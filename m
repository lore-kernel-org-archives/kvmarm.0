Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4A717AC2
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 16:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9709CC433EF;
	Fri,  9 Jun 2023 16:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686329219;
	bh=Svn5PaYfn4owwrOXlSAGosifn4fpgZpDHUwDbWmHyHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMxkXDk2VwyolA1uuXHbjL71x7DaMPrNBpzOcVUgnVWt4POufprq51thPLvEAw+4/
	 01nE7+sG3rW4/QDU44NNJ+9z/olvE4Hxzf4F+C5xzyV1tve4rLhFk+rpGzU39UwoZG
	 tV2XCJ29yIJmGBT+MgdZAjvUgpx3NYnNlYPnVLP9zkS2mv3ez5V2+eAv0eJfOh9E/5
	 MrFmfejcaupAen9KOxqskT0QBm0xianMWlJygKQ1fbhAnSFjy5v5D2eGL7KBe2EGO0
	 vzZWSevRD4QAkrDRY4NpaipJv4wjpixf+BfGuqW21VFjAXRccfQPM7FrOWu2w1sqWT
	 fgJ4raYlVHlqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q7esN-0048L7-Lz;
	Fri, 09 Jun 2023 17:22:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 15/17] KVM: arm64: Force HCR_E2H in guest context when ARM64_KVM_HVHE is set
Date: Fri,  9 Jun 2023 17:21:58 +0100
Message-Id: <20230609162200.2024064-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Also make sure HCR_EL2.E2H is set when switching HCR_EL2 in guest
context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c       | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4d82e622240d..cf40d19a72f8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -74,7 +74,7 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
-	if (is_kernel_in_hyp_mode())
+	if (has_vhe() || has_hvhe())
 		vcpu->arch.hcr_el2 |= HCR_E2H;
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
 		/* route synchronous external abort exceptions to EL2 */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 5d5ee735a7d9..8033ef353a5d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -44,6 +44,9 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD),
 				PVM_ID_AA64PFR0_ALLOW));
 
+	if (has_hvhe())
+		hcr_set |= HCR_E2H;
+
 	/* Trap RAS unless all current versions are supported */
 	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), feature_ids) <
 	    ID_AA64PFR0_EL1_RAS_V1P1) {
-- 
2.34.1

