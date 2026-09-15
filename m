Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B332C491599
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471086; cv=none; b=ifOkZzo+Kl/s8vCi6sz4TphCCPGm1utN/q5+upVX9FKB4ej4JgJoK8wvXtC2cmw0uNND/au8qoc5HgCgNkjeCVUFPa9xR7pTQPK++gfY9WkEnMVh2IoEMixI8buJc9Nplb8KnTWdjpup6mfraL3O2kHyPVpuMFS5xu0NXDXe2n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471086; c=relaxed/simple;
	bh=iJi4C1JJslEGfBsCdIjHmlbU2EkydfNefg0zh5bL9nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kDJ9YTdO9BJXesRkVZLdTKGS0p6+WZLEzqjgjwbstTNDnO2H8fiXIrX0LJeuyQj+HQh015urUP7qPTCeqBEzBswfFKEqJtFgpfhog7Kd4OjQJ1WpeDpSsTIpLd0xvTYta1nw9aknDjbsosAOichDQNoJln3g8JJz03PzXOYriBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bGMdqgt4; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bGMdqgt4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=iJi4C1JJslEGfBsCdIjHmlbU2EkydfNefg0zh5bL9nk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789471082; v=1; x=1790075882;
 b=bGMdqgt4OpXpzZhBIPhBKtbQ9/PIOtujB5vyhjPISRsK/d8KyEf4oo7qTp8i7hEHi1heIP/l
 5f2ZonW5wtpUSTsifvyyE5HJ0D+bb/QOtANUfqyzddlxkMhUfzC9yVsrCjlAxV5Kj5INHi/b6Sq
 GXuL+ZeUgEcGNXCeDeBVj9Ew=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 533a14d847494482;
	Tue, 15 Sep 2026 11:18:02 +0000
X-Mizu-Trace-ID: 533a14d847494482
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so4628e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 04:17:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwvBPopxPmonRGcDheWSrkn8iDujHjc+12hc6katLFleo+029hKULlF5oVzMzBEx4cb0vBcnZ8=@lists.linux.dev
X-Gm-Message-State: AFuF++mTWipoWhM5uOjhuuaGTCTXZV3ek8lv0EyLIXTyhxlT0FGNX52L
	RUZfOE6ydmg8cLds2ZcYHm5+ee7/6jktBNyv5fkDHGCRTMhzvRDDAMuH/94a3o7hizdwZ3LtnUR
	7NA+b8I8Ghs4Jez0wxO4SZ+1xrx6XqLExdps26Xn+
X-Received: by 2002:a05:6512:2251:b0:5b6:bcb:26c4 with SMTP id
 2adb3069b0e04-5b8b2d57c88mr134440e87.16.1789471077790; Tue, 15 Sep 2026
 04:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915091606.2111217-1-vdonnefort@google.com>
