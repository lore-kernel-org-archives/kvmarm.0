Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6453E275870
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777648085; cv=none; b=YkX/lbIAQPFd8JJo6FW5NbBet6pPgLqmzzK2fgC2dK5dDUZYJiaHPMnnWVfwIf7QfdGgQyLFFiEJoZYZiBmOQZ9WgJAEc5GpaRQd1gbs2UwsLGEktheuanqoQsTrx9y5Ssyb8qE6lzBanUKuvTfPQZCRgMleD5ySoq0+VnV/3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777648085; c=relaxed/simple;
	bh=qoDHNXdsi0DnZC69MMDvUsZgKnEB5TOrg4oNxq6awUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nytGBvCzdVZAjnA4ubSlfYB3CI1KPb0gO/N7Pz0MasGUc6SviVq5Ab/+PCu5Afm0PpzqQF7hxkEFrVL1vOnMtgrfCDpG8gYf6he+GATxVtJJ44FmAxQeWB8OkUVnkCBu8yAH8FrAVY8fnWF4e+82vc1CWIkEw/2ofiTxPZs1UT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CCvnpVsx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CCvnpVsx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F84F2A9A;
	Fri,  1 May 2026 08:07:57 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A3B8E3F62B;
	Fri,  1 May 2026 08:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777648082; bh=qoDHNXdsi0DnZC69MMDvUsZgKnEB5TOrg4oNxq6awUE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CCvnpVsxMfxf3cRxVy+bhKHRxeQOta7hKclZr4AjTfXE5bDghZ+yEodChYsAQgZIj
	 RffENUr9wfbHxS8fO3NS8hJsd40zjbjcYBH1QYZTzTilQe/l8HmOaSBDrnzRXJkWGX
	 Wtu4ezb75gn1o5JrkPjFlClmw2jdZbsuJCY9Ewz4=
Message-ID: <b1be5378-1835-417c-aee5-c92253b340d0@arm.com>
Date: Fri, 1 May 2026 16:07:59 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v2 1/6] KVM: arm64: Make EL2 exception entry and exit
 context-synchronization events
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com,
 vdonnefort@google.com, catalin.marinas@arm.com, will@kernel.org,
 yaoyuan@linux.alibaba.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260501112149.2824881-1-tabba@google.com>
 <20260501112149.2824881-2-tabba@google.com>
 <a7e2ac96-b710-40e5-a159-b49555bcf518@arm.com>
 <CA+EHjTwgUF4AEw6WvxPiwMTtrTUEs1NjjuKso+VBChon2cdozQ@mail.gmail.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <CA+EHjTwgUF4AEw6WvxPiwMTtrTUEs1NjjuKso+VBChon2cdozQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 5/1/26 16:01, Fuad Tabba wrote:
> Hi Ben,
> 
> On Fri, 1 May 2026 at 14:47, Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> Hi Fuad,
>>
>> On 5/1/26 12:21, Fuad Tabba wrote:
>>> SCTLR_EL2.EIS and SCTLR_EL2.EOS control whether exception entry and
>>> exit at EL2 are Context Synchronisation Events (CSEs). Per ARM DDI
>>> 0487 M.b D24.2.175 (p. D24-9754):
>>>
>>>   - !FEAT_ExS: the bit is RES1, so the entry/exit is unconditionally
>>>     a CSE.
>>>   - FEAT_ExS: the reset value is architecturally UNKNOWN; software
>>>     must set the bit to make the entry/exit a CSE.
>>>
>>> INIT_SCTLR_EL2_MMU_ON in arch/arm64/include/asm/sysreg.h sets neither
>>> bit. KVM/arm64 hot paths rely on ERET from EL2 being a CSE, and on
>>> synchronous EL1->EL2 entry being a CSE, to elide explicit ISBs after
>>> MSRs to context-switching system registers (HCR_EL2, ZCR_EL2,
>>> ptrauth keys, etc.). On FEAT_ExS hardware those reliances are not
>>> architecturally backed unless EOS=1 (and, for entry, EIS=1).
>>>
>>> Until commit 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg
>>> infrastructure"), SCTLR_EL2_RES1 was a hand-rolled mask that
>>> included BIT(11) (EOS) and BIT(22) (EIS), so INIT_SCTLR_EL2_MMU_ON
>>> was setting both unconditionally. The conversion made
>>> SCTLR_EL2_RES1 auto-generated; because the sysreg tooling only
>>> models unconditionally-RES1 fields and EIS/EOS are RES1 only when
>>> FEAT_ExS is absent, the auto-generated mask is UL(0). The seven
>>> other bits dropped from the old mask (positions 4, 5, 16, 18, 23,
>>> 28, 29) are unconditionally RES1 in the E2H=0 SCTLR_EL2 layout per
>>> DDI 0487 M.b D24.2.175, so dropping them is harmless. EIS and EOS
>>> are the only bits whose semantics changed for FEAT_ExS hardware
>>> and where the kernel relies on the value being 1.
>>>
>>> Make the guarantee explicit: include SCTLR_ELx_EIS | SCTLR_ELx_EOS in
>>> INIT_SCTLR_EL2_MMU_ON so that EL2 exception entry and exit are
>>> unconditionally CSEs regardless of whether FEAT_ExS is implemented.
>>> This matches the pairing in arch/arm64/kvm/config.c which treats EIS
>>> and EOS together as RES1 under !FEAT_ExS.
>>
>> In v1 you also had this sentence:
>>
>> "INIT_SCTLR_EL2_MMU_OFF is left unchanged: that path is used during
>> very early EL2 init and the EL2 MMU-off transition, neither of which
>> relies on these bits in the same way."
>>
>> To me, it seems useful to keep that sentence as it makes it clear that INIT_SCTLR_EL2_MMU_OFF is purposely not changed.
>> Or is there a reason why you dropped it? Perhaps it's just obvious to people more familiar with this code.
> 
> To be honest, I thought the commit message was quite long, and I
> wanted to make it a bit more concise. I could re-introduce it if you
> think it's helpful.

I don't really mind but it was useful in helping me understand your change.

Thanks,

Ben
