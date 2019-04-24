Return-Path: <SRS0=bv25=S2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF893C10F11
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 13:42:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 436132089F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 13:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 436132089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D077F4A48D;
	Wed, 24 Apr 2019 09:42:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id my+M3p+VhEyc; Wed, 24 Apr 2019 09:42:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2A24A46F;
	Wed, 24 Apr 2019 09:42:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 680554A46F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 09:42:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f+4wPHXSnbCG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 09:42:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D914A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 09:42:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C28315A2;
 Wed, 24 Apr 2019 06:42:26 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C10653F238;
 Wed, 24 Apr 2019 06:42:24 -0700 (PDT)
Date: Wed, 24 Apr 2019 14:42:22 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v10 1/5] KVM: arm64: Add a vcpu flag to control ptrauth
 for guest
Message-ID: <20190424134221.GX3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-2-git-send-email-amit.kachhap@arm.com>
 <20190423154419.GL3567@e103592.cambridge.arm.com>
 <f9ebe12e-b6df-690b-1279-b7e2709c9e25@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f9ebe12e-b6df-690b-1279-b7e2709c9e25@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190424134222.QzoXxmfFrn_efbM_RHm3DBxU_6GQ8fmYScr8qMtJqfc@z>

On Wed, Apr 24, 2019 at 11:27:50AM +0530, Amit Daniel Kachhap wrote:
> Hi,
> 
> On 4/23/19 9:14 PM, Dave Martin wrote:
> >On Tue, Apr 23, 2019 at 10:12:34AM +0530, Amit Daniel Kachhap wrote:
> >>A per vcpu flag is added to check if pointer authentication is
> >>enabled for the vcpu or not. This flag may be enabled according to
> >>the necessary user policies and host capabilities.
> >>
> >>This patch also adds a helper to check the flag.
> >>
> >>Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> >>Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >>Cc: Mark Rutland <mark.rutland@arm.com>
> >>Cc: Marc Zyngier <marc.zyngier@arm.com>
> >>Cc: Christoffer Dall <christoffer.dall@arm.com>
> >>Cc: kvmarm@lists.cs.columbia.edu
> >>---
> >>Changes since v9:
> >>
> >>* Added ptrauth cpufeature static check in vcpu_has_ptrauth [Marc Zyngier].
> >>
> >>  arch/arm64/include/asm/kvm_host.h | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >>diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>index 7a096fd..7ccac42 100644
> >>--- a/arch/arm64/include/asm/kvm_host.h
> >>+++ b/arch/arm64/include/asm/kvm_host.h
> >>@@ -355,10 +355,15 @@ struct kvm_vcpu_arch {
> >>  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
> >>  #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
> >>  #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
> >>+#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
> >>  #define vcpu_has_sve(vcpu) (system_supports_sve() && \
> >>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> >>+#define vcpu_has_ptrauth(vcpu)	((system_supports_address_auth() || \
> >>+				  system_supports_generic_auth()) && \
> >
> >Come to think of it, should this be
> >system_supports_address_auth() _&&_ system_supports_generic_auth()?
> I thought about it and kept it this way so that the implementation
> limitation is not introduced in this patch but only in a single place in the
> 3rd patch where all the documentation and reasoning is present on doing this
> way.

OK, I think that's reasonable.  Just wanted to check that I wasn't
missing some subtle issue here.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
