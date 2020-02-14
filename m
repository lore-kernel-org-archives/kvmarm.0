Return-Path: <SRS0=Bd71=4C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134C1C2BA83
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 14:19:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91BF122314
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 14:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/cKO9Kz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91BF122314
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 323944AE96;
	Fri, 14 Feb 2020 09:19:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id frOYc9GlgEP9; Fri, 14 Feb 2020 09:19:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051864AE99;
	Fri, 14 Feb 2020 09:19:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 051B64ACB7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 09:19:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PoEAnGWimt0R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Feb 2020 09:19:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17A424AC88
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 09:19:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D74DA206B6;
 Fri, 14 Feb 2020 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581689961;
 bh=VoFhf4zdTOyDrs9WxiWbFkep8aWMI/NkIQEpLgdHAjA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=o/cKO9Kz9b3Kp6vLs8dIkD6hDZk6Nk1UAyhUHiYMLMjNuRAwzomQ88YU8iOzL1PF2
 BN9xazvXxB89FbP08V43JOG1fOOQIGxzL6t4zCacfGcJzeO+qD0tvhZJB1HlsYGXeI
 BfGzCJyIgaGqAUbm4qgMvOlLxp8n64SA7NokBH2I=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j2boN-0057Sx-21; Fri, 14 Feb 2020 14:19:19 +0000
MIME-Version: 1.0
Date: Fri, 14 Feb 2020 14:19:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] arm64: kvm: Annotate assembly using modern annoations
In-Reply-To: <20200214114027.GA4827@sirena.org.uk>
References: <20200213153820.32049-1-broonie@kernel.org>
 <b25323d02c76441ee12c206f07907383@kernel.org>
 <20200214114027.GA4827@sirena.org.uk>
Message-ID: <e8e8da7f1e02e9c2f8e67968697bdf85@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-02-14 11:40, Mark Brown wrote:
> On Thu, Feb 13, 2020 at 09:36:56PM +0000, Marc Zyngier wrote:
>> On 2020-02-13 15:38, Mark Brown wrote:
> 
>> > -ENTRY(__kvm_call_hyp)
>> > +SYM_FUNC_START(__kvm_call_hyp)
> 
>> I'm not convinced by this particular change. _kvm_call_hyp is called
>> directly from
>> C, and behaves almost like a normal function. What's the issue here?
> 
> I'm not sure I understand your comment here - this is annotated as
> SYM_FUNC_ which is the annotation for things that look like normal
> C functions.

You're right, apologies. I got confused between _FUNC_ and _CODE_.

> 
>> >  	.align	11
>> > -ENTRY(__bp_harden_hyp_vecs_start)
>> > +SYM_CODE_START_NOALIGN(__bp_harden_hyp_vecs)
>> > +SYM_INNER_LABEL(__bp_harden_hyp_vecs_start, SYM_L_GLOBAL)
> 
>> Why isn't SYM_CODE_START_NOALIGN enough? And what is the rational for
> 
> The _start and _end labels that were there before are explicitly
> referenced by code, removing them would break the build.

But if we're going to clean things up, I'd rather we actually do that.
The only time __bp_harden_hyp_vecs_end is used is when computing the
size of the vectors, and that'd better be BP_HARDEN_EL2_SLOTS * 2kB
(which can be statically asserted at compile time).

> 
>> the _NOALIGN, btw? I'd expect an alignment of 2kB to be more than 
>> enough.
> 
> So that the explicit .align above takes effect rather than anything the
> macro decides to do, I'm trying to err on the side of caution here.

I don't think we need this. The macros should do the right thing, and
be fixed if they don't.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
