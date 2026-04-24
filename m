Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9227635DA6D
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 08:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020557; cv=none; b=MS1EILqKfDHdoiGN4jbR3J0Xcu+/zwLKLF8dOdllRlLdY6c4GJdkn7G4P+CY1bVQE928umcMaualz/t0Q4EoMc/rQatmHT4Dn3fIww6hZFu3+Ki1JxjKGy6aI0FBVz18OBNebxw676bgkHf1FRq357B2NB6GRmGmGf6P1HtEKhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020557; c=relaxed/simple;
	bh=nELHylJPezncARiAi8KKGYsmhL2qaAXiYMmMmo3Zi9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S1cpE+h7qyuYVGfdTdgR4p2MUIQ1tXKvcYyGjC5WDhYGvTuOrbB9UAXvCy/TTtjhewdQkCSoLTLcxiV+/kp1dxOM4u2gj+ZmFXY+Ws7DpqCLb2o8Vxgn0wfowL+jFyofRcY8hedGpsqcsrzYRimO/R4wGOYAtG1ZMVaoice1UJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VXXaN57v; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VXXaN57v"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43fe791a398so6016206f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 01:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777020553; x=1777625353; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=75xbgkgj9TP8McSEuAQtz161daMjjx48XqQqIGgEMWU=;
        b=VXXaN57vtRMOX1X/iqWQ1jiwVAKMAumhVv6QSQOzxw0WWWjWFZKghS5kk/Nus3ILy3
         XZKK1M+/XPeSN6y9LdjpLDVcz2U/Ui1it6wOpo20KnoBiJ7ZImhTfdrZfAy8T0GE5gtr
         BQrgUT9Wx4KHh0cczSiaoRvvx8zS1CMRDAIoUWmtzB8L3PBNK4lDSUkMk+vxmxXniVaf
         rR2c5Yg4ux63JtnBiOs/sEM0DsCqcUjI4X8bM9EvVqBvJ/ZWDn8486f2IrkDAKLMY22q
         Kpw8ITWIjljLWuJQvTaXnsuGzzF5NvnOtTbS6NRSCte4/4I38qPpzTO8gpLoEdeCqwth
         I33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777020553; x=1777625353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=75xbgkgj9TP8McSEuAQtz161daMjjx48XqQqIGgEMWU=;
        b=SKB2j8MnezwY3zluf04Qj8eqO8JJVVsPFFkEALFaS+XF2a+O44GLieUQSxeUSz8FL2
         YtP4rnhS1Cgqk5dW9ntwgJBK3wH0xRv9Djzo9p5ruIWjhZzDEMO566yvi/vxDaTVHL/3
         AgWomthuhHz3wV8QwRy4syStDTURHAOqyGjT3fjrmReL9rjBP6U0F02fSwCI+Je1OcIR
         TGYbLYE8TCBPq9kYy5ysPPFIA/F73C9MwVbHAXL/gZJz0ptBCihQfa2B1ceT6/QnGVax
         Dg5rhR0RwPCWV4Il40ab2gCPPMCld39Oiie9EEOAOq47VizGMGqmDE4BGJkyYpqLYG8d
         T2GA==
X-Gm-Message-State: AOJu0YyAHdcw9dOBJf5LdSQNvncFtfWXaiggo8GTz4PgHSWaaNLm86GB
	PnqRDkduB+9mwj4rfA/xYvcpQQO7vVWCnPR3Oai+DyVTDKLErEX8ezTg1Zb3kYuUNCKp9YwYys+
	5/b3RJdzdqmWKEhuRKeNwB9gaUVTkA1m420AKy/my6iSZAPuyaTzmw1ASgVjqKh24xxyyTZW5BJ
	8oPxku45QM/iI3A1LXVt3jHhO9pYLQKk4=
