Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79404182B9
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 23:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458811; cv=none; b=TIGFf2dBXSmVRSFqftGvxJHF0OvLOxfhobs/yoBtdKTmlFnfEV4vtpC9Z40LYJ963HBZYs0W63fK+wxuDCmkE6YfVx7i9tIFbaA/MQpETzI6cVRdSrIuSsxjoOgEyuk9JoKzAOCF5mF4cSvOkB5lCHou6OUCr+hNREF1aBATxLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458811; c=relaxed/simple;
	bh=kL1anMirud9R6581IlVg1+Shvk0whf3zxCiXUgx5dcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LRITzfMeFaXf/Dyo1EfLFzcDYoGvXX6Zogp+WisWkEnG+AYFFPMcq0JrIJpL3Mnz+3FVHodaQjKYe16Ap1m4Y2Wthp2uCA4Hxt6u9BUPIzECcoKSBF12Q+2281a5qzM1K8lsWNE4ULKaeFVDGYRyfHycOmrUhOekptKd3YjqGCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CY69QKc+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CY69QKc+"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6b9895301so1353545b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 16:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458809; x=1711063609; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k1ceQ+0+7x0dggVxu3pfjgACx/CpWN/VJ25BN1jj24Q=;
        b=CY69QKc+U9KjTE/3NeCDunaWv4O7rqt+fxsTlqHrWr1a7y+/Bi6QhXiuwgM6n2J9F+
         SNcmDIcGpiztEPmY2HjkKWV8nRKAPbHeUUTa20QGc78qzU9mBbJ9r0/SQCxb07oDmWsk
         hmEEyTNRZUI9Dq+p1A8Vd8d3GUFTbMQ4dYWa6URNBiipwZ/Znicav8sxUil9PZrqF97a
         70yfrzQeuXMv6Y9gEwGUpM1YN4Zq/k8RMos5HG02glCdxJVYS7unnYAoj6pf/CZcNdo8
         62jXkscQJZgbIfZ2Pmg1HalrcbPnsnZmSK6qHM4csb15+GVDpaJy5H8nT4lc3rSGcWQ7
         dJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458809; x=1711063609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k1ceQ+0+7x0dggVxu3pfjgACx/CpWN/VJ25BN1jj24Q=;
        b=l/y5lUGmLsv76U2H4hsuhhedtDyP4DfC+RavnD5UU83mqpuyzKtHOKeUccmJv+QOWb
         psVLx5FLDpSyIb4o65JLnNJzQnp5SVQ3VLcI4jDKQxI6ssc0lk24OY14IViwe4U5kSLH
         uUueU99rYV6uCEM4+L4fsfKNIqFi6go7uGNIBYBXHn/f6Vgp6cuePVB5voGIpYF3Pc3C
         887aNgjUwxMiQcqOEadY2LKMQBRUImySsqG0afFgTyMf6U9uGuCkGl0UhuqjH1ljFPMn
         E8DRzadvxZAJ3pwAuN6zT6njMhQk7lXBaqibtfK8Q63LiAPqsDDjnPCk07vkDljQDcqn
         kYeg==
X-Forwarded-Encrypted: i=1; AJvYcCUNaUopkxRTNTJBRLmEc+DuD9uX/9xn1M5MhXkJn2wZTj4oDsR1edcN2Cem3HA3NYOR6oSFhTn+f7auv9//2cInWSNZft7B
X-Gm-Message-State: AOJu0Yz4CQQwCUOuCUEz12p1r9j6QTWnI+AdjR0s13nhFWjUD6EkDzFS
	EjZngetJPWuuEciaksBQgtJMBlPyjTvQMWpC6XnImnXmWxizOhqE/Qn/F4J8cIZinSqXH2uleST
	DIQ==
X-Google-Smtp-Source: AGHT+IFa6Xo5alB77JWBKkmfaT2866W5+uuYd+R94MhsO58PTc0FssqvQ3Br5ekzS9Hb9uDd/sllma8cTz8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:23c6:b0:6e6:c374:f104 with SMTP id
 g6-20020a056a0023c600b006e6c374f104mr152102pfc.0.1710458808854; Thu, 14 Mar
 2024 16:26:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:24 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-6-seanjc@google.com>
Subject: [PATCH 05/18] KVM: selftests: Move platform_info_test's main assert
 into guest code
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

As a first step toward gracefully handling the expected #GP on RDMSR in
platform_info_test, move the test's assert on the non-faulting RDMSR
result into the guest itself.  This will allow using a unified flow for
the host userspace side of things.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/platform_info_test.c | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index 87011965dc41..cdad7e2124c8 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -29,7 +29,9 @@ static void guest_code(void)
 
 	for (;;) {
 		msr_platform_info = rdmsr(MSR_PLATFORM_INFO);
-		GUEST_SYNC(msr_platform_info);
+		GUEST_ASSERT_EQ(msr_platform_info & MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
+				MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
+		GUEST_SYNC(0);
 		asm volatile ("inc %r11");
 	}
 }
@@ -42,13 +44,15 @@ static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
 	vcpu_run(vcpu);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
-	get_ucall(vcpu, &uc);
-	TEST_ASSERT(uc.cmd == UCALL_SYNC,
-			"Received ucall other than UCALL_SYNC: %lu", uc.cmd);
-	TEST_ASSERT((uc.args[1] & MSR_PLATFORM_INFO_MAX_TURBO_RATIO) ==
-		MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
-		"Expected MSR_PLATFORM_INFO to have max turbo ratio mask: %i.",
-		MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_SYNC:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+	default:
+		TEST_FAIL("Unexpected ucall %lu", uc.cmd);
+		break;
+	}
 }
 
 static void test_msr_platform_info_disabled(struct kvm_vcpu *vcpu)
-- 
2.44.0.291.gc1ea87d7ee-goog

