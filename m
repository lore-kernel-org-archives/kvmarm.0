Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5519C432BE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 12:31:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D543610CD
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 12:31:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1D543610CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC1F4B127;
	Thu,  2 Sep 2021 08:31:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NUlgr7zfsJ4S; Thu,  2 Sep 2021 08:31:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B68D94B12F;
	Thu,  2 Sep 2021 08:31:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BA604B104
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 08:31:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nnp4E4Okt5oK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 08:31:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C9BD4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 08:31:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630585874;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1bF0+pdPFV1oPqtHYhh2gb/KkOQLq0K7gX0PwtmmkGA=;
 b=iGKkNJW1LysqKv0d01S2ie3jo4e9FI+rss9lrkG2wV89kYI980/O8mT5cA+O2iENiSPPTe
 T+UHSjfzbEKMh5TBoC1JuxS9paSTV/JVfYT/fWH6rTYw3bAb35j3y2wNX6XTFOQBvKI+AP
 JhsYP6gONzunUMONih4YkEeqYXKCzBI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-bTTyG6dTPriZgsHVKe4Xbw-1; Thu, 02 Sep 2021 08:31:13 -0400
X-MC-Unique: bTTyG6dTPriZgsHVKe4Xbw-1
Received: by mail-wr1-f70.google.com with SMTP id
 p10-20020a5d68ca000000b001552bf8b9daso475571wrw.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 05:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1bF0+pdPFV1oPqtHYhh2gb/KkOQLq0K7gX0PwtmmkGA=;
 b=KObcBPZFe+Zp0++wwlfcKU+jZFpuQ6ZMlaKtjqdVL6CM4MG6ZK9XcsbfM3EFnnQDeb
 zj43FbFWxuYYIuRhJkQkLhHQY8NxW1fofLXfAwosmvV1+3KG8XGaJO1+dj1fx2EyrAx5
 JxbO+7m5qeCFdx3zom+4W+Ng4aPhMarr2OlyvIcwvVFyVI+cPjrBLpcvyJdWv5pLUuQX
 6eP/dMGAzKi+DmqgjvtWtmFTeWLz82W25nC2IrdptAlfb8ySll0RimCDKaqKzt2aOVHt
 GZR1/KeCMh/4e5Ykms/e58/7oya/LxmN77BNO4FwPCSw0MvNfJdlyHPQgZC5WagD935z
 dQ0A==
X-Gm-Message-State: AOAM533XnolQcNbH9kjHQMztjH0/O3ZmXlykY5b+YubJVtGXFoJD7UaL
 5tADu8S6Sgfc3wP+vzJLqZ0BrXIj56kvlJfPXTW3FvN00zPhAO0dz1efNI5bzoJFp4elOibRmer
 hbRBg8m3qPnhdPV1SHiC1kg4U
X-Received: by 2002:a5d:6cc9:: with SMTP id c9mr3459273wrc.12.1630585872057;
 Thu, 02 Sep 2021 05:31:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzw9OYDFsRzxtUxt8WzFVuzQqX9uKEjP7AudR21ZtDRAs5a3V/WpA+nMGwkaPm1bwnde7r7Lg==
X-Received: by 2002:a5d:6cc9:: with SMTP id c9mr3459246wrc.12.1630585871881;
 Thu, 02 Sep 2021 05:31:11 -0700 (PDT)
Received: from gator (nat-pool-brq-t.redhat.com. [213.175.37.10])
 by smtp.gmail.com with ESMTPSA id x21sm1539270wmi.15.2021.09.02.05.31.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 05:31:11 -0700 (PDT)
Date: Thu, 2 Sep 2021 14:31:10 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <20210902123110.royrzw4dsykkrcjx@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
 <YS/wfBTnCJWn05Kn@google.com> <YS/53N7LdJOgdzNu@google.com>
 <CAJHc60xU3XvmkBHoB8ihyjy6k4RJ9dhqt31ytHDGjd5xsaJjFA@mail.gmail.com>
 <YTAHYrQslkY12715@google.com>
MIME-Version: 1.0
In-Reply-To: <YTAHYrQslkY12715@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Sep 01, 2021 at 11:06:10PM +0000, Oliver Upton wrote:
> On Wed, Sep 01, 2021 at 03:48:40PM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Sep 1, 2021 at 3:08 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > On Wed, Sep 01, 2021 at 09:28:28PM +0000, Oliver Upton wrote:
> > > > On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> > > > > For register names that are unsupported by the assembler or the ones
> > > > > without architectural names, add the macros write_sysreg_s and
> > > > > read_sysreg_s to support them.
> > > > >
> > > > > The functionality is derived from kvm-unit-tests and kernel's
> > > > > arch/arm64/include/asm/sysreg.h.
> > > > >
> > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > >
> > > > Would it be possible to just include <asm/sysreg.h>? See
> > > > tools/arch/arm64/include/asm/sysreg.h
> > >
> > > Geez, sorry for the noise. I mistakenly searched from the root of my
> > > repository, not the tools/ directory.
> > >
> > No worries :)
> > 
> > > In any case, you could perhaps just drop the kernel header there just to
> > > use the exact same source for kernel and selftest.
> > >
> > You mean just copy/paste the entire header? There's a lot of stuff in
> > there which we
> > don't need it (yet).
> 
> Right. It's mostly register definitions, which I don't think is too high
> of an overhead. Don't know where others stand, but I would prefer a
> header that is equivalent between kernel & selftests over a concise
> header.
>

Until now we haven't needed the sys_reg(...) type of definitions for
sysregs in selftests. In case we did, we defined the registers we
needed for get/set_one_reg by their parts, e.g.

 #define ID_AA64DFR0_EL1 3, 0,  0, 5, 0

allowing us to choose how we use them, ARM64_SYS_REG(...) vs.
sys_reg(...).

Bringing over sysreg.h is probably a good idea though. If we do, then
I'd suggest we define a new macro that allows us to convert a SYS_*
register definition from sysreg.h into an ARM64_SYS_REG definition
for get/set_one_reg in order to avoid redundant definitions.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
