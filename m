Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E1C372662
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 10:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372215; cv=none; b=YvENbsxmW9AEdDFl1nfui5OLTF/AslfUz081UX/G7GxMGNJucK6KM9shCE3r6mXeb4tjzpmJrkwk04kRRj/L6zLh7R4yu1+pGGbjIJc7KrhU+iHSMPFm23LAP8xApTJ2W4HSanWEtbqBiTCSjsaSpK6PpkRGmOaOKJKwUyr4oPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372215; c=relaxed/simple;
	bh=dwxEJdIz8vYk/ufo4vzAXxS0t3GaEBIy02K4bnRRtU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d1FXsSaLGDoK1HceTYVCSNQ4lmyaJUe97RO0GYnWbnO9Drh9NyrZiwAq+PfOz2JRc4yRbZXhn9RAm9XhnJO6abzZ2txQ0jdcW7HsZRmzyudW3qJVP5W7bYDcaIOEuTiTq13c4HbNGUtKfzzlP7Ol+H9h8mocLwSLDznioo9UQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h0zGUdy0; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h0zGUdy0"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b9ca1ef3403so977949666b.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 03:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777372212; x=1777977012; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xE/iPxwYzw+NNX7wEA81VsFDw/XB5o3T+Ctb9g0a1xk=;
        b=h0zGUdy0hwEGEro5kI7vOaLHkv8JyHhZysXBNgG+4LmqFMgUZMSve3sDdO0gvF8Wix
         utPPYTcIIo3UqfyqTphBM40Iq9l0R86ICF2JS60sx3YJAQ/q+0NxitA6yUX12BdLpwLq
         y4nhPGGesab3hITCoUMnslY3s1NpA9UpIM0M+uKvFnUK6O/b4RjAoQ6YgBifuxUR+QrJ
         9+tTs8qvKaBOrKTcLld2pJRxnGmj4M6h3JJqaWj5m7offG2jGsOuKUjchFR1FD96Ydu6
         4B3a2EODc4v2EQ9r6ReKCpN3xaCgU71fp4xK51TLwCxksGpp7Wla+wVjkI1VzRgjQO2D
         gEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372212; x=1777977012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xE/iPxwYzw+NNX7wEA81VsFDw/XB5o3T+Ctb9g0a1xk=;
        b=Ne8VYRhZQIY6Q42bIVcNqCQz4Um158LS70xydJFr5hOOFLeq14PX3U4Ah7i8cTXJWy
         w5PmsQ4XRtRo5+ThaJOmn49E1LPTfWi93e2aUWqQjhuQnyZYhNYNV203eM+6EWZNG+Gz
         F/a1Nq2Ik2GiJSYU/tSY9tdvtwoZwVxe59KvyGpKeVzaAlCcg6epOT5mQr8Zo3a87HZW
         0dJT2E8zmEho5BEQbql3kmykigffZUJ4W3iKjX+QAhTX3rEtd/n++Yz0xFlVSGEvMAM+
         urUF1aTLhdXQ8WIHJSyZPL/DYcYQn52J5zr9sRv1TGKI6pX6TzPSSsxdZKwcc5lHBXab
         T1pw==
X-Forwarded-Encrypted: i=1; AFNElJ9mCKO2U2ZgnmoIgws/cQ1C8Lv/ZzNE81m8x6MX5s3CY6asaITKiUNXC5kg4RQbEjylTmg8nDE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvCuCq6tjNCa2/0J32OvXT2c4TP4Q81mndEmdIKPcYSc56azah
	9gDFRiV2/6GsyotOb2I+iqyZhnILVa2UZPauFNDy4sMfx+euUmJoGMfPUuHR8aYbeIyg49f8Lzx
	Wjw==
