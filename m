Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4375A6AA2
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 12:38:44 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-56942442eb0so56044317b3.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 05:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690202323; x=1690807123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mf80e1OwyHu4f/CRae72DKiIlU/3p46CRlLr92KMZew=;
        b=lXrCljxXK2+4BN/4SbQI/l39iYMqQ8Mt0d8IU4COLnWfOABVdRBLIIvov//yQSZIk4
         qWUzrQQUmFDpHfin+Ag0XUr2qNmufWxFyMQakfUpa5N/kmekuLDI8VBlIK/4KtpfjstU
         RDlhBpDoLMnxgP8dN4IOSZ1XkFVsIDRBpmka/Ur9zW+a3JgzUgPHpnlPPoW77MWyN8TX
         B4A/5z/LauD1sYFRHBwagvFxMSLRETUpXKAZmkSq5ikxt8qiiPLJk0Xfdr/gVrY3H2Lt
         KJqUTlQEqgLlUITYkoTfktmP2h6ImxlXAkK0SPz+cfs//3ZWyhxFF+qKE6EBCS6NsTHa
         o8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202323; x=1690807123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mf80e1OwyHu4f/CRae72DKiIlU/3p46CRlLr92KMZew=;
        b=TUX/bBjti+9+I3WtHfUHe+8x492j17t5z91Px0omEiMRm/OFLfi5YvBIFJoC+L+Xp3
         gtbTA+jDFRXZybDWaiclqqF0+wE9TdvCdJRKaPEnDXU2ZGAVOMcGiuC+EojzeI5vvPiB
         uU0SDtqoFAsWhnrM0UJjOFY94tsjAcZVoL0T6ZVqs3HF5NjGVp1FRUVCamIsmjDoYJFF
         EIvhFufceeAcshYTSq400CLZiC/AtXXkxjnbmhrQun8LMpIhuLQcJr+DGDouqEfjLCl0
         fapWttkvdszK+L60lrtnhhYoD7LjCrAE5wBK16MWPjHr+in+EDDFYKW/qWjqaLptK9dT
         BOog==
X-Gm-Message-State: ABy/qLbm0uQMVACICwrtpE1mbmaL1uqFigIDgqA8+kppLAI6gos783zX
	OWToMWDEeIBTnkroGb+ZgoAW5iP5Gpb8b31zOUUdxfSDx2OIHwrI62XOQ5Sy6VLS4qo6NLLav8B
	oszqqAsBBIR8zvTOfoluRrn44ENEd25ssYncOZ1NekfRUxU/YElff9DBAKb4=
X-Google-Smtp-Source: APBJJlEVKEGtkcc+0iPxhSMQGnZhGjFH0nN+wHvPohKnDVU1kVTG6rl/XnSXZf17eAHE3MlDJ8j87+v+Pg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:4324:0:b0:573:ab97:578 with SMTP id
 q36-20020a814324000000b00573ab970578mr66165ywa.2.1690202323257; Mon, 24 Jul
 2023 05:38:43 -0700 (PDT)
Date: Mon, 24 Jul 2023 13:38:26 +0100
In-Reply-To: <20230724123829.2929609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230724123829.2929609-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230724123829.2929609-6-tabba@google.com>
Subject: [PATCH v3 4/7] KVM: arm64: Helper to write to appropriate feature
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

