Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF39AC43331
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:31:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4500C20650
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PHfICUeS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4500C20650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B83AB4A568;
	Fri,  6 Sep 2019 09:31:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fKu2cyAzvPer; Fri,  6 Sep 2019 09:31:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5B7B4A5A2;
	Fri,  6 Sep 2019 09:31:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8994A558
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:31:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RPFbctX7LYYJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 09:31:54 -0400 (EDT)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B27A4A542
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:31:54 -0400 (EDT)
Received: by mail-ot1-f65.google.com with SMTP id b2so5699063otq.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Sep 2019 06:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2e7BdIjA7tp8BLDXeTA/WaYjf5EqoeihfbnfZF6VGmM=;
 b=PHfICUeS2mGCEh2CUf3C4hLmGAZ/WIw5tAL4fbOBgvE0Y8Ltf9mXNE3/ktZvwiHkB/
 dFroiYLtzUzJrSiZFcu/QpXoDOSrvwWUQ0H3FFFkdXSseWIf2bDhqlGbc2qbRZ9oAXuP
 MGgVx6djL4ok5HVHhvhpy0lUn0ocg2WuN1gW/IIFZ0ZI3Uw3w4gBtrrG1ljJIdFozS4J
 E3gb7oNUQcRxPkaKWpXR2gFZt3fZqSNRuQUOxJFDOyVR6ESPYtAdrOdZvsgasgM/e3uv
 S9KxhITdI8qURQHjP4qbzOcYpPXrElyuyt6BAQB+J1zNYBrAx+CQZoknoBo6x+/jcUvZ
 5lYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2e7BdIjA7tp8BLDXeTA/WaYjf5EqoeihfbnfZF6VGmM=;
 b=C0/cO6W3kYvThh2FWJ6XW4zkTap8pJtqqHuY7unrWCl7XVyAg8rIa7YIXiojbKZu6C
 /MrVkEMSJq8Lz0EFkzZbGq5J5wajLTQfiGXdKkId+Js7o8p9+V4hrLiLRC9n62A8Km+o
 CAMLVuzMrxNKD4/UnDkS4Hxom+wRYsI4lnICNOh4mgkkEUGgCY5pkqBN4U585PvL49JV
 1SJbL5fmd1z70bc5fr/pZtLLh8f9j3XYz3ust3OjSWq66fPRXAw1expQTqQatUoldRg4
 BZG85AwtJN+btLFv/OmqH7OoVufm5ySzOYs9vclXlc9tPs7z3QH2GsOgAAjGbC97M8I9
 6FGQ==
X-Gm-Message-State: APjAAAVdc3/Dl1mjJNpBQopPFT54xxo11rqUb3UtfpyOXT8983TH5lxn
 CePkknYkcfDmZgDsbHiqnmMrGa3aqyA6H202dR1LYQ==
X-Google-Smtp-Source: APXvYqwHxB0tCnJPTv4Q3uXRBF5mEn1yIopnVEF/pkDXQ5Kdt3akKBuuprc79qQjbky6hEBpVz6/HyR6CfvcxPFrepI=
X-Received: by 2002:a9d:6a8a:: with SMTP id l10mr4739602otq.97.1567776713698; 
 Fri, 06 Sep 2019 06:31:53 -0700 (PDT)
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
In-Reply-To: <20190906131252.GG4320@e113682-lin.lund.arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 6 Sep 2019 14:31:42 +0100
Message-ID: <CAFEAcA9vwyhAN8uO8=PpaBkBXb0Of4G0jEij7nMrYcnJjSRVjg@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
To: Christoffer Dall <christoffer.dall@arm.com>
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

On Fri, 6 Sep 2019 at 14:13, Christoffer Dall <christoffer.dall@arm.com> wrote:
> I'd prefer leaving it to userspace to worry about, but I thought Peter
> said that had been problematic historically, which I took at face value,
> but I could have misunderstood.
>
> If QEMU, kvmtool, and whatever the crazy^H cool kids are using in
> userspace these days are happy emulating the exception, then that's a
> viable approach.  The main concern I have with that is whether they'll
> all get it right, and since we already have the code in the kernel to do
> this, it might make sense to re-use the kernel logic for it.

Well, for QEMU we've had code that in theory might do this but
in practice it's never been tested. Essentially the problem is
that nobody ever wants to inject an exception from userspace
except in incredibly rare cases like "trying to use h/w breakpoints
simultaneously inside the VM and also to debug the VM from outside"
or "we're running on RAS hardware that just told us that the VM's
RAM was faulty". There's no even vaguely commonly-used usecase
for it today; and this ABI suggestion adds another "this is in
practice almost never going to happen" case to the pile. The
codepath is unreliable in QEMU because (a) it requires getting
syncing of sysreg values to and from the kernel right -- this is
about the only situation where userspace wants to modify sysregs
during execution of the VM, as opposed to just reading them -- and
(b) we try to reuse the code we already have that does TCG exception
injection, which might or might not be a design mistake, and
(c) as noted above it's a never-actually-used untested codepath...

So I think if I were you I wouldn't commit to the kernel ABI until
somebody had at least written some RFC-quality patches for QEMU and
tested that they work and the ABI is OK in that sense. (For the
avoidance of doubt, I'm not volunteering to do that myself.)
I don't object to the idea in principle, though.

PS: the other "injecting exceptions to the guest" oddity is that
if the kernel *does* find the ISV information and returns to userspace
for it to handle the MMIO, there's no way for userspace to say
"actually that address is supposed to generate a data abort".

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
