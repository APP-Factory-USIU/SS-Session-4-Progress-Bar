# Follow up tasks
These tasks **aren't** necessary but I think they'll a good challenge.

## 1. Dynamic Batch size
Our current `batch+pallelism.bash` file works great, but it could be better.
For now, we have a fixed batch size of 100, but what if there was a way to set this value automatically??

### Hint
* 1. Semi-Dynamic Batch size
Start basic, assign a batch size if the number of files of between a range:

> [!NOTE]
> Below **is not** a functional snippet. It's just there to give you an idea

```text
if `len` >= 100;
  batch_size = 10;
else;
  batch_size = 5;
```

* 2. Fully Dynamic Batch size
Think of how to determine the largest number that can divide the number of files. (**Remember:** Remainder == 0)

Have a look at the `factor` package. It may be of use if you think back to `xargs`
