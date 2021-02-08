Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79126C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 17:31:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC8A464DB2
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 17:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC8A464DB2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BF914B665;
	Mon,  8 Feb 2021 12:31:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rozqd5OiOdny; Mon,  8 Feb 2021 12:31:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3B134B6B2;
	Mon,  8 Feb 2021 12:31:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9314A4B665
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 12:31:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7cs+56mHqCTU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 12:31:51 -0500 (EST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
 [209.85.208.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 874144B599
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 12:31:51 -0500 (EST)
Received: by mail-ed1-f50.google.com with SMTP id z22so19337451edb.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Feb 2021 09:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=150RTcQf9BfKKICDDXV9LKFJabVH26+mj9gc5y6fe7Y=;
 b=hyAFs0fKGKFRmcciR03ZZ+YgXacp92jIDmnU50sMK4A9BRuJZf1z7VY29bDmosfHTb
 1WxxFJmX4Gx2fA5LbII7eG20wFGqZn2bS948AI6OJ6Alo0QsDcr/UWtsoB9PEoSSrQs6
 Sgp9ku+9stH6xnurZ6pYqxXLqFor2p8XQ8xdOHBcBbW6DZ9qjJXHVcwNrJ9g2FJfHgrr
 nJ7wG+20YbrL/0Rdm7sCRiO2XEvUYsLQR+ZhObZcRDg0iMfiwvTqtzC1QFMWLyLnPeZW
 eyTK7lotvYRoGNA1ptcR3iRB9VOCPrva6py9K0rLj2MnNZz0HANq9733DQWdvkSShO8W
 u1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=150RTcQf9BfKKICDDXV9LKFJabVH26+mj9gc5y6fe7Y=;
 b=khYEcPEYIJZK71L2ZO4KD7B7iha+12mu6Z80WyWXPoiPWLQbiB2SEggo0bH3khQ076
 w3eVBzgP0DoYpuQkmwpvVT7aF0f7+1IEekufANno0iIs2qhk2HMnle1Gv1G78p3qZOUJ
 CM8Bmsc0jX6GeEZr1iABtMbsJ2A4DAKk5mcEFg6vprLDpBdHYwjoAvKWwVhQhs8zaX7a
 KFm1CJpMdeJ3h2xskCLLEvGD9wEMDDY7KYp4iQISIdcxqdnOpkYd8rwc7jFHF29Vqb8g
 FGkw85evplHHB79KLNdu7N7VreJ2q9FKNIYzWFYpIuhx5fm1wF1KcmaAcEad3SvV9NU8
 l8/g==
X-Gm-Message-State: AOAM530Gpd0qibqemrcN9jbiLvHRTMVk6X9agfHOhkpxEMZiGE4/zRqc
 y6PIibX3gLB8iJ5A6BK9yEqe1xHzPIf40t3RR8+arQ==
X-Google-Smtp-Source: ABdhPJyfU7DR5l4b18tnpHL187lOP8zLT1R2zc8ro9MwTmAB+zuO7xlpf0gqcrlNJL178r53Bg3pYOpuitw0w/ezOBI=
X-Received: by 2002:a50:e80d:: with SMTP id e13mr17842705edn.251.1612805510357; 
 Mon, 08 Feb 2021 09:31:50 -0800 (PST)
MIME-Version: 1.0
References: <20210205135803.48321-1-steven.price@arm.com>
 <20210205135803.48321-6-steven.price@arm.com>
In-Reply-To: <20210205135803.48321-6-steven.price@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 8 Feb 2021 17:31:39 +0000
Message-ID: <CAFEAcA99kV_d6ev9wC4ySiyoD7Cp=HCD0v2bBhGSOU-KrzkqaQ@mail.gmail.com>
Subject: Re: [RFC PATCH v8 5/5] KVM: arm64: ioctl to fetch/store tags in a
 guest
To: Steven Price <steven.price@arm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Fri, 5 Feb 2021 at 13:58, Steven Price <steven.price@arm.com> wrote:
>
> The VMM may not wish to have it's own mapping of guest memory mapped
> with PROT_MTE because this causes problems if the VMM has tag checking
> enabled (the guest controls the tags in physical RAM and it's unlikely
> the tags are correct for the VMM).
>
> Instead add a new ioctl which allows the VMM to easily read/write the
> tags from guest memory, allowing the VMM's mapping to be non-PROT_MTE
> while the VMM can still read/write the tags for the purpose of
> migration.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h | 13 +++++++
>  arch/arm64/kvm/arm.c              | 57 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  1 +
>  3 files changed, 71 insertions(+)

Missing the update to the docs in Documentation/virtual/kvm/api.txt :-)

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
