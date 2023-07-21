Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5543E174CA
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:52:02 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-31421c900b7so1010823f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 02:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689933120; x=1690537920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=08VuI70si6NZ8B9DZQut4OP4SkSw7zkI3scPs6qrjHI=;
        b=WBcJrj/LK/CGiqsny7/lxrDsotTh3eel5nKRAcVWebexhb1PzvaVBoJEZtI6R/xT0H
         GTylQEqGzJ6WvEDL0mk7ck8ZX8q6dJejbzlDtTSvRyRN8WWd1k3Pw9X3x1L1UqKeJxiF
         3aypR6Lh8oWu2kWw3wI/rADFlEBguWuEfxjaGg/8EIRXPWK3qikfIK6/sw+hZx1i7JHC
         zouTYZiEAtgotJ/jwNGpqKOyqOqVYRERE5NYOQ62UoSZfcGESAr9qsnY4H9KOFScUXn/
         WMNVBTixyMhTymi8AP+wm/N5t2/gof41BsK96WRvkacLwksdR/+391/b3v50jidYaZYb
         IBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689933120; x=1690537920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08VuI70si6NZ8B9DZQut4OP4SkSw7zkI3scPs6qrjHI=;
        b=J0o3U0K+tvYFqsjb5Sm8Z/0dHYjpoa3EUB/3iaynaHi/wBsMKHpb4AKCi4LKKupR5q
         WK8T9UBMiNFaE5e7SA815hsqqXSGJhQbaWVXp807D/dOjRbmFqIjNVmN4wIhbc/vO158
         UjmX+3m6IT13YQA9kVE0JUNJFmHN8rXF/DbMyU/hTDrNfOZM94i9bbgeBt3vRR3Fy8GJ
         ystt35oEAvQQv4PNfzQH8ObZDxyPsoIAMxXnCx2sg7wIFl50o7uTa658OFR7afAzI5NF
         Cruvf2KBZHtS07sU1gKeYdxsAqpQ3wxThAohyEa5zEfw9zkt6tgAWymHJk13Boo2BQd2
         nbRg==
X-Gm-Message-State: ABy/qLYIxMtkq8C/S38KIJZl2gnT7rpDXLtlSaaDw0egNMXNkK9o2NVW
	ocQ5uU87OyOaK7f/+IsFKueYUk/gPOM7/0GsGqda+ijahLkCgCU4rnYuD1/nqlYppKZwEy1eV6s
	PBqywakReOs/gdYD++zOukZpkxRdFqHmJKzxnsocAaX07qXq3nsRp+jjQcM8=
X-Google-Smtp-Source: APBJJlG59Kiasrv3tB9PEVs1dwK/vR+hf/8Hc9SWTzeAg4DoAKR95HQR+JNKxdu4WgiDWYcqozGWf5PCuQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:d4c4:0:b0:314:3986:4d2f with SMTP id
 w4-20020adfd4c4000000b0031439864d2fmr8356wrk.14.1689933120509; Fri, 21 Jul
 2023 02:52:00 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:51:43 +0100
In-Reply-To: <20230721095144.306817-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230721095144.306817-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721095144.306817-7-tabba@google.com>
Subject: [PATCH v2 6/7] KVM: arm64: Fix resetting SVE trap values on reset for hVHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Ensure that SVE traps are disabled for hVHE, if the FPSIMD state
isn't owned by the guest, when getting the reset value for the
architectural feature control register.

Fixes: 75c76ab5a641 ("KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f5941f6dce49..c04ff63fedab 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -588,6 +588,10 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 		       CPACR_EL1_ZEN_EL1EN);
 	} else if (has_hvhe()) {
 		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
+
+		if (vcpu_has_sve(vcpu) &&
+		    (vcpu->arch.fp_state != FP_STATE_GUEST_OWNED))
+			val |= CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN;
 	} else {
 		val = CPTR_NVHE_EL2_RES1;
 
-- 
2.41.0.487.g6d72f3e995-goog

