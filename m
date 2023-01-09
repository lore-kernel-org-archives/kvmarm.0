Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1575233
	for <kvmarm@lists.linux.dev>; Mon,  9 Jan 2023 21:54:07 +0000 (UTC)
Received: by mail-oi1-f201.google.com with SMTP id 4-20020aca0b04000000b0035e9d1b2188so3129305oil.17
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 13:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDYN0MRDIF+SnOeyd4pyYdGIKCrHRaNe9q+tU9g7tHk=;
        b=JpgU+lBoUCLbZ56Jvj7Pn/vdi78vU5U3QuKtvIBxucZgLmZuMLmd88ZuQTUzyBKvak
         6URYiypCIW+TZt6tpj3vahCJkJfZ/bLR5/iBFmcgS2xJWZjSs5Km1XmDOCZFVyYNrNdF
         aQxMRNm9CoVdpDALfBC57x8+EFA1cfuvZqgDxyITXdGCIOEqTxQiAuVy9uJ1cxGO/3EV
         abfT9ocI5Otykw8Nadc9eXPbqcQZXXaZrNB0el9+yvluuWfZF1VWhrmpIVzBQ0tBz6CD
         +6oL0xnc06/xPuEhNIL+kfwdmFZFTaFbgKl3SlvFFlUqQ7wMRKAH+9CjY0D5URbPHfBd
         jhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDYN0MRDIF+SnOeyd4pyYdGIKCrHRaNe9q+tU9g7tHk=;
        b=P4K2er2pTwD96QWOjZAr21lv/ZiXyINd319Z3nKRSkdu5MhZpdFGwpc5IQRsTaBZqT
         OIeigy6W933OiwDiPIS3UHuDAV0VvhX3W/WXYh3iCXNpq7LIbh9Oxu61+cA267tHbjA1
         YnwbTTBIPIQ+Q7jqOI6B7hN7B5Ge8Zlnp/B61f4js4qcroOoQdhoXNiXGoYZGfjDqrb7
         /I4TO2kTRUT6eMuS/yV5Q6k5NXCHL+cmOdjoyx1Qf/Xe83danUgmnIllRus4AFowiM3a
         eGDBfmDXoocu8D7crgi//JTm7DQExNIeJ7KXcfziOOLyCQEk9yuUA5//ER/EzSVCZ/yD
         1MiQ==
X-Gm-Message-State: AFqh2kpHJFycSTobp2N+W+53rmpSJ7C5CQ4yowDN9Qfg0vorBk1BYQhp
	TwoaeWCzeGi8bQDkpdv6bKsCqPkvHv/0
X-Google-Smtp-Source: AMrXdXtrkhTOwelbRPQw7yNs/JV3tuDLBxCLoimzlrlEKqCeF4IooRkE3J40GXTjhloRi+UlLLpIxIlpLZyo
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6808:1a1d:b0:364:532d:215a with SMTP
 id bk29-20020a0568081a1d00b00364532d215amr195559oib.187.1673301246427; Mon,
 09 Jan 2023 13:54:06 -0800 (PST)
Date: Mon,  9 Jan 2023 21:53:44 +0000
In-Reply-To: <20230109215347.3119271-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109215347.3119271-4-rananta@google.com>
Subject: [RFC PATCH 3/6] KVM: Define kvm_flush_remote_tlbs_range
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Define kvm_flush_remote_tlbs_range() to limit the TLB flush only
to a certain range of addresses. Replace this with the existing
call to kvm_flush_remote_tlbs() in the MMU notifier path.
Architectures such as arm64 can define this to flush only the
necessary addresses, instead of the entire range.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/mmu.c     | 10 ++++++++++
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  7 ++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 39d9a334efb57..70f76bc909c5d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -91,6 +91,16 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 }
 
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+
+	if (system_supports_tlb_range())
+		kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, start, end, 0);
+	else
+		kvm_flush_remote_tlbs(kvm);
+}
+
 static bool kvm_is_device_pfn(unsigned long pfn)
 {
 	return !pfn_is_map_memory(pfn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f51eb9419bfc3..a76cede9dc3bb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 03e6a38094c17..f538ecc984f5b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -376,6 +376,11 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		++kvm->stat.generic.remote_tlb_flush;
 }
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
+
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	kvm_flush_remote_tlbs(kvm);
+}
 #endif
 
 static void kvm_flush_shadow_all(struct kvm *kvm)
@@ -637,7 +642,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	}
 
 	if (range->flush_on_ret && ret)
-		kvm_flush_remote_tlbs(kvm);
+		kvm_flush_remote_tlbs_range(kvm, range->start, range->end - 1);
 
 	if (locked) {
 		KVM_MMU_UNLOCK(kvm);
-- 
2.39.0.314.g84b9a713c41-goog

