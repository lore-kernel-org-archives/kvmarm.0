Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2118115A87F
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654964; cv=none; b=H/Pyj0SpvS9ZNBSRq2YbKPZJkZ8lwN8weUhBMT+c1gJRXB44ynoNF/9co3aDh00V+kn+yv19dJLU98zKmBf0n9Oh96VipdGwHRNCMqmYIGQmQHQ4DKaCVFp13WGtTr3pemj40c9nAfwI2k60uaJRGf+nAQiJ3/U5+Ljoa1VPdw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654964; c=relaxed/simple;
	bh=3Qf2g5mWL+5xmgWA+ouxgQR+hBm6JQ6o96+DWwhG9sw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJQIu1xB695GqWpEit5dAjnY9l65uHsf8dRqiluFYXGuQ5VxsI1OooDf856XeWqudlnc2O4P5ofVxZlaRTyJ0+RMRPehbwkgJP+0mnUgPEeX+wv05KktZkHkYSF/1k7IVLMOxbDhX6ksITvyC/ERPY0T9KDZ/Z7H3sFY/169B+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yMyCqS5J; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yMyCqS5J"
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-8101bdcb1f2so78902241.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654962; x=1721259762; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6BWcXKAsCbgqy4w2nNCeUW6tFbXjuDYwJZkZfwSoSpo=;
        b=yMyCqS5JguSrN8z8ou1QSM4FUprwtaOxvsXzCQcgqm9wszhVM00aFpZLGA+0CuFK9u
         mS0Y1yr9KMCOQwhAlkiew/KrG8Ci9G0baFlUufCZVMBbGSkLarqzhXE/mHRKbHeyhl0q
         nlc9QL1Pn/Vtg1eBHuyqSIAQZq2h1jr+vgWBdCYxroyAyGLNticlrMbhu1Oi7vAiBhSB
         dxMq4WUCqYeTF/Ees+tF7N+mHUXSr6ZgFW/9l5w8lCo53ALjpYesoeXiSb1u8T43N+YW
         Ra2Fv+2qcxCmMtqrAcUdoziB/oaiQR6VD0GtPsnO/ftbmirtpcb5nqzVxqKv8WkT3nY9
         wNqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654962; x=1721259762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6BWcXKAsCbgqy4w2nNCeUW6tFbXjuDYwJZkZfwSoSpo=;
        b=v2Ys/atKfiYhLHd8zyPP7LOMbCU+UsBVw4ZXtQc5N23UtXi7UBtkyAQPbPbvFGteEs
         vm7FNblDlzKq6zFtHgZyiX0jIGSnDwXhdAgy9aCDOIERwyc7gu5JmlkSC0rFohbqUD+G
         bFAMlwpo4v32KC7I2mdKHRW7sKChXGc36AFK6Yzg+d2TcLASUGh8XLCvr4zXKhY1lxI5
         H3NaiMJG2W8ybvVZGsQ3LGT+Q4Tm6LLVusBN4W441Fsq87Vynp8znNJBfwhH0u/eCZUu
         zYLDawPhpvAAq/EN03prj/8sh4x/0YcRCUzMugp+dz8c1f/JzFtYOVChqCYG0m6zajSM
         fgSQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1DmTK1TNnWrQrcPH0PiSuRyurBvolxlykePTVx6/dEgfzt1ZNmJ8jBxdOWlBgEJBsMlm6dFok/XV16MMTgarUoYUIjogE
X-Gm-Message-State: AOJu0YxlZJVWG5fboIi/8TAaIWnmahs49ocgHiHayNR7pZHwwhWAOpYe
	KX1GCz1YnZhg2cBBV97nRCU+bi1talOE/GEEJR19Lp9ZmBmIHyXPm1KZTZM7Xf6shE6Oa7/7hK2
	rmLnulmLCbQ3OkDf1WQ==
X-Google-Smtp-Source: AGHT+IEs5vUQHQ0lGxrPeXnI8U3zg0scUB3VU7/qVip/3trOIT/81ZfcXpykTilnpI2xQFZASFVWimG+3mGsVHMv
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6130:2b07:b0:810:2714:60fd with
 SMTP id a1e0cc1a2514c-81076dc9388mr47870241.1.1720654962027; Wed, 10 Jul 2024
 16:42:42 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:08 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-5-jthoughton@google.com>
Subject: [RFC PATCH 04/18] KVM: Fail __gfn_to_hva_many for userfault gfns.
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Add gfn_has_userfault() that (1) checks that KVM Userfault is enabled,
and (2) that our particular gfn is a userfault gfn.

Check gfn_has_userfault() as part of __gfn_to_hva_many to prevent
gfn->hva translations for userfault gfns.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 12 ++++++++++++
 virt/kvm/kvm_main.c      |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c1eb59a3141b..4cca896fb44a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -140,6 +140,7 @@ static inline bool is_noslot_pfn(kvm_pfn_t pfn)
 
 #define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
 #define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
+#define KVM_HVA_ERR_USERFAULT	(PAGE_OFFSET + 2 * PAGE_SIZE)
 
 static inline bool kvm_is_error_hva(unsigned long addr)
 {
@@ -2493,4 +2494,15 @@ static inline bool kvm_userfault_enabled(struct kvm *kvm)
 #endif
 }
 
+static inline bool gfn_has_userfault(struct kvm *kvm, gfn_t gfn)
+{
+#ifdef CONFIG_KVM_USERFAULT
+	return kvm_userfault_enabled(kvm) &&
+		(kvm_get_memory_attributes(kvm, gfn) &
+		 KVM_MEMORY_ATTRIBUTE_USERFAULT);
+#else
+	return false;
+#endif
+}
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ffa452a13672..758deb90a050 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2686,6 +2686,9 @@ static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t
 	if (memslot_is_readonly(slot) && write)
 		return KVM_HVA_ERR_RO_BAD;
 
+	if (gfn_has_userfault(slot->kvm, gfn))
+		return KVM_HVA_ERR_USERFAULT;
+
 	if (nr_pages)
 		*nr_pages = slot->npages - (gfn - slot->base_gfn);
 
-- 
2.45.2.993.g49e7a77208-goog

