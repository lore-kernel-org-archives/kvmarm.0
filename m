Return-Path: <SRS0=P9fm=2N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1DFC2D0CF
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 12:10:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5EF432063A
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 12:10:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EF432063A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C072E4AF53;
	Mon, 23 Dec 2019 07:10:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6A55J6n3ZWgJ; Mon, 23 Dec 2019 07:10:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D4D4AF48;
	Mon, 23 Dec 2019 07:10:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 322704AF2C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 07:10:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PiFjy2USAChj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Dec 2019 07:10:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22AAC4AF28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 07:10:05 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C11BA1FB;
 Mon, 23 Dec 2019 04:10:04 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36A063F68F;
 Mon, 23 Dec 2019 04:10:04 -0800 (PST)
Date: Mon, 23 Dec 2019 12:10:02 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 15/18] perf: arm_spe: Handle guest/host exclusion flags
Message-ID: <20191223121002.GB42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-16-andrew.murray@arm.com>
 <865zi8imr7.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <865zi8imr7.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
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

On Sun, Dec 22, 2019 at 12:10:52PM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:22 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > A side effect of supporting the SPE in guests is that we prevent the
> > host from collecting data whilst inside a guest thus creating a black-out
> > window. This occurs because instead of emulating the SPE, we share it
> > with our guests.
> > 
> > Let's accurately describe our capabilities by using the perf exclude
> > flags to prevent !exclude_guest and exclude_host flags from being used.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  drivers/perf/arm_spe_pmu.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > index 2d24af4cfcab..3703dbf459de 100644
> > --- a/drivers/perf/arm_spe_pmu.c
> > +++ b/drivers/perf/arm_spe_pmu.c
> > @@ -679,6 +679,9 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
> >  	if (attr->exclude_idle)
> >  		return -EOPNOTSUPP;
> >  
> > +	if (!attr->exclude_guest || attr->exclude_host)
> > +		return -EOPNOTSUPP;
> > +
> 
> I have the opposite approach. If the host decides to profile the
> guest, why should that be denied? If there is a black hole, it should
> take place in the guest. Today, the host does expect this to work, and
> there is no way that we unconditionally allow it to regress.

That seems reasonable.

Upon entering the guest we'd have to detect if the host is using SPE, and if
so choose not to restore the guest registers. Instead we'd have to trap them
and let the guest read/write emulated values until the host has finished with
SPE - at which time we could restore the guest SPE registers to hardware.

Does that approach make sense?

Thanks,

Andrew Murray

> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
