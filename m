Return-Path: <SRS0=1iKH=4I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1705C11D0C
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 17:35:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 487502071E
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 17:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yFT0Vn71"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 487502071E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B29034AF6B;
	Thu, 20 Feb 2020 12:35:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id evcyVSuTAUx8; Thu, 20 Feb 2020 12:35:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9D8B4AF76;
	Thu, 20 Feb 2020 12:35:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 666C54AC70
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 12:35:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yNFF9Wgb9MZv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Feb 2020 12:35:53 -0500 (EST)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E4224AF46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 12:35:53 -0500 (EST)
Received: by mail-wm1-f66.google.com with SMTP id c84so2971463wme.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 09:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=HkVLR2b73DAGD917AOuRE1lTBu4a8Rh3kqQkFLTI4rc=;
 b=yFT0Vn710DW0so3/boied4hPxoxXhsUqHPxoqWb8ruUCtG9a8uZrf50nHxtcsn8+WH
 AYAFTsGCwhfeFGOmw7YgjxkVZyDOxvefF8Hy2iGEhJzxnRuTLtQgadXLRJkvReQeJ0oP
 FkCydzbq4aw/lcWzsrEnTjI44SYQTsq1F4hhak/GGrO4o7cg0evOxCW5L5gK3DT8U6gw
 XbDTtS91UTJQbHxgmwEB4vkyKVH7UjANPo601Otd+5KpjqOyDzCAgod1jEXvnfJXNLBN
 vJyhRaWrLgAU60P50Dl8eHqPGWTiVQgDt2p0WzsmeDIvKnGD8uW91vSu3eFxYw+sa+Od
 cNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=HkVLR2b73DAGD917AOuRE1lTBu4a8Rh3kqQkFLTI4rc=;
 b=l3b2NeBelLkS7xy9PYsDKGLszsqPm+eIH4Q/nTw0OoOoRr0CaOHst7iowIWEhC/CcM
 sBY7rFD0cHhVkKjKyCyhuf6Z5fCpqUP8NH+pG2tcSmymprHNymAFdRfeSxVedpPsDes1
 wDNxTkYjFFINAb0DrCnRuczMtf00JiMITFCbeBc+gsjdg3rMQZGT9e2iEXxlZKWZp44a
 jl60dufKSvXDZTISaSTZucb7Qh8xLcvhwiPKzHg8nc/wlMIMXMgJR41mb7s94BbhDWcC
 2Az6eyMbdc4/lWBGDYwECHYoPnYB+jmmzPUI0v5iozMg1NTAFlE0rRgjzOhmqujtEKJ6
 MSpw==
X-Gm-Message-State: APjAAAUHIIuBB19Bsw49X6kqWtuHl+ntuLZr9Kwrj3FZRhrIvckj5dJ/
 ucTDAHwNpcDQZ/bNcDnULF3Mgw5vmSzqe5IYywCIHg==
X-Google-Smtp-Source: APXvYqz8RR9jQXx/vIJb8eAbOBHSHnLSW6n15dc9aL96rRs/LA9imwxF8w2omx0W/F5kPRZgi607H449WjEU68J/swY=
X-Received: by 2002:a1c:282:: with SMTP id 124mr5482340wmc.62.1582220152092;
 Thu, 20 Feb 2020 09:35:52 -0800 (PST)
MIME-Version: 1.0
References: <20200220165839.256881-1-james.morse@arm.com>
 <CAKv+Gu-tPOWyxjsKrL-auC=ZxeNJPgAPyQ2rBd9S8sgMbb=r_w@mail.gmail.com>
 <1ecedad2-1b3e-0d37-42e8-7022ac5a8370@arm.com>
In-Reply-To: <1ecedad2-1b3e-0d37-42e8-7022ac5a8370@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 20 Feb 2020 18:35:41 +0100
Message-ID: <CAKv+Gu-4wOvPppZDxd9TdoK5_+=JMJ-ado5C4VP3-khod70_bw@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Ask the compiler to __always_inline
 functions used by KVM at HYP
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, 20 Feb 2020 at 18:33, James Morse <james.morse@arm.com> wrote:
>
> Hi Ard,
>
> On 20/02/2020 17:04, Ard Biesheuvel wrote:
> > On Thu, 20 Feb 2020 at 17:58, James Morse <james.morse@arm.com> wrote:
> >> It turns out KVM relies on the inline hint being honoured by the compiler
> >> in quite a few more places than expected. Something about the Shadow Call
> >> Stack support[0] causes the compiler to avoid inline-ing and to place
> >> these functions outside the __hyp_text. This ruins KVM's day.
> >>
> >> Add the simon-says __always_inline annotation to all the static
> >> inlines that KVM calls from HYP code.
>
> > This isn't quite as yuck as I expected, fortunately, but it does beg
> > the question whether we shouldn't simply map the entire kernel at EL2
> > instead?
>
> If the kernel is big enough to need internal veneers (the 128M range?), these would
> certainly go horribly wrong because its running somewhere other than the relocation-time
> address. We would need a way of telling the linker to keep the bits of KVM close together...
>

Ah, of course, there is that as well ...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
