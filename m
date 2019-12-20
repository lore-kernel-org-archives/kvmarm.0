Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A66CC3F68F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 17:55:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1082F206C3
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 17:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1082F206C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52C1C4ACD5;
	Fri, 20 Dec 2019 12:55:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O2JhwNHI7A8c; Fri, 20 Dec 2019 12:55:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27DD24AC88;
	Fri, 20 Dec 2019 12:55:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 494B64A95C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 12:55:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RXjiPaKPvZYj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 12:55:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0819A4A95B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 12:55:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 619A01FB;
 Fri, 20 Dec 2019 09:55:28 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D2C13F67D;
 Fri, 20 Dec 2019 09:55:27 -0800 (PST)
Date: Fri, 20 Dec 2019 17:55:25 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 00/18] arm64: KVM: add SPE profiling support
Message-ID: <20191220175524.GC25258@lakrids.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
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

Hi Andrew,

On Fri, Dec 20, 2019 at 02:30:07PM +0000, Andrew Murray wrote:
> This series implements support for allowing KVM guests to use the Arm
> Statistical Profiling Extension (SPE).
> 
> It has been tested on a model to ensure that both host and guest can
> simultaneously use SPE with valid data. E.g.
> 
> $ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
>         dd if=/dev/zero of=/dev/null count=1000
> $ perf report --dump-raw-trace > spe_buf.txt

What happens if I run perf record on the VMM, or on the CPU(s) that the
VMM is running on? i.e.

$ perf record -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
        lkvm ${OPTIONS_FOR_GUEST_USING_SPE}

... or:

$ perf record -a -c 0 -e arm_spe/ts_enable=1,pa_enable=1,pct_enable=1/ \
        sleep 1000 &
$ taskset -c 0 lkvm ${OPTIONS_FOR_GUEST_USING_SPE} &

> As we save and restore the SPE context, the guest can access the SPE
> registers directly, thus in this version of the series we remove the
> trapping and emulation.
> 
> In the previous series of this support, when KVM SPE isn't supported
> (e.g. via CONFIG_KVM_ARM_SPE) we were able to return a value of 0 to
> all reads of the SPE registers - as we can no longer do this there isn't
> a mechanism to prevent the guest from using SPE - thus I'm keen for
> feedback on the best way of resolving this.

When not providing SPE to the guest, surely we should be trapping the
registers and injecting an UNDEF?

What happens today, without these patches?

> It appears necessary to pin the entire guest memory in order to provide
> guest SPE access - otherwise it is possible for the guest to receive
> Stage-2 faults.

AFAICT these patches do not implement this. I assume that's what you're
trying to point out here, but I just want to make sure that's explicit.

Maybe this is a reason to trap+emulate if there's something more
sensible that hyp can do if it sees a Stage-2 fault.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
