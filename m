Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30831C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 10:31:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EF9640B41;
	Thu, 17 Feb 2022 05:31:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qv2OpdhyPmrH; Thu, 17 Feb 2022 05:30:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BDFB49DE3;
	Thu, 17 Feb 2022 05:30:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7834040B41
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 05:30:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sluwGw-0xn3I for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 05:30:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D4A8408AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 05:30:56 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9086F1396;
 Thu, 17 Feb 2022 02:30:55 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B041F3F718;
 Thu, 17 Feb 2022 02:30:53 -0800 (PST)
Date: Thu, 17 Feb 2022 10:31:12 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v5 02/38] KVM: arm64: Add lock/unlock memslot user API
Message-ID: <Yg4j8MpTZ3BA7wZy@monolith.localdoman>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-3-alexandru.elisei@arm.com>
 <CAAeT=Fzx4Hf+Rimi7yNMxCO2OOm6C1_s1CnhcONHwg04nV_d7Q@mail.gmail.com>
 <YguInzLt1D9PZkwh@monolith.localdoman>
 <CAAeT=FwOh2125oscptguaLEK+PVFqTmtz0eG078xrUoEcGzr6A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FwOh2125oscptguaLEK+PVFqTmtz0eG078xrUoEcGzr6A@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Reiji,

On Wed, Feb 16, 2022 at 11:35:06PM -0800, Reiji Watanabe wrote:
> Hi Alex,
> 
> On Tue, Feb 15, 2022 at 3:03 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> >
> > Hi Reiji,
> >
> > On Mon, Feb 14, 2022 at 09:59:09PM -0800, Reiji Watanabe wrote:
> > > Hi Alex,
> > >
> > > On Wed, Nov 17, 2021 at 7:37 AM Alexandru Elisei
> > > <alexandru.elisei@arm.com> wrote:
> > > >
> > > > Stage 2 faults triggered by the profiling buffer attempting to write to
> > > > memory are reported by the SPE hardware by asserting a buffer management
> > > > event interrupt. Interrupts are by their nature asynchronous, which means
> > > > that the guest might have changed its stage 1 translation tables since the
> > > > attempted write. SPE reports the guest virtual address that caused the data
> > > > abort, not the IPA, which means that KVM would have to walk the guest's
> > > > stage 1 tables to find the IPA. Using the AT instruction to walk the
> > > > guest's tables in hardware is not an option because it doesn't report the
> > > > IPA in the case of a stage 2 fault on a stage 1 table walk.
> > > >
> > > > Avoid both issues by pre-mapping the guest memory at stage 2. This is being
> > > > done by adding a capability that allows the user to pin the memory backing
> > > > a memslot. The same capability can be used to unlock a memslot, which
> > > > unpins the pages associated with the memslot, but doesn't unmap the IPA
> > > > range from stage 2; in this case, the addresses will be unmapped from stage
> > > > 2 via the MMU notifiers when the process' address space changes.
> > > >
> > > > For now, the capability doesn't actually do anything other than checking
> > > > that the usage is correct; the memory operations will be added in future
> > > > patches.
> > > >
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > ---
> > > >  Documentation/virt/kvm/api.rst   | 57 ++++++++++++++++++++++++++
> > > >  arch/arm64/include/asm/kvm_mmu.h |  3 ++
> > > >  arch/arm64/kvm/arm.c             | 42 ++++++++++++++++++--
> > > >  arch/arm64/kvm/mmu.c             | 68 ++++++++++++++++++++++++++++++++
> > > >  include/uapi/linux/kvm.h         |  8 ++++
> > > >  5 files changed, 174 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > > index aeeb071c7688..16aa59eae3d9 100644
> > > > --- a/Documentation/virt/kvm/api.rst
> > > > +++ b/Documentation/virt/kvm/api.rst
> > > > @@ -6925,6 +6925,63 @@ indicated by the fd to the VM this is called on.
> > > >  This is intended to support intra-host migration of VMs between userspace VMMs,
> > > >  upgrading the VMM process without interrupting the guest.
> > > >
> > > > +7.30 KVM_CAP_ARM_LOCK_USER_MEMORY_REGION
> > > > +----------------------------------------
> > > > +
> > > > +:Architectures: arm64
> > > > +:Target: VM
> > > > +:Parameters: flags is one of KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_LOCK or
> > > > +                     KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_UNLOCK
> > > > +             args[0] is the slot number
> > > > +             args[1] specifies the permisions when the memslot is locked or if
> > > > +                     all memslots should be unlocked
> > > > +
> > > > +The presence of this capability indicates that KVM supports locking the memory
> > > > +associated with the memslot, and unlocking a previously locked memslot.
> > > > +
> > > > +The 'flags' parameter is defined as follows:
> > > > +
> > > > +7.30.1 KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_LOCK
> > > > +-------------------------------------------------
> > > > +
> > > > +:Capability: 'flags' parameter to KVM_CAP_ARM_LOCK_USER_MEMORY_REGION
> > > > +:Architectures: arm64
> > > > +:Target: VM
> > > > +:Parameters: args[0] contains the memory slot number
> > > > +             args[1] contains the permissions for the locked memory:
> > > > +                     KVM_ARM_LOCK_MEMORY_READ (mandatory) to map it with
> > > > +                     read permissions and KVM_ARM_LOCK_MEMORY_WRITE
> > > > +                     (optional) with write permissions
> > >
> > > Nit: Those flag names don't match the ones in the code.
> > > (Their names in the code are KVM_ARM_LOCK_MEM_READ/KVM_ARM_LOCK_MEM_WRITE)
> >
> > That's true, I'll change the flags to match.
> >
> > >
> > > What is the reason why KVM_ARM_LOCK_MEMORY_{READ,WRITE} flags need
> > > to be specified even though memslot already has similar flags ??
> >
> > I added both flags to make the ABI more flexible, and I don't think it's a
> > burden on userspace to specify the flags when locking a memslot.
> >
> > For this reason, I would rather keep it like this for now, unless you think
> > there's a good reason to remove them.
> 
> Understood.
> Just to confirm, KVM_ARM_LOCK_MEMORY_READ is practically unnecessary,
> isn't it ? (Perhaps it might be more straightforward to have a similar

