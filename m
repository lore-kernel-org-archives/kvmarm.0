Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE5364959
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 08:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786179515; cv=none; b=KA+WCjqCxf5ZA4cndXTajhFUnP4uWx5QrxakWVFwzJDGfT55ObC/0yUA9E0NAHjfZe1tRMdSLusWCcXucGMOHaRxAUMl/lqcRShx/uq2vpvFmzSqNceWksaEPt0570S3TBSCHv+BIM5doQUm6GndT+N3XGJZx7rLqviyPg4NGzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786179515; c=relaxed/simple;
	bh=sOMxXRo2tf/41bNIqVZVhHEfAJNv3PSGO+R2IPHZu9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I4PbErC3/db6VPCSihuuozqfeca1spCvb3jIPwVbL8IZME51oJ5whPZaO5bGIFQbmPkYNZxr/WIEv9oqHZBt05aWd7G3Ylm3xnSv+qX9U/zCPx9feBxYOs6UqDfRNGRjve8e1F64vwfs7d3t6DMUdgoTicY5psfM+2ny/yqmO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Br3uRtwk; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Br3uRtwk"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1f3117bc6bso22215866b.0
        for <kvmarm@lists.linux.dev>; Sat, 08 Aug 2026 01:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786179512; x=1786784312; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w+A/GWMMn/zlz2wejiFB/oEcYi+94/jbgzvZk1RNCE8=;
        b=Br3uRtwk8wGeZpa7NWrJ+bBULG64esjMTZYwo52EuTMZ+qqX8pQ8EUdiS3fXnKH09o
         R2vBg/ETOWb8dkHkT4GcXcbDPvLrjCWwnKfCw2StPSe0n/Z150Ay/atdmRyfd75eQs3r
         XQ8OYxYv5PXQM5tyS1ZZHs5BcCDBYngmziQb6kMNI6JjQr7CsdGuG2S0Mm6VkEFQNLnb
         S2QDUgtBYv8nmZKFnFxBZH9tr/7L2IdXgLlrUPGB68q8+Y4IM+G4aVdYAJN0TyR1lA55
         EdpKa29Tq3zEjcCk4R572QJS7gXvm0L+186DspH7MXCLDbYkg3oCmGXZrEpActW7x0nD
         JsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786179512; x=1786784312;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w+A/GWMMn/zlz2wejiFB/oEcYi+94/jbgzvZk1RNCE8=;
        b=FOtdrOuKMKFQWE1mz5QZ+VkVfhzEpEj3/qCHmh8EbocbW7R+u0wHbII2Lc5xqt8Chs
         xZUfp/ZMGbX3zp3z27RWVBt6Iy1/gIctEQygDVWlWNJqACclZeD2YtQA4DSsY8C4BBnM
         BwG0RKu/5TvI4FKDwVaFUD+WLJWkjAaTC5sE6LS4yNfs4u4ik1QXS1vUyvSvoA1smgZS
         OUeeuVY7WdITTEt0bLBTXL3WGG/SOH6gzzo64TTusrnTwvsR1W1wQIVAVledzYBpAlT1
         2Hsa6hWfXXTTsFyNJHGJpC4au2RmhjCOW3bkLpGuuNVSJstVAH99hDhcCcK0PIezoj82
         6PCA==
X-Forwarded-Encrypted: i=1; AHgh+Rp6c+wVVSGyTR+oZvAXT8DIHvm0CvT1QMrxkHwZrThe0Peq11StrKLaugsXmaZfXrNkTOD6lUg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHycg01uTZKbvRvmyowR3nqWlfgmHY99JaBCQd5dQseHZt9StC
	cIdPQOet1qjo1JnIMtVGHotCPZfvbgpfJtgCMnsmcfn0oXGrlPS4wNKPpe5WB3x4iRUsE0WTHZE
	HZYbln25ycn95HQ==
X-Received: from ejdao2.prod.google.com ([2002:a17:907:f482:b0:c15:cd6e:51d6])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9729:b0:c15:db5c:7127 with SMTP id a640c23a62f3a-c2073364a2bmr714358466b.20.1786179511440;
 Sat, 08 Aug 2026 01:58:31 -0700 (PDT)
Date: Sat,  8 Aug 2026 08:58:22 +0000
In-Reply-To: <20260808085824.732659-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260808085824.732659-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260808085824.732659-2-smostafa@google.com>
Subject: [PATCH v2 1/3] KVM: arm64: Make timer_get_offset() work in all contexts
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	yaoyuan@linux.alibaba.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

We currently have two implementations of get_timer offset(), one
in arm_arch_timer.h, and another one in switch.h.

These two only differ by a pair of kern_hyp_va(), which seems a
pretty weak reason to open-code it.

Turn this function into a macro to avoid the include dependency hell
on kern_hyp_va(), and make it work correctly in all contexts.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +----------
 include/kvm/arm_arch_timer.h            | 34 +++++++++++++++----------
 2 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 4bf624a49591..2aceda749641 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -706,22 +706,9 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-/* Open-coded version of timer_get_offset() to allow for kern_hyp_va() */
-static inline u64 hyp_timer_get_offset(struct arch_timer_context *ctxt)
-{
-	u64 offset = 0;
-
-	if (ctxt->offset.vm_offset)
-		offset += *kern_hyp_va(ctxt->offset.vm_offset);
-	if (ctxt->offset.vcpu_offset)
-		offset += *kern_hyp_va(ctxt->offset.vcpu_offset);
-
-	return offset;
-}
-
 static inline u64 compute_counter_value(struct arch_timer_context *ctxt)
 {
-	return arch_timer_read_cntpct_el0() - hyp_timer_get_offset(ctxt);
+	return arch_timer_read_cntpct_el0() - timer_get_offset(ctxt);
 }
 
 static bool kvm_handle_cntxct(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 725023ddc792..f3f0a79647cd 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -163,20 +163,28 @@ static inline bool has_cntpoff(void)
 	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
 }
 
-static inline u64 timer_get_offset(struct arch_timer_context *ctxt)
-{
-	u64 offset = 0;
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define KERN_HYP_VA(x)		kern_hyp_va(x)
+#else
+#define KERN_HYP_VA(x)		x
+#endif
 
-	if (!ctxt)
-		return 0;
-
-	if (ctxt->offset.vm_offset)
-		offset += *ctxt->offset.vm_offset;
-	if (ctxt->offset.vcpu_offset)
-		offset += *ctxt->offset.vcpu_offset;
-
-	return offset;
-}
+#define timer_get_offset(ctxt)						\
+	({								\
+		struct arch_timer_context *__ctxt = (ctxt);		\
+		u64 off = 0;						\
+									\
+		if (__ctxt) {						\
+			struct arch_timer_offset *ato = &__ctxt->offset;\
+									\
+			if (ato->vm_offset)				\
+				off += *KERN_HYP_VA(ato->vm_offset);	\
+			if (ato->vcpu_offset)				\
+				off += *KERN_HYP_VA(ato->vcpu_offset);	\
+		}							\
+									\
+		off;							\
+	})
 
 static inline void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
-- 
2.55.0.654.g21b8a5bc05-goog

