Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240A5C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 15:48:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C433B2084C
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 15:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTcXyzee"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C433B2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E44D4B262;
	Mon, 25 May 2020 11:48:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qLTa3CZDJeiD; Mon, 25 May 2020 11:48:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 608F04B22B;
	Mon, 25 May 2020 11:48:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE1D4B1F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 11:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CbeOv9xgutaF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 11:48:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E045A4B200
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 11:48:21 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0271C207D8;
 Mon, 25 May 2020 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590421701;
 bh=N64AAieCFNKsupOv15QMm5WksqcdlYTBULH/wOivY3w=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tTcXyzee8xvOIAzI1WDooZ0r8m41ecZFYxpKyNiZCAx0DTGhGOLphpJNU2rsSpMaO
 huIbYmZGchpA8yS4dd5XpkeK3YLzdObE4kkqv1lk1u8AprxmA8Tr3RFcryRVCmNR9p
 BjN9grh7za0o+INyqftI7YYmxaZV/Ip66TamIX0A=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jdFKt-00FCJb-Ep; Mon, 25 May 2020 16:48:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH] arm64: kvm: Fix incorrect comment on kvm_get_hyp_vector()
Date: Mon, 25 May 2020 16:48:14 +0100
Message-Id: <159042163819.423883.8265784934325308577.b4-ty@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515152550.83810-1-dbrazdil@google.com>
References: <20200515152550.83810-1-dbrazdil@google.com>
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

On Fri, 15 May 2020 16:25:50 +0100, David Brazdil wrote:
> The comment used to say that kvm_get_hyp_vector is only called on VHE systems.
> In fact, it is also called from the nVHE init function cpu_init_hyp_mode().
> Fix the comment to stop confusing devs.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20200515152550.83810-1-dbrazdil@google.com
> 
> [...]

Applied to kvmarm-master/next, thanks!

[1/1] KVM: arm64: Fix incorrect comment on kvm_get_hyp_vector()
      commit: 438f711ce1d889632467be80779c8f5762b107d7

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
