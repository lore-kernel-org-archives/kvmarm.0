From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: kvm: deadlock in kvm_vgic_map_resources
Date: Thu, 12 Jan 2017 11:42:53 +0100
Message-ID: <20170112104253.GB13547@cbox>
References: <CACT4Y+YRg=H0F-_QTtPf0--o85sQCb__j=V25tPchx9ycYtyKg@mail.gmail.com>
 <70371c5c-d0c0-b59e-b12c-fd8359392763@arm.com>
 <286255e8-918e-66b5-012f-f347a2ae71cd@arm.com>
 <0994d5a9-d9f4-7b80-4b16-1797c093edb5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0994d5a9-d9f4-7b80-4b16-1797c093edb5@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, syzkaller <syzkaller@googlegroups.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 12, 2017 at 10:30:39AM +0000, Marc Zyngier wrote:
> On 12/01/17 09:55, Andre Przywara wrote:
> > Hi,
> > 
> > On 12/01/17 09:32, Marc Zyngier wrote:
> >> Hi Dmitry,
> >>
> >> On 11/01/17 19:01, Dmitry Vyukov wrote:
> >>> Hello,
> >>>
> >>> While running syzkaller fuzzer I've got the following deadlock.
> >>> On commit 9c763584b7c8911106bb77af7e648bef09af9d80.
> >>>
> >>>
> >>> =============================================
> >>> [ INFO: possible recursive locking detected ]
> >>> 4.9.0-rc6-xc2-00056-g08372dd4b91d-dirty #50 Not tainted
> >>> ---------------------------------------------
> >>> syz-executor/20805 is trying to acquire lock:
> >>> (
> >>> &kvm->lock
> >>> ){+.+.+.}
> >>> , at:
> >>> [< inline >] kvm_vgic_dist_destroy
> >>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:271
> >>> [<ffff2000080ea4bc>] kvm_vgic_destroy+0x34/0x250
> >>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:294
> >>> but task is already holding lock:
> >>> (&kvm->lock){+.+.+.}, at:
> >>> [<ffff2000080ea7e4>] kvm_vgic_map_resources+0x2c/0x108
> >>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:343
> >>> other info that might help us debug this:
> >>> Possible unsafe locking scenario:
> >>> CPU0
> >>> ----
> >>> lock(&kvm->lock);
> >>> lock(&kvm->lock);
> >>> *** DEADLOCK ***
> >>> May be due to missing lock nesting notation
> >>> 2 locks held by syz-executor/20805:
> >>> #0:(&vcpu->mutex){+.+.+.}, at:
> >>> [<ffff2000080bcc30>] vcpu_load+0x28/0x1d0
> >>> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:143
> >>> #1:(&kvm->lock){+.+.+.}, at:
> >>> [<ffff2000080ea7e4>] kvm_vgic_map_resources+0x2c/0x108
> >>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:343
> >>> stack backtrace:
> >>> CPU: 2 PID: 20805 Comm: syz-executor Not tainted
> >>> 4.9.0-rc6-xc2-00056-g08372dd4b91d-dirty #50
> >>> Hardware name: Hardkernel ODROID-C2 (DT)
> >>> Call trace:
> >>> [<ffff200008090560>] dump_backtrace+0x0/0x3c8 arch/arm64/kernel/traps.c:69
> >>> [<ffff200008090948>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:219
> >>> [< inline >] __dump_stack lib/dump_stack.c:15
> >>> [<ffff200008895840>] dump_stack+0x100/0x150 lib/dump_stack.c:51
> >>> [< inline >] print_deadlock_bug kernel/locking/lockdep.c:1728
> >>> [< inline >] check_deadlock kernel/locking/lockdep.c:1772
> >>> [< inline >] validate_chain kernel/locking/lockdep.c:2250
> >>> [<ffff2000081c8718>] __lock_acquire+0x1938/0x3440 kernel/locking/lockdep.c:3335
> >>> [<ffff2000081caa84>] lock_acquire+0xdc/0x1d8 kernel/locking/lockdep.c:3746
> >>> [< inline >] __mutex_lock_common kernel/locking/mutex.c:521
> >>> [<ffff200009700004>] mutex_lock_nested+0xdc/0x7b8 kernel/locking/mutex.c:621
> >>> [< inline >] kvm_vgic_dist_destroy
> >>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:271
> >>> [<ffff2000080ea4bc>] kvm_vgic_destroy+0x34/0x250
> >>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:294
> >>> [<ffff2000080ec290>] vgic_v2_map_resources+0x218/0x430
> >>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-v2.c:295
> >>> [<ffff2000080ea884>] kvm_vgic_map_resources+0xcc/0x108
> >>> arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-init.c:348
> >>> [< inline >] kvm_vcpu_first_run_init
> >>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:505
> >>> [<ffff2000080d2768>] kvm_arch_vcpu_ioctl_run+0xab8/0xce0
> >>> arch/arm64/kvm/../../../arch/arm/kvm/arm.c:591
> >>> [<ffff2000080c1fec>] kvm_vcpu_ioctl+0x434/0xc08
> >>> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:2557
> >>> [< inline >] vfs_ioctl fs/ioctl.c:43
> >>> [<ffff200008450c38>] do_vfs_ioctl+0x128/0xfc0 fs/ioctl.c:679
> >>> [< inline >] SYSC_ioctl fs/ioctl.c:694
> >>> [<ffff200008451b78>] SyS_ioctl+0xa8/0xb8 fs/ioctl.c:685
> >>> [<ffff200008083ef0>] el0_svc_naked+0x24/0x28 arch/arm64/kernel/entry.S:755
> >>
> >> Nice catch, and many thanks for reporting this.
> >>
> >> The bug is fairly obvious. Christoffer, what do you think? I don't think
> >> we need to hold the kvm->lock all the way, but I'd like another pair of
> >> eyes (the coffee machine is out of order again, and tea doesn't cut it).
> >>
> >> Thanks,
> >>
> >> 	M.
> >>
> >> From 93f80b20fb9351a49ee8b74eed3fc59c84651371 Mon Sep 17 00:00:00 2001
> >> From: Marc Zyngier <marc.zyngier@arm.com>
> >> Date: Thu, 12 Jan 2017 09:21:56 +0000
> >> Subject: [PATCH] KVM: arm/arm64: vgic: Fix deadlock on error handling
> >>
> >> Dmitry Vyukov reported that the syzkaller fuzzer triggered a
> >> deadlock in the vgic setup code when an error was detected, as
> >> the cleanup code tries to take a lock that is already held by
> >> the setup code.
> >>
> >> The fix is pretty obvious: move the cleaup call after having
> >> dropped the lock, since not much can happen at that point.
> >                           ^^^^^^^^
> > Is that really true? If for instance the calls to
> > vgic_register_dist_iodev() or kvm_phys_addr_ioremap() in
> > vgic_v2_map_resources() fail, we leave the function with a half
> > initialized VGIC (because vgic_init() succeeded). 
> 
> But we only set dist->ready to true when everything went OK. How is 
> that an issue?
> 
> > Dropping the lock at
> > this point without having the GIC cleaned up before sounds a bit
> > suspicious (I may be wrong on this, though).
> 
> Thinking of it, that may open a race with vgic init call, leading to 
> leaking distributor memory.
> 
> > 
> > Can't we just document that kvm_vgic_destroy() needs to be called with
> > the kvm->lock held and take the lock around the only other caller
> > (kvm_arch_destroy_vm() in arch/arm/kvm/arm.c)?
> > We can then keep holding the lock in the map_resources calls.
> > Though we might still move the calls to kvm_vgic_destroy() into the
> > wrapper function as a cleanup (as shown below), just before dropping the
> > lock.
> 
> I'd rather keep the changes limited to the vgic code, and save myself 
> having to document more locking (we already have our fair share here). 
> How about this (untested):
> 
> From 24dc3f5750da20d89e0ce9b7855d125d0100bee8 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <marc.zyngier@arm.com>
> Date: Thu, 12 Jan 2017 09:21:56 +0000
> Subject: [PATCH] KVM: arm/arm64: vgic: Fix deadlock on error handling
> 
> Dmitry Vyukov reported that the syzkaller fuzzer triggered a
> deadlock in the vgic setup code when an error was detected, as
> the cleanup code tries to take a lock that is already held by
> the setup code.
> 
> The fix is to avoid retaking the lock when cleaning up, by
> telling the cleanup function that we already hold it.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 21 ++++++++++++++++-----
>  virt/kvm/arm/vgic/vgic-v2.c   |  2 --
>  virt/kvm/arm/vgic/vgic-v3.c   |  2 --
>  3 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 5114391..30d74e2 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -264,11 +264,12 @@ int vgic_init(struct kvm *kvm)
>  	return ret;
>  }
>  
> -static void kvm_vgic_dist_destroy(struct kvm *kvm)
> +static void kvm_vgic_dist_destroy(struct kvm *kvm, bool locked)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
> -	mutex_lock(&kvm->lock);
> +	if (!locked)
> +		mutex_lock(&kvm->lock);

Hmm, not a fan of passing this variable around.  How about this instead
then (untested):

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 5114391..a25806b 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -264,19 +264,16 @@ int vgic_init(struct kvm *kvm)
 	return ret;
 }
 
