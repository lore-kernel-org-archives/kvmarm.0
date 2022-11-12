Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E96A45
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:28 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id f22-20020a635556000000b0046fd05d55cdso3505590pgm.1
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L6sxJiifG/HbcI/kD9HXwh1w5rUr/VbuNcHdSSEcRpA=;
        b=FacScKAelNZrGtgwl8w+3ds6vKtyYp808JuUQWEzIIVYOOJlOjcRWuUTvbIoA3BtvV
         K3J0uCUKlxt5wvgfQMZm7xPR5YfJItnFP1kjZcOT+7su8jLIaXVWm+n4P2LFU8KIzFHW
         m4f/I1VNmAFezxGI67Z+iuWEGpH2YJQlhAlB7DTz7PqrUnrF23WwFZWVgBUTNFZIoAr4
         +g5eCvtaOf6vZoUeLPvZHrqlf9C3sd2ywaN0FRXaPkfbvTu1wdg314O5h+cGnkcOK3hB
         alv5KrakCKq94WoxhQ6EWq84sNAGs+cFc11nr109zSRgOi4O5L2vDw39F05glpPR+m23
         /9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L6sxJiifG/HbcI/kD9HXwh1w5rUr/VbuNcHdSSEcRpA=;
        b=sMGqR8fltNW1n8c0nlxgcwxhBP9u7TlFgvNtDHw4Y4ogHQd7kQr1QsLYgq3FK6uxkP
         dLyCzHyGsbbX8w6r84lXVaF7JtlVdcVQopaUJmmwUri/+TSJtFt11vft40z9hg/rnj+E
         Lsn6IP5U/bVmzfQUaMZ88xu7yI57AgpanRo4yyqcVhTMIvZ+agWdeULi0T8BJvdKiXNV
         NuVzxvyfJIpAXkTZ8VN4ahWK1Y7FaOMkR0lCX2aaFAl0O3HIXMVp8uvJV16YfNareC4I
         hzjbHicMiqicfO3X4dgqkCqx6HWijNJ15hzArD/73+8p40jYtC50BfY9rwtmmQTJJvzm
         vA6g==
X-Gm-Message-State: ANoB5pmqY6+Jo5X/2vPVAVar4mJJcEQVKa8Nm2xeGpVTNg3tUUToUIqV
	1qbrEPqN8WTubyiG7fOYCsUMXIqqs9Szeg==
X-Google-Smtp-Source: AA0mqf7aQpUifUSeHmW7DiqEX55OKzbVwNTuSNUOb6rC8J81HSb9LyTNzd73+bZceLSa4TYbJsj7t2D3QIZ4qw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7e01:b0:186:b38a:9c4a with SMTP
 id b1-20020a1709027e0100b00186b38a9c4amr5537618plm.163.1668241047863; Sat, 12
 Nov 2022 00:17:27 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:08 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-7-ricarkol@google.com>
Subject: [RFC PATCH 06/12] KVM: arm64: Split block PTEs without using break-before-make
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081708.M2LMGY4OixrCzViTZhE-DXiE-g_5K0qHVTYGMue3GfA@z>

Breaking a huge-page block PTE into an equivalent table of smaller PTEs
does not require using break-before-make (BBM) when FEAT_BBM level 2 is
implemented. Add the respective check for eager page splitting and avoid
using BBM.

Also take care of possible Conflict aborts.  According to the rules
specified in the Arm ARM (DDI 0487H.a) section "Support levels for changing
block size" D5.10.1, this can result in a Conflict abort. So, handle it by
clearing all VM TLB entries.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/esr.h     |  1 +
 arch/arm64/include/asm/kvm_arm.h |  1 +
 arch/arm64/kvm/hyp/pgtable.c     | 10 +++++++++-
 arch/arm64/kvm/mmu.c             |  6 ++++++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 15b34fbfca66..6f5b976396e7 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -114,6 +114,7 @@
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
+#define ESR_ELx_FSC_CONFLICT	(0x30)
 
 /* ISS field definitions for Data Aborts */
 #define ESR_ELx_ISV_SHIFT	(24)
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 0df3fc3a0173..58e7cbe3c250 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -333,6 +333,7 @@
 #define FSC_SECC_TTW1	(0x1d)
 #define FSC_SECC_TTW2	(0x1e)
 #define FSC_SECC_TTW3	(0x1f)
+#define FSC_CONFLICT	ESR_ELx_FSC_CONFLICT
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c42eff6d42e..36b81df5687e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1267,6 +1267,11 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
 	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
 }
 
+static bool stage2_has_bbm_level2(void)
+{
+	return cpus_have_const_cap(ARM64_HAS_STAGE2_BBM2);
+}
+
 struct stage2_split_data {
 	struct kvm_s2_mmu		*mmu;
 	void				*memcache;
@@ -1308,7 +1313,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 */
 	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
 
-	stage2_put_pte(ctx, data->mmu, mm_ops);
+	if (stage2_has_bbm_level2())
+		mm_ops->put_page(ctx->ptep);
+	else
+		stage2_put_pte(ctx, data->mmu, mm_ops);
 
 	/*
 	 * Note, the contents of the page table are guaranteed to be made
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8f26c65693a9..318f7b0aa20b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1481,6 +1481,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	/* Conflict abort? */
+	if (fault_status == FSC_CONFLICT) {
+		kvm_flush_remote_tlbs(vcpu->kvm);
+		return 1;
+	}
+
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
-- 
2.38.1.431.g37b22c650d-goog

