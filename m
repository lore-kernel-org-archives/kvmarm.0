Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792482253;
	b=qkLfYO4O0BE5mY2G3gCU/cWA2lQ6H4cFLHZ5s1tXJly4iY/BadQekovP8dUMnZ7e65kS
	 jRwmS+YGDvCTqiVQTtcOHPl0YRDJHCRicTRwKT2e7HQPblDVv1CuYdtHMzHvYGvowI8rL
	 xjr33dvN76rP93S2uoNrCaR09AjptuO6jasWbs7fXYlGiWjzJQ2DHwprPJbpXsq1jgMwz
	 uQ0mWUBinQiOIhyeRuY790X3oKGBslzRoX4g4RV5gJEfuo+5Nz7BLfzURWM5Yhc15CSlv
	 2AsQzjvEysQa8jEwxIYm+twnd289Sj3BUj0B09kn5ZRE+Gr5w7cPlek96+A05edWw5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482253;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=LfoOhm00iP//E0N4F9AlbSUJTf43+auw00OGwsKyDj8=;
	b=UytfoUiRg8mBHsXjz6UjBZOYQEwc6hpv1BbZyrkmlwYgYDjVs9QojT98NW/UZ4ClFVd2
	 E42qKwApLVf73wnmXDsmuo6W/ctiAFTfLRR0WYhvC84Hk6eKUYYhWvyNAAbhtWsppBs5D
	 052gOgayhJWr732vcihfh4OAtn4YgVGbNdt3OOPf7RfPz/jbQF8d3Nl7WJqYcS0I6mEi9
	 kM5VSzqoIGaZUZ/tJYftuaXF4QGRPMD6BjLuXHTgLhEMuEEoLKQnEynHLZnJ/Ek3GXUYB
	 nCexGUsl/FBhJZBnCr6ZAM2MW8UsyzALVzFMGe2LYnBCydCWZZ6BZB69JGDuoV39DAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OgkQUeEp;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17855606A31D
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 07:44:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17855606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OgkQUeEp
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F1AF1595;
	Tue, 20 Oct 2026 00:44:09 -0700 (PDT)
Received: from [10.0.136.108] (M0PRX50XMG.cambridge.arm.com [10.0.136.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFBA13F7B4;
	Tue, 20 Oct 2026 00:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792482252; bh=2c18fozBhrsSmOpHTh00ZE2k6HIbTfIxp8a4vEnkaO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OgkQUeEpqjp95Q9MtHaL/sbEWU+qgni+fsviK1MMEa+vnKCPyN3p8tNRbHHF5CWHU
	 BoidisyAu8NDjn3lHNyAE2lbiO0T49D7NCLcadhPb/2fc2bsOlX++IMQWKGZ3UoTVu
	 FKQtQy4BQ32NisE2mBlmacmU6AIjOmy1ErWGmIDw=
Message-ID: <a87f0a59-f71f-4583-8ace-394f9af649e5@arm.com>
Date: Tue, 20 Oct 2026 08:44:09 +0100
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
Subject: Re: [PATCH v2 1/2] KVM: arm64: vgic: Require matching VGIC model for
 GICv3 ITS
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
References: <20261019134242.1289002-1-sascha.bischoff@arm.com>
 <20261019134242.1289002-2-sascha.bischoff@arm.com>
 <CA+EHjTzqKiWr2tnV0rUiA4VVCs5a0E2XQQTdwvH0bTKZ5dxe5A@mail.gmail.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <CA+EHjTzqKiWr2tnV0rUiA4VVCs5a0E2XQQTdwvH0bTKZ5dxe5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 19/10/2026 16:32, Fuad Tabba wrote:
> Hi Sascha,
> 
> On Mon, 19 Oct 2026 14:42:41 +0100, Sascha Bischoff
> <sascha.bischoff@arm.com> wrote:
>> On a GICv5 host with legacy support, KVM registers both VGICv3 and
>> VGICv5 devices. Without a model check, a VM can create a GICv3 ITS
>> alongside an incompatible VGIC, regardless of creation order.
> 
> Could you add to the commit message that the new checks apply on every
> host? A GICv2 VGIC and an ITS, in either order, now fail with -ENODEV,
> where before both were created and the ITS was ignored.

Ah, that's a good point (and a situation that hadn't properly clicked in 
my head). I'll absolutely update it.

> 
> [...]
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> [...]
>> @@ -42,10 +42,7 @@ bool vgic_has_its(struct kvm *kvm)
>>   {
>>           struct vgic_dist *dist = &kvm->arch.vgic;
>>
>> -        if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
>> -                return false;
>> -
>> -        return dist->has_its;
>> +        return !!dist->its_model;
>>   }
> 
> I think this should check vgic_model as well, as Sashiko raised [1].

Yeah, Sashiko and you have raised a valid point here.

> vgic_its_create() accepts an ITS when there's no in-kernel VGIC, and
> the VM can then run with a userspace irqchip. On a GICv4.0 host,
> kvm_vgic_flush_hwstate() then calls vgic_v4_commit() on every entry,
> for a vPE that vgic_v4_init() never set up. irq_set_vcpu_affinity()
> fails on irq 0 and the error is ignored, so nothing crashes, but this
> patch makes that path reachable. The MSI paths Sashiko lists are fine,
> since KVM_SIGNAL_MSI requires an in-kernel irqchip and irqfd an
> initialised VGIC.
> 
> Something like this would keep the 0 == 0 case you pointed out for
> Marc's version false:
> 
>          return dist->its_model && dist->its_model == dist->vgic_model;

Foolishly, this was the variant I'd dismissed as it returns false until 
vgic_model is set. However, I guess that is the behaviour we want here. 
An ITS is only a valid ITS if the model matches.

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/sashiko-outbox-177254@kernel.org/

Thank you!
Sascha

