From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/2] Add the missing resetting LRs at boot time for
 new-vgic
Date: Tue, 6 Dec 2016 11:47:57 +0000
Message-ID: <cc4193be-c66e-f40a-7be4-f8f775abcd63@arm.com>
References: <1481006504-25460-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 467FF40423
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:47:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1BH+6aqlsyfa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 06:47:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9B840197
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:47:02 -0500 (EST)
In-Reply-To: <1481006504-25460-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/12/16 06:41, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Commit 50926d8(KVM: arm/arm64: The GIC is dead, long live the GIC)
> removes the old vgic and commit 9097773(KVM: arm/arm64: vgic-new: 
> vgic_init: implement kvm_vgic_hyp_init) doesn't reset LRs for new-vgic
> when probing GIC. These two patches add the missing part.
> 
> BTW, here is a strange problem on Huawei D03 board when using
> upstream kernel that android guest with a goldfish_fb will hang with
> rcu_stall and interrupt timeout for goldfish_fb. We apply these patches
> but the problem still exists, while if we revert the commit
> b40c489(arm64: KVM: vgic-v3: Only wipe LRs on vcpu exit) the guest runs
> well.
> 
> We add a trace in kvm_vgic_flush_hwstate() to print the value of 
> compute_ap_list_depth(vcpu) and the value of vgic_lr before calling
> vgic_flush_lr_state(). The first output shows that the ap_list_depth is zero
> but the first one in vgic_lr is 10a0000000002001. I don't understand why
> there is a valued one in vgic_lr since the memory of vgic_lr is zero
> allocated. I think It should be zero when the vcpu first run and first
> call kvm_vgic_flush_hwstate().
> 
> qemu-system-aar-6673  [016] ....   501.969251: kvm_vgic_flush_hwstate: VCPU: 0, lits-count: 0, LR: 10a0000000002001, 0, 0, 0
> 
> I also add a trace at the end of vgic_flush_lr_state() which shows the
> kvm_vgic_global_state.nr_lr is 4, used_lrs is 0 and all LRs in vgic_lr
> are zero.
> 
> qemu-system-aar-6673  [016] ....   501.969254: vgic_flush_lr_state_nuke: kvm_vgic_global_state.nr_lr is :4, irq1:0, irq2:0, irq3:0, irq4:0
> 
> But the trace at the beginning of kvm_vgic_sync_hwstate() shows the
> first one of vgic_lr is 10a0000000002001.
> 
> qemu-system-aar-6673  [016] ....   501.969261: kvm_vgic_sync_hwstate_vgic_lr: VCPU: 0, used_lrs: 0, LR: 10a0000000002001, 0, 0, 0
> 
> The above three trace outputs are printed by the first KVM_ENTRY/EXIT of VCPU 0.

Decoding this LR value is interesting:

10a0000000002001
| |         | LPI 8193
| |
| Priority 0xa0
|
Group1

Someone is injecting an LPI behind your back. If nobody populates this,
then you may want to investigate what is happening on the host side. Is
there anyone using this interrupt?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
