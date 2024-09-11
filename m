Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC63B19992A
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087355; cv=none; b=lBB6iE/hoQhWAp3nc6Qi9JxHOf0/TiFjH326bYJyJa9hkucuS7tobBJuft9iFntGRMnuI4fVt5JYb97AKxDFobzYbY/qc1JUQlyaKN3rgI5Hix2j3VMrQdquTQgDaPpR79NYQDv3gAAjHJ8UnKTgHggLjFBz9aj0szyfZkuM7Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087355; c=relaxed/simple;
	bh=1saQ6Xhz3JzwSNCRR1yV2CCjz4AlXZeyzxAJr9SdD5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y21lgUlQmVrfLWKVA0Kk9ydr5zF+PHKQgKxJEu+eGAyUX4QPB18C6mFthDm5MFPk07TFdAjzxlpfIvR5Flaq6/v4K16oGCP3uXc/8KnHtH7VDtEeoBSaaSsx60ngUD+bz6S+KMPMxCOYPMJhzSRO0li3jqWTNxlKzWRCzRmGU+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hT0SE7Wd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hT0SE7Wd"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d4f9e1a1a0so458645a12.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087353; x=1726692153; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/zCwfp6P0Cp/T+by076ZLxu5O+Esa9Wy3+GZFib04b0=;
        b=hT0SE7WdweGCg5HPPmQYaaoWIOMLvDTi9mLZP2JlD/8TA6m22N1on3qfbTYGPZ8I1W
         8QngapNxMTzUUcfH5EyNKqtT6QIDPN42pvvNDlD8Yw1i5ucXyIsx3wh6BZeO9Um4jgs0
         cILS4MDemOhW1dYmr48D6n+tuvgfYllSrDTkoH9Qlr9yjpELaJYcF4+l51ptojNItHsY
         B/JxG+u434TQe3zMO7JasO+mHH3nC5JxgXfQfSTQd9swpuCH5YDTqVtLS3RxXcSuNxiw
         MdEUx38OA6xUyx0xk95kOspTr5XDyzOT8cbANhvAO0cb/1IVpoX6Y/0c1xCQlPn0T7jd
         +lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087353; x=1726692153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zCwfp6P0Cp/T+by076ZLxu5O+Esa9Wy3+GZFib04b0=;
        b=blIU7xiRuIMNH6dDskOF49Dkk97dr/eJzHj47rAxmPKrj629oDbxKOHIHGWsx/ZshC
         FBi0MLQ8TwkKNXcPMNV/FFHDynIxFZ0paI1mFS+miSb4PYLJTYk12AJUWl0ewZVE7voa
         Cz6sec6ChltvLypvUv+RGXYHEwmI8S5UHDBPTwBHtBzyhQjmLue39iwl6jnN+k0nocOv
         uVnkOOrGr61EYQvg4tpyFvlEzQq4bK6Po7tDpiAV8npeFbtgzX4oV0812/JTL5zZSX/q
         RZ5TDfwpkJRUB7BGSJLs6hz8UBQAelr9fnxzjEoP+e85YW8TznElTfK9OJ7qWBF1eSZo
         Rb3A==
X-Forwarded-Encrypted: i=1; AJvYcCWNIeJNwuOkqtDzJx5FTPw0ALIeqw8ad2WMAzY+gjRp/ZC8lk0zFy+eMaxlSxL4qUWCU2aNPnc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvUQNWTGX2eD++3Bi/VjthdQstfaAGb8uR3/+6u/Ka2uW1QQpt
	ZhF66ohMWwqX5jvF90Lh3F079/bxcE7W9/jYW0yfz6WSd4gWnU6OLhz+/6cKpVnvFd5jGNXNLdh
	+rQ==
X-Google-Smtp-Source: AGHT+IGUai264jNYdPregUs2lG6efJQ9mB9ec+8i+QUzJ8LDBnAP8lzvYrxYOQMf2YPIMJvqww0dvL1st/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f68a:b0:206:c5ec:1445 with SMTP id
 d9443c01a7336-2076e44b9a6mr10485ad.8.1726087353017; Wed, 11 Sep 2024 13:42:33
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:51 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-7-seanjc@google.com>
Subject: [PATCH v2 06/13] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename max_guest_memory_test to mmu_stress_test so that the name isn't
horribly misleading when future changes extend the test to verify things
like mprotect() interactions, and because the test is useful even when its
configured to populate far less than the maximum amount of guest memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../kvm/{max_guest_memory_test.c => mmu_stress_test.c}          | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..93d6e2596b3e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -138,7 +138,7 @@ TEST_GEN_PROGS_x86_64 += guest_print_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
-TEST_GEN_PROGS_x86_64 += max_guest_memory_test
+TEST_GEN_PROGS_x86_64 += mmu_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += rseq_test
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/max_guest_memory_test.c
rename to tools/testing/selftests/kvm/mmu_stress_test.c
-- 
2.46.0.598.g6f2099f65c-goog

