From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: HCPTR cp15 writes need isb?
Date: Wed, 17 Jun 2015 09:38:50 +0100
Message-ID: <5581321A.2060300@arm.com>
References: <557F7D1F.1070308@codeaurora.org>
 <20150616074624.64b7d71c@why.wild-wind.fr.eu.org>
 <558016CE.2050103@codeaurora.org> <55801AF3.3010705@arm.com>
 <55806237.7060405@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E8555CC1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 04:28:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bpm4OfM5RU+0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 04:28:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A00255CA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 04:28:16 -0400 (EDT)
In-Reply-To: <55806237.7060405@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vikram Sethi <vikrams@codeaurora.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "mmcilvai@qti.qualcomm.com" <mmcilvai@qti.qualcomm.com>, "vikrams@qti.qualcomm.com" <vikrams@qti.qualcomm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/06/15 18:51, Vikram Sethi wrote:
> On 06/16/15 07:47, Marc Zyngier wrote:
>> On 16/06/15 13:30, Vikram Sethi wrote:
>>> On 06/16/15 01:46, Marc Zyngier wrote:
>>>> On Tue, 16 Jun 2015 02:34:23 +0100
>>>> Vikram Sethi <vikrams@codeaurora.org> wrote:
>>>>
>>>> Hi Vikram,
>>>>
>>>>> Hi Marc, Christoffer, Catalin, Will,
>>>>>
>>>>> I'm seeing an issue with KVM HCPTR (cp15) writes on guest entry/exit
>>>>> on one of Qualcomm's CPU cores in AArch32 host and AArch32 guest
>>>>> mode. Our CPU architects believe that HCPTR cp15 writes are context
>>>>> changing and require an isb. With an isb in set_hcptr macro in
>>>>> arch/arm/kvm/interrupts_head.S I am able to boot the Aarch32 guest,
>>>>> but without it, I see strange crashes to hyp_undef or hyp_pabt.
>>>> [...]
>>>>
>>>> Can you look at the following patch (queued for 4.2)?
>>>>
>>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-March/330955.html
>>>>
>>>> Please let me know if this solves the issue you are seeing.
>>> Don't we have the same issue the first time guest touches FP and
>>> traps i.e in switch_to_guest_vfp where we turn on floating point
>>> access in HCPTR and immediately access FPEXC in store_vfp_state
>>> without a isb?
>> Good point, looks like my initial fix is incomplete. I'll repost a more
>> complete fix but in the meantime, does adding the following work for you?
> Yes, the additional isb in switch_to_guest_vfp along with your original patch works for me.
> When you refactor the original patch will it be cleaner to handle the
> isb in the set_hcptr macro whenever it is changed to not trap VFP
> access?

That's what I have done, but the result is a bit awkward, so I'm in two
minds about it. I'll post it in a minute, please check that it still
works for you (though I've checked that the generated code is the same).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
