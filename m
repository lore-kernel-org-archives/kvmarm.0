Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094767;
	b=CgmRIAlOG4NQsIO3DVNsOVun5NnRvJ1oMbbfx2YPUoKJV48sEUIYe8jrfqfeDquxdzZN
	 dFf8XDu968wWeUf7BnzIiNwUoWvmQekamCdt0k+rDrH3E6U6cGl5LXpHSn15/n6te0Fcf
	 kFYDNdC13q9LUkyv91dRLdRhyvW/kHcNCqV52/PrsrzqguMgzijz3GUXc2BDLNvgRJqez
	 XhwgsRgNSqSddaUmffcHRgGiW0XtjdAAqTXIe5G7xFrqGJQ/rwPaZQrZ6kef4TpNjj6ge
	 9x4xgmSAJubOU3Q7fCcVkCIbOIVAhKsHKARID1zHOFgjg5nbqHGTGQcKkDtU2RQeSAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094767;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=9RCUmBluXL32Xv+pv5scriRF4mb+lkStDc3uAW97NWc=;
	b=05xi50025iKg9U4WIVpxA7X7//zSz62lhv3X67RH1yKy3wdJdNJ0eJDoqj72pQxqHqHB
	 Lr29U6v6a4CZoR+mE7YgfnFyU9F1a0n0cXIGBeVQFup6gLNtYZ1CVNA6VGHWC2twpjRP8
	 2byrPmsD/84A1dOuQyhg22iyNtlkJ4MJA5Y9LGu9mWR0ojTRmxtrXm49oJ7CUL6+UzQct
	 3BkuLKyijr1nf7sd5Rk8zSoHY3L4+zgxxF0D32e3jIBX+VjJPyNquU7l4yDwl1y+N5dWq
	 Y7kPfRLWxMj5ln+FIWWCb7t3jOc4GMw3En3Wm1wcTgB4qAtiX1BTR2ylfN39kSp0NYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=eqXF57zd;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0E7606A32A
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 13:26:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE0E7606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=eqXF57zd
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-49465892f7bso1755385f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 05:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795094765; x=1795699565; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9RCUmBluXL32Xv+pv5scriRF4mb+lkStDc3uAW97NWc=;
        b=eqXF57zdzmQDLfKdV8n4nOb14LDMH5RQc+fwh7P5Z0QMUxC+x4bGdJJGZ5SG5xMWla
         G+87ofAkXpBfNfZMGgiN4OKHsEZNdGGqzwdDCEzG/4sLLSvTF01CpUlJwrlGEfxt/z0h
         hAKb6G3u8jdKI5bIE6zkEJFsOSD/LNBqPkTmWZ75qRlEks8RBi4kx3am+/HIG/FQHbd4
         9gEVKZ0gXACqomOJMHn8wwQXk2UdbmkxhGLO/G3puI5I1Dunfa5kqVWZCu+nWk7yNzUD
         VVu8fd0RdMDP2KvylHv/3Ug09R4Hz/jrQFK7DswuFLB4GVNHInc2RBHE5KxAvnuRkia5
         V/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094765; x=1795699565;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9RCUmBluXL32Xv+pv5scriRF4mb+lkStDc3uAW97NWc=;
        b=ozeXgDy5o2QTHsi+22qfYqc4YNvdSKDwMU7btoVjTuF7ESGt/viIAW/zHTalEHHFmy
         YNsmwdtkLQdxx1GXwkW6uNKnrvH7D/k6bHmSY36ByU1KG6bUrNAxGvS42D4fEcMLMffo
         BFp70kWelFll04Xy4uKp5MB9mlj1u5+u4UZ6ENZB2Rs1iBVAJHg6ekkz5jSo5STIIH75
         NnvC+JAHLndEGdcJt8NLGgG0DOSx2stm0SgbGN4vgtxx6mJyGNHb6uVklLhpQF9krw0W
         r6XA9Mu3ymCaaw0c4pYy7l5vEZAEyk2svQT7us0QXHyk20eBlKTvUn8u6/SuraA+jitE
         WGpg==
X-Forwarded-Encrypted: i=1; AL+hErHRwPZGyichcnC4l9BrTP4Jw+yZP4J7kRh2+vtwHFHm8hxaXrCptUyCwlZoHx5+ehmNJespFZA=@lists.linux.dev
X-Gm-Message-State: APuU4Z/myNQnSfOv2tWrSWXC/sDAm7PEvQLLhnXZT9gTTkl/nyO8pcMv
	Af1CG9LhnpLaTe0LlK2qKqjnD3JSNoc85LJIUQFkI3eIsNEFsf2jq+cOrYY6g/eyC10=
