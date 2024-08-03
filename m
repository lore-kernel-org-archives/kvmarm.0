Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949BD1ABEA7
	for <kvmarm@lists.linux.dev>; Sat,  3 Aug 2024 10:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722681533; cv=none; b=ZwZY0zU5a5NW4APzarKDdygBMKhtK3Upukt9iJrZgH8WgXuM9chCqVJF5RZTuPsNA8PegZOsoaf+/hd0K4P4812kAa8+BsP2hbuzGhjgCyZ9mx988GJsjhXOcRTggZyaImldlj4HvK4Zniz1DVCJMMXbL40TZOQYWOUy4vAIi9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722681533; c=relaxed/simple;
	bh=YGq3TVZtqJrXxBplwOG85CUfLYaIn/S8Akul9NrisN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eSc3ZoH2QWK6OZ4CgJ4zz13X9DwCswiBCSZrvfNtn4P0i0dJ3QIKC5ruEcZyJT5dedUOvTKAtRh4fNb2FBs8qLsQ7MfPfKuDqo+UhW7aIAPj2pwG+LBcBy/Z22BiYLyxqD34yvHaQnu1jfu9CfEuctdYdRc6yQNR6TeE/HbfpxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED00DDA7;
	Sat,  3 Aug 2024 03:39:09 -0700 (PDT)
