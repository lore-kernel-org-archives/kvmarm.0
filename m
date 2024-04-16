Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7D32907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261433; cv=none; b=i/8219kyTo4ZnZFlaDbPPtGj1ASQfh0HxAXitd5CQmRXxyrtMxl4m07s1lQEZ4pAOk9VZOF7jtl618+a7sfFrw9uc+EZj/N1uSXWEXvJcYJTVqUvqwpLtuEnVAQKsk7n/PN4umggDtvIDOcMoTvrTj9D6o0ab/jvFrHCUD38A2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261433; c=relaxed/simple;
	bh=4mmjLeW5XYMtfDDJqFSwRQyVD+YjRIXEYxMh2rP/PDo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y9VK0qxkyjSQqAMU5tlJWrqVYC9p2ZGD7luilhOJTo4dwLLvsasDWYRUalJwkJ4mXGpwwuEi/WGIFn5iaPMJfcZPnUYfwI25eAQwLgdR4KvnMSFT+LeSAsbcda8LqJeSDtM6KUtcqVImGyaR2T652QhQudUh1G+txz+uhWa/HS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZtCY11ot; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZtCY11ot"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-416ac21981dso21909655e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261431; x=1713866231; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7CWqwJbj0pvwd60TW3Rv0GBu1dIiKpUz3vGeM+UNM/A=;
        b=ZtCY11otW9pw9n7ZUTg4BJKfyXqGlXIiRDrttzu59/7UwnK3uUyoHNi4Q+P/3oHoGb
         7PAdrFAEUSLl8W81g9WYqeklstX0g0s4srOH9BSy3Jz+PK2d3EldfSbYUJ57Saeo79lH
         GHc3D79ZPojey7Xz95xe02CMFrh8rS7R4Yintw7FYe9R+VJM7WVV1FOQgn8dfJJEM9c2
         mwKdieooP7HSlcXZrVNBB/N8kM4p+LQwGekghTcFX2Hem5YpMmZRGIGQGiby37DDBPyf
         p4z6RZ9naK2M8bmXEo84+m5X1RS8JawA/kNi8eRrIH/pGZ+kjx9rozBhPxfD8DG0j1mP
         OK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261431; x=1713866231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7CWqwJbj0pvwd60TW3Rv0GBu1dIiKpUz3vGeM+UNM/A=;
        b=O3oA6YTwyBg5PANJXvtzveL8O2iW5cc9W+Xze2E9bNhl7wxSnmukwxtjpC62UtPofY
         0HiKouEtGWUq9835UGkuxx7OFllhjHgHh//5wIGT9Ye4/gRVCOd7wmncE438sL0vsrY/
         9rqtctCDydqVMecHmO4yMims3wW2ki1KQHxQjPaU6WShj2q8Nhg7T/esaK2cffm30LVv
         X1/f/oD6un8bvrjbglSj4BtxVld5ugXq73fhHhcu+18hwKZIZzOa7N4C4Y1RVFGcAfgN
         7GKDr7smSqUJSyPn131MIHq/VCpNbpSVAFsn1y/0e3CyE0NG9aw/en9j+lyI77J8V1TX
         z12Q==
X-Gm-Message-State: AOJu0YzIfTqumBpWu4kg4xGVYElnH1z1kKey+dVlT/iF9AcSEozj0qcr
	fTcf7wqX8LxXT5f1mHxG/GTwf/pArBKq3u1ROzv5KrcjqJrMWn4dIP2Qi9QuE1O+P0fMiU5akaY
	7FbQb92bflnDHd3zUl4AOFWVe1HR2bonrdmVLgJVX7nx794AGLWSDUeE1Ki2A3gmMERgxlrMPz8
	HtSltBTigipzisT7WEGSA/kJN0l9o=
X-Google-Smtp-Source: AGHT+IGuHbo9Borcfin+4vggWuM2qX7zjNOeKDtl8We9aA1ZI1+dX/pMgGRxNPnxx4n9ZQdgHMRoaIcsQg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:35d3:b0:418:9fd3:6e71 with SMTP id
 r19-20020a05600c35d300b004189fd36e71mr25726wmq.2.1713261430981; Tue, 16 Apr
 2024 02:57:10 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:04 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-14-tabba@google.com>
Subject: [PATCH v2 13/47] KVM: arm64: Introduce predicates to check for
 protected state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

In order to determine whether or not a VM or (hyp) vCPU are protected,
introduce a helper function to query this state. For now, these will
always return 'false' as the underlying field is never configured.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h      |  6 ++----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h | 13 +++++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2b63fdfad5b2..9e4b044d4cea 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -211,6 +211,7 @@ typedef unsigned int pkvm_handle_t;
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
+	bool enabled;
 };
 
 struct kvm_mpidr_data {
@@ -1286,10 +1287,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-static inline bool kvm_vm_is_protected(struct kvm *kvm)
-{
-	return false;
-}
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.pkvm.enabled)
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 20c3f6e13b99..169fbfef61b7 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -53,6 +53,19 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
 	return container_of(hyp_vcpu->vcpu.kvm, struct pkvm_hyp_vm, kvm);
 }
 
+static inline bool vcpu_is_protected(struct kvm_vcpu *vcpu)
+{
+	if (!is_protected_kvm_enabled())
+		return false;
+
+	return vcpu->kvm->arch.pkvm.enabled;
+}
+
+static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	return vcpu_is_protected(&hyp_vcpu->vcpu);
+}
+
 void pkvm_hyp_vm_table_init(void *tbl);
 void pkvm_host_fpsimd_state_init(void);
 
-- 
2.44.0.683.g7961c838ac-goog

