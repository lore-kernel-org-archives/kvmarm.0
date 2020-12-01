Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B697EC64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 14:58:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 132212084C
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 14:58:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 132212084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B75B4C17B;
	Tue,  1 Dec 2020 09:58:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2cnAIqmYHlx4; Tue,  1 Dec 2020 09:58:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AC914C246;
	Tue,  1 Dec 2020 09:58:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 097A94C245
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 09:58:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OMFpWvs2XAyS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 09:58:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01AD44C1A1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 09:58:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6CCA30E;
 Tue,  1 Dec 2020 06:58:47 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.30.155])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 444ED3F575;
 Tue,  1 Dec 2020 06:58:43 -0800 (PST)
Date: Tue, 1 Dec 2020 14:58:40 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 06/23] kvm: arm64: Add kvm-arm.protected early kernel
 parameter
Message-ID: <20201201145840.GC86881@C02TD0UTHF1T.local>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-7-dbrazdil@google.com>
 <20201127163254.zxdrszlveaxhluwn@bogus>
 <20201201131913.u7m2eifvtus74dra@google.com>
 <20201201140734.GA86881@C02TD0UTHF1T.local>
 <20201201144349.bglz7yicc3peixe6@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201201144349.bglz7yicc3peixe6@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Tue, Dec 01, 2020 at 02:43:49PM +0000, David Brazdil wrote:
> > > > be just me, but if you agree please update so that it doesn't give remote
> > > > idea that it is not valid on VHE enabled hardware.
> > > > 
> > > > I was trying to run this on the hardware and was trying to understand the
> > > > details on how to do that.
> > > 
> > > I see what you're saying, but !CONFIG_ARM64_VHE isn't accurate either. The
> > > option makes sense if:
> > >   1) all cores booted in EL2
> > >      == is_hyp_mode_available()
> > >   2) ID_AA64MMFR1_EL1.VH=0 or !CONFIG_ARM64_VHE
> > >      == !is_kernel_in_hyp_mode()
> > > 
> > > The former feels implied for KVM, the latter could be 'Valid if the kernel
> > > is running in EL1'? WDYT?
> > 
> > I reckon we can avoid the restriction if we instead add an early stub
> > like with have for KASLR. That way we could parse the command line
> > early, and if necessary re-initialize EL2 and drop to EL1 before the
> > main kernel has to make any decisions about how to initialize things.
> > That would allow us to have a more general kvm-arm.mode option where a
> > single kernel Image could support:
> > 
> > * "protected" mode on nVHE or VHE HW
> > * "nvhe" mode on nVHE or VHE HW
> > * "vhe" mode on VHE HW
> > 
> > ... defaulting to VHE/nVHE modes depending on HW support.
> > 
> > That would also be somewhat future-proof if we have to add other
> > variants of protected mode in future, as we could extend the mode option
> > with parameters for each mode.
> 
> Agreed that 'mode' is a more future-proof flag and I would very much love to
> have an option to force nVHE on VHE HW. I however expect that the early stub
> would not be a trivial addition and would not want to get into that in this
> series. Could we agree on 'protected' as the only supported value for the time
> being?

Sure, that works for me.

Thanks,
Mark. 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
