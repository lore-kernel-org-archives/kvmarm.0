Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC56DC43334
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 04:12:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04A1B4C4FC;
	Thu, 14 Jul 2022 00:12:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NRqBPtKnjALc; Thu, 14 Jul 2022 00:12:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8C9D4C501;
	Thu, 14 Jul 2022 00:12:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1B464C4FB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 00:12:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8jLyeZDL2rGg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 00:12:13 -0400 (EDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com
 [209.85.217.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9BEA4C4FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 00:12:13 -0400 (EDT)
Received: by mail-vs1-f49.google.com with SMTP id k2so435747vsc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2022 21:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zEaLJX6S+5YvYcIkKQJtiP2svusPKIStGeqUFKW6f3U=;
 b=ZTbfM9Y+dMFvfF13OC4AR5kTUKBIDrUa+Le7sBHkaJuHsS+ZSMLef0DSuivVx1r/O7
 /AlaHQYPpIaVLLtVVUP41rSeb8jrDT6X0dFep8FB85XRucQPnd/uFMgqKmt5zPtCkrMg
 WTQkAsU4S1d3f5BK63arXG8fCFE0KEmW2tSc/TvZ+vezkDz8gfeay9Rur1aIMkWhbhx7
 d5936R86uO6gLko5s0VnXwBu1v3tr2GC4q8xMzpw+pv+8vxNIXAFTxHFTQLfpUW8Yl0r
 PNq3IzGt72jJdTcA1hIzOX7vSbSqU96qNpRehKAyG7phT7bN83XwbNLaJdPCzm0azUCb
 RreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zEaLJX6S+5YvYcIkKQJtiP2svusPKIStGeqUFKW6f3U=;
 b=I9WlCQx+gi/UMDBomeW1Vem+3d1+pgQL+6lyohyhGLeeZSpstUac4Ii9TOa5SoKVGi
 1bk3UA0bTC/WuLbgnVbYbS2KZ9t3OzpRRpl1E26tWur6j2GbPRbhkwm9Fv1QJ5ledYZV
 B+JAiwI6nfSXTKztM8H7QCzQ+wettODhITBDayhE/Qm8D/F6lwFF0i+ZpgkROhACRWRx
 ow/sP+6ypy67HpIkfwwTHtJfPwfz7Zev1iSNG30LlRwd4rKeCgstXQMjKDjly52GkSWH
 jN2asqkcOZkIikXpHPLQ5QYkJCxZpLSECgBWT1cQDuJi7rado/pEe0o5eOLW5F3cJh9H
 47ow==
X-Gm-Message-State: AJIora+v4RAExtU4WUk4dLzlV104BzSHnJzPw6uuJlSXtApmKbo6APQh
 QeyY0LuogMC4EL9TruTcmjpuOQmRDjGdtSow3IwEFw==
X-Google-Smtp-Source: AGRyM1to9RnV8FNlt2WrIvg6MUdYykCobiFcxVrnd4PiT6rzfBKrQcqwcReszcf2lgnCX97QNGeFleY5Sgb+zj53VI8=
X-Received: by 2002:a67:b24c:0:b0:356:c997:1cf0 with SMTP id
 s12-20020a67b24c000000b00356c9971cf0mr2640501vsh.9.1657771933106; Wed, 13 Jul
 2022 21:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-13-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-13-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 13 Jul 2022 21:11:57 -0700
Message-ID: <CAAeT=Fx61zZ7Z8Jbm5iAJf6V1GO2HihUZRnO3fGvT8c7spaDzQ@mail.gmail.com>
Subject: Re: [PATCH 12/19] KVM: arm64: vgic-v3: Consolidate userspace access
 for MMIO registers
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

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> For userspace accesses to GICv3 MMIO registers (and related data),
> vgic_v3_{get,set}_attr are littered with {get,put}_user() calls,
> making it hard to audit and reason about.
>
> Consolidate all userspace accesses in vgic_v3_attr_regs_access(),
> makeing the code far simpler to audit.

Nit: s/makeing/making/

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
