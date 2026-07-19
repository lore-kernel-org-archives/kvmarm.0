Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6AC38236D;
	Sun, 19 Jul 2026 23:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784502681; cv=none; b=U2MFwuDZ5ze17a01P4nOOr5eZyqQ4ZtORnsT4wkVCAUwfUlxxbBKmHrHVTXWKu6M9OLYPyqrggdBsnHgwnABFF2d1x+A2/YT1Lr9aWsiss7rgTbvdoolS5DzXIvBR6ezY1NNzflu3IZqbuwS57oi8r6TeQgdMEclJJuL/X4zoR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784502681; c=relaxed/simple;
	bh=OLmfKw1OWtsaEUazoIIIWYByRIJqe5QP2QutP6yHROg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pWl5Yh+FmAuD5Y4DQ2mp7t3mP5M+vegeB+MT42dNU5QdIVNE9Ro7rp3Y1l8vZYlX4ppjoiDDq3ydFFe95hxt1MFeGWzpLV850J19lRvJZDB5hu/SRRei0pwbFYwlJ/rBBsuu6PV0P5CsjuwGtZ8qxgCfcEbI3OShvKGtJ8vuOQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4MxLCXS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4MxLCXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0B11F000E9;
	Sun, 19 Jul 2026 23:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784502679;
	bh=8QKfeY6MF9dpRy4jWvo6mGVT4QR36ThS7v75EfE7dSs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e4MxLCXSPf2kWjpkFRE2nPg0lQkG1x+47uXc9IEtSlaJ14wMlQSZKOmNKoyL1rXHR
	 EKvB4ZrrwOCohaPC7ALCyxWk4ni6YPA+C9njsTkLAhIyrdoi79dWLB+G5yPKa4/McO
	 8gEmBhBW9BrIJV9Ne2/jdTNIUAAhM/OrFt6P4QpanKGzNeBgBjRBSaRkLas9YBLirS
	 xh5WUeeE23/7z+xdU40svoksStoz5mcvfGmFPUO0dKruxG1DtBdD3nMSkOv4LraeoU
	 BTmlzdSMCtHFtKAmsP0z9uPBqsU8lr3dMxKTSLcohl3SJJRbigvd9v9uIspEI6oEY7
	 dD12q7aDEjpww==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 20 Jul 2026 00:07:46 +0100
Subject: [PATCH v13 19/32] KVM: arm64: Support TPIDR2_EL0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kvm-arm64-sme-v13-19-d9abd3ffa245@kernel.org>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
In-Reply-To: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4705; i=broonie@kernel.org;
 h=from:subject:message-id; bh=OLmfKw1OWtsaEUazoIIIWYByRIJqe5QP2QutP6yHROg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqXVk2dyjNwO2ydr9q0peDQtfzHdNngXOQCLdoG
 377ZZxBElWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCal1ZNgAKCRAk1otyXVSH
 0HaAB/9VVxYov3R1QcHJyuQ6qd55dsBztQ+F2tpkMMGvGTD/UpGd21sgtg8A2Ii1gKKYl2a60hf
 JLDWcrm7vkS1EpVnTjgTX+XTP/4EoGXWYOSmXxtJdFAU6CMm7h01pHqXvWC6MKqRrtafE5QD1h0
 odfd39iIY8mFfmZ3GnqagTyH08egKxQsZQe/f/9PNlupQwCeRrEVH74MPkUzbh73l0aTNeU+D40
 UF49C558n14kC8CMsE3t1UsOu1zDUvSmqwhUsxKMQY3Eqv59mVM8prhGLTCkLf/1pfzjE30op5X
 HHns3LxAnQ4hmG0dhPbHNWgH4Ev1pkbFZnMI8y907jl0ZXzR
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

SME adds a new thread ID register, TPIDR2_EL0. This is used in userspace
for delayed saving of the ZA state but in terms of the architecture is
not really connected to SME other than being part of FEAT_SME. It has an
independent fine grained trap and the runtime connection with the rest
of SME is purely software defined.

