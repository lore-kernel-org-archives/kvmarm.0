Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28163175A9B
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 12:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784723565; cv=none; b=ULcy+G0NI7FhSslnN6oHGslTG70LhPLcgCwauN1ik3/fCKAGxS7ZNCpNjBz5lWQorMycg3GtGToov8jrvBGFlM70iSZjVpRLxoWobmklF34DyKXpQCNB7PTv6tmyvl54N04Qd+xsHk6W0aH8y2DOAl2YUnutEEyXGjN+3HJGCSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784723565; c=relaxed/simple;
	bh=VvT2re+sM0BJTxjL3EnnMyFWgNvucUHzBIQrAQUPVOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YLFaYIIFJj5vHPCLPWaAIvIXgXrwFL/OVB/d/y5sjhizl9hlUwNN9mtOFzLtDSEz09i8bf5MUs5tAzMU9IkdrpUokSkEMDw9gMGIW1MU7eoTh3U0HO4XzwZA2n0MGgOCZK6QEQrYPic/uFreEz7Tmpx25IjFa+l+dro64ppNyAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AaRVq7gB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AaRVq7gB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784723563;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i7gqBLmiNP/G2NWV47w7HHLvruXwNX+UfAId5Ty/suA=;
	b=AaRVq7gBNhIk6JW+rLfDUJYnXNxQCMKmpI2mUni+zyQq/rnjngodEMV/5IQ9nfifl18t+1
	56hMHuzxL3XjN2a3C3OwGDRXdSt5K2IhDQ/YOLbdrElIRCfXlT1AToSNq5N7GBtQ6GgGWj
	kV2s3UWizpMXRYultqnIsIkKhmWWNh0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-3O1UKpc4MhmRTjHqki-Phw-1; Wed, 22 Jul 2026 08:32:39 -0400
X-MC-Unique: 3O1UKpc4MhmRTjHqki-Phw-1
X-Mimecast-MFC-AGG-ID: 3O1UKpc4MhmRTjHqki-Phw_1784723558
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495529a93f9so29637415e9.3
        for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 05:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784723558; x=1785328358;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i7gqBLmiNP/G2NWV47w7HHLvruXwNX+UfAId5Ty/suA=;
        b=srUfr3kwY98kfyDmBchE7Rommt7OAZZ0C8QxBM6XTeyPUquz0YoPGtmzBB3Qj2zs6N
         53gKwxb/5pd42qJ26VKc95qhZi4UjqBa+Z9AYfK9GsaSMHdLt1WiRyPvnJHYr528stM+
         C0K+VcXPlfKOxX9NvWYAvpGTMUVdgKBQov0s/AdrEgM9U4d3VqrqSe2QMI9eLufWhqlm
         6OJhXUqXoiFgP2rQ1O4nR4zSDDy2Q4IdmPqJV3a4S14mSEAzyJaxyZ9ZpEne8d6rqrtW
         gHNC3KEoxC+cZ0T8wcS7sYEuUlM71+AR8c5BcuQwg22FXy/MWN8BBdtWMjUxiskLrbAl
         1l6Q==
X-Forwarded-Encrypted: i=1; AHgh+RqIES+kChXlI4/diF34Vc2XEmiV4IxXU8Z0bbZ7XUbUxxEqOIA2G+pR7I8mOStC4IjXGavDOi4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbJmWuXo17xfIo9P/aIeIZX5xnO+i8XQGW5OfUBvQJCDYB8gTQ
	y+m1h8AWnKm+P2zGERZNqheD0afrxybUd18OW8KGkykp+CTVxeVwNSeQodK+5V833lP/D+P7e6C
	shUgDkA9G+m8po4uWId8kFRHlOE7w4K7uUkGVmk3SQH3G7l3FxMbH+JqQ0w==
X-Gm-Gg: AR+sD13yWI2/IbIdLn/O2FhvhGcVYizvkZbdTYkPp+o1m8RFynEhLtkVXnuG6K+4fgW
	Bs6W3xyqlZ72Az22tzp1RvuNpbvtOgzBsry9SWRTt4blvIgYaDAN7LgRqtLK/mRW+KwPw5yhCb7
	++9qhr31Gbc8i588EGTbSPNIJgBN4pucbPblokrG4Qhbr1dPFLcFhIHN9SdRgDwzsazryJmcpPc
	qZH0qh94Fmv6VkHYi1vOi5ZyyhqxbJr2kb+40AH1nGTj7nc9n5a0byHZrVjyzG4CG9n2wvVom5K
	fHxXijASDaqT2pQOR6gJYUm92aZL8xh50mrPkUHGmS7r5Mob4NTx5C01jSYGgm8E+O85Bz89p3Q
	EF9Dwf+ifWGoYhnf+biXLg8OVypwOGtprbwqRjPvwaw1v/t7U
