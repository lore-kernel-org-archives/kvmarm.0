Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78583A16B6
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 09:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168991; cv=none; b=q4KbkV8ASQiytM7mzbhb+/QCopV16+xaSd/DmYMaVpzlvcQCV6GrpS1cRiW5dSd+GzoBRGN+1upes5EvsQCfMz31XJnbHt7rxnulZGO3PpzrspDN92QOsxvjQNrBupWGqVOohVpKd3//CyWzSud1i6hODoipz/rLezt9s06I5Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168991; c=relaxed/simple;
	bh=DlQCC1b2cyDyfn1MMrV0+zXgkrjFpHKtJMb4vJOp7og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9Lz1fKEaJF7f0wtevrSBLfLqUC6/j8XNpmN3LisdN2oUKdvkDRuRCh0I4uwi58Etvd4X42DJ8X2gHUcheQi8EoaRdew7nxkISDyI+fEOqg9oNJdERZAJxL/AEhRZnB0xrHYkcp5Se1BYiRdk9S2vnhsMBd6jXgE9NGa+IswhwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmzvW/tO; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmzvW/tO"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bf36a6905cso55153325ad.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 02:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781168990; x=1781773790; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hJQzOmFV/Ytg9nEqGh0nKDO0htHLo9gYwrvtn/DgpM=;
        b=jmzvW/tOSNibNab5mXMy65hn058XpkHugIFVKVnUhUJDAmf9Rrevsa2aEBZpKpykt6
         Y0aNllsbe03RRhri2Wfi8vh5Ce+3e10Iuy45Zt0iW7mPuA+v3jdMsCYr1vF91KjrRVKv
         EvFMMRsJ2rO0kz4d5+x8JoY6OV3+7ppQBbr6cSXsQi9m3DUwDlIe1ALzQdib4U23lAA3
         gzTeGLqTqGJKZwZoNfW1W4LBEfn83rhx79f73k7XMUzJG45TIRS58p0K5pqMUVRY2PR2
         xIX99wiswhhAKys1pjFGN3G9LzToEskjqL/7aS19nIZIZsqoPADz0aEIfQ3B+n8zQKb0
         sUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781168990; x=1781773790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1hJQzOmFV/Ytg9nEqGh0nKDO0htHLo9gYwrvtn/DgpM=;
        b=eB8v/x3kemMBVtBKlAqFqOj/gA/wI/DIx3CYT2iC/dXIgk3G4EP1sACnstpflCJc8/
         ExAgGjiuydJl0pSw6mivAShIwO0nOa8ZX/1fLCSmbwhr5roEBV34DQaZ7drnMQ6R6RUG
         dlaUhmQgdO9JFnOkaJs7sPsP0QBjw8Pzxmys07OvDBmqiog0ESkbz27wAprnf3ey+voy
         1hR4FyI8LTPsV7ZeUkhE1Vr/hgI5a3Ygq2VI2QEhAhcCOakGSzECgiSG2WtXE4GaRY0b
         Kt7pHflINphVrFTWz2xfiJ+FO1SIt9hsmstTbiaJ/VEub9x8H9gsCHSA466CVm/ffNg8
         C7JQ==
X-Forwarded-Encrypted: i=1; AFNElJ/hXtwZXsfBU3Y0YdQdxGPG5QL7KRlCK7YSKmVSc7fQn2WOWWwZcLM45aAQRJul1gmg2kJFr1g=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSXPzv771HMCcEUeMFsAC4LZVvfwKBHcB+Iu9TFMPrShBsBVhm
	AWDbe1cS4sgYqvWcm81EXGfEp53Oxl8n8mg2wefZPoPQdH0vM2SKSb6q
X-Gm-Gg: Acq92OE3PBDBBrNul8LLx9Kf54OE/EYMeBl8OIoDaOlbJ5AmJda16WbbbBf0HIQct0A
	4+7ZbAO/k/VX9bFFSEMmSngswh0n1Sapew6t9eHjGeUe37lV9Nc5GXnPyncAxAt8Jz4gKDsnNNu
	tH70vBPB0Oz6Z7QLZdx2BYx2+a2GAL6mP5uOXxOuf0wtCZ9CsAJYLmlTeNQoCh330w8eWHlcauX
	Xn+IkTXY1zQwP2n8OsA2sUQPTXBca8oFczwVvu6yj7CH4310DWo4oEJ2dOKLH4P+78USyZHZqc1
	O2hY22cL3M9vcXHE7wz4QkQozWIX3LE1udIK+WEjH7sypNl+pRgRsMkOLJ7d6c0eLWVvmW7y9Xr
	vffHdfqKYubaviGv+uYOiAbIR7XN8GGlecjMH7QNZZ6beoFJWH337k5k+kGWRHGaBmQaafwpqY8
	3NVai1AN3y3XJJSM28m+RWuGs1irNM86AvMAVwwdaExP1mUJLm+IBnzdxb9dCJjNaQFg==
X-Received: by 2002:a17:902:e5c2:b0:2bf:1cda:29ce with SMTP id d9443c01a7336-2c2efc6b356mr20900295ad.6.1781168989874;
        Thu, 11 Jun 2026 02:09:49 -0700 (PDT)
Received: from localhost.localdomain ([2408:80e0:41fc:0:4a46:1ea3:200a:5fb2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f8792bsm279519355ad.23.2026.06.11.02.09.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Jun 2026 02:09:49 -0700 (PDT)
From: fuqiang wang <fuqiang.wng@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: dongxu zhang <xu910121@sina.com>,
	wangfuqiang49 <wangfuqiang49@jd.com>,
	fuqiang wang <fuqiang.wng@gmail.com>
Subject: [PATCH 2/2] KVM: arm64: Skip unreset vCPUs in MPIDR lookup table
Date: Thu, 11 Jun 2026 17:09:34 +0800
Message-ID: <20260611090934.84469-3-fuqiang.wng@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20260611090934.84469-1-fuqiang.wng@gmail.com>
References: <20260611090934.84469-1-fuqiang.wng@gmail.com>
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
 arch/arm64/kvm/arm.c                 | 10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5bf3d7e1d92c..8158e88aaa4e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -506,6 +506,15 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
+/*
+ * Check if MPIDR matches hardware reset value. RES1 bits are set after reset,
+ * while a zero default indicates a vCPU that has not been reset.
+ */
+static inline bool kvm_vcpu_mpidr_is_reset(u64 val)
+{
+	return (val & MIDR_RES1_MASK) == MIDR_RES1_MASK;
+}
+
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3732ee9eb0d4..b47088201683 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -890,6 +890,16 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
 		u16 index = kvm_mpidr_index(data, aff);
 
+		/*
+		 * In the CPU hot-plug scenario, the kvm_for_each_vcpu() macro
+		 * iterates over all possible vcpus. For vcpus that are not
+		 * reset, kvm_vcpu_get_mpidr_aff() returns 0, then the index
+		 * computed by kvm_mpidr_index() will also be 0, thereby
+		 * overwriting the original value of vcpu0.
+		 */
+		if (!kvm_vcpu_mpidr_is_reset(aff))
+			continue;
+
 		data->cmpidr_to_idx[index] = c;
 	}
 
-- 
2.47.0

