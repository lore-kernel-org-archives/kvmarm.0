Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795793510;
	b=Trly3qos5eAyPsyOxizA2ziTk0RgPovs7UacjDj/ispDp7QRpuxkyIpu+4+3197XRKps
	 eumEERtSKJjdHPwwRawa/TQFHdx1FKL9xJ8/QWkjoUcLM1D+47lKf7tZhIHgqKhx/B/Lh
	 //Cg5uK/uE1GHgbetSJCfV29cT2jL4+2fue8kseJimkCwStP3w0g616010VNa1aGrfYFt
	 4Q2H/bxpQ1dScEaxKxZPOfGpSEf4hScqIReDClppmclecAMW39FcC+jRyJicosPNdANBO
	 oZwzF+djWEPkR4aowo/cHY3eui4fXlk2yILs/VWUmEWhBu+RXkDdX5nzlhEQ0ZG9qJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=psEWMDtbK/VEnWlI7cGkj3njVmGtbz4cdV2wNJVv0u4=;
	b=Ye0fQlEu94mZlxsTouhu3aiYbY3M5ev/EvdVY1XR1Hf1L8TjNPTWiVfprkQlCrfRlHO4
	 hmvm6I8hSRF2ZW1cBCMWz22JwcDJkWt6wnzu3gLbciFuMWywrASuWy+myJY3LssaisoX4
	 uoluhepFR6QBHANLt0iUl7ztDD5JixcmvVBONW4D/+uGJCBKuUaqrj6tornkwQ00ntxJh
	 eHu2OMdWE9haLxNkf23FfVjsqJp1J54wHk8YBzHx2LbnvmfFo0CYhefCCa+OD6tqP3jpU
	 s1n2Va+/nsmxRYUnjEc8+ylEFA9qjUbE0P/KtaccBwp6eJgfZUpr3D1QeLv6LalR2iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=O14+SAqt;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D98606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 15:31:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6D98606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=O14+SAqt
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so74537885e9.2
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 07:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795793508; x=1796398308; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=psEWMDtbK/VEnWlI7cGkj3njVmGtbz4cdV2wNJVv0u4=;
        b=O14+SAqtezA3uR8ZHIDxP4eiHipbPm1cPr9KoY/1OlkwVnGEKTsu25AwUj49PXDPCP
         wMNJCU3M2BS8gjZGlbz2yUonnmeoXDyfmpL0qu31ZZqBVkoiAip4ck2kyjwUwJgBpn8j
         uNvgmQl8qb1e1io7y6Pkgv38j359zr6ByhUsKevk23N8LlJYTzDnFnjJCBoVC1pxBc0R
         frK8XoufYBVP4jlIUhik9BkIp3AkGF/+OX5t0bwRLfCt1+1XcuFeRnRLUfenAySBdXQd
         Y/7YaX+mVogN84qL1A0BAA0X+0X4zzkLl7SsyqOKIATMYYu+cNLr6sXu9EDnZprWY2La
         ZB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795793508; x=1796398308;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=psEWMDtbK/VEnWlI7cGkj3njVmGtbz4cdV2wNJVv0u4=;
        b=gEJUhXbz1aYw/onknNh0+Qczi+YoyvcAcjmZEKgpF8mJtSbZwXIMt0T8COuOb9V5ny
         5LCye5qxBFn2M9tf2yFmYzVh2E1PK+ZD+vn24AfeuBb6Kv2cu665Bth2NRhzmgchJxz4
         c+nNobrXxlgOvys7CJwi2fDcnl6mlVRsUTjnkBM4NitLxNbUgqUmIOyFhtIDJlHJZ0MW
         t0ZhsiVa6D5OecOc0lz++XOCM8ifMJAQ9oj3mCN3vQgIdS0MTggZwqgW68f3HIbKwu9Z
         X0Vn4Dskz6Z5p+7qSJuwJDZ5NwUhivWOkRRr9wf86ZsdA8NduZY1cEuC9pkTgWHZQQeb
         zLaA==
X-Forwarded-Encrypted: i=1; AL+hErEeKhX9grbcHesuCrh89Y/5ulAz8RGz2iP2G2R2DfaZ5/5bpDB161FAy/YGGBtNv3NHiufnnBc=@lists.linux.dev
X-Gm-Message-State: APuU4Z9MJ5lsauCYOSXBaxVumq1anaqZWNishPL+qmBwCpxVI40QAMI7
	o7QoBvsHzzEoCasmJCVrp4k5vmr6ogi1p8WkubeUz2W+6HBsy52K5Jlf7hkWZYLOUWc=