+/* Must be called with the kvm->lock held */
 static void kvm_vgic_dist_destroy(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	mutex_lock(&kvm->lock);
-
 	dist->ready = false;
 	dist->initialized = false;
 
 	kfree(dist->spis);
 	dist->nr_spis = 0;
-
-	mutex_unlock(&kvm->lock);
 }
 
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -286,7 +283,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 }
 
-void kvm_vgic_destroy(struct kvm *kvm)
+void __kvm_vgic_destroy(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	int i;
@@ -297,6 +294,13 @@ void kvm_vgic_destroy(struct kvm *kvm)
 		kvm_vgic_vcpu_destroy(vcpu);
 }
 
+void kvm_vgic_destroy(struct kvm *kvm)
+{
+	mutex_lock(&kvm->lock);
+	__kvm_vgic_destroy(kvm);
+	mutex_unlock(&kvm->lock);
+}
+
 /**
  * vgic_lazy_init: Lazy init is only allowed if the GIC exposed to the guest
  * is a GICv2. A GICv3 must be explicitly initialized by the guest using the
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 9bab867..c6f7ec7 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -294,7 +294,7 @@ int vgic_v2_map_resources(struct kvm *kvm)
 
 out:
 	if (ret)
-		kvm_vgic_destroy(kvm);
+		__kvm_vgic_destroy(kvm);
 	return ret;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 5c9f974..f1c7819 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -303,7 +303,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
 
 out:
 	if (ret)
-		kvm_vgic_destroy(kvm);
+		__kvm_vgic_destroy(kvm);
 	return ret;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 859f65c..74a0bbb 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -37,6 +37,8 @@ struct vgic_vmcr {
 	u32	pmr;
 };
 
+void __kvm_vgic_destroy(struct kvm *kvm);
+
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);


Thanks,
-Christoffer
