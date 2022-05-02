Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE577C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 16:55:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 486D84B23A;
	Mon,  2 May 2022 12:55:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7HcFdGHPmfU1; Mon,  2 May 2022 12:55:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36EDC4B1A9;
	Mon,  2 May 2022 12:55:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 222EA49EE6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 12:55:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id byHcJ9nKtkHK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 12:54:59 -0400 (EDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
 [209.85.208.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2F2549EB2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 12:54:58 -0400 (EDT)
Received: by mail-lj1-f172.google.com with SMTP id q185so19075135ljb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 09:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=tuwSXDS47usg98UbOCK/I9oPEzbY53h2cc8iNFbvNdQ=;
 b=aMhh8jxi4MJNkWjHLMMsq21pu+OlopMpNWh/ZkcBXDP72LSQ4XoW3ys9Aid/fsiFyo
 6f33+KLowYyiwr5MPmEx92h34cmNTRYgDAIVeUP2R88OpMo9h8QovxDHFK3K2MgcpUKz
 ozK4fCy0XFBENiG1s2ch0aKV/O5ZaTi/x/rf3Gu3d/Ty0zraKgMEMbwQcDjlCH+O5H5M
 jNvG/4k8zJtPPOkFF25ROWlzpr84s1xlORhrOMkw2L/V/mYnL6wRS4MiqeHULVlFyJ/P
 5XgedszkbvcnOnkQ/YO2on9T3IYpk0esfVTWBj0ne3SrkozSH0e7Ug//kG0aP0qbR925
 4x6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tuwSXDS47usg98UbOCK/I9oPEzbY53h2cc8iNFbvNdQ=;
 b=IziPFTENVzJQnxVphWN2difAQqhJluy5rsLaXFosz9KinCpx1vQgY2GBVSmGTYbdbu
 d6B/dIoARmRxVl21KpTJRPyD1VdY9ZpdwTx1CdIw0TN3B2VUWGj7Tuy5dLDgH+u2wySE
 f7Wor9bwwVTL91/QfaDq0b3E0ImWgf9+e8vj43y6l0fjZaqa1ZNaH25F0AHdLw35aX0T
 5VZZ86glfeuiAk2sQ+KSqKVEUTIyVPANIL6qbJaAevtpZfm/j3Rxwtic7fMiJbbDQYQW
 XKcjGJfn7boRBxcS0Mamg9cAo2jvkkfme84Uzh0TOMHMBUlD/1a6i51wMRIQ9DLO/2MD
 in1w==
X-Gm-Message-State: AOAM531AITdTW4WcDR347RZ2+QnyCEBwLiu5Y9VlYfsI9IyZIImmipFI
 CpJ3eOzzOUuqs5h64hJ4zCL5mp2jza2oBPmRJFEDgg==
X-Google-Smtp-Source: ABdhPJxidiAuNREg4SBCMW3M8snJ5Qcx2YyO7ESaLOxRuKvXGNp4UO7ALmr+WQsQqrydLCtL70Bgahl47Xz4JvKAbVg=
X-Received: by 2002:a05:651c:104f:b0:24f:3fc4:1892 with SMTP id
 x15-20020a05651c104f00b0024f3fc41892mr8053610ljm.399.1651510497220; Mon, 02
 May 2022 09:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220420214317.3303360-1-kaleshsingh@google.com>
 <165117574186.3115452.6818682378273681624.b4-ty@kernel.org>
In-Reply-To: <165117574186.3115452.6818682378273681624.b4-ty@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 2 May 2022 09:54:45 -0700
Message-ID: <CAC_TJve+n8gXbG_XY_rb+DC7399SSmP6BRc5x7X=cvht50XLYA@mail.gmail.com>
Subject: Re: [PATCH v8 0/6] KVM: arm64: Hypervisor stack enhancements
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: "Cc: Android Kernel" <kernel-team@android.com>,
 Will Deacon <will@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Changbin Du <changbin.du@intel.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Suren Baghdasaryan <surenb@google.com>,
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

On Thu, Apr 28, 2022 at 12:55 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 20 Apr 2022 14:42:51 -0700, Kalesh Singh wrote:
> > This is v8 of the nVHE hypervisor stack enhancements. This version is based
> > on 5.18-rc3.
> >
> > Previous versions can be found at:
> > v7: https://lore.kernel.org/r/20220408200349.1529080-1-kaleshsingh@google.com/
> > v6: https://lore.kernel.org/r/20220314200148.2695206-1-kaleshsingh@google.com/
> > v5: https://lore.kernel.org/r/20220307184935.1704614-1-kaleshsingh@google.com/
> > v4: https://lore.kernel.org/r/20220225033548.1912117-1-kaleshsingh@google.com/
> > v3: https://lore.kernel.org/r/20220224051439.640768-1-kaleshsingh@google.com/
> > v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
> > v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/
> >
> > [...]
>
> Applied to next, thanks!
>
> [1/6] KVM: arm64: Introduce hyp_alloc_private_va_range()
>       commit: 92abe0f81e1385afd8f1dc66206b5be9a514899b
> [2/6] KVM: arm64: Introduce pkvm_alloc_private_va_range()
>       commit: f922c13e778d6d5343d4576be785a8204c595113
> [3/6] KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
>       commit: ce3354318a57875dc59f4bb841662e95bfba03db
> [4/6] KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
>       commit: 1a919b17ef012ca0572bae759c27e5ea02bfb47f
> [5/6] KVM: arm64: Detect and handle hypervisor stack overflows
>       commit: 66de19fad9ef47c5376a99bb2b00661f1c788a94
> [6/6] KVM: arm64: Symbolize the nVHE HYP addresses
>       commit: 6ccf9cb557bd32073b0d68baed97f1bd8a40ff1d

Thanks for applying these Marc.

I was wondering if instead of taking these through kvm-arm64/next,
could Catalin consolidated these in arm64 for-next/core with Mark
Ruthland's and Madhavan's stacktrace patches[1]? This avoids conflict
and would allow for the hypervisor unwinding changes[2] to apply
cleanly.

[1] https://lore.kernel.org/r/20220413145910.3060139-1-mark.rutland@arm.com/
[2]  https://lore.kernel.org/r/20220427184716.1949239-1-kaleshsingh@google.com/

Thanks,
Kalesh
>
> Cheers,
>
>         M.
> --
> Without deviation from the norm, progress is not possible.
>
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
