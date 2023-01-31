Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D74808
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 09:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DABC433EF;
	Tue, 31 Jan 2023 09:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675158100;
	bh=/QY1FPyGRGaFdavJIbYCnyzWzBu7xwfwmRblKc+JKKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNOvakJ6KCxiNC2UdKi5Sf0dZeX0nDqa5Zkp8T82mZ7zRqnkXXnXjX6kQ/PoM2MRE
	 LedmDUu2cbkFXnQiGD0QiYuALCXDRHccVe3HI8qa2nQe8zbmQdEwn1+iotwBPGXbiF
	 Y1ODgnW/jwjAttTAOXinLsT8r/qP0cGrMGGfNcecaa2kd3g5MLN6jrYhJwwZlMiOQm
	 1ogTEhwGDUTKBgUcID4yHc28sv7YHL1JRbD60+861rdBLP2JwAwnYVCgJXBw5OUHcq
	 esS3MMlS4cVaU0eaxcI6xIYSnexvktKrTTKHjXLYinKZHNI1TL/VxcEK5Lxe9Fr4ob
	 RAh5hqY5kt1FA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pMmtT-0067U2-Te;
	Tue, 31 Jan 2023 09:25:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 23/69] KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
Date: Tue, 31 Jan 2023 09:24:18 +0000
Message-Id: <20230131092504.2880505-24-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Jintack Lim <jintack.lim@linaro.org>

Forward exceptions due to WFI or WFE instructions to the virtual EL2 if
they are not coming from the virtual EL2 and virtual HCR_EL2.TWX is set.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 14 ++++++++++++++
 arch/arm64/kvm/handle_exit.c         |  6 +++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 2f5d3e27c017..6e9c0d76a818 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -17,6 +17,7 @@
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
 #include <asm/virt.h>
@@ -333,6 +334,19 @@ static __always_inline u64 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.esr_el2;
 }
 
+static inline bool guest_hyp_wfx_traps_enabled(const struct kvm_vcpu *vcpu)
+{
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	bool is_wfe = !!(esr & ESR_ELx_WFx_ISS_WFE);
+	u64 hcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
+
+	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
+		return false;
+
+	return ((is_wfe && (hcr_el2 & HCR_TWE)) ||
+		(!is_wfe && (hcr_el2 & HCR_TWI)));
+}
+
 static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b0c343c4e062..ea73b47b99ac 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -124,8 +124,12 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
+	bool is_wfe = !!(esr & ESR_ELx_WFx_ISS_WFE);
 
-	if (esr & ESR_ELx_WFx_ISS_WFE) {
+	if (guest_hyp_wfx_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
+	if (is_wfe) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
 	} else {
-- 
2.34.1

