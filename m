Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6852C13D503
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558700; cv=none; b=YugmkjT0QD+YII8CY/jIY0L7sFaiVe7j7sZU5IOmnnp0k7GgHVRhoEVAiAoxUDK78EZXP0+cvCf5GilD2J9WHn6Z15Cukvxvz0CJa5as18FEN07HrKLIKRVjnhnaWXSuMu/SUlbp31Ku7FfQaG8PlARG/wbF8BTfXBHikIB0XTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558700; c=relaxed/simple;
	bh=WblEmOXy4lG1OvHRKBFgBmQz8+4EVU20P3KzKjYyjd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=olIfWpRBP78z8IJ46aQylH/JeaQvTwrqcv3X8AWyElguTCGWmtAwtbUFcVurd0MIU9eUrF4KVRvYOPx4onsDPZkepeTvn7a3EwEsW+rG5L0RPKx1r3Ik7tCzKeWlUaKgMc7cNdXh6Mctu36QRRN2N2arnk8X3ymNLDe9tdRau6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1gBpHNZs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1gBpHNZs"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9743093so4787868a91.3
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 17:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558699; x=1737163499; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3UIVRx5jS5uHOad/ZRxuC+ZyfJfWx7WVNf7AHGunc9Q=;
        b=1gBpHNZsMcqxv9GMezombf7cKqmBs+l+urqi3XHi3KUl8u466wHuGsLP/AJYjECiue
         aBuFWrMgO6qHkySuVSAT1c4HdPl6Z0cqkENpySdR7KQ5FPe+o0hd2NPxH+oeZwdxzCF2
         n1xHp86Vx5wAEgW9pQZIDdiOd76/bG3UU4C/prXIOStGM/7cCRLul2foIPGLGVrb2NfE
         ZtScN5+g3BhHqw4qJaTmV1GQ6hLW1e0VDr/rzDS0yBwYKWFaw0YeSMznbw1x3bW5ievo
         R2jlt1CeysRFMvEgQsj5HrbabZFxI+oO0qjfqh1oNRuu+jkjS6bLfUcFuLn+JN9M9jwG
         j8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558699; x=1737163499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3UIVRx5jS5uHOad/ZRxuC+ZyfJfWx7WVNf7AHGunc9Q=;
        b=J0RxbWULjr2NnBm7XtUGDfSsOrFa2iApyiCYOEoPzyYbKfr/NdUVAD7WHU7CPuIzdR
         BS3AZh+vECfblt9FcV4MCYLZGc7Bv9gyUaVohzn/aCojLeXG4OsS3CWA1he9+X0vMKLA
         AfSiCDVGhxpeZLIpYaQRZBWfy3W3HtZb9Jy01bIAJyY351i9QuVoox4hpUfP5c8SK2he
         JBMe/Pxt6YHQR6usU8XsQNlhePtPOFGu2aXyB4t2EYG1Ps0k1dwFkMl3XGrg8Zq5R0bU
         8/6aNSuXBWZI/Kqrbki4b3b7KA4N80Tcp03mX9L4r4v1YhY+XZbfRq/llimMWRVIYWQ/
         LoSA==
X-Forwarded-Encrypted: i=1; AJvYcCVh3IUNVOTInMsXmZBGtnCK7Z0ouEzOVf3Autau1d/VLSJq8EA4EpDzp4886T3cIH/Dw7ssWMc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8YHHqcLenSdShg5TzThSZNg0EZEfyD4CvMRF3E2JKjnL0c07t
	crm+RDLtvhiz0QKO3NI7k019NbrtHpk/ZJ7cJWn2bHdBX5TAJb+C12zQo4dyWt2ZYK93AoZC4R5
	FYw==
X-Google-Smtp-Source: AGHT+IHf025t1EVvlV+j91gbU3uZgm+9mZiPk2JrEEttgvDlmrVpnhWnRwbzCB96nhWXuJS4v4uP1KYHMJk=
X-Received: from pjbnw13.prod.google.com ([2002:a17:90b:254d:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5188:b0:2ee:df57:b194
 with SMTP id 98e67ed59e1d1-2f548eceb00mr17022072a91.21.1736558698928; Fri, 10
 Jan 2025 17:24:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:24:49 -0800
In-Reply-To: <20250111012450.1262638-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111012450.1262638-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Provide separate helper for KVM_RUN with immediate_exit
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Turn vcpu_run_complete_io() into a wrapper for a dedicated helper for
doing KVM_RUN with immediate_exit = true, so that a future patch can do
userspace exit completion if and only if it's actually necessary,
whereas x86's nested exceptions test wants to unconditionally do KVM_RUN
with an immediate exit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h           | 9 ++++++++-
 tools/testing/selftests/kvm/lib/kvm_util.c               | 2 +-
 tools/testing/selftests/kvm/x86/nested_exceptions_test.c | 3 +--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 4c4e5a847f67..78fd597c1b60 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -631,7 +631,14 @@ static inline int __vcpu_run(struct kvm_vcpu *vcpu)
 	return __vcpu_ioctl(vcpu, KVM_RUN, NULL);
 }
 
-void vcpu_run_complete_io(struct kvm_vcpu *vcpu);
+
+void vcpu_run_immediate_exit(struct kvm_vcpu *vcpu);
+
+static inline void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
+{
+	vcpu_run_immediate_exit(vcpu);
+}
+
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
 
 static inline void vcpu_enable_cap(struct kvm_vcpu *vcpu, uint32_t cap,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 33fefeb3ca44..c9a33766f673 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1665,7 +1665,7 @@ void vcpu_run(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_RUN, ret));
 }
 
-void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
+void vcpu_run_immediate_exit(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
diff --git a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
index 3eb0313ffa39..4f144576a6da 100644
--- a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
@@ -238,8 +238,7 @@ int main(int argc, char *argv[])
 
 	/* Pend #SS and request immediate exit.  #SS should still be pending. */
 	queue_ss_exception(vcpu, false);
-	vcpu->run->immediate_exit = true;
-	vcpu_run_complete_io(vcpu);
+	vcpu_run_immediate_exit(vcpu);
 
 	/* Verify the pending events comes back out the same as it went in. */
 	vcpu_events_get(vcpu, &events);
-- 
2.47.1.613.gc27f4b7a9f-goog

