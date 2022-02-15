Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D06CC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Feb 2022 18:54:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75CD149DF6;
	Tue, 15 Feb 2022 13:54:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IMQg74xL-HWr; Tue, 15 Feb 2022 13:54:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0795849ED1;
	Tue, 15 Feb 2022 13:54:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B63849DF6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 13:53:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T0utkOW36oIe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Feb 2022 13:53:58 -0500 (EST)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com
 [209.85.166.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26CA249ECF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 13:53:58 -0500 (EST)
Received: by mail-io1-f42.google.com with SMTP id r144so25036071iod.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 10:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Yx1B/cs7/hXpHc5o53p2VfNCQ8b83twxE6k0Rej+Yk8=;
 b=eAAyLSjaB5SUjk+1n/lRwJZogI1aqp2R5DvFmrEQYCGCf6geLREv7owAy5sYJpZn4N
 RXc11qrNNmvhuMoRR7Iz3p+76JR2CEhCqPCae+oW58ZndYMkAMrDp3vwWpaGYsydNs6l
 G5/vHS0A+vd9/pQj5TkbNLBjntdfQ7KdWAkDZOV9VsY+Q0I4dR+FQV3fcx4r3y8N4twT
 1ZipnLyI7ZEXovK6l81zFNw1qE6WIHXuEn51/aFFhUB4TsCMnkw6X1l4xwiFmyN7jRAI
 cL+MATrXMay6ss3mFgPrsiRqowhJXd7DCXd7noFnP+KXp11SApZA7miyQBPxyjRLCldQ
 kTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Yx1B/cs7/hXpHc5o53p2VfNCQ8b83twxE6k0Rej+Yk8=;
 b=sRc7p0othGFDAEGykmTZ6DvxtzxTwY6U4GH/o9eGfay9c6HdG2s/1SjUcvMjjCIklU
 VT1CMupBW5z5sd3QfM5XHxpGjEn/rHD0mMQv9REt28ttpETc9+wFnHanNuvPw5RE5V7h
 X2/anp8IrZQD5mMydu+R9++i2mMmOq0nMyQppJZGaVSQuw0V7S4amWDNfUJPMyGdRGxM
 KB/a8a10B+6+UPqommUFL3bHU9ZOXlpCjAjfYysZuv/TA6N510x3Mbvx6mUYZ8OoDNl0
 thpqJquKsB0Uy554kfVTt3HIpFH6lhYRGGDdLIwY8jI7sFJvy0rx0RVImHa+i2ci+ZwR
 W4rA==
X-Gm-Message-State: AOAM532jfEUXnlKntGYEljq54XLMtw1js6FhXqnETnqwMV2XUPdrjRuj
 ZmvBfGEd4HioRMaSgaKqgJfATw==
X-Google-Smtp-Source: ABdhPJzzeZLPtmDYqHqSvCizKyae+6eZF1KsXoBDzTL0pIOFtruI9XNo23MRTW5nI8sMZENvq4WhqA==
X-Received: by 2002:a05:6638:2217:: with SMTP id
 l23mr190891jas.190.1644951237062; 
 Tue, 15 Feb 2022 10:53:57 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id k9sm6734677ilv.31.2022.02.15.10.53.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Feb 2022 10:53:56 -0800 (PST)
Date: Tue, 15 Feb 2022 18:53:53 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v5 09/27] KVM: arm64: Make ID_AA64MMFR1_EL1 writable
Message-ID: <Ygv2wS8qdlu1YnA6@google.com>
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-10-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220214065746.1230608-10-reijiw@google.com>
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

Hi Reiji,

On Sun, Feb 13, 2022 at 10:57:28PM -0800, Reiji Watanabe wrote:
> This patch adds id_reg_info for ID_AA64MMFR1_EL1 to make it
> writable by userspace.
> 
> Hardware update of Access flag and/or Dirty state in translation
> table needs to be disabled for the guest to let userspace set
> ID_AA64MMFR1_EL1.HAFDBS field to a lower value. It requires trapping
> the guest's accessing TCR_EL1, which KVM doesn't always do (in order
> to trap it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which
> also traps many other virtual memory control registers).
> So, userspace won't be allowed to modify the value of the HAFDBS field.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4ed15ae7f160..1c137f8c236f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -570,6 +570,30 @@ static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int validate_id_aa64mmfr1_el1(struct kvm_vcpu *vcpu,
> +				     const struct id_reg_info *id_reg, u64 val)
> +{
> +	u64 limit = id_reg->vcpu_limit_val;
> +	unsigned int hafdbs, lim_hafdbs;
> +
> +	hafdbs = cpuid_feature_extract_unsigned_field(val, ID_AA64MMFR1_HADBS_SHIFT);
> +	lim_hafdbs = cpuid_feature_extract_unsigned_field(limit, ID_AA64MMFR1_HADBS_SHIFT);
> +
> +	/*
> +	 * Don't allow userspace to modify the value of HAFDBS.
> +	 * Hardware update of Access flag and/or Dirty state in translation
> +	 * table needs to be disabled for the guest to let userspace set
> +	 * HAFDBS field to a lower value. It requires trapping the guest's
> +	 * accessing TCR_EL1, which KVM doesn't always do (in order to trap
> +	 * it without FEAT_FGT, HCR_EL2.TVM needs to be set to 1, which also
> +	 * traps many other virtual memory control registers).
> +	 */
> +	if (hafdbs != lim_hafdbs)
> +		return -EINVAL;

Are we going to require that any hidden feature be trappable going
forward? It doesn't seem to me like there's much risk to userspace
hiding any arbitrary feature so long as identity remains architectural.

Another example of this is AArch32 at EL0. Without FGT, there is no
precise trap for KVM to intervene and prevent an AArch32 EL0.
Nonetheless, userspace might still want to hide this from its guests
even if a misbehaved guest could still use it.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
