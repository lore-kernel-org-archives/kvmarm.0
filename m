Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E0AECA
	for <kvmarm@lists.linux.dev>; Thu,  6 Apr 2023 08:02:30 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id l27so38622479wrb.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Apr 2023 01:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768149;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aV1ZnUUJLqxOvx3H0XRFtDasoGMKHSB5Y7fc9UvZtzk=;
        b=YgAI2RKmmfNtFPE/EL3tY0mL4x4CM1XeV17+kFv+MwARKdbfDenoKaze/zdW1ShSez
         4n9nQmcyv9Wm8Om/THcxFYGjdNVr8TQ63gFwBT3zhS1V+YvR7C4TWRsSv5hDmiesos1r
         vHJ6Yk6rr+3LhneR3H2GCBqoRiJlvGn32SrrRhsWei72mN48CrOH766Ty2ApW+7FRSQg
         X3VGA7dS47sideSdlPoLAXNoN5lEDQ9KKc+06Iky+TgJPQyBSdjNC8TJsxT4y+r2jIQT
         RhN1SqAZlfj4CSG+T/XMW0CDZG/vL96vm09vw0FNrS5+kiGdvRWeOfDONaQgB6meiOWM
         Jy0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768149;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aV1ZnUUJLqxOvx3H0XRFtDasoGMKHSB5Y7fc9UvZtzk=;
        b=AhRqAA1OuzisitUNRuw7Q2ioxV1H5R5NacGjr64PBtBAwwKYEKrqsEObNiu9xOG4WS
         ErpGYFcmv6xqmJO8XQ/phEfO8al2mLLcILBP/yFWM7pS2dVbOlVSeBuq1tZaXM5iNFhT
         dfFyM8uT1f2lf3emJaLZ7sPthhXw6sKMUmoo9cL7tdH8Ja3/fJRjAHuKQbOgYlwZ1QV0
         7WtLyoVKcbct40NKaGMISRO/obtjKKq22h753S9CjiBbxiSsuHDIZUrRRUCQ/YGaSzkP
         zaip0H3lE8/2coFpQ6qSNIpNJZWDTpgPNiXnvEB1kvJ2V3pqmBM+rNRmhErhlZK/ixw7
         xYhQ==
X-Gm-Message-State: AAQBX9cRkdjrnEL3Zl43vuPW8X4X51v3cWLx7fKzXhmEMRpAxiWRSxu+
	m/XEyVu/k/HkfLSE0KBuOU0=
X-Google-Smtp-Source: AKy350b9h7ZEL2DRsB2Pm+8XOYlemA64X3N8kveF+ecbq572GltkKa28E4U1bJN1sMSfw1pXKqN7ug==
X-Received: by 2002:a5d:4950:0:b0:2ce:fd37:9392 with SMTP id r16-20020a5d4950000000b002cefd379392mr5485266wrs.45.1680768148950;
        Thu, 06 Apr 2023 01:02:28 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id b14-20020adfde0e000000b002d1bfe3269esm1008601wrm.59.2023.04.06.01.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:02:28 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: selftests: Fix spelling mistake "KVM_HYPERCAL_EXIT_SMC" -> "KVM_HYPERCALL_EXIT_SMC"
Date: Thu,  6 Apr 2023 09:02:26 +0100
Message-Id: <20230406080226.122955-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a test assert message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/kvm/aarch64/smccc_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/smccc_filter.c b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
index 0f9db0641847..82650313451a 100644
--- a/tools/testing/selftests/kvm/aarch64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
@@ -211,7 +211,7 @@ static void expect_call_fwd_to_user(struct kvm_vcpu *vcpu, uint32_t func_id,
 			    "KVM_HYPERCALL_EXIT_SMC is not set");
 	else
 		TEST_ASSERT(!(run->hypercall.flags & KVM_HYPERCALL_EXIT_SMC),
-			    "KVM_HYPERCAL_EXIT_SMC is set");
+			    "KVM_HYPERCALL_EXIT_SMC is set");
 }
 
 /* SMCCC calls forwarded to userspace cause KVM_EXIT_HYPERCALL exits */
-- 
2.30.2

