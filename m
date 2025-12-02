Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA5A301714
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 10:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764671733; cv=none; b=N5sXJf3IQJVSBeisPiXIV0P2jUzohon/iU4+EgRpETpIm2debidA5jjKckoeOeF7YtFfTRbpJH7TV3qMvqxtQZiRYDfL0jQgY+g5Vg6MaV6+zb+yQ57blJFGZ+o8z6ut8nyGpQY/oR3XNubUqhiS2+pDKPlypYauHusaihkZlcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764671733; c=relaxed/simple;
	bh=8ehwieRgME29YittKX3I6p8D8uoKGas4AaSH/vNw+ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZW9P6G0IhkBZuLB/8go0M/dqCKYGK+M1ZvENIfdNN8IFTZKn2e86FS2QdBTKYi7RqtIDCQNnKhOu7JlGfuSKQa4RoMCNx9As5Ken1+oF/kIRnZDoCo1LiJLPLQEsIczw4nIXnD9arziS5C4BLR3XhIwSvBRQi+ixchO3jX11F0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ifNqaXN7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ifNqaXN7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764671730;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nVckf801EzlHLt3eBGX4mHh0JO99LKIAjAwFPbJ7PrM=;
	b=ifNqaXN71fNhg0EoZQSPTiGJgWiU8AqVC1PiwclVMrI7KD776GiQgklK5ki7wH6VhlytLP
	oB64o22dwDGH89MOdsjlO+02X3Y+XSjJIswxWuZi7vkNYRoRNWBMNOKF+tMJlud0YuLEn+
	LOIK4kBEWDEh/3kt1SgKE1Gzjb3rQTA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-BR6BLUVCMz-g_PJNHEcDHA-1; Tue, 02 Dec 2025 05:35:29 -0500
X-MC-Unique: BR6BLUVCMz-g_PJNHEcDHA-1
X-Mimecast-MFC-AGG-ID: BR6BLUVCMz-g_PJNHEcDHA_1764671729
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-882376d91beso139811196d6.3
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 02:35:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764671729; x=1765276529;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVckf801EzlHLt3eBGX4mHh0JO99LKIAjAwFPbJ7PrM=;
        b=TP4CxGt2svYCQrNQTCGB12xCD4AtFj9df0O4LIznr8n53MhIS0BM5HgcWqUyznsNaJ
         vrhbp/iqkHqT0ZUXfsOrA9CfXtSmWWCZz/AhewOFxgf8TASp31Su3DwGyXxG6MCdruhN
         L1O5D5ywsj4NoprJaSYsh4zO0XMI5vSlihmRDEnuducA73YldspTCavVZI3aI/6FohSY
         kE39xfk9kTod1hd2ULTcV7Umbf5ojGeFpRyNc1E8Uvy1dLUZVC5552azr+vwd889T1+t
         MKLdZVIU5K9tHb4reZJVGtqf9aK6xcD/SSXsyGsNu0qlyO27+Be237likLmuOXxRXOPI
         rf9A==
X-Forwarded-Encrypted: i=1; AJvYcCWSyVRBlKvhGSgpei0wRgEYIfFt0oOKiEOEP52Y05SzSThVIbdOkfr/bTk17UR9JbVYFOE4MMg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5Eqa4pdN4sqw9Y9ybYpbnBV6BO8HOlRBdpqkwyUinvsZB/NFq
	C6vFYMPSup9njGFPzUCY+Gri6RQmShyfEaQa4zuX65v98iunJoGCOmsLVNPfCh6+76j443zKSJF
	/e0Hs6NYfQCMeNcBpKmxTCJabc5xdNjsSLYh1xkc4Qvb8DYn+YmCWGq6iKg==
X-Gm-Gg: ASbGnctRTTF1HQKZNhFLuONrZ1R4Ij3yc5BL2JmQp1uTSvHvRTx1fS3uZqpt3kE3znL
	y4WHhwkrWozZWMSxi48Kip1WoocNArsiXhz+Q3XHu8uapETegZUbAZ1gNYVM6J987cyjnCDdlel
	zOKcxAyzcQaqr9A5kOPYXwgCWzb+TRF1Yr1XKZcmuMTYbalm2w8/L7F9B6wYyEqMh4t+rU5wQAD
	PW6g7zHP1BXXeB58YbiKcp7+ICjLL3T8a2LNRVaB01LNpflKDrLNGcri1aJ7UBtpW5d8CBuU8WA
	8S5TZxR/ev0KWOcRanW0WQ+oouTfJzVtjOmqiZotUcfiQdNQdfk+A+n/i+g2eFeU+mLjVBCnM9w
	nLYCiK1GGNtCJFRhtEXLa/yWS9Z4hFV0CYk9Hql6OnyxgKmJUxtwnGlLmUw==
