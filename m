Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587D0EDC
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 10:38:04 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id y2-20020adfee02000000b002bfb44f286dso2889799wrn.11
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 02:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LkxKzYtJyLBnk6YaWLdXcrP+huEFDCptixA8sQJDrTA=;
        b=Cgj3iAnktqlF5j/X2Zs/AvWwSuC377hgw3vsTJuLls35Ku4dcC9GOC8s5WkGAsylPx
         8AD2/jIoyM8KmqnlJl59pnaJQeBFva/t4Qkup7aDeVurYyMFaO8bHtgpv6AV3plLPdQ4
         VCLJ7+3S1j2wHgTZcZVoLoIOnxREru4FkIT04NnLjyfs2ZAI+CoC22iK7KKmdYDbZBEZ
         A7JU0AkOvPaLeskvPozEUdct2hwGx13diIFSZTkyz7MbnZCeqMX5U/yK5A59yhC5ukaQ
         Ho7EhcjY2SG2hUizVbhCRUNeOMprPoAbyuf60umZEht/F//XRPeLdP5kQyxywilKLbBP
         xWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LkxKzYtJyLBnk6YaWLdXcrP+huEFDCptixA8sQJDrTA=;
        b=wZ+v6G42dk33dqQwGpKBWhiN4P4iVHQrCmrQsQLCY4HmkkOIDyt3pfOE/+LO47DXre
         HVluWGLYdvGnimbku6ief7KrVsQ46xybaMdHExdIChHl9cE3PSOMQdU6Hs9IPf2+EX/3
         9PXInZqVyp2yO4qhOJfPMI97mZ2NFKL6Otc5dRUEpvtp8OPTU+gYhjo439D3wPuFo1La
         5b44ffWUfjRvU/cEp9MJYMXPxwA1m3+u9BzjuG7waFflz2vM3ArUxRzAVVsLYhe7xcvF
         cgX2hMOc8q1n2JHaFClnYgLg2Wx90rjoi7Zoi25NIb2AvZoK5JbQ69R3jG3Pa5HiOp94
         zc+A==
X-Gm-Message-State: AO0yUKW2Mlr6gZfvanNSnF7eKnH3oNs0vjbFcTOXaLYr52LPZBLN2VDp
	lcGCq1qKuVnAQTyAC3AmOLufqRs3FZr/
X-Google-Smtp-Source: AK7set+4dyT64Ybcc5I/aCMrcw8Vd3S+aCXtsLCGbugPPvCPuVOfo5Ea5wI/nh9/m6q+UBsRN/El5Os2d/wi
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a05:600c:4f0e:b0:3dd:f488:4a87 with SMTP
 id l14-20020a05600c4f0e00b003ddf4884a87mr67576wmq.54.1675247882739; Wed, 01
 Feb 2023 02:38:02 -0800 (PST)
Date: Wed,  1 Feb 2023 10:37:51 +0000
In-Reply-To: <20230201103755.1398086-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201103755.1398086-1-qperret@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201103755.1398086-2-qperret@google.com>
Subject: [PATCH 1/4] KVM: arm64: Provide sanitized SYS_ID_AA64SMFR0_EL1 to nVHE
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

We will need a sanitized copy of SYS_ID_AA64SMFR0_EL1 from the nVHE EL2
code shortly, so make sure to provide it with a copy.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 6797eafe7890..bdd9cf546d95 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -122,6 +122,7 @@ extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..d9c6ec650b42 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1887,6 +1887,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 0f9ac25afdf4..08d2b004f4b7 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -26,6 +26,7 @@ u64 id_aa64isar2_el1_sys_val;
 u64 id_aa64mmfr0_el1_sys_val;
 u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
+u64 id_aa64smfr0_el1_sys_val;
 
 /*
  * Inject an unknown/undefined exception to an AArch64 guest while most of its
-- 
2.39.1.456.gfc5497dd1b-goog

