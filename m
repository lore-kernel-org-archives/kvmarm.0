Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7376167DA8
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654973; cv=none; b=A6MzWVUcjBF00/ck7iavLjBVP5gmNIRrQ9CjRwdPp2kd875rdfBmaOJoFtUu7fb3AcnHeAte4xcsqHcHq0E7MG4VGM/1QWGbq5MBDdoW0Obcg/FRWe8wc1ubCPt4kI2dlIQI9zvoyg3gih/GL3s07F1axgBN+pmNfxceJlwbVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654973; c=relaxed/simple;
	bh=bFngUTjVBtg5CbyG25RDmTc6wZ0g8Z4dE05PWolnMuA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EKfs7g6hLl2Up9nBkLd8UDOBmS6itvzmDOfpcmE+2K47e4ruvqDiOwEj4Lkkmxy1IcYBgzveYX1UEjk1s4kfHCsKWtJSDX///PINh7q5EYoClEHtvnanRXyfls29qE8VAFh/CP9UnKklekz70HvblFtTYHndBkmqHpnhZchR4V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAQx/QFJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAQx/QFJ"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e056d640abbso495590276.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654970; x=1721259770; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wAPg+uoGyE7jrnqbrfnqp+qBfKQe/ElheERXpCs/y30=;
        b=oAQx/QFJs+wVElnJ0rtHAvL3IEa5r1fynik46zCW0DLpN8wWlzPgcKsteoq5QW3cLb
         RS4ROeuWvi6a37ZtKXKsYIBl9hPAMwCR9PMV14hbofmoRmo92d/r1pL1hR6Tl9/e34mv
         xXc41xA5RgFcjYWb7r5vjjsk/CKl8dpUrcRZSv2exNZWMc2cJHFKCG8Vr3SwjUcy6Izb
         2ttu3ngJCtxKS+KOUbSuJ+AnoZryV4hTqpzT2v7+QMzy+wjsh+nxZgAPc50NoVoxb/yZ
         2s1+6wsnfpNzlY0k7yPlt3+cWtuA1GuuqII1Ynz/v2ZBJdWpKsBBW/QjYSF0TsCA9h0F
         lM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654970; x=1721259770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wAPg+uoGyE7jrnqbrfnqp+qBfKQe/ElheERXpCs/y30=;
        b=g03W3vIq5GkLGBC75D0KMC8CGobNCJB9SBJgbzrrgqlgxQ1GPq+RBN7Wi4S0ScvukQ
         rI08EZU4bAUpYj3p8ZpWHW4XnKW9GB0et9+12B1mYyIQCpAgk+9oO0Es9E0P24UmLCBo
         B3jjAOr1v7aAMpKnDdEY46zSlXheLhgTeo5AQb3cPGJWuDSZ9zOUNYA5GaQKbsswqyqw
         iYYz5c0f871oZPVJcQt+8uZbZ2TLZr3AUYlIZOz6QxRd4viPga75WY9FdAcbCMicOTYG
         yuOWK+CFX86k3qbkv7oHhnRCDq6xcfgjqtzKJ2+Ont7JXZYt9Ud9d7OesPvgoiiqFZZ7
         MKqg==
X-Forwarded-Encrypted: i=1; AJvYcCVACO8nLInSRpOA9mWpRVp6SqQO/3x/TLbxxmLVOHhqpQq0cWvcWvs5JZkBPHuadItmt+WE2gsN7adeGIahjc52RR6fLmfn
X-Gm-Message-State: AOJu0YyVFb6HkhXEVBjijc5PmGbJhU2ZNo6cQO54RU3IWtMFk5GoDm3F
	Rt5nBTSEphtyJ3PxbJRLEuNSDmis+OPAc7W0w2VcRdeqGCzc/GzUivm0X0NCCtbgAaQnR/7vEIk
	1NEOcYKINj6qhBJxH1w==
X-Google-Smtp-Source: AGHT+IEUTEcOd07Ngb0BqkggJw4ozgt7Za8itkm1dvA0VYqtERMoRdOJmQ0AmWvr6/7REaf9c4XX0hx8Il26mfc6
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2101:b0:e03:31ec:8a24 with
 SMTP id 3f1490d57ef6-e041b17dfb5mr382800276.8.1720654969766; Wed, 10 Jul 2024
 16:42:49 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:16 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-13-jthoughton@google.com>
Subject: [RFC PATCH 12/18] KVM: arm64: Add userfault support for steal-time
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

As part of KVM_RUN, we may need to write steal-time information to guest
memory. In the case that the gfn we are writing to is userfault-enabled,
we should return to userspace with fault information.

With asynchronous userfaults, this change is not necessary and merely
acts as an optimization.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  8 ++++++--
 arch/arm64/kvm/pvtime.c           | 11 +++++++++--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 36b8e97bf49e..4c7bd72ba9e8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1166,7 +1166,7 @@ static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
 
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
-void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
+int kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
 bool kvm_arm_pvtime_supported(void);
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 59716789fe0f..4c7994e44217 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -974,8 +974,12 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 */
 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
 
-		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
-			kvm_update_stolen_time(vcpu);
+		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu)) {
+			int ret = kvm_update_stolen_time(vcpu);
+
+			if (ret <= 0)
+				return ret;
+		}
 
 		if (kvm_check_request(KVM_REQ_RELOAD_GICv4, vcpu)) {
 			/* The distributor enable bits were changed */
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 4ceabaa4c30b..ba0164726310 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -10,7 +10,7 @@
 
 #include <kvm/arm_hypercalls.h>
 
-void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
+int kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 base = vcpu->arch.steal.base;
@@ -20,9 +20,14 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	int idx;
 
 	if (base == INVALID_GPA)
-		return;
+		return 1;
 
 	idx = srcu_read_lock(&kvm->srcu);
+	if (gfn_to_hva(kvm, base + offset) == KVM_HVA_ERR_USERFAULT) {
+		kvm_prepare_memory_fault_exit(vcpu, base + offset, PAGE_SIZE,
+					      true, false, false, true);
+		return -EFAULT;
+	}
 	if (!kvm_get_guest(kvm, base + offset, steal)) {
 		steal = le64_to_cpu(steal);
 		vcpu->arch.steal.last_steal = READ_ONCE(current->sched_info.run_delay);
@@ -30,6 +35,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 		kvm_put_guest(kvm, base + offset, cpu_to_le64(steal));
 	}
 	srcu_read_unlock(&kvm->srcu, idx);
+
+	return 1;
 }
 
 long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
-- 
2.45.2.993.g49e7a77208-goog

