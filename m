Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D0616E89C
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901184; cv=none; b=RjX3j4bdcdhHYEVSyAQpy+cbEsmNmgAflK88ScERHWRhypr2aEiLG2qjD9wCoBdM2uf7pjQkVP9SpbUum2FLyXc6UjiLT/iSdGmo2xkuJiJJXFf+pi646iyWkqU5sh2+k5jffVGVnNR3W1+xqV8BSiiFep0dFfAod94wVN4pqAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901184; c=relaxed/simple;
	bh=eQtBlMeWX0f6KAueJvpyyhfPakemB/PoiU10QfPFVtA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oCkNScNt0tT9h83REFlbcItrYREZ0vW1rydfyCmNhMeRPC4hKPY+FDlxdG2oFUPd3cfZBpQLIuHtv6wZd9BE+oxtVhDzMChyDJ/9gP5jGuU1srEthZD1bw1NteY9SpRUOS2liprsV1nTmcdv8wGdrg6hbeY6huyHCWOpM9vK0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bgM/4EWn; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bgM/4EWn"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-35502b6f973so447789f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901181; x=1717505981; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=daRpCEHOmv3CdVavwX5fJITEQSPSMo7n1xKsBHmKg2k=;
        b=bgM/4EWnpYKUTKHed9qc2LFQmyMwzHHLDxbnoEMzDOrm/lkF4LPfY/54H/c2/sxbQm
         xfwtAHcGDVbwJDnP1Ahm9qUgF3FNgkCt3GihQej7hy1VzqBFGAjodHQAOQimNpOhw9OV
         2VUvQkRh9SHHoJEx7pE0ljRpvpG77sZAYTMKiXhd6kSxDL68b3QXK58GdskitG8FT4ph
         6RGoa0kfJGNNXVMJkj12ow1hl2RYAjeDsFRYueFRE8uIPVFxYOpVPsa3Z97VkDnclMCN
         IISPoPqMdVt/bYJQTy9IX7Z74EzEF3CKw0frOgB9gdNf36Tt8Yl6ZtKluyqj+1G1Vz4Q
         6J3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901181; x=1717505981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=daRpCEHOmv3CdVavwX5fJITEQSPSMo7n1xKsBHmKg2k=;
        b=OIjD9fyIHrRd4sC1Y/x77Eeb4qpW8aQQrv2S85FNo9A6Rg1sc1Toos4vKEX7BpEvzq
         tG5Y+4AB2TXIIGi4pQpZkSZgeVtlaCsMM8PpwyYPjm1DYc9uKU3xYibKmiAtLXqdtEDn
         qrIU7voJcRKXUYlIEtn0JaA0vuw+SflymHpgQnkXeKcO8p3fIrqKuimgX+U8L1rMOUgj
         OBjbMDQWiKzgAnHEIEdLcOcOBRuxX0FQ8uR75rjCQzAnTWgpbBHdLDBOLpEodBYauFhK
         37EgKaDpmbpsHFe4vEO1hbLGhM+hhxFjHgGAGojnLxx9VOhbg2ghZ3DeHOaAZiuPrl5n
         WC4Q==
X-Gm-Message-State: AOJu0Yxv3hV7UbeuMlrsenPQ/bf628Qct0hg9sZhJG3SAMXo9z0i+AM9
	DQhebme4QTRoylFpfcbs2DXn2CekeCDW003osq+hSfYiJoMAqHxs9oggQxcxuKFuQ7sfIG8AJqz
	x/TOPQPKXp/LqgOmz98mPi5am83qMkaurpLlRktpamBAzlogbkWRdg7OYG/7uHSQR2Zl97TTWHe
	lEw6A3DoE4Sxx0kz160i/uE0rLlsA=
X-Google-Smtp-Source: AGHT+IGBI8EZQnL3nBg2jy+S4h22WZdoLVWAvCyI0X0YfCdNRKLbrtcxkefnemka3Hzt+afPjLnod/qCmw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4b85:0:b0:355:291:19de with SMTP id
 ffacd0b85a97d-355221689a3mr23715f8f.9.1716901180145; Tue, 28 May 2024
 05:59:40 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:13 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-11-tabba@google.com>
Subject: [PATCH v3 10/11] KVM: arm64: Do not perform an isb() if ZCR_EL2 isn't updated
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

When conditionally updating ZCR, no need to perform an isb() if
the value isn't updated. Introduce and use
sve_cond_update_zcr_vq_isb(), which only has the barrier if the
value of ZCR is updated.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
This patch is undone by the following patch. Please consider one
of these two patches, or feel free to drop both.
---
 arch/arm64/include/asm/fpsimd.h         | 14 ++++++++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  3 +--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index bc69ac368d73..531f805e4643 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -219,15 +219,24 @@ static inline void sve_user_enable(void)
 	sysreg_clear_set(cpacr_el1, 0, CPACR_EL1_ZEN_EL0EN);
 }
 
-#define sve_cond_update_zcr_vq(val, reg)		\
+#define __sve_cond_update_zcr_vq(val, reg, sync)	\
 	do {						\
 		u64 __zcr = read_sysreg_s((reg));	\
 		u64 __new = __zcr & ~ZCR_ELx_LEN_MASK;	\
 		__new |= (val) & ZCR_ELx_LEN_MASK;	\
-		if (__zcr != __new)			\
+		if (__zcr != __new) {			\
 			write_sysreg_s(__new, (reg));	\
+			if (sync)			\
+				isb();			\
+		}					\
 	} while (0)
 
+#define sve_cond_update_zcr_vq(val, reg)		\
+	__sve_cond_update_zcr_vq(val, reg, false)
+
+#define sve_cond_update_zcr_vq_isb(val, reg)		\
+	__sve_cond_update_zcr_vq(val, reg, true)
+
 /*
  * Probing and setup functions.
  * Calls to these functions must be serialised with one another.
@@ -330,6 +339,7 @@ static inline void sve_user_disable(void) { BUILD_BUG(); }
 static inline void sve_user_enable(void) { BUILD_BUG(); }
 
 #define sve_cond_update_zcr_vq(val, reg) do { } while (0)
+#define sve_cond_update_zcr_vq_isb(val, reg) do { } while (0)
 
 static inline void vec_init_vq_map(enum vec_type t) { }
 static inline void vec_update_vq_map(enum vec_type t) { }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 24b43f1f3d51..162a60bcc27d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -314,8 +314,7 @@ static bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
-	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	isb();
+	sve_cond_update_zcr_vq_isb(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index b28d7d8cdc30..cef51fe80aa8 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -31,8 +31,7 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
 	 * the guest. The layout of the data when saving the sve state depends
 	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
 	 */
-	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
-	isb();
+	sve_cond_update_zcr_vq_isb(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr);
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
 }
-- 
2.45.1.288.g0e0cd299f1-goog

