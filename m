Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AD57C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:06 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-583fe0f84a5so28087827b3.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591025; x=1691195825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MTnhp9X0lvYUZIL9WzwgJz1fC/FCDEfshbcoz/56eco=;
        b=lx0KZzEtIsU0AdZ9qnXZlqbpjsDtaC9HcUC6zEB5z+kgdFIehygXDlCxd/jAA0wTwd
         4gRgNK3LibVhKtGBS+OwiXCm8B21jgDt2+6DxZvJ76oM47lhWAHJHFB0tKxpVNtgeF+B
         RMIjaJHwQQvB52Sgbeem3LaxJb7s8wsgeNOUhXWjnrzAyjFTAF0QPmYoh9DFE9SHjp9N
         WYQ7gSBDcpm+zTFhDttDC7VO88WNVZrNOtJn/gyTAZoWDTKtnoLkUSHxC6+D3Ctlvpda
         PH1Z199C1u+Cu7YlHc7/jYTzKlazFn0t0RJr3GmJfdmakqJtYgm5QBnYq03xGWhI10A8
         DNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591025; x=1691195825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MTnhp9X0lvYUZIL9WzwgJz1fC/FCDEfshbcoz/56eco=;
        b=l0if95lrTZq/L/tcG8j47RaSsKM7VMIxHPIGYDbjBz6sXPzclU30as6la+K8TDc3lt
         D76xBVw/JPu8rIZfVrIxkscjZ39hxYjQ0kYK+0ZmdIknHpTub88FCI9SBWS5w7fiMMC9
         bI+kIm0IwLfNn1Mk/FyZqf1JJI9W8UtIYQHJbxawyc2MJj4uWnIktyv4lIA6d+kveKqj
         sB1mMaZMKnIRU9SRMM/rXX85vFyefQxgPTVsL+HJKjutSBHNP3yHbaflf7I3Fb0O6Zmk
         A+2xboNKPk0LL12vc48lVC0fYllHb2YLGZ/0bvKzSBL0pDVhbElZMDLCryzuBuY0Hbtq
         I/YQ==
X-Gm-Message-State: ABy/qLbpgCxn9gfTOC341HBOzPDOlIGr6jQXQTBjP+BUaM557HFHCP53
	nldsyyu9xh5vgY/u504yKpBe+1Emolw=
X-Google-Smtp-Source: APBJJlGkPJLpvMgBhZQZngegrJd5H8lH0SpYQU1t+gpMp8O4I9K80z10fyRXj9c+AjJBWPrkzcKXkpDJEd0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad42:0:b0:56f:f62b:7a11 with SMTP id
 l2-20020a81ad42000000b0056ff62b7a11mr22723ywk.8.1690591025745; Fri, 28 Jul
 2023 17:37:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:19 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-11-seanjc@google.com>
Subject: [PATCH v4 10/34] KVM: selftests: Convert aarch_timer to printf style GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert ARM's aarch_timer test to use printf-based GUEST_ASSERT().
To maintain existing functionality, manually print the host information,
e.g. stage and iteration, to stderr prior to reporting the guest assert.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 22 +++++++++----------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 8ef370924a02..b53bcf126e6a 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -19,6 +19,7 @@
  *
  * Copyright (c) 2021, Google LLC.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #define _GNU_SOURCE
 
@@ -155,11 +156,13 @@ static void guest_validate_irq(unsigned int intid,
 	xcnt_diff_us = cycles_to_usec(xcnt - shared_data->xcnt);
 
 	/* Make sure we are dealing with the correct timer IRQ */
-	GUEST_ASSERT_2(intid == timer_irq, intid, timer_irq);
+	GUEST_ASSERT_EQ(intid, timer_irq);
 
 	/* Basic 'timer condition met' check */
-	GUEST_ASSERT_3(xcnt >= cval, xcnt, cval, xcnt_diff_us);
-	GUEST_ASSERT_1(xctl & CTL_ISTATUS, xctl);
+	__GUEST_ASSERT(xcnt >= cval,
+		       "xcnt = 0x%llx, cval = 0x%llx, xcnt_diff_us = 0x%llx",
+		       xcnt, cval, xcnt_diff_us);
+	__GUEST_ASSERT(xctl & CTL_ISTATUS, "xcnt = 0x%llx", xcnt);
 
 	WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
 }
@@ -192,8 +195,7 @@ static void guest_run_stage(struct test_vcpu_shared_data *shared_data,
 			TIMER_TEST_ERR_MARGIN_US);
 
 		irq_iter = READ_ONCE(shared_data->nr_iter);
-		GUEST_ASSERT_2(config_iter + 1 == irq_iter,
-				config_iter + 1, irq_iter);
+		GUEST_ASSERT_EQ(config_iter + 1, irq_iter);
 	}
 }
 
@@ -243,13 +245,9 @@ static void *test_vcpu_run(void *arg)
 		break;
 	case UCALL_ABORT:
 		sync_global_from_guest(vm, *shared_data);
-		REPORT_GUEST_ASSERT_N(uc, "values: %lu, %lu; %lu, vcpu %u; stage; %u; iter: %u",
-				      GUEST_ASSERT_ARG(uc, 0),
-				      GUEST_ASSERT_ARG(uc, 1),
-				      GUEST_ASSERT_ARG(uc, 2),
-				      vcpu_idx,
-				      shared_data->guest_stage,
-				      shared_data->nr_iter);
+		fprintf(stderr, "Guest assert failed,  vcpu %u; stage; %u; iter: %u\n",
+			vcpu_idx, shared_data->guest_stage, shared_data->nr_iter);
+		REPORT_GUEST_ASSERT(uc);
 		break;
 	default:
 		TEST_FAIL("Unexpected guest exit\n");
-- 
2.41.0.487.g6d72f3e995-goog

