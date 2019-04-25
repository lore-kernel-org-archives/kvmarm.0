Return-Path: <SRS0=pAxc=S3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E91C10F03
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:05:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9428420678
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:05:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9428420678
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB694A4AA;
	Thu, 25 Apr 2019 09:05:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3BT+cJ+mr6xy; Thu, 25 Apr 2019 09:05:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83A014A3B4;
	Thu, 25 Apr 2019 09:05:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAFC84A369
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:05:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LuZo6z3nFUS4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:05:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 893DF4A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:05:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C873A78;
 Thu, 25 Apr 2019 06:05:19 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17D883F5C1;
 Thu, 25 Apr 2019 06:05:16 -0700 (PDT)
Date: Thu, 25 Apr 2019 14:05:14 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 00/14] KVM: arm64: SVE cleanups
Message-ID: <20190425130514.GB3567@e103592.cambridge.arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
 <875zr2w9cj.fsf@zen.linaroharston>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875zr2w9cj.fsf@zen.linaroharston>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190425130514.xJ4jJL-NPK9R_Lbz88vnOgULh0KJL4F0GjmIHzyTgXk@z>

On Thu, Apr 25, 2019 at 01:35:56PM +0100, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > This series contains some cleanups applicable to the SVE KVM support
> > patches merged into kvmarm/next.  These arose from Andrew Jones'
> > review.
> >
> > Apart from some minor changes to error codes and checking, these are
> > mostly cosmetic / sytlistic changes only.
> >
> > The patches are based on
> > git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> > 5d8d4af24460 ("arm64: KVM: Fix system register enumeration")
> >
> > This series in git:
> > git://linux-arm.org/linux-dm.git sve-kvm-fixes/v2/head
> > http://linux-arm.org/git?p=3Dlinux-dm.git;a=3Dshortlog;h=3Drefs/heads/s=
ve-kvm-fixes/v2/head
> >
> > Tested with qemu and kvmtool on ThunderX2, and with kvmtool on the Arm
> > Fast model (to exercise SVE support).
> =

> These all look good to me:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks for the review!

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
