Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EBA9440
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 17:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09919C433D2;
	Thu, 30 Mar 2023 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680198983;
	bh=KcCyQyN0weWoFv98+bG3HUcBKenbrX+8D1/wpqF7/io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2zZBZhBS1Z8yLMhsHeVwwM/30gOATKRGu0YXsNL6l4KghYOmIAPUHaELkZxQMjdB
	 To3HVcy405bsNzZCBUgl37/uMewyAxks0pZPVnuyHVpRE2vZrhJMJvisG3JvhJ8Uje
	 Y8lE3WusicUXDbonfCOehbsDzT2u62fzz4Cs5rMOrKrcw/9Iw0GpP0ETh5ys1oI76Q
	 C8dNp5dpR8dJS2xAXRdx32LA+B0DQ3/mX7vkVUjayGiJjwEUAVkRhtXBNaEHh83PgT
	 Xh0i+ZtbSPoxFZisvn7kxAZNbkqpneiVMFTP8TWcSpmswGK9IXGVrho2fqdhF+z2SH
	 PTOmKUALlfXUQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1phwNb-004Rpa-3d;
	Thu, 30 Mar 2023 18:48:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	dwmw2@infradead.org
Subject: [PATCH v4 13/20] KVM: arm64: timers: Fast-track CNTPCT_EL0 trap handling
Date: Thu, 30 Mar 2023 18:47:53 +0100
Message-Id: <20230330174800.2677007-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330174800.2677007-1-maz@kernel.org>
References: <20230330174800.2677007-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that it is likely that CNTPCT_EL0 accesses will trap,
fast-track the emulation of the counter read which doesn't
need more that a simple offsetting.

One day, we'll have CNTPOFF everywhere. One day.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 36 +++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 07d37ff88a3f..9954368f639d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -26,6 +26,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
@@ -326,6 +327,38 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_context *ctxt;
+	u32 sysreg;
+	u64 val;
+
+	/*
+	 * We only get here for 64bit guests, 32bit guests will hit
+	 * the long and winding road all the way to the standard
+	 * handling. Yes, it sucks to be irrelevant.
+	 */
+	sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
+
+	switch (sysreg) {
+	case SYS_CNTPCT_EL0:
+	case SYS_CNTPCTSS_EL0:
+		ctxt = vcpu_ptimer(vcpu);
+		break;
+	default:
+		return false;
+	}
+
+	val = arch_timer_read_cntpct_el0();
+
+	if (ctxt->offset.vm_offset)
+		val -= *kern_hyp_va(ctxt->offset.vm_offset);
+
+	vcpu_set_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu), val);
+	__kvm_skip_instr(vcpu);
+	return true;
+}
+
 static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
@@ -339,6 +372,9 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (esr_is_ptrauth_trap(kvm_vcpu_get_esr(vcpu)))
 		return kvm_hyp_handle_ptrauth(vcpu, exit_code);
 
+	if (kvm_hyp_handle_cntpct(vcpu))
+		return true;
+
 	return false;
 }
 
-- 
2.34.1

