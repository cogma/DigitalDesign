#include <stdio.h>

typedef struct lnode {
    int name;
    int value;
} Heap;

int heap_last=0;

void swap(Heap a[], int i, int j)
{
	Heap temp;
    temp.name = a[i].name;
    temp.value = a[i].value;
	a[i].name = a[j].name;
    a[i].value = a[j].value;
	a[j].name = temp.name;
    a[j].value = temp.value;
}

void insert(Heap heap[], int object, int name)
{
	int i;

	heap[heap_last].value = object;
    heap[heap_last].name = name;

	i = heap_last;
	while (i > 0 && heap[(i - 1) / 2].value < heap[i].value) {
		swap(heap, i, (i - 1) / 2);
		i = (i - 1) / 2;
	}
}

Heap deletemax(Heap heap[])
{
	int i = 0;
	Heap object;

	object.value = heap[0].value;
    object.name = heap[0].name;

	heap[0].name = heap[heap_last].name;
    heap[0].value = heap[heap_last].value;
	heap[heap_last].value = 0 ;

	while (i < heap_last / 2 && (heap[i].value < heap[2 * i + 1].value || heap[i].value < heap[2 * i + 2].value)) {
		if (heap[i].value < heap[2 * i + 1].value) {
			if (heap[2 * i + 2].value <= heap[2 * i + 1].value) {
				swap(heap, i, 2 * i + 1);
				i = 2 * i + 1;
			}
			else {
				swap(heap, i, 2 * i + 2);
				i = 2 * i + 2;
			}
		}
		else if (heap[i].value < heap[2 * i + 2].value) {
			swap(heap, i, 2 * i + 2);
			i = 2 * i + 2;
		}
	}

    return object;
}

int main(void)
{
    int i;
    int data;
    int data2;
    int count=0;
    Heap heap[256];
    Heap object;

    for(data=1; data<256; data++){
        count=0;
        data2=data;
        while(data2>1){
            if(data2%2==0){
                data2=data2/2;
            }

            else{
                data2=3*data2+1;
            }
            count++;
        }
        insert(heap, count, data);
        heap_last++;
    }

	insert(heap, 0, 0);

	heap_last--;

	for (i = 0; i < 16; i++) {
        object=deletemax(heap);
		heap_last--;
        printf("%3d : %d times\n", object.name, object.value);
	}

    return 0;
}