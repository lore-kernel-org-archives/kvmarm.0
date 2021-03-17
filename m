Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE22C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:47:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48FD164F50
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:47:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48FD164F50
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E1914B65B;
	Wed, 17 Mar 2021 10:47:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YWU3w+QZ+C4h; Wed, 17 Mar 2021 10:47:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7914B65D;
	Wed, 17 Mar 2021 10:47:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A3F54B654
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:47:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C2Vc8q06kaSQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 10:47:29 -0400 (EDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 650D44B649
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:47:29 -0400 (EDT)
Received: by mail-wm1-f45.google.com with SMTP id
 y124-20020a1c32820000b029010c93864955so3527233wmy.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+NAwyApKGr9OeZM13UJcb083CY8RcBRmmL5kmNSORk4=;
 b=nxH0ZK/Z7SqIpebv2BlNzbvBvCRL5tEEruzMTQdpRepI5rsoy3EZLK4EEJC1LcX9fX
 sZHM/Q8lK2uJl//w+rXeQthlNb61MBnMXN+zTp3nVHigR4jyXmNOpaYn1UZU/71AiA3r
 v9ekQg3b1cv3QMlWeD+X3BlwdAHitT4uZAQtmtPYGdS9FEWzy9arlQ4fD01OFvaj/LXh
 spWFU8d78nqCj04AcACb3fE1uwwa0MLw3TYG8DZpJtf5IZkwn9yxoH/faccSN+wTUWf4
 2RDQfbmbFAKdXhc/jkyDlWHxa02Mv3hAk5WA1xczlUSB/2fqQrovbN795fJIbS1Y3Pjv
 wZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+NAwyApKGr9OeZM13UJcb083CY8RcBRmmL5kmNSORk4=;
 b=BmjfJRhTiqur2fGt4xDEXnt7/w8psuVe2cXwxxSZRwPOoH8ESqAVbNYxY1lte++PJ1
 e/2ANjGuSmyTZswjYyJuVjNWM9j01ygcwtOgLFql1RcP9x2ry0aht5tbK5VNHC2pmlcH
 Tt1PoMqMMJTFC4vSjJ0RkRlpIrro0HBifO/8YlR2n6SeKat8XgNYFuCiPIWaok4UhUfv
 vyQhsjXg3Xs0bXnJjriHYAjRpL8yMwkmz1Rq4d/k4XMd0IOdL5FXaBd0r8uVDwIQYw38
 6UOz2KPUrUAght1h50gt6TF+0hydRHOfgcZdA3h8/Vw/S5z1OCkfOqTkhMPk3hTFRrPa
 5fhQ==
X-Gm-Message-State: AOAM531srLKFtbs9GgEv8qQAF85SoTehuqFP7Ojm5eaX6Kz3n2RIOjQU
 Je7q1yn8YYlhxCoQltRO9BIu4Q==
X-Google-Smtp-Source: ABdhPJx6AfATlLEiTNGqh1ucC7Hd3kT3uV12yFJvjNGYlQxmEPb67BtfUEuJl/OZaTdbQtSNc86AuA==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr4102199wmk.30.1615992448272;
 Wed, 17 Mar 2021 07:47:28 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id j30sm28608530wrj.62.2021.03.17.07.47.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 17 Mar 2021 07:47:27 -0700 (PDT)
Date: Wed, 17 Mar 2021 14:47:25 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: Introduce KVM_PGTABLE_S2_NOFWB Stage-2
 flag
Message-ID: <YFIWff9f+fESjIM2@google.com>
References: <20210315143536.214621-34-qperret@google.com>
 <20210317141714.383046-1-qperret@google.com>
 <20210317141714.383046-2-qperret@google.com>
 <87a6r1j10k.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87a6r1j10k.wl-maz@kernel.org>
Cc: kernel-team@android.com, android-kvm@google.com, catalin.marinas@arm.com,
 mate.toth-pal@arm.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, seanjc@google.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wednesday 17 Mar 2021 at 14:41:31 (+0000), Marc Zyngier wrote:
> Hi Quentin,
> 
> On Wed, 17 Mar 2021 14:17:13 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > In order to further configure stage-2 page-tables, pass flags to the
> > init function using a new enum.
> > 
> > The first of these flags allows to disable FWB even if the hardware
> > supports it as we will need to do so for the host stage-2.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > 
> > ---
> > 
> > One question is, do we want to use stage2_has_fwb() everywhere, including
> > guest-specific paths (e.g. kvm_arch_prepare_memory_region(), ...) ?
> > 
> > That'd make this patch more intrusive, but would make the whole codebase
> > work with FWB enabled on a guest by guest basis. I don't see us use that
> > anytime soon (other than maybe debug of some sort?) but it'd be good to
> > have an agreement.
> 
> I'm not sure how useful that would be. We fought long and hard to get
> FWB, and I can't see a good reason to disable it for guests unless the
> HW was buggy (but in which case that'd be for everyone). I'd rather
> keep the changes small for now (this whole series is invasive
> enough!).

OK, that works for me.

> As for this patch, I only have a few cosmetic comments:

Happy with the suggestions, I'll fold that in v6.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