Even if the flag looks unnecessary now, that might change in the future, if new
flags are added.

> read only lock flag to the memslot considering this is an operation for
> a memslot?)

I don't see a reason to add a read-only flag to this ioctl, the memslot's
read-only flag should be enough.

> 
> >
> > >
> > > > +:Returns: 0 on success; negative error code on failure
> > > > +
> > > > +Enabling this capability causes the memory described by the memslot to be
> > > > +pinned in the process address space and the corresponding stage 2 IPA range
> > > > +mapped at stage 2. The permissions specified in args[1] apply to both
> > > > +mappings. The memory pinned with this capability counts towards the max
> 
> I assume 'both mappings' mean the permission is applied to the
> mapping for process address space as well as stage 2.
> Why do you want to apply the permission to the process address space
> mapping as well (not just for the stage 2 mapping) ?

pin_user_pages() does not apply the permissions. It checks that they are already
there (look at pin_user_pages -> __gup_longterm_locked -> __get_user_pages_locked).

I put the "both mappings" bit there to let userspace know that the userspace
mapping backing the memslot must have at least the same permissions as those
specified when locking the memslot. I'll remove this part, because it's
confusing and redundant.

> 
> 
> > > > +locked memory limit for the current process.
> > > > +
> > > > +The capability should be enabled when no VCPUs are in the kernel executing an
> > > > +ioctl (and in particular, KVM_RUN); otherwise the ioctl will block until all
> > > > +VCPUs have returned. The virtual memory range described by the memslot must be
> > > > +mapped in the userspace process without any gaps. It is considered an error if
> > > > +write permissions are specified for a memslot which logs dirty pages.
> > > > +
> > > > +7.30.2 KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_UNLOCK
> > > > +---------------------------------------------------
> > > > +
> > > > +:Capability: 'flags' parameter to KVM_CAP_ARM_LOCK_USER_MEMORY_REGION
> > > > +:Architectures: arm64
> > > > +:Target: VM
> > > > +:Parameters: args[0] contains the memory slot number
> > > > +             args[1] optionally contains the flag KVM_ARM_UNLOCK_MEM_ALL,
> > > > +                     which unlocks all previously locked memslots.
> > > > +:Returns: 0 on success; negative error code on failure
> > > > +
> > > > +Enabling this capability causes the memory pinned when locking the memslot
> > > > +specified in args[0] to be unpinned, or, optionally, all memslots to be
> > > > +unlocked. The IPA range is not unmapped from stage 2.
> > > > +>>>>>>> 56641eee289e (KVM: arm64: Add lock/unlock memslot user API)
> > >
> > > Nit: An unnecessary line.
> > >
> > > If a memslot with read/write permission is locked with read only,
> > > and then unlocked, can userspace expect stage 2 mapping for the
> > > memslot to be updated with read/write ?
> >
> > Locking a memslot with the read flag would map the memory described by the
> > memslot with read permissions at stage 2. When the memslot is unlocked, KVM
> > won't touch the stage 2 entries.
> >
> > When the memslot is unlocked, the pages (as in, struct page) backing the VM
> > memory as described by the memslot are unpinned. Then the host's MM subsystem
> > can treat the memory like any other pages (make them old, new, unmap them, do
> > nothing, etc), and the MMU notifier will take care of updating the stage 2
> > entries as necessary.
> >
> > I guess I should have been more precise in the description. I'll change "causes
> > the memory pinned when locking the memslot specified in args[0] to be unpinned"
> > to something that clearly states that the memory in the host that backs the
> > memslot is unpinned.
> 
> Thank you for the explanation.
> It seems I misunderstood the read/write lock flag.
> These lock flags only affect the permission of locked mappings, not
> the guest's permission to access the memory, which depends only on
> the memslot permission (not on the lock flags) as before. Correct ?

