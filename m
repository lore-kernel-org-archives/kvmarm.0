Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635F21A294
	for <kvmarm@lists.linux.dev>; Fri, 22 Aug 2025 01:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755827657; cv=none; b=mUdTohJ0QG5Js0GcX5WrQoJkgVTWZ8D4akDQyn9acM/6Fy2ZRRq0+440U1+0Y9nufDMd3e6Wj34NevdtkSg/DkRjs6G2O/QcXD5LYrp/43V/1SIGfmFOg7jsr6ooT1IR/sQdZ7ddBpsBT9rohEVvL5E4hQXgDTRmCgcOsIDl6T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755827657; c=relaxed/simple;
	bh=/1/QWLsLvRtdrhrDAVpUpcNbke1YQ3duino1v3jonrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tS2qMPDn5ec2/cp1Dkfd6aWNnDr5zSPpsxd4PTn2B6cV/Ug0VN8WXZwPxYRp8CCuQyS9ZcatPY9j+hDHX/KB71HhFsXM9fFZHCBq+L3H2/x/y//NfTdrq3M0F3tBhacz9TLVODpw47KH3Agu9N+kW7njHkZMAPGcoePUKgaj/vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c7NYV2nMrz27jGQ;
	Fri, 22 Aug 2025 09:55:10 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id B807E1A0171;
	Fri, 22 Aug 2025 09:54:04 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 09:54:04 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 09:54:03 +0800
Message-ID: <996453bb-fc9a-9606-afec-3f322fa50b27@hisilicon.com>
Date: Fri, 22 Aug 2025 09:54:03 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 3/6] KVM: arm64: vgic-v3: Allow access to GICD_IIDR
 prior to initialization
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
	jiangkunkun <jiangkunkun@huawei.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-4-oliver.upton@linux.dev>
 <de355a64-01f6-cbc5-7a88-5f57687d5fb8@hisilicon.com>
 <aKdo3aIxN6-RKVtA@linux.dev>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <aKdo3aIxN6-RKVtA@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/8/22 2:43, Oliver Upton wrote:
> On Thu, Aug 21, 2025 at 06:55:13PM +0800, Zhou Wang wrote:
>> On 2025/7/10 5:14, Oliver Upton wrote:
>>> KVM allows userspace to write GICD_IIDR for backwards-compatibility with
>>> older kernels, where new implementation revisions have new features.
>>> Unfortunately this is allowed to happen at runtime, and ripping features
>>> out from underneath a running guest is a terrible idea.
>>>
>>> While we can't do anything about the ABI, prepare for more ID-like
>>> registers by allowing access to GICD_IIDR prior to VGIC initialization.
>>> Subsequent changes will allow the VMM to further provision the GIC
>>> feature set, e.g. the presence of nASSGIcap.
>>>
>>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-init.c       |  9 +--------
>>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 20 +++++++++++++++++++-
>>>  2 files changed, 20 insertions(+), 9 deletions(-)
>>>
>> [...]
>>>  /*
>>>   * vgic_v3_attr_regs_access - allows user space to access VGIC v3 state
>>>   *
>>> @@ -552,7 +570,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>>>  
>>>  	mutex_lock(&dev->kvm->arch.config_lock);
>>>  
>>> -	if (!vgic_initialized(dev->kvm)) {
>>> +	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
>>
>> I am confused here, the logic is that:
>>
>> 1. For the ID registers, they can not be modified after vGIC init.
>> 2. For other registers, the original logic is that they should be modified after
>>    vGIC init.
>>
>> So code here should be:
>>
>> if ((reg_allowed_pre_init(attr) && vgic_initialized(dev->kvm)) ||
>>     !vgic_initialized(dev->kvm)) {
>>          ret = -EBUSY;
>>          goto out;
>> }
>>
>> Not sure my understanding is right.
> 
> This would break ABI which I tried to allude to in the changelog.
> GICD_IIDR is _already_ writable post-init, meaning that the only option
> we have is to relax that register and allow access pre- and post-init.>
> The preferred semantics around ID registers is that they're RW prior to
> init and RO post-init. GICD_TYPER2 enforces this.

Hi Oliver,

I got your idea, many thanks for your help.

Best,
Zhou

> 
> Thanks,
> Oliver
> .
