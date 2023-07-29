Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609197C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:08 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5847479b559so21521447b3.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591027; x=1691195827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qOSidrRp2LZHBdun0W7JYB5cE5pjjFCNvb+AcO0kpgo=;
        b=IeguEOY0s9ia4LSqz0PgZnKqVW1fP0z9QG/oINDmIWG6CyC3ATWOXcPU8daBe6CfLx
         EbQ+o0l0XWCtodFbjFJ1lBYl8zQ9lI/HK1IBed/hhqLzu7yFojnkVmJ5Yc2zwNnTDATA
         PExKr3IXJDvazDfzsaLC2WMEfRgTgridif3o+lN8QltCrJCx75svpURWl+JX3rfL6VEC
         3I/IQlUXZ5bIz7Ak78S5iG2A5Q194P91ty6X2ufPMUJBcnfkbk60TGWdsf0zLtGZHLwv
         khBr1DTEcFb4P1GyQshYSHcICbfkfAmADqNs7y7pi05FdJndMa+XA5kZAm/Fjpmrk/DX
         KMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591027; x=1691195827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOSidrRp2LZHBdun0W7JYB5cE5pjjFCNvb+AcO0kpgo=;
        b=DKesls2WDxm3V4WXwvtBAFkwfGu11Ri1+KG9IuF6td1q7TP6L2EfrScCuQx2Q0SXG6
         uB2y68dgrRMePlj2x6WyzJriym0dzCoJ8CY5k6vqNZenEK/rF2mgneF/PtAt4uOl6hQU
         oxE2n/vTO+ppaw/C6yh0pi626xzGv1GhXrP0WiAkqP/ERBC/nMrgKZfs5lq7DmIAO5q9
         fM7I1BgSnMk4aE6xzYYa2NLhFmaWl5Hhltuo1NkT4n/fpRWIBjtKndUqEI7EY0UPNleV
         /46bYKubguTwtyhX8ImDmUlA/0UVrpEXm5Ka/y5e98DrS9HPtXmdhSoVY8ieY4p7zqmQ
         OK+g==
X-Gm-Message-State: ABy/qLYSWY//E4SS4aHtdD9UHC1O7Zcy1lx+i+RiXdiCOcLCRLWISZyM
	ij1pKZPTrkkRQcsVQRLmYfrtmEpvJAY=
X-Google-Smtp-Source: APBJJlFoZbKPiG4qr8ZwiXvM3nPYLxinTgJuk9sccrmvpGopOc0ujixNDWPL7G8kTRHnTG9EjYmYrn1AOZ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac1a:0:b0:565:9bee:22e0 with SMTP id
 k26-20020a81ac1a000000b005659bee22e0mr24550ywh.0.1690591027421; Fri, 28 Jul
 2023 17:37:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:20 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-12-seanjc@google.com>
Subject: [PATCH v4 11/34] KVM: selftests: Convert debug-exceptions to printf
 style GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert ARM's debug exceptions  test to use printf-based GUEST_ASSERT().
Opportunistically Use GUEST_ASSERT_EQ() in guest_code_ss() so that the
expected vs. actual values get printed out.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 637be796086f..fdd5b05e1b0e 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
@@ -365,7 +367,7 @@ static void guest_wp_handler(struct ex_regs *regs)
 
 static void guest_ss_handler(struct ex_regs *regs)
 {
-	GUEST_ASSERT_1(ss_idx < 4, ss_idx);
+	__GUEST_ASSERT(ss_idx < 4, "Expected index < 4, got '%u'", ss_idx);
 	ss_addr[ss_idx++] = regs->pc;
 	regs->pstate |= SPSR_SS;
 }
@@ -410,8 +412,8 @@ static void guest_code_ss(int test_cnt)
 		/* Userspace disables Single Step when the end is nigh. */
 		asm volatile("iter_ss_end:\n");
 
-		GUEST_ASSERT(bvr == w_bvr);
-		GUEST_ASSERT(wvr == w_wvr);
+		GUEST_ASSERT_EQ(bvr, w_bvr);
+		GUEST_ASSERT_EQ(wvr, w_wvr);
 	}
 	GUEST_DONE();
 }
@@ -450,7 +452,7 @@ static void test_guest_debug_exceptions(uint8_t bpn, uint8_t wpn, uint8_t ctx_bp
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+		REPORT_GUEST_ASSERT(uc);
 		break;
 	case UCALL_DONE:
 		goto done;
-- 
2.41.0.487.g6d72f3e995-goog

