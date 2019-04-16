Return-Path: <SRS0=JhHZ=SS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8900DC10F13
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 12:37:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0849A206BA
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 12:37:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0849A206BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A3E74A504;
	Tue, 16 Apr 2019 08:37:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6rti7+d+9Hl4; Tue, 16 Apr 2019 08:37:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21AC84A511;
	Tue, 16 Apr 2019 08:37:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E760F4A506
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 08:37:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8x2E19k2qsBz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Apr 2019 08:37:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 912224A4CF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 08:37:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7D0DEBD;
 Tue, 16 Apr 2019 05:37:38 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E49D93F706;
 Tue, 16 Apr 2019 05:37:36 -0700 (PDT)
Date: Tue, 16 Apr 2019 13:37:34 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 05/14] KVM: arm64/sve: Clean up UAPI register ID
 definitions
Message-ID: <20190416123734.GN3567@e103592.cambridge.arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
 <1555086498-26691-6-git-send-email-Dave.Martin@arm.com>
 <20190415151739.svfcwoybfr5js3wc@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190415151739.svfcwoybfr5js3wc@kamzik.brq.redhat.com>
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
Message-ID: <20190416123734.WmychaqVn28vQzhweR7664oEh4p5okMPwoIk9olqOXc@z>

On Mon, Apr 15, 2019 at 05:17:39PM +0200, Andrew Jones wrote:
> On Fri, Apr 12, 2019 at 05:28:09PM +0100, Dave Martin wrote:
> > Currently, the SVE register ID macros are not all defined in the
> > same way, and advertise the fact that FFR maps onto the nonexistent
> > predicate register P16.  This is really just for kernel
> > convenience, and may lead userspace into bad habits.
> > 
> > Instead, this patch masks the ID macro arguments so that
> > architecturally invalid register numbers will not be passed through
> > any more, and uses a literal KVM_REG_ARM64_SVE_FFR_BASE macro to
> > define KVM_REG_ARM64_SVE_FFR(), similarly to the way the _ZREG()
> > and _PREG() macros are defined.
> > 
> > Rather than plugging in magic numbers for the number of Z- and P-
> > registers and the maximum possible number of register slices, this
> > patch provides definitions for those too.  Userspace is going to
> > need them in any case, and it makes sense for them to come from
> > <uapi/asm/kvm.h>.
> > 
> > sve_reg_to_region() uses convenience constants that are defined in
> > a different way, and also makes use of the fact that the FFR IDs
> > are really contiguous with the P15 IDs, so this patch retains the
> > existing convenience constants in guest.c, supplemented with a
> > couple of sanity checks to check for consistency with with the UAPI
> 
> s/with with/with/

Good spot, thanks.

> > header.
> > 
> > Fixes: e1c9c98345b3 ("KVM: arm64/sve: Add SVE support to register access ioctl interface")
> > Suggested-by: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/uapi/asm/kvm.h | 32 +++++++++++++++++++++++---------
> >  arch/arm64/kvm/guest.c            |  9 +++++++++
> >  2 files changed, 32 insertions(+), 9 deletions(-)
> >
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
