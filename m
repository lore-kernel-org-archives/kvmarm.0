From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: ARM: updtae the VMID generation logic
Date: Tue, 3 Apr 2018 17:49:48 +0100
Message-ID: <20180403164947.n3h5vgtrtd2d3tok@lakrids.cambridge.arm.com>
References: <1522335624-24332-1-git-send-email-zhaoshenglong@huawei.com>
 <20180329152758.za6ppojjiw6ea52u@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 562B749F94
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Apr 2018 12:41:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BKooCPYSV3dB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Apr 2018 12:41:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB1EE401CD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Apr 2018 12:41:25 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180329152758.za6ppojjiw6ea52u@lakrids.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 29, 2018 at 04:27:58PM +0100, Mark Rutland wrote:
> On Thu, Mar 29, 2018 at 11:00:24PM +0800, Shannon Zhao wrote:
> > From: zhaoshenglong <zhaoshenglong@huawei.com>
> > 
> > Currently the VMID for some VM is allocated during VCPU entry/exit
> > context and will be updated when kvm_next_vmid inversion. So this will
> > cause the existing VMs exiting from guest and flush the tlb and icache.
> > 
> > Also, while a platform with 8 bit VMID supports 255 VMs, it can create
> > more than 255 VMs and if we create e.g. 256 VMs, some VMs will occur
> > page fault since at some moment two VMs have same VMID.
> 
> Have you seen this happen?
> 
> I beleive that update_vttbr() should prevent this. We intialize
> kvm_vmid_gen to 1, and when we init a VM, we set its vmid_gen to 0. So
> the first time a VM is scheduled, update_vttbr() will allocate a VMID,
> and by construction we shouldn't be able to allocate the same VMID to
> multiple active VMs, regardless of whether we overflow several times.

Having delved a bit deeper, I think there is a case where a vcpu could
end up using a stale VMID.

Say we have two physical CPUs, and we're running a VM with two VCPUs. 

We start one vCPU, and in update_vttbr() we find the VM's vmid_gen is
stale. So we:

1) Take the vmid lock
2) Increment kvm_vmid_gen
3) force_vm_exit(cpu_all_mask)
4) kvm_call_hyp(__kvm_flush_vm_context)
5) Update kvm->arch.vmid_gen
6) Update kvm->arch.vmid
7) Update kvm->arch.vttbr

... but between steps 5 and 6/7, another CPU can enter update_vttbr(), see that
kvm->arch.vmid_gen == kvm_vmid_gen, and carry on into hyp. In hyp, it reads the
stale kvm->arch.vmid or kvm->arch.vttbr, and programs a stale VMID into the
hardware.

There's a very small window for that to happen, but we might be able to
exacerbate it with something like the below (untested) hack.

This is a classing TOCTTOU bug, and the best way I'm aware of to sovle this is
something like the arm64 ASID allocator, where we reserve the active ASID on
each CPU.

Thanks,
Mark.

---->8----
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 53572304843b..69d55aa12350 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -506,6 +506,7 @@ static void update_vttbr(struct kvm *kvm)
        }
 
        kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
+       udelay(10);
        kvm->arch.vmid = kvm_next_vmid;
        kvm_next_vmid++;
        kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
