Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BE0C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:49:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6174F61100
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6174F61100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D62BB4B160;
	Thu,  9 Sep 2021 12:49:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K9PPQiENCiB2; Thu,  9 Sep 2021 12:49:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7B2C4B15E;
	Thu,  9 Sep 2021 12:49:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 512424B0E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:49:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 06dM4sFjwj9i for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 12:49:11 -0400 (EDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com
 [209.85.219.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 221BF4A534
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:49:11 -0400 (EDT)
Received: by mail-yb1-f172.google.com with SMTP id v10so5166380ybq.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 09:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=s+RgoVMQufwJ1iQH8D3qsEs6NeJAccH1we8wbejIgaA=;
 b=cKYHvkvuT7X76SxD/wV7YqPOMI1NJnCntmtpLCPUNYxyJ9kJmg1gz9JmPF8j6aZWCp
 HkUfLN6kOAf5LDuVEu+pXws7bQINvVC+T+LEEAor5KfA35yFRFVrURB3lc2+sX6+x8GM
 PzsCJaynqKz2jVTUHEL0fGsZpjHslFS5xMQwWj93foGhmNCnNL6CCsOiBH8anvLtHz0n
 yLWSMLlZi5dJczkFF96IfwEUwqoGsDFhBEfhAkmfrxcGIuKY48mSwUmU5GT/8Nob6l5I
 bZNfoDgt9wxtcx2nSN/Z0cTmkA7ttTgOGC2d2uM3N1eo3Mwa//VA8lA6J54Xcww3kP3h
 HU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=s+RgoVMQufwJ1iQH8D3qsEs6NeJAccH1we8wbejIgaA=;
 b=Rzrm0Yx2IRfGZKKkYzfNzUA/DzFPp0WU3sW9Iqfx8B4a+CRmc57fSBtFZDdCPlfQFO
 exOe3GKDzD2aOHTxdGgJykbLhog56uofnew9mw+7aCo98duFawqhxW0SxQCpYj1jxU7b
 r66egnpEinpOFH81czq9WlCciAwVPl0e+vkusHXffBSEkp3R7vkRXQX5Co2W4QAqOMsK
 +FeFhHQM8kRs/rl9Zf7I7rS0c3tty/uwYFYtT9hjKMXqOrkUGKC1lFel96bOzEHeVfVq
 Q20sM9/k29MiceAGjDbPWrMMeOTL/91G4a82/dMT6rHEOXuyOiwIKWYHmcdMfAZYHjoA
 BsXA==
X-Gm-Message-State: AOAM531rgFgLTLE6mrGmSA/UCWvneHlLmnVTF0H6NQNCPUB6QKIuGUbi
 2LuGcwueNIZDAkrC4HPRzupQQK19JAEhaTzq2nZC+Q==
X-Google-Smtp-Source: ABdhPJwYzxkIizwJV6evp1HhsQhKyxmT4fexYZ5FumlIdEfFU+MXdO/TKphQSop5An7mY+3rnXaNQ/1679+nvib75Zc=
X-Received: by 2002:a25:c504:: with SMTP id v4mr4742567ybe.308.1631206150502; 
 Thu, 09 Sep 2021 09:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-5-rananta@google.com>
 <YTl5RQjJ0EFmhUlG@google.com>
In-Reply-To: <YTl5RQjJ0EFmhUlG@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 09:48:58 -0700
Message-ID: <CAJHc60zkJ472fW7iAqMoW7JKLzXYwfYdZcAvRyYrxY-V04bTmQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/18] KVM: arm64: selftests: Introduce
 ARM64_SYS_KVM_REG
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 8, 2021 at 8:02 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Raghu,
>
> On Thu, Sep 09, 2021 at 01:38:04AM +0000, Raghavendra Rao Ananta wrote:
> > With the inclusion of sysreg.h, that brings in system register
> > encodings, it would be redundant to re-define register encodings
> > again in processor.h to use it with ARM64_SYS_REG for the KVM
> > functions such as set_reg() or get_reg(). Hence, add helper macro,
> > ARM64_SYS_KVM_REG, that converts SYS_* definitions in sysreg.h
> > into ARM64_SYS_REG definitions.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h      | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index bed4ffa70905..ac8b63f8aab7 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -26,6 +26,20 @@
> >
> >  #define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
> >
> > +/*
> > + * ARM64_SYS_KVM_REG(sys_reg_id): Helper macro to convert
> > + * SYS_* register definitions in sysreg.h to use in KVM
> > + * calls such as get_reg() and set_reg().
> > + */
> > +#define ARM64_SYS_KVM_REG(sys_reg_id)                        \
>
> nit: KVM_ARM64_SYS_REG() perhaps? Dunno which is more readable.
>
> > +({                                                   \
> > +     ARM64_SYS_REG(sys_reg_Op0(sys_reg_id),          \
> > +                     sys_reg_Op1(sys_reg_id),        \
> > +                     sys_reg_CRn(sys_reg_id),        \
> > +                     sys_reg_CRm(sys_reg_id),        \
> > +                     sys_reg_Op2(sys_reg_id));       \
> > +})
> > +
>
Heh, I came up with the logic faster than picking a name for the
macro. I guess KVM_ARM64_SYS_REG may be more readable, just for the
fact that it begins with KVM_. I'll change it.

Regards,
Raghavendra
> Could you also switch all current users of ARM64_SYS_REG() in the KVM
> selftests directory in this commit? You can also drop the system
> register encodings defined in processor.h
>
I did that in a separate patch, but I can squash it here to avoid confusion.

Regards,
Raghavendra
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
