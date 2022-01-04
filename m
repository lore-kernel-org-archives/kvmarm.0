Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C8DC4332F
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 17:18:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72CE74A0FD;
	Tue,  4 Jan 2022 12:18:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qF4C3oynuIO0; Tue,  4 Jan 2022 12:18:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 619DE49F43;
	Tue,  4 Jan 2022 12:18:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D91E649F43
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 12:18:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iIMiWHtNpUZt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 12:18:35 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9CF849EFE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 12:18:35 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 84B83B8179E;
 Tue,  4 Jan 2022 17:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F5CC36AED;
 Tue,  4 Jan 2022 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1641316713;
 bh=UkZFEDb4tbKzvcbyZHYlvNAxkPyB5nrD6sI05Eqzrxs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=t8nCcaZoMJpJjkAnP/295K453uXOowW5+h53HDseFaAudgqbpdgEDDf/VZ/qRPM5u
 xM/gEswIQSU5d7mW6S6XrKt7xMY8QTg7B7Lbyuy/JepqtGbW+3NUY30O7+ZBVHj3sU
 X5GsgO/3sQqcmj+FSpW9yiUrY86Cdd98bO3XJAO8EQutZEx71sOYtFuQg3lOUm3I38
 vVTlV9kBo/BYG8V1hvaAbGoMlspamoDRebRMygF4uug87QdXl+EpBnrdJ2A9Kxkx6B
 +VT2RZ+e8x6L8+D/LT21Gk2DXMd41HKH1MczRkQNgz19+k0fqina6zFbBAmoh/+BZX
 u8amhnVle7Jyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n4nSB-00Fy9A-2X; Tue, 04 Jan 2022 17:18:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: vgic: Replace kernel.h with the
 necessary inclusions
Date: Tue,  4 Jan 2022 17:18:23 +0000
Message-Id: <164131669019.3722270.11121664995774113019.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104151940.55399-1-andriy.shevchenko@linux.intel.com>
References: <20220104151940.55399-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 andriy.shevchenko@linux.intel.com, linux-arm-kernel@lists.infradead.org,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, james.morse@arm.com
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

On Tue, 4 Jan 2022 17:19:40 +0200, Andy Shevchenko wrote:
> The arm_vgic.h does not require all the stuff the kernel.h provides.
> Replace kernel.h inclusion with the list of what is really being used.

Applied to next, thanks!

[1/1] KVM: arm64: vgic: Replace kernel.h with the necessary inclusions
      commit: 6c9eeb5f4a9bb2b11a40fd0f15efde7bd33ee908

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
