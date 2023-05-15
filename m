Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E883EFBF6
	for <kvmarm@lists.linux.dev>; Mon, 15 May 2023 17:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8989C4339B;
	Mon, 15 May 2023 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684172845;
	bh=Xkcpw/RASPYlaQiDAc4919g0yzXaTKmg9opjnJ02hk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpyBj/SawmFZL/I/HWX7qMPEBAp1YIhii1F5wFFea/CioPW48h8BI/L7RHJ0FEcps
	 B/yvK8LxKe5q+8GdBavKg0YmWY51LTvXSLruVTAl56sDbVVGQfpPRMwcJ4KGog+Ncf
	 Pl8+nslVKL96tPo0edfpwJA7R9bwSanLo73rxSW/YP4/oiFHkQfHpXV32lGb1fIma1
	 eJqsmo4bFELMu6qa63VZNnniL3pkyVSOThmR3OfEzF8exDsy/FK7uBKjMWI2eUhLcG
	 8YAr0xL57UCpgAxuv0Toi08tVk8qQw36Sb/0LVNt0NigRhUo+PmEyWot5g7UNQx/Mi
	 VOXB/zBOjVvsQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pyc3C-00FJAF-Ng;
	Mon, 15 May 2023 18:31:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 59/59] KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on
Date: Mon, 15 May 2023 18:31:03 +0100
Message-Id: <20230515173103.1017669-60-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although FEAT_ECV allows us to correctly enable the timers, it also
reduces performances pretty badly (a L2 guest doing a lot of virtio
emulated in L1 userspace results in a 30% degradation).

Mitigate this by emulating the CTL/CVAL register reads in the
inner run loop, without returning to the general kernel. This halves
the overhead described above.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 2d305e0f145f..fc8b7e374e9d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -201,11 +201,60 @@ static bool kvm_hyp_handle_tlbi_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_ecv(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 esr, val;
+
+	/*
+	 * Having FEAT_ECV allows for a better quality of timer emulation.
+	 * However, this comes at a huge cost in terms of traps. Try and
+	 * satisfy the reads without returning to the kernel if we can.
+	 */
+	if (!cpus_have_final_cap(ARM64_HAS_ECV))
+		return false;
+
+	if (!vcpu_has_nv2(vcpu))
+		return false;
+
+	esr = kvm_vcpu_get_esr(vcpu);
+	if ((esr & ESR_ELx_SYS64_ISS_DIR_MASK) != ESR_ELx_SYS64_ISS_DIR_READ)
+		return false;
+
+	switch (esr_sys64_to_sysreg(esr)) {
+	case SYS_CNTP_CTL_EL02:
+	case SYS_CNTP_CTL_EL0:
+		val = __vcpu_sys_reg(vcpu, CNTP_CTL_EL0);
+		break;
+	case SYS_CNTP_CVAL_EL02:
+	case SYS_CNTP_CVAL_EL0:
+		val = __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0);
+		break;
+	case SYS_CNTV_CTL_EL02:
+	case SYS_CNTV_CTL_EL0:
+		val = __vcpu_sys_reg(vcpu, CNTV_CTL_EL0);
+		break;
+	case SYS_CNTV_CVAL_EL02:
+	case SYS_CNTV_CVAL_EL0:
+		val = __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0);
+		break;
+	default:
+		return false;
+	}
+
+	vcpu_set_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu), val);
+	__kvm_skip_instr(vcpu);
+
+	return true;
+}
+
 static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (kvm_hyp_handle_tlbi_el1(vcpu, exit_code))
 		return true;
 
+	if (kvm_hyp_handle_ecv(vcpu, exit_code))
+		return true;
+
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
-- 
2.34.1

