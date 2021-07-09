Return-Path: <SRS0=w/1t=MB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4283FC07E9B
	for <kvmarm@archiver.kernel.org>; Fri,  9 Jul 2021 09:25:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D339E613DF
	for <kvmarm@archiver.kernel.org>; Fri,  9 Jul 2021 09:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D339E613DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 884134A19E;
	Fri,  9 Jul 2021 05:25:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ewCUcqLPOnhP; Fri,  9 Jul 2021 05:25:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCB8B4AC80;
	Fri,  9 Jul 2021 05:25:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B22D40068
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 03:52:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xR7jlL8qpxQb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jul 2021 03:52:06 -0400 (EDT)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95BA640016
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jul 2021 03:52:06 -0400 (EDT)
Received: by mail-pj1-f51.google.com with SMTP id
 h1-20020a17090a3d01b0290172d33bb8bcso7807403pjc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Jul 2021 00:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=O9yEJ/RI8DyqTUqQc7qvFOA41xcGAb9AUJUpJSi1YCk=;
 b=hykJA/Js2Xkhhe70Ko9i6iWvtj5MCdYDu7B/4u+DpVpsKePBnWY5j4t4PmJ+/N5Tma
 i74pAgLdfgxkaGf4SgAwZgceXKJ7rvLOQBWSmhuTfRMGbGSTEGg8Y90WlqU6AxZc1+ne
 VnQDpGlScVjcXYoN01FMKeV5pUHPa6XpOQzAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=O9yEJ/RI8DyqTUqQc7qvFOA41xcGAb9AUJUpJSi1YCk=;
 b=ju4SpexdiDGjEnKD7Tj9RxgxbZxMRlot3fC/6RX59KdNrAF2jP+wPFBLhJ4QPjQTU8
 xchXBYRlLbTlVGTAD3acWt0tBDkfkmCTL2hmECKy7QOEFJerqC2KZxd6CoD7ylDNfZbT
 JYfxd9OoMywpvmowHbc/5yGpm3/pfBKwu+mi/OmF0stsWZNt7pFcP4mVJq1oi4/lAElZ
 uMgsuUEJdQ3CVFm3WnPlkCk5XI0GFziuYEye5O7deKWFZIVUgRmCAPTGNE2dWseJKf98
 HN/mWornm+NVlsmj2Z/lrqYNur3zINWJ8oyvaf8aTMDIF5aOPe+ysckwYqhAIfR/ZjrV
 ckJw==
X-Gm-Message-State: AOAM531+R51JXFz+KNIlXZi28r89qxLozL0/s7iTmqWjyTBCwASHwIsD
 NzaN4ogjuIaxyxk+liE9MfUEHw==
X-Google-Smtp-Source: ABdhPJy5Iba/1n9IqX8ohIsdLkvuWXlXJvMJv1c0Hhbuj+FFhPRYR/07l1fWcSHSalGaLyrQsw0tBg==
X-Received: by 2002:a17:90a:5d16:: with SMTP id
 s22mr36261212pji.48.1625817125628; 
 Fri, 09 Jul 2021 00:52:05 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:a30d:fc4:7834:ee08])
 by smtp.gmail.com with ESMTPSA id 194sm5349713pfy.51.2021.07.09.00.52.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Jul 2021 00:52:05 -0700 (PDT)
Date: Fri, 9 Jul 2021 16:52:00 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: David Edmondson <dme@dme.org>
Subject: Re: [PATCHv2 2/4] arm64: add guest pvstate support
Message-ID: <YOgAIOBVhhD+on93@google.com>
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-3-senozhatsky@chromium.org>
 <m2v95k2axe.fsf@dme.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <m2v95k2axe.fsf@dme.org>
X-Mailman-Approved-At: Fri, 09 Jul 2021 05:25:42 -0400
Cc: Joel Fernandes <joelaf@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
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

On (21/07/09 08:39), David Edmondson wrote:
[..]
> > +
> > +static bool has_pv_vcpu_state(void)
> > +{
> > +	struct arm_smccc_res res;
> > +
> > +	/* To detect the presence of PV time support we require SMCCC 1.1+ */
> 
> "PV VCPU state support" rather than "PV time support".

Indeed. Thanks.

[..]
> > +static int pv_vcpu_state_register_hooks(void)
> > +{
> > +	int ret;
> > +
> > +	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
> > +				"hypervisor/arm/pvstate:starting",
> > +				vcpu_state_init,
> > +				vcpu_state_release);
> > +	if (ret < 0)
> > +		pr_warn("Failed to register CPU hooks\n");
> 
> Include that it's PV VCPU state hooks?

Ack.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
