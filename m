Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C377C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:37 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d074da73c3eso2523676276.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591056; x=1691195856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A8aQo92BGEsQWkSMM0MIWBDLRqK5BVyNdFuue+2u5/k=;
        b=rHAAon41DFnQeXUebX2OJqNtyuIqCjw/zv/LEFTrP6sKfuqbWQWy9vTAeDC9baKzkM
         InL2pbSWIvgmJo1PFc5PkZ9IssaPyWA6beQKHDlATRaITOhgmWiIi4Yc6QNojT4gim2g
         VHEcBgumeC+dZAbxD6aD3GbVFZzVhTveam9/0HVj8PAwwacp6sj79h3MRWTWHVGts8EH
         qeFgp3tJXVbDG7wMwDPRbM2LiNJJ9L5W/iXasZCfE08XzD2USXpqlYmrhqXhXY8U8Dxh
         QtEieDJoOJzHX5jn1vKb8EIGVG6faLPinZHl9nkvORH8R4TaxZmBVa2qWsf+mhcEmiq1
         bkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591056; x=1691195856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A8aQo92BGEsQWkSMM0MIWBDLRqK5BVyNdFuue+2u5/k=;
        b=SxO9bgxb5t0B/RKensrPjWdXJx/80lTfn9MbLQ1C5v+GhvKE88Duor8p8Wa94/LiCa
         M1Y58IgQtgBuTBhms0VjOziFM7keN/UjlDJBkuAV9NNYhOUg7Nywl0M4xlR9eTXOxe5p
         zsry0pu7x/tWc8X3sNbXtzdvA2TugWbgC6E1/Hau9GsVH3G2rNKopjqRKkDXswUIhICP
         gJgG3Gj+EsmDYLn+9tQv84vF9y0g2QyFux+L8FTSiu5HeznFvhw3UaC8iy6IGZSvduf7
         tTACAiPXTcnB7683v8ZvKuUfvKdF+9ob0crjM25HPepAqEss4lnV8B3A24tlzFLwvPDa
         cByA==
X-Gm-Message-State: ABy/qLYnw4Wc3FlJ7pE/w3E6EJIhBQIyAiu8RZSKzJhykqp7+eqv9iPm
	v3Wgw7rCeiv4+npHHY3ZlqDApOzaB6Y=
X-Google-Smtp-Source: APBJJlEJnPZI81sdISJjMNXK9i+0b+uyCp/hlcuf7GAPKJmfjcAxHXQ0DG6ODxl42Zjvl3eTSQ7DFBljZzk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:29c2:0:b0:d16:89fe:52cd with SMTP id
 p185-20020a2529c2000000b00d1689fe52cdmr17553ybp.11.1690591056277; Fri, 28 Jul
 2023 17:37:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:35 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-27-seanjc@google.com>
Subject: [PATCH v4 26/34] KVM: selftests: Convert x86's set BSP ID test to
 printf style guest asserts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert the set_boot_cpu_id test to use printf-based guest asserts,
specifically the EQ and NE variants.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index b25d7556b638..abb3f26d3ce0 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -4,6 +4,8 @@
  *
  * Copyright (C) 2020, Red Hat, Inc.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #define _GNU_SOURCE /* for program_invocation_name */
 #include <fcntl.h>
 #include <stdio.h>
@@ -20,7 +22,7 @@ static void guest_bsp_vcpu(void *arg)
 {
 	GUEST_SYNC(1);
 
-	GUEST_ASSERT(get_bsp_flag() != 0);
+	GUEST_ASSERT_NE(get_bsp_flag(), 0);
 
 	GUEST_DONE();
 }
@@ -29,7 +31,7 @@ static void guest_not_bsp_vcpu(void *arg)
 {
 	GUEST_SYNC(1);
 
-	GUEST_ASSERT(get_bsp_flag() == 0);
+	GUEST_ASSERT_EQ(get_bsp_flag(), 0);
 
 	GUEST_DONE();
 }
@@ -65,7 +67,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 					stage);
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+			REPORT_GUEST_ASSERT(uc);
 		default:
 			TEST_ASSERT(false, "Unexpected exit: %s",
 				    exit_reason_str(vcpu->run->exit_reason));
-- 
2.41.0.487.g6d72f3e995-goog