X-Received: by 2002:a05:6214:212b:b0:7f7:777e:39c5 with SMTP id 6a1803df08f44-8863af15e51mr447369466d6.25.1764671728776;
        Tue, 02 Dec 2025 02:35:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGEbGb2r6oAFr49aUac0U3SAzN0PPLJROZTPCjIXcuNk6VSBXpQXplvBnfUNVbCdUK5fRCMw==
X-Received: by 2002:a05:6214:212b:b0:7f7:777e:39c5 with SMTP id 6a1803df08f44-8863af15e51mr447369246d6.25.1764671728422;
        Tue, 02 Dec 2025 02:35:28 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b6851dsm100885856d6.42.2025.12.02.02.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 02:35:27 -0800 (PST)
Message-ID: <0ceb3518-6eb2-4d0d-95c5-f926cce313ca@redhat.com>
Date: Tue, 2 Dec 2025 11:35:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 09/10] arm64: run at EL2 if supported
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-10-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-10-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TnP8UoK4SH-DeY9_a8OnL_jTB7xKbhbN7Q7GkEySpis_1764671729
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> If VHE is supported, continue booting at EL2, otherwise continue booting at
> EL1.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/cstart64.S         | 17 +++++++++++++----
>  lib/arm64/asm/sysreg.h |  5 +++++
>  2 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 79b93dd4..af7c81c1 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -18,7 +18,7 @@
>  .macro init_el, tmp
>  	mrs	\tmp, CurrentEL
>  	cmp	\tmp, CurrentEL_EL2
> -	b.ne	1f
> +	b.ne	2f
>  	/* EL2 setup */
>  	mrs	\tmp, mpidr_el1
>  	msr	vmpidr_el2, \tmp
> @@ -41,17 +41,26 @@
>  	msr_s	SYS_HFGWTR2_EL2, \tmp
>  	msr_s	SYS_HFGITR2_EL2, \tmp
>  .Lskip_fgt_\@:
> +	/* check VHE is supported */
> +	mrs	\tmp, ID_AA64MMFR1_EL1
> +	ubfx	\tmp, \tmp, ID_AA64MMFR1_EL1_VH_SHIFT, #4
> +	cbz	\tmp, 1f
> +	ldr	\tmp, =(INIT_HCR_EL2)
> +	msr	hcr_el2, \tmp
> +	isb
> +	b	2f
> +1:
>  	mov	\tmp, #0
>  	msr	cptr_el2, \tmp
>  	ldr	\tmp, =(INIT_HCR_EL2_EL1_ONLY)
>  	msr	hcr_el2, \tmp
>  	mov	\tmp, PSR_MODE_EL1t
>  	msr	spsr_el2, \tmp
> -	adrp	\tmp, 1f
> -	add	\tmp, \tmp, :lo12:1f
> +	adrp	\tmp, 2f
> +	add	\tmp, \tmp, :lo12:2f
>  	msr	elr_el2, \tmp
>  	eret
> -1:
> +2:
>  .endm
>  
>  
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index ed776716..f2d05018 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -80,6 +80,8 @@ asm(
>  #define ID_AA64MMFR0_EL1_FGT_SHIFT	56
>  #define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
>  
> +#define ID_AA64MMFR1_EL1_VH_SHIFT	8
> +
>  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
>  #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
>  #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> @@ -116,9 +118,12 @@ asm(
>  #define SCTLR_EL1_TCF0_SHIFT	38
>  #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
>  
> +#define HCR_EL2_TGE		_BITULL(27)
>  #define HCR_EL2_RW		_BITULL(31)
> +#define HCR_EL2_E2H		_BITULL(34)
>  
>  #define INIT_HCR_EL2_EL1_ONLY	(HCR_EL2_RW)
> +#define INIT_HCR_EL2		(HCR_EL2_TGE | HCR_EL2_E2H | HCR_EL2_RW)
>  
>  #define SYS_HFGRTR_EL2		sys_reg(3, 4, 1, 1, 4)
>  #define SYS_HFGWTR_EL2		sys_reg(3, 4, 1, 1, 5)

