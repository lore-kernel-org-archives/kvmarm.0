Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFAFC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 15:03:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D686D65220
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 15:03:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D686D65220
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C344B325;
	Mon,  8 Mar 2021 10:03:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8XqOe8hWdV8A; Mon,  8 Mar 2021 10:03:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E36574B3C2;
	Mon,  8 Mar 2021 10:03:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 085B14B325
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 10:03:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D6dqEL3ZwhmA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 10:03:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CA054B2B4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 10:03:33 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A77431B;
 Mon,  8 Mar 2021 07:03:33 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.51.12])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 918373F73C;
 Mon,  8 Mar 2021 07:03:30 -0800 (PST)
Date: Mon, 8 Mar 2021 15:03:20 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] arm64/mm: Fix __enable_mmu() for new TGRAN range values
Message-ID: <20210308150232.GA14159@C02TD0UTHF1T.local>
References: <1614954969-14338-1-git-send-email-anshuman.khandual@arm.com>
 <20210305145111.GA78884@C02TD0UTHF1T.local>
 <1f339512-34ac-9779-e534-bee6698b99aa@arm.com>
 <20210308133053.GA26128@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210308133053.GA26128@willie-the-truck>
Cc: linux-efi@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>,
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

On Mon, Mar 08, 2021 at 01:30:53PM +0000, Will Deacon wrote:
> On Sun, Mar 07, 2021 at 05:24:21PM +0530, Anshuman Khandual wrote:
> > On 3/5/21 8:21 PM, Mark Rutland wrote:
> > > On Fri, Mar 05, 2021 at 08:06:09PM +0530, Anshuman Khandual wrote:

> > >> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT	0x0
> > >> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE	0x1
> > >> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN	0x2
> > >> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX	0x7
> > >
> > > The TGRAN2 fields doesn't quite follow the usual ID scheme rules, so how
> > > do we deteremine the max value? Does the ARM ARM say anything in
> > > particular about them, like we do for some of the PMU ID fields?
> > 
> > Did not find anything in ARM ARM, regarding what scheme TGRAN2 fields
> > actually follow. I had arrived at more restrictive 0x7 value, like the
> > usual signed fields as the TGRAN4 fields definitely do not follow the
> > unsigned ID scheme. Would restricting max value to 0x3 (i.e LPA2) be a
> > better option instead ?
> 
> I don't think it helps much, as TGRAN64_2 doesn't even define 0x3.
> 
> So I think this patch is probably the best we can do, but the Arm ARM could
> really do with describing the scheme here.

I agree, and I've filed a ticket internally to try to get this cleaned
up.

I suspect that the answer is that these are basically unsigned, with
0x2-0xf indicating presence, but I can't guarantee that.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