X-Gm-Gg: AZFdTZfKbYnw+c4jlMDaoWncPa6T/iQOFZhzOYxaGV0NPeP2UmF4RKPLTvT1FQMnIoX
	QCNQiIcwlOHHrvaO7m3YGAUBCJDCV/VSPxIcZg9VSFgQepHV+AVVjd9ATNkBpH+yKSQlQN8iLZg
	waeEoVuaee030wotz5uqyxoruXRD5cAtk55R6edXrICaK7qc+mAetCmemuabezS5m5HgOpllM4H
	pVTFOol2ePZ6JqFHMesRMnbO1bdhhG1LaonNn1YYIi5lqn0urPrVq5bIwcpq8kCnkdB/DZ0g1pQ
	66DPqRZUI8bytXGAlQuGzZZGveh3WcbxHy5idBGHaqh4kfpNYcpQQkZIM+lCsICQnDXAdG6Ov5L
	Zn3xP5rqq8xNsoKU5xB6PQDRlRn60v3aSIVquAzOGELCFE//EoHKaOMfrykOjwUcCOJwrtP4aXp
	T/TEz0pT6o33hW8P1tPmErXYRg5uJpiky/0ND8UotmL7d+eO8WAwMpmfWmdxNFmyfS10Dn2hpE7
	lCGLGDAEzyXk/ioELyYZbjIpjPzRRC2yEElfc5V2lUVprC8Wi8wKNbrf+tf2TM0dSJ++R3X43cT
	zl0mkOw0zl/aJi8bYAk=
X-Received: by 2002:a05:600c:64c9:b0:4bb:8701:bb14 with SMTP id 5b1f17b1804b1-4bb88804d1cmr535797655e9.5.1795793508061;
        Fri, 27 Nov 2026 07:31:48 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bbab390cf5sm217781495e9.7.2026.11.27.07.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 07:31:47 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Fri, 27 Nov 2026 18:31:38 +0300
Subject: [PATCH 1/3] KVM: arm64: nv: Fix AT emulation for TCR2_EL1
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-nv-tcr2-v3-v1-1-9c15c1cabe01@pereq.eu>
References: <20261127-nv-tcr2-v3-v1-0-9c15c1cabe01@pereq.eu>
In-Reply-To: <20261127-nv-tcr2-v3-v1-0-9c15c1cabe01@pereq.eu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, stable@vger.kernel.org
X-Mailer: b4 0.16.0

Arm provides an AT instruction that translates a virtual address the way
the MMU would and returns the result.  We emulate this instruction by
setting up the state and calling the actual AT instruction.  There is a
bug in how the TCR2_EL1 permission bits are handled.

The TCR2_EL1 register has bits which turn on permission indirection (PIE)
and permission overlays (POE).  When these bits are set, the AT
instruction reads the permissions stored in permission registers PIR_EL1,
PIRE0_EL1, POR_EL1 and POR_EL0.  If you have the right features and
permissions then the return value from the AT instruction has bit that is
0 if the access is allowed or 1 if it would fault.

The bug is that the current code assumes that if the VM doesn't have
the feature then the host doesn't have it either, and isn't necessarily
true.  The host can have the features but disable them for a guest.  The
way the current code is written, if the VM doesn't have the features then
KVM doesn't bother to load the TCR2_EL1 or the permission registers, but
uses whatever was left there previously.

The impact of this information leak is very small.  It's hard to imagine
how knowing someone else's permission bits is useful to an attacker.
Claude suggests that potentially two guests could set up a secret
back channel where they communicate by flipping their permissions on and
off.  :)

Fix this by clearing the PIE and POE bits in effective_tcr2() when the
VM doesn't have those features, and load the result into TCR2_EL1
whenever the CPU has TCR2, not only when the VM has it.

When the AT runs on the guest hypervisor's own registers, in
__kvm_at_s1e2() and __kvm_at_s1e01_fast(), use the new load_guest_tcr2()
function to load the guest's TCR2_EL2 for the AT and restore the
original value afterwards.  If the VM doesn't have the PIE and POE
features, those bits of TCR2_EL2 are RES0 because
kvm_vcpu_apply_reg_masks() clears them.

There is a closely related bug in __kvm_at_s1e01_fast().  Here the issue
is that KVM is performing an AT command for a guest hypervisor but the
POR_EL0 isn't loaded, so we use the VMM's.  This bug is triggered when
the guest hypervisor runs with HCR_EL2.{E2H,TGE} = {1,1}.  Fix this by
loading the guest's POR_EL0 before the AT and restoring the VMM's value
afterwards.

Fixes: 477e89cabb14 ("KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}")
Fixes: 23e7a34c8397 ("KVM: arm64: Add AT fast-path support for S1PIE")
Fixes: 846c993df982 ("KVM: arm64: Add POE save/restore for AT emulation fast-path")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v3: Re-write commit message
    Add a new fix for the guest's POR_EL0 when HCR_EL2.{E2H,TGE} = {1,1}
    and add a new Fixes tag for that.

    Btw, Marc the zeros in the load_guest_tcr2() don't come from the
    reset value, they're actually set in tcr2_el2_feat_map[] so that
    should re-assure you.  :)  Update that comment.

v2: Restore the original TCR2 at the end as pointed out by Sashiko.
    Cleanup the code based on Marc's review.
    Clear the guest's TCR2 in effective_tcr2().
