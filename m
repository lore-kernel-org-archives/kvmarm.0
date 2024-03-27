Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C6F14E2E4
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561052; cv=none; b=EtNpCgtRbGYVo4UGmxSRZalyJKgQ+mn7jPMJPZkS51aRWsEzs6rPazuE4YIVStYlGdE6EPm/qm9MKnQPL+uUSUxTQkryQh4UOuJG1vrZghrZC31DzvNsQQrU66w2BPYVTSZDuYxcJtgYerxrrH18O5tvKHouO/5w+DB3epKkopw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561052; c=relaxed/simple;
	bh=I7vttjUEFrrcZjX1TGbuqHCLRNnzpWDhkCAxtgk3a2E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pMgXZEfZQFVIqg89f1zc8MrWBMONLKn7sIdZpRmIBOmRxsDmSHcvNDdUVL+nYJSrCUgcbxc2q4MYRu/V6KCdsgaiay9YcutiN9SSR9VAu6VYkSVQXyXylPX10xqk7cM9YtqYbkBft6bhWfULPs2jTfRm5AiN5fjK+9nWP9ozFCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wHzkYz8y; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wHzkYz8y"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso47979276.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561049; x=1712165849; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IMIgnoATqcv4sbLKe11UEv/iOk7sXYGehSkkX87GcRo=;
        b=wHzkYz8yfTl8/4bFTyEMXuhuHeb3oOthkpfiBwLxAO7JyjQCHrt+aTOUOMuFcUH9Tl
         +oSRQu2AwMdsAc1xApdc/vc+xu+GG9P6YfjfdXehVtUinRxiAXN+iPqTuSZDidMVsmr1
         oCpq6N9oykhdwH1vEILkvAch1vpvxVO761G4w9RiDxyPga8QagmW8gzspIlcHUegWOFK
         SCiEJj7/CNlnKsr52Aixbev1mqE/HK1K2mnCtMylJM6MyFK+18sRuhPhdnokMogtnPab
         B9n5gfQk1uiLzd99mUWMuHukWE0nHxyFcsWYU0W+mhcc82YgwcDWYSTibtdMmgijRDKX
         b6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561049; x=1712165849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMIgnoATqcv4sbLKe11UEv/iOk7sXYGehSkkX87GcRo=;
        b=QlxIsTLcR/SNPzGgoqmBX9Jvw3Pj3KFzCfWmkxaxRcnhhOWl6w3r8pyD/C4XXiDU8O
         3ZFCI9KsPYr3g2CTYzlzMFtYKAOX2G3bPgb6d0HD/5nJKdOmKYyBSa1CrG9G+jOvrVej
         2vGwQNHrEtmwVLdv9L9ERQGDUVC8P78KII/yUw/oo9UKweAxiex1TvonCytBzXOQfgo1
         5rHI1V6pKQmzcj/QU580OJrjlTSial1w/oUQVdLa5q1t5MUrpY1fsTi2ZajCmrl5vKEg
         88Msn3SlLMktzbetjrxgEmL7jEExtPItweCuIS8V4rMgps4NOz8gqe14ZmszD5pw94VY
         eROQ==
X-Gm-Message-State: AOJu0YyTQyYW4gp/IHowgN50aUOcwc2cCtb/OULze8gtRlYOJl/5KDL1
	8/wwwjbJSYmota6+xt7jZlQUWf6BHFC24GIb1Jc2byg/ZAvhxqymm9D5+Z2TuXia1uEzzmis1M2
	Zex/GnV4/7xalgYmA6mv7g7qgU05U3Ex7Jn6Vh7WJ4QjCU8fFmR0e6VeD2y4YeshGpHCMbdy8WZ
	Lefp8OGrbjMd4fdEuKrUifsnjwNkc=
X-Google-Smtp-Source: AGHT+IGpYy75ajbnDiBemn5jYN9pTdH7W4jCv2gFUaD/XrjODs5e0AxZkreQEih5rMrSam6xrweXT01YpQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2183:b0:dc6:53c3:bcbd with SMTP id
 dl3-20020a056902218300b00dc653c3bcbdmr143488ybb.7.1711561049599; Wed, 27 Mar
 2024 10:37:29 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:31 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-45-tabba@google.com>
Subject: [PATCH v1 44/44] KVM: arm64: Force injection of a data abort on NISV
 MMIO exit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

If a vcpu exits for a data abort with an invalid syndrome, the
expectations are that userspace has a chance to save the day if
it has requested to see such exits.

However, this is completely futile in the case of a protected VM,
as none of the state is available. In this particular case, inject
a data abort directly into the vcpu, consistent with what userspace
could do.

This also helps with pKVM, which discards all syndrome information when
forwarding data aborts that are not known to be MMIO.

Finally, hide the RETURN_NISV_IO_ABORT_TO_USER cap from userspace on
protected VMs, and document this tweak to the API.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst |  7 +++++++
 arch/arm64/kvm/arm.c           | 14 ++++++++++----
 arch/arm64/kvm/mmio.c          |  9 +++++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..b11b70ae137e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6894,6 +6894,13 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+This feature isn't available to protected VMs, as userspace does not
+have access to the state that is required to perform the emulation.
+Instead, a data abort exception is directly injected in the guest.
+Note that although KVM_CAP_ARM_NISV_TO_USER will be reported if
+queried outside of a protected VM context, the feature will not be
+exposed if queried on a protected VM file descriptor.
+
 ::
 
 		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 828bbd9e2d94..924010e8a8cc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -80,9 +80,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
-		r = 0;
-		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
-			&kvm->arch.flags);
+		if (kvm_vm_is_protected(kvm)) {
+			r = -EINVAL;
+		} else {
+			r = 0;
+			set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+				&kvm->arch.flags);
+		}
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
@@ -240,7 +244,6 @@ static int kvm_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
-	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
@@ -250,6 +253,9 @@ static int kvm_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_COUNTER_OFFSET:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_NISV_TO_USER:
+		r = !kvm || !kvm_vm_is_protected(kvm);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 5e1ffb0d5363..87fd8faf2b62 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -133,11 +133,20 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	/*
 	 * No valid syndrome? Ask userspace for help if it has
 	 * volunteered to do so, and bail out otherwise.
+	 *
+	 * In the protected VM case, there isn't much userspace can do
+	 * though, so directly deliver an exception to the guest.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
 		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
+		if (is_protected_kvm_enabled() &&
+		    kvm_vm_is_protected(vcpu->kvm)) {
+			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+			return 1;
+		}
+
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
-- 
2.44.0.478.gd926399ef9-goog

