Return-Path: <SRS0=UWlR=26=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C0EC282DD
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 17:42:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F070420721
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 17:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F070420721
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 790BD4B250;
	Thu,  9 Jan 2020 12:42:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t9arNndImtGL; Thu,  9 Jan 2020 12:42:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 494AC4B27B;
	Thu,  9 Jan 2020 12:42:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E494B1D3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 12:42:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0gJDjCpBZYxr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jan 2020 12:42:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36F5D4B1B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 12:42:55 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8564328;
 Thu,  9 Jan 2020 09:42:54 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 901EF3F703;
 Thu,  9 Jan 2020 09:42:53 -0800 (PST)
Date: Thu, 9 Jan 2020 17:42:51 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 11/18] KVM: arm64: don't trap Statistical Profiling
 controls to EL2
Message-ID: <20200109174251.GJ3112@lakrids.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-12-andrew.murray@arm.com>
 <86bls0iqv6.wl-maz@kernel.org>
 <20191223115651.GA42593@e119886-lin.cambridge.arm.com>
 <1bb190091362262021dbaf41b5fe601e@www.loen.fr>
 <20191223121042.GC42593@e119886-lin.cambridge.arm.com>
 <20200109172511.GA42593@e119886-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200109172511.GA42593@e119886-lin.cambridge.arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Andrew,

On Thu, Jan 09, 2020 at 05:25:12PM +0000, Andrew Murray wrote:
> On Mon, Dec 23, 2019 at 12:10:42PM +0000, Andrew Murray wrote:
> > On Mon, Dec 23, 2019 at 12:05:12PM +0000, Marc Zyngier wrote:
> > > On 2019-12-23 11:56, Andrew Murray wrote:
> > > > My original concern in the cover letter was in how to prevent
> > > > the guest from attempting to use these registers in the first
> > > > place - I think the solution I was looking for is to
> > > > trap-and-emulate ID_AA64DFR0_EL1 such that the PMSVer bits
> > > > indicate that SPE is not emulated.
> > > 
> > > That, and active trapping of the SPE system registers resulting in injection
> > > of an UNDEF into the offending guest.
> > 
> > Yes that's no problem.
> 
> The spec says that 'direct access to [these registers] are UNDEFINED' - is it
> not more correct to handle this with trap_raz_wi than an undefined instruction?

The term UNDEFINED specifically means treated as an undefined
instruction. The Glossary in ARM DDI 0487E.a says for UNDEFINED:

| Indicates cases where an attempt to execute a particular encoding bit
| pattern generates an exception, that is taken to the current Exception
| level, or to the default Exception level for taking exceptions if the
| UNDEFINED encoding was executed at EL0. This applies to:
|
| * Any encoding that is not allocated to any instruction.
|
| * Any encoding that is defined as never accessible at the current
|   Exception level.
|
| * Some cases where an enable, disable, or trap control means an
|   encoding is not accessible at the current Exception level.

So these should trigger an UNDEFINED exception rather than behaving as
RAZ/WI.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
