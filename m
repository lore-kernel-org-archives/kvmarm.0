Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F9822256F
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052828; cv=none; b=JKlCdDdk6Syt86gRsS8L8RnG3iL750fboKS3ERVgJX93aKGZWQwXbkhJ/swCYdYof0pdyrf8OzajM61FQwj/KEz589SWVfg0pFTx8jYegyKYQ73jEj5YBJFjjuW2ybfMhWo4ujlB5M6q3+pOnmfgxG/cqFQjl6UPwOiE5fLB4lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052828; c=relaxed/simple;
	bh=vIl+HWefkeqsv1qtuVtCcBVofBdfj9obESA6FgCgLp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nyn77afu6ka94a4+c6mD0fu+H0VCzLOYyCI+qslGtLQWAXu1SJGp5RXuw17LRmZY+OFUmo+m+Z0gsfjOwyKcikJZjnWVFhoW2YaATTobbpXbYNYsgKGyd+nmK0crJXikm03Ur1zmAU0Ivm2HjK2v3IP2w51FFDixryGKp2W2MiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TUkz2xbD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TUkz2xbD"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c858e0cbca3so3235800a12.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052827; x=1781657627; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8NGdw5RJ6bJAu+NqY9JKZh9Q+XXOC2uDO6XCtjvqorw=;
        b=TUkz2xbD2w0R7pcAO1gzN/kCq1GR0Og//9AF4ZgDfhwsXyqwaNf6dGD1YUYDVOfu2N
         pk3mazYcbWPcvN1wjHdZgcilAngsho/pWg8oRtGft+FgVKDYZOu7wL7BPbgIHIWAcKt6
         gyRz/LztnByDIJhfCtECx93uS0YFti1sGuc68pKG2/VCmaN36WQAZrOxq/5ke4+MIMEk
         LucK77N2UKMQc0eXMio/TJZKQPv9h23Y4CbhTGPpiLaCt2Pg0XGrqay+3XmyO1mAgdER
         Os9/KfSUAkunXQwfFbvRhcky7Pu8c8n4mzRy3bdIAiF4wUHvqiRJ1XkWw0Lpb0QzwwUC
         YLtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052827; x=1781657627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8NGdw5RJ6bJAu+NqY9JKZh9Q+XXOC2uDO6XCtjvqorw=;
        b=JB/unldbZAIMXHD7fR/aVXfYR8SfZ85Z2QYdEQ9+YQO9rjf2HjhPRSXz1GKc5NgE4Q
         qtTMQ4RaBHzMvkyrDVPziVsIcsEQptDvRjT03fNs3WjQkmfd7Qh45YR3iEu7zc6P0pcn
         c/Wd1TJWuu/G9IfQAu0MdGTKj64aGhnbqeamTzzJHvuhIMYUgjy9z6nmsuMWENO8yUN9
         gpBSQP2wQfczOgRUvGIFkipqI8KzHRLipeJT9G6DZvRi3D46gpaNLLc0xtc0Hc+sz2Fa
         prZKnL+wDGfUlFBQJ1E1oaPMlLnHvZqGy1QIvEqliuSVgqW6MDzEvo9NeqXbTJX+rSWc
         uP5A==
X-Forwarded-Encrypted: i=1; AFNElJ+gWlhCtbtdIReYTrTcx6pLHeW/iT4mWY1U1xy5iUD0+RKI534TVgoGTZkE+m+sn4cI2wwj7eo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCdgWEiCyGxPN6g8nuFKLKyyIBY5TKYPk3JXz3W8m7UYP43l4c
	U0KqrLTbEnLZa6RonNLPYli0SBuoQgSqCQosE4b6v1iULB8ytVAXNwobi5ejOgM66NHuN2PT5WH
	8TqLxCw==
X-Received: from pfbhk10.prod.google.com ([2002:a05:6a00:878a:b0:842:723a:7919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2351:b0:842:569d:b105
 with SMTP id d2e1a72fcca58-842b0f8bd8bmr25284333b3a.34.1781052826595; Tue, 09
 Jun 2026 17:53:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:24 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-5-seanjc@google.com>
Subject: [PATCH v6 04/18] KVM: selftests: Add helper to generate random u64 in
 range [min,max]
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Josh Hilke <jrhilke@google.com>

Introduce kvm_random_u64_in_range(state, min, max). This function
returns a random u64 in the inclusive range of [min, max] using a struct
kvm_random_state.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/test_util.h  |  3 +++
 tools/testing/selftests/kvm/lib/test_util.c    | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 44c0104d60ac..d64c8a228207 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -134,6 +134,9 @@ static inline u64 kvm_random_u64(struct kvm_random_state *state)
 	return ((u64)kvm_random_u32(state) << 32) | kvm_random_u32(state);
 }
 
+u64 kvm_random_u64_in_range(struct kvm_random_state *state, u64 min,
+			    u64 max);
+
 enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index e98ca7ef439c..e208a57f190c 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -42,6 +42,24 @@ u32 kvm_random_u32(struct kvm_random_state *state)
 	return state->seed;
 }
 
+/* Returns a random u64 in the inclusive range [min, max] */
+u64 kvm_random_u64_in_range(struct kvm_random_state *state, u64 min,
+			    u64 max)
+{
+	u64 value;
+	u64 range;
+
+	TEST_ASSERT(min <= max, "PEBKAC, min = 0x%lx, max = 0x%lx", min, max);
+
+	value = kvm_random_u64(state);
+
+	range = max - min;
+	if (range == ULLONG_MAX)
+		return value;
+
+	return min + (value % (range + 1));
+}
+
 /*
  * Parses "[0-9]+[kmgt]?".
  */
-- 
2.54.0.1099.g489fc7bff1-goog

