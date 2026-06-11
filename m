Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1213749F5
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 14:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781188863; cv=none; b=gBfsAIfSNbazr0uwJ9OAkDrkUyrdXA/nYy/AaJ6viC6q8RUY1jYfjel+z61zNJEp3npx/223AyhVPqC+/ikfgtF45EpKSiRYcpbXi8yN/iuxEXUGLD2/OOZrPUt5kbtwxtQrCjDcF5CyyewN3mTepiE51lsFABiVYlWjAlgk3fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781188863; c=relaxed/simple;
	bh=vkRFnqFRZDNgXItUjQ6xqyVHK57bprpfgDRxGQKjzfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpkpSAZenPsDntE8/wQUQogjOxJPyK5UvdMTO9TMCS23YbH7poGH5i6hfo4SzLpMf8LUKv3bsFhEgiSBSNZWr4l1tyBqY7qr/maBDYl82khoeU1ybD6ms8alQqdqfB2AXFPpGVp/8HGxxI1k4j1gea2waNA/yf8Mmia3wWstBCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QounVKEJ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QounVKEJ"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c0c1e0b0faso55290905ad.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 07:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781188857; x=1781793657; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OKp05mDY6QDPFoLBnfnNv8HD5BOSRFbCTyjoLTQuk6A=;
        b=QounVKEJruyCZpLpplM00QsM5X6I0kO6jmQ+46xZLsDZ12Q5YzkBnHQ/DdEmeLcY5b
         w56aKUy5Nt4pcnagrJZ/bVtgvNjP06fTosNdcD470af8yZyowHz+kPHM105hZ1DZ8H3a
         KUzcZIp36anOBE0a6W9y0Gno3FcsCQ8JX+XtIH27iyfc3CDq+ywo1AU55heLVH+6baDA
         JgqeAT5Pka4IwiSQoFFcT4NtnY4v5zzfKCUQDtbZgB1dTZ94rM5RMwzYNFcG9uf5eLL7
         fh4SIiCEXr8sFKgtehkCmDlPPcsW9eC2ykxZtNQGSaJeWBhAVeyiS/RuE+G4o6mnc3DN
         zkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781188857; x=1781793657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OKp05mDY6QDPFoLBnfnNv8HD5BOSRFbCTyjoLTQuk6A=;
        b=CdcT/OnECnEXFJVLI2i/Qr5xLem4eJU6R83qLDNNDwyE5Nk8qT0TV8Fc3ZVnjz+Z6L
         UX/nZ2vwhMyM9CSC4QcYDBU3cb/0k2cs44Ff0ackkHTIQR/kMTWFjM+Rc+30CQ2YbjFn
         HKtGGes95TIf3qGwW4w/JgmbTziGSFW4g3Sduezfyc7vNlvZ6moQbMjSoglvwJHtuDz8
         Ai9fo43/OITqgtH3EYlt7P374yh/didpxuBmjpGn+dJ1WGaC0n8uu726SJLkwyrJlErN
         5DIH3cYSZ83FIyVrMi7NKPtdjhOnVLVAAM4aelx+mI85lFDAd1OGlnfrEqqMM2StBGuY
         bYkw==
X-Forwarded-Encrypted: i=1; AFNElJ9pzwK1feewFsJvsWZNq0zrK7CXf3MIaqnk7kBoj5CIS9cW5yXwQN2mnc/gwbklzUAy9yw3xz8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwU3/fwsOCm/ohFeH6Z3c6o1X8Cvq1Z9nHDHlcqUxyOi66yrvIe
	Eqktc2m37BDQmgVWoDOVyn/hscESI3lCdNmsxiucCQ4iPubIOIg4yFgV
