Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3A5C43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:18:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 950B7206D4
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:18:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vlBR8so8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 950B7206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11AD84B0F3;
	Fri,  4 Sep 2020 06:18:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6fr2V-kpdXB5; Fri,  4 Sep 2020 06:18:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A73FF4B300;
	Fri,  4 Sep 2020 06:18:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E329A4B124
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:18:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4HjKOPvsqloz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 06:18:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 010D14B0F3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:18:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C484F206D4;
 Fri,  4 Sep 2020 10:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599214708;
 bh=wiOJ/0KSbi3Zwox2+g8TOpETDOK8VgS09mO0+Uvw2lo=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=vlBR8so8LeeFg+cdgJhioO7vbCWDEUORu0ntKRqt9sLFHzYztoEonzC/BeX97VwZC
 pYVwxVOWg0L4umk7/mCCfOimE0GJTyT/Ickc57s2iAMvFFT1HlgkLBn1ry5NQ6M5hD
 Xj8t2zyJ5gNtSNRk1Co2GUf250TK4xaWhJz0MYMA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kE8nb-0098F0-7h; Fri, 04 Sep 2020 11:18:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 0/2] KVM: arm64: user_mem_abort() improvements
Date: Fri,  4 Sep 2020 11:18:20 +0100
Message-Id: <159921467170.1081927.3513898210020479477.b4-ty@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200901133357.52640-1-alexandru.elisei@arm.com>
References: <20200901133357.52640-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Tue, 1 Sep 2020 14:33:55 +0100, Alexandru Elisei wrote:
> The first patch is a fix for a bug that I found by code inspection.
> 
> The second patch is an enhancement for the way user_mem_abort() handles
> hugetlbfs backed VM memory.
> 
> Tested on a rockpro64 with 4K pages and hugetlbfs hugepagesz=1G (PUD sized
> block mappings).  First test, guest RAM starts at 0x8100 0000
> (memslot->base_gfn not aligned to 1GB); second test, guest RAM starts at
> 0x8000 0000, but is only 512 MB.  In both cases using PUD mappings is not
> possible because either the memslot base address is not aligned, or the
> mapping would extend beyond the memslot.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Update page shift if stage 2 block mapping not supported
      commit: 7b75cd5128421c673153efb1236705696a1a9812

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
