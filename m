Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B4EC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 12:54:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27ACC61077
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 12:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 27ACC61077
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A314B27B;
	Mon, 18 Oct 2021 08:54:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hkl-cj3SJHaZ; Mon, 18 Oct 2021 08:54:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4907E4B27F;
	Mon, 18 Oct 2021 08:54:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E1384B27C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 08:54:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8h88aAPmJBDK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 08:54:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01DBE4B27B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 08:54:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A866101E;
 Mon, 18 Oct 2021 05:54:28 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF1B83F73D;
 Mon, 18 Oct 2021 05:54:26 -0700 (PDT)
Date: Mon, 18 Oct 2021 13:56:10 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH v4 04/39] KVM: arm64: Defer CMOs for locked memslots
 until a VCPU is run
Message-ID: <YW1u6uaiJ808nOFS@monolith.localdoman>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
 <20210825161815.266051-5-alexandru.elisei@arm.com>
 <871r4jq3ku.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <871r4jq3ku.wl-maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Sun, Oct 17, 2021 at 12:43:29PM +0100, Marc Zyngier wrote:
> On Wed, 25 Aug 2021 17:17:40 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > KVM relies on doing dcache maintenance on stage 2 faults to present to a
> > gueste running with the MMU off the same view of memory as userspace. For
> > locked memslots, KVM so far has done the dcache maintenance when a memslot
> > is locked, but that leaves KVM in a rather awkward position: what userspace
> > writes to guest memory after the memslot is locked, but before a VCPU is
> > run, might not be visible to the guest.
> > 
> > Fix this by deferring the dcache maintenance until the first VCPU is run.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  7 ++++
> >  arch/arm64/include/asm/kvm_mmu.h  |  5 +++
> >  arch/arm64/kvm/arm.c              |  3 ++
> >  arch/arm64/kvm/mmu.c              | 56 ++++++++++++++++++++++++++++---
> >  4 files changed, 67 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 97ff3ed5d4b7..ed67f914d169 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -112,6 +112,10 @@ struct kvm_arch_memory_slot {
> >  	u32 flags;
> >  };
> >  
> > +/* kvm->arch.mmu_pending_ops flags */
> > +#define KVM_LOCKED_MEMSLOT_FLUSH_DCACHE	0
> > +#define KVM_MAX_MMU_PENDING_OPS		1
> > +
> >  struct kvm_arch {
> >  	struct kvm_s2_mmu mmu;
> >  
> > @@ -135,6 +139,9 @@ struct kvm_arch {
> >  	 */
> >  	bool return_nisv_io_abort_to_user;
> >  
> > +	/* Defer MMU operations until a VCPU is run. */
> > +	unsigned long mmu_pending_ops;
> 
> This has a funny taste of VM-wide requests...

I guess you can look at it that way, although the exact semantics of a VM-wide
request are very vague to me.

> 
> > +
> >  	/*
> >  	 * VM-wide PMU filter, implemented as a bitmap and big enough for
> >  	 * up to 2^10 events (ARMv8.0) or 2^16 events (ARMv8.1+).
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index ef079b5eb475..525c223e769f 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -219,6 +219,11 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
> >  int kvm_mmu_lock_memslot(struct kvm *kvm, u64 slot, u64 flags);
> >  int kvm_mmu_unlock_memslot(struct kvm *kvm, u64 slot, u64 flags);
> >  
> > +#define kvm_mmu_has_pending_ops(kvm)	\
> > +	(!bitmap_empty(&(kvm)->arch.mmu_pending_ops, KVM_MAX_MMU_PENDING_OPS))
> > +
> > +void kvm_mmu_perform_pending_ops(struct kvm *kvm);
> > +
> >  static inline unsigned int kvm_get_vmid_bits(void)
> >  {
> >  	int reg = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index efb3501c6016..144c982912d8 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -829,6 +829,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >  	if (unlikely(!kvm_vcpu_initialized(vcpu)))
> >  		return -ENOEXEC;
> >  
> > +	if (unlikely(kvm_mmu_has_pending_ops(vcpu->kvm)))
> > +		kvm_mmu_perform_pending_ops(vcpu->kvm);
> > +
> >  	ret = kvm_vcpu_first_run_init(vcpu);
> 
> Is there any reason why this isn't done as part of the 'first run'
> handling? I am refactoring that part to remove as many things as
> possible from the fast path, and would love not to go back to piling
> more stuff here.
> 
> Or do you expect this to happen more than once per VM (despite what
> the comment says)?

In theory, it can happen more than once per VM and KVM should allow it to
happen. I believe there is a least one valid use case for it, if userspace
unlocks a memslot to perform migration (so KVM can write-protect stage 2),
decides to cancel migration, then locks the memslot again without destroying the
VM.

However, I didn't take this scenario into account in this series
(kvm_mmu_lock_memslot returns an error if one VCPU has vcpu->arch.has_run_once
true). I'll put it on my todo list for the next iteration.

> 
> >  	if (ret)
> >  		return ret;
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 59c2bfef2fd1..94fa08f3d9d3 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1253,6 +1253,41 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >  	return ret;
> >  }
> >  
> > +/*
> > + * It's safe to do the CMOs when the first VCPU is run because:
> > + * - VCPUs cannot run until mmu_cmo_needed is cleared.
> > + * - Memslots cannot be modified because we hold the kvm->slots_lock.
> 
> It would be good to document the expected locking order for this kind
> of stuff.

I created this locking scheme with the assumption that a memslot is locked
before any VCPUs have run. I need to reconsider that for the use case I
mentioned above. I do agree that this needs to be very well documented.

I also want to try to get rid of lock_all_vcpus (which was
renamed to kvm_lock_all_vcpus in this series), because it triggers a lockdep
bug, which is present in from upstream KVM. Copy and pasted from the cover
letter (I got the number of VCPUs wrong, 47 is enough to trigger it):

"With CONFIG_PROVE_LOCKING=y, KVM will hit a BUG at
kvm_lock_all_vcpus()->mutex_trylock(&vcpu->mutex) with more than 48
VCPUs.

This BUG statement can also be triggered with mainline. To reproduce it,
compile kvmtool from this branch [1] and follow the instruction in the
kvmtool commit message".

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/vgic-lock-all-vcpus-lockdep-bug-v1

Here's the dmesg on my rockpro64, with mainline Linux v5.15-rc6, with the
kvmtool patch above:

$ ./vm run -c47 -m256 -k ../kvm-unit-tests/arm/selftest.flat --nodefaults -p "setup smp=47 mem=256"

[..]
[  136.888002] BUG: MAX_LOCK_DEPTH too low!
[  136.888372] turning off the locking correctness validator.
[  136.888859] depth: 48  max: 48!
[  136.889140] 48 locks held by vm/401:
[  136.889461]  #0: ffff00000d621248 (&kvm->lock){+.+.}-{3:3}, at: vgic_v3_attr_regs_access+0x9c/0x250
[  136.890288]  #1: ffff0000098d80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.891032]  #2: ffff00000b9980c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.891774]  #3: ffff00000b8440c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.892516]  #4: ffff00000d6c00c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.893259]  #5: ffff00000aa600c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.894001]  #6: ffff0000099540c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.894743]  #7: ffff00000b8f00c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.895486]  #8: ffff00000b9e00c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.896228]  #9: ffff00000b8e40c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.896970]  #10: ffff00000b8dc0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.897719]  #11: ffff00000b8d40c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.898468]  #12: ffff00000b9cc0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.899219]  #13: ffff00000ca940c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.899968]  #14: ffff00000c8f40c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.900717]  #15: ffff00000baa40c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.901465]  #16: ffff00000e98c0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.902214]  #17: ffff00000e9dc0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.902965]  #18: ffff00000aacc0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.903713]  #19: ffff0000098c80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.904462]  #20: ffff00000ab940c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.905211]  #21: ffff00000aba40c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.905961]  #22: ffff00000e9e80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.906710]  #23: ffff00000e9ec0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.907460]  #24: ffff00000d4d80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.908209]  #25: ffff00000d4dc0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.908959]  #26: ffff00000ab980c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.909708]  #27: ffff00000ab9c0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.910458]  #28: ffff00000ba9c0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.911206]  #29: ffff00000b9dc0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.911955]  #30: ffff00000abb40c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.912704]  #31: ffff00000aab80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.913454]  #32: ffff00000b9a00c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.914203]  #33: ffff00000b9e80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.914952]  #34: ffff00000ba000c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.915701]  #35: ffff00000b8a80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.916451]  #36: ffff00000ca080c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.917199]  #37: ffff00000aba80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.917950]  #38: ffff00000abac0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.918700]  #39: ffff00000c9e80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.919450]  #40: ffff00000c9ec0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.920199]  #41: ffff00000d4e00c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.920948]  #42: ffff00000d4e40c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.921697]  #43: ffff00000ca0c0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.922446]  #44: ffff00000abf00c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.923195]  #45: ffff00000abf40c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.923945]  #46: ffff00000abf80c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.924693]  #47: ffff00000abfc0c8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x2c/0xf0
[  136.925443] INFO: lockdep is turned off.
[  136.925795] CPU: 5 PID: 401 Comm: vm Not tainted 5.15.0-rc6 #103
[  136.926331] Hardware name: Pine64 RockPro64 v2.0 (DT)
[  136.926781] Call trace:
[  136.927000]  dump_backtrace+0x0/0x1a0
[  136.927332]  show_stack+0x18/0x24
[  136.927630]  dump_stack_lvl+0x8c/0xb8
[  136.927960]  dump_stack+0x18/0x34
[  136.928258]  __lock_acquire+0xbc8/0x20cc
[  136.928611]  lock_acquire.part.0+0xe0/0x230
[  136.928987]  lock_acquire+0x68/0x84
[  136.929301]  mutex_trylock+0xa8/0xf0
[  136.929623]  lock_all_vcpus+0x2c/0xf0
[  136.929953]  vgic_v3_attr_regs_access+0xb4/0x250
[  136.930366]  vgic_v3_get_attr+0x128/0x1e4
[  136.930726]  kvm_device_ioctl+0xd8/0x120
[  136.931078]  __arm64_sys_ioctl+0xa8/0xf0
[  136.931432]  invoke_syscall+0x48/0x114
[  136.931771]  el0_svc_common.constprop.0+0xfc/0x11c
[  136.932200]  do_el0_svc+0x28/0x90
[  136.932499]  el0_svc+0x54/0x130
[  136.932782]  el0t_64_sync_handler+0xa4/0x130
[  136.933164]  el0t_64_sync+0x1a0/0x1a4

The test completes correctly, and the lockdep splat is benign (bumping
include/linux/sched.h::MAX_LOCK_DEPTH removed the splat), but I would still like
to try to avoid it if possible.

> 
> > + *
> > + * It's safe to periodically release the mmu_lock because:
> > + * - VCPUs cannot run.
> > + * - Any changes to the stage 2 tables triggered by the MMU notifiers also take
> > + *   the mmu_lock, which means accesses will be serialized.
> > + * - Stage 2 tables cannot be freed from under us as long as at least one VCPU
> > + *   is live, which means that the VM will be live.
> > + */
> > +void kvm_mmu_perform_pending_ops(struct kvm *kvm)
> > +{
> > +	struct kvm_memory_slot *memslot;
> > +
> > +	mutex_lock(&kvm->slots_lock);
> > +	if (!kvm_mmu_has_pending_ops(kvm))
> > +		goto out_unlock;
> > +
> > +	if (test_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE, &kvm->arch.mmu_pending_ops)) {
> > +		kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
> > +			if (!memslot_is_locked(memslot))
> > +				continue;
> > +			stage2_flush_memslot(kvm, memslot);
> > +		}
> > +	}
> > +
> > +	bitmap_zero(&kvm->arch.mmu_pending_ops, KVM_MAX_MMU_PENDING_OPS);
> 
> clear_bit() instead? I understand that you want to support multiple
> ops, but this looks odd.

I can do that.

> 
> > +
> > +out_unlock:
> > +	mutex_unlock(&kvm->slots_lock);
> > +	return;
> > +}
> > +
> >  static int try_rlimit_memlock(unsigned long npages)
> >  {
> >  	unsigned long lock_limit;
> > @@ -1293,7 +1328,8 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >  	struct kvm_memory_slot_page *page_entry;
> >  	bool writable = flags & KVM_ARM_LOCK_MEM_WRITE;
> >  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > -	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> > +	struct kvm_pgtable pgt;
> > +	struct kvm_pgtable_mm_ops mm_ops;
> >  	struct vm_area_struct *vma;
> >  	unsigned long npages = memslot->npages;
> >  	unsigned int pin_flags = FOLL_LONGTERM;
> > @@ -1311,6 +1347,16 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >  		pin_flags |= FOLL_WRITE;
> >  	}
> >  
> > +	/*
> > +	 * Make a copy of the stage 2 translation table struct to remove the
> > +	 * dcache callback so we can postpone the cache maintenance operations
> > +	 * until the first VCPU is run.
> > +	 */
> > +	mm_ops = *kvm->arch.mmu.pgt->mm_ops;
> > +	mm_ops.dcache_clean_inval_poc = NULL;
> > +	pgt = *kvm->arch.mmu.pgt;
> > +	pgt.mm_ops = &mm_ops;
> 
> Huhuh... Can't really say I'm in love with this. Are you trying to
> avoid a double dcache clean to PoC? Is this a performance or a
> correctness issue?

