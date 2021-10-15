Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970DEC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 13:31:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 065A0611EE
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 13:31:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 065A0611EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62C714B126;
	Fri, 15 Oct 2021 09:31:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 33ZWY+s0uTHn; Fri, 15 Oct 2021 09:31:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26AED4A19A;
	Fri, 15 Oct 2021 09:31:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36B384B1D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 09:31:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sbKmEWSyb7-E for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 09:31:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5D894B183
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 09:30:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634304643;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TzclPTF3LlBIf4dbbRNEyBzW3ai4bqqCccg0ARotygI=;
 b=crYAenY2G1RE7Ie5Fcpy4+2nil1KetSJswBZ1HkHS7maZjWqxZr30IJ2B/bxzaNnOLvPIb
 ioa2HpWBoFUVq3oFlDXRAqMEsPShHpqdinF6UfZm4fOIbw69G7RKnBJ5gyCsbAFW0txR54
 lGtEXVD6Cm59Exm0c4LctxdoOnOUCEk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-iclSCeqlMKyBV7xBHoCPgQ-1; Fri, 15 Oct 2021 09:30:42 -0400
X-MC-Unique: iclSCeqlMKyBV7xBHoCPgQ-1
Received: by mail-wr1-f72.google.com with SMTP id
 s1-20020adfc541000000b001645b92c65bso709226wrf.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 06:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TzclPTF3LlBIf4dbbRNEyBzW3ai4bqqCccg0ARotygI=;
 b=coWn9nX6Y0oT4b/Fs5DoGeleDpkxkIbXiJhKLcoYPqiNAUKtT2UWPq2ED5rfr00Aus
 fv1Ox9TLY1FHe6u+GzHmuIoa3plQlzUHUD6HNonEW3VBlygJUEZAxJn9qPC+vlUBzYPU
 HoOxCXnSYfovMQCAVnS1rB32+IeqhAAIo0jYY7cuwffop1/d+5+yvJncawdTRGiBBFhA
 LwZ3R4w1/A482rirdF5Z9g43do2fczNixrZ5zzE6bL0PFOqBx7bkqzVSw9J6vIO/tQUY
 cdkOpbxqOKdlB7rYukiJyFA9zgnidG0icD3nCUGITv/X/Gw5YjYdYUJVpuTrzWcYNBz9
 /guA==
X-Gm-Message-State: AOAM531iGhCoSuUgajHM4tnOHauOy+Tz1Z4bTjfmum7pSqKxnTruKCEc
 ywjwA724KvPmBK2L9pImCPYOCEoYf7aEGGsY7P21OxB4a0Y5F9Ba2HW55MFSUWW/3ZLROFgRDkl
 IBnljS2ewODmOlHSuKWjhPR6q
X-Received: by 2002:a05:6000:188e:: with SMTP id
 a14mr13773724wri.223.1634304640989; 
 Fri, 15 Oct 2021 06:30:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUVezSIzJykePD1chYmayDwCb5Y2ipNT/EUSs/rogejtsd3QRAM6NctsUUaVjY+/q5r5cySQ==
X-Received: by 2002:a05:6000:188e:: with SMTP id
 a14mr13773693wri.223.1634304640760; 
 Fri, 15 Oct 2021 06:30:40 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id y5sm4715733wrq.85.2021.10.15.06.30.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Oct 2021 06:30:40 -0700 (PDT)
Date: Fri, 15 Oct 2021 15:30:38 +0200
From: Andrew Jones <drjones@redhat.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH 03/25] KVM: arm64: Introduce a validation function
 for an ID register
Message-ID: <20211015133038.xfyez4rvxbs5ihmg@gator>
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-4-reijiw@google.com>
MIME-Version: 1.0
In-Reply-To: <20211012043535.500493-4-reijiw@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 11, 2021 at 09:35:13PM -0700, Reiji Watanabe wrote:
> Introduce arm64_check_features(), which does a basic validity checking
> of an ID register value against the register's limit value that KVM
> can support.
> This function will be used by the following patches to check if an ID
> register value that userspace tries to set can be supported by KVM on
> the host.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  1 +
>  arch/arm64/kernel/cpufeature.c      | 26 ++++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index ef6be92b1921..eda7ddbed8cf 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -631,6 +631,7 @@ void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
>  u64 __read_sysreg_by_encoding(u32 sys_id);
> +int arm64_check_features(u32 sys_reg, u64 val, u64 limit);
>  
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 6ec7036ef7e1..d146ef759435 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -3114,3 +3114,29 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>  		return sprintf(buf, "Vulnerable\n");
>  	}
>  }
> +
> +/*
> + * Check if all features that are indicated in the given ID register value
> + * ('val') are also indicated in the 'limit'.

Maybe use @<param> syntax to reference the parameters, even though this
file doesn't seem to adopt that anywhere else...

> + */
> +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> +{
> +	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
> +	const struct arm64_ftr_bits *ftrp;
> +	u64 exposed_mask = 0;
> +
> +	if (!reg)
> +		return -ENOENT;
> +
> +	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
> +		if (arm64_ftr_value(ftrp, val) > arm64_ftr_value(ftrp, limit))

Hmm. Are we sure that '>' is the correct operator for all comparisons? It
seems like we need a arm64_ftr_compare() function that takes
arm64_ftr_bits.type and .sign into account.

> +			return -E2BIG;
> +
> +		exposed_mask |= arm64_ftr_mask(ftrp);
> +	}
> +
> +	if (val & ~exposed_mask)
> +		return -E2BIG;

I'm not sure we want this. I think it implies that any RAO bits need to be
cleared before calling this function, which could be inconvenient.

Thanks,
drew

> +
> +	return 0;
> +}
> -- 
> 2.33.0.882.g93a45727a2-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
