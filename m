Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F59E3F1667;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039792; cv=none; b=EANQBTDIjcs5gQGV+/baDUXQJ47bakH+p6lHwJK3YvnvzF7MEO/lGmRIM6XTaA3Rcvb6PE7bIKPXi4pWYMYLkNOWr1pPRRCT4kfybFKlfEaVbnOFmZOAzM1PE7fElKvMWix4K5dA4OUoDgF7/XT7lgxVQg6paysEIbJN58N3L1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039792; c=relaxed/simple;
	bh=xtvnTDSUGx89lzG8mtjye1LfgZ1vl+5viyWjfbbqRxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsXtt/7OC38ojK6yG/5KfERLeiiri5gBBCT6pRs8i2MX0ZHfm/RVLQPHZNPHVXQscon5vuXTY1p3j5lQJLq5vxZ+FTRiwnKDeSETy7aiUkHJ/E1JeapvB7rLIYyHg/YHR5I0P5hbp1F6S1+HwAeCwmzTClwT9uAnLiuxf7Awl0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOvVH7mN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOvVH7mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAD9C2BCB5;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039792;
	bh=xtvnTDSUGx89lzG8mtjye1LfgZ1vl+5viyWjfbbqRxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOvVH7mNXfyBK1Q8QeaW5W/W0DB7uVts37OEPb/rfAHs3J84QiqIgcGlnhJXcPN7B
	 ITMelKySZ3WU3k2pnEXTeq797KcUj6nckJh2VKtCP2fePC04AXbk9AIaVE/6oPQFc/
	 oxQGdDWfxwKOhDiipi5+QOC1zBcM1IcroUGgAGbb1TW5UrfnKacXcjxW0oUIUmtuht
	 /EGvJl2zcY+38M/xqqpBUriRd0GSKUcdXaSkGoyd7abHx4OMw3zh3wJVceB1eo8ZUh
	 Vz3qOBInMOd4mN0/YDtAHBAmqdQxCK7loKSN2a0KTJXw5t3ItFrQ5GbXxAID1EFESP
	 QVdkjVLE24bcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw2-00000007oRQ-1HXS;
	Wed, 01 Apr 2026 10:36:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 05/16] KVM: arm64: Account for RESx bits in __compute_fgt()
Date: Wed,  1 Apr 2026 11:36:00 +0100
Message-ID: <20260401103611.357092-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When computing Fine Grained Traps, it is preferable to account for
the reserved bits. The HW will most probably ignore them, unless the
bits have been repurposed to do something else.

Use caution, and fold our view of the reserved bits in,

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Fixes: c259d763e6b09 ("KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index e14685343191b..f35b8dddd7c1f 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1663,8 +1663,8 @@ static __always_inline void __compute_fgt(struct kvm_vcpu *vcpu, enum vcpu_sysre
 		clear |= ~nested & m->nmask;
 	}
 
-	val |= set;
-	val &= ~clear;
+	val |= set | m->res1;
+	val &= ~(clear | m->res0);
 	*vcpu_fgt(vcpu, reg) = val;
 }
 
-- 
2.47.3

