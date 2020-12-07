Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079AFC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 15:27:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 620C32371F
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 15:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 620C32371F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AED944B288;
	Mon,  7 Dec 2020 10:27:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 24W6cTPrWdyC; Mon,  7 Dec 2020 10:27:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A03494B274;
	Mon,  7 Dec 2020 10:27:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A229A4B272
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 10:27:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B+RY1AP3MUXu for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 10:27:53 -0500 (EST)
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com
 [209.85.218.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 990454B26B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 10:27:53 -0500 (EST)
Received: by mail-ej1-f67.google.com with SMTP id jx16so20010711ejb.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2020 07:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CWPqY7gB/QoMToun+/6liS3Aa5bW1uZwjLPmmW+88Ls=;
 b=oBuBU1tDmmtrU8cWvFlNKQWEqdKRQqE+dKLNuy9coZBBMCAJGg+E3Kc1wVxRgi/hGQ
 vGFMphwkXSofsqjWkq+HMZ3AqYHvAvIvBunbHGBON3w6W+gamq3+mTIDD9MnwpbG5daf
 V/RYUVeN5MDlShhtWblzedtvCxeXUWBY+Ay/n5eL34XeViW2U/znT0VRqBFDQfosUJ5+
 iaF0gRhMU8gUf4QTzKigFbIIixW09ocdj2KLMN3eylf2lrn3YSOvJcVIcN2BJpCTZ4U1
 GCRaC/lGDa+Wu2VviBnS9CCYjnPe/na+kkUsZu2PyCc21jIo5N4Dk8oSQ2sBrjDlzmkB
 AHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CWPqY7gB/QoMToun+/6liS3Aa5bW1uZwjLPmmW+88Ls=;
 b=IAlcfx6L3QIZl+8QLsF95m2+IwTLEI2r+YPsaWwasAyQCSc2+5M1NlFO4KYLT5/JMf
 EESkuJ0UAmMVwt9ILmxzXpiOAPpP0GIRXOM/QWTklwV9WPQaI6iz67HPzoCNu0fEW0yz
 t57QXxPjsCHEwy2w/464I/fkUzupzMNcqYlNEUPW076b8pOl1h9UnI0cqeikuZjhRkKt
 CiVk+mFn+jlSEx5mZLV1jySmCkdDjEWafm7KIFYOWrs6Wu4mi1u3fg/wpu0asqwmE5g9
 q0p8h/vmNvhSUo4nJWHZUdjTYvOsXRkF74gPJFiZQzO3J0tGilPOzpMG7x682ne6pfCO
 LrzQ==
X-Gm-Message-State: AOAM5305ZUtrma/VSK3KfYikdCb1aZXM7ZxHhsSt5p7nWt8tRQavYwnK
 3f02nkawoG/Pg3Il40jq5QMb7jDjUjTTawKzlPRoWA==
X-Google-Smtp-Source: ABdhPJxzlqdtQ7zxg9nsdsKrHpDmw3fYW0PNLe0UvSzvUx0bNUOWgUFAyJCA9n9a8k59bXziSr7Lj3CtVdIGqZTX0SA=
X-Received: by 2002:a17:906:1542:: with SMTP id
 c2mr18896508ejd.382.1607354872135; 
 Mon, 07 Dec 2020 07:27:52 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
In-Reply-To: <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 7 Dec 2020 15:27:40 +0000
Message-ID: <CAFEAcA_Q8RSB-zcS8+cEfvWz_0U5GLzmsf12m_7BFjX8h-1hrA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Steven Price <steven.price@arm.com>
Cc: Juan Quintela <quintela@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Dave Martin <Dave.Martin@arm.com>
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

On Mon, 7 Dec 2020 at 14:48, Steven Price <steven.price@arm.com> wrote:
> Sounds like you are making good progress - thanks for the update. Have
> you thought about how the PROT_MTE mappings might work if QEMU itself
> were to use MTE? My worry is that we end up with MTE in a guest
> preventing QEMU from using MTE itself (because of the PROT_MTE
> mappings). I'm hoping QEMU can wrap its use of guest memory in a
> sequence which disables tag checking (something similar will be needed
> for the "protected VM" use case anyway), but this isn't something I've
> looked into.

It's not entirely the same as the "protected VM" case. For that
the patches currently on list basically special case "this is a
debug access (eg from gdbstub/monitor)" which then either gets
to go via "decrypt guest RAM for debug" or gets failed depending
on whether the VM has a debug-is-ok flag enabled. For an MTE
guest the common case will be guests doing standard DMA operations
to or from guest memory. The ideal API for that from QEMU's
point of view would be "accesses to guest RAM don't do tag
checks, even if tag checks are enabled for accesses QEMU does to
memory it has allocated itself as a normal userspace program".

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
