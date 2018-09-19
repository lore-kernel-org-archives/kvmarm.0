From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 00/13] kvm: selftests: add aarch64 framework and dirty
Date: Wed, 19 Sep 2018 14:13:48 +0100
Message-ID: <f48129c0-4eb4-9803-a999-574f85acfab0@arm.com>
References: <20180918175436.19742-1-drjones@redhat.com>
 <20180919123738.yp6bncgwlpzhob2u@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5144A1FE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Sep 2018 09:12:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cl3czs5QXM3k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Sep 2018 09:12:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 659DC49F8B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Sep 2018 09:12:52 -0400 (EDT)
In-Reply-To: <20180919123738.yp6bncgwlpzhob2u@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On 09/19/2018 01:37 PM, Andrew Jones wrote:
> On Tue, Sep 18, 2018 at 07:54:23PM +0200, Andrew Jones wrote:
>> This series provides KVM selftests that test dirty log tracking on
>> AArch64 for both 4K and 64K guest page sizes. Additionally the
>> framework provides an easy way to test dirty log tracking with the
>> recently posted dynamic IPA and 52bit IPA series[1].
>>
>> The series breaks down into parts as follows:
>>
>>   01-02: generalize guest code to host userspace exit support by
>>          introducing "ucalls" - hypercalls to userspace
>>   03-05: prepare common code for a new architecture
>>   06-07: add virtual memory setup support for AArch64
>>      08: add vcpu setup support for AArch64
>>      09: port the dirty log test to AArch64
>>   10-11: add 64K guest page size support for the dirty log test
>>   12-13: prepare the dirty log test to also test > 40-bit guest
>>          physical address setups by allowing the test memory
>>          region to be placed at the top of physical memory
>>
>> [1] https://www.spinics.net/lists/arm-kernel/msg676819.html
>>
> 
> Hi Suzuki,
> 
> Here's an [untested] add-on patch that should provide the means to
> test dirty logging with a 52-bit guest physical address space.
> Hopefully it'll be as easy as compiling and then running with
> 
>   $ ./dirty_log_test -t

I will give this series a spin with 52 IPA and let you know.

Thanks
Suzuki

