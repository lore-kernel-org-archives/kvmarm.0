Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AC3C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 07:08:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D50B54BD77;
	Fri, 15 Jul 2022 03:08:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UE7fbJmq2Ybg; Fri, 15 Jul 2022 03:08:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C72E4BD81;
	Fri, 15 Jul 2022 03:08:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DDC64BD78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 03:08:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3KkFMNLbwhjC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 03:08:21 -0400 (EDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com
 [209.85.217.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BC704BD77
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 03:08:21 -0400 (EDT)
Received: by mail-vs1-f54.google.com with SMTP id 125so3511470vsx.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 00:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=SKk4fe199tCOLmeDZfxcQNbddbUVsyVisM9qRwohock=;
 b=r0pw304zOECYCgUHXTN6ao3Z1B6PkME/SytPQMFVHrlaV0z+/BfsnZHYXcJQi0Bj/G
 N4HfVKbuXpxgPPtABJBrrqdooOu6fvBwtgd2oinBP7NJPSpWxYuWsobTWRYGJXMdpMiE
 8dNAtOii6zmmC93BWSONKym+icl6pMBvCh6XxyErAUnOtVhRG6dPEfGXnZII7r3//yox
 dGB4EjXOykrabNDbI6JJNUmdSNboTiWss+1w9Ilj231RuRGvyIuYPSVrm5rTAT8ZdoJA
 sjQxaSF8qKnqDJQihhR++EMaCXWJfSHXVpaBXa25toQ+QTLzA8TR8ZorE0yS1r2lcum5
 zSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=SKk4fe199tCOLmeDZfxcQNbddbUVsyVisM9qRwohock=;
 b=xMlAeq1+4A89eaM9P5xvdztgUPX8n9tQYk6Kn0nvAyHj7bU8drBfaNd5sYzUy/UWxB
 9TstNFl2RrSShUFtprFusUf+Ji3bviie/zo7ZEk6asX5tx93GoL3UtUZdN1gWk66wXIE
 U2Xb7gcbqBYDHcRKX7VZVlifgi2W1JsFa0U01Ac6Luh76CPRuzOWMnhwlWisTZR/wssd
 MwlCwZyN1rYcHNdw9sY5p8kd/bgj7uOO8YggxTov0ipSwmDZld2NkOKK/HD7RXhJB1I7
 we2tGui4LBhKK8+kRk2LJxSeHlFBYF97dxi+g2SU9eihdje7PeT5WSWH1jsVsRCaw8aW
 YYaQ==
X-Gm-Message-State: AJIora8MVQnGoPrcBVRaQocpIc0RZvIpcs8jtWBkWyPfX/Rjudhkdy5f
 MSp0Pw8iC/X5EFusLV7u/lfrcm5cuU2HO98dxgpXsQ==
X-Google-Smtp-Source: AGRyM1v0EdTtR37dp0R9PYh4/X5Sg5iaWnvVnHvmKNDDpJsX9lLRQ3N0otxNm8E4tbZlaACWVfJeWABJ4mCl5j6GmqU=
X-Received: by 2002:a67:b24c:0:b0:356:c997:1cf0 with SMTP id
 s12-20020a67b24c000000b00356c9971cf0mr4858211vsh.9.1657868900660; Fri, 15 Jul
 2022 00:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220714152024.1673368-1-maz@kernel.org>
 <20220714152024.1673368-9-maz@kernel.org>
In-Reply-To: <20220714152024.1673368-9-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 15 Jul 2022 00:08:04 -0700
Message-ID: <CAAeT=FyENQ2GqoFi9e80nWQrPpcoBfN_9x0ZMhf6uH8b0NYXZw@mail.gmail.com>
Subject: Re: [PATCH v2 08/20] KVM: arm64: vgic-v3: Push user access into
 vgic_v3_cpu_sysregs_uaccess()
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Jul 14, 2022 at 8:20 AM Marc Zyngier <maz@kernel.org> wrote:
>
> In order to start making the vgic sysreg access from userspace
> similar to all the other sysregs, push the userspace memory
> access one level down into vgic_v3_cpu_sysregs_uaccess().
>
> The next step will be to rely on the sysreg infrastructure
> to perform this task.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you for addressing the comments!
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
