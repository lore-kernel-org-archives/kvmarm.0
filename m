Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65122C4320A
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 21:30:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1101C60E97
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 21:30:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1101C60E97
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C5C4B0F7;
	Mon, 16 Aug 2021 17:30:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J1gGfwF8ocja; Mon, 16 Aug 2021 17:30:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49EB04B116;
	Mon, 16 Aug 2021 17:30:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7BAD4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 16:56:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IfGW7fcMYo6p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Aug 2021 16:56:28 -0400 (EDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com
 [209.85.221.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C62094B0B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 16:56:28 -0400 (EDT)
Received: by mail-vk1-f174.google.com with SMTP id d30so4625539vkl.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Aug 2021 13:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PAjqAgz4SbwhR4C2g99BnpgC4FJpr+PKslvtcBCtV7g=;
 b=Z0LdAVsVOA5UHNfiWH6pgQcaDfOI9yO7Prph0FcJkli65iCPGkn28i57u0iz4+rr/k
 7vexRoGXmoPITr+5iwD1J66G3TX2bPkT/CXwyeVpXNo7GjzQ7AhRHto17gppMPSKbsWK
 RuJRGjnJZUEvu08KT6euDd9I6tm7GraORU6AK3mdU3PHuwzqhr90lo9viERzvg1NotTN
 SQEOnKw/W7fs/3/6pADSnP1TY1XrkH/jkzfAZhWNNJ5qAQpDVTkOjbT7l7Uy0t3/vrRN
 MMadQi9Wh82FRxI2kmi5Jl9OwXaKDExXlsgp1jDNN4pukiE+JblEQPerb0tNc5/nkAmI
 uLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PAjqAgz4SbwhR4C2g99BnpgC4FJpr+PKslvtcBCtV7g=;
 b=RUHuFXwW7mqZfjeGLT9mbNbIex+Kv0NzVLNgTpd/FD5uWg11bUgWp8xvsNN9djAcos
 XL87I4fHfmoeRUCHHHd1sXeZOKvosY2DTjzqdc//elUSheyGFfRoiS64pkh71PCJ8zrA
 MNOvS+up4bKpYCAojDTLNVQAABUGteT0KJ5mHhvwOMxMjNr5cWuhuSQJ1ySGIQJiA50w
 yI1n6dsTYhC+7ait3GHxUZQyDMyBBlUCLOUhccd/h+UKHthvvNUVK9vXbJlmb0xCF2Xz
 X8KdZHZvWhZKAohiCDc2rZS4y+5KmxoEE2Z0iEU+RXV8rjUQpgrGcXyIVayn1fUGbZ1h
 B8DA==
X-Gm-Message-State: AOAM531bZG/hc3/ZOBVxIThXr741ywywP20ZGNy9+KrRMeWlAPCibPSG
 pMAZFBdLJyfYiagU8ixoYuxgVs6auCgRor25geTeyg==
X-Google-Smtp-Source: ABdhPJwFYs1vFOV9d+q8kCyHbjok7b0AZnXTp2WBYai2NMcFXOwpP6G4PDTDMv1OQqhNCSOcya9L68gfllHl5OFFeZI=
X-Received: by 2002:a1f:bfc4:: with SMTP id p187mr407300vkf.17.1629147388071; 
 Mon, 16 Aug 2021 13:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
 <20210816121548.y5w624yhrql2trzt@gator.home>
In-Reply-To: <20210816121548.y5w624yhrql2trzt@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 16 Aug 2021 13:56:17 -0700
Message-ID: <CAJHc60yqNcpmDCmSehVb6uDeu+FF--aPhwJ9ZBTAcJCPBVR=1Q@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: arm64: selftests: Introduce arch_timer selftest
To: Andrew Jones <drjones@redhat.com>
X-Mailman-Approved-At: Mon, 16 Aug 2021 17:30:36 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Mon, Aug 16, 2021 at 5:15 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 13, 2021 at 09:12:01PM +0000, Raghavendra Rao Ananta wrote:
> > Hello,
> >
> > The patch series adds a KVM selftest to validate the behavior of
> > ARM's generic timer (patch-10). The test programs the timer IRQs
> > periodically, and for each interrupt, it validates the behaviour
> > against the architecture specifications. The test further provides
> > a command-line interface to configure the number of vCPUs, the
> > period of the timer, and the number of iterations that the test
> > has to run for.
> >
> > Since the test heavily depends on interrupts, the patch series also
> > adds a basic support for ARM Generic Interrupt Controller v3 (GICv3)
> > to the KVM's aarch64 selftest framework (patch-9).
> >
> > Furthermore, additional processor utilities such as accessing the MMIO
> > (via readl/writel), read/write to assembler unsupported registers,
> > basic delay generation, enable/disable local IRQs, spinlock support,
> > and so on, are also introduced that the test/GICv3 takes advantage of.
> > These are presented in patches 1 through 8.
> >
> > The patch series, specifically the library support, is derived from the
> > kvm-unit-tests and the kernel itself.
> >
>
> Hi Raghavendra,
>
> I appreciate the new support being added to aarch64 kselftests in order to
> support new tests. I'm curious as to why the kvm-unit-tests timer test
> wasn't extended instead, though. Also, I'm curious if you've seen any
> room for improvements to the kvm-unit-tests code and, if so, if you plan
> to submit patches for those improvements.


Hi  Andrew,

Interesting question! It's more about ease and flexibility in
controlling the guest via the VMM-
Since arch_timer's interface is mostly per-CPU, we'd like to extend
this test case to be
more stressful, such as migrating the vCPUs across pCPUs rapidly, or
even affining
a large number of vCPUs to a single pCPU, and so on.

On the other hand, since the patch series brings-in a lot of aarch64
goodies with it,
such as interrupt support, it might encourage others to add more arch
specific tests
easily :) For example, we also plan to add tests that verifies KVM
interface for interrupts,
for which the GIC support in the series would come handy.

I'm still gaining understanding of kvm-unit-tests. However, I'm
curious to know your thoughts as
well in-support of kvm-unit-tests.

Unfortunately, I don't have any immediate plans to submit patches on
arch_timer for
kvm-unit-tests.

Thanks,
Raghavendra

>
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
