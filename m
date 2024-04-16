Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCF82907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261460; cv=none; b=C82KLEIQsLs4+Nsm8T/1kP5Y0aIzPT3zpEy3buG3BF6+z6RTmQuSwTPcuV99paXOEWFNH9ZtcgyfOL4vq9vWGL06ULeWEILrA6+5yjLtOrEHHc/bjyHI79e6F5zrUesda6hnPkhgqEwArINMoPvOZSBr1px7GgRlP0k5ksjp6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261460; c=relaxed/simple;
	bh=k9liPHZtXGSnWUEvh62ggXdBPt2tfKCpBPihetHgVeQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DdU4oBdKF07PgM+3XqwORmFaNyox+wMPjH5uXWreN6kDnq6xIF0YnWjBY2bV9r1nQjU8HjeJDmmtLIgDvczvKNOMtjAefo5Ei7qzndxqfxI18qhElskmApgS1a7WrHZKnT56eppYovj52bdzsTQuL+FiK8DyKmPQWZ2OtfRsSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LiuvzkEC; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LiuvzkEC"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61afb46bad8so845157b3.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261458; x=1713866258; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JRN+kZYTEgmtVKMVK/AhpU9BtGxpK0R9pbv7JyRURow=;
        b=LiuvzkECXSa7V2+s4QJfb+EgZmu4idWKvNq82faV4yeK02GO+mQxExhBcWWncTqFLk
         abFRl8G45eTDbqKtXCtFA8f4sUZYIBMzYIxa3fxoof8CNKSU33cMQ/J/lLpQ5Kk9ctuz
         gAFk6FwjqYyiaDMCsJSlzGSxlbgUcZW3T+RfUtKJ5T0um5B6xtSg4LpPtcqrAP3HPc/E
         8VZvtrIWwvuAQZZUDhHVDj0VO9ZpCyDWZalTunE6WH18B5W/CfEzlfbXw8LX2fjFw9pw
         D8k7HDZ6/fgtJF5+/LDPff1hkLpyfExY2S79fc10lYVYhUR8sMUk3K6hcuIkVgFTAw3/
         ee+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261458; x=1713866258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JRN+kZYTEgmtVKMVK/AhpU9BtGxpK0R9pbv7JyRURow=;
        b=CJye4RUgrekqLOyY7DhIdya9xxX8EDM2pItF0LktEjqExt+z01AsB7M6KO4gDJ5Ram
         0St54ZyaT9AP+52moG5q7j8SGGJfE1hu33+95/B11sD1lqC3qL+Wfi5bEOOcFwbKcZ81
         brLMqGJGSXGSOou64DCYEaeO7xT2VDQKrtpE/94rnwDXJn+ZQ9NkJb4+QdP4pNoJb7hD
         BXG+cQdcfgzJz2SVXap0wXZM5Xs/t82bXd27K/Ldp9/ssR68I+jtx9z7XT+b0LXfXdoB
         v6/sWu4ThK8hzRPPt/rvB6JMDdn5d78+B5DzzUH+ysNhfKW+CT7RrSbSVHaYbt1AgqHg
         LGRw==
X-Gm-Message-State: AOJu0YwsFFkohLw2Lka25L5CZCGz+HpZBONOF4xZtr++65fERKb/w+qa
	ByvclILbA00bubzvdNgm0qeYIWVJ3m0aZ+zgdg+XpkDtPHtRvL7myYSXtRyCy9MAh/S0W7v9bcs
	oQEFnKsc/4oGjRlsAJx89s40M5f9scG3KaOL56raipzZ96gN2gUz2+iUCfEkD9orfVej2F1Wfx1
	509we4HcphzicxbMIlSE/T0kOftWo=
X-Google-Smtp-Source: AGHT+IHqdr9kHegfzD5/uShRDM3yxWo2f0mZpZ5oAp+OeRPW+LKxgdPEDHhPop+7ftRgrm7Uc9tqkcK4DA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:d503:0:b0:61a:af2d:3615 with SMTP id
 x3-20020a0dd503000000b0061aaf2d3615mr578963ywd.2.1713261458115; Tue, 16 Apr
 2024 02:57:38 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:16 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-26-tabba@google.com>
Subject: [PATCH v2 25/47] KVM: arm64: Introduce gfn_to_memslot_prot()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Returns the memslot and whether it's writable without requiring a
userspace address at the host.

The userspace address isn't needed to get this information.
Future patches, where the userspace address might not be known,
would need access to the memslot and whether it's writeable.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..94f0e8e00d0c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1292,6 +1292,7 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
+struct kvm_memory_slot *gfn_to_memslot_prot(struct kvm *kvm, gfn_t gfn, bool *writable);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb49c2a60200..8757c8f7808b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2709,6 +2709,28 @@ static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
 	return slot->flags & KVM_MEM_READONLY;
 }
 
+/*
+ * Return the memslot of a @gfn and the R/W attribute if slot is valid, or NULL
+ * if slot is not valid.
+ *
+ * @slot: the kvm_memory_slot which contains @gfn
+ * @gfn: the gfn to be translated
+ * @writable: used to return the read/write attribute of the @slot if the hva
+ * is valid and @writable is not NULL
+ */
+struct kvm_memory_slot *gfn_to_memslot_prot(struct kvm *kvm, gfn_t gfn, bool *writable)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+		return NULL;
+
+	if (writable)
+		*writable = !memslot_is_readonly(slot);
+
+	return slot;
+}
+
 static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
 				       gfn_t *nr_pages, bool write)
 {
-- 
2.44.0.683.g7961c838ac-goog

