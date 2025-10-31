Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6781132ABD0
	for <kvmarm@lists.linux.dev>; Fri, 31 Oct 2025 08:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761898182; cv=none; b=P3Ioxv9/73E9CSAlQtrfC7LorywQPPRe/gju6Sz6l9wa2Y+Y/NmriNqAvj/Pg59OBx0hj4VlPu0gmfH5oZGbmgcEjgTof8RqyCYCGWcXrE2cGUAH9JQgULiS4oYotUdxCk4+OGgeBmzmzS/JMMiK9wS3WrdcuNL4/H1vYK0YoNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761898182; c=relaxed/simple;
	bh=kf8HyOsYwdOePIqwVTCWV7fE1+Z/HvbEoskwb19+yBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFgXVHxItAR0SLYMhFvxeOd6kiSArTlxFgEAkh0XYVENccEof/Od4uDEbOE28oM1v/LxRQ2GGwcU7Kk8H6dPKjoviOiWFpdTHmQtmd+2f9WLwIZkXR+v4Pjo8xxL6AW7Q9XMxahrA1C01DU6xGv9BtN90URNmB6NBtbaTCv4ZIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L89v0xFo; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L89v0xFo"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4770d4df4deso32765e9.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Oct 2025 01:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761898179; x=1762502979; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VvPD2QlzwFWzsFKSo3tRWtjQG+OHFkXfXTJssyHMdKI=;
        b=L89v0xFom4/Z/c/4yFdFSfOlYwC/uem8J6kddZmU1PM94QLXXrgK/MerxjcSgkocnC
         WQt3m1TWaByBozznfvT2JiG2Eyj+Oqg63iyofJAK3iSDiefsYE4mWvPmn9Fx5IDTy1YR
         6HWomeb+30o8Ur9pBA/cC65OjZGxMycwSs6Wb0VD7AsfIuhMBYUDos7Dw2HeJOscerGy
         uUcU3iiEhcIHU9dKZiyL+7cx/7VBEDvi1jNSNIaRFfyBKaqNDS/gfxn/sX56KPTS06z6
         cNfr3SvzffBuApBef4aTXnDHDnz2ETe0gaLAp5/NfoyhTE+KZUDUKzTfHA7eRaUBBvin
         Ndmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761898179; x=1762502979;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VvPD2QlzwFWzsFKSo3tRWtjQG+OHFkXfXTJssyHMdKI=;
        b=kNirGcumPywMz1qp7Go+lhYduVt7HCkkKiTvjPRYIuvAscPOnhMvKYOHce2WZGRV3a
         5x0C0cqHA47sGw0xGMCWamrZhGg/5puvy1WkTMWeJ9+ybch6FudAi0j013qBdN6RfOWS
         LzNaf8etkjIPeqzSkUnnOlUovQNasAZgp3U9JKYdAyqMc1r204QUYjZA6270A7aTq+wc
         cTQVvs1Rdz37XYeU+C9NeaF2eERE+nLBt9mFAa8celoyzWksaqOjNLq6o39BYMuUKWUD
         1o+NGoI3lOIa//W+gKapEhvaSLRaMM8VY+XRhWYmOPPwe4kLEYpjSm5PQ7eh1MhcVOJg
         CvYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyWjafkIxGvevGt/1JENHBG6A5W26VYIa02p2I+ibGmpVYwchJUgDAO2/Bf0/l3HLC0sEiR6Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXxqTFJxwIvh4ENinr2FtZDa1DtuSyKY39W1PgoYMmYToSX7cO
	km0f/1QSb+YpHD8s79U9CnnCPzb+9Qpc1mnsQJuCH3ohrd9lJJO8CMPD+ommBufXjg==
