Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D18ECAAA2
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 00:51:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27C244E394;
	Thu, 25 Aug 2022 20:51:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pRwXd6XWeymn; Thu, 25 Aug 2022 20:51:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 041AF4E38C;
	Thu, 25 Aug 2022 20:51:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12A9C4E388
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 20:51:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HjZ-Fkk4hQMG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 20:51:05 -0400 (EDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com
 [209.85.217.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED4CA4E38E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 20:51:04 -0400 (EDT)
Received: by mail-vs1-f43.google.com with SMTP id h67so268273vsc.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 17:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=0JrpajtekJvh71Rso/3aI0o/Auj8HCuqh9lk53mDmoI=;
 b=entdwi6GP0iJd2AnCMO31AfWW8zOCmhAS9at2OdNy6E92caHUoaGQEKydCUbCoIoxg
 VN8DdyPa3fJ9cQjlyP2409JiQZMLSHkb+vM4xQPNFItu/TO3tt1+apfdL1po2fwkT0W0
 GRg1Xzt4AY8pxjquXh4caIjjTdFpwMWGk688lRpI3bi7tCV7OpeSzysZQJFx7tjHni7C
 HGHW8vXzi6SSvBDNiAUcThQ/PpHRqZWerF/4uxfUJ4gixuTyi3zoJTicZ28c/rp1WYp7
 r5RIRgvrdd0EB/AFhGlvD2G3odBSIebVpAgZX2FluJOoJBdHn1R1UQI8pUk35ycqiy2Q
 JrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=0JrpajtekJvh71Rso/3aI0o/Auj8HCuqh9lk53mDmoI=;
 b=Ft7Lm18oggQt3vcpiMpQlW63oq08nDS8KWgTBWQOlExdmyOf9WzqOF1No4pMywlfRw
 vp2E4SynQH4+c9q/vIAAixpH1FwD7S2K/u6go2v3Bq5962MN9VWfrrBoduwPbUUQ9RJH
 kek9uweqtPwDxjJYjrbnMoiWI3VPicuVBTFwRu/W00kdl+DPhcBAobOZpaSo65LULcmB
 /R+nS1l6qes3gI5KTbskmMxZT5xIMWZxCGuDXv69MYDbcI//BD9h/1gFLf1H4OZ4WfOn
 Yev03iF5J0RG3WyL3Rw0yF3h3QO+BwDrUOj4Eobs0hIpBozWxh4MfJighPfBD5WfINhJ
 JfAA==
X-Gm-Message-State: ACgBeo3+NZ1dtYYv8YwCwImC2VUoZCj5jXoZMMbq5y3mnD24I0mt7rQD
 QaYQOnSIp2s3YMX/3/AvUwNegq70cBXWAFEICRSpsQ==
X-Google-Smtp-Source: AA6agR7p7Dit2ezx7YKW+encSK4TFrVerFoY/6em0zK1bdoztUQVx0haLRefCWKzReFCSOzdWGd2pyDhRpM+ThjkMxU=
X-Received: by 2002:a67:b009:0:b0:38a:e0f2:4108 with SMTP id
 z9-20020a67b009000000b0038ae0f24108mr2723225vse.9.1661475064402; Thu, 25 Aug
 2022 17:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-2-reijiw@google.com>
 <Ywen44OKe8gGcOcW@google.com> <Yweo5cmA6D0pxwmJ@google.com>
 <YweqIefFbP107fe+@google.com>
In-Reply-To: <YweqIefFbP107fe+@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 25 Aug 2022 17:50:48 -0700
Message-ID: <CAAeT=Fxza9hdqDNDDeHqXKwLW_K2aj-3E7Z5FL9eXH0Wpa3YcA@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: selftests: Add helpers to extract a field
 of an ID register
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Oliver, Ricardo,

On Thu, Aug 25, 2022 at 9:58 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Thu, Aug 25, 2022 at 09:52:53AM -0700, Ricardo Koller wrote:
> > On Thu, Aug 25, 2022 at 09:48:35AM -0700, Oliver Upton wrote:
> > > Hi Reiji,
> > >
> > > On Wed, Aug 24, 2022 at 10:08:38PM -0700, Reiji Watanabe wrote:
> > > > Introduce helpers to extract a field of an ID register.
> > > > Subsequent patches will use those helpers.
> > > >
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > ---
> > > >  .../selftests/kvm/include/aarch64/processor.h     |  2 ++
> > > >  .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++++++++++
> > > >  2 files changed, 17 insertions(+)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > index a8124f9dd68a..a9b4b4e0e592 100644
> > > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > > @@ -193,4 +193,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> > > >
> > > >  uint32_t guest_get_vcpuid(void);
> > > >
> > > > +int cpuid_get_sfield(uint64_t val, int field_shift);
> > > > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift);
> > > >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > > > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > > index 6f5551368944..0b2ad46e7ff5 100644
> > > > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > > > @@ -528,3 +528,18 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> > > >                  [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> > > >                : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> > > >  }
> > > > +
> > > > +/* Helpers to get a signed/unsigned feature field from ID register value */
> > > > +int cpuid_get_sfield(uint64_t val, int field_shift)
> > > > +{
> > > > + int width = 4;
> > > > +
> > > > + return (int64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > > > +}
> > >
> > > I don't believe this helper is ever used.

I thought I was going to use this in the selftest for my ID register series.
(So, I originally would like to have similar helpers in cpufeture.h)
But, you are right. That test only extracts unsigned fields...

> > >
> > > > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift)
> > > > +{
> > > > + int width = 4;
> > > > +
> > > > + return (uint64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > > > +}
> > >
> > > I would recommend not open-coding this and instead make use of
> > > ARM64_FEATURE_MASK(). You could pull in linux/bitfield.h to tools, or do
> > > something like this:
> > >
> > >   #define ARM64_FEATURE_GET(ftr, val)                                       \
> > >               ((ARM64_FEATURE_MASK(ftr) & val) >> ftr##_SHIFT)
> > >
> > > Slight preference for FIELD_{GET,SET}() as it matches the field
> > > extraction in the kernel as well.
> >
> > Was doing that with this commit:
> >
> >       [PATCH v5 05/13] tools: Copy bitfield.h from the kernel sources
> >
> > Maybe you could just use it given that it's already reviewed.
>
> Oops, thanks for the reminder Ricardo! Yeah, let's go that route then.

Thank you for the information. I will use that instead.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
