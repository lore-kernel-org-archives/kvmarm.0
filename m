Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C30F19525
	for <kvmarm@lists.linux.dev>; Tue,  9 May 2023 14:23:25 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 855A9FEC;
	Tue,  9 May 2023 07:24:09 -0700 (PDT)
Received: from e126864.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA7993F663;
	Tue,  9 May 2023 07:23:21 -0700 (PDT)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/11] KVM: arm64: switch HCRX_EL2 between host and guest
Date: Tue,  9 May 2023 15:22:27 +0100
Message-Id: <20230509142235.3284028-4-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230509142235.3284028-1-kristina.martsenko@arm.com>
References: <20230509142235.3284028-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch the HCRX_EL2 register between host and guest configurations, in
order to enable different features in the host and guest.

Now that there are separate guest flags, we can also remove SMPME from
the host flags, as SMPME is used for virtualizing SME priorities and has
no use in the host.

Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h        | 3 ++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index fb7fe28b8eb8..7bb2fbddda54 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -93,7 +93,8 @@
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-#define HCRX_HOST_FLAGS (HCRX_EL2_SMPME)
+#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME)
+#define HCRX_HOST_FLAGS 0
 
 /* TCR_EL2 Registers bits */
 #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c41166f1a1dd..8f95bcbe6cdf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -130,6 +130,9 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
+
+	if (cpus_have_final_cap(ARM64_HAS_HCX))
+		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
 }
 
 static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
@@ -144,6 +147,9 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 &= ~HCR_VSE;
 		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
+
+	if (cpus_have_final_cap(ARM64_HAS_HCX))
+		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
 }
 
 static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
-- 
2.25.1

