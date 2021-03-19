Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4F9C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:42:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46F3964E6B
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:42:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46F3964E6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8F084B6A9;
	Fri, 19 Mar 2021 06:42:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h14K6ofh6QKT; Fri, 19 Mar 2021 06:42:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04EB44B6A1;
	Fri, 19 Mar 2021 06:42:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4988F4B6A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:42:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0qoV1Iqkr-oh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:42:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55CBE4B693
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:42:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 220A864E6B;
 Fri, 19 Mar 2021 10:42:31 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lNCaK-002auV-WF; Fri, 19 Mar 2021 10:42:29 +0000
MIME-Version: 1.0
Date: Fri, 19 Mar 2021 10:42:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: Log source when panicking from nVHE hyp
In-Reply-To: <CADcWuH3aP8yWbh5mYbgEqjpqvRT8R6HFp814BiZevQAc_o-1+Q@mail.gmail.com>
References: <20210318143311.839894-1-ascull@google.com>
 <20210318143311.839894-6-ascull@google.com>
 <20210318165946.GA7656@willie-the-truck>
 <CADcWuH28yNVXwE5HyVSDcLLQKGesgZuXOKV1R0b7U2WVRV4PdA@mail.gmail.com>
 <CADcWuH3aP8yWbh5mYbgEqjpqvRT8R6HFp814BiZevQAc_o-1+Q@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <05382db2bb80997e7f5f9c66a4669bf9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 julien.thierry.kdev@gmail.com, catalin.marinas@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-03-19 10:38, Andrew Scull wrote:
>> > > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> > > index 90873851f677..7c17a67d2291 100644
>> > > --- a/arch/arm64/include/asm/kvm_mmu.h
>> > > +++ b/arch/arm64/include/asm/kvm_mmu.h
>> > > @@ -121,6 +121,8 @@ void kvm_update_va_mask(struct alt_instr *alt,
>> > >  void kvm_compute_layout(void);
>> > >  void kvm_apply_hyp_relocations(void);
>> > >
>> > > +#define __hyp_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
>> >
>> > Just a heads up: but Quentin's series moves this same macro, but to a
>> > different header (arch/arm64/kvm/hyp/include/nvhe/memory.h)
>> 
>> I can make sure we're putting it in the same header to ease the merge.
> 
> Seems I was too optimistic since nvhe/memory.h can only be used from
> nVHE hyp. I could rebase no top of Quentin to move the macro somewhere
> that can be used from here, but that would add a series dependency
> that you usually seem to try and avoid so I'm not going to change
> this, unless you'd prefer that I do.

I can deal with this at merge time.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