X-Received: by 2002:a05:600c:19c8:b0:495:6134:6d61 with SMTP id 5b1f17b1804b1-4956202554emr129779145e9.19.1784723558327;
        Wed, 22 Jul 2026 05:32:38 -0700 (PDT)
X-Received: by 2002:a05:600c:19c8:b0:495:6134:6d61 with SMTP id 5b1f17b1804b1-4956202554emr129778605e9.19.1784723557861;
        Wed, 22 Jul 2026 05:32:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bd850asm5598955f8f.15.2026.07.22.05.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 05:32:36 -0700 (PDT)
Message-ID: <134decf2-a084-4cba-8536-a59ecbd6b420@redhat.com>
Date: Wed, 22 Jul 2026 14:32:34 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 07/19] target/arm/kvm: handle special ID registers
 cases when reading from KVM
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 prerna.saxena@nutanix.com
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-8-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260716213858.609699-8-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VtfodmUyCvblT-gqSx_gtaiTpV_3LiMXDQgA9Fg-b84_1784723558
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 7/16/26 11:38 PM, Khushit Shah wrote:
> The generic KVM_GET_ONE_REG loop cannot correctly read a handful of
> ID registers, so specially handle those:
>
> - DCZID_EL0: No fine grain trap exists, hence not tracked by KVM.
>   It is EL0-readable and untrapped, so read it directly with MRS.
>
> - CCSIDR_EL1/CCSIDR2_EL1: not plain ID registers, their value is
>   selected by CSSELR_EL1. KVM only exposes them via the DEMUX API
>   (KVM_REG_ARM_DEMUX_ID_CCSIDR), so there is no single value to read
>   here. Skip them.
>
> - SMIDR_EL1: KVM does not support SME, so there is no meaningful host
>   value. Skip it.
>
> - GMID_EL1: not in KVM's sys_reg_descs[] and, being an EL1 register,
>   cannot be read from userspace via MRS either. The guest reads the
>   raw host value; this is a genuine miss when MTE is enabled.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/kvm.c | 53 ++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 44 insertions(+), 9 deletions(-)
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 42ff731f6e..6974e5c551 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -311,15 +311,50 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
>          int ret;
>  
>          reg = &ahcf->isar.idregs[i];
> -        ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
> -        if (ret) {
> -            if (errno == ENOENT) {
> -                warn_report("%s error reading value of host %s register "
> -                                "(ENOENT)", __func__, sysregdesc->name);
> -            } else {
> -                error_report("%s error reading value of host %s register"
> -                            " (%m)", __func__, sysregdesc->name);
> -                err = ret;
> +        switch (i) {
> +        case DCZID_EL0_IDX:
> +            /*
> +             * DCZID_EL0 is not in KVM's sys_reg_descs[], so
> +             * KVM_GET_ONE_REG will fail. Read it directly from
> +             * hardware since KVM doesn't trap guest reads of it.
> +             */
> +            asm volatile("mrs %0, DCZID_EL0" : "=r" (*reg));
> +            break;
> +        case CCSIDR_EL1_IDX:
> +        case CCSIDR2_EL1_IDX:
> +            /*
> +             * CCSIDR_EL1 is not a plain ID register: the value it
> +             * returns is selected by CSSELR_EL1, so there is no single
> +             * value to capture here. It is exposed to userspace only via
> +             * the DEMUX API (KVM_REG_ARM_DEMUX_ID_CCSIDR), indexed by
> +             * CSSELR. Skip reading it here as there is no meaningful host
> +             * value to read.
> +             */
I think you should rely on prerequisite
[PATCH v4 3/3] arm/kvm: get demuxed ID registers from kvm


> +            break;
> +        case SMIDR_EL1_IDX:
> +            /*
> +             * As SME is not yet supported by KVM, ignore reading SMIDR_EL1
> +             */
> +             break;
> +        case GMID_EL1_IDX:
> +            /*
> +             * GMID_EL1 is not in KVM's sys_reg_descs[] and guest reads
> +             * the raw host value. But as it is an EL1 register, we cannot
> +             * read it directly. This is a genuine miss when MTE is
> +             * enabled for the guest.
> +             */
> +            break;
> +        default:
> +            ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
> +            if (ret) {
> +                if (errno == ENOENT) {
> +                    warn_report("%s error reading value of host %s register "
> +                                    "(ENOENT)", __func__, sysregdesc->name);
trace point
> +                } else {
> +                    error_report("%s error reading value of host %s register"
> +                                " (%m)", __func__, sysregdesc->name);
> +                    err = ret;
> +                }
>              }
>          }
>          trace_get_host_cpu_idregs(sysregdesc->name, *reg);
Thanks

Eric

