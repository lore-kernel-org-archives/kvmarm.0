Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA58C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 17:12:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71B4D4B26A;
	Mon, 25 Apr 2022 13:12:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KtRbaN0I2bI0; Mon, 25 Apr 2022 13:12:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 664B34B287;
	Mon, 25 Apr 2022 13:12:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEF504B241
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 13:12:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fpRTHrZpx-s0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 13:12:45 -0400 (EDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com
 [209.85.208.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEA9A4B298
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 13:12:44 -0400 (EDT)
Received: by mail-lj1-f169.google.com with SMTP id bn33so18659650ljb.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 10:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=N7fee2Yrx0qNzoi9PdXZ5hx4nrnlVdrW/GV2fmMxG2M=;
 b=acRadtvAlYLUZrCmq9O5iI5dPYliXwwNI96yUgxN2vvYnQyHFYWbIq3YSk6wxSOnDA
 GX9RTiQdnHyQtA4OQ7FAx/eRuBe2F7nW7K20QiBw/g4p0zT/aDNIb6GoMhyOYCqluUsp
 w966oKCZq/KG44LRlyljtZupZ4wx32aOVe7+Hy5Wp+N7xnx+tccplGXtnJVAGCdgqJyB
 1sBDmWynVnSD+y20tg/j5uLrhve94nndrnKPQyKku8wVj2d2fT/EX/EyAnZIXYqJGaZp
 x6AKN+qlvspopkwCnb+v9+yZhH/oDM5Srj9sWSLPXfpmXjBom7/BSqtbI/xONPkGOToT
 8cJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=N7fee2Yrx0qNzoi9PdXZ5hx4nrnlVdrW/GV2fmMxG2M=;
 b=QGy2f4J2Es8Ty5L+hDg/IUr2x0hj9QmVuDZReYgTWjI/dxDGK97ZS0VRP/O5LT41uB
 QuE77m0HIHHCT6GL+V7+MeyN1cvhc7DItv7sOWUNvfz5kb9s8J3mJfxihXGCH9BZ2S84
 jwf/RrqifjsdAmh+Epdhq7b01FptlHPDDSL2466U+6ZhCZPPOplpTTQg47HOnhhQZbFt
 bCmK0jTlf95mAtbjHIokr4uzU/NaMTlIWnLzpLj/fAGOXhYIjUJ6OnqGnZy2D801KW0M
 MAM7F1ggQeI4ft9QZRRdYEiPkRBBFYtW+OIoXlNCWIet6lLYfLTRhIM5bDmaS5Z07Uz4
 WPxA==
X-Gm-Message-State: AOAM53096UiHjEcpJJ2Uc5OWU/g3sRXvmxi40OmoeuA/jK0mgUo/8HG7
 ajTDX8AGJAbVKlUa+kzI/KrZfWQu6Fv11Rh3tDwHiQ==
X-Google-Smtp-Source: ABdhPJxUrJi15zmGDPYrRdXhEhm6WWYpITF+DKeRbw52izZPXspEXizuIrsiftQCpGs1t6FoJos6DDldjOwxUQ8ZRFY=
X-Received: by 2002:a2e:5c6:0:b0:24f:5bd:5f89 with SMTP id
 189-20020a2e05c6000000b0024f05bd5f89mr7433707ljf.170.1650906763210; 
 Mon, 25 Apr 2022 10:12:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-5-rananta@google.com>
 <CAAeT=Fyc3=uoOdeXrLKfYxKtL3PFV0U_Bwj_g+bca_Em63wGhw@mail.gmail.com>
 <CAJHc60zR4Pa=y-Y4Dp27FoAvqpBrONCN727KbnhSoxNGRiBGuA@mail.gmail.com>
In-Reply-To: <CAJHc60zR4Pa=y-Y4Dp27FoAvqpBrONCN727KbnhSoxNGRiBGuA@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Mon, 25 Apr 2022 10:12:32 -0700
Message-ID: <CAOQ_QsjFtyy1AFq5c-jLSY-r9fWEL4H5fuKNbt9QcFirnU2wmg@mail.gmail.com>
Subject: Re: [PATCH v6 4/9] KVM: arm64: Add vendor hypervisor firmware register
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, Apr 25, 2022 at 9:52 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:

[...]

> > > +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX    1
> >
> > Nit: IMHO perhaps it might be more convenient to define the MAX macro
> > in arch/arm64/include/uapi/asm/kvm.h like below for maintenance ?
> > (The same comments are applied to other KVM_REG_ARM_*_BMAP_BIT_MAX)
> >
> > #define KVM_REG_ARM_VENDOR_HYP_BIT_MAX KVM_REG_ARM_VENDOR_HYP_BIT_PTP
> >
> We have been going back and forth on this :)
> It made sense for me to keep it in uapi as well, but I took Oliver's
> suggestion of keeping it outside of uapi since this is something that
> could be constantly changing [1].

The maximum set of features in a given bitmap register is a property
of the running system, not the headers chosen at compile time. There
is an illusion of ABI breakage when adding new bits to the registers
if we've declared the max bit in UAPI. We also define
KVM_VCPU_MAX_FEATURES outside of UAPI, even though it is related to
the KVM_ARM_VCPU_INIT ioctl.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
