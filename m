Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A563BE15F
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 10:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774868088; cv=none; b=T1bDiEy7DvnbEBzBqNJsW2p78NZUC2M7MWa28adhGRESte+WhLL1IrqVOdis1sRE/PD8p2z9r3NUVA7RCwEynrebORWRemo6iNF9ad+Jvit7BZ/pxr5XUK+OmmzEx1rpm4yxiqMg/XHVPEClcjXhZjbX2MMt9hOt8UEzFAs48kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774868088; c=relaxed/simple;
	bh=n8/FjOxzEWawetfjf8dTLKWl6TONEIaNu/yMlW5S67w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=N7k4PCsi9npqZO56lf8mysTOh8z5nsk3e2W/wY2Co044pyex4qm150v7yg+5aRYRu7l2qPRCRx6pk1s7FBMKT7a0XC4p0IJlH9QLFqb2L0oxmA/DLLuEPIuN5OBT6Q+cBCL5i4t6skI3mDQB7ViSSY0JyF0BwK9PhWNzLWT4krY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z0gv2PzD; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z0gv2PzD"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48542d5aa9eso39288625e9.0
        for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 03:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774868085; x=1775472885; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OCpQaHn340hA9gXHDWXNQio0q+3ps0T5nKIr2QuIXig=;
        b=Z0gv2PzD1rhWh89tT18DL4rpTo6wRq4PtIDRyduMSrshacKd1PUAI4TT1HwOQyJuro
         1ddbCTCP70CSaSmXrsi3APMg/21oGWqn3rU9jxAzMZ1MXfzRvqZATMoHWdBon3AjrUvt
         u5NLwWuQgWvX4LStX8jGhoemmtGingsBCxDIVcRPArFJ1j/kfncZ4nRxTLZYWPCy3xut
         8wQtNdUaJA/gLlD+Kw12dTLWyUAyr2xDUpr+ibi9/1OX4TsZmk2ydDPXYMII/A247KHT
         WZ1azLpbo+KAW3bEIzVa305gkLfdD6yMTLQrxUC6IHpNDVfpgXGF/vNxnXTeAxp12rzW
         nd9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774868085; x=1775472885;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OCpQaHn340hA9gXHDWXNQio0q+3ps0T5nKIr2QuIXig=;
        b=EUZGK9onWUH3G9Fj+YGoht439w+WlCEh9GCMe3GcCIGyTUKRxjRlWMJvrnUJ1jv46n
         h+UqolrK5tbC2L2ZBYQMhRAJxurMRozEgyJz0KU8lS4vdphuFQ3DxdxvHaYIDwoi/ln9
         Dq61MSIQz4Uwwa76/2HL0fuXk/Woirx4FEcl3VkHIyJ+gDXKBngbU68DRNnIQu/jr8lB
         SaZAk/UKFI5iOzdAcB0aZBzUitnJzzyLQSueIh5tVYOxExzBzKrjdn1Ze3E1X/s1s4ks
         z4hi3QXWgqxzDczJTcYd6qSu9lFN7q4BloP10ctqN3hTFKEYEJm3z1ah/oXjq5DEReLs
         1hMQ==
X-Gm-Message-State: AOJu0YwIj645F7QUbyk26oZ7NPafyHqEFOrf7Hq/d+EquFWIILvt9BMw
	xQDGmMzZ1NkBQsne2kA4xVGFb4viBEnzXiI4GxgST0yKF/wlsjmTploIZHKcgVlrBNc5ZYVPvHo
	oC/jy73o2aGXpkaoHx9sfz/7UXEJullwGvDLDx6HWcwmsJaHpjG292XtI8TUqIwHTZ8XEbRq0Yg
	aHwLjTiC4JUtKNwkTxeSt2Go/jOT75+Jt92Fh7+7ulMwGXr6OXUs687ADYlW7GTPWtvqz7
X-Received: from wmro3.prod.google.com ([2002:a05:600c:3783:b0:483:41b6:adeb])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5290:b0:486:fcdf:c065 with SMTP id 5b1f17b1804b1-4872808d317mr201624445e9.27.1774868084528;
 Mon, 30 Mar 2026 03:54:44 -0700 (PDT)
Date: Mon, 30 Mar 2026 10:54:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260330105441.3226904-1-sebastianene@google.com>
Subject: [PATCH v3] KVM: arm64: Prevent the host from using an smc with imm16
 != 0
From: Sebastian Ene <sebastianene@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, android-kvm@google.com
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, 
	maz@kernel.org, oupton@kernel.org, sebastianene@google.com, 
	suzuki.poulose@arm.com, tabba@google.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

The ARM Service Calling Convention (SMCCC) specifies that the function
identifier and parameters should be passed in registers, leaving the
16-bit immediate field un-handled in pKVM when an SMC instruction is
trapped.
Since the HVC is a private interface between EL2 and the host,
enforce the host kernel running under pKVM to use an immediate value
of 0 only when using SMCs to make it clear for non-compliant software
talking to Trustzone that we only use SMCCC.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
v2 -> current:
 - move the ESR decoding of the imm16 in the handle_host_smc where it
   was supposed to be
 - updated the commit message to include the reason behind while we are
   not doing for HVCs as well
 - updated the commit message to clarify that pKVM is not handling the
   imm16

v1 -> v2:
 - Dropped injecting an UNDEF and return an error instead
   (SMCCC_RET_NOT_SUPPORTED)
 - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
 - Updated the title of the commit message from:
   "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
    smc with imm16 != 0"

Link to v2:
https://lore.kernel.org/all/20260325113138.4171430-1-sebastianene@google.com/
Link to v1:
https://lore.kernel.org/all/20260324135728.3532400-1-sebastianene@google.com/

---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7790097db93..461cf5cb5ac7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -676,8 +676,14 @@ static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, func_id, host_ctxt, 0);
+	u64 esr = read_sysreg_el2(SYS_ESR);
 	bool handled;
 
+	if (esr & ESR_ELx_xVC_IMM_MASK) {
+		cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
+		goto exit_skip_instr;
+	}
+
 	func_id &= ~ARM_SMCCC_CALL_HINTS;
 
 	handled = kvm_host_psci_handler(host_ctxt, func_id);
@@ -686,6 +692,7 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	if (!handled)
 		default_host_smc_handler(host_ctxt);
 
+exit_skip_instr:
 	/* SMC was trapped, move ELR past the current PC. */
 	kvm_skip_host_instr();
 }
-- 
2.53.0.1018.g2bb0e51243-goog