In-Reply-To: <20260915091606.2111217-1-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 12:17:21 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz_c5BS3XgFuv61AtwgxD7WWELwuWZ3crd7_7RMvGA2Gw@mail.gmail.com>
X-Gm-Features: AcwNN1W8tXPkaYaAzpBOVgD68ymVthdN91Jk0rdnos-skeuAGBrhz5xWmc71Bek
Message-ID: <CA+EHjTz_c5BS3XgFuv61AtwgxD7WWELwuWZ3crd7_7RMvGA2Gw@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Fix protected VM fault on system with
 pages larger than 4K
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, 15 Sept 2026 at 10:16, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
>
> Just like commit 08f97454b7fa ("KVM: arm64: Fix protected mode handling
> of pages larger than 4kB") fixed the boot of non-protected VMs on system
> larger than 4K pages, align the fault IPA down to the page-size for
> protected VMs.
>
> To paraphrase Marc, pkvm_pgtable_stage2_map() assumes the address passed
> as a parameter is aligned to the size of the intended mapping, while
> HPFAR_EL2 gives the IPA minus the bottom 12 bits, regardless of the
> system page size configuration.
>
> Add a check at the start of pkvm_pgtable_stage2_map() as we do not
> support !PAGE_ALIGNED arguments and ensure callers pass a page-aligned
> IPA.

The fix is correct, and I can reproduce the bug. On a 16K-page host an
unpatched v7.3-rc2 never gets a pVM to a prompt: no guest console
output at all, a core pegged at 100% when I sampled it a minute in,
killed at the 120s timeout. A guest_memfd-backed non-protected VM
times out the same way, while one without guest_memfd boots fine,
which puts the failure on the two paths you fix. With the patch all
three boot clean, and 4K still boots both. That is QEMU with kvmtool
guests; the same three 16K legs also pass on an M4 running pKVM at EL2
on the silicon.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

> Fixes: ea03466e806f ("KVM: arm64: Handle aborts from protected VMs")

A second Fixes: for the gmem_abort() half? a7b57e099592 ("KVM: arm64:
Handle guest_memfd-backed guest page faults") added that call site,
and the ranges differ: ea03466e806f is in v7.1, a7b57e099592 in v6.18.

Should this carry Cc: stable@vger.kernel.org? 08f97454b7fa, the fix
this one follows, did, and 16K-page hosts are a shipping Android
configuration.

> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  arch/arm64/kvm/mmu.c  | 12 +++++++-----
>  arch/arm64/kvm/pkvm.c |  3 +++
>  2 files changed, 10 insertions(+), 5 deletions(-)
>
> Changelog:
>
> v3:
>   - Fix nested case in gmem_abort() (Sashiko)
>
> v2: https://lore.kernel.org/all/20260914075839.4019904-1-vdonnefort@google.com/
>
>   - Use gfn_to_gpa(gfn)
>   - Drop "phys" from the PAGE_ALIGNED check, it isn't a requirement.
>   - Fix gmem_abort() as well (Sashiko)
>
> v1: https://lore.kernel.org/all/20260913173516.3122436-1-vdonnefort@google.com/
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4a..e199dd339583 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1610,6 +1610,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>         bool write_fault, exec_fault;
>         bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
>         enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> +       phys_addr_t ipa = ALIGN_DOWN(s2fd->fault_ipa, PAGE_SIZE);
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>         struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>         unsigned long mmu_seq;

One more in gmem_abort(): the memory fault exit at mmu.c:1647 still
reports the unaligned address, and that one is userspace-visible.

    kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
         write_fault, exec_fault, false);

api.rst defines the range as [gpa, gpa + size), so on a 16K host it
starts mid-page. gfn_to_gpa(gfn) is the one to use: gfn is what
kvm_gmem_get_pfn() failed on, and the L1 IPA in the nested case. x86
passes fault->gfn << PAGE_SHIFT.

> @@ -1672,12 +1673,12 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>                  * PTE, which will be preserved.
>                  */
>                 prot &= ~KVM_NV_GUEST_MAP_SZ;
> -               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, ipa,
>                                                                  prot, flags);
>         } else {
> -               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> -                                                        __pfn_to_phys(pfn), prot,
> -                                                        memcache, flags);
> +               ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, ipa, PAGE_SIZE,
> +                                                        __pfn_to_phys(pfn),
> +                                                        prot, memcache, flags);
>         }
>
>  out_unlock:
> @@ -1710,6 +1711,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>         unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
>         struct kvm_vcpu *vcpu = s2fd->vcpu;
>         struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +       gfn_t gfn = gpa_to_gfn(s2fd->fault_ipa);
>         struct mm_struct *mm = current->mm;
>         struct kvm *kvm = vcpu->kvm;
>         void *hyp_memcache;
> @@ -1756,7 +1758,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>         }
>
>         write_lock(&kvm->mmu_lock);
> -       ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
> +       ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), PAGE_SIZE,
>                                       page_to_phys(page), KVM_PGTABLE_PROT_RWX,
>                                       hyp_memcache, 0);
>         write_unlock(&kvm->mmu_lock);
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8e4c6e4bec12..b7340c430ed6 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>         u64 end = addr + size;
>         int ret;
>
> +       if (!PAGE_ALIGNED(addr | size))
> +               return -EINVAL;
> +

Could this be if (WARN_ON_ONCE(!PAGE_ALIGNED(addr | size)))? The three
checks just below WARN on the same class of caller bug, and this one
runs first, so a bad size now returns -EINVAL with no splat.

With the memory fault exit fixed:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>         lockdep_assert_held_write(&kvm->mmu_lock);
>         mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
> --
> 2.55.0.1032.g73a4cd73de-goog
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
