Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25C1C00A89
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 10:11:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 270272087D
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 10:11:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nLHWQQ3e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 270272087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D44A4B78E;
	Thu,  5 Nov 2020 05:11:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ISgoUfOvR9sm; Thu,  5 Nov 2020 05:11:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6874B4B76B;
	Thu,  5 Nov 2020 05:11:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C0FA4B750
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 05:11:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HusqMEqElRxq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 05:11:07 -0500 (EST)
Received: from mail-io1-f67.google.com (mail-io1-f67.google.com
 [209.85.166.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09CA14B73E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 05:11:07 -0500 (EST)
Received: by mail-io1-f67.google.com with SMTP id s10so1236461ioe.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Nov 2020 02:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=fmtzIz3uInIJsTqP7McA6pPsVlB9nCK+V3BmIXK0eBc=;
 b=nLHWQQ3eDG8C8OPwpPkRkLy1DaXtZfgjf9Gap7DNjIRv9xrDjMBjOrp5i8lSTw/EdS
 CGj5R9Ot12pry8N9A9H0+crzZtAg05FqgzXzdRfiloWc+OlRct0+52n9yM/DEGvmFxBg
 l85YWraGKuhAn3lbnXDe3Wh67SdlYG1g+EliiCmoa3XkerDCq35XNmlXbf+VfdLr75db
 LaF59TXwf0hFpc3f7IYxxHhQ3G6vQspderAM+gCKojrv/MywLf7zafxlvPKxJbVQ3qDi
 z4tldgYc4IbUhyjh+kUacZMTKU+ui5IfoV8lCkwj3b7v8LJNFxL3pZ+QGheuGlRULXkL
 bhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=fmtzIz3uInIJsTqP7McA6pPsVlB9nCK+V3BmIXK0eBc=;
 b=tY4CxrcvX73k9jef0W4isbbUbBofE2yv0RzdDxui0a9UFzsGSLzZub8t48UX0dVyuX
 5pwvV2NH9o1HZDl0Ris/P1wOccUoiaPxvnOP76DLFIHlCZKcC4zJ/FRvQ3avpdXoUGVm
 sn+wV5hbXPLgIasfAFg+F/xm2xnPs6elpfm47m2ljgU7kQ0ny0Z2f6i9CsLX3zio4JKj
 tmuoybLFTvkl63MLim21dt1B8t5AyIAkWvysOzBLUvXLKut4ByraGnmJvLJX70HWIKsr
 ymb1QhdIBRqDnO8etrRd/gCCeV4fAcFSQOyZbK4IRXUJXWAHiuXIDNK7Fn0maVes7lTE
 bKNw==
X-Gm-Message-State: AOAM531oVI7gGQ32chp8uaWUiLkWwzm3PfjVjoqbH92Ngb34sD2BRopR
 ggXAcKfkGGxVK4m7a+PnZ/hCuTdNcdJU9ZItRFiu
X-Google-Smtp-Source: ABdhPJyV9XuNa8AE6Bg6qAjBPUlOYd7lC2FZHAnpUZ46sEwhQuXOC7FWFZAm+5QVq4cf8BP5J5AHH13oOZ5O5pI6qY4=
X-Received: by 2002:a02:cf0b:: with SMTP id q11mr1400312jar.125.1604571066162; 
 Thu, 05 Nov 2020 02:11:06 -0800 (PST)
MIME-Version: 1.0
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-11-alexandru.elisei@arm.com>
In-Reply-To: <20201027172705.15181-11-alexandru.elisei@arm.com>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Thu, 5 Nov 2020 18:10:54 +0800
Message-ID: <CAJc+Z1HJq_j2wVXBM=0BY7p_A7=1sR+Gdf+edEQ5wZkT6-arfQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 10/16] KVM: arm64: Add a new VM device control
 group for SPE
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 28 Oct 2020 at 01:26, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Stage 2 faults triggered by the profiling buffer attempting to write to
> memory are reported by the SPE hardware by asserting a buffer management
> event interrupt. Interrupts are by their nature asynchronous, which means
> that the guest might have changed its stage 1 translation tables since the
> attempted write. SPE reports the guest virtual address that caused the data
> abort, but not the IPA, which means that KVM would have to walk the guest's
> stage 1 tables to find the IPA; using the AT instruction to walk the
> guest's tables in hardware is not an option because it doesn't report the
> IPA in the case of a stage 2 fault on a stage 1 table walk.
>
> Fix both problems by pre-mapping the guest's memory at stage 2 with write
> permissions to avoid any faults. Userspace calls mlock() on the VMAs that
> back the guest's memory, pinning the pages in memory, then tells KVM to map
> the memory at stage 2 by using the VM control group KVM_ARM_VM_SPE_CTRL
> with the attribute KVM_ARM_VM_SPE_FINALIZE. KVM will map all writable VMAs
> which have the VM_LOCKED flag set. Hugetlb VMAs are practically pinned in
> memory after they are faulted in and mlock() doesn't set the VM_LOCKED
> flag, and just faults the pages in; KVM will treat hugetlb VMAs like they
> have the VM_LOCKED flag and will also map them, faulting them in if
> necessary, when handling the ioctl.
>
> VM live migration relies on a bitmap of dirty pages. This bitmap is created
> by write-protecting a memslot and updating it as KVM handles stage 2 write
> faults. Because KVM cannot handle stage 2 faults reported by the profiling
> buffer, it will not pre-map a logging memslot. This effectively means that
> profiling is not available when the VM is configured for live migration.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Documentation/virt/kvm/devices/vm.rst |  28 +++++
>  arch/arm64/include/asm/kvm_host.h     |   5 +
>  arch/arm64/include/asm/kvm_mmu.h      |   2 +
>  arch/arm64/include/uapi/asm/kvm.h     |   3 +
>  arch/arm64/kvm/arm.c                  |  78 +++++++++++-
>  arch/arm64/kvm/guest.c                |  48 ++++++++
>  arch/arm64/kvm/mmu.c                  | 169 ++++++++++++++++++++++++++
>  arch/arm64/kvm/spe.c                  |  81 ++++++++++++
>  include/kvm/arm_spe.h                 |  36 ++++++
>  9 files changed, 448 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
> index 0aa5b1cfd700..b70798a72d8a 100644
> --- a/Documentation/virt/kvm/devices/vm.rst
> +++ b/Documentation/virt/kvm/devices/vm.rst
> @@ -314,3 +314,31 @@ Allows userspace to query the status of migration mode.
>              if it is enabled
>  :Returns:   -EFAULT if the given address is not accessible from kernel space;
>             0 in case of success.
> +
> +6. GROUP: KVM_ARM_VM_SPE_CTRL
> +===============================
> +
> +:Architectures: arm64
> +
> +6.1. ATTRIBUTE: KVM_ARM_VM_SPE_FINALIZE
> +-----------------------------------------
> +
> +Finalizes the creation of the SPE feature by mapping the guest memory in the
> +stage 2 table. Guest memory must be readable, writable and pinned in RAM, which
> +is achieved with an mlock() system call; the memory can be backed by a hugetlbfs
> +file. Memory regions from read-only or dirty page logging enabled memslots will
> +be ignored. After the call, no changes to the guest memory, including to its
> +contents, are permitted.
> +
> +Subsequent KVM_ARM_VCPU_INIT calls will cause the memory to become unmapped and
> +the feature must be finalized again before any VCPU can run.
> +
> +If any VCPUs are run before finalizing the feature, KVM_RUN will return -EPERM.
> +
> +:Parameters: none
> +:Returns:   -EAGAIN if guest memory has been modified while the call was
> +            executing
> +            -EBUSY if the feature is already initialized
> +            -EFAULT if an address backing the guest memory is invalid
> +            -ENXIO if SPE is not supported or not properly configured
> +            0 in case of success
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5b68c06930c6..27f581750c6e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -92,6 +92,7 @@ struct kvm_s2_mmu {
>
>  struct kvm_arch {
>         struct kvm_s2_mmu mmu;
> +       struct kvm_spe spe;
>
>         /* VTCR_EL2 value for this VM */
>         u64    vtcr;
> @@ -612,6 +613,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> +int kvm_arm_vm_arch_set_attr(struct kvm *kvm, struct kvm_device_attr *attr);
> +int kvm_arm_vm_arch_get_attr(struct kvm *kvm, struct kvm_device_attr *attr);
> +int kvm_arm_vm_arch_has_attr(struct kvm *kvm, struct kvm_device_attr *attr);
> +
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>                                struct kvm_device_attr *attr);
>  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 331394306cce..bad94662bbed 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -124,6 +124,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>                           phys_addr_t pa, unsigned long size, bool writable);
> +int kvm_map_locked_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
> +                          enum kvm_pgtable_prot prot);
>
>  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index ca57dfb7abf0..8876e564ba56 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -350,6 +350,9 @@ struct kvm_vcpu_events {
>  #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES 3
>  #define   KVM_DEV_ARM_ITS_CTRL_RESET           4
>
> +#define KVM_ARM_VM_SPE_CTRL            0
> +#define   KVM_ARM_VM_SPE_FINALIZE      0
> +
>  /* Device Control API on vcpu fd */
>  #define KVM_ARM_VCPU_PMU_V3_CTRL       0
>  #define   KVM_ARM_VCPU_PMU_V3_IRQ      0
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e51d8f328c7e..2d98248f2c66 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -41,6 +41,7 @@
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_psci.h>
> +#include <kvm/arm_spe.h>
>
>  #ifdef REQUIRES_VIRT
>  __asm__(".arch_extension       virt");
> @@ -653,6 +654,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>         if (unlikely(!kvm_vcpu_initialized(vcpu)))
>                 return -ENOEXEC;
>
> +       if (vcpu_has_spe(vcpu) && unlikely(!kvm_arm_spe_finalized(vcpu->kvm)))
> +               return -EPERM;
> +
>         ret = kvm_vcpu_first_run_init(vcpu);
>         if (ret)
>                 return ret;
> @@ -982,12 +986,22 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>          * ensuring that the data side is always coherent. We still
>          * need to invalidate the I-cache though, as FWB does *not*
>          * imply CTR_EL0.DIC.
> +        *
> +        * If the guest has SPE, we need to unmap the entire address space to
> +        * allow for any changes to the VM memory made by userspace to propagate
> +        * to the stage 2 tables when SPE is re-finalized; this also makes sure
> +        * we keep the userspace and the guest's view of the memory contents
> +        * synchronized.
>          */
>         if (vcpu->arch.has_run_once) {
> -               if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> +               if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) ||
> +                   vcpu_has_spe(vcpu)) {
>                         stage2_unmap_vm(vcpu->kvm);
> -               else
> +                       if (vcpu_has_spe(vcpu))
> +                               kvm_arm_spe_notify_vcpu_init(vcpu);
> +               } else {
>                         __flush_icache_all();
> +               }
>         }
>
>         vcpu_reset_hcr(vcpu);
> @@ -1045,6 +1059,45 @@ static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
>         return ret;
>  }
>
> +static int kvm_arm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       int ret = -ENXIO;
> +
> +       switch (attr->group) {
> +       default:
> +               ret = kvm_arm_vm_arch_set_attr(kvm, attr);
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +static int kvm_arm_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       int ret = -ENXIO;
> +
> +       switch (attr->group) {
> +       default:
> +               ret = kvm_arm_vm_arch_get_attr(kvm, attr);
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +static int kvm_arm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       int ret = -ENXIO;
> +
> +       switch (attr->group) {
> +       default:
> +               ret = kvm_arm_vm_arch_has_attr(kvm, attr);
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
>  static int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
>                                    struct kvm_vcpu_events *events)
>  {
> @@ -1259,6 +1312,27 @@ long kvm_arch_vm_ioctl(struct file *filp,
>
>                 return 0;
>         }
> +       case KVM_SET_DEVICE_ATTR: {
> +               struct kvm_device_attr attr;
> +
> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> +                       return -EFAULT;
> +               return kvm_arm_vm_set_attr(kvm, &attr);
> +       }
> +       case KVM_GET_DEVICE_ATTR: {
> +               struct kvm_device_attr attr;
> +
> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> +                       return -EFAULT;
> +               return kvm_arm_vm_get_attr(kvm, &attr);
> +       }
> +       case KVM_HAS_DEVICE_ATTR: {
> +               struct kvm_device_attr attr;
> +
> +               if (copy_from_user(&attr, argp, sizeof(attr)))
> +                       return -EFAULT;
> +               return kvm_arm_vm_has_attr(kvm, &attr);
> +       }
>         default:
>                 return -EINVAL;
>         }
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 2ba790eeb782..d0dc4bdb8b4a 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -988,3 +988,51 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>
>         return ret;
>  }
> +
> +int kvm_arm_vm_arch_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       int ret;
> +
> +       switch (attr->group) {
> +       case KVM_ARM_VM_SPE_CTRL:
> +               ret = kvm_arm_vm_spe_set_attr(kvm, attr);
> +               break;
> +       default:
> +               ret = -ENXIO;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +int kvm_arm_vm_arch_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       int ret;
> +
> +       switch (attr->group) {
> +       case KVM_ARM_VM_SPE_CTRL:
> +               ret = kvm_arm_vm_spe_get_attr(kvm, attr);
> +               break;
> +       default:
> +               ret = -ENXIO;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +int kvm_arm_vm_arch_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       int ret;
> +
> +       switch (attr->group) {
> +       case KVM_ARM_VM_SPE_CTRL:
> +               ret = kvm_arm_vm_spe_has_attr(kvm, attr);
> +               break;
> +       default:
> +               ret = -ENXIO;
> +               break;
> +       }
> +
> +       return ret;
> +}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c3c43555490d..31b2216a5881 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1365,6 +1365,175 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>         return ret;
>  }
>
> +static int stage2_map_vma(struct kvm *kvm,
> +                         struct kvm_memory_slot *memslot,
> +                         struct vm_area_struct *vma,
> +                         enum kvm_pgtable_prot prot,
> +                         unsigned long mmu_seq, hva_t *hvap,
> +                         struct kvm_mmu_memory_cache *cache)
> +{
> +       struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> +       unsigned long stage2_pagesize, remaining;
> +       bool force_pte, writable;
> +       hva_t hva, hva_end;
> +       kvm_pfn_t pfn;
> +       gpa_t gpa;
> +       gfn_t gfn;
> +       int ret;
> +
> +       hva = max(memslot->userspace_addr, vma->vm_start);
> +       hva_end = min(vma->vm_end, memslot->userspace_addr +
> +                       (memslot->npages << PAGE_SHIFT));
> +
> +       gpa = (memslot->base_gfn << PAGE_SHIFT) + hva - memslot->userspace_addr;
> +       gfn = gpa >> PAGE_SHIFT;
> +
> +       stage2_pagesize = 1UL << stage2_max_pageshift(memslot, vma, hva, &force_pte);
> +
> +       while (hva < hva_end) {
> +               ret = kvm_mmu_topup_memory_cache(cache,
> +                                                kvm_mmu_cache_min_pages(kvm));
> +               if (ret)
> +                       return ret;
> +
> +               /*
> +                * We start mapping with the highest possible page size, so the
> +                * gpa and gfn will always be properly aligned to the current
> +                * page size.
> +                */
> +               pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL, true, &writable);
> +               if (pfn == KVM_PFN_ERR_HWPOISON)
> +                       return -EFAULT;
> +               if (is_error_noslot_pfn(pfn))
> +                       return -EFAULT;
> +               /* Can only happen if naughty userspace changed the VMA. */
> +               if (kvm_is_device_pfn(pfn) || !writable)
> +                       return -EAGAIN;
> +
> +               spin_lock(&kvm->mmu_lock);
> +               if (mmu_notifier_retry(kvm, mmu_seq)) {
> +                       spin_unlock(&kvm->mmu_lock);
> +                       return -EAGAIN;
> +               }
> +
> +               remaining = hva_end - hva;
> +               if (stage2_pagesize == PUD_SIZE && remaining < PUD_SIZE)
> +                       stage2_pagesize = PMD_SIZE;
> +               if (stage2_pagesize == PMD_SIZE && remaining < PMD_SIZE) {
> +                       force_pte = true;
> +                       stage2_pagesize = PAGE_SIZE;
> +               }
> +
> +               if (!force_pte && stage2_pagesize == PAGE_SIZE)
> +                       /*
> +                        * The hva and gpa will always be PMD aligned if
> +                        * hva is backed by a transparent huge page. gpa will
> +                        * not be modified and it's not necessary to recompute
> +                        * hva.
> +                        */
> +                       stage2_pagesize = transparent_hugepage_adjust(memslot, hva, &pfn, &gpa);
> +
> +               ret = kvm_pgtable_stage2_map(pgt, gpa, stage2_pagesize,
> +                                            __pfn_to_phys(pfn), prot, cache);
> +               spin_unlock(&kvm->mmu_lock);
> +
> +               kvm_set_pfn_accessed(pfn);
> +               kvm_release_pfn_dirty(pfn);
> +
> +               if (ret)
> +                       return ret;
> +               else if (hva < hva_end)
> +                       cond_resched();
> +
> +               hva += stage2_pagesize;
> +               gpa += stage2_pagesize;
> +               gfn = gpa >> PAGE_SHIFT;
> +       }
> +
> +       *hvap = hva;
> +       return 0;
> +}
> +
> +int kvm_map_locked_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
> +                          enum kvm_pgtable_prot prot)
> +{
> +       struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +       struct vm_area_struct *vma;
> +       unsigned long mmu_seq;
> +       hva_t hva, hva_memslot_end;
> +       int ret;
> +
> +       lockdep_assert_held(&kvm->slots_lock);
> +
> +       if (!(prot & KVM_PGTABLE_PROT_R))
> +               return -EPERM;
> +       if ((prot & KVM_PGTABLE_PROT_W) && (memslot->flags & KVM_MEM_READONLY))
> +               return -EPERM;
> +
> +       hva = memslot->userspace_addr;
> +       hva_memslot_end = memslot->userspace_addr + (memslot->npages << PAGE_SHIFT);
> +
> +       /*
> +        * Be extra careful here in case userspace is messing with the VMAs
> +        * backing the memslot.
> +        */
> +       mmu_seq = kvm->mmu_notifier_seq;
> +       smp_rmb();
> +
> +       /*
> +        * A memslot might span multiple VMAs and any holes between them, while
> +        * a VMA might span multiple memslots (see
> +        * kvm_arch_prepare_memory_region()). Take the intersection of the VMAs
> +        * with the memslot.
> +        */
> +       do {
> +               mmap_read_lock(current->mm);
> +               vma = find_vma(current->mm, hva);
> +               /*
> +                * find_vma() returns first VMA with hva < vma->vm_end, which
> +                * means that it is possible for the VMA to start *after* the
> +                * end of the memslot.
> +                */
> +               if (!vma || vma->vm_start >= hva_memslot_end) {
> +                       mmap_read_unlock(current->mm);
> +                       return 0;
> +               }
> +
> +               /*
> +                * VM_LOCKED pages are put in the unevictable LRU list and
> +                * hugetlb pages are not put in any LRU list; both will stay
> +                * pinned in memory.
> +                */
> +               if (!(vma->vm_flags & VM_LOCKED) && !is_vm_hugetlb_page(vma)) {
> +                       /* Go to next VMA. */
> +                       hva = vma->vm_end;
> +                       mmap_read_unlock(current->mm);
> +                       continue;
> +               }
> +               if (!(vma->vm_flags & VM_READ) ||
> +                   ((prot & KVM_PGTABLE_PROT_W) && !(vma->vm_flags & VM_WRITE))) {
> +                       /* Go to next VMA. */
> +                       hva = vma->vm_end;
> +                       mmap_read_unlock(current->mm);
> +                       continue;
> +               }
> +               mmap_read_unlock(current->mm);
> +
> +               ret = stage2_map_vma(kvm, memslot, vma, prot, mmu_seq, &hva, &cache);
> +               if (ret)
> +                       return ret;
> +       } while (hva < hva_memslot_end);
> +
> +       if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
> +               spin_lock(&kvm->mmu_lock);
> +               stage2_flush_memslot(kvm, memslot);
> +               spin_unlock(&kvm->mmu_lock);
> +       }
> +
> +       return 0;
> +}
> +
> +
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
>  }
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index f91a52cd7cd3..316ff8dfed5b 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -10,6 +10,13 @@
>  #include <kvm/arm_spe.h>
>  #include <kvm/arm_vgic.h>
>
> +#include <asm/kvm_mmu.h>
> +