X-Gm-Gg: AYBFou04odWDqHpctlbYzTDI/JATRV7zHlDxfBpMrvfzmyerZBzoNsy/2lwB9rFSFLV
	uxggd+W2XvQhfKzwLJwXOn6qd9FksrspmzP8u4dB7e4jrnspNBVsLRv0T5+26QWYFC8UatKuleU
	15cp4cev6DP7jjYPOSyorZaJCM9auLIWcLlq3UIif0s28qUjujiJ4FGmRJ2BHtz4FPJRmIdqdQ7
	UXxk1W0F+CE4dqZH9kU/VyYCoocnl0Wmr4SfoTKKI/+PXdVqf95qHroZ1GfTD2/LzdKNiKT9zhd
	KFkHmPya2yxZLo9vbdZSa5rU29FaWYGLYCawvDuyxALqZTijCci7gbBDmiZTt7RLq8ESwqX8gpW
	C4t2Zp7zwG+nUEMCWaQBe6O6eiTlErlFY2eVh2XtIBdOyQh5RNi4Gt3BUlD+nRbp3Amw/jbp7KE
	YGwSwvNW7Gv56j5Wj7+YIfBiTun/73HjjbUHuyuIO+SAIADhURihTLfHqeKUixgMVD+deCFJUQi
	TjsBipwdaWMlqFs8OBEbztcBQraBWXXahsEbuqN6XDhP4eb4yk9p2DBEwzW6PjUFvNUtZgiMacq
	CtiLBSzPEx6S5/Ze2bU=
X-Received: by 2002:a05:600d:19:b0:4bb:8701:a2df with SMTP id 5b1f17b1804b1-4bb8701a2eamr15744495e9.17.1795094765053;
        Thu, 19 Nov 2026 05:26:05 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb85342cedsm36282605e9.4.2026.11.19.05.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:26:04 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Thu, 19 Nov 2026 16:25:35 +0300
Subject: [PATCH v2 2/4] KVM: arm64: Trap TCR2_EL1 writes when S1PIE or
 S1POE is hidden
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
Message-Id: <20261119-nv-tcr2-v2-2-3deb1a6cdba8@pereq.eu>
References: <20261119-nv-tcr2-v2-0-3deb1a6cdba8@pereq.eu>
In-Reply-To: <20261119-nv-tcr2-v2-0-3deb1a6cdba8@pereq.eu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jintack Lim <jintack.lim@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0

A VMM can offer FEAT_TCR2 to a guest but hide FEAT_S1PIE or FEAT_S1POE,
for example this is done to keep the VM migratable.  KVM then stops
loading the PIR_EL1, PIRE0_EL1 and POR_EL1 registers for that guest.  But
the guest's writes to the TCR2_EL1 register don't trap, and the CPU still
acts on its PIE, POE and E0POE bits.

If a guest turned these features on, it would run with the permission
settings another VM left on the CPU.  Technically this is a kind of
information leak and a guest could figure out another guests permission
setting based on which accesses fault.

For these VMs, set the TCR_EL1 bit in HFGWTR_EL2 so that writes to
TCR_EL1 and TCR2_EL1 trap, and clear the hidden bits in a new
access_tcr2_el1() handler.

Fixes: 58627b722ee2 ("KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the guest")
Fixes: b86c9bea6349 ("KVM: arm64: Save/restore POE registers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: This is a new patch

This is only a partial fix, I will update nested virtualization in the
next patch and the !vcpu_has_nv(vcpu) condition in __compute_hfgwtr() will
go away.
---
 arch/arm64/kvm/config.c   |  5 +++++
 arch/arm64/kvm/sys_regs.c | 14 +++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index e295435a30b8..f756f7c4fdf8 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1896,6 +1896,11 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
+
+	/* The CPU acts on hidden TCR2_EL1 bits, so trap writes to clear them */
+	if (!vcpu_has_nv(vcpu) && kvm_has_tcr2(vcpu->kvm) &&
+	    (!kvm_has_s1pie(vcpu->kvm) || !kvm_has_s1poe(vcpu->kvm)))
+		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
 }
 
 static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index afd7e76bedff..3899702d438b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -615,6 +615,18 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_tcr2_el1(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (!kvm_has_s1pie(vcpu->kvm))
+		p->regval &= ~TCR2_EL1_PIE;
+	if (!kvm_has_s1poe(vcpu->kvm))
+		p->regval &= ~(TCR2_EL1_POE | TCR2_EL1_E0POE);
+
+	return access_vm_reg(vcpu, p, r);
+}
+
 static bool access_actlr(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -3501,7 +3513,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
-	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0,
+	{ SYS_DESC(SYS_TCR2_EL1), access_tcr2_el1, reset_val, TCR2_EL1, 0,
 	  .visibility = tcr2_visibility },
 
 	PTRAUTH_KEY(APIA),

-- 
2.53.0

