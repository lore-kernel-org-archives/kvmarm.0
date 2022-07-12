Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF966C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 05:23:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4150E4BDAF;
	Tue, 12 Jul 2022 01:23:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LeRvByNzFGZm; Tue, 12 Jul 2022 01:23:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FFC14BD36;
	Tue, 12 Jul 2022 01:23:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3D474BD36
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 01:23:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u9lriPdsQ6wL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 01:23:08 -0400 (EDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com
 [209.85.217.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07D4A4BD33
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 01:23:07 -0400 (EDT)
Received: by mail-vs1-f46.google.com with SMTP id a184so6839718vsa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 22:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/VRajJxNUiS0mp6F6S2buQXRTsevV7rowOUF5aBZsQI=;
 b=OiSBox2sJ0e0F+m7zahTrJvpzUBmI5f3RMcKq0nC8srWH3BPfHFA5bvqMMIihpfXxR
 aK7vrYOk6hDw41MycU0xQYZtUSzKVo69UYBJvJ/H091shMkEcLzTCRroVEf7VLNN02I6
 /WT+nthsAqircmH+X5S9FLhM3WmMGDKhyC0nTSNHHTHEQP+0AbUMFIqdCampj+p5WvMo
 /KnLTr7K3MeSfdrj0b25WqEGJ1Pl6t0M8TqzCK3UpZltOGY6N1R85kcuZMkZVe4KaShd
 tPvoWhQc12doCLTJmUQRbTbB/LMLUUuCNpC8ZPe/BG3b0QppKBz43qT4AUA3fSFd32uZ
 ly2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/VRajJxNUiS0mp6F6S2buQXRTsevV7rowOUF5aBZsQI=;
 b=U/BDICwsT53B0GRcrIeUvuCEPCv3d8CnmMCBv8KMjDjevlonAEItz4FHU5eAehqo+0
 3+0dE+3puUB5vCTeUjSLzGKIYsyHvQcX9ivG8UpJNjk5J+H2d6KfHWUmk+x/O2IJItoY
 /JYbXHzLUWdx/r0IyLp2ent5y3ju85Feb5Kkgg2jV8/GtjB+5juNaIm0cniVw4b/Ys8e
 bAu9lPN8tFVdQ79QrI5nazoK3TTs0OftupzWugSr6AqQBYNvHwEKhNlF6/W8Zh75F2Yv
 FCYsBXmV/6YnPH4zjplaSQ+3hlNECb4mKotHrNmYvEC23FKW7gEi4qrPHEm1qBqWtmvh
 25rw==
X-Gm-Message-State: AJIora+Ov3dXi9Z1kCgAxG5MLM1hqW2mR6LSaWWR4n77/jwC5/hnBYsO
 SwYVmsQdTdzFrfV+TtOWUV/p4ahuj8ZQF9y7VFTNWA==
X-Google-Smtp-Source: AGRyM1taYhdOJ76KHhu1hfwHJcpNMUoDVUHGja8vLOMJi5jaaNCuKYH76aur5PS3Rq4Q6Zx/eQJbN10MhL0nB2tD6bo=
X-Received: by 2002:a05:6102:2126:b0:357:6663:a469 with SMTP id
 f6-20020a056102212600b003576663a469mr2600597vsg.58.1657603387497; Mon, 11 Jul
 2022 22:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-8-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-8-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 11 Jul 2022 22:22:51 -0700
Message-ID: <CAAeT=FwKmNfGZM7U1MHUsOcEBR2x6f3DgmpCyLW3wPydvswVEg@mail.gmail.com>
Subject: Re: [PATCH 07/19] KVM: arm64: vgic-v3: Simplify
 vgic_v3_has_cpu_sysregs_attr()
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Finding out whether a sysreg exists has little to do with that
> register being accessed, so drop the is_write parameter.
>
> Also, the reg pointer is completely unused, and we're better off
> just passing the attr pointer to the function.
>
> This result in a small cleanup of the calling site, with a new
> helper converting the vGIC view of a sysreg into the canonical
> one (this is purely cosmetic, as the encoding is the same).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
