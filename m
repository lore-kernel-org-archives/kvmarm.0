Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14ABC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 15 May 2022 10:57:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42F034B1C4;
	Sun, 15 May 2022 06:57:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZovREMhQXVAt; Sun, 15 May 2022 06:57:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2419D4B10A;
	Sun, 15 May 2022 06:57:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FED349E42
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 06:57:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eE77wn9HEpvk for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2022 06:57:36 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5418849E36
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 06:57:36 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3897C60F42;
 Sun, 15 May 2022 10:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0B4C385B8;
 Sun, 15 May 2022 10:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652612254;
 bh=pi03VEKNrViqX/TFOKodc1nns+aTQhhhfd/QEcfbuhQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GLMvkWmcRShJE0q3JMiWvyCOuowXm7PAbQ35r4FsJ/VNcbusr5yx5fnvzOO6uQAaG
 QlSInY4mkJvO4iMqP9Vj4f0dQxvrC4+wwygE0dn4j2tylNMTLQyTdFbWa4tRXY0FrW
 UrNE9QSBZJOY3+mx9y4hBXkeuCJTBkgitzJgfNNo2al9+wzLpERGYuyWZa463wgqMI
 6WWdBpGcpCx4cZX6OEEUzMGvqwLB6/AswL0Qysac3gBZj4NjCRgPNyFk8jyaUvXDk0
 qGp8zyBPLzxNsutpgCpHl/elgCgWTyJLw4SWLlZw75roR3MUs9AKjf4xQVjnMATYiW
 Nn647jZLzNWpQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nqBwJ-00BPnZ-Tm; Sun, 15 May 2022 11:57:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: arm64: vgic-v3: List M1 Pro/Max as requiring the
 SEIS workaround
Date: Sun, 15 May 2022 11:57:20 +0100
Message-Id: <165261223450.3678424.14361389366792054409.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220514102524.3188730-1-maz@kernel.org>
References: <20220514102524.3188730-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kernel-team@android.com, marcan@marcan.st,
 catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, marcan@marcan.st,
 kernel-team@android.com, Will Deacon <will@kernel.org>
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

On Sat, 14 May 2022 11:25:24 +0100, Marc Zyngier wrote:
> Unsusprisingly, Apple M1 Pro/Max have the exact same defect as the
> original M1 and generate random SErrors in the host when a guest
> tickles the GICv3 CPU interface the wrong way.
> 
> Add the part numbers for both the CPU types found in these two
> new implementations, and add them to the hall of shame. This also
> applies to the Ultra version, as it is composed of 2 Max SoCs.

Applied to next, thanks!

[1/1] KVM: arm64: vgic-v3: List M1 Pro/Max as requiring the SEIS workaround
      commit: cae889302ebf5a9b22ca3580996118b8d20b3ae6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
