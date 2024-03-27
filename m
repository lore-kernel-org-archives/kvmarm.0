Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0257014EC40
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560989; cv=none; b=MVp7qczJUqPF9oXtZ9uBwawkMylY4S7RWCE0EP8ggQRS9qqWLbgaZeBDSVVm/dO7l3kFydZwciZKwA6XAbmnAC1UKeQJ8IRIPdMebrzX0gC4vdTTPhyzDunO5SU9H0rsMpoEWhvFhcRivo20yxk8+04YdYAzFfZ2EAZ3qxG8nws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560989; c=relaxed/simple;
	bh=Mp08rRFxbl7YCd7B4FHXv7atmiw5f4JEVIuCa92utQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W7JSE/QOzNjewB6jt9I2d8SdG2iZff6et2EKIBgYjuUNLFjhhSp9fW3e1Q9hd3wrFRPba7J8QgKQ1jlJHVdobKx6a/e6/qmNu4drccOV86Hy7w+Wao1JDUGjUFInlQdsDOyw2yZ07+Y4C7orx3IlH4Bw8CPgZlESZvjGopn5Qy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LU41sfEK; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LU41sfEK"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cd041665bso1901227b3.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560987; x=1712165787; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mLImnFonwMkXaGq9YZhAJ29c7Vai4lnQOH9Ys3CxoUI=;
        b=LU41sfEKwwe/4fdMOtNwD2BVd9sBhWHTwPld3r31eP2JlDeifEkwhlcSWvJWtZA+D8
         iqzc1YIonwkKVetKcMdPSWM0djQP04mG8/QEckDpfwOLURTl6Rij3/O3nFk83yzauIJH
         pt0gHlF9gWVso5UjqQzdsK+cUeI6pvMyojOiyGjV2v2oMMI7rTZ/Dp2G1jzN6cdaZrk9
         Qb2B6qzjVEG4pWagfQPxlyjrvsn4FxvF3t7bunIctnVSFJq6Ovu7L7xxGYqOy+dgBwro
         YQUrpAsvGtqF15hCaQAxkDBRPrXNNVGLZVwCygZ03TlLZg0GiC2NvGOAEJyAG/nTFbgO
         mp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560987; x=1712165787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mLImnFonwMkXaGq9YZhAJ29c7Vai4lnQOH9Ys3CxoUI=;
        b=Cgh54cw1hhX+MJRzEqzWMVelScaIPUS6dHf9x2YVSVnejXGPOrnzWm7YUEqfyY9p3n
         VdFJ0eECtgUVg0m2zPmqgOR55DQLCU82nzQvZ1vTnvoxeWXa9USO42HUru4D9R3Y/6Pa
         u5VERpWFjFs+VhkQiMbrerloB4RdUMaCTuPZjIN5fGvWp8pdookPMvCoYbiOQKn8R43B
         p7G2QQnM/jJSdDGPt26KVTvymwmU9Czyn9QuyUsaXTLyhmZ2s/J7x0t5TIF9CnXqXf08
         hcZ5iyhwmfrG1Or/tbBs8i+mXhnt3XV5xEJFi2im1byX5UkzVVJKdlFk3X0BDcsJcIXO
         yxIQ==
X-Gm-Message-State: AOJu0Ywh1bVjR/uNvNT6t3r20sc3iCrrDjIzQu89CUegVybY5Did1pjs
	4gjF0D3EglYFKe2A7qIQnTaVuE7qCP8c5zfSNlDCosZxiQxV9Mx27+ZVAyqC7s8d+o+BW4bD4Dp
	TzwuVqiIWwhMXufEiQJNG2n4uCZ5/QqroY/6NGUyf53BzSkvuokkbg+otMgTrMNgxhCIt3h3lKm
	lqZxAi3Syuv4/+yGdR5OoEIho3SFw=
X-Google-Smtp-Source: AGHT+IG/h1jXGZ5fvx9VTc+A3k0Hjoel10zEI8YlPodNyN+XTwNYwkHACJnWY2XDwJ7NIxXkG+mCYiVrnA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1b11:b0:dda:eee6:8e52 with SMTP id
 eh17-20020a0569021b1100b00ddaeee68e52mr151169ybb.7.1711560987094; Wed, 27 Mar
 2024 10:36:27 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:10 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-24-tabba@google.com>
Subject: [PATCH v1 23/44] KVM: arm64: Introduce gfn_to_memslot_prot()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
2.44.0.478.gd926399ef9-goog

