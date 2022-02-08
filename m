Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFA7C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:37:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 513294A0FC;
	Tue,  8 Feb 2022 12:37:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I3LSLo12R921; Tue,  8 Feb 2022 12:37:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D44D4B0FB;
	Tue,  8 Feb 2022 12:37:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CECD4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OaZYIfUj955l for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:37:23 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A72C4A19F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:23 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B4601B81CA5;
 Tue,  8 Feb 2022 17:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8D6C004E1;
 Tue,  8 Feb 2022 17:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644341840;
 bh=RhMEptw39XyE9fgL+v/UC/IxcD6A1g7uJsr86bhiK/E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=idEX234e8xdEQJoqSOBCwSpzG/SKKEUhiMvYEGJJy50uRo1mZcs6mFJwSkQQMynAV
 J2mzUz4aMiS0Mh79bSo+wNzrPjsdDuUnTLddPZ0VkOOTdutRG9V+er6RC0MjD7HJ1J
 qIQm/4LYB0QIszmG2kaWfr+DdeSlwZZBMwbGfmuRctNdb/GZM1aAneypoXYAXOFJBS
 yJmaMR9TxNZcXSn1DY6pUPrZiQ3caKclA31V9uMr0ImmM4J9AdDvmqm1I7aqm4YI6D
 TnuPBASwLSl6/gN3TKhnxfgjz1ITKfzVatGRVf0M7sFnpGMCKAW65R1a/iw4dvLjEx
 DpA3qEUYxakGg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nHUQY-006Krz-LA; Tue, 08 Feb 2022 17:37:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v1 0/2] KVM: arm64: Additional documentation of the FP code
Date: Tue,  8 Feb 2022 17:37:14 +0000
Message-Id: <164434147327.3931943.3810495237551896674.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124155720.3943374-1-broonie@kernel.org>
References: <20220124155720.3943374-1-broonie@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: broonie@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, 24 Jan 2022 15:57:18 +0000, Mark Brown wrote:
> These couple of patches add a few more comments to the floating point
> code which will hopefully help the next person who comes along and tries
> to figure out what is going on.
> 
> Mark Brown (2):
>   KVM: arm64: Add comments for context flush and sync callbacks
>   KVM: arm64: Add some more comments in kvm_hyp_handle_fpsimd()
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Add comments for context flush and sync callbacks
      commit: 23afc82539cfcce105bf18c5c835c75e463ca349
[2/2] KVM: arm64: Add some more comments in kvm_hyp_handle_fpsimd()
      commit: 01a244decc760b1ae2caa045647d79ff431bf37b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