It seems that the below function is used to de-finalize the spe status
if I get it correctly.
How about rename the function to some like "kvm_arm_vcpu_init_spe_definalize()"

> +void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu)
> +{
> +       vcpu->kvm->arch.spe.finalized = false;
> +}
> +
>  static bool kvm_arm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
>  {
>         if (!vcpu_has_spe(vcpu))
> @@ -115,6 +122,50 @@ int kvm_arm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>         return -ENXIO;
>  }
>
> +static int kvm_arm_spe_finalize(struct kvm *kvm)
> +{
> +       struct kvm_memory_slot *memslot;
> +       enum kvm_pgtable_prot prot;
> +       struct kvm_vcpu *vcpu;
> +       int i, ret;
> +
> +       kvm_for_each_vcpu(i, vcpu, kvm) {
> +               if (!kvm_arm_spe_vcpu_initialized(vcpu))
> +                       return -ENXIO;
> +       }
> +
> +       mutex_unlock(&kvm->slots_lock);

Should be mutex_lock(&kvm->slots_lock);?

> +       if (kvm_arm_spe_finalized(kvm)) {
> +               mutex_unlock(&kvm->slots_lock);
> +               return -EBUSY;
> +       }
> +
> +       prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> +       kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
> +               /* Only map memory that SPE can write to. */
> +               if (memslot->flags & KVM_MEM_READONLY)
> +                       continue;
> +                /*
> +                 * Dirty page logging will write-protect pages, which breaks
> +                 * SPE.
> +                 */
> +               if (memslot->dirty_bitmap)
> +                       continue;
> +               ret = kvm_map_locked_memslot(kvm, memslot, prot);
> +               if (ret)
> +                       break;
> +       }
> +
> +       if (!ret)
> +               kvm->arch.spe.finalized = true;
> +       mutex_unlock(&kvm->slots_lock);
> +
> +       if (ret)
> +               stage2_unmap_vm(kvm);
> +
> +       return ret;
> +}
> +
>  int kvm_arm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>         switch (attr->attr) {
> @@ -127,3 +178,33 @@ int kvm_arm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>         return -ENXIO;
>  }
> +
> +int kvm_arm_vm_spe_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       switch (attr->attr) {
> +       case KVM_ARM_VM_SPE_FINALIZE:
> +               return kvm_arm_spe_finalize(kvm);
> +       }
> +
> +       return -ENXIO;
> +}
> +
> +int kvm_arm_vm_spe_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       return -ENXIO;
> +}
> +
> +int kvm_arm_vm_spe_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +       struct kvm_vcpu *vcpu;
> +       int i;
> +
> +       switch (attr->attr) {
> +       case KVM_ARM_VM_SPE_FINALIZE:
> +               kvm_for_each_vcpu(i, vcpu, kvm)
> +                       if (kvm_arm_vcpu_supports_spe(vcpu))
> +                               return 0;
> +       }
> +
> +       return -ENXIO;
> +}
> diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> index 0275e8097529..7f9f3a03aadb 100644
> --- a/include/kvm/arm_spe.h
> +++ b/include/kvm/arm_spe.h
> @@ -18,23 +18,38 @@ struct kvm_spe_cpu {
>         bool initialized;       /* Feature is initialized on VCPU */
>  };
>
> +struct kvm_spe {
> +       bool finalized;
> +};
> +
>  #define kvm_arm_spe_irq_initialized(v)                 \
>         ((v)->arch.spe_cpu.irq_num >= VGIC_NR_SGIS &&   \
>          (v)->arch.spe_cpu.irq_num < VGIC_MAX_PRIVATE)
>  #define kvm_arm_spe_vcpu_initialized(v)        ((v)->arch.spe_cpu.initialized)
> +#define kvm_arm_spe_finalized(k)       ((k)->arch.spe.finalized)
>
>  int kvm_arm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_arm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_arm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>
> +int kvm_arm_vm_spe_set_attr(struct kvm *vcpu, struct kvm_device_attr *attr);
> +int kvm_arm_vm_spe_get_attr(struct kvm *vcpu, struct kvm_device_attr *attr);
> +int kvm_arm_vm_spe_has_attr(struct kvm *vcpu, struct kvm_device_attr *attr);
> +
> +void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu);
> +
>  #else
>  #define kvm_arm_supports_spe() false
>
>  struct kvm_spe_cpu {
>  };
>
> +struct kvm_spe {
> +};
> +
>  #define kvm_arm_spe_irq_initialized(v) false
>  #define kvm_arm_spe_vcpu_initialized(v)        false
> +#define kvm_arm_spe_finalized(k)       false
>
>  static inline int kvm_arm_spe_set_attr(struct kvm_vcpu *vcpu,
>                                        struct kvm_device_attr *attr)
> @@ -51,5 +66,26 @@ static inline int kvm_arm_spe_has_attr(struct kvm_vcpu *vcpu,
>  {
>         return -ENXIO;
>  }
> +
> +static inline int kvm_arm_vm_spe_set_attr(struct kvm *vcpu,
> +                                         struct kvm_device_attr *attr)
> +{
> +       return -ENXIO;
> +}
> +
> +static inline int kvm_arm_vm_spe_get_attr(struct kvm *vcpu,
> +                                         struct kvm_device_attr *attr)
> +{
> +       return -ENXIO;
> +}
> +
> +static inline int kvm_arm_vm_spe_has_attr(struct kvm *vcpu,
> +                                         struct kvm_device_attr *attr)
> +{
> +       return -ENXIO;
> +}
> +
> +static inline void kvm_arm_spe_notify_vcpu_init(struct kvm_vcpu *vcpu) {}
> +
>  #endif /* CONFIG_KVM_ARM_SPE */
>  #endif /* __ASM_ARM_KVM_SPE_H */
> --
> 2.29.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
