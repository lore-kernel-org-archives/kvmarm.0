Return-Path: <SRS0=XNJw=ST=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8899DC282DA
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 15:22:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2421F20821
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 15:22:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2421F20821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A0074A511;
	Wed, 17 Apr 2019 11:22:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kcTDiwT8vKoV; Wed, 17 Apr 2019 11:22:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24DE24A51B;
	Wed, 17 Apr 2019 11:22:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B44F44A511
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 11:22:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PeerqkWN9F42 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Apr 2019 11:22:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 331524A4C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 11:22:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CF43A78;
 Wed, 17 Apr 2019 08:22:46 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C31D93F557;
 Wed, 17 Apr 2019 08:22:44 -0700 (PDT)
Date: Wed, 17 Apr 2019 16:22:42 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v9 4/5] KVM: arm64: Add capability to advertise ptrauth
 for guest
Message-ID: <20190417152242.GC3567@e103592.cambridge.arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-5-git-send-email-amit.kachhap@arm.com>
 <20190416163212.GX3567@e103592.cambridge.arm.com>
 <0070b1c2-07d6-7472-1bbc-c252710f6ca3@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0070b1c2-07d6-7472-1bbc-c252710f6ca3@arm.com>
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
Message-ID: <20190417152242.XR-u13oJnT2S2B-DuXKIIqy_dK35SW8vB6mKvxlzyEw@z>

On Wed, Apr 17, 2019 at 03:09:02PM +0530, Amit Daniel Kachhap wrote:
> Hi,
> 
> On 4/16/19 10:02 PM, Dave Martin wrote:
> >On Fri, Apr 12, 2019 at 08:50:35AM +0530, Amit Daniel Kachhap wrote:
> >>This patch advertises the capability of two cpu feature called address
> >>pointer authentication and generic pointer authentication. These
> >>capabilities depend upon system support for pointer authentication and
> >>VHE mode.
> >>
> >>The current arm64 KVM partially implements pointer authentication and
> >>support of address/generic authentication are tied together. However,
> >>separate ABI requirements for both of them is added so that any future
> >>isolated implementation will not require any ABI changes.
> >>
> >>Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >>Cc: Mark Rutland <mark.rutland@arm.com>
> >>Cc: Marc Zyngier <marc.zyngier@arm.com>
> >>Cc: Christoffer Dall <christoffer.dall@arm.com>
> >>Cc: kvmarm@lists.cs.columbia.edu
> >>---
> >>Changes since v8:
> >>*  Keep the capability check same for the 2 vcpu ptrauth features. [Dave Martin]
> >>
> >>  Documentation/virtual/kvm/api.txt | 2 ++
> >>  arch/arm64/kvm/reset.c            | 5 +++++
> >>  include/uapi/linux/kvm.h          | 2 ++
> >>  3 files changed, 9 insertions(+)
> >>
> >>diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> >>index 9d202f4..56021d0 100644
> >>--- a/Documentation/virtual/kvm/api.txt
> >>+++ b/Documentation/virtual/kvm/api.txt
> >>@@ -2756,9 +2756,11 @@ Possible features:
> >>  	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
> >>  	  for the CPU and supported only on arm64 architecture.
> >>  	  Must be requested if KVM_ARM_VCPU_PTRAUTH_GENERIC is also requested.
> >>+	  Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
> >
> >What if KVM_CAP_ARM_PTRAUTH_ADDRESS is absent and
> >KVM_ARM_VCPU_PTRAUTH_GENERIC is requested?  By these rules, we have a
> >contradiction: userspace both must request and must not request
> >KVM_ARM_VCPU_PTRAUTH_ADDRESS.
> >
> >We could qualify as follows:
> >
> >	Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
> >	Must be requested if KVM_CAP_ARM_PTRAUTH_ADDRESS is present and
> >	KVM_ARM_VCPU_PTRAUTH_GENERIC is also requested.
> ok agree. This makes it clear.

[*]

> >>  	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
> >>  	  for the CPU and supported only on arm64 architecture.
> >>  	  Must be requested if KVM_ARM_VCPU_PTRAUTH_ADDRESS is also requested.
> >>+	  Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
> >
> >Similarly.
> >
> >Or, we go back to having a single cap and a single feature, and add
> >more caps/features later on if we decide it's possible to support
> >address/generic auth separately later on.
> >
> >Otherwise, we end up with complex rules that can't be tested.  This is a
> >high price to pay for forwards compatibility: userspace's conformance to
> >the rules can't be fully tested, so there's a fair chance it won't work
> >properly anyway when hardware/KVM with just one auth type appears.
> >
> >[...]
> >
> >Thoughts?
> I agree that single cpufeature/capability is a simple solution to implement.
> The bifurcation of feature was done to reflect the different ID register
> split up.
> 
> But the h/w implementation provides a same EL2 exception trap for both the
> features and hence current implementation ties both of the features
> together. I guess in future if this is limitation goes away then one auth
> type is possible. Here I am not sure if the future h/w will retain this
> merged exception trap and add 2 new separate exception trap in addition to
> it.
> 
> I guess it will be probably simple split-up of this merged exception trap.
> In this case there won't be any ABI change required as per current
> implementation.

OK, I'm not opposed to keeping the ABI as-is, with the above
clarification [*] spelled out appropriately for both cases.

Alternatively, or in addition, we could say something like:

"If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
requested."

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
