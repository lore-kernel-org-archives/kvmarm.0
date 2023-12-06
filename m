Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2686728DA2
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XnMvXAtx"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-db53c05f802so651850276.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857133; x=1702461933; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hrfldcOZCeMx7EH6nJTIZOW2ImS4e6CjoBRwxFPBnYY=;
        b=XnMvXAtxN8z6hJrEVNJ/kjlWLhp+YawptEoQxT+w6vFSYdtS42pwYOzkAX+FalxQpq
         9TGuMfT/9bUyK0AnupXbWTJV83EhWiRwdj17qYhh0js4LH4nm3JJG+GbjJzSpXa57hfs
         ULAxq4Zfz42bfz5HO9/Ptjecerm1hc7JoGEOvbjbFiq6F8ZyP3IZ/q9zhkjtyl6ejs5q
         vuYQP0PAmBYa3NZWXgndoD3gxuPptt16ewZI1pBmyLxXZDA1wMLnvPky7LbMXF5NWmwq
         aImcj0j4wHM41aRxuDzFGh97giQTgfcPEHqk4OK2Ni/ufP+LJpM58I541xaeIa/vcAM2
         MI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857133; x=1702461933;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hrfldcOZCeMx7EH6nJTIZOW2ImS4e6CjoBRwxFPBnYY=;
        b=GEmLntpogyQg0xeA9hDkL3mH81JjC/F+zMtBPBDipRsjsJEnIexAr0Gfj9vnWbOjRi
         nGZLcyipI86L72TsjmwjvS9YerMsmYllx+6mEpAXyo4wsopylatgpocH6uRysf51kmyQ
         yRIodLPIauC6NFCwon2CL1LWzIVHpJoPCa7YgAedMmn4PD029tpCRd6HVO91nkEmgBvK
         O1Y9eNeTl3CMzKarY5d+OAcrbw52Em4sdMVCXkMkQy3VZDi8YEFbO24obeZSSjb45f4j
         rF6y7viSNFZXrkW8J+WdlZL8RnMfv43+rWAOoLzyDPg3cHB8VJxdShTK9d3/gF3wOhlp
         czOQ==
X-Gm-Message-State: AOJu0YyPQpPMTVoBjmug6njx0SBlCzeiObSpKiRVkCSExYc0Ps9x9eqo
	22M58xDtDGBZooAjuSk+QiB7Z+I565xXER2qdW2GlCpNr+NwsPh6WNe4/uTk2dimXOjhvmBKE+L
	NplfhbRTKD9WQs76ud8DS8BxgVYvnOdwdekZ7DNCSLXYrZGZQZ2oiPYdz2TY=
X-Google-Smtp-Source: AGHT+IGzrK8EB8ayunJchvbQsIRFZYUpQibF48L1UBSApQWsOQGeXNXv4lAo2xGY5BO41qaP5geB/xZKyA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:51:b0:da3:b467:af07 with SMTP id
 m17-20020a056902005100b00da3b467af07mr83570ybh.2.1701857132544; Wed, 06 Dec
 2023 02:05:32 -0800 (PST)
Date: Wed,  6 Dec 2023 10:05:01 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-12-tabba@google.com>
Subject: [PATCH v2 11/12] KVM: arm64: Trap external trace for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

pKVM does not support external trace for protected VMs. Trap
external trace, and add the ExtTrcBuff to make it possible to
check for the feature.

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
index 85f8b385fed2..be857797cc00 100644
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