Expose the register as a system register if the guest supports SME,
context switching it along with the other EL0 TPIDRs.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h          |  1 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 12 ++++++++++++
 arch/arm64/kvm/sys_regs.c                  |  6 +++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 796b6e3a50f7..da7e572822a1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -460,6 +460,7 @@ enum vcpu_sysreg {
 	CSSELR_EL1,	/* Cache Size Selection Register */
 	TPIDR_EL0,	/* Thread ID, User R/W */
 	TPIDRRO_EL0,	/* Thread ID, User R/O */
+	TPIDR2_EL0,	/* Thread ID, Register 2 */
 	TPIDR_EL1,	/* Thread ID, Privileged */
 	CNTKCTL_EL1,	/* Timer Control Register (EL1) */
 	PAR_EL1,	/* Physical Address Register */
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 5624fd705ae3..0fd4092e4f25 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -88,6 +88,14 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
 	return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
 }
 
+static inline bool ctxt_has_sme(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = ctxt_to_vcpu(ctxt);
+	return kvm_has_sme(kern_hyp_va(vcpu->kvm));
+}
+
 static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
 {
 	return host_data_ptr(host_ctxt) != ctxt;
@@ -127,6 +135,8 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt_sys_reg(ctxt, TPIDR_EL0)	= read_sysreg(tpidr_el0);
 	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
+	if (ctxt_has_sme(ctxt))
+		ctxt_sys_reg(ctxt, TPIDR2_EL0)	= read_sysreg_s(SYS_TPIDR2_EL0);
 }
 
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
@@ -204,6 +214,8 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0),	tpidr_el0);
 	write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),	tpidrro_el0);
+	if (ctxt_has_sme(ctxt))
+		write_sysreg_s(ctxt_sys_reg(ctxt, TPIDR2_EL0), SYS_TPIDR2_EL0);
 }
 
 static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 24bbe30c075a..8f19caac6008 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -131,6 +131,7 @@ static enum sr_loc_attr locate_direct_register(const struct kvm_vcpu *vcpu,
 
 	case TPIDR_EL0:
 	case TPIDRRO_EL0:
+	case TPIDR2_EL0:
 	case TPIDR_EL1:
 	case PAR_EL1:
 	case DACR32_EL2:
@@ -246,6 +247,7 @@ static u64 read_sr_from_cpu(enum vcpu_sysreg reg)
 	case SCTLR2_EL1:	val = read_sysreg_s(SYS_SCTLR2_EL12);	break;
 	case TPIDR_EL0:		val = read_sysreg_s(SYS_TPIDR_EL0);	break;
 	case TPIDRRO_EL0:	val = read_sysreg_s(SYS_TPIDRRO_EL0);	break;
+	case TPIDR2_EL0:	val = read_sysreg_s(SYS_TPIDR2_EL0);	break;
 	case TPIDR_EL1:		val = read_sysreg_s(SYS_TPIDR_EL1);	break;
 	case PAR_EL1:		val = read_sysreg_par();		break;
 	case DACR32_EL2:	val = read_sysreg_s(SYS_DACR32_EL2);	break;
@@ -285,6 +287,7 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64 val)
 	case SCTLR2_EL1:	write_sysreg_s(val, SYS_SCTLR2_EL12);	break;
 	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	break;
 	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	break;
+	case TPIDR2_EL0:	write_sysreg_s(val, SYS_TPIDR2_EL0);	break;
 	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
 	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
 	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
@@ -3598,7 +3601,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .visibility = s1poe_visibility },
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
-	{ SYS_DESC(SYS_TPIDR2_EL0), undef_access },
+	{ SYS_DESC(SYS_TPIDR2_EL0), NULL, reset_unknown, TPIDR2_EL0,
+	  .visibility = sme_visibility },
 
 	{ SYS_DESC(SYS_SCXTNUM_EL0), undef_access },
 

-- 
2.47.3

