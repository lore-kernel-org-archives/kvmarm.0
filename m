Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BBAC28CC3
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 09:26:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C231D24619
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 09:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C231D24619
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DDE74A4E6;
	Tue,  4 Jun 2019 05:26:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XBWltaclGVMX; Tue,  4 Jun 2019 05:26:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E87434A417;
	Tue,  4 Jun 2019 05:26:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C69A4A409
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 05:26:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RM6wMjeJtCYC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 05:26:44 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F10784A36B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 05:26:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D819A78;
 Tue,  4 Jun 2019 02:26:43 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C62673F246;
 Tue,  4 Jun 2019 02:26:41 -0700 (PDT)
Date: Tue, 4 Jun 2019 10:26:39 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Drop 'const' from argument of vq_present()
Message-ID: <20190604092639.GS28398@e103592.cambridge.arm.com>
References: <699121e5c938c6f4b7b14a7e2648fa15af590a4a.1559623368.git.viresh.kumar@linaro.org>
 <20190604084349.prnnvjvjaeuhsmgs@mbp>
 <20190604085545.hsmxfqkpt2cbrhtw@vireshk-i7>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190604085545.hsmxfqkpt2cbrhtw@vireshk-i7>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
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

On Tue, Jun 04, 2019 at 02:25:45PM +0530, Viresh Kumar wrote:
> On 04-06-19, 09:43, Catalin Marinas wrote:
> > On Tue, Jun 04, 2019 at 10:13:19AM +0530, Viresh Kumar wrote:
> > > We currently get following compilation warning:
> > > 
> > > arch/arm64/kvm/guest.c: In function 'set_sve_vls':
> > > arch/arm64/kvm/guest.c:262:18: warning: passing argument 1 of 'vq_present' from incompatible pointer type
> > > arch/arm64/kvm/guest.c:212:13: note: expected 'const u64 (* const)[8]' but argument is of type 'u64 (*)[8]'
> > 
> > Since the vq_present() function does not modify the vqs array, I don't
> > understand why this warning. Compiler bug?
> 
> Probably yes. Also marking array argument to functions as const is a
> right thing to do, to declare that the function wouldn't change the
> array values.
> 
> I tried a recent toolchain and this doesn't happen anymore.
> 
> Sorry for the noise.

Sparse is already warning about this, but I had dismissed it as a false
positive.

I think this is an instance of disallowing implicit conversions of the
form

	T ** -> T const **

because this allows a const pointer to be silently de-consted, e.g.:

static const T bar;

void foo(T const **p)
{
	*p = &bar;
}

T *baz(void)
{
	T *q; 
	foo(&q);
	return q;
}


I _suspect_ that what's going on here is that the compiler is
eliminating a level of indirection during inlining (i.e. converting
pass-by-reference to direct access, which is precisely what I wanted
to happen).  This removes the potentially invalid behaviour as a
side-effect.

This relies on the compiler optimising / analysing the code
aggressively enough though.

So, I don't have a problem with dropping the extra extra const, e.g.:

static bool vq_present(
	u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
	unsigned int vq)

Since this function is static and only used very locally, I don't see a
big risk: the only reason for the extra const was to check that
vq_present() doesn't modify vqs when it shouldn't.  But it's a trivial
function, and the intent is pretty clear without the extra type
modifier.


I'm in two minds about whether this is worth fixing, but if you want to
post a patch to remove the extra const (or convert vq_present() to a
macro), I'll take a look at it.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
