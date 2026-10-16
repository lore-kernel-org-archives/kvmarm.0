Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871E64BA1E2
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 13:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792156337; cv=none; b=o51NM/W2Plg5o1cOlO+npwgudWsSb8X3OcbaEcgxJY0PRY8GNP7kYLKRD+aqIuV1I4o2U/tHcYUQjn5/KhYpYbduWPsY5nSMThR7KssvQKt/PUyRfvVMhafGdXCkn1zlPJyZMhhagnsNFMIbhk2zW4NDny5dBoIeGiy+uWJ8PUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792156337; c=relaxed/simple;
	bh=6JQVd3X+R3u1fYQaDZLc6Kxr0tOcpkrFapxytXdzm3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q5jwKlGCbVffFcmXLbpn5bm1ladWRO1sMFMFkJ51wioQXcU3IqC3t2OwD4j5n3G/aPL+c58WFaV+M9FW1qgVf3G1V7eLw3AYvqAfAv+/DTLmEvYWP0CpbOT1265LMwoAWJW0BfcQSWGMq/3r7YM9XbwaYFU5AuqGV7yufF102CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+5onHvf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+5onHvf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792156331;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NqAlwmurey0eGwhQI19UUFnkpSWK92NIkqItN6DRKHs=;
	b=G+5onHvfjfUhooSNPMgXfZN1uLCLWoarFb466FDS97HrjmfU3rNBR4vCdObCG+SRSpodIV
	2rCycOJyITkt7e2ziBusaT+0FkeaI3T0yryhYxzhc5mew/h8RR8ZsJ8gBzv+mQXkYsW4i9
	E5P/q4pkvmIiieVnG16j/JNKQM/v3QE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-GAb4HpQXM7mboYFtzAcK-w-1; Fri, 16 Oct 2026 13:12:06 +0000
X-MC-Unique: GAb4HpQXM7mboYFtzAcK-w-1
X-Mimecast-MFC-AGG-ID: GAb4HpQXM7mboYFtzAcK-w_1792156325
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a166a9ea21so54159215e9.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 06:12:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792156325; x=1792761125;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NqAlwmurey0eGwhQI19UUFnkpSWK92NIkqItN6DRKHs=;
        b=txP4OC+7tdti7NlVEC33QI22E+LejxT1XPxLtUVob/nX2vaH0vOLrZwtQDS79ACQkS
         u3GTDf4N0zHFhHdVk5go8Nf1Q2BFMldVKj/0r9oP/+2+rLO4NuvESDuWtRi2I+LxLUEI
         OhgBYT6MnfN1duP5PE1Odyh8fgBMAkQqe38prmAtz3ze27R2PBRZoJElI3wFqZOqggOH
         zXhpu/YZdM604DW0p46p8ifZ4S8pxaBx6srwgRZ/K1zRXBjFjtcRbXUAZt2komLadHb1
         7rrLAHnbxO2I33YHHkP8b5zNndN6WYQ0iUWCvf297H+9Ou8e2PSL3wIEvv8yVr1DLUKr
         ZTMg==
X-Forwarded-Encrypted: i=1; AKwUvBz2Q1G4Zb1I/IfTFRY6c4zO1WW2Hr1XW9UvxAzxKuptDACupedpnZa4o3i7CRUZNx8kMSh8gcw=@lists.linux.dev
X-Gm-Message-State: AFq9FYKAeg6vkXCYndyUAma8ifXlg6sZHUOQT23SXR1kXZQNF4nkG/rj
	WYBbvtiM9ZPkcvedZWYK2C+pI5SjUuq7XM/ltwwhu4gG1Nvu3IvrNd8npHK5RAnHMW/pL6x0+qw
	1veQyQ67SrAM0DAvXZW5BJYoKoidY8QOozSz+XsGPMIwBq36qcrwuJ1XWkA==
X-Gm-Gg: AYBFou0z65twEzHYZHDGLiUAYqLbhKvYH8qootUckoRoqW3K5OtWZeFhZ7Zvc3Rvf6L
	UiinR8Wq7GmhkUr1TYH+oc98ENuySG7OgyamaNaS5DhHyoByNVn4XYznvhKpdeI0LthW2i/WPPa
	Jo8OlQVL7SslNzyrvCcBet/+FsRzoPvnI7WmYiIVR2a9zXTa/mhEagoOE/psDDTrQvZrIQ8mdO5
	uDX5d6eR9mygoMs2Hd4mxiA4tmHzAIuHzvkhQGQjx53EWb3PJi5knCpzA0ELAjBmvsXkmG76OFN
	NzUyGRW0UDH3mZ2Y0HN9+Rzmk+cTwkfuv7erxlUafz5Ohp/oKjJCDraSCGtWObVac/aTP/U1qV/
	V0UTCN/brOTYYiPhknVyjali9Ryb7WGjWSyBLmWZQMHi40cb0
