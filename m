Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61875C388F9
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 13:52:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7EB1A20729
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 13:52:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="BgBnJ8EK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EB1A20729
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFDB04BB61;
	Mon, 23 Nov 2020 08:51:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QwZ6EJu+c-0M; Mon, 23 Nov 2020 08:51:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D4C94BB56;
	Mon, 23 Nov 2020 08:51:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43DC64BB4C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 08:51:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Av23S3O1X4fT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 08:51:56 -0500 (EST)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BE714BB4A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 08:51:56 -0500 (EST)
Received: by mail-wm1-f65.google.com with SMTP id a3so17309256wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 05:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=iaau9hhA1KFwy2KDmDsX/sn+tVvl77lzzmCiDGToHck=;
 b=BgBnJ8EK3bza/181q05p8iQXYs1RFznPl/Ry+CtkBEqrhmo0cDH+CdGkp84Kl7VtoZ
 0MXDjoCuJ9ewJWRWvmxbHgQGAzkgtkHlr0ywKiw8rXqDO0ze1p7PzKWkFWH79bhxAqUI
 6jIltWFyRts2sRBAUNyMtgisXoiwq3Nx0b7Lw2MIuZ2EflVqv6tUs2im41Nm2pDDGSjA
 Fa+wRpnl6JOqv2tiJ1BvZ3rfyLWW9eUD9WZ5Wyj/7MzePo1L4f3PEMUWioqIy/BYO5Nd
 5RqoRi/8HhqjyyjHjaUmEyFGBFS2N9lGzNc7Zf9YgR/Viuf5HTyCR9maRGJ/6GB2ZKIh
 Jygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=iaau9hhA1KFwy2KDmDsX/sn+tVvl77lzzmCiDGToHck=;
 b=uDUW/9DWRe1JqBlcImy0vLIZwei2Y1owdQ9OboKUhK+Ypkxw8pO43+2/rcx2TwSewT
 hPHh/06sHPkk8Y6FVgrxyWa9jvTdLuZQfPM/zhNCTvB8MCgaqM8uAyM7Wx3MA6PSnOKe
 F7CN0OlRqby0am/rrl6cf6iIY45L+WaTBJV4rX8SRcSBcq+/a+GEtulROigd/AqkXKSV
 ZwNK2yF1UwRXC3xpbeeZf6dDmwWpl6XayZeamkqioTjEU3Luy3VioU9Y8g+03gbYJMee
 Z6LAtDmDVEWg+36VAtv8UlSKOOZL8zwSESwAyyX5BBPeoQbervyLUV8pZCUOxUyC2tKv
 PiKA==
X-Gm-Message-State: AOAM530W1V9oDcdsubgzJtZOlMm9KBcA6eBRw97o3IpnCJeGo7V3+/eD
 FGnCLnmDF8FqxuR2zxLpdaGKrw==
X-Google-Smtp-Source: ABdhPJw2S0g7xc5LX0mjnROVXQEjQ1dcwMwqbjEh95H+sw1EIksGKfdkdpqjbz7CHSJ0dqI/brkrGw==
X-Received: by 2002:a7b:c0cc:: with SMTP id s12mr23506422wmh.41.1606139515051; 
 Mon, 23 Nov 2020 05:51:55 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id j71sm17278653wmj.10.2020.11.23.05.51.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 05:51:54 -0800 (PST)
Date: Mon, 23 Nov 2020 13:51:51 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH 13/27] KVM: arm64: Enable access to sanitized CPU
 features at EL2
Message-ID: <20201123135151.GA490744@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-14-qperret@google.com>
 <CA+EHjTwebfoJLpure-mHNzCnmLwnNEi6yh66OLFGrhH_+ysExA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTwebfoJLpure-mHNzCnmLwnNEi6yh66OLFGrhH_+ysExA@mail.gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, Android KVM <android-kvm@google.com>,
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

On Monday 23 Nov 2020 at 10:55:20 (+0000), Fuad Tabba wrote:
> > diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
> > new file mode 100644
> > index 000000000000..d34f85cba358
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_cpufeature.h
> > @@ -0,0 +1,17 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright (C) 2020 - Google LLC
> > + * Author: Quentin Perret <qperret@google.com>
> > + */
> 
> Missing include guard.

Right, but on purpose :)

See how arm.c includes this header twice with different definitions of
KVM_HYP_CPU_FTR_REG for instance.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
