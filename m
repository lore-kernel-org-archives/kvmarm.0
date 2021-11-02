Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED97C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 14:54:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4A3EB60F02
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 14:54:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4A3EB60F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B03C84B0BA;
	Tue,  2 Nov 2021 10:54:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PYmsTzWpFQ7f; Tue,  2 Nov 2021 10:54:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F5694A5A0;
	Tue,  2 Nov 2021 10:54:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0309A4A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 10:54:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WUdBboImj7Kl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 10:54:10 -0400 (EDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com
 [209.85.208.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C11814A193
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 10:54:09 -0400 (EDT)
Received: by mail-lj1-f173.google.com with SMTP id t11so16988358ljh.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 07:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=tnGWO6De14brnYGPNkilMKJ5C7ikF6fltBLGDbtm+4I=;
 b=n1oUGDjaHoDg098yqn+LHnoPMS4aHLuNVa5s6QfWlXEkLVxSnQXuM+v5Hyu0hZ3Ni5
 OcnkPtRyYM4yHdSOysGEgIXfIeLHDR+LcTU7igKkfQKB2/3ddfz7o71ca5LerXkT7mTl
 ahaRXfWLUm0LoGtiSGpyJZMISzzmHF2son9Ay7L/xHkSfZJ+cESQMXdcJ5rOVuR/G1TF
 kTlnyqkYXOn1G3XiBF8PZMbo02rXf1M91TH534by95sMcgrFUK7A0gYDNGb0EfuFWI5A
 1kRb1lv4E8O0nVPa1P5cyOVqJQ12+rk4bPsMcu6jNhrSZTfa9EXF2so/KNVyqKpAjAIA
 u+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tnGWO6De14brnYGPNkilMKJ5C7ikF6fltBLGDbtm+4I=;
 b=nwvz3QjGW8AKO2eST/4BgGrI/6nLwVixLYCXWD/LX86gkuodJjIPX7wy/ZiksawYXw
 5sfPi1uYG/tRO2AouIiLxM7LueZQLBU9ULufUye4Koj6q57fuhAwc+/mteei5DctrdK9
 6fKBveMGctFhiItssc23tgvWA1pzHLdBXtxwmQ8BBKDWAkdwNk1wXB0Ol6XucChYYE3t
 4WZHQ4DZxq41I8CN8CXAwkl6eQ7SJ/bUlqdrBXGKbZn3keXpcHf0YrMCrJstMhJUVBX+
 PA4WgghB4jgZ1aJJo1gSiANQHjc6LwtnTBdUs4a6RPSLajZ6rxk/4oV3Mf81KgF8Ygpv
 L3rQ==
X-Gm-Message-State: AOAM532UpHpxh0dU3tG6AtF1TfFT9olQ+ORhwis+PkZvua0EFJmoSHmE
 ioRVvqerTPNwyM5A4aBtA45wCzGNTFblBf+uNbxC3A==
X-Google-Smtp-Source: ABdhPJxe3szcKlyys/NryzWwNDy9H79VGLc5m1/8ywBPPJ4/fdMKnezEBfFJQkuhbNkEahaMF5HZcIhSnGRq+r5T80E=
X-Received: by 2002:a05:651c:2cf:: with SMTP id
 f15mr12460790ljo.170.1635864848055; 
 Tue, 02 Nov 2021 07:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-7-oupton@google.com>
 <875ytaak5q.wl-maz@kernel.org>
In-Reply-To: <875ytaak5q.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Tue, 2 Nov 2021 07:53:57 -0700
Message-ID: <CAOQ_Qsgc7aA89OMBZTqYykbdKLypBhra0FNQZRPTEHpcaaqyhw@mail.gmail.com>
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

Hey Marc,

On Tue, Nov 2, 2021 at 4:09 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Tue, 02 Nov 2021 09:46:51 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > KVM now correctly handles the OS Lock for its guests. When set, KVM
> > blocks all debug exceptions originating from the guest. Add test cases
> > to the debug-exceptions test to assert that software breakpoint,
> > hardware breakpoint, watchpoint, and single-step exceptions are in fact
> > blocked.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++++++-
> >  1 file changed, 56 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index e5e6c92b60da..6b6ff81cdd23 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -23,7 +23,7 @@
> >  #define SPSR_D               (1 << 9)
> >  #define SPSR_SS              (1 << 21)
> >
> > -extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
> > +extern unsigned char sw_bp, hw_bp, hw_bp2, bp_svc, bp_brk, hw_wp, ss_start;
> >  static volatile uint64_t sw_bp_addr, hw_bp_addr;
> >  static volatile uint64_t wp_addr, wp_data_addr;
> >  static volatile uint64_t svc_addr;
> > @@ -47,6 +47,14 @@ static void reset_debug_state(void)
> >       isb();
> >  }
> >
> > +static void enable_os_lock(void)
> > +{
> > +     write_sysreg(oslar_el1, 1);
> > +     isb();
> > +
> > +     GUEST_ASSERT(read_sysreg(oslsr_el1) & 2);
> > +}
> > +
> >  static void install_wp(uint64_t addr)
> >  {
> >       uint32_t wcr;
> > @@ -99,6 +107,7 @@ static void guest_code(void)
> >       GUEST_SYNC(0);
> >
> >       /* Software-breakpoint */
> > +     reset_debug_state();
> >       asm volatile("sw_bp: brk #0");
> >       GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
> >
> > @@ -152,6 +161,51 @@ static void guest_code(void)
> >       GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
> >       GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
> >
> > +     GUEST_SYNC(6);
> > +
> > +     /* OS Lock blocking software-breakpoint */
> > +     reset_debug_state();
> > +     enable_os_lock();
> > +     sw_bp_addr = 0;
> > +     asm volatile("brk #0");
> > +     GUEST_ASSERT_EQ(sw_bp_addr, 0);
>
> I haven't had a change to properly review the series, but this one
> definitely caught my eye. My expectations are that BRK is *not*
> affected by the OS Lock. The ARMv8 ARM goes as far as saying:
>
> <quote>
> Breakpoint Instruction exceptions are enabled regardless of the state
> of the OS Lock and the OS Double Lock.
> </quote>
>
> as well as:
>
> <quote>
> There is no enable control for Breakpoint Instruction exceptions. They
> are always enabled, and cannot be masked.
> </quote>

/facepalm I had thought I read "Breakpoint Instruction exceptions" in
the list on D2.5 "The effect of powerdown on debug exceptions",
although on second read I most definitely did not. And if I had read
the bottom of the section, I'd of seen one of the quotes.

> I wonder how your test succeeds, though.

Probably because the expectations I wrote match the non-architected
behavior I implemented :-)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
