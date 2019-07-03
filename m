Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225F9C0650E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 16:24:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE0AA2187F
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 16:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE0AA2187F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18C534A51B;
	Wed,  3 Jul 2019 12:24:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mwbQDUXGkmeQ; Wed,  3 Jul 2019 12:24:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B474A4FF;
	Wed,  3 Jul 2019 12:24:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F0614A501
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 12:24:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NwBQTqgwJpx1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jul 2019 12:24:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 476B54A4EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 12:24:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF569344;
 Wed,  3 Jul 2019 09:24:15 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0EFF3F718;
 Wed,  3 Jul 2019 09:24:14 -0700 (PDT)
Date: Wed, 3 Jul 2019 17:24:12 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 04/59] KVM: arm64: nv: Introduce nested virtualization
 VCPU feature
Message-ID: <20190703162412.GU2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-5-marc.zyngier@arm.com>
 <20190624114329.GO2790@e103592.cambridge.arm.com>
 <5bd65cc0-89a1-0849-2041-b6016d58e4f2@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5bd65cc0-89a1-0849-2041-b6016d58e4f2@arm.com>
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

On Wed, Jul 03, 2019 at 12:56:51PM +0100, Marc Zyngier wrote:
> On 24/06/2019 12:43, Dave Martin wrote:
> > On Fri, Jun 21, 2019 at 10:37:48AM +0100, Marc Zyngier wrote:
> >> From: Christoffer Dall <christoffer.dall@arm.com>
> >>
> >> Introduce the feature bit and a primitive that checks if the feature is
> >> set behind a static key check based on the cpus_have_const_cap check.
> >>
> >> Checking nested_virt_in_use() on systems without nested virt enabled
> >> should have neglgible overhead.
> >>
> >> We don't yet allow userspace to actually set this feature.
> >>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> > 
> > [...]
> > 
> >> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> >> new file mode 100644
> >> index 000000000000..8a3d121a0b42
> >> --- /dev/null
> >> +++ b/arch/arm64/include/asm/kvm_nested.h
> >> @@ -0,0 +1,13 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +#ifndef __ARM64_KVM_NESTED_H
> >> +#define __ARM64_KVM_NESTED_H
> >> +
> >> +#include <linux/kvm_host.h>
> >> +
> >> +static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
> >> +{
> >> +	return cpus_have_const_cap(ARM64_HAS_NESTED_VIRT) &&
> >> +		test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features);
> >> +}
> > 
> > Also, is it worth having a vcpu->arch.flags flag for this, similarly to
> > SVE and ptrauth?
> 
> What would we expose through this flag?

Nothing new, put possibly more efficient to access.

AFAIK, test_bit() always results in an explicit load, whereas
vcpu->arch.flags is just a variable, which we already access on some hot
paths.  So the compiler can read it once and cache it, with a bit of
luck.

For flags that are fixed after vcpu init, or flags that are only read/
written by the vcpu thread itself, this should work fine.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
