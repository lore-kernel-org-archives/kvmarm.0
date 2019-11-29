Return-Path: <SRS0=MZYq=ZV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2771C432C0
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 09:51:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36DEB2176D
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 09:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l8j0zi42"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36DEB2176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A06664AEB8;
	Fri, 29 Nov 2019 04:51:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aEaO4rSJ9tZb; Fri, 29 Nov 2019 04:51:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 988EE4AEA0;
	Fri, 29 Nov 2019 04:51:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0237E4A959
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 04:51:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JecE5BqeAa2H for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Nov 2019 04:51:52 -0500 (EST)
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com
 [209.85.167.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 204944A7FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 04:51:52 -0500 (EST)
Received: by mail-oi1-f195.google.com with SMTP id c16so3436996oic.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Nov 2019 01:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=F573XsxzX5sf/nxyxfqM8N2v84gU2Xd4IPR9VlS2F48=;
 b=l8j0zi42iC+kaUMBQEKmsKX+XYLVXAmYdWnEzYB4l4dwVvffkTkV4S/5cew5jdbvWh
 HlokksfnDIgDi8lrnGAR6RqrAvT3MGK8jsc9/zwXdOtlLYAgWP4fW1cgM9ZYzqQQ/D8M
 lfGR7UsXEA8UeDlzvWO0J/g0mbbXpC7PbJ6p5BO89t7yHnjA8y1dgsGysBUuiGW4MXvt
 IEjx00VOZQrQZJtgGTsby4HpLZQkoVfxXPeSCwgHj4pzhhxgQf1fG0HRE2g542zyKAKd
 adzvWMjVSqxJucEFQBcmE9EmM04JpexeFW5b4Ow+5U0MOv/kVU/DnTiV5XryJ+CoQ6dv
 6t/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=F573XsxzX5sf/nxyxfqM8N2v84gU2Xd4IPR9VlS2F48=;
 b=MDOlpnghhyJbbThjzPyf5S/cstJii7FemGRU9drIH8N8b82+fG6cobQcEaN2DgOuPx
 tKtkQi2cloRuESbDdSUlZslR+LlSFY676bDz14KthOkkXztrr8LP89chpRSSIt/xhQX/
 4aJfIFYj0VS5PKgTEB2c/CvHo3zq7gp6UrMkSVGbvR/qxyluHCX9zEOigtz1NreEjiWa
 MOuDJM/QT2jqPcv8zKqKCfFE5V//OTZ7NA1T9d/9/fuZQXXNa/j2nQdztf9izprdRW/t
 spAzw8SpJ6BGP6r7PafvIbig8LufWqTcRnf55YoQYgJGcZlOHjvu5h/bxCjsSKehw2xB
 oIbg==
X-Gm-Message-State: APjAAAVrabG7q1A8n16WqeOjU/02W3fp2A3ng7TL/x5yGPgPeTwbwXtg
 0p5ARsxhrIDeImbJCYFsb68lkJO3F+UhEAD/Y6I63w==
X-Google-Smtp-Source: APXvYqwXBm+2V83stX0WqwadtUKNURHmmj6F1Djs+8HjBqNtwmHx2/fTKPXWzRLjT/kVekGe9wvhCH2MTvK3O6x+Ohg=
X-Received: by 2002:aca:3182:: with SMTP id x124mr1100650oix.170.1575021111512; 
 Fri, 29 Nov 2019 01:51:51 -0800 (PST)
MIME-Version: 1.0
References: <20191128161718.24361-1-maz@kernel.org>
 <20191128161718.24361-4-maz@kernel.org>
 <20191129082806.GF29312@toto> <3a53b096bd101f9627d4c61ecfd742de@www.loen.fr>
 <20191129094557.GB25295@toto>
In-Reply-To: <20191129094557.GB25295@toto>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 29 Nov 2019 09:51:40 +0000
Message-ID: <CAFEAcA_HM5hCpY=cC9KLy3sFDFydhLNCEmtOhBCr+aQkBKwXhw@mail.gmail.com>
Subject: Re: [PATCH 3/3] target/arm: Handle trapping to EL2 of AArch32 VMRS
 instructions
To: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

On Fri, 29 Nov 2019 at 09:45, Edgar E. Iglesias
<edgar.iglesias@gmail.com> wrote:
> IIRC, the current EL was always known at translation time but I've
> not been tracking recent changes.

Yes, it's known at translate time, in dc->current_el.
(The code is structured to make it difficult to accidentally
use info that's not known at translate-time: most translate.c
code only has access to the DisasContext struct, and that
struct only has info that is safe to use.)

We need to know the EL at translate time anyway because we
need to generate the right kind of guest load/store, where
the code generated is different for different ELs (they
get looked up in different TLBs because the access
permissions can differ).

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
