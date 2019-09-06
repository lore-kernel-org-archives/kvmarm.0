Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06977C00307
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:50:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA92E21907
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QJLxdzCm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA92E21907
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A614A536;
	Fri,  6 Sep 2019 09:50:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ITkXnFQGM8qq; Fri,  6 Sep 2019 09:50:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33D3A4A53F;
	Fri,  6 Sep 2019 09:50:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AD5A4A535
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:50:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wv2UOj6kcBFz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 09:50:46 -0400 (EDT)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2825D4A4F4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:50:46 -0400 (EDT)
Received: by mail-oi1-f196.google.com with SMTP id 7so4981614oip.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Sep 2019 06:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=M3zKBTNhIg8D+FIn0RZewf6I27LDWwbXRyiB+RiFIt4=;
 b=QJLxdzCmNOBoOEJcJvHLBetbvlrq02aheoBREc7Fpa35nydqJO0APfx6nad3lCVm28
 lJ1ZUe0/fJeQUUFgiMPPj6/fbcM9e7OjKrEc1QrYxG5ClkOdWLBjZFFcMIApdjWbuChA
 GwWqFB90O/OmPDWZFtpAJd0+ch2CJJJrMPGfYnCy8OENP1wN2b8V+IZ2aaVx5mHzHYo+
 C0QkvjyNgA22hfWbRziRRoMC+Uw8bf7qwZa9iRMstY4NRjAsqoN/eAs29FaHED5FZO7H
 9y7wj4KZNLMXXLh1zyjnoa+6KX/HQ1RXmCmVcjWUoO1zek/YPUj/3Er41Lu+SUg8DZJ2
 YJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=M3zKBTNhIg8D+FIn0RZewf6I27LDWwbXRyiB+RiFIt4=;
 b=ax5Hiw5j1u1SfaV/zV1GgjPNoKohcyfadmlPf8jlnsjBTmD5OsUeg4evfclZh1YVBL
 sCWu2Z0ighBDq/a58hHPTaOKYFXAB5bD9YIQu8dr0Y2MMOjyN6tkhN8vntsIh1FOQOMG
 mBWvG4s5eYnEZ43xCF4n82cBk4Fu6mCKN9dQ47/4dKgPOHYdaGrmx3vxtZ1UjiZ6qajM
 lVV2Zf0pjOvHx4FsmyN2QFYbPWW7HmVlPmJIHtLjuf1sMw4VW3nq3EndaM+jqQgYzldY
 xhQ0oSkRZg/iJrKXG/pH6+Ke16AcjXKFhQGM4gWgA0vHiXhVciHueG0n9QwdgzuHMkvy
 RqaQ==
X-Gm-Message-State: APjAAAUqjy+AmE1lq9q8XCbI4UCtnJcBsfwMQTGuz7zVD53i7jwqMo/i
 Cc5bJ8YMPR7t45Iy2eC3TVtgqMUovDu4P2BkiB6sNg==
X-Google-Smtp-Source: APXvYqxmXHWpUWZdq9c0hrTTVJDwQytlmXVaK7yqoJ7V8pIYxhd7z8W2/IAM32BufSMj7tAhgV/7VotgrBEcuRvwPrQ=
X-Received: by 2002:aca:50d8:: with SMTP id e207mr6690938oib.48.1567777845580; 
 Fri, 06 Sep 2019 06:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
 <86mufjrup7.wl-maz@kernel.org>
 <CAFEAcA9qkqkOTqSVrhTpt-NkZSNXomSBNiWo_D6Kr=QKYRRf=w@mail.gmail.com>
 <20190905092223.GC4320@e113682-lin.lund.arm.com>
 <4b6662bd-56e4-3c10-3b65-7c90828a22f9@kernel.org>
 <20190906080033.GF4320@e113682-lin.lund.arm.com>
 <a58c5f76-641a-8381-2cf3-e52d139c4236@amazon.com>
 <20190906131252.GG4320@e113682-lin.lund.arm.com>
 <CAFEAcA9vwyhAN8uO8=PpaBkBXb0Of4G0jEij7nMrYcnJjSRVjg@mail.gmail.com>
 <28c5c021-7cb0-616b-4215-dd75242c16e6@amazon.com>
In-Reply-To: <28c5c021-7cb0-616b-4215-dd75242c16e6@amazon.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 6 Sep 2019 14:50:34 +0100
Message-ID: <CAFEAcA8HH-JeMLZ29h6GidDcLpb_oUHqoyEMJ0buo3hyTBj5jA@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
To: Alexander Graf <graf@amazon.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Fri, 6 Sep 2019 at 14:41, Alexander Graf <graf@amazon.com> wrote:
> On 06.09.19 15:31, Peter Maydell wrote:
> > (b) we try to reuse the code we already have that does TCG exception
> > injection, which might or might not be a design mistake, and
>
> That's probably a design mistake, correct :)

Well, conceptually it's not necessarily a bad idea, because
in both cases what we're doing is "change the system register
state (PC, ESR_EL1, ELR_EL1 etc) so that the CPU looks like
it's just taken an exception"; but some of what the
TCG code needs to do isn't necessary for KVM and all of it
was not written with the idea of KVM in mind at all...

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