X-Received: from wrpx14.prod.google.com ([2002:adf:f64e:0:b0:43d:7088:5f55])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2f83:b0:43d:7d6f:f529
 with SMTP id ffacd0b85a97d-43fe3e0dc49mr47722399f8f.31.1777020552885; Fri, 24
 Apr 2026 01:49:12 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:49:05 +0100
In-Reply-To: <20260424084908.370776-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260424084908.370776-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424084908.370776-4-tabba@google.com>
Subject: [PATCH 3/6] KVM: arm64: Fix FEAT_SPE_FnE to use PMSIDR_EL1.FnE, not PMSVer
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Cc: tabba@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oupton@kernel.org, qperret@google.com, suzuki.poulose@arm.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

FEAT_SPE_FnE is architecturally detected via PMSIDR_EL1.FnE [6], not
ID_AA64DFR0_EL1.PMSVer. The FEAT_X macro form (register, field, value)
cannot encode a PMSIDR_EL1-based feature, so FEAT_SPE_FnE was defined
identically to FEAT_SPEv1p2 (ID_AA64DFR0_EL1, PMSVer, V1P2), producing
a duplicate that used PMSVer >= V1P2 as a proxy.

Replace the macro with feat_spe_fne(), following the same pattern as
the sibling feat_spe_fds(): guard on FEAT_SPEv1p2 and read
PMSIDR_EL1.FnE [6] directly. Wire the two NEEDS_FEAT consumers to use
the new function.

Remove the now-unused FEAT_SPE_FnE macro.

Fixes: 63d423a7635b ("KVM: arm64: Switch to table-driven FGU configuration")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/config.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index a722ea178f68..0622162b089e 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -131,7 +131,6 @@ struct reg_feat_map_desc {
 	}
 
 #define FEAT_SPE		ID_AA64DFR0_EL1, PMSVer, IMP
-#define FEAT_SPE_FnE		ID_AA64DFR0_EL1, PMSVer, V1P2
 #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
 #define FEAT_TRC_SR		ID_AA64DFR0_EL1, TraceVer, IMP
 #define FEAT_PMUv3		ID_AA64DFR0_EL1, PMUVer, IMP
@@ -302,6 +301,16 @@ static bool feat_spe_fds(struct kvm *kvm)
 		(read_sysreg_s(SYS_PMSIDR_EL1) & PMSIDR_EL1_FDS));
 }
 
+static bool feat_spe_fne(struct kvm *kvm)
+{
+	/*
+	 * Revisit this if KVM ever supports SPE -- this really should
+	 * look at the guest's view of PMSIDR_EL1.
+	 */
+	return (kvm_has_feat(kvm, FEAT_SPEv1p2) &&
+		(read_sysreg_s(SYS_PMSIDR_EL1) & PMSIDR_EL1_FnE));
+}
+
 static bool feat_trbe_mpam(struct kvm *kvm)
 {
 	/*
@@ -537,7 +546,7 @@ static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
 		   HDFGRTR_EL2_PMBPTR_EL1	|
 		   HDFGRTR_EL2_PMBLIMITR_EL1,
 		   FEAT_SPE),
-	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, FEAT_SPE_FnE),
+	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, feat_spe_fne),
 	NEEDS_FEAT(HDFGRTR_EL2_nBRBDATA		|
 		   HDFGRTR_EL2_nBRBCTL		|
 		   HDFGRTR_EL2_nBRBIDR,
@@ -605,7 +614,7 @@ static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
 		   HDFGWTR_EL2_PMBPTR_EL1	|
 		   HDFGWTR_EL2_PMBLIMITR_EL1,
 		   FEAT_SPE),
-	NEEDS_FEAT(HDFGWTR_EL2_nPMSNEVFR_EL1, FEAT_SPE_FnE),
+	NEEDS_FEAT(HDFGWTR_EL2_nPMSNEVFR_EL1, feat_spe_fne),
 	NEEDS_FEAT(HDFGWTR_EL2_nBRBDATA		|
 		   HDFGWTR_EL2_nBRBCTL,
 		   FEAT_BRBE),
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog

