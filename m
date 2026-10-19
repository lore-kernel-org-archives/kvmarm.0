Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D6D48E0C8;
	Mon, 19 Oct 2026 13:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416616; cv=none; b=W9ZMXR0YEfcwLcM1AvDyTdW8hTPLpfAHV76MsZoJqZH7tLWlL+Z+bdiF4JsJ/sh/4+Wkkm0LqB9xoqX5lH0Y78zKlZGpojaYmDfJxABdib043UE69dMJwC1SrfGipusDCWRSlvxyFgkC2FZnhsFYCltKddWHmKLNV28FlZHvdpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416616; c=relaxed/simple;
	bh=gnSvZ/LUFuJBVLtInfEtDLD0rv1MVCgno8bRL9CcznM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OoHYp/NAz/pn7zkxFHsfzPzkbW4qx/deV2KaGGjFx3e3DbIw41fVOhsJkj3sYE7fT1lf5OpouqyJj22kFpCnT7qsbHz7tdfzsEahAmvWSLKXpXQVlmNJLmLZLFKpVwcbUSIANnIQSPI/a4CWnkaQZkwSgDKIiTPFKqM5fZyFyGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XWIiIh+9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XWIiIh+9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 062451682;
	Mon, 19 Oct 2026 06:30:10 -0700 (PDT)
Received: from [10.0.136.108] (M0PRX50XMG.cambridge.arm.com [10.0.136.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DA513F7D8;
	Mon, 19 Oct 2026 06:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792416613; bh=gnSvZ/LUFuJBVLtInfEtDLD0rv1MVCgno8bRL9CcznM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XWIiIh+9N00nPEszeOCb0o1XUFPcpksmB+gfgf1dsmuWmFkafVKu0XsjhNE00YwI6
	 oQkIrEn1hXZSm1Y1KdyKHhfjct+P2agJ9D8DvghaybKTIt0i644pkuamtCLPLpegQk
	 gyNBx5JhhgeRqCXWqWrXL55FMs9abZiA1nRRrrcY=
Message-ID: <c6981395-bb76-4683-bf9c-b9b83e9a6a9a@arm.com>
Date: Mon, 19 Oct 2026 14:30:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Require matching VGIC model for
 GICv3 ITS
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016152225.898761-1-sascha.bischoff@arm.com>
 <20261016152225.898761-2-sascha.bischoff@arm.com>
 <sashiko-outbox-174566@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174566@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 16:35, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] kvm: vgic: its_model state leak on ITS creation failure prevents VGIC fallback
> --
> 
> commit 1db9490bd1d4f94f4d1c1d3aee70dca948f96eb7
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> KVM: arm64: vgic: Require matching VGIC model for GICv3 ITS
> 
> On a GICv5 host with legacy support, KVM registers both VGICv3 and
> VGICv5 devices. A VM can create a GICv3 ITS with another VGIC model,
> setting has_its even though that model cannot use the GICv3 ITS.
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index e5657cb603567..bf901626ea6df 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> 
> [ ... ]
> 
>> @@ -1903,6 +1911,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>>   
>>   	dev->kvm->arch.vgic.msis_require_devid = true;
>>   	dev->kvm->arch.vgic.has_its = true;
>> +	dev->kvm->arch.vgic.its_model = KVM_DEV_TYPE_ARM_VGIC_V3;
>>   	its->enabled = false;
>>   	its->dev = dev;
> 
> [Severity: Medium]
> When vgic_its_create() successfully executes, it updates the VM-wide state
> (its_model, has_its, msis_require_devid) to reflect the ITS device. If the
> generic kvm_ioctl_create_device() subsequently fails at anon_inode_getfd()
> due to process FD exhaustion, it aborts the device creation and calls the
> vgic_its_destroy() cleanup callback.
> 
> However, vgic_its_destroy() does not roll back the its_model VM-wide property:
> 
> arch/arm64/kvm/vgic/vgic-its.c:vgic_its_destroy() {
>      ...
> 	vgic_its_free_device_list(kvm, its);
> 	vgic_its_free_collection_list(kvm, its);
> 	vgic_its_invalidate_cache(its);
> 	xa_destroy(&its->translation_cache);
> 
> 	mutex_unlock(&its->its_lock);
> 	kfree(its);
> 	kfree(kvm_dev);
> }
> 
> Consequently, the VM permanently records that it requires a GICv3 VGIC model.
> 
> Does this state inconsistency prevent userspace from recovering and falling
> back to a different VGIC model (such as VGICv5) after an ephemeral FD
> allocation error, or if userspace intentionally closes the ITS file descriptor
> before creating the VGIC?
> 

This is something that I don't intend to fix. If the case where we've 
encountered process FD exhaustion, then we're already in a rather broken 
state. If userspace closes the FD before creating the vgic, then that's 
on userspace. I don't think that these are realistic cases to fix.

Thanks,
Sascha
