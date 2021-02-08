Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBA9C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 14:40:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A135F64E84
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 14:40:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A135F64E84
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D6094B597;
	Mon,  8 Feb 2021 09:40:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S+lP45qZLX1F; Mon,  8 Feb 2021 09:40:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9E64B67D;
	Mon,  8 Feb 2021 09:40:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4822E4B53B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 09:40:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hdgNZAe2N4dS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 09:40:47 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39EB44B19A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 09:40:47 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C4464E75
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612795246;
 bh=uzVP/yUTZ26j2flqJpYpKjVHor/lpsoGXsqXFjLI8Ac=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=qcMSda+hMlq6oiVFD7V7aK7jrnYayHkeWCwg6mSQSQC4KSe68pSYAhQ9MLQxRHhSp
 7cnuxD90DJ6ukwjMLeq16FJJ9bqf4suMkJipKYJo71DMqcRK1fX6o8PpiDIkgR4w8v
 hiZ68kFrY6oAMB/WH3Dk/mEfC4lsSrq5WjSZdmT6MKhhLzej/oHkShYc0zNah/IBmZ
 DtrS+HRpa2aPFbvOUepqfj/xU09Xz1zaO/u0jRTx99Swb5v87m8k3s2Pdlodof9dkV
 FWwwsyOr+bW0uxzNpongew++F50MbGErul6TGcEWMv3VRT/st9ZTAwG9GtnXD0WFin
 o6P/x1TELi3Wg==
Received: by mail-ot1-f54.google.com with SMTP id e5so7512967otb.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Feb 2021 06:40:45 -0800 (PST)
X-Gm-Message-State: AOAM530qQc+pHS8r06H2u5jaJFe63XzU4pbKUyvP1B23mEVVSNsTfAA8
 gRdSZvkZekwDmw6wNa8ZgDZNltoGwfAXsP7OJas=
X-Google-Smtp-Source: ABdhPJwfnlQb1L3cCjYD7p80QTVblCNgqmsUFh18POCp3XEUcxiYvTt3HkWHqjqqd4APNtXMrcvFuIgfQrKN7vEYCsA=
X-Received: by 2002:a05:6830:13ce:: with SMTP id
 e14mr1791419otq.108.1612795245250; 
 Mon, 08 Feb 2021 06:40:45 -0800 (PST)
MIME-Version: 1.0
References: <20210208095732.3267263-1-maz@kernel.org>
 <20210208143248.GA25934@willie-the-truck>
In-Reply-To: <20210208143248.GA25934@willie-the-truck>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 8 Feb 2021 15:40:33 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGu_CLPiJDSzTkvdVNiDcRpo4se_fR8zqVgxyfERtgoAw@mail.gmail.com>
Message-ID: <CAMj1kXGu_CLPiJDSzTkvdVNiDcRpo4se_fR8zqVgxyfERtgoAw@mail.gmail.com>
Subject: Re: [PATCH v7 00/23] arm64: Early CPU feature override, and
 applications to VHE, BTI and PAuth
To: Will Deacon <will@kernel.org>
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, Marc Zyngier <maz@kernel.org>,
 Hector Martin <marcan@marcan.st>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ajay Patil <pajay@qti.qualcomm.com>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
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

On Mon, 8 Feb 2021 at 15:32, Will Deacon <will@kernel.org> wrote:
>
> Hi Marc,
>
> On Mon, Feb 08, 2021 at 09:57:09AM +0000, Marc Zyngier wrote:
> > It recently came to light that there is a need to be able to override
> > some CPU features very early on, before the kernel is fully up and
> > running. The reasons for this range from specific feature support
> > (such as using Protected KVM on VHE HW, which is the main motivation
> > for this work) to errata workaround (a feature is broken on a CPU and
> > needs to be turned off, or rather not enabled).
> >
> > This series tries to offer a limited framework for this kind of
> > problems, by allowing a set of options to be passed on the
> > command-line and altering the feature set that the cpufeature
> > subsystem exposes to the rest of the kernel. Note that this doesn't
> > change anything for code that directly uses the CPU ID registers.
>
> I applied this locally, but I'm seeing consistent boot failure under QEMU when
> KASAN is enabled. I tried sprinkling some __no_sanitize_address annotations
> around (see below) but it didn't help. The culprit appears to be
> early_fdt_map(), but looking a bit more closely, I'm really nervous about the
> way we call into C functions from __primary_switched. Remember -- this code
> runs _twice_ when KASLR is active: before and after the randomization. This
> also means that any memory writes the first time around can be lost due to
> the D-cache invalidation when (re-)creating the kernel page-tables.
>

Not just cache invalidation - BSS gets wiped again as well.

-- 
Ard.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
