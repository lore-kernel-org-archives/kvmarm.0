Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF4A30BF66
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852714; cv=none; b=bfc5GxmIupmU8M+qkE/dR5F48ACE3rts7QBo8FBBSl7DhYzgUzMaqQwiRPcQA6HRIv8PTVBd/j0aeAsMqNHbeDkA86IquoPWNc61fkE1ZgxjSayYYh4F6lzulBQoyb5QFVP6IdtSuf5bYm1rX+tF2shggUlcNqiRCP23x6IE7HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852714; c=relaxed/simple;
	bh=p8zLycY+wAssG4/53MKFl1WK0XraVe4S0eUc1H0xs0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=to9Ey9nW2JJ3sggtkNmcp46b/xwYfOLQCtdt66y01v7jile+Xf5WXzNd2K7msrN9FgVzzc5sHBcO8WUz8DN3/aUpJIympt9bBQyrUR7yPVoTH+OwCbav8wavYFmK8Snrj2cyqYE1VkTt4sDzGLU3GCN0D3cyz7lgjNu/VRaUOUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B4qLK+jT; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B4qLK+jT"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b8adf8b8so14271135e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852711; x=1782457511; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UbL9lwJzeVbN1iJUU9ZRwmA6X1IAE6tmxjMtgc8Iqwc=;
        b=B4qLK+jTiWzjNw7z31mNI3vy7fcGneFaZD3P73cmc+5l7G2oWsqm7VESwX3OPDKnFc
         SMR4SugqIjpRGLGogy8XxJ3JoH6/8XXP8rTQnqXsa2QRK1zIuAOTydfz8gVfRduYSZYZ
         y+dGJ9Q9YabkypbsI8U9XaQTAk0kF+nApTnsXJbTITjiRaTKUyA+sCsOwG8vbnJ0i+2W
         CPuNtDfXM6guSnEQMAradlA/swkA3SQockqXrkrDsEhzFoFD27uUSPbzhAbj72IyfqkY
         9DolqY5jypX9Pb5e4OdA3oJNPi/rjGuUEIH844JrNks475lGx/x/21imJ6EBbM0frmMS
         2l6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852711; x=1782457511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UbL9lwJzeVbN1iJUU9ZRwmA6X1IAE6tmxjMtgc8Iqwc=;
        b=AdQfKSipUuULPXiMgwB3KQk5rsUDsPXrZLuFFK6MUrptp6ZAqRImZvWQqvtW0lmHEI
         Gz/LYqrBTOKGNr2mxx+jR5ekcj8r7q1xKJd9V/m4URUStBrKxxYdGntPDsJgEkYUntDf
         IEI9jp1OPir5lF+4rDzT77COCTncmD9RbdOU0NVxy257MOCmrtFNA6xxZHugw4ZMMy8b
         uhZLZUjZ6cvEvPKDr0hda0i8fP0IcTn9P9h1UZ2BYb42HRhtbZOwCjyEUZRWojTOvqTh
         I40njFwYU4aqoy2yaHjoBOvr3MGrPb/Oe6VtUg6X9wedAslcFCa9W/3WpPJAXAmvWQKd
         Luag==
X-Forwarded-Encrypted: i=1; AFNElJ83AyfwhhpCRMq00CWb52TAnhPdslUq5Q77s11qkPVbYP5Hzql91UrUTIApZA0X+mIUq3mmUJ4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx74sYvtZgSXgJOzreJRoY74aXhqW9+gHx6tuXnHJMdvaJAYQh6
	dc6/vHZ78XQAgTE+l6SEo/A26jkim0FuseeeLq0xdzb/WHAhqw4dpdF6jIVAUAxLkdAyHoCi25C
	UgQ==
X-Received: from wmbdr18.prod.google.com ([2002:a05:600c:6092:b0:490:9d65:494e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5493:b0:492:1ea2:6258
 with SMTP id 5b1f17b1804b1-49240e7b049mr31031545e9.33.1781852711056; Fri, 19
 Jun 2026 00:05:11 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:05:01 +0100
In-Reply-To: <20260619070508.802802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070508.802802-2-tabba@google.com>
Subject: [PATCH 1/8] KVM: arm64: Extract MPIDR computation into a shared header
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Extract the vCPU MPIDR computation embedded in reset_mpidr() into a
kvm_calculate_mpidr() inline in sys_regs.h, so it can be computed
without duplicating the logic. A follow-up series reuses it to reset
protected vCPUs at EL2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 14 +-------------
 arch/arm64/kvm/sys_regs.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 33c921df19b5..674fabe1d40d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -976,21 +976,9 @@ static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 mpidr;
+	u64 mpidr = kvm_calculate_mpidr(vcpu);
 
-	/*
-	 * Map the vcpu_id into the first three affinity level fields of
-	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
-	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
-	 * of the GICv3 to be able to address each CPU directly when
-	 * sending IPIs.
-	 */
-	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
-	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
-	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	mpidr |= (1ULL << 31);
 	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
-
 	return mpidr;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 2a983664220c..bd56a45abbf9 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -222,6 +222,25 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
+static inline u64 kvm_calculate_mpidr(const struct kvm_vcpu *vcpu)
+{
+	u64 mpidr;
+
+	/*
+	 * Map the vcpu_id into the first three affinity level fields of
+	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
+	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
+	 * of the GICv3 to be able to address each CPU directly when
+	 * sending IPIs.
+	 */
+	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
+	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
+	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
+	mpidr |= (1ULL << 31);
+
+	return mpidr;
+}
+
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

