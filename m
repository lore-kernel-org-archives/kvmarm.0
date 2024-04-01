Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430B857300
	for <kvmarm@lists.linux.dev>; Mon,  1 Apr 2024 23:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014201; cv=none; b=WOpuELIgx7mn1X+HZL58BX69wGd6FfwajbmQ43bAiJBYQK/cx5BlYHm3zvEfNh6KQ3C4sBbrBPuWBGkvj9Kyuc50cpKKB7u9s1VwqEsfLvTi/Ot61/5RcDpQM92w1yJ/GOYC09U1wUyg9neQyXLFf2YmHEbeWVuuF7kXuHh20Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014201; c=relaxed/simple;
	bh=0ndCTUSKNYjrC7chZIPInNHsk3SUFRlCdRJOI83//j4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ArxH0oDZZkmD82gqQq2isI/H/yiqDIzYba7e+GXPXdCZSQ/71Nhy8O1zPxy1iL9ADvaTeebAQ73ubqoNA2Etxs96pmu8EKirgsqlFRjQX59hm8WDNYJDPlogMlcNohO9DOPGc8DTSxlzIegesNzcANyqrShyRO040dgoHsOkOgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M72vx27m; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M72vx27m"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61504a34400so11750737b3.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Apr 2024 16:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014198; x=1712618998; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lJfaFUFI3gJojofhvI2fMvWTfkDCiiHnhDdEzunFXno=;
        b=M72vx27mSVQwuRosBEREQsOOpq2lGysXM67EF1NT/YXvt1a7JiqGyBtItxBEimQndG
         8Kwpc8ScN/A70WAccgZa9HqGTqEvu3AzoLwZj5vMEneyUV+aRcJlv2ozOaFFcid4CPTZ
         Mkf+KEaGZjvSVQwHF9XpSPOF+EeicDZ2Y3LpEBnJjZeKYq3lWWaq4Rl/1YONi05CARGZ
         CkanP2/tLtDbb0XEeGPz26+sHKqANrFwLBU8byoXbjHTRKxH49Vc9OR1DZSeHmRESnHU
         gu+if3F7eNnTy83GMSj2mA+E8zNI4Ir9XYHP/7Hai+fHTO8so93Aur5fxRpC7iCys0ca
         EtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014198; x=1712618998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lJfaFUFI3gJojofhvI2fMvWTfkDCiiHnhDdEzunFXno=;
        b=T0kWef/j9mp2Xk5GbcEyEIw0RkD26HX7gwraaPyyU63nJx8EGOWbSAhv7ZGzparhCf
         10lko/eS4N95QiImk+k5i2ebS/H0fKxwXSA/PzTs/+w7upYMPRNgCGXyZNRmH5KaGeMS
         vh178ToQd7TE/qE7MvGoc1uEVN19t0Dapl3TfLCVaPtzAuMsdwHwGEIIFPSI+ak/uMx8
         ZQSW1oyt/BVuW+qC56I1++kCPoUJIbGw6DwNsWYi4FXd7hFHJloUaiQP/X6in5y2edmj
         gYZ/8GHMDHa0BUEeti6bqElnScRTvyM1I9WxPHG9X5GI9S/qYziDx0ciYlda6KcDv3rv
         IuGw==
X-Forwarded-Encrypted: i=1; AJvYcCW2kN77GOsVYGydmqCiGVTE43apPanI+EgIgfur853gQ4Op5Rf/ob3Agkon68yvBfbUXdZddrZZthL6iEmwdiTSsUjfqGil
X-Gm-Message-State: AOJu0Yy+4I71DccT7xkS1tSUIhIngh6wDPz2BxipmPDgVq6nWFrFww5b
	2FTZnQTB+vgf2TEeqBb/4bJ5z+bAMaOtBB+GTIPalPHlq8qf1yMZLcTpPcpkVyke8UdMK9kB8FL
	OAyUbL9Sl05cvwLATiw==
X-Google-Smtp-Source: AGHT+IEzS+9pOebrRYAPHZcYp9+yLQ7vZUDEjcM1NuDRlvVAs7z0PGB+6rnD36HZsSFqff67vdpG7JIIt1VZPePZ
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:1006:b0:dcc:94b7:a7a3 with
 SMTP id w6-20020a056902100600b00dcc94b7a7a3mr767796ybt.12.1712014198123; Mon,
 01 Apr 2024 16:29:58 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:41 +0000
In-Reply-To: <20240401232946.1837665-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-3-jthoughton@google.com>
Subject: [PATCH v3 2/7] KVM: Move MMU notifier function declarations
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

To allow new MMU-notifier-related functions to use gfn_to_hva_memslot(),
move some declarations around.

Also move mmu_notifier_to_kvm() for wider use later.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 41 +++++++++++++++++++++-------------------
 virt/kvm/kvm_main.c      |  5 -----
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..1800d03a06a9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -257,25 +257,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
-union kvm_mmu_notifier_arg {
-	pte_t pte;
-	unsigned long attributes;
-};
-
-struct kvm_gfn_range {
-	struct kvm_memory_slot *slot;
-	gfn_t start;
-	gfn_t end;
-	union kvm_mmu_notifier_arg arg;
-	bool may_block;
-};
-bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-#endif
-
 enum {
 	OUTSIDE_GUEST_MODE,
 	IN_GUEST_MODE,
@@ -2012,6 +1993,11 @@ extern const struct kvm_stats_header kvm_vcpu_stats_header;
 extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
+static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
+{
+	return container_of(mn, struct kvm, mmu_notifier);
+}
+
 static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
 {
 	if (unlikely(kvm->mmu_invalidate_in_progress))
@@ -2089,6 +2075,23 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
 
 	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
 }
+
+union kvm_mmu_notifier_arg {
+	pte_t pte;
+	unsigned long attributes;
+};
+
+struct kvm_gfn_range {
+	struct kvm_memory_slot *slot;
+	gfn_t start;
+	gfn_t end;
+	union kvm_mmu_notifier_arg arg;
+	bool may_block;
+};
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 #endif
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ca4b1ef9dfc2..d0545d88c802 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -534,11 +534,6 @@ void kvm_destroy_vcpus(struct kvm *kvm)
 EXPORT_SYMBOL_GPL(kvm_destroy_vcpus);
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
-static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
-{
-	return container_of(mn, struct kvm, mmu_notifier);
-}
-
 typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm);
-- 
2.44.0.478.gd926399ef9-goog

