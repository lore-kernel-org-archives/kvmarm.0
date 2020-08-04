Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B025C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 08:52:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC8F62075D
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 08:52:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC8F62075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=misterjones.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DEE24B6A3;
	Tue,  4 Aug 2020 04:52:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b7cM1PKHr3hX; Tue,  4 Aug 2020 04:52:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ACE14B62B;
	Tue,  4 Aug 2020 04:52:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C10734B617
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 04:52:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KlJdFO+dW-q0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 04:52:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B80F4B4C5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 04:52:34 -0400 (EDT)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@misterjones.org>)
 id 1k2sgS-00HL1G-R6; Tue, 04 Aug 2020 09:52:32 +0100
MIME-Version: 1.0
Date: Tue, 04 Aug 2020 09:52:32 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Roja Eswaran <reswara1@binghamton.edu>
Subject: Re: Regarding Direct Injection of Virtual LPI in ARMv8 GICv4
In-Reply-To: <CAGTfD8bTpj914KrqY4RzCXQYqxTfGjVApyZRDAV9PrRBAx6+kA@mail.gmail.com>
References: <CAGTfD8bTpj914KrqY4RzCXQYqxTfGjVApyZRDAV9PrRBAx6+kA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <f5ba7437f4da266b0483c2872c2b6b41@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reswara1@binghamton.edu, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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

On 2020-08-03 19:09, Roja Eswaran wrote:
> CAN WE MODIFY TIMER INTERRUPTS OR IPI INTO VIRTUAL LPI AND DIRECTLY
> INJECT THEM IN VM?

[HTML email, all-caps... This is hard to take early in
  the morning, as I only had a single coffee]

No, you cannot route timer interrupts as VLPIs. These
interrupts are hard-wired into the core. For GICv4,
the only thing you can route as VLPI is LPIs.

With GICv4.1, you can directly inject SGIs them into
the guest, but only if you are prepared to forego the
active state.

You're welcome.

         M.
-- 
Who you jivin' with that Cosmik Debris?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
