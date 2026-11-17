Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926174;
	b=hhMO3YBpGqMLuwjvcxd+N0BARNKAUrG0nSNbo9mBGsfJ1IEKkoCMM5W+nsMD4RDQ87pt
	 wq+bVVd/Ki9TotbWotc+W6a5biGywbe38J0JyC8XhOpkbvmHxCmhtlqJ8punySx3n1oXy
	 CiKF4T9y7t8u3kFJ1ipgHUdeeqliXHVd5BxbMA2iOFit0UzclxXpmzOtU9TdSmATITQqi
	 XBHQWBYCzK0IhdNGAGcbBy8oHGDQRFQv9rLumaRiHXWqT5TL/A6G7ZEXMXzTH+b5FzlO3
	 3DmCQfqCpd1WOSfnmf4G+UiPvr6XymuR1rq/dZSlJHTN7cAIm+C/v+DA9Mq8UvO+eQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926174;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=O6LryH0j9aDeGupJj+GdTTB2fTZI04rn2KNQvmULex8=;
	b=LCHGtQIVwaoXpfP45FWDX77E06+jxE9pvRaoUBmBt6F12Qa1Z6agWdVpWfbkP/7bjVy3
	 isfcm0tyqCTurg8g6fkfy8ZnyqeuSPhJSl9KnfT6gpslUWBB1c469PaFeKbuxP7kUiaTg
	 /taf82hNlmqPDfpejNw34DcVnxl8Rbl1gASpPMfRUpPQgBncTnihq/76cO5/qbrySZ9N7
	 CgXNoTrVOTerz0bvXIT82KnWyEeobPlKFrD7IESWNOhykTO/fRE6+UHrgzNYUMDiJhXuk
	 Oml2mTmvxdqTWbOdeomFEwutA1EnHku6rMzhuekz1btVjN7pYAPTWYkLWrzCTUiXLyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K9/Ggob+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA40B606A32C;
	Tue, 17 Nov 2026 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K9/Ggob+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E49A1F000C5;
	Tue, 17 Nov 2026 14:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794926174;
	bh=O6LryH0j9aDeGupJj+GdTTB2fTZI04rn2KNQvmULex8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K9/Ggob+DsJGpbqSo81P1bFwyl19xmgdBBPix/sbGDwvXJ+/8YJHR40GuiB7nEVEs
	 oLTpE2VDjS6KcxyTx0XEjxjdwnOKW7N3dsGpN3mOlseYmb87N2j99JA+u7zwptY3Wn
	 EvKKF/2K2rUaEVX4MDoPywRr4QbY1+GoQXVXxLQXvoU6wxYm1y+VCgAFAt7u9E0I/b
	 kZcO7cnGcVqR2ciWO7FLWOaSOT2rpvHUgCANr5g25cWtYGOfrz37xdpOU1fWo8LBA9
	 JLDBKiDqFqAkYpjoecpsA+BeMizxztslcOaafULIej8fwu95w1vBp0mZOKLl/ljd9c
	 Hq7arpYqWXpgw==
Date: Tue, 17 Nov 2026 14:36:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against
 a full dirty ring
Message-ID: <avxj4cTtgy6gOLyC@gremlin>
References: <20261117074428.7544-1-fuad.tabba@linux.dev>
 <20261117074428.7544-3-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117074428.7544-3-fuad.tabba@linux.dev>

On Tue, Nov 17, 2026 at 07:44:28AM +0000, Fuad Tabba wrote:
> Pre-fault more populated, dirty-logged pages than the vCPU's dirty ring
> holds, and check that each call stops before the ring overflows, that a
> retry returns ENOSPC without progress, and that each page is reported
> exactly once. A read pre-fault can map a page read-only, or
> access-tracked on x86 without EPT A/D bits, so skip the case if
> pre-faulting doesn't dirty any page.
>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

