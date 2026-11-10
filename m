Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794321516;
	b=epgWk66n4ulelrlUQ+jDZnxXgkjyPkfnLhVrhzyHnnmXb/YRfNNK/z4bnCKS3RiOE9ez
	 L3xFExrzv1atgUIpqXpKTcEU62aZP+Jeidt3MT9Fvsa5JiVcEUdN5KvuCEMrhSqj8vk/L
	 h+cpTLljMbaurFLv72bfOlg54jz6kGh+FdkbuATq7KIzaUwUBKddmIeRgDOH/TwPzwG0o
	 y6k0XM/Jop9Lp0szd0qh+Vrne6gjdotiv5XS1fzcFFroapcyAtKNIvfEVtFuXurKdf+S2
	 VnKvLlEpxIv2w5/bIG3S64BlqBGyS5q+sQqLhdU50P2LgYsuKDT/AkHmsnkyfPETevw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794321516;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZFnL1ntqolxL08fuMI08M9PJX/8t5EaSGsOH7b+bnDc=;
	b=HcTZKWDtdZ+vLNN775HB/IJG7rXaOywczxS7j9WrFZUGfiPlWDfE1erCU9KcbxTaGLCn
	 QTYAeuWAOxCRGcAxSkzxkvave0sOPyHpjtUKF+D8LSHMMgmh3+xGqeM/V4hlleJCiMRTD
	 kSyDibB6p6mDLrUnkuqzUWUg+hAC6pmflN3iW7g8ZttnRtau6WPEU9E+vo1wPPHODEccZ
	 LIcgvPkhoVda+tGC5TfOBTXxJ5urJHqSDhbiIZVSWXa2f5XbaTFKujA8d0JqWiE/L8++r
	 yM3j5WKFgV6KsgWdLsYPq3AwKAyHqjCu5X9bfeRBpnI0BoivGRG4NGfr+lEzEuN2IIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AHgLJxmS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60A060A5BD1;
	Tue, 10 Nov 2026 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AHgLJxmS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1F91F008A6;
	Tue, 10 Nov 2026 14:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321515;
	bh=ZFnL1ntqolxL08fuMI08M9PJX/8t5EaSGsOH7b+bnDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AHgLJxmSIK0goX9ZoiHOTLpeYCPeQPCf4Ahk6tNBjy/aiOqDDvtdzeCM5/6GGy5hX
	 GaSDDlHFt8bVNhNAGkajizBEbDYIzwglX0nIc52FqkFxTkZl2HOZdydnCbP/UWd10w
	 E1Cjkrp5G5HoJhXnEw0R5Mqf5EyQeWG7NnBn6sC2nG7NXlA3yl9XkouNjpMZG0Y0hh
	 +cetXM3Ps+2XrHG8WT/7nxuqq0G78CqGjap7Lrg9LYZxUSi5pJEbNkVBWtYxNW/H5u
	 YRx9/T7j6uD21BGIVYTrg1uJoyhTALNQXM9bbI907mtVuDgJfIDqe2TPEeFpTqj9QB
	 VL+HVqsiEhHsA==
Date: Tue, 10 Nov 2026 14:38:27 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, Wei-Lin Chang <weilin.chang@arm.com>, 
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a
 full dirty ring
Message-ID: <avMoubwqgXbpflwM@gremlin>
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
 <20261110110724.3614412-3-fuad.tabba@linux.dev>
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
In-Reply-To: <20261110110724.3614412-3-fuad.tabba@linux.dev>

On Tue, Nov 10, 2026 at 11:07:24AM +0000, Fuad Tabba wrote:
> Pre-fault more populated, dirty-logged pages than the vCPU's dirty ring
> holds, and check that each call stops before the ring overflows, that a
> retry returns ENOSPC without progress, and that the harvested entries
> are the pages in order. A read pre-fault can map a page read-only, or

Are we asserting an invariant that prefaulting happens in address order
here?  Is that explicitly presumed in the prefault API, or just how it
happens to pan out?

I wonder if we might decide for whatever reason in future to do things
differently there. Bit nitty I know, but wonder if it's asserting an
implementation detail?

> access-tracked on x86 without EPT A/D bits, so skip the case if
> pre-faulting dirties nothing.
>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  .../selftests/kvm/pre_fault_memory_test.c     | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> index 3082fe09b95fa..18fc1d69acbf0 100644
> --- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
> +++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
> @@ -5,6 +5,7 @@
>   * Author:
>   * Isaku Yamahata <isaku.yamahata at gmail.com>
>   */
> +#include <asm/barrier.h>
>  #include <linux/sizes.h>
>
>  #include <test_util.h>
> @@ -17,6 +18,8 @@
>  /* Arbitrarily chosen values */
>  #define TEST_BASE_SIZE		SZ_2M
>  #define TEST_SLOT		10
> +/* Large enough for the entries every architecture reserves. */
> +#define TEST_RING_SIZE		SZ_64K
>
>  /* Storage of test info to share with guest code */
>  struct test_config {
> @@ -281,6 +284,87 @@ static void test_pre_fault_memory(unsigned long vm_type, enum vm_mem_backing_src
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
> +	u64 harvested = 0, n, size;
> +	struct kvm_vcpu *vcpu;
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
> +	size = npages * vm->page_size;
> +	gpa = align_down(vm->max_gfn * vm->page_size - size, SZ_2M);
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa, TEST_SLOT, npages,
> +				    KVM_MEM_LOG_DIRTY_PAGES);
> +
> +	/* Populate the pages, so that pre-faulting can map them writable. */

Reviewed below, but I wonder how x86 could then read fault these?

> +	memset(addr_gpa2hva(vm, gpa), 1, size);
> +
> +	range = (struct kvm_pre_fault_memory) { .gpa = gpa, .size = size };
> +	while (range.size) {

NIT: n could be scoped to this block instead.

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

Could this loop forever if cur->flags always == KVM_DIRTY_GFN_F_DIRTY? Or
is that guaranteed not to be the case?

> +			cur = &gfns[fetch % entries];
> +			if (smp_load_acquire(&cur->flags) != KVM_DIRTY_GFN_F_DIRTY)

Is this and the below release paired with equivalent stuff in the dirty ring code?

> +				break;
> +
> +			TEST_ASSERT(cur->slot == TEST_SLOT && cur->offset == harvested + n,
> +				    "Ring entry %u: slot %u offset 0x%llx, expected slot %u offset 0x%lx",
> +				    fetch, cur->slot, cur->offset, TEST_SLOT, harvested + n);
> +			smp_store_release(&cur->flags, KVM_DIRTY_GFN_F_RESET);
> +			fetch++;
> +		}
> +
> +		/* A read pre-fault can map a page read-only, or access-tracked on x86. */

Hmm under what circumstances would that happen? Is there no way to ensure pages
are dirtied by prefaulting? I imagine not though!

> +		if (!n && !harvested && !range.size) {

Hmm, so !n && (harvested || range_size) will pass this, but then you assert
n immediately below, so it seems like n is an unconditional requirement.

So I wonder whether this should just be !n in this conditional or maybe the
assert afterwards should be dropped?

> +			pr_info("Skipping the dirty ring test: pre-faulting dirtied no pages\n");
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
> +	kvm_vm_free(vm);
> +}
> +
>  static void help(char *name)
>  {
>  	puts("");
> @@ -320,5 +404,6 @@ int main(int argc, char *argv[])
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
