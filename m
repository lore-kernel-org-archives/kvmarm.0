Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D4519509
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 16:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19E2C433AF;
	Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686327731;
	bh=UaDqzpeXMxTsA0h1VeMgRA4blxON31O7kP8OlVYUq/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQx339FkvGKc764l2LE1I0Y0uiAPNfR5N+VijH6pniKl4bVTdLL8ptr0X4rv41cut
	 vaJ5/hyGjPiHT7TsM+jGeVzNm+UitXovcKmJi+FR7ACmn8wGXJWrq+wczWwkhpbnT7
	 3e+vqyJ9m2Zqeo2HxcV2p5hrnW3HYHacGdHgcUMwbILeokUfcBQG4aZu5C24bhsErL
	 zn80Xyr/7oUKIZTTg8yx/uSGzJ2DLKzIN7EnlGLc/2nmr8/svLKIN6jf11epSI35dt
	 ggmbR7b6RqGn4NWxE2Kp0Bx3+atOqBg8GXy4J7szhtC5SZr3GoeIis+ETag+yT9+Es
	 eYUAYMDFNdX/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q7esM-0048L7-3r;
	Fri, 09 Jun 2023 17:22:10 +0100
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
Subject: [PATCH v3 08/17] KVM: arm64: Remove alternatives from sysreg accessors in VHE hypervisor context
Date: Fri,  9 Jun 2023 17:21:51 +0100
Message-Id: <20230609162200.2024064-9-maz@kernel.org>
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

In the VHE hypervisor code, we should be using the remapped VHE
accessors, no ifs, no buts. No need to generate any alternative.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index bdd9cf546d95..fea04eb25cb4 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -16,6 +16,23 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+/*
+ * Unified accessors for registers that have a different encoding
+ * between VHE and non-VHE. They must be specified without their "ELx"
+ * encoding, but with the SYS_ prefix, as defined in asm/sysreg.h.
+ */
+
+#if defined(__KVM_VHE_HYPERVISOR__)
+
+#define read_sysreg_el0(r)	read_sysreg_s(r##_EL02)
+#define write_sysreg_el0(v,r)	write_sysreg_s(v, r##_EL02)
+#define read_sysreg_el1(r)	read_sysreg_s(r##_EL12)
+#define write_sysreg_el1(v,r)	write_sysreg_s(v, r##_EL12)
+#define read_sysreg_el2(r)	read_sysreg_s(r##_EL1)
+#define write_sysreg_el2(v,r)	write_sysreg_s(v, r##_EL1)
+
+#else // !__KVM_VHE_HYPERVISOR__
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
@@ -35,12 +52,6 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 					 : : "rZ" (__val));		\
 	} while (0)
 
-/*
- * Unified accessors for registers that have a different encoding
- * between VHE and non-VHE. They must be specified without their "ELx"
- * encoding, but with the SYS_ prefix, as defined in asm/sysreg.h.
- */
-
 #define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
 #define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
 #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
@@ -48,6 +59,8 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 #define read_sysreg_el2(r)	read_sysreg_elx(r, _EL2, _EL1)
 #define write_sysreg_el2(v,r)	write_sysreg_elx(v, r, _EL2, _EL1)
 
+#endif	// __KVM_VHE_HYPERVISOR__
+
 /*
  * Without an __arch_swab32(), we fall back to ___constant_swab32(), but the
  * static inline can allow the compiler to out-of-line this. KVM always wants
-- 
2.34.1

