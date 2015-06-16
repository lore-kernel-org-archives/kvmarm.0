From: Vikram Sethi <vikrams@codeaurora.org>
Subject: HCPTR cp15 writes need isb?
Date: Mon, 15 Jun 2015 20:34:23 -0500
Message-ID: <557F7D1F.1070308@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25821551B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2015 21:23:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYLizlsMYLnF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2015 21:23:53 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B1C15519B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2015 21:23:52 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, marc.zyngier@arm.com, Christoffer Dall <christoffer.dall@linaro.org>, catalin.marinas@arm.com, will.deacon@arm.com, shankerd@codeaurora.org, mmcilvai@qti.qualcomm.com, vikrams@qti.qualcomm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc, Christoffer, Catalin, Will,

I'm seeing an issue with KVM HCPTR (cp15) writes on guest entry/exit on one of Qualcomm's CPU cores in AArch32 host and AArch32 guest mode. Our CPU architects believe that HCPTR cp15 writes are context changing and require an isb.
With an isb in set_hcptr macro in arch/arm/kvm/interrupts_head.S I am able to boot the Aarch32 guest, but without it, I see strange crashes to hyp_undef or hyp_pabt.

What is your opinion on HCPTR cp15 writes being context changing and needing isb? I can submit a one line patch that adds the isb at the end of set_hcptr macro.

I did find some examples in ARMv7 ARM with an isb after cp15 write and an ARM blog [1] that states ISB "is used to ensure any previously executed context changing operations (including cp15 operations) will have completed by the time the ISB completed."

I also found this text from an older lkml thread [2] which seems to quote from an ARM document (although I cannot find the same text in ARMv7 ARM) "Any change to CP15 registers is guaranteed to be visible to subsequent
instructions only after one of isb, exception, return from exception"

1 http://community.arm.com/groups/processors/blog/2011/10/19/memory-access-ordering-part-3--memory-access-ordering-in-the-arm-architecture
2 http://lkml.iu.edu/hypermail/linux/kernel/1105.1/00475.html

Thanks,
Vikram

-- 
Vikram Sethi
Qualcomm Technologies Inc, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
