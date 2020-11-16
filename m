Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3CCC2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 17:56:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDEE520B80
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 17:56:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="sdIhKOXd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDEE520B80
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E93B4B9A3;
	Mon, 16 Nov 2020 12:56:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ct4FZqQizHmL; Mon, 16 Nov 2020 12:56:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3662C4B9B5;
	Mon, 16 Nov 2020 12:56:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 608584B99C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:56:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wbHABbcd8ows for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 12:56:39 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 620AE4B98A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:56:39 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id c9so109434wml.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 09:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xaNTxNoQPnXnoUb4r3iV3mkFKbHJuRiufvKdd63kC7I=;
 b=sdIhKOXdzOYUd+0zNv8c0adHbCQpoXeesxkjDLAWcVsQPMNDpfluCLKkFw4WfVYV2U
 T4Lz4ZqbN1XalTec7vHfSnyzVHrGMdF7wclbYRmO3LLQfhJopfg2xSZxPgYaf+i2tjPY
 V2TKzLtaYd0cs8iOJ3X1mjjRUUpt+mng4ZKIpkfQ+qHCFS29msT7SFYYx4p7lHs9wOl5
 fv1KQionDArngXPYQxG9i/TfiCd3A2uIbWu9nzce8vKzKcgc9mPpxL8avcoVPIZDkLL7
 QC/2UIKH/WrfxI3/ZMXY/zKHjO5bVHqehzf6TdSeb0koVcSwzq+7la8pSEjEQ6PlwYUr
 DiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xaNTxNoQPnXnoUb4r3iV3mkFKbHJuRiufvKdd63kC7I=;
 b=TiEHLmA++u2tmqLfVhsz69lCtAWcA3IOPwloG7yewMqm+ZqRZMx5ZzlkGJ7cgbePmO
 a8zfaLTWt8J/wuK/a0j7DC5B74oHDLzgtquXFQlEz9O5FEOjoE5q3kjGN/9eYwfWAzeT
 eyk0U53QLOdHU6q9s3NRM8O4w43k+sKX06qW/hliZclJcT9Z9pR919c9hz+esyQ6XI4+
 UU64+xkuYRT+V8sy1FJEC2uqYRka3cyQdBFIrvRpwjShWs09I2IiBhy1WkcEck14OVAa
 2gjf2oguA5veRDmeY5t8aJmA0r+D2W+AELWAZVrahG+qG6mqBB5t42cHHrFugbgSGVpj
 nnGg==
X-Gm-Message-State: AOAM533YBDvxCvmUbd8U9jLEmCcv9eDXUJ8QrQ+KanKnpNjneGjAD4b2
 i9iuKAMd1L8B1JrAzmBoZc21yA==
X-Google-Smtp-Source: ABdhPJzq+YhoQ9FGcQcT1hEJKNYAgJc8ZImY4yxRsCLZhalfs1c7PQkN19eo6JoF/FMRMs7CfUQDxw==
X-Received: by 2002:a05:600c:2202:: with SMTP id
 z2mr43648wml.115.1605549398247; 
 Mon, 16 Nov 2020 09:56:38 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:58a8:7836:6672:a072])
 by smtp.gmail.com with ESMTPSA id z189sm69814wme.23.2020.11.16.09.56.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 Nov 2020 09:56:37 -0800 (PST)
Date: Mon, 16 Nov 2020 17:56:36 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 10/24] kvm: arm64: Extract parts of el2_setup into a
 macro
Message-ID: <20201116175636.qmp5iws6gq7a7syi@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-11-dbrazdil@google.com>
 <a6f5d318eb7e7adde2106df068121b48@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a6f5d318eb7e7adde2106df068121b48@kernel.org>
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hi Marc,

> > +	 * Check for VHE being present. x2 being non-zero indicates that we
> > +	 * do have VHE, and that the kernel is intended to run at EL2.
> >  	 */
> >  	mrs	x2, id_aa64mmfr1_el1
> >  	ubfx	x2, x2, #ID_AA64MMFR1_VHE_SHIFT, #4
> > -#else
> > -	mov	x2, xzr
> > -#endif
> > +	cbz	x2, el2_setup_nvhe
> 
> What initialises x2 to zero when CONFIG_VHE is disabled?

There is no need for x2 anymore, the nVHE code just falls through. Basically:

	el2_setup:
		< check CurrentEL >
		b.eq	1f
		ret
	1:
	#ifdef CONFIG_VHE
		< check has VHE >
		cbz	el2_setup_nvhe
		< VHE setup >
		ret
	#endif
	el2_setup_nvhe:
		< nVHE setup >
		eret

-David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
