Return-Path: <SRS0=Zv6D=ZG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB516C432C3
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 15:57:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 368E7206F0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 15:57:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wss5Uy39"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 368E7206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8B94AF6C;
	Thu, 14 Nov 2019 10:57:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pwlxZJFDEd6K; Thu, 14 Nov 2019 10:57:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 670304AEFB;
	Thu, 14 Nov 2019 10:57:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F4D14AEFB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 10:57:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N-3JkCKui0lC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Nov 2019 10:57:10 -0500 (EST)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49A684AEC4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 10:57:10 -0500 (EST)
Received: by mail-oi1-f193.google.com with SMTP id 14so5672273oir.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 07:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yjMXCbazTOSF5ZA1NpqAV9Px3HPrhaWxcfkJjI+LIPY=;
 b=wss5Uy39oJlSYHFFHHEOWzpAvbWEgcIP3BFM8PM3bJBmSYB5EXD9/2b6UZMZUiiJb9
 yLhZ2DyPKwFcRVAZkdxSjetdSPm0YuTCliwOyZKPAH6SNN2YXCW7A2CccOccn3vyw/wu
 icYtnF9cSXXIopsv8FpEvj3zWIClYBExFqIcLxdKVzmqfQKrVu/eMrO+/f4OtTUmtYma
 1kE6I14Mxtait7vHzk49xNI3TkVimWfzP3/dDbIrBP6XVVZ7NpZuZ0ujOaQuruHXfRc4
 dhy2SdCZklRn/3RI6JWPKBhtBtoWiXndUT/TCfVWXwvCmoFARhJrMmUcwdGcdOPCKGlb
 1F+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yjMXCbazTOSF5ZA1NpqAV9Px3HPrhaWxcfkJjI+LIPY=;
 b=F7+Rg88ZOZaPTRRKF+oVngsuPVCBtuAhtsw36LCwOEA8b1Tqr8LQDB++uyHwh/Sgoz
 ZcJ0MG4xxeeT2KPYdn0xnCDuVX1gaRNxcFKA6sZ31rxDhyXCaK0W0x81NY0oAc1AADxe
 EDaVJ8S7qSv/l/SYoSAqiJ6ZCQF5PMU+wIq8CkBytxRgpx6rVzfKNM6Hw8RIaBT0wNDM
 9kqUlCkXOgsXYrE1DPKetX0pGS5Ouw9Kobwt+sT4aKLb17XWybuAykDperYwvtmlI4Qv
 uMAYzfZFtIvf4VhitkJ4HKXO/5b7MGMaYyh11rttNxprwK39k4ekNhPBOx58KzQSjHOi
 x9Qg==
X-Gm-Message-State: APjAAAU99OP1yO8j6d8T9RXHjgECCLRFbrA0a3WdgqrkKXBLXCNAmgMV
 9BbDBXfp5UM/yN1qv0t7d7qs23tq6fPLlxE5TxHq6A==
X-Google-Smtp-Source: APXvYqz5IQbjutZdvvYa/3o0Mr6hqGWXbe7G7tQsit1pTz8/pYN9OG6VZnW+z/gr1RizUorqEyF5YU2yY3mz3vzG/rg=
X-Received: by 2002:a05:6808:b04:: with SMTP id
 s4mr4127338oij.163.1573747029581; 
 Thu, 14 Nov 2019 07:57:09 -0800 (PST)
MIME-Version: 1.0
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-10-andre.przywara@arm.com>
 <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
 <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
 <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
 <90cdc695-f761-26bd-d2a7-f8655ce04463@arm.com>
 <187393bb-a32d-092d-d0ea-44c58a54d1de@arm.com>
 <CAFEAcA_kcQwrnJxtCynX9+hMEvnFN0yBnim_Kn-uut5P4fshew@mail.gmail.com>
 <241e3df3-e3e3-14a0-3fbe-5398a1bf9d00@arm.com>
In-Reply-To: <241e3df3-e3e3-14a0-3fbe-5398a1bf9d00@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 14 Nov 2019 15:56:58 +0000
Message-ID: <CAFEAcA9-BPCN2VC5qJO0oPPPdVbai05KM68eMUxA3tDn_10LFw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping
 GICD_CTLR.DS
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Thu, 14 Nov 2019 at 15:47, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> On 11/14/19 3:27 PM, Peter Maydell wrote:
> > The virt board doesn't do EL3 by default, but if you add -machine secure=true
> > to your command line then it it should emulate it, including a
> > trustzone-aware GIC.

> Indeed, and that made the test fail because apparently qemu implements it as
> RAZ/WI (which is allowed by the architecture). Thank you for the suggestion!

Hmm. The behaviour QEMU thinks it's implementing is:

 * if we have only one security state, then CTLR.DS is RAO/WI
 * if we have two security states, then:
    - for access from NonSecure, CTLR.DS is RAZ/WI
    - for access from Secure, CTLR.DS is initially 0, and is
      writeable, but if you write 1 to it then the only way
      to get it to go back to zero is to reset the system

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
