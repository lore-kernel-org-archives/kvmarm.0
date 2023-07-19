Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BD2154BF
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 15:06:52 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3143b999f6eso4020640f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 08:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689779211; x=1690384011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=slcrF7+GQDDw6VlIeoZ0VpWDTs9WdDjAMWGTWSakO08=;
        b=cm80/7drvbcbjI2ZS3jRKyG4/lLNNYsGi9bX9XSwT+FXeTxSlKVemE1PP5eJcBzinn
         Y0ilB0WTTfY2l51b+PoZFZrIgaFsEl2iZYM46AxMDXv3f4oIPGx4WK7qNhB4yJqJ6gPr
         fQWRqB08Nh0EEEDbpRQUS65dJgt3PWK4AaLBsn9V9DlzRTqAHx/OdyZR3PSifihQE8JA
         iwl4nwskdNq19HFoILad9/AXdXl9nqK7GlWWriAGUNzwr4SuQdbldZFPnx/0EkKwMgJe
         FR2K8dXunZ9YCFMEq28NkKmEW+DbhsFOJOVb0bDsSS1SPBIlUybCM1q1cwGs/GcDHMIN
         ugjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689779211; x=1690384011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=slcrF7+GQDDw6VlIeoZ0VpWDTs9WdDjAMWGTWSakO08=;
        b=O+IqAnYwSzEwR8B9WKLpSGEPnT4fKUHpGtbMHcFuxMNc0gpX8quYluB+jIffzNpT/K
         zP7jP4BzctJZpbx0UOozJG/EnC7Gb2uqQWyaRufHZCPmyH0KhgGFN8MiXDatfBozIvW5
         nIYcY0LI7Lgr3x6UxTckRMtqm/jvv8xG+nf8FHmfIT/QM1VBpirucVY/G3BgPYykT7SK
         wrGluFsymSRuePjc6Lpfrs1UBLq/em3LkviBSYQDUuC3wCrOmVwSvzeZncCC8oHZ88jz
         HUHIk/NnqeB98mham4WETp7k1ZWXEBgMuN+UM6UFAhKo2i9sJzczsqAClujuqRyIQLHQ
         wkCA==
X-Gm-Message-State: ABy/qLYRS+e/WWaBbSDTlOZAkp7LE8mpag2YTf6OxVWR/g3NO6QdHStJ
	aUhHG6vB+quGmGXEUH2bsqpZyiOKNiIaggSFMmfBl/wvNbupfHYTOyKMbsfL6TqFimHm+VMUrWk
	sp/+n9nJHgXYFV0qyzyebkU/w2lEIkMHcWVecMh0y+7kT8bGSmhma4Yh84KA=
X-Google-Smtp-Source: APBJJlHGUNQJkak6uS9Q16kUUc2Gbc+p1rgfSJ2fXPAMyDAbw9HrS9HZIf1/+RgNg60mLbCUwb9/d+WgwQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4fc9:0:b0:314:eac:6d91 with SMTP id
 h9-20020a5d4fc9000000b003140eac6d91mr631wrw.12.1689779210657; Wed, 19 Jul
 2023 08:06:50 -0700 (PDT)
Date: Wed, 19 Jul 2023 16:06:38 +0100
In-Reply-To: <20230719150639.1968034-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230719150639.1968034-5-tabba@google.com>
Subject: [PATCH v1 4/5] KVM: arm64: Fix resetting SVE trap values on reset for hVHE
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
index efc0b45d79c3..997c0ae72204 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -580,6 +580,10 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
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
2.41.0.255.g8b1d071c50-goog

