Return-Path: <SRS0=4kLF=SM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1E7C10F11
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 12:42:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B733C20818
	for <kvmarm@archiver.kernel.org>; Wed, 10 Apr 2019 12:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B733C20818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34D674A433;
	Wed, 10 Apr 2019 08:42:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nsbqt9lXReIP; Wed, 10 Apr 2019 08:42:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E09DB4A47A;
	Wed, 10 Apr 2019 08:42:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C454A422
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 08:42:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TPQUh2Ei103T for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 08:42:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E9F24A36D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 08:42:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18404A78;
 Wed, 10 Apr 2019 05:42:05 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 264E73F59C;
 Wed, 10 Apr 2019 05:42:03 -0700 (PDT)
Date: Wed, 10 Apr 2019 13:42:00 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 23/27] KVM: arm64/sve: Add pseudo-register for the
 guest's vector lengths
Message-ID: <20190410124200.GI3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-24-git-send-email-Dave.Martin@arm.com>
 <20190404201854.7dzga3ctjj7427hk@kamzik.brq.redhat.com>
 <20190405093603.GM3567@e103592.cambridge.arm.com>
 <20190405101451.xtx7ggyomvrbrpxl@kamzik.brq.redhat.com>
 <20190405125413.GA3567@e103592.cambridge.arm.com>
 <20190405153321.r4ide5n2bkiuflqn@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190405153321.r4ide5n2bkiuflqn@kamzik.brq.redhat.com>
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
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190410124200.yEt8vWz3vCqkG4uRF0dlIs8h9MMLCnNCOpgjxHauKPE@z>

On Fri, Apr 05, 2019 at 05:33:21PM +0200, Andrew Jones wrote:
> On Fri, Apr 05, 2019 at 01:54:13PM +0100, Dave Martin wrote:

[...]

> > If you think the above is enough for ABI documentation purposes, I will
> > aim to drop the following comment into set_sve_vls():
> > 
> > 	/*
> > 	 * Vector lengths supported by the host can't currently be
> > 	 * hidden from the guest individually: instead we can only set a
> > 	 * maxmium via ZCR_EL2.LEN.  So, make sure the available vector
> > 	 * length match the set requested exactly up to the requested
> > 	 * maximum:
> > 	 */
> > 	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
> > 		if (vq_present(&vqs, vq) != sve_vq_available(vq))
> > 			return -EINVAL;
> > 
> > Do you think that's enough?
> >
> 
> That works for me, and I'm glad I now have it understood, because this
> will be a key piece of the QEMU uesr interface to work out. I.e. we
> need to be able to provide the user with the current host's VL list
> up to the max virtualizable VL when queried, allow them to choose a max
> from that list for a guest, and then commit to that VL sublist for the
> guest. I'll dive into QEMU on Monday, hopefully I won't drown there.

Agreed.

How to make this user-friendly is a separate problem, provided that the
kernel provides userspace with sufficient tools to do the job.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
