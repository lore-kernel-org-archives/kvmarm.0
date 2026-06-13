Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C191C23ABA8
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310046; cv=none; b=aYZ0tPliLg5/kERpf7BEfl1fZrkPfrgr7ptJ+j1WCWERaEXY94t8ZaAQN7MPTx/x8wT3JJEj1FKu3rjpjy2gaEp/1lYC590QAjQsKcg+7Rvci0D+CEnvzQxd4cf6aAAzDlz9osjCjNAdmXXVzyb5d2jee9RSZPRTns3Fg0EqyFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310046; c=relaxed/simple;
	bh=z2y3Udpn3PcQ5P8PyZ7p3m88PIL7r3+VZEmGyqxvHS4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cqLoInwyqXpCsrDe2MEcskU919TMZjX2nJfqUFWHzP18CTAwKYqvSs7qxo9VsodwlkjGFqjwRzKV9ohAjVu82Ztd8f2mgZ2kT/fj3BXyMX6OtJdE1wtLF5fejvARNiCy9/3n9g8xvd9fRM62HdnfMbJJZpPX3njf6178Hqw5Nug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PWGNKlIP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PWGNKlIP"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c0532a6588so13996595ad.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310042; x=1781914842; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RpDrln9aFOeZE+9RVMRnWEbd+STgPtUuso+t2WcSRjI=;
        b=PWGNKlIPLK+9P6KodBGORpUfEFQG0j4z+zGMBPrV/yPKSQar+qbFpa53B/XCtXo7qE
         PSolq6bAN/iAdTdKBks80vhYqMYkPKEKI4UP7TpBGcIfnLGTA0Euc9OUqliwWyCN23Q0
         i6cxtjGIvu0n97uFzRFpLDpxOKHhqj1MEyP3SZtFyFFLN1pttw4UlUBXv45oRn5XsvVy
         oFPUx+kuxSAT+jstKRhMdf+2e2y8jUfTy7EuRvffYqaq1LhPyWYS0ZBIzYyaI8HEVufE
         Dcfpt4rDpLzuzEeirgK/Vs+ux/Q7ov2bxQA2v5cpzggLsY4EmrGQh70+2SpXA/xDjeuu
         AZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310042; x=1781914842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RpDrln9aFOeZE+9RVMRnWEbd+STgPtUuso+t2WcSRjI=;
        b=ZNnKaT3fWoJAGLi1I4NLmhtcwmaTrS/xjUjP7wyFu7/QXi2vJdsqQtLxPQaMXF1c0j
         cmN6rrU7A4e9lPRHIq1o4xYiFHk03X+AMAqnxOypueReQ3AWC6IX+qtgzFILRIHZhRV3
         BMMT7YepaMHBS5s8zk62xv8wfAQ6yzm7cQciAHyK1pkikohgqLh/HIyty3dgxLYLKxPb
         Lp3hVrdOKuDEi7bnRfcOlbtefxNBmF6wjEgFMDtoTJHT5UD6wa8N0D14AuNN9fjFkzjj
         7mlZdmAcoM/huXdr40Op0aoeOvST+xsy5rED2vt/r6t592pRlMgYa+8A1QqvZT2rzklb
         sJfg==
X-Forwarded-Encrypted: i=1; AFNElJ9/jCtzQuZ/6lz3RpTvUTSNe+YxdqXovqrPWn/LVTT7tg53DarYcoDsTKR4St2eC4TAxXoyJ/c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWo2YgTVdySY8pmFVcgrTwavheYV2RZDe4K0zM9PN8EPlobfjN
	VIZHi26+kTQAibSD/zNFHMKJAZri6gfOrz/7DUag/IUtidJE70SUpooNzDTDrNtD6aNuFlmxe9I
	ro6thVQ==
X-Received: from plbkx8.prod.google.com ([2002:a17:902:f948:b0:2bd:106:8ad0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e881:b0:2c0:b932:866e
 with SMTP id d9443c01a7336-2c6642915famr18540805ad.27.1781310041864; Fri, 12
 Jun 2026 17:20:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:17 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-7-seanjc@google.com>
Subject: [PATCH v7 06/20] KVM: selftests: Add helper to generate random u64 in
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
2.54.0.1136.gdb2ca164c4-goog

