Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21724364DE
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g+s+iKBa"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbcc8f895daso2273139276.2
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548152; x=1703152952; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BZpm5g8sXqlgN71zqSoD3PYKLpgzzVAPPBQdv9SzS9U=;
        b=g+s+iKBaTuZCwSeVMLVU2PF0h3ERvqW/5l2o1uY+mvWxvmXf2l789NO21dDNQWjy3B
         /e+vC4scFF9LUd5Xh6k4AI1frp22hrml0p2ddJLoGKyqEAR7ptyh0mpF64b3WqgWilAe
         rnITPz+/yAtFeqyor8NNcCkh9NpHjEqB2lulNxT4Kx2SLlAq2kZHji5hzkJY2qZ61C9l
         usg8jd8ihLwwfFdraPYrXmLEtJrdugCjVoEczraKo8p5fRuZeZCU1YUfPP2/vYTk2iBT
         BMM9wUSmaxykj1ee/L2oe6Mp7H4PRz/eQ7EkxQKJdFKjaRbL5YDAhdGjmBE25P4J9Qil
         c5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548152; x=1703152952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZpm5g8sXqlgN71zqSoD3PYKLpgzzVAPPBQdv9SzS9U=;
        b=H6Ym4FVG9sYfpFU6rLjnULQdsdv0a+Q91SZn75kB09HAqqd+GgxiiCINZ+biYe90LC
         7KvwHx1/WYKao5jhc0eWpZf1aCi85gr4nKEd0nravPVMWjULp6oYSIE79h1GfIScOpWa
         NzOcXSnhzPsSlbEY4rKsXJC8hLE5MRPXoqik0ax4vx3IYtw+roIfzITiP1277/xYDLVQ
         SFAm1CTqFHZfUSEkldn57A2eMN0DuclEZ35vOxj2ByWkPGmQ+r7jaeEze3EJMzIlurNJ
         k4+w19BqegUnxK9w4b4j0sb8rzuXHJGjT0zWlt2I2JCuVrkxRQl03FZBp6rJivF2pvB3
         EAVQ==
X-Gm-Message-State: AOJu0YyGwoNKF4Q3+LgI86LwZMVb1vTKfxlHAxGg7Vv5yH7rUJIM5YIJ
	10VYEjeQPFzJFHvZkT+Oz8s8kRRh/wrtRiujWcsu3y01iCf9y9AeQ87SGtG0LADJsTcTqGvyrjb
	OEG1SS30j3cDPociU6MXTShUFQ9lAsydx5p/p+2HMa2bpOvTy8+3lbD5eJ/A=
X-Google-Smtp-Source: AGHT+IF6Akn1Pi5DCUhyiJjAZLduSqaHqIoZSn6di1DIm8HQc07sCgOSlwvtGjmu28U/J1q4cm0p0M6luQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:150:b0:da0:3da9:ce08 with SMTP id
 p16-20020a056902015000b00da03da9ce08mr109580ybh.10.1702548151743; Thu, 14 Dec
 2023 02:02:31 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:54 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-15-tabba@google.com>
Subject: [PATCH v3 14/17] KVM: arm64: Macros for setting/clearing FGT bits
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

There's a lot of boilerplate code for setting and clearing FGT
bits when activating guest traps. Refactor it into macros. These
macros will also be used in future patch series.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 60 +++++++++----------------
 1 file changed, 21 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 17ce40f5b006..e223fc0d5193 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -79,6 +79,23 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		clr |= ~hfg & __ ## reg ## _nMASK; 			\
 	} while(0)
 
+#define update_fgt_traps_cs(reg, clr, set)				\
+	do {								\
+		struct kvm_cpu_context *hctxt =				\
+			&this_cpu_ptr(&kvm_host_data)->host_ctxt;	\
+		u64 val, c = 0, s = 0;					\
+									\
+		ctxt_sys_reg(hctxt, reg) = read_sysreg_s(SYS_ ## reg);	\
+		compute_clr_set(vcpu, reg, c, s);			\
+		val = __ ## reg ## _nMASK;				\
+		val |= (s | set);					\
+		val &= ~(c | clr);					\
+		write_sysreg_s(val, SYS_ ## reg);			\
+	} while(0)
+
+#define update_fgt_traps(reg)						\
+	update_fgt_traps_cs(reg, 0, 0)
+
 /*
  * Validate the fine grain trap masks.
  * Check that the masks do not overlap and that all bits are accounted for.
@@ -146,45 +163,10 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
 		return;
 
-	ctxt_sys_reg(hctxt, HFGITR_EL2) = read_sysreg_s(SYS_HFGITR_EL2);
-
-	r_set = r_clr = 0;
-	compute_clr_set(vcpu, HFGITR_EL2, r_clr, r_set);
-	r_val = __HFGITR_EL2_nMASK;
-	r_val |= r_set;
-	r_val &= ~r_clr;
-
-	write_sysreg_s(r_val, SYS_HFGITR_EL2);
-
-	ctxt_sys_reg(hctxt, HDFGRTR_EL2) = read_sysreg_s(SYS_HDFGRTR_EL2);
-	ctxt_sys_reg(hctxt, HDFGWTR_EL2) = read_sysreg_s(SYS_HDFGWTR_EL2);
-
-	r_clr = r_set = w_clr = w_set = 0;
-
-	compute_clr_set(vcpu, HDFGRTR_EL2, r_clr, r_set);
-	compute_clr_set(vcpu, HDFGWTR_EL2, w_clr, w_set);
-
-	r_val = __HDFGRTR_EL2_nMASK;
-	r_val |= r_set;
-	r_val &= ~r_clr;
-
-	w_val = __HDFGWTR_EL2_nMASK;
-	w_val |= w_set;
-	w_val &= ~w_clr;
-
-	write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
-	write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
-
-	ctxt_sys_reg(hctxt, HAFGRTR_EL2) = read_sysreg_s(SYS_HAFGRTR_EL2);
-
-	r_clr = r_set = 0;
-	compute_clr_set(vcpu, HAFGRTR_EL2, r_clr, r_set);
-
-	r_val = __HAFGRTR_EL2_nMASK;
-	r_val |= r_set;
-	r_val &= ~r_clr;
-
-	write_sysreg_s(r_val, SYS_HAFGRTR_EL2);
+	update_fgt_traps(HFGITR_EL2);
+	update_fgt_traps(HDFGRTR_EL2);
+	update_fgt_traps(HDFGWTR_EL2);
+	update_fgt_traps(HAFGRTR_EL2);
 }
 
 static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
-- 
2.43.0.472.g3155946c3a-goog

