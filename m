Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72906C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 19:59:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E704B240;
	Thu, 28 Apr 2022 15:59:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uMd7sDGeRNJ4; Thu, 28 Apr 2022 15:59:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA96A4B248;
	Thu, 28 Apr 2022 15:59:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 550224B230
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 15:59:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g4465PPzQ3Yh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 15:59:10 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E6374B1EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 15:59:10 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 04D3CCE2DAD;
 Thu, 28 Apr 2022 19:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561D2C385AF;
 Thu, 28 Apr 2022 19:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651175940;
 bh=2VpuXfSni30Kb/eTw7UZLyG2wBlPNOJWkggE1bbFFCE=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=DVDCnGs+zqo2oLW52P6WQB/+50WL+4HDCfG9fI9/Gba5nc9y5zW2ucTmC4TQsEm+K
 SecChsBnoav7wo53YNj5wrGJc3a1SRogPz9ErxmMZiszJfQTnYBwXXTtFrcsO4+H0G
 q+q+YNKncBWM/wXcKf6ysHqmFKKTt5CSchjG/xK0AJpSdOSY4nhLWhmRoDTHZzHwlL
 OrHzT8/7kDigQMDU8ntPSOhBwB9H4somfY9++KgwwcqIEye3YIS62iHzoEQxuCsMny
 GvEJC0p3mkN+rVdjmOOtcHJXGzSyJiCh/mjgvgMPx2qUGMB56ulmgVoVjrqnwgJO/V
 7lrO103GhcHIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nkAHy-007lBY-0K; Thu, 28 Apr 2022 20:58:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>, james.morse@arm.com,
 suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM/arm64: Don't emulate a PMU for 32-bit guests if
 feature not set
Date: Thu, 28 Apr 2022 20:58:54 +0100
Message-Id: <165117592520.3115569.6681600496977267947.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220425145530.723858-1-alexandru.elisei@arm.com>
References: <20220425145530.723858-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com,
 james.morse@arm.com, suzuki.poulose@arm.com
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

On Mon, 25 Apr 2022 15:55:30 +0100, Alexandru Elisei wrote:
> kvm->arch.arm_pmu is set when userspace attempts to set the first PMU
> attribute. As certain attributes are mandatory, arm_pmu ends up always
> being set to a valid arm_pmu, otherwise KVM will refuse to run the VCPU.
> However, this only happens if the VCPU has the PMU feature. If the VCPU
> doesn't have the feature bit set, kvm->arch.arm_pmu will be left
> uninitialized and equal to NULL.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM/arm64: Don't emulate a PMU for 32-bit guests if feature not set
      commit: 8f6379e207e7d834065a080f407a60d67349d961

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
