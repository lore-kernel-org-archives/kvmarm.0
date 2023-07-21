Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BCF14F98
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:51:57 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bc68c4e046aso1515463276.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 02:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689933116; x=1690537916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mf80e1OwyHu4f/CRae72DKiIlU/3p46CRlLr92KMZew=;
        b=DFBCQ0zcE4k5YCk0yV0RJtzlj82bMW3BQTaIpn/m0C3SHnv6WKnOs9qCHiBeQheCOZ
         ePH40Bfd4CHnugquiSTkxYJ7G4fPkq50pV4idboHfrptjYFdKgYN8LVgC1tM1t3skLt5
         JmpFTG1nQAoZ+l6VGNH1A37AUF0gMJUIFc5jkaTF1IkG1EV0SOPu2Tm1e+aKUF9ohDSe
         oqmzPSuhFDDB2EANB2EKEqH2w2YyxJaD3GQ1bsO7MH1WQ1XJs9fzt56pROhibBCk4JB/
         GDXu9u/Q/lwzG1SOP8jyHWUJuMw5CmpFaUmN1SzTDrM6ZiZSTp87uVK2MecfkJxtFs71
         xk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689933116; x=1690537916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mf80e1OwyHu4f/CRae72DKiIlU/3p46CRlLr92KMZew=;
        b=W0u1zop0dXhujT4Dp1ZSOfKbC2G8dTc1NeR56l2yBkEZHxmTPVTiFCXnJipnKNyVgF
         XfCEyfnXFVUN2Nj2SFmLVqj7g+hsy79+Erv0w49Ur7k+GfEywfl/hR3e+//sXoVdTye4
         al1QSYJ/MqCDZJF+YnJXnaEdfBEGrrZZh/exvE4DJNRaOldfV5FpDrOMfb/Ag80F97Gh
         M3xsU8Aw20qas8lnv+q+m+5vg3OqjiRC8GxgB4ex65tVsJ7sbnKGWsDBG63NTmd9PQ59
         u1ywEP8y5kUOuOAtDSibIcPCJmzQ1t653FOfFcnLay5vCCol8hP52PiQRRjBG8oOfKhs
         X0Lg==
X-Gm-Message-State: ABy/qLbP2n1SgY0ip2UJ85WRdzpfxntZe26tpucwQlCreHAVtwH/O903
	DoExaM7VxV+XPgAvMfSzzZMYZ4U4xeQfwzht+fdVopnZ1idM7eriMxt3lXSx2QM3iAtZhuvqjl0
	IlVeXNzE55sjOf6IlYikmVfqfNZfSWreJlOW3jv3BDG0fkyBcBni/byL49CI=
X-Google-Smtp-Source: APBJJlHnpW+10f8wTOvatRuyQfC2AjtUDzshrOMi6JheRexlu6aPqPG2BcNMwDSWefVnUdrDLvvQwiJPrA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:ba06:0:b0:c61:7151:6727 with SMTP id
 t6-20020a25ba06000000b00c6171516727mr10316ybg.10.1689933116009; Fri, 21 Jul
 2023 02:51:56 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:51:41 +0100
In-Reply-To: <20230721095144.306817-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230721095144.306817-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721095144.306817-5-tabba@google.com>
Subject: [PATCH v2 4/7] KVM: arm64: Helper to write to appropriate feature
 trap register based on mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Factor out the code that decides whether to write to the feature
trap registers, CPTR_EL2 or CPACR_EL1, based on the KVM mode,
i.e., (h)VHE or nVHE.

This function will be used in the subsequent patch.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index efc0b45d79c3..f5941f6dce49 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -571,6 +571,14 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
 	return test_bit(feature, vcpu->arch.features);
 }
 
+static __always_inline void kvm_write_cptr_el2(u64 val)
+{
+	if (has_vhe() || has_hvhe())
+		write_sysreg(val, cpacr_el1);
+	else
+		write_sysreg(val, cptr_el2);
+}
+
 static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 {
 	u64 val;
@@ -597,9 +605,6 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 {
 	u64 val = kvm_get_reset_cptr_el2(vcpu);
 
-	if (has_vhe() || has_hvhe())
-		write_sysreg(val, cpacr_el1);
-	else
-		write_sysreg(val, cptr_el2);
+	kvm_write_cptr_el2(val);
 }
 #endif /* __ARM64_KVM_EMULATE_H__ */
-- 
2.41.0.487.g6d72f3e995-goog

