Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5985C174CA
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:52:04 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c4cda9d3823so1516383276.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 02:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689933123; x=1690537923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QZNo6JDhsJeJ3yKQ996bt9zAUEjHgWjkczKsNxQK98o=;
        b=ne35r4HArn/CiJNoEQWC8/oAkYOFeNHauBVqOnp1nxt50YDujH3Aw0jhlNpm5qIEJ4
         A3JqTtLkqNkqda/VDqVDwb30vuWBShxCRmrZKqUehatqYwcACDWNLC5rCrZe5D7xQh1w
         I1FLUr2GzXbtYtYRKtdo8YP7pLwMCx1WqtlKGCG5dGyACefqFn6YU1nYv6BNEZxJMIgL
         jhDoEDoyOkkv39iOPW7dNNXllRXrPuk50wzZilFewDR70/Y6ocNzSo20cr46XHH388RO
         JpIP5MT7XP52kwJopC5TvlNup5BcXx8Wiq5ZJgmOIQZkIY+pL/e/0bQJSMkdPFBCzczy
         PCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689933123; x=1690537923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZNo6JDhsJeJ3yKQ996bt9zAUEjHgWjkczKsNxQK98o=;
        b=JpC0wY74QafqHf4vOdXy4q0FDTIbmLNujcjKgCHbhelWYZZdvsuw8JgVQs3IXGz8rw
         wNgybcAtZQpL1ZBIcHwWpfzhQWXhDG7xyLrUrAFxfrG85cuTi7mgRVytISTwOBzCRtEe
         Lhfski5RQt0LT1a0usapE5ltYq5ElW8W4wSDSuy/Iy+Lradd80J1pZ+SO/7UPo/nJ178
         2IBDbpkBbfs315hWb+7/sI5pEuI35phLgOXEtoFpAesWTwh/vXBOC6xTU1CRWVMveAPF
         vjalABBYWjfES98pl3556eTF0CQBa6M7N2/tJVZhk5I5wH9l5Qbe51i3XqwwDUecTcbe
         pA1Q==
X-Gm-Message-State: ABy/qLaHF8oPEqOXLqhZdW2C4bgQBRlPrOqtIbR8T9cM9qo7NTZmc86l
	Lco5LtQEjjsbI7TlsrF/ANHeJ2xK9QSaZ0wWmf2t/BKKjEN0LWll3mPyOXdwR36hXZSODuNrgcX
	hndtjrSrlxJnULuoFtheo11I+vvKTT1T1hqgua5CmDD46DNlEzl+OMWHQibE=
X-Google-Smtp-Source: APBJJlFPNUfWlbSRAh8MYdFcz93uLGV1r3Y0915X9i8namFSGlwNyrKOJIcTfhADYC1Iu3/Oj0Y+3xi0uQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:6608:0:b0:cff:ec0f:430f with SMTP id
 a8-20020a256608000000b00cffec0f430fmr8547ybc.8.1689933122986; Fri, 21 Jul
 2023 02:52:02 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:51:44 +0100
In-Reply-To: <20230721095144.306817-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230721095144.306817-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721095144.306817-8-tabba@google.com>
Subject: [PATCH v2 7/7] KVM: arm64: Fix resetting SME trap values on reset for (h)VHE
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
index c04ff63fedab..8feba4446f49 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -586,12 +586,16 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
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
2.41.0.487.g6d72f3e995-goog

