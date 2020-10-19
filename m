Return-Path: <SRS0=pEf/=D2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1A5C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 11:43:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF75522276
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 11:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R55ieoV4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF75522276
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BCF64B632;
	Mon, 19 Oct 2020 07:43:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7qopAvsY493M; Mon, 19 Oct 2020 07:43:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ACF24B536;
	Mon, 19 Oct 2020 07:43:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2AC94B51D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 07:43:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id khPUGTWrqx+Y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2020 07:43:45 -0400 (EDT)
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com
 [209.85.208.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8DBB4B393
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 07:43:45 -0400 (EDT)
Received: by mail-ed1-f68.google.com with SMTP id o18so9893153edq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 04:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=lhRyiaF4Mj4SAFapWDuVKTR91M4N1ZAMCfQG7PSQtZE=;
 b=R55ieoV4chafnTnejfeCIzez71tOjmqPt6Eaa9gpHowReSiqasMTu6h/2iyTbC51Sd
 6qF4op744gdzUEn6hhBRNK860EHqYz2fvdMvGVIWexAZ3R34PR9aDJcgponBXclqPfsY
 Y8wiWlbdaLzy12g+MuBTSN6Gsu1D2DW19vIyb48KXeoB2Q030VvzalZMPdzV9vFYbFIb
 NBm0lKET3zw78IUd4Dsw/mnl1zb7Tv/IZo3rID/MPO2tujGJyLnblNuzy2P+B1WzAsEn
 X1LG7G6PAzvWUbXPogSiaxbOpPedR+fzm+7USziBdsrLxyiUmb7bFpmyIxqKvKHlSkTK
 3QHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=lhRyiaF4Mj4SAFapWDuVKTR91M4N1ZAMCfQG7PSQtZE=;
 b=iif8Xuj95fnUA0DhF5cnU+WZfkD16VEm6VrXxRpBdaXQB6nGRMQmYPAyrQdiyFH77z
 Mnmq9Q43DfhqRv9SkshRKxu++c57mBvMiMuNE95XwzVxDK7Tqfdr8d/5LLr1h8gGKa+N
 SOV66HnZiFOOHQl8osZIs7YgFT0GaiMCCUXkAd2BKSRU+TjRO876q29Y5x5IZWKwWo6a
 GMb6Ke55j0wjh1BZM/SLb/jNhIN3/B5BDcTIw8ugBgMywB3MLttILLc0qFDhIJbSXHls
 I4GGQrIJDgjE4bV/RV9MERvcNQIRXuU2q4keXYTz2MKVm4IPK0kCHvHYsDLxjnV8C8ZB
 i6Bg==
X-Gm-Message-State: AOAM531uwcic3ed5m2TnDwBAy9CyrJCWv2kJyUtgsFri6fU/QoIObMnj
 y58skuifN2FyjqnUelm5AQV/Ys3jRjl7X4Ve9TkAxw==
X-Google-Smtp-Source: ABdhPJyWN6vu70FNoDT+mUde/Oxrsko4OlVYRLt7U8r4v0TFnpNAU3f+Bg5gCpqSY5aGvzYrrda8cyfIAg2ZyBrRK8Y=
X-Received: by 2002:aa7:c683:: with SMTP id n3mr17448774edq.146.1603107824651; 
 Mon, 19 Oct 2020 04:43:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
 <7fecfc67da4caab1d677a8b4cd5386b3@kernel.org>
 <20201015133505.ubxvbrt6xyvl4362@kamzik.brq.redhat.com>
 <16400df4bdf79b8b22e824eb1a20e2b4@kernel.org>
 <20201015144104.ytwzpxjlsgyun3ob@kamzik.brq.redhat.com>
 <CAFEAcA-LBmbjp-Teb35f=O-1QtMLd8bAuq5XaCz9URdQZ1jxow@mail.gmail.com>
 <20201019092525.ekvgbcwwtm63pueu@kamzik.brq.redhat.com>
 <20201019113157.GN32292@arm.com>
In-Reply-To: <20201019113157.GN32292@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 19 Oct 2020 12:43:33 +0100
Message-ID: <CAFEAcA8oncKmGxKGEZBg9Pnm4hjSO8u9KSv4YxFWxX0+LJ5E2g@mail.gmail.com>
Subject: Re: Kernel patch cases qemu live migration failed.
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, xu910121@sina.com,
 qemu-devel <qemu-devel@nongnu.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Mon, 19 Oct 2020 at 12:32, Dave Martin <Dave.Martin@arm.com> wrote:
> I'm not quite sure about Peter's assessment here.
>
> I agree with the inconsistency identified here: we always enumerate all
> unallocated ID regs, but we enumerate ID_AA64ZFR0_EL1 conditionally.
> This doesn't feel right: on a non-SVE guest, ID_AA64ZFR0_EL1 should
> behave exactly as an unallocated ID register.
>
> I'm not sure about the proposed fix.
>
> For one thing, I'm not sure that old hosts will accept writing of 0 to
> arbitrary ID regs.  This may require some digging, but commit
> 93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features from guests")
> may be the place to start.

Well, ID regs are special in the architecture -- they always exist
and must RAZ/WI, even if they're not actually given any fields yet.
This is different from other "unused" parts of the system register
encoding space, which UNDEF.

Older hosts didn't permit writing 0 to all parts of the ID
register space (and didn't list all ID registers in the KVM_GET_REG_LIST
list), but that was a kernel bug which we've since fixed.
(QEMU has workaround code for pre-4.15 kernels for this.)
Across that older bugfix, migration works from an old kernel to
a newer one, but wouldn't have worked from a post-bugfix kernel
to a pre-4.15 one.

> My original idea was that at the source end we should be conservative:
> enumerate and dump the minimum set of registers relevant to the
> target -- for compatibility with old hosts that don't handle the
> unallocated ID regs at all.  At the destination end, modern hosts
> should be permissive, i.e., allow any ID reg to be set to 0, but don't
> require the setting of any reg that older source hosts might not send.

The problem is that you've actually removed registers from
the list that were previously in it (because pre-SVE
kernels put this ID register in the list as a RAZ/WI register,
and now it's not in the list if SVE isn't supported).

> So, I think that instead of changing the ID_AA64ZFR0_EL1 behaviour,
> parhaps we should move all ID_UNALLOCATED() regs (and possibly
> ID_HIDDEN(), not sure about that) to have REG_HIDDEN_USER visibility.

What does this do as far as the user-facing list-of-registers
is concerned? All these registers need to remain in the
KVM_GET_REG_LIST list, or you break migration from an old
kernel to a new one.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
