Return-Path: <SRS0=1iKH=4I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6DCC11D0C
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 17:04:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCA7820722
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 17:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XY/4gY+8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCA7820722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EADB4AF94;
	Thu, 20 Feb 2020 12:04:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id irFkWFDFIyc4; Thu, 20 Feb 2020 12:04:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2212E4AF7C;
	Thu, 20 Feb 2020 12:04:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024084AF46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 12:04:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SfsrYjquOMIF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Feb 2020 12:04:32 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E214D4AEED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 12:04:31 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id t3so5450338wru.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 09:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=i7eOTYTHh3oRYEr7KxlGSpxwpMXx1RwVuFN4gvySKeU=;
 b=XY/4gY+8JUa/7ITcrbRS5yhQeMDJLKgcmgfcnMQ0CWPvUZ8uTiNvdcd8X/Mh7Q3zSk
 vgV6JB+6viMvup6k2dB1LWHP/NYpk6et2TvOmMErlqaeVcIdQlko+BFoYy9dXrVg/39r
 IAtqc9rcmSyJKRroqRPM+w0WJlNFiuFiObCmAwJogm4cVZSpJon5xJD8l4vI1mBD2Pab
 gc7NU3rJgkQD2QW3w5q89j6cU4fi4HwM3Pk/exjiugnMf/Ie9pGu8ZsW1mLmzpKf9WDS
 YtF7tiU52j4GqtH1MSaZmWOhXknWGHiF2kgtPih1dzEhpJMNni5Tzy2OtuLrevEOWr99
 Jr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=i7eOTYTHh3oRYEr7KxlGSpxwpMXx1RwVuFN4gvySKeU=;
 b=peMx2CwUpR8HBCYxG1UvSQmLIuLC+22Q1Bpb3jo6pjx28ZNS9c/Z5Oh8B/W1gcQVT7
 Ixwd6iDqSiZJqbpv9HOlmpOWZU5gFzLjdytlygmBXDtemMQ/+JnvPG5LN0hAm+wvqWrK
 gyzDUYhstHdKu4iCyGx0ZhYVEF4v3TFG2684Cf+VUBzs8DLrm7/60v2+bBS1hC9b6sHa
 ocmLW8rvQtO+avFrWNXAiY/C+rnI/uB8kQ33pDUotsoGd09SbL94i/6k/JS7evm84dKn
 1YjR4YfDUBeOdUSVc04FTD3v6snahcqII7yhirjXWqEowJlflZDI84kN/VAY/lWLRfz8
 kl4A==
X-Gm-Message-State: APjAAAXrLm790T6Gf4XA/VXX6Hvtna86i+YZXtGqu4eVeEZ44PFwdKVW
 dICgPt1jpqgIO2kgzWGr5dBH4QcWzxo9NYFrsfa2ow==
X-Google-Smtp-Source: APXvYqw+zSSFiKJdFbGQsSu3dMAIiapGSlm59sUSzvk+xT5G+aVQ5ypW9IatO7p8HheiKTMU6790g3JAieCaf1qWtbc=
X-Received: by 2002:adf:fd8d:: with SMTP id d13mr43836092wrr.208.1582218270798; 
 Thu, 20 Feb 2020 09:04:30 -0800 (PST)
MIME-Version: 1.0
References: <20200220165839.256881-1-james.morse@arm.com>
In-Reply-To: <20200220165839.256881-1-james.morse@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 20 Feb 2020 18:04:19 +0100
Message-ID: <CAKv+Gu-tPOWyxjsKrL-auC=ZxeNJPgAPyQ2rBd9S8sgMbb=r_w@mail.gmail.com>
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

On Thu, 20 Feb 2020 at 17:58, James Morse <james.morse@arm.com> wrote:
>
> Hello!
>
> It turns out KVM relies on the inline hint being honoured by the compiler
> in quite a few more places than expected. Something about the Shadow Call
> Stack support[0] causes the compiler to avoid inline-ing and to place
> these functions outside the __hyp_text. This ruins KVM's day.
>
> Add the simon-says __always_inline annotation to all the static
> inlines that KVM calls from HYP code.
>
> This series based on v5.6-rc2.
>

This isn't quite as yuck as I expected, fortunately, but it does beg
the question whether we shouldn't simply map the entire kernel at EL2
instead?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
