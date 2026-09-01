Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EDC35E1BC
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 04:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788236982; cv=none; b=nZEUQ7+0a1Q4eBwOmh2kGXZFSaQe7jkQfSp2oofUZW8XCNgZdZRPbxdTpQ6vdoYz9ieJDR7C8gknJAWyS9Tr+5hJbM2KIV2Y//ure2b41bpjUS7DKYo2VLrGEWdMHcSm5mQkpsgHso4cbFgOQrvcGRpr/FXaBHUu8otuxbCKZR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788236982; c=relaxed/simple;
	bh=b/q72RLD9lBRxi2VmlFM4dWbgfCb6GrTRD2Ri5Ba41s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XqZH1aPt0+D2/RPlrcRLMGeyebeL7LS/ac9NV0wy04lZdrp5R3ocd9MqkKgsGqVDxgpy+d0pbVLRSP1HOtOLYGMc65NurINJ8ukXAXsI1fPY7Rk9gxFDDloylOPrI7NRm3cs+5RVlCY5pSYLC8GtBlakHVXpMClG80Dex3uMUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MCINri1g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MCINri1g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788236976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YCQU+V95xqEH8EbNTciL/CsMqe3BTX/wUO0rCYM10FE=;
	b=MCINri1gBAl2Y5AU/X1mZ1x7bpSitYjHljQdXJiSZq3VhDLv16nW4uOgMIg0gucgFmYE2u
	ZXrQNABPzwOxj4wWUEqxn5MnaSRFbYVPufXMYTuH8SEiKNxoP3vtUYDpWP9sGz9s/qvbnj
	1eq4Xl+xPebXwsoQlVbu5Zo9z8oLTAU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-ykb7trl8NamMOtoQPBh6Kg-1; Tue, 01 Sept 2026 00:29:35 -0400
X-MC-Unique: ykb7trl8NamMOtoQPBh6Kg-1
X-Mimecast-MFC-AGG-ID: ykb7trl8NamMOtoQPBh6Kg_1788236974
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1b8088202so4489618a12.3
        for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 21:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788236974; x=1788841774;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YCQU+V95xqEH8EbNTciL/CsMqe3BTX/wUO0rCYM10FE=;
        b=jOYK4HDumO8LB2kVndl024h9uFt2Y9UEOYaMMlt09QSULWTUN/7ERdc2lUx+LZePiC
         H7MZUljOWHJ6XrJhOnS7tIEiMIpDqfzgZLKNucxRuOGbM+rka7BLNrSW/0X4wx7X5Umx
         4rnx//J9ikYtWrwP9oNz6pw0jftxIjAJJ+WPgpZAZ1Qde5P+mVMtqC2J0rSY3pEOr6XR
         d1sM044M202i0/eY1+eLNU0tMRGBTXhm+fC8wMkk8Y2JC8EwSDKTmI6qVPm77vKBkOTr
         mce+NQ3HDWkjYj6twec6QZrDrUVUi9UxWXZUIQTXxV9BblgDpLji2NBtd/Geex8Yc9hd
         sFZQ==
X-Forwarded-Encrypted: i=1; AKwUvBxmF2agykDfSEUXvONoDPHeEYgxyoqeGM5Fvyu+zy7RZNYPOP/0XiuyVFp0Vb8nkSllodNlcI8=@lists.linux.dev
X-Gm-Message-State: AFuF++kyCD8J6h+kXWqs5d3rnQowTNCkELn5b0gChjrQr0EKvNatG1T8
	S+FTr/HHf8PzoNbnKgX82Opo0A4bUxdsxdqYmhr0HsMCMeIfFUew5Dpy9LrUHY0yeJn0mxCZusg
	I1p8WcqB9fRC+4VkgbK63JN/eFl4g0GIcuUY24gkLQXMBBGcWzPNgWQCN7Q==
X-Gm-Gg: AYBFou3QKuZVkNcXO+aDoTpXXTd0A2xZSfgA1BsnJOatfKo+fITgME1Q4xxZlZdbMkH
	BRIfuS8TEYaA20FNnH5nh3qdFNsm528S1uUyAQGuKnMagzw5AzlfKdax/B7mxk3vHxTSpCGh/eB
	bdHfA5QtXr+mxf1KhGehKh4WVdAZRNSIVGd2Pq1jQjVHqMD1HWR7cCYqAbc1MpcKljTvxOoiJEh
	R1ihdfhTRc7YOpoasiD1EeutL7DgzyCAFuPKr0a8Vt+mBzgvqsUS+PzWQdAra2f/g0VhzQrHG5I
	hG3RM2GvgDMetlwTw2MWgsAYKyCK5XbtVRNDUxt4BN3qy+Uy3Q89/hlYADkjFD5dfWBJc3lNZL5
	GV33+kWVVOL0fsjM/3lnukaPuRqUyIuCWB4nO4ZiAtA==
