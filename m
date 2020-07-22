Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51BDC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:36:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A802206C1
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFd11XXd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A802206C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3D484B194;
	Wed, 22 Jul 2020 12:36:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V3ssd+WP4dFD; Wed, 22 Jul 2020 12:36:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19F6E4B20C;
	Wed, 22 Jul 2020 12:36:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98D9D4B16D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:36:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oPQQZbgDRDyw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:36:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F43E4B194
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:36:36 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 89126206C1;
 Wed, 22 Jul 2020 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595435795;
 bh=RRNwRkB4H209C3u0y4jLhx8pKepXqEgfppWV76SZML4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=cFd11XXdI2/GMhydrlLYi1B5d/nf7hYRlp56nHeAD2UUpsLXKh8Fm/NhjPEuUb0ih
 Um9cl+CmUJGHnQdKMmcZuXEHcVrlA1ZUb2/Y/E3IywPUhZyjQ/1EVDuA/x2FgBbMm5
 J7jDDd3Q+aQkxMWDPF+RAT/l7+ay1ApYIxqmXePU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jyHjO-00E1ch-52; Wed, 22 Jul 2020 17:36:34 +0100
MIME-Version: 1.0
Date: Wed, 22 Jul 2020 17:36:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 0/4] Manage vcpu flags from the host
In-Reply-To: <20200722162429.GP30452@arm.com>
References: <20200713210505.2959828-1-ascull@google.com>
 <20200722162429.GP30452@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <7cbc5c0450035a576d87bf4821dc36a0@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Dave.Martin@arm.com, ascull@google.com,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On 2020-07-22 17:24, Dave Martin wrote:
> On Mon, Jul 13, 2020 at 10:05:01PM +0100, Andrew Scull wrote:
>> The aim is to keep management of the flags in the host and out of hyp
>> where possible. I find this makes it easier to understand how the 
>> flags
>> are used as the responsibilities are clearly divided.
>> 
>> The series applies on top of kvmarm/next after VHE and nVHE have been
>> separated.
> 
> (A commit ID would be useful for someone trying to the patches.)
> 
>> From v1 <20200710095754.3641976-1-ascull@google.com>:
> 
> (Nit: Is there some easy way of looking up mails by Message-ID?
> 
> Otherwise, it can be helpful to have a mail archive URL here, e.g.,
> lore.kernel.org)

I routinely use https://lore.kernel.org/r/<msgid>, which does
the right thing.  But indeed, including the link directly is
the preferred course of action, and saves having to assemble
the URL by hand.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
