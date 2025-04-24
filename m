Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0C82951B1
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504071; cv=none; b=jCW4oIfR+RcDo6i//x8+F03LQh05T/pXdyBcba7q5wDlUGhsT8JjnLCP7/gjZ/pkUBhcuYUEwN/S4lZF40hlqPvS2Ww5NeNj5cLT9sU63Fobmyw5PEpOfuLxptz0DsovUfzOpoOxzP/z1Eua4wP1FVEP5+D6sTMlu8f3k7+xgRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504071; c=relaxed/simple;
	bh=lrb7r2WDY6/wiV70trrJFyhVfjh+ttGLRTnjEamSc+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FbS874J4tKxkbx2GXnXOzcx6QKbRZC3i2S2oYEVpmBrVi/Urp6s0rtonTNp8xlZ8jhUxZCsx6ra2E+m0wL5gNUnBDxQfC7DxSQrND9lVTQJsorbAXgRigtaa/uiuFlCJKcnSfS6wHxPrO1n4HXd6k2acMUHg6yydb6lNqlhnk7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EOOr3Aty; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EOOr3Aty"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso9462995e9.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504066; x=1746108866; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+7xBf3XhJMHfpZe6B0obtpZq77mLhIssmTOLfcblvc=;
        b=EOOr3Aty1LyTR0z65LqGD28eyKFeboVTnpoEyZilPYjYM6cpfaDpTKuUljF4d5Clwv
         McEJFj6oZGjwkPCQ0kmVlGCcozamx09tXqxSZFNoQVrTofI+zK1x51Q0nAByebaVJNTv
         5XUlqrhSzmoASpe3BuGolGSyjKCUojOtteE9Xd7OE1/7J4d5XpyHTy94Yh3zlTuzgTPd
         knu/TS4H0Dw8C5nox2Vime5Alx5pb4WcGLxiRYaiSvTgdks5z6DqyxHIJT4jRLR2O9v/
         gZ0hV6TpBz1Vt9/2rvDudHNmxCm73iOomO7MZlDXr/J+vmNbFwuWq0iK76MMIq8uo2ew
         wWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504066; x=1746108866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+7xBf3XhJMHfpZe6B0obtpZq77mLhIssmTOLfcblvc=;
        b=cN5OIuxG0acNP/UryJAyoKlUlTrC49K/HL3OjN0FfOYZGnMPWAyZ052mGtgw0AOy01
         OlYEc66z87ZAh4xiVxL3Q5AZ9TqVJSX8jE8GLW7Eyufdxvj9DcUE6vfI2ZPq+Y/A2HOH
         gzDTe3szP07Amq9d74YjKhjL2a4+oHSHRkuPX1ZUqwQTHXDcyw8iA49o7L3QIt5m84Ar
         kGxiNdGO7ZC1qhVaJeNLihu8B5NphFbU2S78tMM+Pj/M/APQw3PHySc9oQR1hPIC1V4U
         2LgZO/6y90HiYTgv0XHLRMsvwsUlYKo/yW3zTfCO2T9+9J3ArX0Rah2ikVW/LvLtrXzk
         nlaA==
X-Forwarded-Encrypted: i=1; AJvYcCV8ikQZT3kucRTc2ppuA4tMkSsapWZLXx4pPIBPU++239wT7m3w+YhJVQupWihySGSBCTrfdBU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKPuBJfMjl3GR1uWkI3LTFHa3AZdOpz74Oju/BDGn2mk1KIvw3
	VJgbpIJAsJ+iJOYhBADr+ay3easD+ktpTsJguMBseMG6ia2RBEawk9w5QBwnVYw=
X-Gm-Gg: ASbGncuVea6n9ZpdN8ALDx4uWQuUVPi22Nd2vUfP0dLhjH8KyYVmLLQ15myYgAT3I8h
	rS3CdB7Nb1hzvzZ3rVi9s+GRCNTtVb8h7H+5t5aML3klqhtGGQq1UeYO2wu7E19id+JfxX+u/wD
	7tSw+q5Pt3VZnOAAC48w+bvIAOINgJ76cCZouOY4nBQC3fSzBhq1sI5eOJyA+i0z2wpZzYfu1n+
	NbOZRbKs36mgG5XS6f95zYpoeW1Gjqz7ITKa2+gVERLqJcsej2Qk9ywBXDFB9IrmEo7dN88uTF0
	qduom3FB+HswK57i3r7J4Yy0G4E3JnBhuQ6uGz/RkzTihx5NVfL9LlQP77oCSBMMQBGeMKTlVgA
	TCEhpZfazysnmBgd9
X-Google-Smtp-Source: AGHT+IHRjNQ9hktsGOI0gDbs88pFfwmyof1gAXg0Su1amTrqhLAxn7c+kspUyHkoAKmkYrrR9nwrhw==
X-Received: by 2002:a5d:48ca:0:b0:39c:1257:cd41 with SMTP id ffacd0b85a97d-3a06cfd462dmr1866395f8f.59.1745504066490;
        Thu, 24 Apr 2025 07:14:26 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:26 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 31/34] gunyah: allow userspace to set boot cpu context
Date: Thu, 24 Apr 2025 15:13:38 +0100
Message-Id: <20250424141341.841734-32-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow userspace hypervisor (e.g. Qemu) to set the context of the boot
cpu. At the moment, only the program counter (PC) is needed.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index e8037d636e8f..df922be2429e 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -1703,6 +1703,24 @@ static int gunyah_vm_rm_notification(struct notifier_block *nb,
 	}
 }
 
+/*
+ * We only need to set PC to start of kernel
+ */
+static int gunyah_vm_set_boot_ctx(struct gunyah_vm *ghvm)
+{
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(&ghvm->kvm, 0);
+	u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
+	struct kvm_one_reg reg;
+	u64 *regaddr;
+
+	reg.id = core_reg | KVM_REG_ARM_CORE_REG(regs.pc);
+	regaddr = core_reg_addr(vcpu, &reg);
+
+	/* We only need to set PC atm. regset is 1 */
+	return gunyah_rm_vm_set_boot_context(
+			ghvm->rm, ghvm->vmid, 1, 0, *regaddr);
+}
+
 static void gunyah_vm_stop(struct gunyah_vm *ghvm)
 {
 	int ret;
@@ -1790,6 +1808,12 @@ static int gunyah_vm_start(struct gunyah_vm *ghvm)
 	}
 	ghvm->vm_status = GUNYAH_RM_VM_STATUS_READY;
 
+	ret = gunyah_vm_set_boot_ctx(ghvm);
+	if (ret) {
+		pr_warn("Failed to setup boot context: %d\n", ret);
+		goto err;
+	}
+
 	ret = gunyah_rm_get_hyp_resources(ghvm->rm, ghvm->vmid, &resources);
 	if (ret) {
 		pr_warn("Failed to get hyp resources for VM: %d\n", ret);
-- 
2.39.5