X-Received: by 2002:a17:903:2acb:b0:2d9:1c02:5a19 with SMTP id d9443c01a7336-2d94a956b48mr72439875ad.22.1788236974298;
        Mon, 31 Aug 2026 21:29:34 -0700 (PDT)
X-Received: by 2002:a17:903:2acb:b0:2d9:1c02:5a19 with SMTP id d9443c01a7336-2d94a956b48mr72439155ad.22.1788236973766;
        Mon, 31 Aug 2026 21:29:33 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f95a847sm30663601eec.17.2026.08.31.21.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 21:29:33 -0700 (PDT)
Message-ID: <8e699e2d-c04c-4ff7-98a3-c01e573ee817@redhat.com>
Date: Tue, 1 Sep 2026 14:29:22 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 15/45] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-16-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260803134403.80630-16-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E7xRe16etdr7U-Deg2cuzMwSoj1al5d3Di1Shk6Ujj0_1788236974
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 8/3/26 11:43 PM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> RMM v2.0 provides no mechanism for the host to perform debug operations
> on the guest. So limit the extensions that are visible to an allowlist
> so that only those capabilities we can support are advertised.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>   * Add missing check in kvm_vm_ioctl_enable_cap().
> Changes since v10:
>   * Add a kvm_realm_ext_allowed() function which limits which extensions
>     are exposed to an allowlist. This removes the need for special casing
>     various extensions.
> Changes since v7:
>   * Remove the helper functions and inline the kvm_is_realm() check with
>     a ternary operator.
>   * Rewrite the commit message to explain this patch.
> ---
>   arch/arm64/kvm/arm.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c4d906861736..6f39831dcf5d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -135,6 +135,26 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>   	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>   }
>   
> +static bool kvm_realm_ext_allowed(long ext)
> +{
> +	switch (ext) {
> +	case KVM_CAP_IRQCHIP:
> +	case KVM_CAP_ARM_PSCI:
> +	case KVM_CAP_ARM_PSCI_0_2:
> +	case KVM_CAP_NR_VCPUS:
> +	case KVM_CAP_MAX_VCPUS:
> +	case KVM_CAP_MAX_VCPU_ID:
> +	case KVM_CAP_MSI_DEVID:
> +	case KVM_CAP_ARM_VM_IPA_SIZE:
> +	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> +	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> +	case KVM_CAP_ARM_RMI:
> +	case KVM_CAP_SYNC_MMU:
> +		return true;
> +	}
> +	return false;
> +}
> +

Nitpick: The code can be simplified a bit if @kvm is passed to kvm_realm_ext_allowed().
In this way, kvm_realm_ext_allowed() looks similar to kvm_pkvm_ext_allowed().

static bool kvm_realm_ext_allowed(struct kvm *kvm, long ext)
{
	if (!kvm || !kvm_is_realm(kvm))
		return true;

	switch (ext) {
	case KVM_CAP_IRQCHIP:
		:
	case KVM_CAP_SYNC_MMU:
		return true;
	}

	return false;
}

>   int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   			    struct kvm_enable_cap *cap)
>   {
> @@ -146,6 +166,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, cap->cap))
>   		return -EINVAL;
>   
> +	if (kvm && kvm_is_realm(kvm) && !kvm_realm_ext_allowed(cap->cap))
> +		return -EINVAL;
> +

	if (!kvm_realm_ext_allowed(kvm, cap->cap))
		return -EINVAL;

>   	switch (cap->cap) {
>   	case KVM_CAP_ARM_NISV_TO_USER:
>   		r = 0;
> @@ -380,6 +403,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
>   		return 0;
>   
> +	if (kvm && kvm_is_realm(kvm) && !kvm_realm_ext_allowed(ext))
> +		return 0;
> +

	if (!kvm_realm_ext_allowed(kvm, ext))
		return 0;

>   	switch (ext) {
>   	case KVM_CAP_IRQCHIP:
>   		r = vgic_present;

Thanks,
Gavin

