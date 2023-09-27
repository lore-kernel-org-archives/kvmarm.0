Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0228200D5
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B578BC433D9;
	Wed, 27 Sep 2023 09:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695805759;
	bh=kU23CEv+nBYaQuElLBiPmIVf/MmSLfglEUFHhMry2OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZ+qf0JaaWsBigV0QttbNQRLOaGqMly2id3+fWaRZhxx5e+dJfpnpAOUtK9FZKB2Q
	 adNiindodX1FgdVLvCFCL+ROsssQtqwjmLiIr4ViEGh6zE3BX2L6CBPMGxbGCWU4EQ
	 GFNkp42WOGLK36QRtqMk9F0ANUAsU8ChvzRmtSPXwje3yTg3fdmtLuI1ArsNtIxwp2
	 fCj77hr0N1hsMdX7HDE4qEqrd5rIRr5m4nSzr1yB41UkGegn2f1x4MzMeo2REa/Uyi
	 7jqmsuWT9FEjGxHfS8RD2g79vy1RRGoU85bq3ABHK1il6IASjW+lT/+tBKhQw/+TVL
	 twhW9LiC+vXaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qlQXl-00GaLb-KP;
	Wed, 27 Sep 2023 10:09:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 06/11] KVM: arm64: Use vcpu_idx for invalidation tracking
Date: Wed, 27 Sep 2023 10:09:06 +0100
Message-Id: <20230927090911.3355209-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While vcpu_id isn't necessarily a bad choice as an identifier for
the currently running vcpu, it is provided by userspace, and there
is close to no guarantee that it would be unique.

Switch it to vcpu_idx instead, for which we have much stronger
guarantees.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fa21fb15e927..9379a1227501 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -438,9 +438,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
-	if (*last_ran != vcpu->vcpu_id) {
+	if (*last_ran != vcpu->vcpu_idx) {
 		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
-		*last_ran = vcpu->vcpu_id;
+		*last_ran = vcpu->vcpu_idx;
 	}
 
 	vcpu->cpu = cpu;
-- 
2.34.1

