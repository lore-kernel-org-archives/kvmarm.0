From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/2] Add the missing resetting LRs at boot time for
 new-vgic
Date: Thu, 8 Dec 2016 13:32:54 +0100
Message-ID: <20161208123254.GI4816@cbox>
References: <1481006504-25460-1-git-send-email-zhaoshenglong@huawei.com>
 <cc4193be-c66e-f40a-7be4-f8f775abcd63@arm.com>
 <5847BE30.9050701@huawei.com>
 <76456b16-0ec2-fae9-6c7b-acb637d9629e@arm.com>
 <5847EBD3.9000504@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F179A402A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 07:31:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jUEpAe2sdedo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2016 07:31:46 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A04D401A1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 07:31:44 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id t79so23234127wmt.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2016 04:32:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <5847EBD3.9000504@huawei.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 07, 2016 at 07:00:35PM +0800, Shannon Zhao wrote:
> 
> 
> On 2016/12/7 16:10, Marc Zyngier wrote:
> > On 07/12/16 07:45, Shannon Zhao wrote:
> >>
> >>
> >> On 2016/12/6 19:47, Marc Zyngier wrote:
> >>> On 06/12/16 06:41, Shannon Zhao wrote:
> >>>> From: Shannon Zhao <shannon.zhao@linaro.org>
> >>>>
> >>>> Commit 50926d8(KVM: arm/arm64: The GIC is dead, long live the GIC)
> >>>> removes the old vgic and commit 9097773(KVM: arm/arm64: vgic-new: 
> >>>> vgic_init: implement kvm_vgic_hyp_init) doesn't reset LRs for new-vgic
> >>>> when probing GIC. These two patches add the missing part.
> >>>>
> >>>> BTW, here is a strange problem on Huawei D03 board when using
> >>>> upstream kernel that android guest with a goldfish_fb will hang with
> >>>> rcu_stall and interrupt timeout for goldfish_fb. We apply these patches
> >>>> but the problem still exists, while if we revert the commit
> >>>> b40c489(arm64: KVM: vgic-v3: Only wipe LRs on vcpu exit) the guest runs
> >>>> well.
> >>>>
> >>>> We add a trace in kvm_vgic_flush_hwstate() to print the value of 
> >>>> compute_ap_list_depth(vcpu) and the value of vgic_lr before calling
> >>>> vgic_flush_lr_state(). The first output shows that the ap_list_depth is zero
> >>>> but the first one in vgic_lr is 10a0000000002001. I don't understand why
> >>>> there is a valued one in vgic_lr since the memory of vgic_lr is zero
> >>>> allocated. I think It should be zero when the vcpu first run and first
> >>>> call kvm_vgic_flush_hwstate().
> >>>>
> >>>> qemu-system-aar-6673  [016] ....   501.969251: kvm_vgic_flush_hwstate: VCPU: 0, lits-count: 0, LR: 10a0000000002001, 0, 0, 0
> >>>>
> >>>> I also add a trace at the end of vgic_flush_lr_state() which shows the
> >>>> kvm_vgic_global_state.nr_lr is 4, used_lrs is 0 and all LRs in vgic_lr
> >>>> are zero.
> >>>>
> >>>> qemu-system-aar-6673  [016] ....   501.969254: vgic_flush_lr_state_nuke: kvm_vgic_global_state.nr_lr is :4, irq1:0, irq2:0, irq3:0, irq4:0
> >>>>
> >>>> But the trace at the beginning of kvm_vgic_sync_hwstate() shows the
> >>>> first one of vgic_lr is 10a0000000002001.
> >>>>
> >>>> qemu-system-aar-6673  [016] ....   501.969261: kvm_vgic_sync_hwstate_vgic_lr: VCPU: 0, used_lrs: 0, LR: 10a0000000002001, 0, 0, 0
> >>>>
> >>>> The above three trace outputs are printed by the first KVM_ENTRY/EXIT of VCPU 0.
> >>>
> >>> Decoding this LR value is interesting:
> >>>
> >>> 10a0000000002001
> >>> | |         | LPI 8193
> >>> | |
> >>> | Priority 0xa0
> >>> |
> >>> Group1
> >>>
> >>> Someone is injecting an LPI behind your back. If nobody populates this,
> >>> then you may want to investigate what is happening on the host side. Is
> >>> there anyone using this interrupt?
> >>>
> >>
> >> For this guest, I think nobody populates this LR, but on the host, there
> >> is a LPI interrupt 8193. It's a interrupt of eth2
> >>
> >> MBIGEN-V2 8193 Edge      eth2-tx0
> >>
> >> It's a little confused to me that the LR registers should only be used
> >> for VM, right? Why does the interrupt on host would affect the LRs?
> > 
> > It should never have an impact, but I'm worried that this could be a HW
> > bug where the physical side of the ITS leaks into the virtual one. You
> > have a GICv4, right?
> Yes, the hardware supports GICv4 but I think current kernel doesn't
> enable it.
> 
> > 
> > It'd be interesting to find out what happens if you leave this interrupt
> > disabled (don't enable eth2) and see if that interrupt magically appears
> > or not.
> > 
> Ah, I found the guest uses ITS and there is a irq number 8193. If I use
> a qemu without ITS feature then there is no such irq in trace output.
> 
> But there is still unexpected LR in vgic_lr[] array of irq 27. Nobody
> calls vgic_update_irq_pending for irq 27 before below trace outputs.
> 
>  qemu-system-aar-6681  [021] ....  1081.718849: kvm_vgic_flush_hwstate:
> VCPU: 0, lits-count: 0, LR: 0, 0, 0
>  qemu-system-aar-6681  [021] ....  1081.718849: vgic_flush_lr_state:
> used lr count is :0, irq1:0, irq2:0, irq3:0, irq4:0
>  qemu-system-aar-6681  [021] d...  1081.718850: kvm_entry: PC:
> 0xffffff8008432940
>  qemu-system-aar-6681  [021] ....  1081.718852: kvm_exit: TRAP: HSR_EC:
> 0x0024 (DABT_LOW), PC: 0xffffff8008432954
>  qemu-system-aar-6681  [021] ....  1081.718852:
> kvm_vgic_sync_hwstate_vgic_lr: VCPU: 0, used_lrs: 0, LR: 0, 0, 0, 0
>  qemu-system-aar-6681  [021] ....  1081.718855: kvm_vgic_flush_hwstate:
> VCPU: 0, lits-count: 0, LR: 50a002000000001b, 0, 0, 0
>  qemu-system-aar-6681  [021] ....  1081.718855: vgic_flush_lr_state:
> used lr count is :0, irq1:0, irq2:0, irq3:0, irq4:0
>  qemu-system-aar-6681  [021] d...  1081.718856: kvm_entry: PC:
> 0xffffff8008432958
>  qemu-system-aar-6681  [021] ....  1081.718858: kvm_exit: TRAP: HSR_EC:
> 0x0024 (DABT_LOW), PC: 0xffffff800843291c
> 

You could write a debug function that compares the GIC view of the LR
and the actual hardware value whenever vcpu_load and vcpu_put are
called, and see if this is a bug in the vgic code or this is related to
migrating vcpu threads around on cores that come and go.

Another thing to try is to pin each vcpu thread to physical cores and
see if you still see this problem.

Thanks,
-Christoffer
