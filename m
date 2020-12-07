Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68DEC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:10:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F4192388B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:10:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F4192388B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6654B29F;
	Mon,  7 Dec 2020 12:10:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CnPiDZwt9tvp; Mon,  7 Dec 2020 12:10:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F964B2B3;
	Mon,  7 Dec 2020 12:10:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E46734B29B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:10:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6CB4rTFTGHtN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 12:10:18 -0500 (EST)
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com
 [209.85.208.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A4DD4B2D2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:10:18 -0500 (EST)
Received: by mail-ed1-f66.google.com with SMTP id cm17so14544065edb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2020 09:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KSdUiyb5ZmZGus9Y18Esm/Zi55w1Hy2x+mQSpH1tzEg=;
 b=dHJ+4IMA3X/al5s5DbkYTlY6I3LlVghULMawjnKlSJ0ze0yAdXh3fCrv3mTZJCBv5T
 COs0CvYqumyk8HnIq52h+Q2+zeuex8E3vSrshRY8sEfQFqP4k8JwSUmB2yYVZ3zRW0S2
 a4+D6euycenV66JUlcpEKePPOO4+mC63iaSxPHS8aMqUJIucKw+0jCpXS1KCQN+g8A9W
 KCjzNaQ53v7EV+5sAfnYd2YDUSVZmVsbh4yxapvRPCAQ4sCavkK1hafYGGbkjrnoFHGn
 +fTLlRh13G3GV5h3wNlQOj6l0hRVljg5R5H5HRAWUS+c2v7uertmQtRBqZLDyFw+KRWC
 w8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KSdUiyb5ZmZGus9Y18Esm/Zi55w1Hy2x+mQSpH1tzEg=;
 b=jtf8IKHAdPqOAvWTeKjk2iYNc2m9RL+Lawr++qOwsb1ohXkfCdCdsgtvJh1AHE92sZ
 7IWqr6E+4oIx+b9ueI9XZbhMVitSRZfL38qF3W0MlT2V7kQtVQOgzVcXk8NOdtpcUUD0
 0Zh00j9dJTneyr0AJf7OyeOI3dFuVKp9HWB831Qa0zBzbEnPgjD13D4j1IkesVaVI45X
 ZPCuFOsNh7uk+Iy3VE+/NzCZBw3N9txWzrO8bPQj2XmJ9lcrcXIiF948BkelhZGkZX7q
 3JzCQ6o43p3lqtT9my4iHp94lYVMXGqD5zEsZ9UQNaSzgkA2JLh+VdhLYjhGDhwYkkXJ
 5MZw==
X-Gm-Message-State: AOAM532KIotrZ79ED46wzH8F3XzoSaBUhOJqq5mXpI869IEdaJmmVkQ7
 7fU1tgfxy78z9ZEiB9V5a9hJ2Nzcircc4fPvSrX8Ww==
X-Google-Smtp-Source: ABdhPJwIY/AvBAO1IUq++8k81Pl67K5DOxG9V6nkqs+h+0gM8fHl+Ak6grDKEj8FlGUvbPzQkEzvfQ/hzY1pBXmaeoI=
X-Received: by 2002:a05:6402:366:: with SMTP id
 s6mr9267484edw.44.1607361017612; 
 Mon, 07 Dec 2020 09:10:17 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAFEAcA_Q8RSB-zcS8+cEfvWz_0U5GLzmsf12m_7BFjX8h-1hrA@mail.gmail.com>
 <b975422f-14fd-13b3-c8ca-e8b1a68c0837@arm.com> <20201207164428.GD3135@work-vm>
In-Reply-To: <20201207164428.GD3135@work-vm>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 7 Dec 2020 17:10:06 +0000
Message-ID: <CAFEAcA9mq0xh1CNvw9UZoNwcOBuoVnCNcBkRDSUv7UK27qdESg@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Juan Quintela <quintela@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Steven Price <steven.price@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 David Gibson <dgibson@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
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

On Mon, 7 Dec 2020 at 16:44, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> * Steven Price (steven.price@arm.com) wrote:
> > Sorry, I know I simplified it rather by saying it's similar to protected VM.
> > Basically as I see it there are three types of memory access:
> >
> > 1) Debug case - has to go via a special case for decryption or ignoring the
> > MTE tag value. Hopefully this can be abstracted in the same way.
> >
> > 2) Migration - for a protected VM there's likely to be a special method to
> > allow the VMM access to the encrypted memory (AFAIK memory is usually kept
> > inaccessible to the VMM). For MTE this again has to be special cased as we
> > actually want both the data and the tag values.
> >
> > 3) Device DMA - for a protected VM it's usual to unencrypt a small area of
> > memory (with the permission of the guest) and use that as a bounce buffer.
> > This is possible with MTE: have an area the VMM purposefully maps with
> > PROT_MTE. The issue is that this has a performance overhead and we can do
> > better with MTE because it's trivial for the VMM to disable the protection
> > for any memory.
>
> Those all sound very similar to the AMD SEV world;  there's the special
> case for Debug that Peter mentioned; migration is ...complicated and
> needs special case that's still being figured out, and as I understand
> Device DMA also uses a bounce buffer (and swiotlb in the guest to make
> that happen).

Mmm, but for encrypted VMs the VM has to jump through all these
hoops because "don't let the VM directly access arbitrary guest RAM"
is the whole point of the feature. For MTE, we don't want in general
to be doing tag-checked accesses to guest RAM and there is nothing
in the feature "allow guests to use MTE" that requires that the VMM's
guest RAM accesses must do tag-checking. So we should avoid having
a design that require us to jump through all the hoops. Even if
it happens that handling encrypted VMs means that QEMU has to grow
some infrastructure for carefully positioning hoops in appropriate
places, we shouldn't use it unnecessarily... All we actually need is
a mechanism for migrating the tags: I don't think there's ever a
situation where you want tag-checking enabled for the VMM's accesses
to the guest RAM.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
