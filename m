Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA212DF3F2
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 05:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791264937; cv=none; b=RaPG4QJ8Mt1njVqeplozKLAQ1dPm0KeJSQF1mtLonpuHeYeoxniNIB9qTR2P+B0gVViPDRYub8sdZSnmefOiFjfzE/oyV1pXOdM/t+3Nv6nZUek1nbLtGC/yOKwy1YlCjzQpS5VRcDNFmqQw7fBxFBGGkhYctziGtWZV3TT479w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791264937; c=relaxed/simple;
	bh=DGW8lI2SR9lWmJKtrYzG10TLsythMb8q9PQyzrQoibM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LoBfbmwPa585ZI4PJbH1cjM7SHJPvfTbWQs0c1sZzDYa+JkRtI+yY5Rxr1IY/Bq5q+TtsicT9JfStQvTOZXU6hP/m9asa3RoI4vVR0de5vff1TPzu7VBLfHXLZSxlKTeUbwwnKY7S7ukpvhSCu+vlb23qnAcvZ8mngjjJqxrry0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UOgehE1O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UOgehE1O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791264934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6HKUn32Pl0RcC+t4ZBVYw0IBfWo3PWYr/PqqN0MysU=;
	b=UOgehE1OSZ5zqdMaBceOwEsccXmQ5MUX/Qr3U6TFiNpQeZ/y/q/GRr0XpXDIcBIzwusagH
	oq+mP3kQK0XC0XvbyUN22CZ3axTbmsmDDFIhBW42Ubc+hf8+FF8QelrbrVl45tfHOt76EF
	YycuJfdVovctJvdENSs0ysvWV395SRQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-DhNYCf0HOru5cDaMSKT3sg-1; Tue, 06 Oct 2026 01:35:33 -0400
X-MC-Unique: DhNYCf0HOru5cDaMSKT3sg-1
X-Mimecast-MFC-AGG-ID: DhNYCf0HOru5cDaMSKT3sg_1791264932
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a85a33333cso437742a91.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 22:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791264932; x=1791869732;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z6HKUn32Pl0RcC+t4ZBVYw0IBfWo3PWYr/PqqN0MysU=;
        b=PzFpMNBT5kfYdf2+78A1bf+6FckTsK+8AC8ffER3+0hWrJnV3Gij0iERsAs9KiXTow
         dktbDyULnjggIzagm98Zj+VRz/FOgI3ajGpLZ3wlJxmaeJ57I/3R8y61M2zBZxs4nnVE
         Mv8kvpUwZnVmAqkFy+RSkltqqHtLZQdzsnkOVW7zInR9mCc3RRiBkoZ3c0TxTbm8eBQV
         YmvS9AMIAm45HHPw/UG3soDEbYAj46ARbJTwWtt05c+uVqYBY26RHil1uOuGp0rFuO7M
         avcENFTUdyp10ACubLWA/NUojfeWeRZfxSlfxRmWS4W6D13qZF4H0tl+lE0GcUosF58W
         dL0w==
X-Forwarded-Encrypted: i=1; AKwUvBwsCeMm7QEsSNnF7Q4FrKjH4Hj2+tY6q7/ipEyFJ1R/AOpfq4oqckz2AMadHBSJdaS4q1u1d20=@lists.linux.dev
X-Gm-Message-State: AFq9FYKH4PBiWMimJpLzCbOmi4CHXo56QF9q1zMWaT9EwD21Sz3uSMpw
	WJSyLg+p3grrHCudki5KoA2BVj7n93vJ0aXJw8Dwud+/ui5tZXSc1Ge0Tvcwk+qoXmqYa0mNahf
	8fYYSIuhWwAprQdjETrv7y7+aP/WUaBtzUtb5Rclp8/IclRP/osSOM7S9FQ==
X-Gm-Gg: AYBFou1LphJLHsExPepIPAmoPTHbLxAwXDnDPIMUvMesBWdGJW2osRfQiYoovRvW/CN
	2LheGmS3MuCmqoTxhgFeaq89Na2w7l9C6Zjh1DlDY8xIdDvKZY2Qc8NHTIG9bwmgbv2qLt2QXEP
	Mm/A2gAI7TvzaF7HDhC72oR1Lyd2uEcP3rPPQZwFO0PphgjlLB794zHkdp8gsb4hSyy1EHZyXy5
	hcgXzB4dKeAjj9bLCXVE9Q2TnQiJgjEHx2IwyaT/77uIjj20E+Hv9YJvIgQZydbbK7yVDtJ/hNU
	sMiBe75vc53x2s0KAmtySI7UY+d6Go8SA7JMa8Xqo5rYUV0rao6lCEXsPH3CiuECf+sl6mtt0E0
	HgL4csUpjSjfFva12wr1CFCPbTHNeyiuT2FObyqutXA==