---
 arch/arm64/kvm/at.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 30d8f062b2c2..893bf88f2f75 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -91,11 +91,18 @@ static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 o
 static u64 effective_tcr2(struct kvm_vcpu *vcpu, enum trans_regime regime)
 {
 	if (regime == TR_EL10) {
+		u64 val;
+
 		if (vcpu_has_nv(vcpu) &&
 		    !(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En))
 			return 0;
 
-		return vcpu_read_sys_reg(vcpu, TCR2_EL1);
+		val = vcpu_read_sys_reg(vcpu, TCR2_EL1);
+		if (!kvm_has_s1pie(vcpu->kvm))
+			val &= ~TCR2_EL1_PIE;
+		if (!kvm_has_s1poe(vcpu->kvm))
+			val &= ~(TCR2_EL1_POE | TCR2_EL1_E0POE);
+		return val;
 	}
 
 	return vcpu_read_sys_reg(vcpu, TCR2_EL2);
@@ -1384,6 +1391,23 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
 	return 0;
 }
 
+/*
+ * Load the guest's TCR2_EL2 and return the original TCR2 so we can restore
+ * it after running the AT command.
+ */
+static u64 load_guest_tcr2(struct kvm_vcpu *vcpu)
+{
+	u64 orig = read_sysreg_el1(SYS_TCR2);
+
+	/*
+	 * TCR2 features are not always exposed to the guests.  If they
+	 * aren't exposed then the bits are RES0.
+	 */
+	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL2), SYS_TCR2);
+
+	return orig;
+}
+
 /*
  * Return the PAR_EL1 value as the result of a valid translation.
  *
@@ -1397,7 +1421,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	struct mmu_config config;
 	struct kvm_s2_mmu *mmu;
+	bool swap_tcr2 = false, swap_por_el0 = false;
 	bool fail, mmu_cs;
+	u64 orig_tcr2, orig_por_el0;
 	u64 par;
 
 	par = SYS_PAR_EL1_F;
@@ -1437,8 +1463,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR1_EL1),	SYS_TTBR1);
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR_EL1),	SYS_TCR);
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
+	if (cpus_have_final_cap(ARM64_HAS_TCR2))
+		write_sysreg_el1(effective_tcr2(vcpu, TR_EL10), SYS_TCR2);
 	if (kvm_has_tcr2(vcpu->kvm)) {
-		write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL1), SYS_TCR2);
 		if (kvm_has_s1pie(vcpu->kvm)) {
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
 			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
@@ -1452,6 +1479,17 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	__load_stage2(mmu);
 
 skip_mmu_switch:
+	if (!mmu_cs && vcpu_has_nv(vcpu) &&
+	    cpus_have_final_cap(ARM64_HAS_TCR2)) {
+		swap_tcr2 = true;
+		orig_tcr2 = load_guest_tcr2(vcpu);
+	}
+	if (!mmu_cs && vcpu_has_nv(vcpu) && kvm_has_s1poe(vcpu->kvm)) {
+		swap_por_el0 = true;
+		orig_por_el0 = read_sysreg_s(SYS_POR_EL0);
+		write_sysreg_s(vcpu_read_sys_reg(vcpu, POR_EL0), SYS_POR_EL0);
+	}
+
 	/* Temporarily switch back to guest context */
 	write_sysreg_hcr(vcpu->arch.hcr_el2);
 	isb();
@@ -1485,6 +1523,11 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	if (!fail)
 		par = read_sysreg_par();
 
+	if (swap_tcr2)
+		write_sysreg_el1(orig_tcr2, SYS_TCR2);
+	if (swap_por_el0)
+		write_sysreg_s(orig_por_el0, SYS_POR_EL0);
+
 	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 
 	if (mmu_cs)
@@ -1544,7 +1587,7 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	 * switching context behind everybody's back, disable interrupts...
 	 */
 	scoped_guard(write_lock_irqsave, &vcpu->kvm->mmu_lock) {
-		u64 val, hcr;
+		u64 val, hcr, orig_tcr2;
 		bool fail;
 
 		val = hcr = read_sysreg(hcr_el2);
@@ -1554,6 +1597,9 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		if (!vcpu_el2_e2h_is_set(vcpu))
 			val |= HCR_EL2_NV | HCR_EL2_NV1;
 
+		if (cpus_have_final_cap(ARM64_HAS_TCR2))
+			orig_tcr2 = load_guest_tcr2(vcpu);
+
 		write_sysreg_hcr(val);
 		isb();
 
@@ -1577,6 +1623,9 @@ int __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		if (!fail)
 			par = read_sysreg_par();
 
+		if (cpus_have_final_cap(ARM64_HAS_TCR2))
+			write_sysreg_el1(orig_tcr2, SYS_TCR2);
+
 		write_sysreg_hcr(hcr);
 		isb();
 	}

-- 
2.53.0

