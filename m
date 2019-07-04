Return-Path: <SRS0=oQwk=VB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36042C06517
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 10:00:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C3797218A0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Jul 2019 10:00:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3797218A0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 366814A4A0;
	Thu,  4 Jul 2019 06:00:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4h2HaoHovgn8; Thu,  4 Jul 2019 06:00:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E459C4A2E7;
	Thu,  4 Jul 2019 06:00:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 361F340A52
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 06:00:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SuJO3DdoCGQs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jul 2019 06:00:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2C2A4005D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jul 2019 06:00:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52016360;
 Thu,  4 Jul 2019 03:00:12 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84C643F703;
 Thu,  4 Jul 2019 03:00:11 -0700 (PDT)
Date: Thu, 4 Jul 2019 11:00:09 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 06/59] KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
Message-ID: <20190704100009.GZ2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-7-marc.zyngier@arm.com>
 <7f8a9d76-6087-b8d9-3571-074a08d08ec8@arm.com>
 <3a68e4e6-878f-7272-4e2d-8768680287fd@arm.com>
 <20190624124859.GP2790@e103592.cambridge.arm.com>
 <09dca509-9696-d224-22d2-4d5b0a0d9161@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <09dca509-9696-d224-22d2-4d5b0a0d9161@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: linux-arm-kernel@lists.infradead.org,
 Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Wed, Jul 03, 2019 at 10:21:57AM +0100, Marc Zyngier wrote:
> On 24/06/2019 13:48, Dave Martin wrote:
> > On Fri, Jun 21, 2019 at 02:50:08PM +0100, Marc Zyngier wrote:
> >> On 21/06/2019 14:24, Julien Thierry wrote:
> >>>
> >>>
> >>> On 21/06/2019 10:37, Marc Zyngier wrote:
> >>>> From: Christoffer Dall <christoffer.dall@linaro.org>
> >>>>
> >>>> We were not allowing userspace to set a more privileged mode for the VCPU
> >>>> than EL1, but we should allow this when nested virtualization is enabled
> >>>> for the VCPU.
> >>>>
> >>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >>>> ---
> >>>>  arch/arm64/kvm/guest.c | 6 ++++++
> >>>>  1 file changed, 6 insertions(+)
> >>>>
> >>>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >>>> index 3ae2f82fca46..4c35b5d51e21 100644
> >>>> --- a/arch/arm64/kvm/guest.c
> >>>> +++ b/arch/arm64/kvm/guest.c
> >>>> @@ -37,6 +37,7 @@
> >>>>  #include <asm/kvm_emulate.h>
> >>>>  #include <asm/kvm_coproc.h>
> >>>>  #include <asm/kvm_host.h>
> >>>> +#include <asm/kvm_nested.h>
> >>>>  #include <asm/sigcontext.h>
> >>>>  
> >>>>  #include "trace.h"
> >>>> @@ -194,6 +195,11 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >>>>  			if (vcpu_el1_is_32bit(vcpu))
> >>>>  				return -EINVAL;
> >>>>  			break;
> >>>> +		case PSR_MODE_EL2h:
> >>>> +		case PSR_MODE_EL2t:
> >>>> +			if (vcpu_el1_is_32bit(vcpu) || !nested_virt_in_use(vcpu))
> >>>
> >>> This condition reads a bit weirdly. Why do we care about anything else
> >>> than !nested_virt_in_use() ?
> >>>
> >>> If nested virt is not in use then obviously we return the error.
> >>>
> >>> If nested virt is in use then why do we care about EL1? Or should this
> >>> test read as "highest_el_is_32bit" ?
> >>
> >> There are multiple things at play here:
> >>
> >> - MODE_EL2x is not a valid 32bit mode
> >> - The architecture forbids nested virt with 32bit EL2
> >>
> >> The code above is a simplification of these two conditions. But
> >> certainly we can do a bit better, as kvm_reset_cpu() doesn't really
> >> check that we don't create a vcpu with both 32bit+NV. These two bits
> >> should really be exclusive.
> > 
> > This code is safe for now because KVM_VCPU_MAX_FEATURES <=
> > KVM_ARM_VCPU_NESTED_VIRT, right, i.e., nested_virt_in_use() cannot be
> > true?
> > 
> > This makes me a little uneasy, but I think that's paranoia talking: we
> > want bisectably, but no sane person should ship with just half of this
> > series.  So I guess this is fine.
> > 
> > We could stick something like
> > 
> > 	if (WARN_ON(...))
> > 		return false;
> > 
> > in nested_virt_in_use() and then remove it in the final patch, but it's
> > probably overkill.
> 
> The only case I can imagine something going wrong is if this series is
> only applied halfway, and another series bumps the maximum feature to
> something that includes NV. I guess your suggestion would solve that.

I won't lose sleep over it either way.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
