Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D607FC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 20:02:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 536CB60F70
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 20:02:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 536CB60F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD86E4B091;
	Tue,  2 Nov 2021 16:02:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r7toSwVzNdMd; Tue,  2 Nov 2021 16:02:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADE514B106;
	Tue,  2 Nov 2021 16:02:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6289F4B091
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 16:02:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id khGYJI-vgK6d for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 16:01:59 -0400 (EDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com
 [209.85.208.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27C214A19F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 16:01:59 -0400 (EDT)
Received: by mail-lj1-f181.google.com with SMTP id d23so90334ljj.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=BDslnEzmaYl8XemO8H14C3E5c69KKbu6q3LyWC8hs6c=;
 b=Y27DdbKfhZ9/em7rMZL3gynod2fwnh07kZ/RrJMtHRxIkaacuz/t1gWiIlisWzp66P
 0vy3sU9WnqbGhx5odG2aKcwRyOfePyWlTLndkiWKaDlR2hoamDr2VC6rHkxfOtWpuP+Z
 ziv8The/TmmcLSQp4curc6nXf41+Kb5ZcCP4bOpkUWs8/1LWyxEvLyTfIx8L7cKL7xWh
 95rhU0KD2PlzngyxJiEn+D1lI+/dUUk91seFcdbdceB/C+WrwBIvN2lncT+KH+Ur9yqe
 rI1OKChd+w93QeyfYRhCaM+RJyUnXCkYukVxTqjjHT/WxI8HhfI7xw38Z7Mw4UX/+a9v
 0vQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=BDslnEzmaYl8XemO8H14C3E5c69KKbu6q3LyWC8hs6c=;
 b=XKQmRjzWU6q3T9+cmNveokOBXu8wfRqk7K2nNgSDupouSAg0A878UHGLmNAYeGTi9X
 7cZw9Ul980vxv6NkjquN7n7Yn9O3vglPLv0KaCtI3NbdakMPJKWf3QrmQvnadBlmpBLI
 heWT78mLPLaG3xFomw7nu6jjjt+VoZKy3YcwGW8Z5o1jWvNrtBTiF7BIvAm/K45tUPmO
 fHYcG3yIDpi9SIMoBiJLKLNFmRhiApjMzGQusj1YFGnDXZ/AlfmQrQ3t1gE6QnUklfm+
 B3guUF46AfLpP+Cj20qJY/KzJvsPRGqPX5f8BQeSTRA7vOm8EEadeIbKWxUn29n5+TBE
 il0A==
X-Gm-Message-State: AOAM531xGN8P54s9marsLhMaAlsnWVHu6T+FIEs9sPtU1SXajZsvMLJf
 ug9feeuSAeoAiaslsIthjGmlw2BFaMtpYWO+aEOFNA==
X-Google-Smtp-Source: ABdhPJxwGH/Xjrm74EIMk3UQCQLZsG2pEJnnfrQ2FDpM1CoFNZIbHEdfny5vZ0lVDpSfXmbDZCATT/vApVIzPh/Vpzo=
X-Received: by 2002:a05:651c:1051:: with SMTP id
 x17mr38505200ljm.337.1635883317514; 
 Tue, 02 Nov 2021 13:01:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-7-oupton@google.com>
 <875ytaak5q.wl-maz@kernel.org>
 <CAOQ_Qsgc7aA89OMBZTqYykbdKLypBhra0FNQZRPTEHpcaaqyhw@mail.gmail.com>
In-Reply-To: <CAOQ_Qsgc7aA89OMBZTqYykbdKLypBhra0FNQZRPTEHpcaaqyhw@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 2 Nov 2021 13:01:46 -0700
Message-ID: <CAOQ_Qsj1rjL5RgkgEL+Bkp9OY6i51VaQetBfppYVF1XLq92rXQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] selftests: KVM: Test OS lock behavior
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Nov 2, 2021 at 7:53 AM Oliver Upton <oupton@google.com> wrote:
> >
> > I haven't had a change to properly review the series, but this one
> > definitely caught my eye. My expectations are that BRK is *not*
> > affected by the OS Lock. The ARMv8 ARM goes as far as saying:
> >
> > <quote>
> > Breakpoint Instruction exceptions are enabled regardless of the state
> > of the OS Lock and the OS Double Lock.
> > </quote>
> >
> > as well as:
> >
> > <quote>
> > There is no enable control for Breakpoint Instruction exceptions. They
> > are always enabled, and cannot be masked.
> > </quote>
>
> /facepalm I had thought I read "Breakpoint Instruction exceptions" in
> the list on D2.5 "The effect of powerdown on debug exceptions",
> although on second read I most definitely did not. And if I had read
> the bottom of the section, I'd of seen one of the quotes.
>
> > I wonder how your test succeeds, though.
>
> Probably because the expectations I wrote match the non-architected
> behavior I implemented :-)

Alright, gave the series a good once over after this and fixed up
quite a few things. Unless you're ready for it, I'll hold back for a
bit to avoid spamming inboxes. As an FYI, here's the fixes I have
queued up:

v2 -> v3:
- Stop trapping debug exceptions when the OS Lock is enabled, as it
   does *not* block software breakpoint exceptions (Marc)
 - Trap accesses to debug registers if the OS Lock is enabled to prevent
   the guest from wiping out KVM's configuration of MDSCR_EL1
 - Update the debug-exceptions test to expect a software breakpoint
   exception even when the OS Lock is enabled.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
