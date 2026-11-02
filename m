Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652029;
	b=ElJiXTBwemYe28LaB49DaWm4EcRSRICYq0Pp1wjzHdmmN94uyiyl4FuQZuPtywdjKB4u
	 OeQKTzJ7WVtuHGyaCS3IiJKo5YV1EYhpr//gZoZZDZa3+qTGo8XR4DNGqbCqzcowk+C7B
	 fJTp9fgauLCI+0gGvWnw9j5/GdzuNuDhk/KRsahTScC8xHyu4F77HkAx4eilscjQOj5u2
	 QjFqM7BFHJHfyrTbFUMxP+AmTLAncmYW+GNEsXZ/1sRHyEvAqXN2XJc7CHtlkR2FJ38Qo
	 2AE95KSqiIOCCck2uxa8Q2EOxN+HMuhdEE8YoXdgGU4CDFxfYvCwsj2LbA3cZkWqe1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652029;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=tYy2Ku4xegZqnpb2I1Vkofx7a7V4Wnlk/wyQiLH6WOM=;
	b=v0oZabYQpUaSSQUKucIJqxUB6Pb2/MftyqAPTxDo9RuR5+hqt4cxa1ueJ5ijU3UOhweG
	 DipIehrwI4rRi0AwGNNkU82tMu1n9+xizwEIPhBVAiA7gnQJtKhpcFBcNlfNYHP2/GxM1
	 5NIY5FWOSC9dBkeELoitVeoXb3Whnk30vxyQg6ED1EuSiHRfLxy7RLi+0vATV4y3cScgP
	 PQrYyWt9NoOyLnEoqQZxg1+pO9Hn37dHJ+VDCSgiP+8PrS+WP3jKt+N6KaDmpvUI+7tJR
	 oHcD+IhsNpPMyvFXGiXxcY44vJojedB5V+Vt1r1wQCTAALOpfb6E8AkSAvSLVZKR2Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BXGpf9zn;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC04606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AC04606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BXGpf9zn
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B84916A3;
	Mon,  2 Nov 2026 12:40:24 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60D473F59E;
	Mon,  2 Nov 2026 12:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793652027; bh=Al3MzymMSlrWFMZrAzyd8qpQMKaF7iqTXVesurs2tQ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BXGpf9znMXiBy/aUiVFFwoePYTHrv2TnzJNeA8bzzRZ/6cR9ep7AiNLgj/CTi9zPK
	 /bVriCa8rbZpJ5L2ne8LKzjaVJLalQ87NAbSPKhni08AlQ+vgAth+rSBF6EeBzS8d3
	 71a78kN6A4pa4PENsCl3t/rZlkXxt3ymfWA76RaY=
Message-ID: <c8164a81-5481-4372-99fc-ce3756930d5f@arm.com>
Date: Mon, 2 Nov 2026 20:40:24 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v3 08/21] arm64: Define GICv5 interrupt types
To: Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-9-sascha.bischoff@arm.com>
 <a754d5cb-dc7f-49f9-a815-98efa3d57574@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <a754d5cb-dc7f-49f9-a815-98efa3d57574@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/10/2026 19:28, Vladimir Murzin wrote:
> On 10/16/26 16:39, Sascha Bischoff wrote:
>> Define the PPI and SPI type values used by GICv5 interrupt specifiers,
>> and the type-field shift used to construct a full GICv5 INTID for
>> KVM's PMU IRQ attribute.
>>
>> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
>> ---
>>   arm64/include/kvm/gic.h | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
>> index 991aa912..bef871be 100644
>> --- a/arm64/include/kvm/gic.h
>> +++ b/arm64/include/kvm/gic.h
>> @@ -10,6 +10,10 @@
>>   #define GIC_FDT_IRQ_TYPE_SPI		0
>>   #define GIC_FDT_IRQ_TYPE_PPI		1
>>   
>> +#define GICV5_IRQ_TYPE_PPI		1
>> +#define GICV5_IRQ_TYPE_SPI		3
>> +#define GICV5_IRQ_TYPE_SHIFT		29
>> +
> 

Hi Vladimir,

> Can we also add
> 
> #define GICV5_FDT_IRQ_TYPE_PPI          GICV5_IRQ_TYPE_PPI
> #define GICV5_FDT_IRQ_TYPE_SPI          GICV5_IRQ_TYPE_SPI
> 

Yes, we can and I have.

> since seeing both GIC_FDT_IRQ_... and GICV5_IRQ_... back to
> back in FDT code is slightly confusing.

Yeah, agreed. For GICv5, they're both the same, but we might as well be 
explicit about how they are used and assuage any doubts that the reader 
might have.

I've made sure to use the _FDT_ variant when we're configuring the DT, 
and the non-_FDT_ variant otherwise.

> 
> Cheers
> Vladimir
> 
>>   #define GIC_FDT_IRQ_PPI_CPU_SHIFT	8
>>   #define GIC_FDT_IRQ_PPI_CPU_MASK	(0xff << GIC_FDT_IRQ_PPI_CPU_SHIFT)
>>   
>> -- 2.34.1
>>
> 

Thanks,
Sascha
