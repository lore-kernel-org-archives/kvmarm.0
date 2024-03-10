Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC88381B9
	for <kvmarm@lists.linux.dev>; Sun, 10 Mar 2024 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710084488; cv=none; b=dPCLOiuY9Sle1mOoTa+rlZ0GsCQwxLvP5oNWynJz012XpK3EfN/H/HjHfphTOvG8ddk3/cDjaI7cPeqlH/sU1ZRShpMhb6PWLzukxgWpSNy82VKuQ5v5yMCROio3WmRnnD5wVaUt6EeIDuzJ1txjfg26BHWOOeCIRkXVtpRpkuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710084488; c=relaxed/simple;
	bh=meFcHg2gEzIQ8mtvjRW7YDi2YskqelxfbVKBQ7mDQsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QnnUtW5ELtvQVmoMCxzfNcjxuZNoxDooBZbLDtuOUxulP26PAXbAgNtbq1KBxr4jJKNLZPBA5C0HvDluVviw7OQu3ylW5Vu+PDP2Y1NlxOGuMUG6PKILyj5Zm8D2+c1mCu64GOdDDLsn6BPtxWxYqzRwkBSOtXMJ48ew9FNZOqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rQSW0jNO; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rQSW0jNO"
Message-ID: <c08a1a77-1058-8586-2607-026de86fd67e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710084483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ngH8uhVVVlDBHAMIl0c4yxK52ZZuA4rZsboMyTbY3gI=;
	b=rQSW0jNOXMahGVXAQnGXnJ+JhASyyBUqSsXzR7MBb9mLqYZpRHPThNWGQpX0qex+dZaW6u
	rmDNO6Fx9c0j1s2cCBmLFOyJwfu9iLUymHKquRHRWEIapmazUcVwZdLWSusInvdJbb7nyy
	amQTQpQMa52kDEcu1KC9Br05UcTg74Q=
Date: Sun, 10 Mar 2024 23:27:29 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Don't load pending state when
 enabling LPIs on RD
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, Oliver Upton <oliver.upton@linux.dev>,
 kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Eric Auger <eric.auger@redhat.com>
References: <20240228000117.2297982-1-oliver.upton@linux.dev>
 <db2920fd-9fe8-1ff4-3f00-34dc4afdcdd5@huawei.com>
 <86o7bq1hhd.wl-maz@kernel.org>
 <453f7cef-2b53-ccc6-40d2-6e147353f220@huawei.com>
 <86le6u178m.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <86le6u178m.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/3/7 21:50, Marc Zyngier wrote:
> On Thu, 07 Mar 2024 12:13:43 +0000,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> Hi Marc,
>>
>> On 2024/3/7 18:09, Marc Zyngier wrote:
>>> Hi Zenghui,
>>>
>>> On Thu, 07 Mar 2024 09:00:42 +0000,
>>> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>>>
>>>> So I've tested it with kvm-unit-tests and got failure with the
>>>> its-pending-migration case:
>>>>
>>>> INFO: gicv3: its-pending-migration: Migration complete
>>>> INFO: gicv3: its-pending-migration: expected 128 LPIs on PE #30, 0 observed
>>>> FAIL: gicv3: its-pending-migration: 128 LPIs on both PE0 and PE1 after
>>>> migration
>>>> SUMMARY: 1 tests, 1 unexpected failures
>>>>
>>>> where the guest SW directly writes to the pending table when
>>>> GICR_CTLR.EnableLPIs == 0. I seriously doubt there is any use case like
>>>> that in real world. But not sure whether it is a funky behaviour from
>>>> the architectural perspective.
>>>
>>> Right, so this is *exactly* the thing I was worried about. A mapping
>>> has been established, the interrupt wasn't pending, all good. Now, an
>>> interrupt lands while GICR_CTLR.EnableLPIs == 0.
>>>
>>> The spec says (4.7.3 "Effect of disabling interrupts")
>>>
>>>   "When GICR_CTLR.EnableLPIs == 0, LPIs are never set pending."
>>>
>>> which to me is a pretty damning indication that we shouldn't take
>>> these bits into account.
>>
>> Ah, thanks for pointing it out! And I believe this is the rationale of
>> Oliver's patch.
>>
>> What confused me is that the spec also says (5.1.2 "LPI Pending tables")
>>
>> | "For physical LPIs, when GICR_CTLR.EnableLPIs is changed to 1, the
>> |  Redistributor must read the pending status of the physical LPIs from
>> |  the physical LPI Pending table."
>>
>> which implicitly indicates that the pending table can contain some
>> pending bits (=1) when EnableLPIs == 0, which would be loaded by RD and
>> make the relevant LPIs pending when EnableLPIs is written from 0 to 1.
>>
>> I have no idea how to interpret these rules ;-) .
> 
> Yeah, even after all this time, the GICv3 spec never fails to
> entertain.  My take on this is that it is there to support the
> different ways to build a GICv3:
> 
> - either RDs are completely independent of the ITSs, and only deal
>   with the forwarding of enabled interrupts. In this case, setting
>   EnableLPIs to 1 would naturally lead to interrupt being forwarded to
>   the CPU. New bits are not allowed to be made pending while it is set
>   to 0 though, which matches 4.7.3.
> 
> - or RDs and ITSs are pretty monolithic, and the GIC infrastructure as
>   a whole maintain the pending state as a result of a translation, not
>   as a set of bits in the pending tables. In this case, EnableLPIs
>   gates the translation process and there are no new pending bits
>   being produced when it is set to 0. We can easily satisfy 5.1.2 by
>   not having created new pending bits.
> 
> So the two rules are more or less correct. They just are saying that
> it is IMPDEF what happens in this case, which is pretty damming for an
> interrupt controller architecture. I feel dirty just having to think
> of these things!

Me too.. Hey, thanks for sharing your thoughts!

Zenghui