X-Received: by 2002:a05:600c:3e07:b0:4a1:a009:9724 with SMTP id 5b1f17b1804b1-4a1a00997f1mr285782705e9.7.1792156324971;
        Fri, 16 Oct 2026 06:12:04 -0700 (PDT)
X-Received: by 2002:a05:600c:3e07:b0:4a1:a009:9724 with SMTP id 5b1f17b1804b1-4a1a00997f1mr285782155e9.7.1792156324572;
        Fri, 16 Oct 2026 06:12:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4c5957sm4960343f8f.9.2026.10.16.06.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 06:12:04 -0700 (PDT)
Message-ID: <0a1a763d-c95d-413c-ac11-384d5db599c2@redhat.com>
Date: Fri, 16 Oct 2026 15:12:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 21/25] target/arm: report 0 as supported for ID
 fields gated by vCPU init flags
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 ping@khushitshah.com, sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-22-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-22-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mDJTPjBF2vab7eSrZ2wdpjSaZUqE-c3qlZ5LyyqE9t4_1792156325
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/21/26 2:32 PM, Khushit Shah wrote:
> When QEMU queries the host ISAR via KVM, it uses a scratch vCPU
> initialized with all host-supported features (like SVE and PAuth).

So I expect this patch is not needed anymore after rebase on v9/v10

Eric
>
> KVM exposes the corresponding ID register fields (e.g.,
> ID_AA64ISAR1_EL1.APA) as read-only. The supported-values list only
> shows the enabled host value (e.g., 5). This falsely flags a model as
> blocked, even though the features can be masked by omitting those flags
> during vCPU initialization. For these fields, even if KVM reports them as
> non-writable, we explicitly append "0" to the list of supported values
> if the host value is non-zero.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/kvm.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 77b1bcdf55..0b5fb49dff 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1346,6 +1346,24 @@ static void ranges_add(GArray *ranges, uint64_t min, uint64_t max)
>      g_array_append_val(ranges, r);
>  }
>  
> +/*
> + * Some fields are reported as non-writable by KVM but can still be
> + * disabled by not requesting the corresponding vCPU init feature flag
> + * (SVE, pauth). The supported values are derived from a scratch vCPU
> + * whose init flags may differ from the real vCPU, so for these fields
> + * "off" (0) is a supported value in addition to the host value.
> + */
> +static bool kvm_arm_field_off_via_vcpu_flags(const ARM64SysRegField *field)
> +{
> +    return field_matches(field, ID_AA64PFR0_EL1_IDX, "SVE")   ||
> +           field_matches(field, ID_AA64ISAR1_EL1_IDX, "APA")  ||
> +           field_matches(field, ID_AA64ISAR1_EL1_IDX, "API")  ||
> +           field_matches(field, ID_AA64ISAR1_EL1_IDX, "GPA")  ||
> +           field_matches(field, ID_AA64ISAR1_EL1_IDX, "GPI")  ||
> +           field_matches(field, ID_AA64ISAR2_EL1_IDX, "APA3") ||
> +           field_matches(field, ID_AA64ISAR2_EL1_IDX, "GPA3");
> +}
> +
>  void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
>                                          const ARMISARegisters *host_isar,
>                                          ArmFieldValueSet **value_set)
> @@ -1358,6 +1376,13 @@ void kvm_arm_field_get_supported_values(const ARM64SysRegField *field,
>      /* A non-writable field can only ever hold the host value. */
>      if (!arm_field_is_writable(field)) {
>          ranges_add(ranges, host, host);
> +        /*
> +         * ...unless it is one of the fields that can still be turned off
> +         * via vCPU init flags, in which case "off" (0) is also supported.
> +         */
> +        if (host != 0 && kvm_arm_field_off_via_vcpu_flags(field)) {
> +            ranges_add(ranges, 0, 0);
> +        }
>          goto done;
>      }
>  

