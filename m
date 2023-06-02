Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8114C33303
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 17:02:53 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-33b4cbdd21aso20243345ab.2
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 10:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685725372; x=1688317372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jc0HXGzYvsWKFFqMwew1siGd4KbapSh3HWhZ39XsN18=;
        b=j+tKfi2kSo+PoSM8bzNfiRyUHJOyeGZ8cXfsmhGYboQIkXNZcgKm7MC/cWX/C6ZkqG
         60f7UABnT6ErAicHdSv8GNsaMsxzvOwv4YmniUVjWIoOAFBY8RnuSFSvJlf10WPLD0Pl
         04johD9tWvxiLCZi1WR0w+oOd0+AB/CP+2jYhm7evUJn7pTqemwzVAxdP+R68pydUGOA
         HIqJ0F9ltOSTrTcu2f3O/9bIynM8h5wdOVo4MLk5r9Ic6t6CxEi8rZbTDEZoGZX1Jbzt
         PmrdFFznsQ54/dOus3KfJ9Qig75zKJPzP+rVna7qVoudLzvULSQv2dyT4F4wCWi6idZ2
         o0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685725372; x=1688317372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jc0HXGzYvsWKFFqMwew1siGd4KbapSh3HWhZ39XsN18=;
        b=h4XzAZGF/pEwVAhxNZnAgDLUz+JszGczri2ImoyEtGDo8IjzOTpqCdFR9ln3BgTJo5
         KF21z/PbMKyqLyyQPJHOoFJRvSV9XGhzYmsNSG+SHGZeRaF7TvX/IdYH5D6WD2OhhuL5
         GPzpEs/xRCVc50V32hn2NN7jJ0QFaAHOVKpDjUE+iTzE1sO22p69YdWuJO+0vBZEgTgP
         /u8tDPhEteROTNrwRk4XK9qTCu6xgo6vLQDEOZPTgk+wgv9vFHPVXiHtxb8ipIuspmCL
         UygWSjx8A5mp8qrVka0tl/TBHBwjyQry4DtPrQTAg6zwIRvvRtqYaJqwevrjDKxBh8gd
         PMAw==
X-Gm-Message-State: AC+VfDwX5F53WaYEDcrQz24jZoU8B4qk4yGD9WWErQP/2V9PgWB20TMS
	mfa2awR0Xb/GCS+mLkH1WNwQtaPd73IvaDgGqw==
X-Google-Smtp-Source: ACHHUZ7+edDLEpgV1IGnbtuAGa0C22RGdZstxlqcJBRqQ5INrzQuoJ8ypYZbCeOZkcJOp1lxWUSrEVByOHlYXL/q9g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:db52:0:b0:335:908b:8f9 with SMTP
 id w18-20020a92db52000000b00335908b08f9mr4386617ilq.1.1685725372593; Fri, 02
 Jun 2023 10:02:52 -0700 (PDT)
Date: Fri,  2 Jun 2023 17:01:46 +0000
In-Reply-To: <20230602170147.1541355-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602170147.1541355-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602170147.1541355-3-coltonlewis@google.com>
Subject: [PATCH 2/3] KVM: arm64: Clear possible conflict aborts
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Clear possible conflict aborts by TLB invalidation targeted to the
address that caused the abort.

Making use of FEAT_BBM Level 2 creates the possibility of a conflict
abort when translating addresses, where multiple entries exist in the
TLB for a single input address.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/esr.h | 1 +
 arch/arm64/kvm/mmu.c         | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 8487aec9b6587..41336cfa19ff3 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -123,6 +123,7 @@
 #define ESR_ELx_FSC_SECC_TTW1	(0x1d)
 #define ESR_ELx_FSC_SECC_TTW2	(0x1e)
 #define ESR_ELx_FSC_SECC_TTW3	(0x1f)
+#define ESR_ELx_FSC_CONFLICT	(0x30)

 /* ISS field definitions for Data Aborts */
 #define ESR_ELx_ISV_SHIFT	(24)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7a68398517c95..96b950f20c8d0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1591,6 +1591,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		return 1;
 	}

+	if (fault_status == ESR_ELx_FSC_CONFLICT) {
+		/* We could be at any level. 0 covers all levels. */
+		__kvm_tlb_flush_vmid_ipa(vcpu->arch.hw_mmu, fault_ipa, 0);
+		return 1;
+	}
+
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 			      kvm_vcpu_get_hfar(vcpu), fault_ipa);

--
2.41.0.rc0.172.g3f132b7071-goog
