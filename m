Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F3E28E8
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 09:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D72C433B5;
	Mon,  7 Nov 2022 09:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667812594;
	bh=/w3KQ4ekRSwyFLr5poURdPuohsmeyxZIMN9hwP3KB9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IV2EqG/iDyOasW7fQPb8t20iKMKHK/mX8DiflB4092cKaA3eMU+atzIPq2VA3Xan1
	 4xbV53kvYn1t6aON6U9jAIsGZJDYEe9sQPd691ohQhVIMHdShobz2W/5pxut05HlgH
	 MkJ8rbqHYyQwUH6URlk6jkMBNJKjLRUm1m1XIZxEQnF4vVDXIP34CnYSInCQfm+WnE
	 gHmx5HltItlAd1ZISC+kGKgT5qrRxzJkpe8X5WTllvQmOMEzgjRx37b52LITXdfdSw
	 /NeygurmvcJQ8Cko1QDitI8c0thREK9nKnFlg0UuZwwuOiVDBJjhOkZwCy7wRFybzY
	 X6HGDITYwFHQg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1orxuE-004KxX-NP;
	Mon, 07 Nov 2022 08:54:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	<kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ricardo Koller <ricarkol@google.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v3 14/14] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the guest
Date: Mon,  7 Nov 2022 08:54:35 +0000
Message-ID: <20221107085435.2581641-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221107085435.Bf0PPZoFSJrEGl8S4RdMsT9k32O4jfQJEO-mMC7ZcWk@z>

Now that the infrastructure is in place, bump the PMU support up
to PMUv3p5.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index dc163e1a1fcf..26293f842b0f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1059,6 +1059,6 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	tmp = cpuid_feature_cap_perfmon_field(tmp,
 					      ID_AA64DFR0_EL1_PMUVer_SHIFT,
-					      ID_AA64DFR0_EL1_PMUVer_V3P4);
+					      ID_AA64DFR0_EL1_PMUVer_V3P5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
 }
-- 
2.34.1

