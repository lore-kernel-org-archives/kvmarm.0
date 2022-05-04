Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523BFC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 06:35:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCB1A4B11C;
	Wed,  4 May 2022 02:35:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sOU4wNgz6TMh; Wed,  4 May 2022 02:35:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A564D49F29;
	Wed,  4 May 2022 02:35:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31CF549F0C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 02:35:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lvE64GBK9iFG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 02:35:35 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EECC549EF2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 02:35:34 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id f4so574432iov.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 23:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5vzaRTCV35kUkQfzNk+SKbEZOUsmK/lhYqqKeLrO+iA=;
 b=nY7I8v9LmP+4+y+Pl5sP80ms0losTfV9G/Y4PGylKqQxcdscu+cYTM+ORUo92C4kUt
 O7aDwIZq9zv1kk5qQCYC3SS8FWkEGveM1Huk39aQLx02Mj20oi6WhjeLWZDBe9OV7EWI
 rdN57Mw0ScAJPvugQHwUwkv9Q1Qkba/kaBpkxO2DnP0t1NUTZEkbCqCxtbYadsfI7XYg
 EHwpwS70sBGfwALZnLVWWslcWVF0my2IMURLbG7/TLEMOvb9A4QT57ksbl1We5aIKhaK
 Re++9wvrBCNiT7UJ5yppLUpD6+2A3bhjBU12ZS2pfjMgS6OhmD3a3x2WJBNmVOScw/i/
 /ANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5vzaRTCV35kUkQfzNk+SKbEZOUsmK/lhYqqKeLrO+iA=;
 b=W7p8N9UbfuIOWNT3Sp8c1qMmn3uuze4rMIQil910gYZ1shRzjRBGYD/DA9HOUnHk6F
 GKeEBRQ+cKSuv0pSQm170kY7t/jwRXwHdRZO+PCik901qqhjmKUoiaI+rARSfB0IPQje
 mM8lKrPc/PkjofpYmAzTfgRULtKghneWdyPcOC+SHhnTFeTb3xh/dg6fIGTgH78XSd+O
 XTwAzmFVtTIptbzW4ljliYLQcZ6XmhYgewOM0jWcrUMA1iIPYuQWcw5BDaxZmpfm40py
 vXF84TOaxJVvco+1Gt3noOk12KoqMFpTTQ0RSNbt/Os3Ffhu96K2EqDcbsNdSbcJRCHy
 0iYw==
X-Gm-Message-State: AOAM5316fQvBKQVJFb6NQ29Lr/d6m/7XrP/MWVVdSQku/tAFKoS4y+gA
 Lp7Ou3whYqNZyDIqLiQsEynO0w==
X-Google-Smtp-Source: ABdhPJwbDoRQpuN7Pfwdsey3kldhkCPsI++0DJuLGbXAwnQJK4QnnF38LPx899UzWmlKxd1ScbQAZQ==
X-Received: by 2002:a02:6f47:0:b0:32b:2be7:e3e4 with SMTP id
 b7-20020a026f47000000b0032b2be7e3e4mr7911068jae.305.1651646134045; 
 Tue, 03 May 2022 23:35:34 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 w26-20020a02b0da000000b0032b3a781784sm4480757jah.72.2022.05.03.23.35.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 May 2022 23:35:33 -0700 (PDT)
Date: Wed, 4 May 2022 06:35:29 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>, h@google.com
Subject: Re: [PATCH v7 01/38] KVM: arm64: Introduce a validation function for
 an ID register
Message-ID: <YnIesawWNhBwZydM@google.com>
References: <20220419065544.3616948-1-reijiw@google.com>
 <20220419065544.3616948-2-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220419065544.3616948-2-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Peng Liang <liangpeng10@huawei.com>,
 Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Apr 18, 2022 at 11:55:07PM -0700, Reiji Watanabe wrote:
> Introduce arm64_check_features(), which does a basic validity checking
> of an ID register value against the register's limit value, which is
> generally the host's sanitized value.
> 
> This function will be used by the following patches to check if an ID
> register value that userspace tries to set for a guest can be supported
> on the host.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  1 +
>  arch/arm64/kernel/cpufeature.c      | 52 +++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index c62e7e5e2f0c..7a009d4e18a6 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -634,6 +634,7 @@ void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
>  u64 __read_sysreg_by_encoding(u32 sys_id);
> +int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit);
>  
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index d72c4b4d389c..dbbc69745f22 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -3239,3 +3239,55 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>  		return sprintf(buf, "Vulnerable\n");
>  	}
>  }
> +
> +/**
> + * arm64_check_features() - Check if a feature register value constitutes
> + * a subset of features indicated by @limit.
> + *
> + * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated by
> + * an item whose width field is zero.
> + * @val: The feature register value to check
> + * @limit: The limit value of the feature register
> + *
> + * This function will check if each feature field of @val is the "safe" value
> + * against @limit based on @ftrp[], each of which specifies the target field
> + * (shift, width), whether or not the field is for a signed value (sign),
> + * how the field is determined to be "safe" (type), and the safe value
> + * (safe_val) when type == FTR_EXACT (safe_val won't be used by this
> + * function when type != FTR_EXACT). Any other fields in arm64_ftr_bits
> + * won't be used by this function. If a field value in @val is the same
> + * as the one in @limit, it is always considered the safe value regardless
> + * of the type. For register fields that are not in @ftrp[], only the value
> + * in @limit is considered the safe value.
> + *
> + * Return: 0 if all the fields are safe. Otherwise, return negative errno.
> + */
> +int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit)
> +{
> +	u64 mask = 0;
> +
> +	for (; ftrp->width; ftrp++) {
> +		s64 f_val, f_lim, safe_val;
> +
> +		f_val = arm64_ftr_value(ftrp, val);
> +		f_lim = arm64_ftr_value(ftrp, limit);
> +		mask |= arm64_ftr_mask(ftrp);
> +
> +		if (f_val == f_lim)
> +			safe_val = f_val;
> +		else
> +			safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);
> +
> +		if (safe_val != f_val)
> +			return -E2BIG;
> +	}
> +
> +	/*
> +	 * For fields that are not indicated in ftrp, values in limit are the
> +	 * safe values.
> +	 */
> +	if ((val & ~mask) != (limit & ~mask))
> +		return -E2BIG;

This bit is interesting. Apologies if I paged out relevant context. What
features are we trying to limit that exist outside of an arm64_ftr_bits
definition? I'll follow the series and see if I figure out later :-P

Generally speaking, though, it seems to me that we'd prefer to have an
arm64_ftr_bits struct plumbed up for whatever hits this case.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
