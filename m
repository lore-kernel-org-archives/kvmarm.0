Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA95C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 21 Oct 2022 03:09:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FFA04BA20;
	Thu, 20 Oct 2022 23:09:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kgOAz4VRFMBD; Thu, 20 Oct 2022 23:09:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E464BA13;
	Thu, 20 Oct 2022 23:09:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDFFC4BA0F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 23:08:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N-c6qFISfdsA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 23:08:57 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C65FC4BA0D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 23:08:57 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id y1so1371980pfr.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 20:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=STonhZa8jZ6LYPO+oZNXkj44XREGON6Gf/DGBneiwkI=;
 b=mLeHnZKp8upCwFqULQ0WMsqVOAbfbjOQeLJ/nW2iaAyeinSRhh8HAdhBVMc2hZC2MX
 mQDwpF7KgDOJy6VPpLQkBrQG4qjXwF9j09ULkxTWNjgtmtNtm7XgkCAvblMM0jjlCkfg
 b19oD36OcL6UjnuNhEke5dCLUexEqGVYYgCuZK0dh5Daun1nBAjzGzoGqIqqB93ReHNE
 GVV+TM99H1zUChwBizTwqff/WWEWhdTIe7Wm9dr7DdVbHdlRScsplxOlxDnO9VMhf9um
 WwuXBLxA5P3k0oKgXjQvQk9mlirHU/Qooc7HjJyACOBCf/wI4FKUVviHhuFlsthGYri1
 E/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=STonhZa8jZ6LYPO+oZNXkj44XREGON6Gf/DGBneiwkI=;
 b=wHRAyiPjzX1H8UNmtyAGX+3j08WdGxGpUhioYsA7UDQ+ctMTd4t6a92t1RXE8/UOE8
 a2tT5IPIT/AJsi6NN4f918mOT7FWL+SzdQeglceJUDPTjiLxwPxPCx78k/O7hrNlJMS4
 RtuuPlHqV0Yb2zu14gdqN28Hg2wuaSpXft3tJLGq6K+KrjAWCaHPef6mChlMpzF1BK9G
 fVRFL0aj8C2o9gkxwDAUu3NPZW9dFVBtwYSOJ4zAr2xPHixNhi4SOBVI4EWdodSLD4rV
 Ra3zUNpAItHETZiFbzk+GD+l/YQObeqvNM9XZQWLwb+2WvN7f3Munrf5V7ZB+O9JGeXZ
 jHLg==
X-Gm-Message-State: ACrzQf1/cARxVrcdEUbFZ6Drl55+MaLeJ8M3IN/vaDdJuo5iz48m4+2e
 V2SQthKBXYo6etTPNZ5RuNz8S60roNXlr55XD41eag==
X-Google-Smtp-Source: AMsMyM6UAgYi+jIUzbgjfQW+SHmEryO+206C9MR8xI73umNRvQecApqvBt9nb0UdbJXU+6CAYcSM5JP4dIs3jf7w0TE=
X-Received: by 2002:a63:db58:0:b0:443:575e:d1ed with SMTP id
 x24-20020a63db58000000b00443575ed1edmr14173692pgi.468.1666321736503; Thu, 20
 Oct 2022 20:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
 <20221020054202.2119018-2-reijiw@google.com>
 <Y1GckDU/gCNQ6tAS@google.com>
In-Reply-To: <Y1GckDU/gCNQ6tAS@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 20 Oct 2022 20:08:39 -0700
Message-ID: <CAAeT=FyOEGQE3pZtz4eft8N9vaD3ESEQ3i0R5X4OZb+5isSBAg@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] KVM: arm64: selftests: Use FIELD_GET() to extract
 ID register fields
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
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

Hi Oliver,

On Thu, Oct 20, 2022 at 12:08 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Wed, Oct 19, 2022 at 10:41:54PM -0700, Reiji Watanabe wrote:
> > Use FIELD_GET() macro to extract ID register fields for existing
> > aarch64 selftests code. No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c  | 3 ++-
> >  tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 3 ++-
> >  tools/testing/selftests/kvm/lib/aarch64/processor.c    | 7 ++++---
> >  3 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> > index 6f9c1f19c7f6..b6a5e8861b35 100644
> > --- a/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> > +++ b/tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
> > @@ -13,6 +13,7 @@
> >  #include "kvm_util.h"
> >  #include "processor.h"
> >  #include "test_util.h"
> > +#include <linux/bitfield.h>
> >
> >  #define BAD_ID_REG_VAL       0x1badc0deul
> >
> > @@ -145,7 +146,7 @@ static bool vcpu_aarch64_only(struct kvm_vcpu *vcpu)
> >
> >       vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> >
> > -     el0 = (val & ARM64_FEATURE_MASK(ID_AA64PFR0_EL0)) >> ID_AA64PFR0_EL0_SHIFT;
> > +     el0 = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0), val);
> >       return el0 == ID_AA64PFR0_ELx_64BIT_ONLY;
> >  }
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 947bd201435c..3808d3d75055 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -2,6 +2,7 @@
> >  #include <test_util.h>
> >  #include <kvm_util.h>
> >  #include <processor.h>
> > +#include <linux/bitfield.h>
> >
> >  #define MDSCR_KDE    (1 << 13)
> >  #define MDSCR_MDE    (1 << 15)
> > @@ -284,7 +285,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
> >       uint64_t id_aa64dfr0;
> >
> >       vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &id_aa64dfr0);
> > -     return id_aa64dfr0 & 0xf;
> > +     return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
> >  }
> >
> >  static void test_guest_debug_exceptions(void)
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 6f5551368944..7c96b931edd5 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -11,6 +11,7 @@
> >  #include "guest_modes.h"
> >  #include "kvm_util.h"
> >  #include "processor.h"
> > +#include <linux/bitfield.h>
> >
> >  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN  0xac0000
> >
> > @@ -486,9 +487,9 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
> >       err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
> >       TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
> >
> > -     *ps4k = ((val >> 28) & 0xf) != 0xf;
> > -     *ps64k = ((val >> 24) & 0xf) == 0;
> > -     *ps16k = ((val >> 20) & 0xf) != 0;
> > +     *ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4), val) != 0xf;
> > +     *ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64), val) == 0;
> > +     *ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16), val) != 0;
>
> Not your code, but since we're here...
>
> Should we change the field values to use the #define's? Also, the test

I agree that would be better.

> for TGRAN64 looks wrong. We should test != ID_AA64MMFR0_TGRAN64_NI. A
> value greater than 0 would indicate an extension of the feature.

Yes, I thought about that, too.

I assumed the intention of the code was only 0x0 is defined as
64KB granule supported as of today unlike for other granule sizes,
which has more than one value that indicates the granule support.
But, considering principles of the ID scheme for fields in ID registers,
I think ">= ID_AA64MMFR0_TGRAN{4,16,64}_SUPPORTED_MIN" would be more
appropriate way of doing those check, although then TGRAN4 and TGRAN64
fields should be handled as signed fields (or we could do
"<= ID_AA64MMFR0_TGRAN{4,16,64}_SUPPORTED_MAX").

I can fix those if I have a chance to work on v3.

> But for this exact change:
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thank you for the review!

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
