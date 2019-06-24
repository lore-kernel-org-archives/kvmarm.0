Return-Path: <SRS0=87+N=UX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CBBC43613
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 12:49:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E542212F5
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 12:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E542212F5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F9C4A501;
	Mon, 24 Jun 2019 08:49:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IpSq2zSHvzhE; Mon, 24 Jun 2019 08:49:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0EA4A4E6;
	Mon, 24 Jun 2019 08:49:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 371744A4BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 08:49:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zlOtfUo4Otow for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jun 2019 08:49:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8BD64A4A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 08:49:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73E0C344;
 Mon, 24 Jun 2019 05:49:02 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 856513F718;
 Mon, 24 Jun 2019 05:49:01 -0700 (PDT)
Date: Mon, 24 Jun 2019 13:48:59 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 06/59] KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
Message-ID: <20190624124859.GP2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-7-marc.zyngier@arm.com>
 <7f8a9d76-6087-b8d9-3571-074a08d08ec8@arm.com>
 <3a68e4e6-878f-7272-4e2d-8768680287fd@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3a68e4e6-878f-7272-4e2d-8768680287fd@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
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

On Fri, Jun 21, 2019 at 02:50:08PM +0100, Marc Zyngier wrote:
> On 21/06/2019 14:24, Julien Thierry wrote:
> > 
> > 
> > On 21/06/2019 10:37, Marc Zyngier wrote:
> >> From: Christoffer Dall <christoffer.dall@linaro.org>
> >>
> >> We were not allowing userspace to set a more privileged mode for the VCPU
> >> than EL1, but we should allow this when nested virtualization is enabled
> >> for the VCPU.
> >>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/kvm/guest.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >> index 3ae2f82fca46..4c35b5d51e21 100644
> >> --- a/arch/arm64/kvm/guest.c
> >> +++ b/arch/arm64/kvm/guest.c
> >> @@ -37,6 +37,7 @@
> >>  #include <asm/kvm_emulate.h>
> >>  #include <asm/kvm_coproc.h>
> >>  #include <asm/kvm_host.h>
> >> +#include <asm/kvm_nested.h>
> >>  #include <asm/sigcontext.h>
> >>  
> >>  #include "trace.h"
> >> @@ -194,6 +195,11 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >>  			if (vcpu_el1_is_32bit(vcpu))
> >>  				return -EINVAL;
> >>  			break;
> >> +		case PSR_MODE_EL2h:
> >> +		case PSR_MODE_EL2t:
> >> +			if (vcpu_el1_is_32bit(vcpu) || !nested_virt_in_use(vcpu))
> > 
> > This condition reads a bit weirdly. Why do we care about anything else
> > than !nested_virt_in_use() ?
> > 
> > If nested virt is not in use then obviously we return the error.
> > 
> > If nested virt is in use then why do we care about EL1? Or should this
> > test read as "highest_el_is_32bit" ?
> 
> There are multiple things at play here:
> 
> - MODE_EL2x is not a valid 32bit mode
> - The architecture forbids nested virt with 32bit EL2
> 
> The code above is a simplification of these two conditions. But
> certainly we can do a bit better, as kvm_reset_cpu() doesn't really
> check that we don't create a vcpu with both 32bit+NV. These two bits
> should really be exclusive.

This code is safe for now because KVM_VCPU_MAX_FEATURES <=
KVM_ARM_VCPU_NESTED_VIRT, right, i.e., nested_virt_in_use() cannot be
true?

This makes me a little uneasy, but I think that's paranoia talking: we
want bisectably, but no sane person should ship with just half of this
series.  So I guess this is fine.

We could stick something like

	if (WARN_ON(...))
		return false;

in nested_virt_in_use() and then remove it in the final patch, but it's
probably overkill.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
