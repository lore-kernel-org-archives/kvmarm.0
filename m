Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD359C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 08:12:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4582A2067D
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 08:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wajtMIDF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4582A2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A084B493;
	Thu, 25 Jun 2020 04:12:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3qjarM-hsSDk; Thu, 25 Jun 2020 04:12:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F664B495;
	Thu, 25 Jun 2020 04:12:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B39024B493
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 04:12:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ojpuwkHS2nkP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 04:12:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C4864B489
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 04:12:53 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4FFDB2067D;
 Thu, 25 Jun 2020 08:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593072772;
 bh=hFDSF6sOyHk09xBbSGXCSJ7Em905+sQZ3Jw5UdSgHV8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=wajtMIDFxtK5LLIDrbKmwtzS9/M5CgCQN4zTXbE8/DDNcLXzi1STfYFv+j/nOtPfH
 ZFDQkMzjJ20GLc/xMuQOC0szrItUDL/GJ315KGMpP8iDpI40ybpQi787V/BTBo9yYP
 76PYC2BW92IQ47rgvV3RC2Jmg+W+2lEEg8y5qn2c=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1joN06-006HRd-Mb; Thu, 25 Jun 2020 09:12:50 +0100
MIME-Version: 1.0
Date: Thu, 25 Jun 2020 09:12:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 05/15] arm64: kvm: Build hyp-entry.S separately for
 VHE/nVHE
In-Reply-To: <20200622102041.myve2otyoj5q7j5s@google.com>
References: <20200618122537.9625-1-dbrazdil@google.com>
 <20200618122537.9625-6-dbrazdil@google.com>
 <5029f8fb4a7816e11de7469c09347c79@kernel.org>
 <20200622102041.myve2otyoj5q7j5s@google.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <491f3c8877897a4ac69d69fb7354c1cb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, will@kernel.org,
 catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 android-kvm@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hi David,

On 2020-06-22 11:20, David Brazdil wrote:
> Hi Marc,
> 
>> > -	void *dst = lm_alias(__bp_harden_hyp_vecs + slot * SZ_2K);
>> > +	char *vec = has_vhe() ? __bp_harden_hyp_vecs
>> > +			      : kvm_nvhe_sym(__bp_harden_hyp_vecs);
>> 
>> If we get this construct often, then something that abstracts
>> the uggliness of the symbol duality would be nice...
> 
> Agreed, I do hope that this will end up being limited to finding the 
> address of
> the hyp-init vector once EL2 becomes self-contained. Even this vector 
> selection
> can be done in EL2 where the symbol duality does not exist.
> If we were to hide it, there is a trade off between code "elegance" and 
> clarity
> of what's happening under the hood. I was thinking we could extract 
> this
> `has_vhe() ? foo : __kvm_nvhe_foo` as a `#define foo` but I do worry 
> that
> anybody debugging this code would be cursing my name.

I would say that whoever is debugging this code better have an 
understanding
of how things are supposed to work. Given that this is only a handful of
people so far, I think your name is safe! ;-)

> It would also not work
> with other macros that take symbol names, notably kvm_ksym_ref. But 
> that can be
> rewritten to accept a pointer instead. The more verbose but less magic 
> approach
> is to have a bunch of different helpers for various situations, eg.
> __pa_symbol_nvhe. What would be your preference?

I'd be happy with the (maybe temporary) magic approach. It helps 
reasoning
about things, and makes the transition smoother. Yes, bugs could crop up
there, but given the static nature of obtaining a symbol's address, I'm
fairly confident we'll get it right. The same cannot be said about 
pointers
though.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