I am trying to avoid a double dcache clean to PoC for performance reasons. I
haven't measured it in any way, but I believe that doing dcache clean to PoC for
VMs with big amounts of memory will have a noticeable impact on performance. I
can run some tests and come back with a number if you wish.

My intention here was to create a copy of the kvm->arch.mmu.pgt without the
dcache clean to PoC function pointer, and I agree that it doesn't look too
pleasing. I can temporarily assign NULL to
kvm->arch.mmu.pgt->mm_ops.dcache_clean_inval_poc if that makes it more
palatable. I'm open to suggestions.

One other option, if this looks too unpleasant and the solution is too
convoluted, is to leave the double dcache operation in place and figure out a
way to optimize it after the series has progressed some more.

Thanks for having a look!

Alex

> 
> > +
> >  	hva = memslot->userspace_addr;
> >  	ipa = memslot->base_gfn << PAGE_SHIFT;
> >  
> > @@ -1362,13 +1408,13 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >  			goto out_err;
> >  		}
> >  
> > -		ret = kvm_pgtable_stage2_map(pgt, ipa, PAGE_SIZE,
> > +		ret = kvm_pgtable_stage2_map(&pgt, ipa, PAGE_SIZE,
> >  					     page_to_phys(page_entry->page),
> >  					     prot, &cache);
> >  		spin_unlock(&kvm->mmu_lock);
> >  
> >  		if (ret) {
> > -			kvm_pgtable_stage2_unmap(pgt, memslot->base_gfn << PAGE_SHIFT,
> > +			kvm_pgtable_stage2_unmap(&pgt, memslot->base_gfn << PAGE_SHIFT,
> >  						 i << PAGE_SHIFT);
> >  			unpin_memslot_pages(memslot, writable);
> >  			goto out_err;
> > @@ -1387,7 +1433,7 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >  	 */
> >  	ret = account_locked_vm(current->mm, npages, true);
> >  	if (ret) {
> > -		kvm_pgtable_stage2_unmap(pgt, memslot->base_gfn << PAGE_SHIFT,
> > +		kvm_pgtable_stage2_unmap(&pgt, memslot->base_gfn << PAGE_SHIFT,
> >  					 npages << PAGE_SHIFT);
> >  		unpin_memslot_pages(memslot, writable);
> >  		goto out_err;
> > @@ -1397,6 +1443,8 @@ static int lock_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >  	if (writable)
> >  		memslot->arch.flags |= KVM_MEMSLOT_LOCK_WRITE;
> >  
> > +	set_bit(KVM_LOCKED_MEMSLOT_FLUSH_DCACHE, &kvm->arch.mmu_pending_ops);
> > +
> >  	kvm_mmu_free_memory_cache(&cache);
> >  
> >  	return 0;
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
