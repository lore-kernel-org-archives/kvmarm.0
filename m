Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3E5C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:07:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 677722070B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:07:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6yyGhX+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 677722070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC7EC4B4F1;
	Thu, 30 Jul 2020 11:07:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tz9P26KB1qoF; Thu, 30 Jul 2020 11:07:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6C9E4B4D0;
	Thu, 30 Jul 2020 11:07:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E0A4B4BA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:07:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dPD5qpzTkGqk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:07:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 378894B1E1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:07:01 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1F8D12070B;
 Thu, 30 Jul 2020 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596121620;
 bh=2cE+kbLpOts0B1H9okA48y/O+7v78nHS9paeuw0zlK8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=I6yyGhX+Waurfa9rjMJ87C5/+IFX96QqLkPWtgkSlsULoW9VZ2lXqQX7TXIwj7OXt
 HLorYX+N/itj5yKH+OkhwoKZA6xCBHLZ7vs5897y5AY9voiomR77PxO1aGXFeBU8R9
 7CRQp9MOPnt3lcV+zvaEoBsOd+Pr+yytNCcMyhTo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k1A94-00GI2X-El; Thu, 30 Jul 2020 16:06:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 0/4] KVM: arm64: Fixes to early stage-2 fault handling
Date: Thu, 30 Jul 2020 16:06:40 +0100
Message-Id: <159612157906.1738719.9299491828902035100.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200729102821.23392-1-will@kernel.org>
References: <20200729102821.23392-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

On Wed, 29 Jul 2020 11:28:17 +0100, Will Deacon wrote:
> This is version two of the patches I posted last week:
> 
>   https://lore.kernel.org/r/20200724143506.17772-1-will@kernel.org
> 
> I got my brain in a twist with exactly what is reported in HPFAR for
> a stage-2 abort on a stage-1 table walk, so I don't think any of these
> are serious any more.
> 
> [...]

Applied to kvm-arm64/misc-5.9, thanks!

[1/4] KVM: arm64: Rename kvm_vcpu_dabt_isextabt()
      commit: c9a636f29b5f236441ff059cef0b2fe734c05afd
[2/4] KVM: arm64: Handle data and instruction external aborts the same way
      commit: 84b951a803a5464b0bff2fb1366e96f07f75b066
[3/4] KVM: arm64: Don't skip cache maintenance for read-only memslots
      commit: 54dc0d2404dd7aa0dd4e4f388a65622b68c6eaff
[4/4] KVM: arm64: Move S1PTW S2 fault logic out of io_mem_abort()
      commit: 022c8328dc8021248047b373b9f67790641b8f2d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
