Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5B44D58F
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zF2EuABB"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-332e11a22a0so4862637f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 05 Dec 2023 02:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701771782; x=1702376582; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nsl2YYWjzyWfpOqWiIYZWMEIY6Tqfa70sHcibcvmU8U=;
        b=zF2EuABBZNRKJy6QtrUBKc56cSFd03lLzlZBsO7lC2u+BbyRG8Li+lUNs87foEVdgu
         66LUG2W9wEqWwIGGEAl0iQvMjro0DwacBkJ3SE/n+9cu0YOMipih2rB7nbLz6BCTC+Kf
         0oo5M86u4QacKxkvO8S55MWTLrPped8aY6w2FNE09lKcncMfLlj33vTZhQnIGKF2zV3E
         X78kiycMc2OESINdhG6rL/gFoKNZj+W8Ou6KeRS5bTal1KHUzRdKyvzmS/u6IjZ4/QtL
         f9g2hb8jXeCOtq516cuJlRlUnjM0RnhP+2N2UnGBWY5YRe4IAPbmjBcreIO56H3SEkDu
         w6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701771782; x=1702376582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nsl2YYWjzyWfpOqWiIYZWMEIY6Tqfa70sHcibcvmU8U=;
        b=nRWoDHmHuD3gcgob6UM0lUqD5H6zx28LUSCyNrMpYTndRdAokkcJKZhnRrdCzIgfRK
         +hHOaqqAqFHa5IWc43wFZ8hcdD9N86HvB+fAHb+SU1ZILIX5tM68L50ixtXV3eo40kNg
         MxParw3dW3nvNIZXXJN/TpyEdJMQrFGimorFsy1XO7yOZVZeK2IsHpY0/2Xz3EE51NNp
         Pn4GBrtI4LWaiYS2zI/d340nijJPkcSuQECUU53tcEGYlxYNup1I9XL2IzwUtzepTGZX
         vgWUEpVvm8kb2Mc+iYsg/puMauXGxebWrfwETKF7EcEOlZleVh8HYRVpPHfNdM1zqRA0
         B3Kw==
X-Gm-Message-State: AOJu0Yz/ZyjW1Y0WRCKb4kAe+A+rQ4zcxUrLRMGMWIn2V4fo+2iYWFQ3
	WjYGE1q/HiE4mw+WO25MmRLvCS6wGhi7VhEyURbsFbiWLboE6Ny5z8JxHsJXoLpw9j52tMFqf6f
	MUuj3Z01X6XM6vKpdcUvcv9ME0x03FzPWdgVAtpMja4rWHcxKgA0v0HinogM=
X-Google-Smtp-Source: AGHT+IGc3JXd4AZGnIIfddtzEYdRl3d3707t9Y6hVwx3FZAfMEmHj/ndlXJo0QeFYZ+zl2D7AFOfbmNFow==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:fd90:0:b0:333:32d8:40a5 with SMTP id
 d16-20020adffd90000000b0033332d840a5mr116120wrr.7.1701771782375; Tue, 05 Dec
 2023 02:23:02 -0800 (PST)
Date: Tue,  5 Dec 2023 10:22:47 +0000
In-Reply-To: <20231205102248.1915895-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231205102248.1915895-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231205102248.1915895-6-tabba@google.com>
Subject: [PATCH v1 5/6] KVM: arm64: Trap external trace for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

pKVM does not support external trace for protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 4 ++++
 arch/arm64/tools/sysreg        | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 9d23a51d7f75..84b5c3f387d8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -136,6 +136,10 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 			cptr_set |= CPTR_EL2_TTA;
 	}
 
+	/* Trap External Trace */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), feature_ids))
+		mdcr_clear |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
+
 	vcpu->arch.mdcr_el2 |= mdcr_set;
 	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
 	vcpu->arch.cptr_el2 |= cptr_set;
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 96cbeeab4eec..02e1a4290fa5 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1115,7 +1115,10 @@ Enum	63:60	HPMN0
 	0b0000	UNPREDICTABLE
 	0b0001	DEF
 EndEnum
-Res0	59:56
+UnsignedEnum	59:56	ExtTrcBuff
+	0b0000	NI
+	0b0001	IMP
+EndEnum
 UnsignedEnum	55:52	BRBE
 	0b0000	NI
 	0b0001	IMP
-- 
2.43.0.rc2.451.g8631bc7472-goog

