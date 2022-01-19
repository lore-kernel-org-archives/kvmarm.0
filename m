Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3B0C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jan 2022 07:47:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCBF84A7FD;
	Wed, 19 Jan 2022 02:47:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UfNbZ4S2DoFH; Wed, 19 Jan 2022 02:47:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 834BF4A49C;
	Wed, 19 Jan 2022 02:47:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CA3F4A119
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jan 2022 02:47:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iJkfA5kfyosH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jan 2022 02:47:31 -0500 (EST)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 373A149F40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jan 2022 02:47:31 -0500 (EST)
Received: by mail-pf1-f169.google.com with SMTP id i65so1784013pfc.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 23:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qbiJb2UVtirrAHsd/tlBtET4SjB9SQTlHXui+2izr3s=;
 b=bP8mpKrUKYYcA4KRpX/Iab6PVeCaEBou0Rle0wK4u0oCxHKHJNxK3XOy8B6lcxgvXY
 FOco+CP1Zd+i3br6c9kACIwlpelrznWTBYQUgGtAv7CIL5/Vnzro9VaR+3UOWqaq8BVB
 xO6cf+i5UOhU4GoneriU5p5ARzP2ioFnBe4GfgF/C+JvyNABeyjbtY0rfzzo/ABYY++3
 iJR1Xxp98BG1ihJUwNmD+zPbT8XFXRlCn6TXC5AqGaP9hKk35oUB0BaIZ9HYjhj8NlBp
 FAWsGfVPMfQ2g6v6WkTOQ8wNCoRN/d9yFYycIOipiN0vhIS7vAg3sF7aPCVLXrVqbIL7
 RxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qbiJb2UVtirrAHsd/tlBtET4SjB9SQTlHXui+2izr3s=;
 b=01yFYDbPoSBikMm+lonbuUHeWHRo4yWCKSDAHc54DKEMgsAzL0qHZVJslH9/H19ma6
 STCYNwV0ffbuhQUXwYPmgB7hXEb4te2kSMHC322j4MpuSyEfEseYDvbHHdrI+sLNUqOp
 2iT/eFbeu/Iy2ERXO6w+LMr+/Xc2H2WlMyMQCO+hlBkRNzQdbVgFlwyNidCFCw+KSaOX
 /jIAlnFHokoK0k/4hQELBJusxFeJgP+OXiZHZFrPK3jr2LVjNTsXsNE4rJ3GOtH8D97O
 GNdMNN0wwYT2sDuBcgXNMDo6KcZCVFJqKv0fqFK9pWy0HhNbNxhF9ClH6ns7ThRRslhG
 8jPA==
X-Gm-Message-State: AOAM532tFQtPfBgujRL2wI4DghchY+5A3C9RDp7rePNwi5T44sbg7nsh
 4dht5KsBMees7NG5HwLvO+P4cBsL0FuLz7UwtIs6Bg==
X-Google-Smtp-Source: ABdhPJynjuL5EJyIFAzAyBjd8DX1zCihK90pwXV5JoP1UY92TV4OnkyTmudcqtrcfRqYDdlvxWABUiftzGEKe/ZrgUE=
X-Received: by 2002:a63:7d42:: with SMTP id m2mr26257918pgn.491.1642578450084; 
 Tue, 18 Jan 2022 23:47:30 -0800 (PST)
MIME-Version: 1.0
References: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com>
 <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
 <YedWUJNnQK3HFrWC@google.com>
In-Reply-To: <YedWUJNnQK3HFrWC@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 18 Jan 2022 23:47:13 -0800
Message-ID: <CAAeT=FyJAG1dEFLvrQ4UXrwUqBUhY0AKkjzFpyi74zCJZUEYVg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>
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

On Tue, Jan 18, 2022 at 4:07 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jan 14, 2022, Reiji Watanabe wrote:
> > The restriction, with which KVM doesn't need to worry about the changes
> > in the registers after KVM_RUN, could potentially protect or be useful
> > to protect KVM and simplify future changes/maintenance of the KVM codes
> > that consumes the values.
>
> That sort of protection is definitely welcome, the previously mentioned CPUID mess
> on x86 would have benefit greatly by KVM being restrictive in the past.  That said,
> hooking KVM_RUN is likely the wrong way to go about implementing any restrictions.
> Running a vCPU is where much of the vCPU's state is explicitly consumed, but it's
> all too easy for KVM to implicity/indirectly consume state via a different ioctl(),
> e.g. if there are side effects that are visible in other registers, than an update
> can also be visible to userspace via KVM_{G,S}ET_{S,}REGS, at which point disallowing
> modifying state after KVM_RUN but not after reading/writing regs is arbitrary and
> inconsitent.

Thank you for your comments !
I think I understand your concern, and that's a great point.
That's not the case for those pseudo registers though at least for now :)
BTW, is this concern specific to hooking KVM_RUN ? (Wouldn't it be the
same for the option with "if kvm->created_vcpus > 0" ?)


> If possible, preventing modification if kvm->created_vcpus > 0 is ideal as it's
> a relatively common pattern in KVM, and provides a clear boundary to userpace
> regarding what is/isn't allowed.

Yes, I agree that would be better in general.  For (pseudo) registers,
I would think preventing modification if kvm->created_vcpus > 0 might
not be a very good option for KVM/ARM though considering usage of
KVM_GET_REG_LIST and KVM_{G,S}ET_ONE_REG.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