Yes, the locked flags only affect the initial permissions with which the IPAs
are mapped at stage 2.

Thanks,
Alex

> 
> 
> >
> > > Can userspace delete the memslot that is locked (without unlocking) ?
> >
> > No, it cannot.
> >
> > > If so, userspace can expect the corresponding range to be implicitly
> > > unlocked, correct ?
> >
> > Userspace must explicitely unlock the memslot before deleting it. I want
> > userspace to be explicit in its intent.
> 
> I see. Thank you for the clarification (I checked patch-9 as well).
> 
> Thanks!
> Reiji
> 
> 
> 
> >
> > Thanks,
> > Alex
> >
> > >
> > > Thanks,
> > > Reiji
> > >
> > > > +
> > > >  8. Other capabilities.
> > > >  ======================
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > > > index 02d378887743..2c50734f048d 100644
> > > > --- a/arch/arm64/include/asm/kvm_mmu.h
> > > > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > > > @@ -216,6 +216,9 @@ static inline void __invalidate_icache_guest_page(void *va, size_t size)
> > > >  void kvm_set_way_flush(struct kvm_vcpu *vcpu);
> > > >  void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
> > > >
> > > > +int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags);
> > > > +int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags);
> > > > +
> > > >  static inline unsigned int kvm_get_vmid_bits(void)
> > > >  {
> > > >         int reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index e9b4ad7b5c82..d49905d18cee 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -78,16 +78,43 @@ int kvm_arch_check_processor_compat(void *opaque)
> > > >         return 0;
> > > >  }
> > > >
> > > > +static int kvm_arm_lock_memslot_supported(void)
> > > > +{
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +static int kvm_lock_user_memory_region_ioctl(struct kvm *kvm,
> > > > +                                            struct kvm_enable_cap *cap)
> > > > +{
> > > > +       u64 slot, action_flags;
> > > > +       u32 action;
> > > > +
> > > > +       if (cap->args[2] || cap->args[3])
> > > > +               return -EINVAL;
> > > > +
> > > > +       slot = cap->args[0];
> > > > +       action = cap->flags;
> > > > +       action_flags = cap->args[1];
> > > > +
> > > > +       switch (action) {
> > > > +       case KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_LOCK:
> > > > +               return kvm_mmu_lock_memslot(kvm, slot, action_flags);
> > > > +       case KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_UNLOCK:
> > > > +               return kvm_mmu_unlock_memslot(kvm, slot, action_flags);
> > > > +       default:
> > > > +               return -EINVAL;
> > > > +       }
> > > > +}
> > > > +
> > > >  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > > >                             struct kvm_enable_cap *cap)
> > > >  {
> > > >         int r;
> > > >
> > > > -       if (cap->flags)
> > > > -               return -EINVAL;
> > > > -
> > > >         switch (cap->cap) {
> > > >         case KVM_CAP_ARM_NISV_TO_USER:
> > > > +               if (cap->flags)
> > > > +                       return -EINVAL;
> > > >                 r = 0;
> > > >                 kvm->arch.return_nisv_io_abort_to_user = true;
> > > >                 break;
> > > > @@ -101,6 +128,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > > >                 }
> > > >                 mutex_unlock(&kvm->lock);
> > > >                 break;
> > > > +       case KVM_CAP_ARM_LOCK_USER_MEMORY_REGION:
> > > > +               if (!kvm_arm_lock_memslot_supported())
> > > > +                       return -EINVAL;
> > > > +               r = kvm_lock_user_memory_region_ioctl(kvm, cap);
> > > > +               break;
> > > >         default:
> > > >                 r = -EINVAL;
> > > >                 break;
> > > > @@ -168,7 +200,6 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> > > >         return VM_FAULT_SIGBUS;
> > > >  }
> > > >
> > > > -
> > > >  /**
> > > >   * kvm_arch_destroy_vm - destroy the VM data structure
> > > >   * @kvm:       pointer to the KVM struct
> > > > @@ -276,6 +307,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > > >         case KVM_CAP_ARM_PTRAUTH_GENERIC:
> > > >                 r = system_has_full_ptr_auth();
> > > >                 break;
> > > > +       case KVM_CAP_ARM_LOCK_USER_MEMORY_REGION:
> > > > +               r = kvm_arm_lock_memslot_supported();
> > > > +               break;
> > > >         default:
> > > >                 r = 0;
> > > >         }
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 326cdfec74a1..f65bcbc9ae69 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -1296,6 +1296,74 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> > > >         return ret;
> > > >  }
> > > >
> > > > +int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags)
> > > > +{
> > > > +       struct kvm_memory_slot *memslot;
> > > > +       int ret;
> > > > +
> > > > +       if (slot >= KVM_MEM_SLOTS_NUM)
> > > > +               return -EINVAL;
> > > > +
> > > > +       if (!(flags & KVM_ARM_LOCK_MEM_READ))
> > > > +               return -EINVAL;
> > > > +
> > > > +       mutex_lock(&kvm->lock);
> > > > +       if (!kvm_lock_all_vcpus(kvm)) {
> > > > +               ret = -EBUSY;
> > > > +               goto out_unlock_kvm;
> > > > +       }
> > > > +       mutex_lock(&kvm->slots_lock);
> > > > +
> > > > +       memslot = id_to_memslot(kvm_memslots(kvm), slot);
> > > > +       if (!memslot) {
> > > > +               ret = -EINVAL;
> > > > +               goto out_unlock_slots;
> > > > +       }
> > > > +       if ((flags & KVM_ARM_LOCK_MEM_WRITE) &&
> > > > +           ((memslot->flags & KVM_MEM_READONLY) || memslot->dirty_bitmap)) {
> > > > +               ret = -EPERM;
> > > > +               goto out_unlock_slots;
> > > > +       }
> > > > +
> > > > +       ret = -EINVAL;
> > > > +
> > > > +out_unlock_slots:
> > > > +       mutex_unlock(&kvm->slots_lock);
> > > > +       kvm_unlock_all_vcpus(kvm);
> > > > +out_unlock_kvm:
> > > > +       mutex_unlock(&kvm->lock);
> > > > +       return ret;
> > > > +}
> > > > +
> > > > +int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags)
> > > > +{
> > > > +       bool unlock_all = flags & KVM_ARM_UNLOCK_MEM_ALL;
> > > > +       struct kvm_memory_slot *memslot;
> > > > +       int ret;
> > > > +
> > > > +       if (!unlock_all && slot >= KVM_MEM_SLOTS_NUM)
> > > > +               return -EINVAL;
> > > > +
> > > > +       mutex_lock(&kvm->slots_lock);
> > > > +
> > > > +       if (unlock_all) {
> > > > +               ret = -EINVAL;
> > > > +               goto out_unlock_slots;
> > > > +       }
> > > > +
> > > > +       memslot = id_to_memslot(kvm_memslots(kvm), slot);
> > > > +       if (!memslot) {
> > > > +               ret = -EINVAL;
> > > > +               goto out_unlock_slots;
> > > > +       }
> > > > +
> > > > +       ret = -EINVAL;
> > > > +
> > > > +out_unlock_slots:
> > > > +       mutex_unlock(&kvm->slots_lock);
> > > > +       return ret;
> > > > +}
> > > > +
> > > >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> > > >  {
> > > >         if (!kvm->arch.mmu.pgt)
> > > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > index 1daa45268de2..70c969967557 100644
> > > > --- a/include/uapi/linux/kvm.h
> > > > +++ b/include/uapi/linux/kvm.h
> > > > @@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
> > > >  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
> > > >  #define KVM_CAP_ARM_MTE 205
> > > >  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> > > > +#define KVM_CAP_ARM_LOCK_USER_MEMORY_REGION 207
> > > >
> > > >  #ifdef KVM_CAP_IRQ_ROUTING
> > > >
> > > > @@ -1483,6 +1484,13 @@ struct kvm_s390_ucas_mapping {
> > > >  #define KVM_PPC_SVM_OFF                  _IO(KVMIO,  0xb3)
> > > >  #define KVM_ARM_MTE_COPY_TAGS    _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
> > > >
> > > > +/* Used by KVM_CAP_ARM_LOCK_USER_MEMORY_REGION */
> > > > +#define KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_LOCK     (1 << 0)
> > > > +#define   KVM_ARM_LOCK_MEM_READ                                (1 << 0)
> > > > +#define   KVM_ARM_LOCK_MEM_WRITE                       (1 << 1)
> > > > +#define KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_UNLOCK   (1 << 1)
> > > > +#define   KVM_ARM_UNLOCK_MEM_ALL                       (1 << 0)
> > > > +
> > > >  /* ioctl for vm fd */
> > > >  #define KVM_CREATE_DEVICE        _IOWR(KVMIO,  0xe0, struct kvm_create_device)
> > > >
> > > > --
> > > > 2.33.1
> > > >
> > > > _______________________________________________
> > > > kvmarm mailing list
> > > > kvmarm@lists.cs.columbia.edu
> > > > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
