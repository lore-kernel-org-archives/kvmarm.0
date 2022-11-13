Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D51320C
	for <kvmarm@lists.linux.dev>; Sun, 13 Nov 2022 16:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66182C433C1;
	Sun, 13 Nov 2022 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668357990;
	bh=b34dd05lgwkbNWXSAPZPFmJHh3ULCqHSxbRsRxcEyjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOehkPP/TP616PU9K1JF5yFdC0F5c7dDNFttoIZOnwOKfL5bnHI3f3G/054N2I4j6
	 epm/HX3GLfbjBftpBh/fIEBdMjgp1q0g3H53d3YwHjt0QoP8g71T4iGhb7CZPuDzvh
	 Z/2WyViWx/TD7NGQkGiLWYeNrRUQE1MQQZnZqcIFXbjSnW4vbcdzI73L8fI93pH+2g
	 PZ1wINDRfnMH5Py5pFk7izLXKrOEO7co22BkXLKLrqU2VyrecikYOeIXEnu/wEHP5K
	 h5o4ZcdNrGhwtlowVDRx3PLMMXQC1AxrrB0GMrU8i0xFYla9e2ZSHBE8DF1/rsz8Oa
	 p1Lbj8wRTKkcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ouG0Q-005oYZ-Tt;
	Sun, 13 Nov 2022 16:38:51 +0000
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
Subject: [PATCH v4 15/16] KVM: arm64: PMU: Simplify vcpu computation on perf overflow notification
Date: Sun, 13 Nov 2022 16:38:31 +0000
Message-ID: <20221113163832.3154370-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
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
Message-ID: <20221113163831.GRMRQ3bkO80Vxr9oSm1kC19a5Xm2ra8nLB1QaJ7JImY@z>

The way we compute the target vcpu on getting an overflow is
a bit odd, as we use the PMC array as an anchor for kvm_pmc_to_vcpu,
while we could directly compute the correct address.

Get rid of the intermediate step and directly compute the target
vcpu.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b7a5f75d008d..e3d5fe260dcc 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -405,11 +405,8 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
 static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
 {
 	struct kvm_vcpu *vcpu;
-	struct kvm_pmu *pmu;
-
-	pmu = container_of(work, struct kvm_pmu, overflow_work);
-	vcpu = kvm_pmc_to_vcpu(pmu->pmc);
 
+	vcpu = container_of(work, struct kvm_vcpu, arch.pmu.overflow_work);
 	kvm_vcpu_kick(vcpu);
 }
 
-- 
2.34.1

