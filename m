Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9465C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:00:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72394208E4
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5IJLLQg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72394208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F1C4B377;
	Fri, 31 Jul 2020 04:00:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5vSy2RnbM2qJ; Fri, 31 Jul 2020 04:00:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFEF04B3E0;
	Fri, 31 Jul 2020 04:00:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93D1B4B3C3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:00:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O6yZDkwJzGSe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 04:00:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D6944B377
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:00:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2E6D12173E;
 Fri, 31 Jul 2020 08:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596182405;
 bh=OdvgGmHi3Zbs34BmxHk1ofD76DInfnuq0Li/8r79EV0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=T5IJLLQgxf9SbcoVwVh1wNm1naj7y+YtXlvhZqd0MVAlJpiZ2fwsbR74vM5gXINig
 TdbJMCd04JkNhcAjlLzIRPCqlkiSgVA9XDyZMIVLRhvcBFSBtlaw1Uctwjo2VQq14O
 GvY9CrqPomuOs/VrJWjBPZXc/I/5R9QUUZCJs/E8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k1PxT-00GTCf-Jn; Fri, 31 Jul 2020 09:00:03 +0100
MIME-Version: 1.0
Date: Fri, 31 Jul 2020 09:00:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
In-Reply-To: <20200730223144.GA2022880@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <20200730223144.GA2022880@google.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <8d469be9de5ce825ffeacdb530731591@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
 will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, catalin.marinas@arm.com, will@kernel.org,
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

Hi Andrew,

On 2020-07-30 23:31, Andrew Scull wrote:
> On Thu, Jul 30, 2020 at 04:18:23PM +0100, Andrew Scull wrote:
>> The ESB at the start of the vectors causes any SErrors to be consumed 
>> to
>> DISR_EL1. If the exception came from the host and the ESB caught an
>> SError, it would not be noticed until a guest exits and DISR_EL1 is
>> checked. Further, the SError would be attributed to the guest and not
>> the host.
>> 
>> To avoid these problems, use a different exception vector for the host
>> that does not use an ESB but instead leaves any host SError pending. A
>> guest will not be entered if an SError is pending so it will always be
>> the host that will receive and handle it.
> 
> Thinking further, I'm not sure this actually solves all of the problem.
> It does prevent hyp from causing a host SError to be consumed but, 
> IIUC,
> there could be an SError already deferred by the host and logged in
> DISR_EL1 that hyp would not preserve if a guest is run.
> 
> I think the host's DISR_EL1 would need to be saved and restored in the
> vcpu context switch which, from a cursory read of the ARM, is possible
> without having to virtualize SErrors for the host.

The question is what do you if you have something pending in DISR_EL1
at the point where you enter EL2? Context switching it is not going to
help. One problem is that you'd need to do an ESB, corrupting DISR_EL1,
before any memory access (I'm assuming you can get traps where all
registers are live). I can't see how we square this circle.

Furthermore, assuming you find a way to do it, what do you do with it?

(a) Either there was something pending already and it is still pending,

(b) Or there was nothing pending and you now have an error that you
     don't know how to report (the host EL1 never issued an ESB)

We could just error out on hypercalls if DISR_EL1 is non-zero, but
I don't see how we do that for traps, as it would just confuse the host
EL1.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
