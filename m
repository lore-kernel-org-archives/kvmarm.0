Return-Path: <SRS0=H6Wl=T4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86BEC04AB6
	for <kvmarm@archiver.kernel.org>; Tue, 28 May 2019 10:11:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 540C020883
	for <kvmarm@archiver.kernel.org>; Tue, 28 May 2019 10:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 540C020883
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C37C44A4C9;
	Tue, 28 May 2019 06:11:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6UkpAY4NplRb; Tue, 28 May 2019 06:11:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 829A34A4E8;
	Tue, 28 May 2019 06:11:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4C414A4C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 May 2019 06:11:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8S481AjDQw8x for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 May 2019 06:11:36 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 075D54A496
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 May 2019 06:11:36 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E041341;
 Tue, 28 May 2019 03:11:35 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B45033F59C;
 Tue, 28 May 2019 03:11:33 -0700 (PDT)
Date: Tue, 28 May 2019 11:11:31 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [kvmtool PATCH v10 5/5] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
Message-ID: <20190528101128.GB28398@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-6-git-send-email-amit.kachhap@arm.com>
 <20190423154625.GP3567@e103592.cambridge.arm.com>
 <3b7bafc9-5d6a-7845-ef1f-577ea59000e2@arm.com>
 <20190424134120.GW3567@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190424134120.GW3567@e103592.cambridge.arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Apr 24, 2019 at 02:41:21PM +0100, Dave Martin wrote:
> On Wed, Apr 24, 2019 at 12:32:22PM +0530, Amit Daniel Kachhap wrote:
> > Hi,
> > 
> > On 4/23/19 9:16 PM, Dave Martin wrote:

[...]

> > >>diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> > >>index 7780251..acd1d5f 100644
> > >>--- a/arm/kvm-cpu.c
> > >>+++ b/arm/kvm-cpu.c
> > >>@@ -68,6 +68,18 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> > >>  		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
> > >>  	}
> > >>+	/* Check Pointer Authentication command line arguments. */
> > >>+	if (kvm->cfg.arch.enable_ptrauth && kvm->cfg.arch.disable_ptrauth)
> > >>+		die("Both enable-ptrauth and disable-ptrauth option cannot be present");
> > >
> > >Preferably, print the leading dashes, the same as the user would see
> > >on the command line (e.g., --enable-ptrauth, --disable-ptrauth).
> > >
> > >For brevity, we could write something like:
> > >
> > >		die("--enable-ptrauth conflicts with --disable-ptrauth");

[...]

> > >>@@ -106,8 +118,12 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> > >>  			die("Unable to find matching target");
> > >>  	}
> > >>-	if (err || target->init(vcpu))
> > >>-		die("Unable to initialise vcpu");
> > >>+	if (err || target->init(vcpu)) {
> > >>+		if (kvm->cfg.arch.enable_ptrauth)
> > >>+			die("Unable to initialise vcpu with pointer authentication feature");
> > >
> > >We don't special-case this error message for any other feature yet:
> > >there are a variety of reasons why we might have failed, so suggesting
> > >that the failure is something to do with ptrauth may be misleading to
> > >the user.
> > >
> > >If we want to be more informative, we could do something like the
> > >following:
> > >
> > >	bool supported;
> > >
> > >	supported = kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> > >		    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC);
> > >
> > >	if (kvm->cfg.arch.enable_ptrauth && !supported)
> > >		die("--enable-ptrauth not supported on this host");
> > >
> > >	if (supported && !kvm->cfg.arch.disable_ptrauth)
> > >		vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
> > >
> > >	/* ... */
> > >
> > >	if (err || target->init(vcpu))
> > >		die("Unable to initialise vcpu");
> > >
> > >We don't do this for any other feature today, but since it helps the
> > >user to understand what went wrong it's probably a good idea.
> > Yes this is more clear. As Mark has picked the core guest ptrauth patches. I
> > will post this changes as standalone.
> 
> Sounds good.  (I also need to do that separately for SVE...)

Were you planning to repost this?

Alternatively, I can fix up the diagnostic messages discussed here and
post it together with the SVE support.  I'll do that locally for now,
but let me know what you plan to do.  I'd like to get the SVE support
posted soon so that people can test it.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
