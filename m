Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDE4C53210
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 17:56:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7384B4BA64;
	Tue,  3 Jan 2023 12:56:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VC8wQgAmj+Oc; Tue,  3 Jan 2023 12:56:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 643C84BA88;
	Tue,  3 Jan 2023 12:56:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73AE54BA34
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 12:56:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z1VCwMisdiy8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 12:56:27 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FF53411D3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 12:56:27 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1D40F61478;
 Tue,  3 Jan 2023 17:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79571C433D2;
 Tue,  3 Jan 2023 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672768585;
 bh=UC4RdBvcPnI5XJhhZ46pv1YotwVqygpNpSpelRcjc+k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dNq2WgLp6fiiAgRTQt9iNPOZmuaaRoeBfgUewesNE5DImDRlCrMbjbqSMDDiIsrFy
 fQ83YDSZTq659bmYpz0aXisuvux6mnraKOdoQTbm8JpDuEzCHDkdZCh0Mmds2rOQr4
 zwjr57RrWgKHYZBAU2oGsX+AOLkodvGX+nd5XUGzF+g2U5a6wQmmlHrkb/NpGNyF1g
 jiab5756EaFtBNsVqKqCW7kzfCZqz0E0E9J4T6flkSFrvguURllYJpT8ZFXEwxrudf
 t41+RiIxV47Yxh5zw0ecjSLfdvnlD3015xQwGTLefok2gZH6Usex2tz5xk+tFQ/HKP
 hD7KRz4wXqP0A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pClWR-00Ga6w-6F;
 Tue, 03 Jan 2023 17:56:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev
Subject: Re: (subset) [PATCH 0/3] KVM: arm64: M2 vgic maintenance interrupt
 rework pre-NV
Date: Tue,  3 Jan 2023 17:56:19 +0000
Message-Id: <167276854454.3239244.7195924669135808939.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230103095022.3230946-1-maz@kernel.org>
References: <20230103095022.3230946-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 kvmarm@lists.linux.dev, suzuki.poulose@arm.com, linux-kernel@vger.kernel.org,
 oliver.upton@linux.dev, alyssa@rosenzweig.io, catalin.marinas@arm.com,
 marcan@marcan.st, sven@svenpeter.dev, alexandru.elisei@arm.com,
 tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, will@kernel.org,
 asahi@lists.linux.dev, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Hector Martin <marcan@marcan.st>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Sven Peter <sven@svenpeter.dev>,
 Thomas Gleixner <tglx@linutronix.de>, Alyssa Rosenzweig <alyssa@rosenzweig.io>,
 asahi@lists.linux.dev
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

On Tue, 3 Jan 2023 09:50:19 +0000, Marc Zyngier wrote:
> I've spent the holiday break reviving the Nested Virt KVM/arm64
> implementation[1] and allowing it to work on the Apple M2 SoC. The
> amusing part is that it actually works!
> 
> However, the way the vgic is implemented on this HW is still at odds
> with the rest of the architecture, and requires some hacks, some of
> which are independent of the actual NV code. This is what this series
> is about.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: vgic: Add Apple M2 cpus to the list of broken SEIS implementations
      commit: 4f6202c9fb51cc6a2593ad37d8ddff136b7acef2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
