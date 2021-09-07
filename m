Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4413BC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 19:05:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BA03F6112F
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 19:05:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BA03F6112F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 497424B099;
	Tue,  7 Sep 2021 15:05:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8euX+vuPXGdH; Tue,  7 Sep 2021 15:05:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55ECF4B093;
	Tue,  7 Sep 2021 15:05:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D8574B093
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 15:05:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jtDAQ35ZL8im for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 15:05:26 -0400 (EDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
 [209.85.208.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5AEE4B092
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 15:05:25 -0400 (EDT)
Received: by mail-lj1-f172.google.com with SMTP id h1so180965ljl.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 12:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sBt2QcT+qejgfLCsR6+AgaDfNkL4tTkfr0k4a7ndIe0=;
 b=pvtitd0K3fv5rwIpgkNW0Ifn/b1Tb8c/Rk+jSr83PySBqWDbSk1YxerhqAO2s1Ii1i
 p6wDa7rk8+6wEWQiP8rFp1bAY/4yVy4CxYsnmh+HmbFN03vtcz8wwB6bfXxe2upsr3Ib
 o0GDhypkB6k54A9jrThT1BhXVAwUkGCTxL+wSU71aKdAKdxwAroMuxTp1JTyfBSoamm3
 7h4zdUhypvFkcIaYtLV8q6b1VcAcLXd5sAN1TRF+pF6DD2uuUIOK9XT9yd3S6shEK/u3
 vEo1puywFmjduBLq9zAbP0mAI7/cgCvUAasLLT7zkWrN9valKtlSvHyec8g6bzzDvEmt
 OjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sBt2QcT+qejgfLCsR6+AgaDfNkL4tTkfr0k4a7ndIe0=;
 b=GII05prnkLnifXNQQCn3Onh+Z2rCb4Md5euHPDYbXm9i7GlD1r+EBdIXC3oFkhgTBH
 ocVXpoTCG/zzyT/V0t6JFtUxrkfc2sOaMNlL2yECXAnZVAp/dTVNf6q1ookBmaMz5X95
 r8QkIpVyzuZDt8qvpOHbBtrQxG/ABJnC/mVpYYLEiHdfWx1XH5/+CIaqHFeRe0KXqvRv
 ygZnPnYVhIJm/UnOzBwMTDRCF8RfuEgED2OHjOZS/ecR9olt+PuP2iFXQodql1jt3MCW
 B7/Xz3UTeER5hFF4G78FJ4FEvmBXUQu0Jx97hxfo6HMP2sBmhp0SGY+9ikkCM+wKuWcn
 Rheg==
X-Gm-Message-State: AOAM53198vawAXBiPDhOPupRtPuG2PlOUEUQXDE+MW8mFy61SpiJ18Mc
 DXkwdu4k9PlWmrkEeHGj8I9MJznwh9hepkAR5FbzcA==
X-Google-Smtp-Source: ABdhPJw0lcNxyeV+WtmpbYLM6yuzl0K5oPwjGar/B0vlVqgp759KpQqNFxSh4fZpMp20d0uB/pwWLXRAV/ASUAQqois=
X-Received: by 2002:a2e:a40c:: with SMTP id p12mr16620609ljn.479.1631041524250; 
 Tue, 07 Sep 2021 12:05:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907180957.609966-3-ricarkol@google.com>
In-Reply-To: <20210907180957.609966-3-ricarkol@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 7 Sep 2021 14:05:13 -0500
Message-ID: <CAOQ_QsgYm9GX=7k0kg8w_4SSP2ioovrJ_BG8jg9y3jjj8TC2vQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: build the memslot tests for arm64
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, maciej.szmigiero@oracle.com,
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

On Tue, Sep 7, 2021 at 1:10 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add memslot_perf_test and memslot_modification_stress_test to the list
> of aarch64 selftests.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
