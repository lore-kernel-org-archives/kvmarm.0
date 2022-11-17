Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34DA191
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 00:23:58 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id l1-20020a170902f68100b00187117d8e44so97376plg.2
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 16:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f1KDr+rH3XIqQLVQCEwig1RrLbtV2JH7CIwItqPq0uE=;
        b=Sb0CLlnDvxGcJjdPFEdXu3sQ7ExS0J2DsrUa96MG+x30pOPo41C8wX8lnkjEvFu692
         o3pvJ4nlLGDjV9D5+o/Xc1NHyPs2MuqEv5vvIqZ+sqZzIL/ssXgFKRuEh3ykOWsb8Aof
         8NuSb0SC0FoNWARBXd8nIP1nNXh5DasKaX+CcaBKFNHtvZl56/253TE6fwjP5JoMpiim
         gUPzWrrXnAvNi8nnM084PxpxGvTGH19Xn+GRoqghoBS14moljDfd44Cr3RqglOvym254
         gzMKd+B+aCWjFP6TQW5RMTEuFyf2CyJjQHrsUsqBJWG2Qn401exrcaqrEcOx43Ax6pEw
         +BbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f1KDr+rH3XIqQLVQCEwig1RrLbtV2JH7CIwItqPq0uE=;
        b=I1Ddl1hlrCZiO8CMzZj5SDrFu9vbuEdEbR6IUJym9lWbKRwiDhR/PYgIhlmG4GeR2z
         31CBpftnQ5DVUHf313CqUGVsEixVvwwsR6ee4/o6kqa4tCZE7ECxm0nAdGXd4FZgeW8H
         bGvRhoitW2t/vnlKYf2/IUQgCj+sh5AgV5jdyZlVC3bShl0sLx8vKO4Mi3sltDq0IywR
         PK2lxAQFMEc/wW1XUbmbzSwJBFmbr7MrFpVIetbxSNAGdLYdYCjr3Es+RSNIsQzz1nm1
         1IUC13uA1fONJ4OwFujyRgIZHPz6uCr+ko2QmgtsFVr7nuTrQNrdkcqDi4zH2ema7b8z
         iszQ==
X-Gm-Message-State: ANoB5pkIK07A+VsM+m2iI9qAMaW0ZjMyJcyAwJXwYLTqDFAH1j5PSbcR
	5I7uI1WHt7nh8YcJbJPPn87KBURU2TQ=
X-Google-Smtp-Source: AA0mqf413lvrUg1TdHwZHTgN7XZflJ1bKJMT3jX1WCVJjGcPVxVBe4WRIWEnFUWoG+XWNbACIBeMBtLtEhE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:a17:b0:213:2708:8dc3 with SMTP id
 gg23-20020a17090b0a1700b0021327088dc3mr636229pjb.2.1668644638088; Wed, 16 Nov
 2022 16:23:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 17 Nov 2022 00:23:49 +0000
In-Reply-To: <20221117002350.2178351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221117002350.2178351-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117002350.2178351-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: arm64: selftests: Disable single-step with correct
 KVM define
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221117002349.CT-7Pn3Tj7djcUKaHw45Uw6G--ILnBtLei_PexdPiRI@z>

Disable single-step by setting debug.control to KVM_GUESTDBG_ENABLE,
not to SINGLE_STEP_DISABLE.  The latter is an arbitrary test enum that
just happens to have the same value as KVM_GUESTDBG_ENABLE, and so
effectively disables single-step debug.

No functional change intended.

Cc: Reiji Watanabe <reijiw@google.com>
Fixes: b18e4d4aebdd ("KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 947bd201435c..91f55b45dfc7 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -369,7 +369,7 @@ void test_single_step_from_userspace(int test_cnt)
 						KVM_GUESTDBG_SINGLESTEP;
 				ss_enable = true;
 			} else {
-				debug.control = SINGLE_STEP_DISABLE;
+				debug.control = KVM_GUESTDBG_ENABLE;
 				ss_enable = false;
 			}
 
-- 
2.38.1.431.g37b22c650d-goog

