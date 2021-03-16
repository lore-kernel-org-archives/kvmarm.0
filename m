Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B08C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 10:31:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B8B66502A
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 10:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B8B66502A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C87834B604;
	Tue, 16 Mar 2021 06:31:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VCy5068Ul4zr; Tue, 16 Mar 2021 06:31:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E4B4B5D6;
	Tue, 16 Mar 2021 06:31:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AD364B5D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 06:31:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZNNgG9Uw735B for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 06:31:50 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19CDF4B407
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 06:31:50 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id x13so7143315wrs.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 03:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=nidvh/89tn+Y/HVhz7QTE7lN1pMSoiQsRzITbdZvVck=;
 b=W1RROg28NSJY+h0JNcBa2OvIgqaoB2tDMiJU6Yuc1AWATHeOV/W7nAGnC706xuhnRg
 Y92LTO9v79rp5ZibisFG/OJXd1QSQsDUqLPYsba8dZx5W1og0IRzlUqMVm/Z7Ld7O8Pu
 ueWROCrphU1orMKIERU6TjPyZLuRJdEPKmsUKTyjpTkrJk/QiHEcaEBsASeatZkRJwI4
 zSqUBkLUmYjBtJv9M2MLl6MXRgwC5JHcFxprBmGIF5U6uDou5yifMF8RfGwWXEHog6i5
 Mzyl0VryqajrdJXkE/dw5iNFe47bk2QbScCn5nbuIWb0nSSurj/ZuiWicIY7YZe/kAmD
 vExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nidvh/89tn+Y/HVhz7QTE7lN1pMSoiQsRzITbdZvVck=;
 b=OJVzCpcMtaoxGqmJwROGmLtEwHPXWppFoH/JQrVZp4v63CRwSP6xJOBk5U319pSxd4
 lNuKD/J8KX7dkSgIyx2n49eoxzlBm06YCle2R7WK0o9zn0QcNLExfdFOHhUV5pBjchg/
 1TwgfAyM7T1VDvBz7pyH2nXy/O1RJiry3Ty36cs9qNhMVzoSh6SZrhJy7RXXYL5X77hx
 GiGx5d5OasevD6E1RRX99vJlUwL9buJe/Jp4EQWJ8M50V8ldstKk+Fv05hJiOFCg8/jh
 rZWqXFK8rdTtwYXzykykg1Ggc1gIwnCFumzykKX80fYUrEooE/ppXUbhXLA0EriFja1K
 KM5g==
X-Gm-Message-State: AOAM532MKviQHdBxqpoSoeNCuTWulaTYQFooyqHdhxX4HNHrDE4t06T4
 CnAQqy2h36HWcZR1wNq1n/u1PQ==
X-Google-Smtp-Source: ABdhPJz9EQO1Z6JuVEny9FQp/kgBd99pD2l8NgikvLXqL/mEIHDS8WGg/zebhRv8UldsnFywXQplgg==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr4028400wrp.89.1615890709026; 
 Tue, 16 Mar 2021 03:31:49 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id s18sm24967422wrr.27.2021.03.16.03.31.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 16 Mar 2021 03:31:48 -0700 (PDT)
Date: Tue, 16 Mar 2021 10:31:46 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 01/10] KVM: arm64: Provide KVM's own save/restore SVE
 primitives
Message-ID: <YFCJEgjUZ5cnq0AK@google.com>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-2-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 broonie@kernel.org, Will Deacon <will@kernel.org>, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Tuesday 16 Mar 2021 at 10:13:03 (+0000), Marc Zyngier wrote:
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index 01f114aa47b0..e4010d1acb79 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -19,3 +19,13 @@ SYM_FUNC_START(__fpsimd_restore_state)
>  	fpsimd_restore	x0, 1
>  	ret
>  SYM_FUNC_END(__fpsimd_restore_state)
> +
> +SYM_FUNC_START(__sve_restore_state)
> +	sve_load 0, x1, x2, 3, x4
> +	ret
> +SYM_FUNC_END(__sve_restore_state)

Nit: maybe this could be named __sve_load_state() for consistency with
the EL1 version?

> +SYM_FUNC_START(__sve_save_state)
> +	sve_save 0, x1, 2
> +	ret
> +SYM_FUNC_END(__sve_restore_state)

SYM_FUNC_END(__sve_save_state) here?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
