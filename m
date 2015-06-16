From: Vikram Sethi <vikrams@codeaurora.org>
Subject: Re: HCPTR cp15 writes need isb?
Date: Tue, 16 Jun 2015 07:30:06 -0500
Message-ID: <558016CE.2050103@codeaurora.org>
References: <557F7D1F.1070308@codeaurora.org>
 <20150616074624.64b7d71c@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E256854541
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2015 08:19:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FCM2GKLYs-Gu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2015 08:19:35 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14BBD5449C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2015 08:19:34 -0400 (EDT)
In-Reply-To: <20150616074624.64b7d71c@why.wild-wind.fr.eu.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "mmcilvai@qti.qualcomm.com" <mmcilvai@qti.qualcomm.com>, "vikrams@qti.qualcomm.com" <vikrams@qti.qualcomm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/16/15 01:46, Marc Zyngier wrote:
> On Tue, 16 Jun 2015 02:34:23 +0100
> Vikram Sethi <vikrams@codeaurora.org> wrote:
>
> Hi Vikram,
>
>> Hi Marc, Christoffer, Catalin, Will,
>>
>> I'm seeing an issue with KVM HCPTR (cp15) writes on guest entry/exit
>> on one of Qualcomm's CPU cores in AArch32 host and AArch32 guest
>> mode. Our CPU architects believe that HCPTR cp15 writes are context
>> changing and require an isb. With an isb in set_hcptr macro in
>> arch/arm/kvm/interrupts_head.S I am able to boot the Aarch32 guest,
>> but without it, I see strange crashes to hyp_undef or hyp_pabt.
> [...]
>
> Can you look at the following patch (queued for 4.2)?
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-March/330955.html
>
> Please let me know if this solves the issue you are seeing.
Don't we have the same issue the first time guest touches FP and traps i.e in switch_to_guest_vfp where we turn on floating point access in HCPTR and immediately access FPEXC in store_vfp_state without a isb?

My first attempt at a fix was similar to yours (add isb only in kvm_vcpu_return path after hcptr update) and while that helped the guest boot further, I still got hyp prefetch abort (hyp_pabt) later in the guest boot, until I also added isbs after the other HCPTR writes.

>
> Thanks,
>
> 	M.


-- 
Vikram Sethi
Qualcomm Technologies Inc, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
