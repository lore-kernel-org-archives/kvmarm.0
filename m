Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2EB2ED17C
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 10:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755773749; cv=none; b=ICcZbWA/zrRhE9x7S6P9KC1Xh3hyXAN1wHMdF6TPDivju/yP/bB6NWFeSMZ1djK+S4TI1FAnJYec8lpjXffLffhZldwQvyl/2lokeNHV+KbsDRV+8UYC9I+ZAvWacrWZpUFfF8NSZio9OBIUrOFqWq5ofgwdDr9l//EgMvnZa/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755773749; c=relaxed/simple;
	bh=vSowepKw8Ryt0NuXgAWRakxcuhgjM/DtykqDnbHXwWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=f/kNA8JmH8Vgtdcgk5AvdCBU7B4XvpxWdshEufGiMibO74DWJTMKv1CJH58aWdab8VI2ortoTVs1ANThq6Yzrj2zLGvZZhxvxRoM7SVkI3O1Zjr5BB51WIo4Of+s7B224b8ILEx44VvFSIVZrXMIywrsqKcS1jtYFBGJBfjF6DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c70XD5X71z2VRJ7;
	Thu, 21 Aug 2025 18:52:44 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E2811A0188;
	Thu, 21 Aug 2025 18:55:35 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 18:55:34 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 18:55:34 +0800
Message-ID: <de355a64-01f6-cbc5-7a88-5f57687d5fb8@hisilicon.com>
Date: Thu, 21 Aug 2025 18:55:13 +0800
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
To: Oliver Upton <oliver.upton@linux.dev>, <kvmarm@lists.linux.dev>
CC: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, "Suzuki K
 Poulose" <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>, jiangkunkun
	<jiangkunkun@huawei.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-4-oliver.upton@linux.dev>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <20250709211417.2074487-4-oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/7/10 5:14, Oliver Upton wrote:
> KVM allows userspace to write GICD_IIDR for backwards-compatibility with
> older kernels, where new implementation revisions have new features.
> Unfortunately this is allowed to happen at runtime, and ripping features
> out from underneath a running guest is a terrible idea.
> 
> While we can't do anything about the ABI, prepare for more ID-like
> registers by allowing access to GICD_IIDR prior to VGIC initialization.
> Subsequent changes will allow the VMM to further provision the GIC
> feature set, e.g. the presence of nASSGIcap.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c       |  9 +--------
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 20 +++++++++++++++++++-
>  2 files changed, 20 insertions(+), 9 deletions(-)
> 
[...]
>  /*
>   * vgic_v3_attr_regs_access - allows user space to access VGIC v3 state
>   *
> @@ -552,7 +570,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  
>  	mutex_lock(&dev->kvm->arch.config_lock);
>  
> -	if (!vgic_initialized(dev->kvm)) {
> +	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {

I am confused here, the logic is that:

1. For the ID registers, they can not be modified after vGIC init.
2. For other registers, the original logic is that they should be modified after
   vGIC init.

So code here should be:

if ((reg_allowed_pre_init(attr) && vgic_initialized(dev->kvm)) ||
    !vgic_initialized(dev->kvm)) {
         ret = -EBUSY;
         goto out;
}

Not sure my understanding is right.

Best,
Zhou

>  		ret = -EBUSY;
>  		goto out;
>  	}
