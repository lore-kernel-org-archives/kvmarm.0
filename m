From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: ARM: updtae the VMID generation logic
Date: Wed, 4 Apr 2018 16:26:05 +0100
Message-ID: <88337662-1c3d-0e63-2e1d-0320fb5978e5@arm.com>
References: <1522335624-24332-1-git-send-email-zhaoshenglong@huawei.com>
 <20180329152758.za6ppojjiw6ea52u@lakrids.cambridge.arm.com>
 <20180403164947.n3h5vgtrtd2d3tok@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F4E14031C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Apr 2018 11:18:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iQ6GVnpTiNej for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Apr 2018 11:17:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 343BF4028A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Apr 2018 11:17:38 -0400 (EDT)
In-Reply-To: <20180403164947.n3h5vgtrtd2d3tok@lakrids.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 03/04/18 17:49, Mark Rutland wrote:
> On Thu, Mar 29, 2018 at 04:27:58PM +0100, Mark Rutland wrote:
>> On Thu, Mar 29, 2018 at 11:00:24PM +0800, Shannon Zhao wrote:
>>> From: zhaoshenglong <zhaoshenglong@huawei.com>
>>>
>>> Currently the VMID for some VM is allocated during VCPU entry/exit
>>> context and will be updated when kvm_next_vmid inversion. So this will
>>> cause the existing VMs exiting from guest and flush the tlb and icache.
>>>
>>> Also, while a platform with 8 bit VMID supports 255 VMs, it can create
>>> more than 255 VMs and if we create e.g. 256 VMs, some VMs will occur
>>> page fault since at some moment two VMs have same VMID.
>>
>> Have you seen this happen?
>>
>> I beleive that update_vttbr() should prevent this. We intialize
>> kvm_vmid_gen to 1, and when we init a VM, we set its vmid_gen to 0. So
>> the first time a VM is scheduled, update_vttbr() will allocate a VMID,
>> and by construction we shouldn't be able to allocate the same VMID to
>> multiple active VMs, regardless of whether we overflow several times.
> 
> Having delved a bit deeper, I think there is a case where a vcpu could
> end up using a stale VMID.
> 
> Say we have two physical CPUs, and we're running a VM with two VCPUs. 
> 
> We start one vCPU, and in update_vttbr() we find the VM's vmid_gen is
> stale. So we:
> 
> 1) Take the vmid lock
> 2) Increment kvm_vmid_gen
> 3) force_vm_exit(cpu_all_mask)
> 4) kvm_call_hyp(__kvm_flush_vm_context)
> 5) Update kvm->arch.vmid_gen
> 6) Update kvm->arch.vmid
> 7) Update kvm->arch.vttbr
> 
> ... but between steps 5 and 6/7, another CPU can enter update_vttbr(), see that
> kvm->arch.vmid_gen == kvm_vmid_gen, and carry on into hyp. In hyp, it reads the
> stale kvm->arch.vmid or kvm->arch.vttbr, and programs a stale VMID into the
> hardware.
> 
> There's a very small window for that to happen, but we might be able to
> exacerbate it with something like the below (untested) hack.
> 
> This is a classing TOCTTOU bug, and the best way I'm aware of to sovle this is
> something like the arm64 ASID allocator, where we reserve the active ASID on
> each CPU.
> 
> Thanks,
> Mark.
> 
> ---->8----
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 53572304843b..69d55aa12350 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -506,6 +506,7 @@ static void update_vttbr(struct kvm *kvm)
>         }
>  
>         kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
> +       udelay(10);
>         kvm->arch.vmid = kvm_next_vmid;
>         kvm_next_vmid++;
>         kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
> 

Using a udelay(100) and a 4 bit VMID space, I managed to reproduce this
race, and get guests to explode. Cool stuff.

Shannon, can you please try the below patch and let me know if that
helps?

Thanks,

	M.

>From 5bea0c247a93422594d3f83e6c8a61df9ce65c31 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Wed, 4 Apr 2018 14:48:24 +0100
Subject: [PATCH] KVM: arm/arm64: Close VMID generation race

Before entering the guest, we check whether our VMID is still
part of the current generation. In order to avoid taking a lock,
we start with checking that the generation is still current, and
only if not current do we take the lock, recheck, and update the
generation and VMID.

This leaves open a small race: A vcpu can bump up the global
generation number as well as the VM's, but has not updated
the VMID itself yet.

At that point another vcpu from the same VM comes in, checks
the generation (and finds it not needing anything), and jumps
into the guest. At this point, we end-up with two vcpus belonging
to the same VM running with two different VMIDs. Eventually, the
VMID used by the second vcpu will get reassigned, and things will
really go wrong...

A simple solution would be to drop this initial check, and always take
the lock. This is likely to cause performance issues. A middle ground
is to convert the spinlock to a rwlock, and only take the read lock
on the fast path. If the check fails at that point, drop it and
acquire the write lock, rechecking the condition.

This ensures that the above scenario doesn't occur.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index dba629c5f8ac..a4c1b76240df 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -63,7 +63,7 @@ static DEFINE_PER_CPU(struct kvm_vcpu *,
kvm_arm_running_vcpu);
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
 static unsigned int kvm_vmid_bits __read_mostly;
-static DEFINE_SPINLOCK(kvm_vmid_lock);
+static DEFINE_RWLOCK(kvm_vmid_lock);

 static bool vgic_present;

@@ -473,11 +473,16 @@ static void update_vttbr(struct kvm *kvm)
 {
 	phys_addr_t pgd_phys;
 	u64 vmid;
+	bool new_gen;

-	if (!need_new_vmid_gen(kvm))
+	read_lock(&kvm_vmid_lock);
+	new_gen = need_new_vmid_gen(kvm);
+	read_unlock(&kvm_vmid_lock);
+
+	if (!new_gen)
 		return;

-	spin_lock(&kvm_vmid_lock);
+	write_lock(&kvm_vmid_lock);

 	/*
 	 * We need to re-check the vmid_gen here to ensure that if another vcpu
@@ -485,7 +490,7 @@ static void update_vttbr(struct kvm *kvm)
 	 * use the same vmid.
 	 */
 	if (!need_new_vmid_gen(kvm)) {
-		spin_unlock(&kvm_vmid_lock);
+		write_unlock(&kvm_vmid_lock);
 		return;
 	}

@@ -519,7 +524,7 @@ static void update_vttbr(struct kvm *kvm)
 	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) &
VTTBR_VMID_MASK(kvm_vmid_bits);
 	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid;

-	spin_unlock(&kvm_vmid_lock);
+	write_unlock(&kvm_vmid_lock);
 }

 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
-- 
2.14.2

	
-- 
Jazz is not dead. It just smells funny...
