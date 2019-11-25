Return-Path: <SRS0=lGdW=ZR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEDAC432C0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 17:28:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8091E20835
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 17:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eVbnkL+V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8091E20835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2C5C4A7D9;
	Mon, 25 Nov 2019 12:28:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4SBnxk1rFJE6; Mon, 25 Nov 2019 12:28:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B87A24A5A3;
	Mon, 25 Nov 2019 12:28:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93AC34A59D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 12:28:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ch3dGXBo1Qtt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Nov 2019 12:28:06 -0500 (EST)
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com
 [209.85.167.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 714024A591
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 12:28:06 -0500 (EST)
Received: by mail-oi1-f195.google.com with SMTP id n14so13798845oie.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 09:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ODipN45RKDugqEFByxohJfMmDdgzkjUfNBbVFYHiRmI=;
 b=eVbnkL+Vk3EkMi7q6dN4vXzhJf7Ftx3WPG9I73qm0Gb34i7HeKk2DPCCMLkegdCbXK
 Lzv937WHEy+KSrJC7a4Rh4R3T2I+kXu2ErH91rS75fe5wpQvc6mvGcN5qOhbrvvCR4ZA
 75JLGS3ULzc/F2ux0OppY/ZEGpNOwbEp/4wyqeyF+DCwDqI6COdTzGo03xjRVLu4gn68
 odi6GKPosFyxZJ6dxnKs7SYo5+zcpvz1loIPGC2ndrvthlHoPj/G/MrPpDX1+DUNKiEO
 EDcLkdFj5+HUCLY4vWLEuEz6Bw1M/RLfMnhWQX/QVLDIDSlH5vp3MFJrocx7TjyYV4wm
 WFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ODipN45RKDugqEFByxohJfMmDdgzkjUfNBbVFYHiRmI=;
 b=pmIO1uAH6o8oZ9TchVy8SAq9/K6P39aAQbHFbgytDGHytcyxzy8p5SeXC/y+m7ZWHq
 biBuX/UkXXMUMib24LWoYW5vNhKpxOz7/Kfx/JWT6K6JVLAGUEOsx9xSc97VOCwjkWqM
 nMOzlTN6g8/dZQCRTLPkeycaHaUEnqbIhwdVTzEO8JJX3VNmBIUWHtYLIQdnjd3V+CvL
 v3kcsn9GqmWk5x29Z2Guq0Wt8ZOYzoZilR12VfMS2qEAF+RfIelJHJ6r0sgxsSsatvPE
 ia8FInOKYtOIsH9f7U3i4HcrufIhKzrE89fr6t1LVps2mtc6IsUpCgp31hg9SFIcWqRd
 nN7g==
X-Gm-Message-State: APjAAAVU+ViFjr/j/4qkvSzxuDVd22JiZlZ94fmyuFBO+KJFr3DXGuUX
 uT+b3kOdGjCxnWvNBJ/C3raiaG1Ko+PrBpzRqTwHog==
X-Google-Smtp-Source: APXvYqyHtjqHcQwQ1kxjFN2sdOoix589I/J3kl2Mykq4RvSYXPJz1FlyLbetm0ZeYRQXecq1Z5ODCNt3h2rQ9AE4t90=
X-Received: by 2002:a05:6808:8c2:: with SMTP id
 k2mr23885342oij.163.1574702885777; 
 Mon, 25 Nov 2019 09:28:05 -0800 (PST)
MIME-Version: 1.0
References: <20191123115618.29230-1-maz@kernel.org>
 <CAFEAcA_MQpJ=8UFnP=Qnt+4GWMUO_AtJBBNz-bM2L2wf5htuaQ@mail.gmail.com>
 <4d8c4763da39d5bfb1800735f90d82d1@www.loen.fr>
In-Reply-To: <4d8c4763da39d5bfb1800735f90d82d1@www.loen.fr>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 25 Nov 2019 17:27:54 +0000
Message-ID: <CAFEAcA87ceF_0ifLn1t9CxyEwJ-rwW8h4QauJGk+ATphJaWa6Q@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Honor HCR_EL2.TID3 trapping requirements
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 kvmarm@lists.cs.columbia.edu
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

On Mon, 25 Nov 2019 at 17:08, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2019-11-25 16:21, Peter Maydell wrote:
> > Missing .accessfn for ID_AA4PFR2_EL1_RESERVED ?
>
> Indeed, I oversaw that one. I'll fix it and repost it together with
> the extra patches to handle TID1 and TID2.

Given that rc3 (last chance, more or less, for bugfixes for 4.2)
is tomorrow, I propose that I take this patch with the
+              .accessfn = access_aa64idreg,
line for ID_AA64PFR2_EL1_RESERVED squashed in. I think
TID1/TID2 and the MMFR-from-aarch32 parts are less urgent ?

> > These are the AArch64 accessors for the aarch32 MVFR registers,
> > but this trap bit is also supposed to trap aarch32 accesses to
> > the MVFR registers, which are via the vmrs insn. That needs
> > to be done in trans_VMSR_VMRS(); we can do that with a
> > followup patch, since the mechanism there is completely different.
>
> Holy cow! I'm afraid that my newly acquired QEMU-foo is missing
> a few key options. Does it mean we need to generate a trapping
> instruction, as opposed to take the exception on access?

We will need to generate a call to a helper function which
does the access check (and possibly raises an exception).
We can't determine at translate time whether the insn is
going to cause an exception, because the TID3 bit is not one
of the fairly limited set of information which we put into
the TB flags and allow to be baked into the generated code.
(In theory we could add it, but we don't have very many TB
flags so we only do that for cases where the overhead of doing
the check at runtime matters.)

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
