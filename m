Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C964154BF
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 15:06:54 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3143a431a01so3838701f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 08:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689779213; x=1690384013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oxUhPETpdlwBKSi5jZ4V6US8ie1o/QLW+MfvBIA7CqE=;
        b=xqzWAQcI0wUNfGHLvJy79VCY2u59Mms7FpqcR60BzccvjCleBCfLE+rZQoIFLq4Qn7
         sfK9OEZ7x0esx4MbDw0WuCWUvFAy/TQSSpHcZITDwg4d7RlWnua0Y+WBC+qPr/gcHfRx
         nTp/TF/ivaM50Rd+Rj7dWZu63lcJrzwPcaNgbzv5TZw5+xv6N7vlovIguc/Tnf8lNLQF
         /enYXRpJU0PNH8vO7iE9hxgo+W/UFRq21nzENMYsNto5EpLTlWMBqs9xSg6izy1SW3KI
         IgYB6SQ0TK6hyy8eSjRS9yhaOF16JpudRMx1BS3q1wjMzkvVVEN5osnbzZCiNu8hH4t9
         Dyvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689779213; x=1690384013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oxUhPETpdlwBKSi5jZ4V6US8ie1o/QLW+MfvBIA7CqE=;
        b=OsvoM4pcFz8JC//PxywqpzKXcVGlOncSZccALn6Oeg//ecyoXvYspnttPUf59+lEwF
         AKpGUIKQiq70T3Q9hwL6/tT7nKQFseICaN+GjzZY/rm5aP9OmiDEWEN8lXZEG2rxPT16
         0IyKNd7L6YZmrkOvFSfV4I/c6lo/HB5V7CxXFAE7tzFlJhPIvubKJDjAkbH5rTeAXFwf
         KjtlZmn74tEGWqNGjsLQ+d1yAFQJOwMTN4/7c+G4nVMEMSJ7SBL0J21R+ZAueK7i2OYH
         5UBS41HPnTndKimRaFKhbqWQ3ia7RsS+zxJH+4nFflbkbYmbmrwW66gmyuqOOaxRXWhY
         7/ww==
X-Gm-Message-State: ABy/qLYB7L1VzM8WaP8U4jWjP13vJLypkKkLaDMeVakOokNh7ofkv9sh
	cJ5PT+BS40M/zNoUojo0LubI8juUdctowyQB5gjTwuU/sK/j6vnXQ/E9AChjvD8cxXBWxmLz7OM
	9yW2UeVR41irxrA3DnVpAgFzWidSDMstEgiYP6QOwCZvTVxQkmClogJowDzw=
X-Google-Smtp-Source: APBJJlHGDEUk5DTf4StFzLCB1nZXOxhMyDHBE7Ht2XW4RlQV+9w0QlLSNr8kFBLKhmzU7u3BAOJ5C5VTVw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4641:0:b0:313:f2bf:4c43 with SMTP id
 j1-20020a5d4641000000b00313f2bf4c43mr1032wrs.2.1689779212830; Wed, 19 Jul
 2023 08:06:52 -0700 (PDT)
Date: Wed, 19 Jul 2023 16:06:39 +0100
In-Reply-To: <20230719150639.1968034-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230719150639.1968034-6-tabba@google.com>
Subject: [PATCH v1 5/5] KVM: arm64: Fix resetting SME trap values on reset for (h)VHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Ensure that SME traps are disabled for (h)VHE when getting the
reset value for the architectural feature control register.

Fixes: 75c76ab5a641 ("KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 997c0ae72204..c37584f77f4f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -578,12 +578,16 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 	if (has_vhe()) {
 		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
 		       CPACR_EL1_ZEN_EL1EN);
+		if (cpus_have_final_cap(ARM64_SME))
+			val |= CPACR_EL1_SMEN_EL1EN;
 	} else if (has_hvhe()) {
 		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
 
 		if (vcpu_has_sve(vcpu) &&
 		    (vcpu->arch.fp_state != FP_STATE_GUEST_OWNED))
 			val |= CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN;
+		if (cpus_have_final_cap(ARM64_SME))
+			val |= CPACR_EL1_SMEN_EL1EN | CPACR_EL1_SMEN_EL0EN;
 	} else {
 		val = CPTR_NVHE_EL2_RES1;
 
-- 
2.41.0.255.g8b1d071c50-goog