> 
> Thanks,
> drew
> 
>  From 09ea1d724551a95ef9962d357049ef21ea8c77e8 Mon Sep 17 00:00:00 2001
> From: Andrew Jones <drjones@redhat.com>
> Date: Wed, 19 Sep 2018 14:23:30 +0200
> Subject: [PATCH] kvm: selftests: aarch64: dirty_log_test: test with 52 PA-bits
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   tools/testing/selftests/kvm/dirty_log_test.c  | 24 ++++++++++++++++---
>   .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 17 +++++++++----
>   .../selftests/kvm/lib/kvm_util_internal.h     |  1 +
>   4 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index d59820cc2d39..c11c76e09766 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -82,6 +82,7 @@ static void guest_code(void)
>   static bool host_quit;
>   
>   /* Points to the test VM memory region on which we track dirty logs */
> +static uint8_t host_ipa_limit;
>   static void *host_test_mem;
>   static uint64_t host_num_pages;
>   
> @@ -209,12 +210,14 @@ static void vm_dirty_log_verify(unsigned long *bmap)
>   }
>   
>   static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
> -				uint64_t extra_mem_pages, void *guest_code)
> +				uint64_t extra_mem_pages, void *guest_code,
> +				unsigned long type)
>   {
>   	struct kvm_vm *vm;
>   	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
>   
> -	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
> +	vm = _vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages,
> +			O_RDWR, type);
>   	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
>   #ifdef __x86_64__
>   	vm_create_irqchip(vm);
> @@ -231,15 +234,22 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>   	struct kvm_vm *vm;
>   	uint64_t max_gfn;
>   	unsigned long *bmap;
> +	unsigned long type = 0;
>   
>   	switch (mode) {
>   	case VM_MODE_P52V48_4K:
>   		guest_pa_bits = 52;
>   		guest_page_shift = 12;
> +#ifdef __aarch64__
> +		type = KVM_VM_TYPE_ARM_IPA_SIZE(52);
> +#endif
>   		break;
>   	case VM_MODE_P52V48_64K:
>   		guest_pa_bits = 52;
>   		guest_page_shift = 16;
> +#ifdef __aarch64__
> +		type = KVM_VM_TYPE_ARM_IPA_SIZE(52);
> +#endif
>   		break;
>   	case VM_MODE_P40V48_4K:
>   		guest_pa_bits = 40;
> @@ -273,7 +283,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>   	bmap = bitmap_alloc(host_num_pages);
>   	host_bmap_track = bitmap_alloc(host_num_pages);
>   
> -	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code);
> +	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code, type);
>   
>   	/* Add an extra memory slot for testing dirty logging */
>   	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> @@ -392,6 +402,14 @@ int main(int argc, char *argv[])
>   	unsigned int mode;
>   	int opt, i;
>   
> +#ifdef __aarch64__
> +	host_ipa_limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +	if (host_ipa_limit == 52) {
> +		vm_guest_modes[VM_MODE_P52V48_4K].supported = 1;
> +		vm_guest_modes[VM_MODE_P52V48_64K].supported = 1;
> +	}
> +#endif
> +
>   	while ((opt = getopt(argc, argv, "hi:I:o:tm:")) != -1) {
>   		switch (opt) {
>   		case 'i':
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index d76431322a30..5202fce337e3 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -53,6 +53,8 @@ enum vm_mem_backing_src_type {
>   int kvm_check_cap(long cap);
>   
>   struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
> +struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
> +			  int perm, unsigned long type);
>   void kvm_vm_free(struct kvm_vm *vmp);
>   void kvm_vm_restart(struct kvm_vm *vmp, int perm);
>   void kvm_vm_release(struct kvm_vm *vmp);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 542336db7b4f..e1805c9e0f39 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -62,13 +62,13 @@ int kvm_check_cap(long cap)
>   	return ret;
>   }
>   
> -static void vm_open(struct kvm_vm *vm, int perm)
> +static void vm_open(struct kvm_vm *vm, int perm, unsigned long type)
>   {
>   	vm->kvm_fd = open(KVM_DEV_PATH, perm);
>   	if (vm->kvm_fd < 0)
>   		exit(KSFT_SKIP);
>   
> -	vm->fd = ioctl(vm->kvm_fd, KVM_CREATE_VM, NULL);
> +	vm->fd = ioctl(vm->kvm_fd, KVM_CREATE_VM, type);
>   	TEST_ASSERT(vm->fd >= 0, "KVM_CREATE_VM ioctl failed, "
>   		"rc: %i errno: %i", vm->fd, errno);
>   }
> @@ -101,7 +101,8 @@ _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
>    * descriptor to control the created VM is created with the permissions
>    * given by perm (e.g. O_RDWR).
>    */
> -struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
> +struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
> +			  int perm, unsigned long type)
>   {
>   	struct kvm_vm *vm;
>   	int kvm_fd;
> @@ -110,7 +111,8 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>   	TEST_ASSERT(vm != NULL, "Insufficent Memory");
>   
>   	vm->mode = mode;
> -	vm_open(vm, perm);
> +	vm->type = type;
> +	vm_open(vm, perm, type);
>   
>   	/* Setup mode specific traits. */
>   	switch (vm->mode) {
> @@ -166,6 +168,11 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>   	return vm;
>   }
>   
> +struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
> +{
> +	return _vm_create(mode, phy_pages, perm, 0);
> +}
> +
>   /*
>    * VM Restart
>    *
> @@ -183,7 +190,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
>   {
>   	struct userspace_mem_region *region;
>   
> -	vm_open(vmp, perm);
> +	vm_open(vmp, perm, vmp->type);
>   	if (vmp->has_irqchip)
>   		vm_create_irqchip(vmp);
>   
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> index 5e05fb98dc62..51a56102a5c9 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> +++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> @@ -44,6 +44,7 @@ struct vcpu {
>   
>   struct kvm_vm {
>   	int mode;
> +	unsigned long type;
>   	int kvm_fd;
>   	int fd;
>   	unsigned int pgtable_levels;
> 