X-Gm-Gg: ASbGncsyZi6GzPtKeFmhKBstRgzalrCZVbBRGW4rjvooGeWfwGKnOvZ6pgY+lIpDLm0
	ikaSP+77PE57DAjIdDlCQOK6guiVaCop6QRF/Er2K003wgkvfERY5sJvgeWdOQL0XLGn+9OUEta
	1ZJNqcAAaDY1nZlU1++NXXV0WX8AT7KxQCRLcxG9EmfJwji+gkGF1qda7emvCHNLukVfQZbj6+7
	RJ05wUsDFHrKBtklSqcG+yAMW9aFtvGjC7RL7SlgLIJkGIXRzJHev1rJsDjVBp+t2nFj013NJdq
	AjZDuPgp+RCi+zpHl0s3dVf4d7+xJl0oXMHaNbJb+d5m7jEQfwncYlmteFQdta+SjvJVNN9VLPe
	1y2ga9TnXToVmqQzpxSq0wSuR/d7j3AWrJV2bkDbtExJwXFYmdiBQHoaYKmVb6JVbQ+ayngg1ox
	OdgO6CTH+CZj1BFvjYdvgtbFnJu/spvuB3CoDr/Aq8mUSl2WoJUfou1xIF0g==
X-Google-Smtp-Source: AGHT+IEowXI+Xa7Cev+Atw93C9B+sivtK/myXmK5E4UjFwYC2UVYflMXTzX7icRn1YESBGhfSybnGw==
X-Received: by 2002:a05:600c:3ba8:b0:477:1afe:b962 with SMTP id 5b1f17b1804b1-477324afbe5mr1342845e9.1.1761898178470;
        Fri, 31 Oct 2025 01:09:38 -0700 (PDT)
Received: from google.com (177.112.205.35.bc.googleusercontent.com. [35.205.112.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47733023256sm19735575e9.17.2025.10.31.01.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 01:09:37 -0700 (PDT)
Date: Fri, 31 Oct 2025 08:09:34 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, perlarsen@google.com,
	ayrton@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: fix FF-A call failure when ff-a driver
 is built-in
Message-ID: <aQRuvu8V3woqnqCV@google.com>
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
 <20251027191729.1704744-2-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251027191729.1704744-2-yeoreum.yun@arm.com>

On Mon, Oct 27, 2025 at 07:17:28PM +0000, Yeoreum Yun wrote:

Hi Yeoreum,

> Until has_version_negotiated is set to true,
> all FF-A function calls fail except FFA_VERSION.
> The has_version_negotiated flag is set to true when
> the first FFA_VERSION call is made after init_hyp_mode().
> 
> This works fine when the FF-A driver is built as a module,
> since ffa_init() is invoked after kvm_arm_init(), allowing do_ffa_version()
> to set has_version_negotiated to true.
> 
> However, when the FF-A driver is built-in (CONFIG_ARM_FFA_TRANSPORT=y),
> all FF-A calls fail. This happens because ffa_init() runs before
> kvm_arm_init() — the init level of ffa_init() is rootfs_initcall.
> As a result, the hypervisor cannot set has_version_negotiated,
> since the FFA_VERSION call made in ffa_init() does not trap to the hypervisor
> (HCR_EL2.TSC is cleared before kvm_arm_init()).
> 

I understand the reason behind the patch but this is problematic to have
the builtin driver load before pKVM because the hypervisor would be
un-aware of the host mapped buffers. (eg. the call from ffa_rxtx_map is
not trapped because it is too early). Essentially, you will end up
bypassing the hyp FF-A proxy which I think you will want to avoid.

> Consequently, this causes failures when using EFI variable services
> with secure partitions that rely on FFA_SEND_DIRECT_MSG.
> 
> To fix this, call hyp_ffa_post_init() and set has_version_negotiated
> during hyp_ffa_init() when the FF-A driver is built-in (CONFIG_ARM_FFA_TRANSPORT=y).
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 4e16f9b96f63..0ae87ff61758 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -984,5 +984,17 @@ int hyp_ffa_init(void *pages)
>  	};
>  
>  	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
> +
> +	if (IS_BUILTIN(CONFIG_ARM_FFA_TRANSPORT)) {
> +		hyp_spin_lock(&version_lock);
> +		if (hyp_ffa_post_init()) {
> +			hyp_spin_unlock(&version_lock);
> +			return -EOPNOTSUPP;
> +		}
> +
> +		smp_store_release(&has_version_negotiated, true);
> +		hyp_spin_unlock(&version_lock);
> +	}
> +
>  	return 0;
>  }

Thanks,
Sebastian

> -- 
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> 
