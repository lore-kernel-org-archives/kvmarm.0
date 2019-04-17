Return-Path: <SRS0=XNJw=ST=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE99C282DC
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 14:53:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EF4E217F4
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 14:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EF4E217F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B99454A515;
	Wed, 17 Apr 2019 10:53:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5vTt6qsUj0f6; Wed, 17 Apr 2019 10:53:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A8D24A4FF;
	Wed, 17 Apr 2019 10:53:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D09124A4FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 10:53:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LqrqMwV59-8k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Apr 2019 10:53:01 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B9524A4D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 10:53:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8DC3A78;
 Wed, 17 Apr 2019 07:53:00 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 395D63F557;
 Wed, 17 Apr 2019 07:52:59 -0700 (PDT)
Date: Wed, 17 Apr 2019 15:52:56 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 1/5] KVM: arm64: Add a vcpu flag to control ptrauth
 for guest
Message-ID: <20190417145255.GB3567@e103592.cambridge.arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-2-git-send-email-amit.kachhap@arm.com>
 <eeeebc4d-f061-42a5-954d-40161bbed23a@arm.com>
 <ef1eb326-cd3a-4033-813d-ceae262b4e23@arm.com>
 <239c5d74-221e-cf8c-2c41-80db016bdc2b@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <239c5d74-221e-cf8c-2c41-80db016bdc2b@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Message-ID: <20190417145256.7E7M8F6WUnOTiXxi6W_xjIycThzxZ3PO9ZGvTNRqQbg@z>

On Wed, Apr 17, 2019 at 03:19:11PM +0100, Marc Zyngier wrote:
> On 17/04/2019 14:08, Amit Daniel Kachhap wrote:
> > Hi,
> > 
> > On 4/17/19 2:05 PM, Marc Zyngier wrote:
> >> On 12/04/2019 04:20, Amit Daniel Kachhap wrote:
> >>> A per vcpu flag is added to check if pointer authentication is
> >>> enabled for the vcpu or not. This flag may be enabled according to
> >>> the necessary user policies and host capabilities.
> >>>
> >>> This patch also adds a helper to check the flag.
> >>>
> >>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >>> Cc: Mark Rutland <mark.rutland@arm.com>
> >>> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >>> Cc: Christoffer Dall <christoffer.dall@arm.com>
> >>> Cc: kvmarm@lists.cs.columbia.edu
> >>> ---
> >>>
> >>> Changes since v8:
> >>> * Added a new per vcpu flag which will store Pointer Authentication enable
> >>>    status instead of checking them again. [Dave Martin]
> >>>
> >>>   arch/arm64/include/asm/kvm_host.h | 4 ++++
> >>>   1 file changed, 4 insertions(+)
> >>>
> >>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >>> index 9d57cf8..31dbc7c 100644
> >>> --- a/arch/arm64/include/asm/kvm_host.h
> >>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>> @@ -355,10 +355,14 @@ struct kvm_vcpu_arch {
> >>>   #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
> >>>   #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
> >>>   #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
> >>> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
> >>>   
> >>>   #define vcpu_has_sve(vcpu) (system_supports_sve() && \
> >>>   			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> >>>   
> >>> +#define vcpu_has_ptrauth(vcpu)	\
> >>> +			((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
> >>> +
> >>
> >> Just as for SVE, please first check that the system has PTRAUTH.
> >> Something like:
> >>
> >> 		(cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH_ARCH) && \
> >> 		 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
> > 
> > In the subsequent patches, vcpu->arch.flags is only set to 
> > KVM_ARM64_GUEST_HAS_PTRAUTH when all host capability check conditions 
> > matches such as system_supports_address_auth(), 
> > system_supports_generic_auth() so doing them again is repetitive in my view.
> 
> It isn't the setting of the flag I care about, but the check of that
> flag. Checking a flag for a feature that cannot be used on the running
> system should have a zero cost, which isn't the case here.
> 
> Granted, the impact should be minimal and it looks like it mostly happen
> on the slow path, but at the very least it would be consistent. So even
> if you don't buy my argument about efficiency, please change it in the
> name of consistency.

One of the annoyances here is there is no single static key for ptrauth.

I'm assuming we don't want to check both static keys (for address and
generic auth) on hot paths.

Checking just one of the two possibilities is OK for now, but we need
to comment clearly somewhere that that will break if KVM is changed
later to expose ptrauth to guests when the host doesn't support both
types.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