X-Received: from ejchp42.prod.google.com ([2002:a17:907:3e2a:b0:b9e:2534:71c9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:5194:20b0:bae:656b:2953
 with SMTP id a640c23a62f3a-bb8022c28ebmr102260866b.11.1777372211619; Tue, 28
 Apr 2026 03:30:11 -0700 (PDT)
Date: Tue, 28 Apr 2026 11:30:02 +0100
In-Reply-To: <20260428103008.696141-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260428103008.696141-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428103008.696141-3-tabba@google.com>
Subject: [PATCH 2/8] KVM: arm64: Synchronise HCR_EL2 writes on the guest exit path
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

MSR HCR_EL2 is not self-synchronising. Per ARM DDI 0487 M.b K1.2.4
(p.K1-16823) and B2.6.1 (p.B2-297), a Context Synchronisation Event
is required between an HCR_EL2 write and any subsequent direct
register access at the same EL that depends on the new value being
in effect.

On the entry path, the HCR_EL2 write in __activate_traps is followed
by further EL2 sysreg work (MDCR_EL2, CPTR_EL2, VBAR_EL2, and on the
speculative-AT errata path SCTLR_EL1/TCR_EL1) before ERET into the
guest. None of those intervening accesses depend on the new HCR_EL2
value, and ERET is a CSE per ARM DDI 0487 M.b D1.4.4.1 rule RBWCFK
(p. D1-7209) conditional on SCTLR_EL2.EOS=1, which is set
unconditionally by INIT_SCTLR_EL2_MMU_ON (see the prerequisite patch
in this series). The requirement is therefore satisfied implicitly
on the activate path.

The deactivate path is different: after write_sysreg_hcr() in
__deactivate_traps() further EL2 sysreg work runs before any natural
CSE - on nVHE, __deactivate_cptr_traps and the VBAR_EL2 write; on
VHE, the timer context save which reads CNTP_CVAL_EL0 under the new
TGE/E2H, and the EL1 sysreg restore. Add an explicit isb() at each
of the two deactivate sites.

The practical impact today is bounded: HCR_EL2.E2H does not toggle
in either path, and the trap bits being changed primarily affect
EL1&0 behaviour. But the architectural rule should be honoured.
Note that write_sysreg_hcr() itself already issues isb() on the
Ampere errata path (sysreg.h), confirming the architectural
expectation; the fast path optimises that away.

The fix is at the call sites rather than inside write_sysreg_hcr()
because the macro has many users (e.g. the activate path, at.c,
hardirq.h, ptrauth alternatives) where the immediately-following
code either reaches ERET or has another CSE; making the macro emit
an unconditional ISB would impose unnecessary cost on those
well-formed users.

Fixes: 9404673293b0 ("KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 11 +++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c  | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 8d1df3d33595..9d7ead5a5503 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -105,6 +105,17 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	__deactivate_traps_common(vcpu);
 
 	write_sysreg_hcr(this_cpu_ptr(&kvm_init_params)->hcr_el2);
+	/*
+	 * MSR HCR_EL2 is not self-synchronising. Per ARM ARM K1.2.4 p.K1-16823
+	 * and B2.6.1 p.B2-297, a Context Synchronisation Event is required
+	 * between an HCR_EL2 write and any subsequent direct register access at
+	 * the same EL that depends on the new value being in effect.
+	 * The activate_traps path falls through to ERET (a CSE), but the
+	 * deactivate path still executes further EL2 sysreg work (CPTR/VBAR
+	 * writes below) before any natural CSE, so make the synchronisation
+	 * explicit.
+	 */
+	isb();
 
 	__deactivate_cptr_traps(vcpu);
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9db3f11a4754..140d3bcb5651 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -149,6 +149,17 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	___deactivate_traps(vcpu);
 
 	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
+	/*
+	 * MSR HCR_EL2 is not self-synchronising. Per ARM ARM K1.2.4 p.K1-16823
+	 * and B2.6.1 p.B2-297, a Context Synchronisation Event is required
+	 * between an HCR_EL2 write and any subsequent direct register access at
+	 * the same EL that depends on the new value being in effect.
+	 * The activate_traps path falls through to ERET (a CSE), but the
+	 * deactivate path still executes further EL2 sysreg work (CPTR/VBAR
+	 * writes below) before any natural CSE, so make the synchronisation
+	 * explicit.
+	 */
+	isb();
 
 	if (has_cntpoff()) {
 		struct timer_map map;
-- 
2.54.0.545.g6539524ca2-goog

