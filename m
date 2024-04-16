Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640D58625F
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261487; cv=none; b=qyFKf5RW2yiFfFxPplssEfy3XSamaFOZsYZ/Oh19PchoYNwhG8cHBE4ljYpAgCs2VNHT4zW0KWWI/De9hrKjo8bdLqNe+Ig0MBERDo2XQHAShtBHy4+1CnNBiDJ63FJ0tTHdA0S75QXdqd928aoThGwFOEIL9YR+LCcSbpCbeGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261487; c=relaxed/simple;
	bh=bSacwKnqms3+zYaQH4l4rhsSE07vHCES2reK7eNk/pU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vb8jBs73A7V6cym2vlNgl4Vxn7eMAn7fMzSZ8g/Mdkq5fhYU7lCANx7z3BVlbLsQzoV1LhO7z6CywMjgGN/fGlRiLfHyPYiyeOtiadW43I8ZDhP8MudzuQrcu2/8TaINPoGH+qYdWh30Z6P2edr7jnxza6/lEeTlSaZe+3ojZig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yTQoSZKf; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yTQoSZKf"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a2386e932so83211587b3.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261485; x=1713866285; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwnWs8VH2DdBsy9bOKwZCv0xyePu3/t2yQyOOH8MmM0=;
        b=yTQoSZKfk//PD6+0aoo0EQ3Mq1FemXmOsSzsWFV6Yn0NrWOBbLMYksgY2Reiv/YIpX
         yB0ssHsCtq0DBZ3MpCNHu5c+2zHF3mUXjWejRQmxti3yGvixD/hqD7YhVsyxOO89iHoO
         OEK23ixOhAD7dlxqS+m68XuNsAX8KhdydIZbbC6F4i4sar2pUj5K86ygEew384AwdVFU
         ez479V3//xyTYjEq5AMxaIT6wbv0b/jNZeBNH2z0m7fdFE+7um5Wz1MEnByZA+Nc3G6P
         yAuZTFjKQKK9kXaEHsLNen6GVVFZ6h7S1qgnbHoRldqvydjIIxQs1/xEbit6W1R3hdNw
         czUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261485; x=1713866285;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UwnWs8VH2DdBsy9bOKwZCv0xyePu3/t2yQyOOH8MmM0=;
        b=g3U33nv8AOjz5ZEVfot2Q1AQ3k+6rfOd47CLDx7rtMa3oUlmN3TTXvCsK1xLuy71qn
         MQrV0f6c2X0osybi4Sg3dPdmgA1WaO8IXzDsXEyogjkNWCGFzMgfbJbwdWxPtRoUkY3z
         TvKWozHZjV8oLoo8CL/Vi6Ba2Wfefc5fZRS3p2PXlBcdeeejeT1pZnyOAU0a3K6qILHR
         4L46xQ9pKcLdDsz3V4OhUGhaG6KzYUsoV6YWlLnZ9Ald75kwDt4w7vN45Z1t1y6vYMHw
         gWAS2vnvxxy1kK5oCB4dMSqCSnXzIYLT3viEXtTm/ptYTxngCwxZOGrpniWuBxMZxmmL
         uvwA==
X-Gm-Message-State: AOJu0Yyw5ibmAWvKGgDQWp8sCer6ndZ+BN2j3j6uNXu5PBFEpEi8sDvR
	XSNYd/Wuj6uq1y7aXoLsjk4FXpgwZBSeBGOUpgcTNhoIWIiYskeaL2cG6M8Ofq/BPKjmI6OR4Sq
	vyNXsXFAZ5/ljjyCc9fCSUAqOFhQGzTW/mR4JVQ9g5OCaEEtQF2aWUpdyw5IxkwaVhgsYHyedk3
	2AeFpMMMgndH6Hy6/JfMINIobEmvc=
X-Google-Smtp-Source: AGHT+IHgpfJnFt+dUcg6UdpO/hoMHul71K9EsThXzZZDYi6KJqLZNiC2WkqW1NdvJsiuXyS/Yp+/pdJPSA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1002:b0:dc6:e5d3:5f03 with SMTP id
 w2-20020a056902100200b00dc6e5d35f03mr4211364ybt.4.1713261485244; Tue, 16 Apr
 2024 02:58:05 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:28 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-38-tabba@google.com>
Subject: [PATCH v2 37/47] KVM: arm64: Trap debug break and watch from guest
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Debug and trace are not currently supported for protected guests, so
trap accesses to the related registers and emulate them as RAZ/WI.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 17aae6fc6898..a29e9efa850d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -119,7 +119,7 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 
 	/* Trap Debug */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), feature_ids))
-		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
+		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA;
 
 	/* Trap OS Double Lock */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DoubleLock), feature_ids))
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 18c1ca0a66b9..1604d170df53 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -345,6 +345,17 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Cache maintenance by set/way operations are restricted. */
 
 	/* Debug and Trace Registers are restricted. */
+	RAZ_WI(SYS_DBGBVRn_EL1(0)),
+	RAZ_WI(SYS_DBGBCRn_EL1(0)),
+	RAZ_WI(SYS_DBGWVRn_EL1(0)),
+	RAZ_WI(SYS_DBGWCRn_EL1(0)),
+	RAZ_WI(SYS_MDSCR_EL1),
+	RAZ_WI(SYS_OSLAR_EL1),
+	RAZ_WI(SYS_OSLSR_EL1),
+	RAZ_WI(SYS_OSDLR_EL1),
+
+	/* Group 1 ID registers */
+	RAZ_WI(SYS_REVIDR_EL1),
 
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
-- 
2.44.0.683.g7961c838ac-goog