X-Received: by 2002:a17:90b:5101:b0:3a8:6b84:234d with SMTP id 98e67ed59e1d1-3a87254fb70mr144149a91.6.1791264931637;
        Mon, 05 Oct 2026 22:35:31 -0700 (PDT)
X-Received: by 2002:a17:90b:5101:b0:3a8:6b84:234d with SMTP id 98e67ed59e1d1-3a87254fb70mr144145a91.6.1791264931169;
        Mon, 05 Oct 2026 22:35:31 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543deb6dsm3003847a91.16.2026.10.05.22.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 22:35:30 -0700 (PDT)
Message-ID: <d330fe17-d9a4-4c6c-9d6c-f47162bbfd14@redhat.com>
Date: Tue, 6 Oct 2026 15:35:21 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 22/23] KVM: arm64: CCA: Expose SVE VL register before
 VCPU finalization
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-23-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-23-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mfiTbTwETeBV6_ZoMsRdgLaxYY-3y9HZMpouBetSTcU_1791264932
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Userspace must configure the SVE vector length before the Realm is created
> (as it is part of the parameter for Realm creation), but the Realm VCPUs
> cannot be finalized until after the Realm Descriptor has been created.
> 
> KVM_GET_REG_LIST currently rejects the unfinalized VCPUs, which prevents
> the userspace from discovering and configuring the VLs for  the Realm.
> 
> Allow KVM_GET_REG_LIST for unfinalized RECs and make the SVE register
> enumeration handle the unfinalized case explicitly. i.e., only expose
> KVM_REG_ARM64_SVE_VLS before SVE is finalized.
> 
> One adverse side effect of this change is that a KVM_GET_REG_LIST call that
> only probes for the array size will now succeed even if SVE is not
> finalized, but that seems harmless since the following KVM_GET_REG_LIST
> with the full array will fail.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/arm.c   | 15 ++++++++++++++-
>   arch/arm64/kvm/guest.c | 10 +++++-----
>   2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe707a0c47308..d99e7818f5894 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2004,6 +2004,19 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>   	return __kvm_arm_vcpu_set_events(vcpu, events);
>   }
>   
> +/*
> + * Realm VCPUs can be finalized only after the Realm descriptor is created.
> + * But in order to seal the SVE VL, we need to allow the userspace to read/write
> + * to the SVE_VL, before everything is finalized.
> + * Allow the register list for RECs before the VCPUs are finalized.
> + */
> +static bool kvm_arm_vcpu_reg_list_allowed(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_arm_vcpu_is_finalized(vcpu))
> +		return true;
> +	return vcpu_is_rec(vcpu);
> +}
> +

Needn't to keep this helper, and the code can be integrated to kvm_arch_vcpu_ioctl(),
see below.

>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg)
>   {
> @@ -2059,7 +2072,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   			break;
>   
>   		r = -EPERM;
> -		if (!kvm_arm_vcpu_is_finalized(vcpu))
> +		if (!kvm_arm_vcpu_reg_list_allowed(vcpu))
>   			break;

Needn't to keep the helper kvm_arm_vcpu_reg_list_allowed() after its logic is
combined to kvm_arch_vcpu_ioctl().

		/*
		 * Realm vCPUs can be finalized only after the Realm descriptor is created.
		 * We need to allow access KVM_REG_ARM64_SVE_VLS before that so that the
		 * register can be sealed.
		 */
		if (!(vcpu_is_rec(vcpu) || kvm_arm_vcpu_is_finalized(vcpu))
			break;

>   
>   		r = -EFAULT;
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index b01d6622b8720..c3ca369882273 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -598,8 +598,8 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>   	if (!vcpu_has_sve(vcpu))
>   		return 0;
>   
> -	/* Policed by KVM_GET_REG_LIST: */
> -	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> +	if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +		return 1; /* KVM_REG_ARM64_SVE_VLS */
>   

Question: After a (Rec) vCPU is finalized, the returned number of registers won't
be 1. Is this expected? Otherwise, we need to use vcpu_is_rec() here.

	/*
	 * KVM_REG_ARM64_SVE_VLS is visible for realm vCPUs no matter if
	 * they have been finalized.
	 */
	if (vcpu_is_rec(vcpu))
		return 1;

>   	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
>   		+ 1; /* KVM_REG_ARM64_SVE_VLS */
> @@ -616,9 +616,6 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>   	if (!vcpu_has_sve(vcpu))
>   		return 0;
>   
> -	/* Policed by KVM_GET_REG_LIST: */
> -	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> -
>   	/*
>   	 * Enumerate this first, so that userspace can save/restore in
>   	 * the order reported by KVM_GET_REG_LIST:
> @@ -628,6 +625,9 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>   		return -EFAULT;
>   	++num_regs;
>   
> +	if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +		return num_regs;
> +

Same question as above.

>   	for (i = 0; i < slices; i++) {
>   		for (n = 0; n < SVE_NUM_ZREGS; n++) {
>   			reg = KVM_REG_ARM64_SVE_ZREG(n, i);

Thanks,
Gavin