Received: from [10.163.57.20] (unknown [10.163.57.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EB953F64C;
	Sat,  3 Aug 2024 03:38:16 -0700 (PDT)
Message-ID: <fb9bef18-adf2-4d3a-8205-b22a65b0c6db@arm.com>
Date: Sat, 3 Aug 2024 16:08:11 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 10/10] KVM: arm64: nv: Add new HDFGRTR2_GROUP &
 HDFGRTR2_GROUP based FGU handling
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240620065807.151540-1-anshuman.khandual@arm.com>
 <20240620065807.151540-11-anshuman.khandual@arm.com>
 <865xu3kh4r.wl-maz@kernel.org> <4d256df7-1ec7-4300-b5c8-355f46c0e869@arm.com>
 <878qyy35e5.wl-maz@kernel.org> <47dc4299-52cc-4f98-929b-fb86bd9757ae@arm.com>
 <86tthhi0nz.wl-maz@kernel.org> <c84d0081-5afa-4bc2-82f4-a6dd07b8ab87@arm.com>
 <86o76c1b8p.wl-maz@kernel.org> <d56735e2-3fee-4d91-84e1-a5b480ec0ce1@arm.com>
 <86bk2b198o.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <86bk2b198o.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/2/24 16:29, Marc Zyngier wrote:
> On Fri, 02 Aug 2024 10:25:44 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> On 8/1/24 21:33, Marc Zyngier wrote:
>>> On Thu, 01 Aug 2024 11:46:22 +0100,
>>> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
> [...]
> 
>>>> +	SR_FGT(SYS_SPMACCESSR_EL1,	HDFGRTR2, nSPMACCESSR_EL1, 0),
>>>
>>> This (and I take it most of the stuff here) is also gated by
>>> MDCR_EL2.SPM, which is a coarse grained trap. That needs to be
>>> described as well. For every new register that you add here.
>>
>> I did not find a SPM field in MDCR_EL2 either in latest ARM ARM or in
>> the latest XML. But as per current HDFGRTR2_EL2 description the field
>> nSPMACCESSR_EL1 is gated by FEAT_SPMU feature, which is being checked
>> via ID_AA64DFR1_EL1.PMU when required. So could you please give some
>> more details.
> 
> I misspelled it. It is MDCR_EL2.EnSPM.
> 
> And you are completely missing the point. It is not about
> HDFGRTR2_EL2, but about SPMACCESSR_EL1 (and all its little friends).
> 
> To convince yourself, just look at the pseudocode for SPMACCESSR_EL1,
> limited to an EL1 access:
> 
> elsif PSTATE.EL == EL1 then
>     if HaveEL(EL3) && EL3SDDUndefPriority() && MDCR_EL3.EnPM2 == '0' then
>         UNDEFINED;
>     elsif EL2Enabled() && IsFeatureImplemented(FEAT_FGT2) && ((HaveEL(EL3) && SCR_EL3.FGTEn2 == '0') || HDFGRTR2_EL2.nSPMACCESSR_EL1 == '0') then
>         AArch64.SystemAccessTrap(EL2, 0x18);
>     elsif EL2Enabled() && MDCR_EL2.EnSPM == '0' then
>         AArch64.SystemAccessTrap(EL2, 0x18);
>     elsif HaveEL(EL3) && MDCR_EL3.EnPM2 == '0' then
>         if EL3SDDUndef() then
>             UNDEFINED;
>         else
>             AArch64.SystemAccessTrap(EL3, 0x18);
>     elsif EffectiveHCR_EL2_NVx() IN {'111'} then
>         X[t, 64] = NVMem[0x8E8];
>     else
>         X[t, 64] = SPMACCESSR_EL1;
> 
> 
> Can you spot the *TWO* conditions where we take an exception to EL2
> with 0x18 as the EC?
> 
> - One is when HDFGxTR2_EL2.nSPMACCESSR_EL1 == '0': that's a fine
>   grained trap.
> - The other is when MDCR_EL2.EnSPM == '0': that's a coarse grained
>   trap.
> 
> Both conditions need to be captured in the various tables in this
> file, for each and every register that you describe.

Ahh, got it now. Because now KVM knows about SPMACCESSR_EL1 register,
access to that register must also be enabled via both fine grained trap
(HDFGxTR2_EL2.nSPMACCESSR_EL1) and coarse grained trap (MDCR_EL2.EnSPM).

For all the registers that are being added via FEAT_FGT2 here in this
patch, their corresponding CGT based path also needs to be enabled via
corresponding CGT_MDCR_XXX groups.

> 
> [...]
> 
>>> Now, the main issues are that:
>>>
>>> - you're missing the coarse grained trapping for all the stuff you
>>>   have just added. It's not a huge amount of work, but you need, for
>>>   each register, to describe what traps apply to it. The fine grained
>>>   stuff is most, but not all of it. There should be enough of it
>>>   already to guide you through it.
>>
>> Coarse grained trapping for FEAT_FGT2 based fine grained registers ?
> 
> Not for FEAT_FGT2. For the registers that FEAT_FGT2 traps. Can you see
> the difference?

Understood, for example PMIAR_EL1 register which FEAT_FGT2 now traps via

SR_FGT(SYS_PMIAR_EL1,           HDFGRTR2, nPMIAR_EL1, 0),

also needs to have corresponding coarse grained trap.

SR_TRAP(SYS_PMIAR_EL1,          CGT_MDCR_TPM),

Similarly corresponding SR_TRAP() needs to be covered for all registers
that are now being trapped with FEAT_FGT2.

Example code snippet.

........
+       SR_TRAP(SYS_SPMEVFILT2R_EL0(8), CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMEVFILT2R_EL0(9), CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMEVFILT2R_EL0(10),        CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMEVFILT2R_EL0(11),        CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMEVFILT2R_EL0(12),        CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMEVFILT2R_EL0(13),        CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMEVFILT2R_EL0(14),        CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMEVFILT2R_EL0(15),        CGT_MDCR_EnSPM),
+
+       SR_TRAP(SYS_SPMCGCR0_EL1,       CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMCGCR1_EL1,       CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMACCESSR_EL1,     CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMCFGR_EL1,        CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMCNTENCLR_EL0,    CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMCNTENSET_EL0,    CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMCR_EL0,          CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMDEVAFF_EL1,      CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMDEVARCH_EL1,     CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMIIDR_EL1,        CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMINTENCLR_EL1,    CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMINTENSET_EL1,    CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMOVSCLR_EL0,      CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMOVSSET_EL0,      CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMSCR_EL1,         CGT_MDCR_EnSPM),
+       SR_TRAP(SYS_SPMSELR_EL0,        CGT_MDCR_EnSPM),
........

> 
>> Afraid, did not understand this. Could you please give some pointers
>> on similar existing code.
> 
> See above. And if you want some example, just took at the file you are
> patching already. Look at how MDCR_EL2 conditions the trapping of all
> the debug, PMU, AMU registers, for example. There is no shortage of
> them.

Right, I understand your point now. I am planning to send out the following
patches (in reply to the current thread) for your review, before sending out
the entire series as V1.

- Patch adding VNCR details for virtual EL2 access
- Patch adding FEAT_FGT2 based FGU handling
- Patch adding corresponding CGT handling for registers being added above

Although, can skip that step and just send out the series directly if you so
prefer. Please do suggest. Thanks for all the detailed information above.

- Anshuman
