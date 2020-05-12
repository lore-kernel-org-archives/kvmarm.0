Return-Path: <SRS0=VUvZ=62=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACA0C54E8E
	for <kvmarm@archiver.kernel.org>; Tue, 12 May 2020 10:56:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3044720675
	for <kvmarm@archiver.kernel.org>; Tue, 12 May 2020 10:56:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3044720675
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CD3D4B134;
	Tue, 12 May 2020 06:56:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cdHXoSxFPZZ1; Tue, 12 May 2020 06:56:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F3AD4B0D3;
	Tue, 12 May 2020 06:56:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C3274B0C1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 May 2020 06:56:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3XevLYpb+jNJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 May 2020 06:56:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D1044B0BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 May 2020 06:56:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A26A530E;
 Tue, 12 May 2020 03:56:19 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.28.99])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD7243F71E;
 Tue, 12 May 2020 03:56:17 -0700 (PDT)
Date: Tue, 12 May 2020 11:56:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] arm64/cpufeature: Add ID_AA64MMFR0_PARANGE_MASK
Message-ID: <20200512105614.GC60359@C02TD0UTHF1T.local>
References: <1589249606-27177-1-git-send-email-anshuman.khandual@arm.com>
 <20200512105343.GB60359@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200512105343.GB60359@C02TD0UTHF1T.local>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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

On Tue, May 12, 2020 at 11:53:43AM +0100, Mark Rutland wrote:
> >
> >  	/* Clamp the IPA limit to the PA size supported by the kernel */
> >  	ipa_max = (pa_max > PHYS_MASK_SHIFT) ? PHYS_MASK_SHIFT : pa_max;
> > @@ -411,7 +411,8 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
> >  		phys_shift = KVM_PHYS_SHIFT;
> >  	}
> >  
> > -	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
> > +	parange = id_aa64mmfr0_parange(read_sanitised_ftr_reg
> > +						(SYS_ID_AA64MMFR0_EL1));
> 
> Can't we add a system_ipa_range() helper, and avoid more boilerplate in
> each of these?
> 
> e.g.
> 
> int system_ipa_range(void)
> {
> 	u64 mmfr0;
> 	int parange;
> 
> 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> 	parange = cpuid_feature_extract_unsigned_field(mmfr0,
> 		ID_AA64MMFR0_PARANGE_SHIFT);
> 	
> 	return parange;
> }

As Per MarcZ's comments, that should be system_pa_range() rather than
system_ipa_range().

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