LGTM!

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  .../selftests/kvm/pre_fault_memory_test.c     | 101 ++++++++++++++++++
>  1 file changed, 101 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> index 3082fe09b95fa..72c501afc873b 100644
> --- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
> +++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> @@ -5,6 +5,9 @@
>   * Author:
>   * Isaku Yamahata <isaku.yamahata at gmail.com>
>   */
> +#include <asm/barrier.h>
> +#include <linux/bitmap.h>
> +#include <linux/bitops.h>
>  #include <linux/sizes.h>
>
>  #include <test_util.h>
> @@ -17,6 +20,8 @@
>  /* Arbitrarily chosen values */
>  #define TEST_BASE_SIZE		SZ_2M
>  #define TEST_SLOT		10
> +/* Large enough for the entries every architecture reserves. */
> +#define TEST_RING_SIZE		SZ_64K
>
>  /* Storage of test info to share with guest code */
>  struct test_config {
> @@ -281,6 +286,101 @@ static void test_pre_fault_memory(unsigned long vm_type, enum vm_mem_backing_src
>  	for_each_guest_mode(__test_pre_fault_memory, &p);
>  }
>
> +/*
> + * Pre-fault more dirty-logged pages than the ring holds: each call has to stop
> + * before the ring overflows, and no entry may be lost.
> + */
> +static void test_pre_fault_dirty_ring(void)
> +{
> +	const u64 entries = TEST_RING_SIZE / sizeof(struct kvm_dirty_gfn);
> +	const u64 npages = entries + entries / 4;
> +	struct kvm_pre_fault_memory range, left;
> +	struct kvm_dirty_gfn *gfns, *cur;
> +	u64 harvested = 0, size;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long *seen;
> +	int ret, stops = 0;
> +	struct kvm_vm *vm;
> +	u32 fetch = 0;
> +	gpa_t gpa;
> +
> +	if (!kvm_has_cap(KVM_CAP_DIRTY_LOG_RING) && !kvm_has_cap(KVM_CAP_DIRTY_LOG_RING_ACQ_REL)) {
> +		pr_info("Skipping the dirty ring test: no dirty ring\n");
> +		return;
> +	}
> +
> +	vm = vm_create(1);
> +	vm_enable_dirty_ring(vm, TEST_RING_SIZE);
> +	vcpu = vm_vcpu_add(vm, 0, NULL);
> +	gfns = vcpu_map_dirty_ring(vcpu);
> +
> +	/* A ring entry is a host page. */
> +	size = npages * getpagesize();
> +	gpa = align_down(vm->max_gfn * vm->page_size - size, SZ_2M);
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa, TEST_SLOT,
> +				    vm_num_guest_pages(vm->mode, npages), KVM_MEM_LOG_DIRTY_PAGES);
> +
> +	/* Populate the pages, so that pre-faulting can map them writable. */
> +	memset(addr_gpa2hva(vm, gpa), 1, size);
> +
> +	seen = bitmap_zalloc(npages);
> +	TEST_ASSERT(seen, "Failed to allocate the bitmap of reported pages");
> +
> +	range = (struct kvm_pre_fault_memory) { .gpa = gpa, .size = size };
> +	while (range.size) {
> +		u64 n;
> +
> +		vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
> +
> +		if (range.size) {
> +			left = range;
> +			ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
> +			TEST_ASSERT_VM_VCPU_IOCTL(ret == -1 && errno == ENOSPC,
> +						  KVM_PRE_FAULT_MEMORY, ret, vm);
> +			TEST_ASSERT(range.gpa == left.gpa && range.size == left.size,
> +				    "KVM_PRE_FAULT_MEMORY made progress on a full ring");
> +			stops++;
> +		}
> +
> +		for (n = 0; ; n++) {
> +			cur = &gfns[fetch % entries];
> +			/* Pairs with the smp_wmb() in kvm_dirty_ring_push(). */
> +			if (smp_load_acquire(&cur->flags) != KVM_DIRTY_GFN_F_DIRTY)
> +				break;
> +
> +			TEST_ASSERT(cur->slot == TEST_SLOT && cur->offset < npages,
> +				    "Ring entry %u: slot %u offset 0x%llx, expected slot %u offset < 0x%lx",
> +				    fetch, cur->slot, cur->offset, TEST_SLOT, npages);
> +			TEST_ASSERT(!__test_and_set_bit(cur->offset, seen),
> +				    "Ring entry %u: offset 0x%llx reported twice",
> +				    fetch, cur->offset);
> +			/* Pairs with kvm_dirty_gfn_harvested()'s smp_load_acquire(). */
> +			smp_store_release(&cur->flags, KVM_DIRTY_GFN_F_RESET);
> +			fetch++;
> +		}
> +
> +		/* A read pre-fault can map a page read-only, or access-tracked on x86. */
> +		if (!n && !harvested && !range.size) {
> +			pr_info("Skipping the dirty ring test: pre-faulting dirtied no pages\n");
> +			bitmap_free(seen);
> +			kvm_vm_free(vm);
> +			return;
> +		}
> +		TEST_ASSERT(n, "KVM_PRE_FAULT_MEMORY pushed nothing to the ring");
> +		TEST_ASSERT(kvm_vm_reset_dirty_ring(vm) == n,
> +			    "KVM_RESET_DIRTY_RINGS didn't reset %lu entries", n);
> +		harvested += n;
> +	}
> +
> +	TEST_ASSERT(harvested == npages, "%lu ring entries for %lu pages", harvested, npages);
> +	TEST_ASSERT(stops, "KVM_PRE_FAULT_MEMORY never stopped for a %lu-entry ring", entries);
> +	pr_info("Pre-faulted %lu pages through a %lu-entry ring, stopping %d times\n",
> +		npages, entries, stops);
> +
> +	bitmap_free(seen);
> +	kvm_vm_free(vm);
> +}
> +
>  static void help(char *name)
>  {
>  	puts("");
> @@ -320,5 +420,6 @@ int main(int argc, char *argv[])
>  	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, backing, false);
>  	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, backing, true);
>  #endif
> +	test_pre_fault_dirty_ring();
>  	return 0;
>  }
> --
> 2.47.3
>

--
Cheers, Lorenzo
