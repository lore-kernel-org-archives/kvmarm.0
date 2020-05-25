Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E742C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 15:48:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F65320812
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 15:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqvGp0CS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F65320812
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB704B250;
	Mon, 25 May 2020 11:48:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HS2gGx7YN7to; Mon, 25 May 2020 11:48:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E0D74B205;
	Mon, 25 May 2020 11:48:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBE224B205
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 11:48:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HZg5vA0XEF3F for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 11:48:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEB814B1F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 11:48:21 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AAA7D207CB;
 Mon, 25 May 2020 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590421700;
 bh=+XKSimPGeCz0W1CMEwgJoWin6kbwXNT1qTSNuAPAw24=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YqvGp0CSkmi7E99dorkU+Ghw2OZpOExzchApOcn49k0dIN041CDW/IkeIYyprRnN6
 lQniwUChGNVBImRKPKHciFDG/Z6PQS4VYAK8HtZeqJ1B2mjrXf11xSkvsq/Ef8pBQE
 cT7DQc8BBvcF8UYEHhDa23EtameHdjpvZeNy9aLo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jdFKt-00FCJb-4L; Mon, 25 May 2020 16:48:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH] arm64: kvm: Clean up cpu_init_hyp_mode()
Date: Mon, 25 May 2020 16:48:13 +0100
Message-Id: <159042163820.423883.9671590581057422816.b4-ty@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515152056.83158-1-dbrazdil@google.com>
References: <20200515152056.83158-1-dbrazdil@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

On Fri, 15 May 2020 16:20:56 +0100, David Brazdil wrote:
> Pull bits of code to the only place where it is used. Remove empty function
> __cpu_init_stage2(). Remove redundant has_vhe() check since this function is
> nVHE-only. No functional changes intended.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20200515152056.83158-1-dbrazdil@google.com
> 
> [...]

Applied to kvmarm-master/next, thanks!

[1/1] KVM: arm64: Clean up cpu_init_hyp_mode()
      commit: 71b3ec5f221b8b3ff545639be83ddfcd5d7c9800

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
