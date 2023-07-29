Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E30C7C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:14 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-585f254c41aso4256377b3.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591033; x=1691195833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jFbTWBnTo16fnwIdUW+NlD/5fy0AI1YGJZRG7rO31c8=;
        b=YbzMbVhpY6NSduIpNQdD3qQlyt9xdigEOx+DaMLJ+/1005/m6d0mQJHJ2zPdXnnIGV
         PHn40LYSFNzYKhu59r32RQyeDajteY1wVPJtsfB/vWe3BTFWN071SEBzc0fNOwPO1eRa
         Spa2H8YIfF5YdZ+xaHx46GKzIR3aKDxlq3sDHHB/UuG/fN3nAvyJSYBPjFjamloZN9VD
         qV1s0UpIMQ9KALXTP5UIutnvC6+eEr47bajzg1NdQv4o7QKOcrtCYaYLEP6HB9i0pgdF
         yccbRzKsSb90kWq3a9BqtOl9xadE/NDJQ/2KS4MDV9xqG2w2KUqOy8WhnlrcioLq9b6q
         /xdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591033; x=1691195833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jFbTWBnTo16fnwIdUW+NlD/5fy0AI1YGJZRG7rO31c8=;
        b=TIiKTk8zXC3UhX9BNcRfYM+Ot5S9M6h9/hJBzHdLBxkQ0pTJCyckfZ0rBp85SFjndb
         YPMdgNLI/UWjVv5Do9gikT2O1mVPbIlBRK2ERfoBCFxPJV95uuG9i0CHVo+t7hKuhpfx
         3i3DK5bHQeYsMaIsLefLrpe5zxhPsS9G0XPbef7vCso9mVorCvipELnusSoVEXgrodab
         89OXOCqZbh9n+d0ZkHbBW+vmgsnl2Q4pfGaGB+of8DhahpzcMS2yn7LHMul2wm/XWNxq
         bJ7p1cPvsRf27FtJcCLWPcJzkHJY1GRwOL3L2wo6WDVS4wo2oxO0aPtPqT5kZupMJV2T
         s9Sg==
X-Gm-Message-State: ABy/qLbJKjk7lvm2UM9MRMhetJ/jfmzhNrjnuXvh5YQi77xJTZnJQx/p
	2NIJvEwAFICgBx5XV5bCcBlDMW6ZRB4=
X-Google-Smtp-Source: APBJJlFOFAvzGLqZ3WhMfPIFqSf7CLYIGldBh6TJ0ra7wfq/Bxr6Fucq0mI7ZF8VYXYP5klQu5yNzrY8ia8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:cf9:3564:33cc with SMTP id
 w15-20020a056902100f00b00cf9356433ccmr24231ybt.13.1690591033359; Fri, 28 Jul
 2023 17:37:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:23 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-15-seanjc@google.com>
Subject: [PATCH v4 14/34] KVM: selftests: Convert ARM's vGIC IRQ test to
 printf style GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Use printf-based guest assert reporting in ARM's vGIC IRQ test.  Note,
this is not as innocuous as it looks!  The printf-based version of
GUEST_ASSERT_EQ() ensures the expressions are evaluated only once, whereas
the old version did not!

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 90d854e0fcff..67da33aa6d17 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -7,6 +7,7 @@
  * host to inject a specific intid via a GUEST_SYNC call, and then checks that
  * it received it.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include <asm/kvm.h>
 #include <asm/kvm_para.h>
@@ -781,7 +782,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 			run_guest_cmd(vcpu, gic_fd, &inject_args, &args);
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_DONE:
 			goto done;
-- 
2.41.0.487.g6d72f3e995-goog