X-Gm-Gg: Acq92OHz/OttBtelSk05CHInj9ogO8X7o3ZrKD14n8ety9fid82uV6XnvC+pAl/neI7
	NXoi1U1QFrh/JXzX/G5+zdWIl7sITXYDSvUvXCcV7xcMz7l3td2MzOxvuhDsJEj0z36Quc7Qys4
	mI/WoULoi8sRviRpqrgebS7+vFV5XOTCeS8rIoeh1iSxVXgFg4F8hssHepICIdNkHMO7MiT8zed
	YyZmNQf4oo0gFWY6Y7JjotrmMHjPrETVX1Hk0tSWWFtwX+8u3r7PGWNix9nG3twoNsKG3ine+OF
	9PLCgXhW0cOc8RgZAg39I/YCWlKwhapx7nliO9S2j7XqMoTb/n8ojOlHUuGx8NR3TYAlkMSBQJ0
	43zwztsetUmTzeuZvgdrxtECqDpCcbkwWQy7j6f+e+mMXLyHPdCxAKJ4pIbMkEltLyO/iiGpJ4N
	wLrxebTjRpmgqaUry14BQNpuyF91gdB0djHhl1MDdBQ927QJa4TOJDUkuMFZPx2iKZIw==
X-Received: by 2002:a17:903:1a8b:b0:2c2:8659:da3a with SMTP id d9443c01a7336-2c2f344a23fmr38855055ad.31.1781188857438;
        Thu, 11 Jun 2026 07:40:57 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:4a46:1ea3:200a:5fb2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c249aeb62csm161097355ad.68.2026.06.11.07.40.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 07:40:56 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: dongxu zhang <xu910121@sina.com>,
	wangfuqiang49 <wangfuqiang49@jd.com>,
	fuqiang wang <fuqiang.wng@gmail.com>
Subject: [PATCH v2 2/2] KVM: arm64: Skip unreset vCPUs in MPIDR lookup table
Date: Thu, 11 Jun 2026 22:40:42 +0800
Message-ID: <20260611144042.97981-3-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20260611144042.97981-1-fuqiang.wng@gmail.com>
References: <20260611144042.97981-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a VM is created with CPU hotplug support, kvm_for_each_vcpu() can
walk vCPUs that have not been reset yet. Their MPIDR_EL1 state is still
zero, which aliases vCPU0 when populating the compressed MPIDR lookup
table.

As a result, cmpidr_to_idx[0] can be overwritten with the index of an
unreset vCPU. A lookup for MPIDR 0 then returns the wrong vCPU, which
can prevent interrupts targeting vCPU0 from being delivered correctly
and make guest boot extremely slow.

Skip vCPUs whose MPIDR_EL1 value does not have the RES1 bit set.

Fixes: 5544750efd51 ("KVM: arm64: Build MPIDR to vcpu index cache at runtime")
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  9 +++++++++
 arch/arm64/kvm/arm.c                 | 14 ++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c..3d2f0a8b040d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -506,6 +506,15 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
+/*
+ * Check if vCPU MPIDR_EL1 has been reset. MPIDR_EL1.bit[31] is RES1
+ * and set during reset; a zero value indicates the vCPU is unreset.
+ */
+static inline bool kvm_vcpu_mpidr_is_reset(struct kvm_vcpu *vcpu)
+{
+	return !!(__vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_RES1_BITMASK);
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3732ee9eb0d4..fccfa97370df 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -887,8 +887,18 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 	data->mpidr_mask = mask;
 
 	kvm_for_each_vcpu(c, vcpu, kvm) {
-		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
-		u16 index = kvm_mpidr_index(data, aff);
+		u64 aff;
+		u16 index;
+
+		/*
+		 * Skip vCPUs that haven't been reset yet; their MPIDR_EL1 is
+		 * zero.
+		 */
+		if (!kvm_vcpu_mpidr_is_reset(vcpu))
+			continue;
+
+		aff = kvm_vcpu_get_mpidr_aff(vcpu);
+		index = kvm_mpidr_index(data, aff);
 
 		data->cmpidr_to_idx[index] = c;
 	}
-- 
2.47.0

