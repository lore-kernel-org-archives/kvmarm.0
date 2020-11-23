Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA30FC56202
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 14:40:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3287220782
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 14:40:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="dDlg28P+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3287220782
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6340D4BB5D;
	Mon, 23 Nov 2020 09:40:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X0lYrKKhOND7; Mon, 23 Nov 2020 09:40:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D33F4BB0A;
	Mon, 23 Nov 2020 09:40:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB104BB03
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 09:40:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2tvYyGPcr0em for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 09:40:00 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E71744B9E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 09:39:59 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id d142so18089730wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 06:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=IA/qfqyOklQJ79pqoG5f5P3U9Ipwq6yHC17vWE58tNA=;
 b=dDlg28P+Jh4WcUUlhAaq1JtPUuluHcfx65ApOfbVNU1dBa9Ao9nNN3oqUjtpo4n2RL
 bs55n7JhmPAMJu5SsUcgF5jAQujYSTMh3gIGsli/knyqFXfi7M7MHR6GJcRTuLW1hAKj
 oDL+sXKgB4ohn7ghXtJVILlso5bwoVTIprgaJOATeg0t+sdmnK259j0WIEcZaUoGG5zI
 nGNhrjlStyWjlCeEriRzGA6e4f5MMBCusLNYE6yOnGB6KBQe2TBnq8tpOpBVz7OwN/0P
 Xo/FufSf0lPAAyfrQoasy/ymA8ZPqtqL8xuT/eBCyPxzhzqP0QRTuj3y7WyhXwzCkLGN
 5XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=IA/qfqyOklQJ79pqoG5f5P3U9Ipwq6yHC17vWE58tNA=;
 b=NMdMbgRYG1qT2z3BMVuv6ozpEdJcNDlixMfrUKaUGP4OSRF9V2Udjl7+dgD40e6nUP
 BSv1nxoHU9C+JRBP5xpuWy9fxKHAc+Azwoi2IGRGmPFNAgkD7m9smgPHnVigeG2ecRAV
 vNNkHQb8MsXyKnHSi9ROhaAEjPCcT6TRDyWGBsm6n8ETp2DY53e9fw5wq6tnEE1X6He9
 3LC5VMy1VBKr8hj1WWJNltS2cG0nW71rPu/mLZjNEEi2vZNovSrRnJMTHd6LDVQxgvrl
 MOQnuZ6pxH07yxgynmAa7D7R+eXpbTZpfihWBN2GazgEtlxT5afLvuPlkFIiNrJxhDEs
 96Vw==
X-Gm-Message-State: AOAM533GxocU1NcUqOQZXmU725XcuHnBE6dWu3iKZeFi1Zsa73vrLXcc
 dIpwMJmPEtQwgVt4SyPJVs6wMg==
X-Google-Smtp-Source: ABdhPJzKkhqMWPHaBtD6XLWKHtSpwRHpjKsbcwlUiF4pqtF3mjusg9s7MoY8/c/6bW3rqWv2KFWqkg==
X-Received: by 2002:a7b:c157:: with SMTP id z23mr23864861wmi.70.1606142398827; 
 Mon, 23 Nov 2020 06:39:58 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id f17sm17235287wmh.10.2020.11.23.06.39.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 06:39:58 -0800 (PST)
Date: Mon, 23 Nov 2020 14:39:54 +0000
From: Quentin Perret <qperret@google.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [RFC PATCH 13/27] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <20201123143954.GA578849@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-14-qperret@google.com>
 <20201123132223.oohevce4izuoaqi3@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201123132223.oohevce4izuoaqi3@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Monday 23 Nov 2020 at 13:22:23 (+0000), David Brazdil wrote:
> Could you help my understand why we need this?
> * Why do we need PI routines in the first place? Would my series that fixes
>   relocations in hyp code remove the need?
> * You added these aliases for the string routines because you were worried
>   somebody would change the implementation in arch/arm64/lib, right? But this
>   cache flush function is defined in hyp/nvhe. So why do we need to point to
>   the PI alias if we control the implementation?

Right, in the specific case of the __flush_dcache_area() function none
of the PI stuff is really needed I think. I did it this way to keep
things as consistent as possible with the host-side implementation, but
that is not required.

I understand this can cause confusion, so yes, I'll simplify this for
v2.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
