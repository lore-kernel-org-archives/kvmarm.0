Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9B83D9031;
	Fri, 10 Apr 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833921; cv=none; b=JugoKSMTRB0cYQH8qqzsTTkZkgSOcl977uZwpg5Cyrn4oMxe/6RgEK/PyK+/F5MthmjA6RwGcd5ORanlaSTa2uCqbB/P6cQOWbhlx6O+0MYWZS7+R8Dqqn/Ppoz/qNo1NGLxVZwKGIWNzrnxH7ZiKiJUaPOvZQZEkempxknOcSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833921; c=relaxed/simple;
	bh=mfZ7HV7qOdJ4SYmi9ANL32i5NeQMgCmP8MyF+qFXJPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T05lyuf6DNAEwD2HgRfNhxXaXm7iwRkZW+cn7yNOk8hc/xpPB/RO0lKx5W/ju9o0AjViYJPqvfawTCELp6CN8Yf1pzBX9lH7JqiLKwORU/waJfO6IKMOaqQcrGHxUc2EeKCPba0Sfxu4vwTxNrGO6+fOlOiK4qQvYSAJ3Tj4w8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AyxViiHB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AyxViiHB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF6073543;
	Fri, 10 Apr 2026 08:11:53 -0700 (PDT)
Received: from [10.1.29.18] (e122027.cambridge.arm.com [10.1.29.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C44743FAA1;
	Fri, 10 Apr 2026 08:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775833919; bh=mfZ7HV7qOdJ4SYmi9ANL32i5NeQMgCmP8MyF+qFXJPM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AyxViiHBDTJMe09anT05P8KCOR+UkoSMxjgP54ID7bmaEz0IJ8qgxDZzrfPPnmhju
	 oIj3ZBOQaxAdcEMThJNMzmKBfEwoxraWqCPGU8mo9t8KlW97mznJGEMOLdcFdwkWnj
	 QVdNdClinPqrUv00O5rMgY46Mb1kZiT5ypjR3dDk=
Message-ID: <ac4e789d-1906-4447-8e98-f6878a513f3d@arm.com>
Date: Fri, 10 Apr 2026 16:11:54 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 20/48] arm64: RMI: Handle realm enter/exit
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-21-steven.price@arm.com>
 <8929a008-0991-4e3c-98a1-f00af47dd0ff@arm.com>
 <02582577-3701-4d5c-88c6-3ce0b3328377@arm.com>
 <c4e30ad1-6fbe-448f-a9fe-6a2480581082@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <c4e30ad1-6fbe-448f-a9fe-6a2480581082@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/03/2026 10:03, Suzuki K Poulose wrote:
> On 20/03/2026 16:32, Steven Price wrote:
>> On 20/03/2026 14:08, Suzuki K Poulose wrote:
>>> On 18/03/2026 15:53, Steven Price wrote:

[...]

>>>> +int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>>> +    int ret;
>>>> +
>>>> +    guest_state_enter_irqoff();
>>>> +    ret = rmi_rec_enter(virt_to_phys(rec->rec_page),
>>>> +                virt_to_phys(rec->run));
>>>
>>> In the normal VM case, we try to fixup some of the exits (e.g., GIC
>>> CPUIF register accesses) which may be applicable to Realms. Do we
>>> need such fixups here ? Given the cost of world switch, it is
>>> debatable whether it matters or not.
>>
>> I'm not really sure what you are referring to here. Can you point me at
>> the normal VM case? This function is the equivalent of
>> kvm_arm_vcpu_enter_exit().
> 
> This happens via fixup_guest_exit() in either vhe/nvhe cases. The VGIC
> registers are emulated in the fast path for normal VMs (when trapping is
> enabled)

Ah, I see what you mean. Yes the VGIC emulation in theory could be
shortcut and speeded up slightly. I'd prefer to leave this sort of pure
optimisation until the basic support is merged to keep the size of the
series (vaguely) under control.

I think it would also be worth doing some benchmarking on a real
platform to see whether it really makes a meaningful difference (or
whether we need to push for an architectural change moving more
processing into the RMM).

Thanks,
Steve

