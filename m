Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C456138E
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:15 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bba9a0da10so18216015ad.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591035; x=1691195835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mSgovIDzsK9OZPmvcIO6PrlG0pGNiSzPLHn93Xk6PxY=;
        b=BbFY48Qmp8nvEYwQyB9GRdCa2QWFGF8GOSvEDsRT2X6u6sk5ecNEIIw5pDClILhRPd
         gRvtNuN3ImdWbXCF4zdd8FaLMJMM1yfDzxm9ActT6o7IL2r/JrzTNkCKHtf9wNe1Gmo3
         Tl4rruj0O7W3W3HeWguPLoJRGSnt0u0v1aQ66LzDC8u8FZwW1oWvwxTpJdtFONqeoOxr
         MyE1evET6xf2Bn4Wij2M2+qzHfPaZBTPWBCljf2z8npAEX9hv3TY+e+9VlxpgDDP4OAh
         +QNyW6006w+aWT6DBLJmvaDiES4sOf5Luaq+3RtJ/lFNzLcfQ5p0vXcaTRPdDU31coc0
         fKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591035; x=1691195835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mSgovIDzsK9OZPmvcIO6PrlG0pGNiSzPLHn93Xk6PxY=;
        b=EL59GsVQzMWXmDHA0k/IHVl31aTamAJUYLxFAEjuNG4q7dISselUG+Nemrx6Dh+r6J
         fW3MYfAID+WQNOiprr3MX/PvLH1vi0KDzscw5ctFlV4LbgTLI0xMMSAdtyNYk9JLkAu5
         aRPql6y9G7+L6wkXUhPy/GpSBqmDt5aDYNuxMKbF+7MUTq59M+RWfx20RbZuFRgiRvHm
         0Gz/i/fwVgP+lFCPy9UWhD9B+D8eThBIv1rfMPf4CyRTXc/iOuKPwytJQtr3DAzYdcr0
         4QGKE77fZyy5JfRC+qsh6h2hhz0Z+B6Uw3pSWOTrQv2oqqCRGenjxj2yHjqQgoJm/6Vf
         Istg==
X-Gm-Message-State: ABy/qLaEKKDgAZIJ5cf1NGQDf/pLlPToFUAvwkxygCw9jx6IbmaXRBTj
	4lQWqj0fNCjVTlW6l9Ur6GMZ1Tnfx5Q=
X-Google-Smtp-Source: APBJJlGy+PARBjAnPL16yx26LNMKVev7tEI0rNgcySfjPv3eElz6XZ45aPg2i/DxTsp7qsC24ybgru6dHtc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e748:b0:1b5:61d3:dae5 with SMTP id
 p8-20020a170902e74800b001b561d3dae5mr14204plf.1.1690591035217; Fri, 28 Jul
 2023 17:37:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:24 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-16-seanjc@google.com>
Subject: [PATCH v4 15/34] KVM: selftests: Convert the memslot performance test
 to printf guest asserts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Use the printf-based GUEST_ASSERT_EQ() in the memslot perf test instead of
an half-baked open code version.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/memslot_perf_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 4210cd21d159..55f1bc70e571 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -6,6 +6,8 @@
  *
  * Basic guest setup / host vCPU thread code lifted from set_memory_region_test.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <pthread.h>
 #include <sched.h>
 #include <semaphore.h>
@@ -157,7 +159,7 @@ static void *vcpu_worker(void *__data)
 				goto done;
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_1(uc, "val = %lu");
+			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_DONE:
 			goto done;
@@ -560,7 +562,7 @@ static void guest_code_test_memslot_rw(void)
 		     ptr < MEM_TEST_GPA + MEM_TEST_SIZE; ptr += page_size) {
 			uint64_t val = *(uint64_t *)ptr;
 
-			GUEST_ASSERT_1(val == MEM_TEST_VAL_2, val);
+			GUEST_ASSERT_EQ(val, MEM_TEST_VAL_2);
 			*(uint64_t *)ptr = 0;
 		}
 
-- 
2.41.0.487.g6d72f3e995-goog

