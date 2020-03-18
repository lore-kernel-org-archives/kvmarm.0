Return-Path: <SRS0=woTa=5D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ED4C10DCE
	for <kvmarm@archiver.kernel.org>; Wed, 18 Mar 2020 10:52:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A37DB20768
	for <kvmarm@archiver.kernel.org>; Wed, 18 Mar 2020 10:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A37DB20768
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBAF24B097;
	Wed, 18 Mar 2020 06:52:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q-KvscCKGld6; Wed, 18 Mar 2020 06:52:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C18254B094;
	Wed, 18 Mar 2020 06:52:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95E214A4AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2020 06:52:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X3MxXNcbUz2A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2020 06:52:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DE864A4A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2020 06:52:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C06B41FB;
 Wed, 18 Mar 2020 03:51:59 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB1AF3F534;
 Wed, 18 Mar 2020 03:51:58 -0700 (PDT)
Date: Wed, 18 Mar 2020 10:51:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCHv6 0/3] arm64: perf: Add support for ARMv8.5-PMU 64-bit
 counters
Message-ID: <20200318105156.GB16012@lakrids.cambridge.arm.com>
References: <20200302181752.14251-1-mark.rutland@arm.com>
 <20200317231431.GM20788@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200317231431.GM20788@willie-the-truck>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: catalin.marinas@arm.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
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

On Tue, Mar 17, 2020 at 11:14:31PM +0000, Will Deacon wrote:
> On Mon, Mar 02, 2020 at 06:17:49PM +0000, Mark Rutland wrote:
> > This is a respin of Andrew Murray's series to enable support for 64-bit
> > counters as introduced in ARMv8.5.
> > 
> > I've given this a spin on (ARMv8.2) hardware, to test that there are no
> > regressions, but I have not had the chance to test in an ARMv8.5 model (which I
> > beleive Andrew had previously tested).
> > 
> > Since v5 [1]:
> > * Don't treat perfmon ID fields as signed
> > * Fix up ID field names
> > * Explicitly compare ARMV8.5 PMU value
> 
> I'm betting on your issue being a model bug, so I've queued this on top of
> Robin's enable/disable rework. Please take a look at for-next/perf [1] in
> case I screwed it up.

From a cursory review, that all looks good to me.

I'll poke if the issue turns out to be anything beyond a model bug. but
I agree it seems that's all it is.

Thanks,
Mark.

> 
> Thanks,
> 
> Will
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=for-next/perf
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
