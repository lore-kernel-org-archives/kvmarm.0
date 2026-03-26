Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10AC4035CB;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539336; cv=none; b=Xi0Ye3R1nSGsh/AVhWAjAvO5QDvPyv2UbjvafFWzkE09STST4CE18YQzCjmOb/zbaTZ4WsaCI/KgniWrW1FrsUveI+tOJ79wNIbDnfjF4t4Wlc3whU4RuWrrl0/+rjfD3X34y2hauSu6GOF0XzkBFwabiLdRs6FhBStOlxoGa2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539336; c=relaxed/simple;
	bh=2qFqwaEfjkfonQCEJHd6t4DHT0B1l3UAc3R8lLUcmVg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jfuFbrh54IDa9Il77cKQ9pb82TGffhDpJeG5hk+ZgttBdex0b+V9PlOnux8v2iYPqTfDXpe94LKrA0CZclavYp9HhqDHk343XI3bUL1fmL4JmHI2erAl/ZF1Fbp9GYA2FTibOazZOQ8REpj0Uyt/1LpekKjWcqB183Brf7yocUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oPns00bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oPns00bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDA2C2BCB0;
	Thu, 26 Mar 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539336;
	bh=2qFqwaEfjkfonQCEJHd6t4DHT0B1l3UAc3R8lLUcmVg=;
	h=From:To:Cc:Subject:Date:From;
	b=oPns00bvIJX0a6WpQMR7SRs8rm/MJV4uSn3ne+1IvspE4KRR/Jp0TZluxF4Xx4xFE
	 k0U6XSjlv1J+9+0Fr+j2vdYkynPpy32GMSu1HzqrH+GC3axVXweoCz51hGw3mjStvQ
	 se068+X1xYcVk1vVCmkXU5KeC7cmdKZrEO84I70ZMlQumlymMye5yiakI/MD/KJNoL
	 ZzbSM90qUrscSR7aBR+qSIiLWwjdPu/DaTpe84/2Hnmo9CX/ZSwiwmeKa0077pdEgd
	 XL9ygfsaVx9e7UANw3D3jLuzJxOoDlW++Cfer52ma23Accjh9xiUbfy/Czvy2sUb4U
	 AYCF9Iy2D42YQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkA-000000060II-0p62;
	Thu, 26 Mar 2026 15:35:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 00/15] KVM: arm64: First batch of vgic-v5 related fixes
Date: Thu, 26 Mar 2026 15:35:15 +0000
Message-ID: <20260326153530.3981879-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Well, merging the first batch of vgic-v5 patches didn't go smoothly at
all. We initially found a couple of regressions, but most of the crap
was actually uncovered by everyone's new best friend (enemy?), the AI
bot sitting behind sashiko.dev [1].

While not all of the remarks were valid, a bunch of them were actually
extremely pertinent, and resulted in me frantically hacking away at
the series. Hopefully the bot doesn't find even more issues in the
fixes. Note that the first patch has already been posted and merged,
and is only here for reference.

Note that given the amount of rework, I'm really in two minds between
adding these patches on top, or pulling the whole series for another
cycle. I guess time will tell.

[1] https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com

Marc Zyngier (15):
  KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
  KVM: arm64: Don't skip per-vcpu NV initialisation
  arm64: Fix field references for ICH_PPI_DVIR[01]_EL2
  KVM: arm64: Fix writeable mask for ID_AA64PFR2_EL1
  KVM: arm64: Account for RESx bits in __compute_fgt()
  KVM: arm64: vgic-v5: Hold config_lock while finalizing GICv5 PPIs
  KVM: arm64: vgic-v5: Transfer edge pending state to ICH_PPI_PENDRx_EL2
  KVM: arm64: vgic-v5: Cast vgic_apr to u32 to avoid undefined
    behaviours
  KVM: arm64: vgic-v5: align priority comparison with other GICs
  KVM: arm64: vgic-v5: Correctly set dist->ready once initialised
  KVM: arm64: Kill arch_timer_context::direct field
  KVM: arm64: Remove evaluation of timer state in
    kvm_cpu_has_pending_timer()
  KVM: arm64: Move GICv5 timer PPI validation into
    timer_irqs_are_valid()
  KVM: arm64: Correctly plumb ID_AA64PFR2_EL1 into pkvm idreg handling
  KVM: arm64: Don't advertises GICv3 in ID_PFR1_EL1 if AArch32 isn't
    supported

 arch/arm64/kvm/arch_timer.c        | 32 +++++++++++++-----------------
 arch/arm64/kvm/config.c            |  4 ++--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  2 +-
 arch/arm64/kvm/sys_regs.c          | 20 +++++++++----------
 arch/arm64/kvm/vgic/vgic-init.c    | 32 ++++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v5.c      | 24 +++++++++++++++++-----
 arch/arm64/tools/sysreg            |  4 ++--
 include/kvm/arm_arch_timer.h       |  3 ---
 8 files changed, 70 insertions(+), 51 deletions(-)

-- 
2.47.3

