From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 4/9] KVM: arm/arm64: preserve host HCR_EL2 value
Date: Sat, 6 Apr 2019 11:37:14 +0100
Message-ID: <f27a3e70-2099-45a6-48e6-481a67e360eb@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-5-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E55E64A409
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Apr 2019 06:37:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZSWr3pKtCYjj for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Apr 2019 06:37:20 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 478B04A320
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Apr 2019 06:37:20 -0400 (EDT)
In-Reply-To: <1554172037-4516-5-git-send-email-amit.kachhap@arm.com>
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
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 02/04/2019 03:27, Amit Daniel Kachhap wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
> is a constant value. This works today, as the host HCR_EL2 value is
> always the same, but this will get in the way of supporting extensions
> that require HCR_EL2 bits to be set conditionally for the host.
> 
> To allow such features to work without KVM having to explicitly handle
> every possible host feature combination, this patch has KVM save/restore
> for the host HCR when switching to/from a guest HCR. The saving of the
> register is done once during cpu hypervisor initialization state and is
> just restored after switch from guest.
> 
> For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
> kvm_call_hyp and is helpful in non-VHE case.
> 
> For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
> to toggle the TGE bit with a RMW sequence, as we already do in
> __tlb_switch_to_guest_vhe().
> 
> The value of hcr_el2 is now stored in struct kvm_cpu_context as both host
> and guest can now use this field in a common way.

These HCR_EL2 flags have had me confused for quite a while.
I thought this was preserving the value that head.S or cpufeature.c had set, and with
ptrauth we couldn't know what this register should be anymore, the host flags has to vary.

Kristina's explanation of it[0], clarified things, and with a bit more digging it appears
we always set API/APK, even if the hardware doesn't support the feature (as its harmless).
So we don't need to vary the host flags...

My question is, what breaks if this patch isn't merged? (the MDCR change is cleanup we can
do because of this HCR change), is this HCR change just cleanup too? If so, can we merge
ptrauth without either, so we only make the change when its needed? (it will cause some
changes in your patch 7, but I can't see where you depend on the host flags).

I recall Christoffer wanting to keep the restored DAIF register value on guest-exit static
to avoid extra loads/stores when we know what the value would be. I think the same logic
applies here.

You mentioned in the cover letter the series has some history to it!


Thanks,

James

[0] http://lore.kernel.org/r/7ec2f950-7587-5ecd-6caa-c2fd091ad22c@arm.com
