Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78B17C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:25 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c6db61f7f64so2575935276.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591044; x=1691195844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hrn38U8XG/46tZy+we7A1as/nu6Sx8AH5e7Mkf5XcGI=;
        b=kYyOWNI3Tn0tKjaJAbKUbe+RATw5K4fjxiUuaXudh6bQsz0nk+rrWkEwGxoeUE8Rdi
         rXRXsprqtFcJhBkVPM20n/0HtgaEsCoVa8v6/kCKFy7oX2SIHFWg51BkdkmGFEmzSepP
         2gAPtNBnJLTWooycD5UVhbOrN4nOcu3008l3Ceyp9g6PnhBXl4EEwwEtEuZLHJfgU/A5
         UkgXflZWtB7aJlaJepJStf7zhJU2AjXbqkCBxzCqurBavTp7EKn7rwX8d9x+RFTF5RwE
         V2ZZUTjWybiOP9xtSUsLs67rNkXjEZ7XhdkUZ4LcC4gsP4I7E7M3kQhVj8JQpnmfVP0o
         TyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591044; x=1691195844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrn38U8XG/46tZy+we7A1as/nu6Sx8AH5e7Mkf5XcGI=;
        b=U9/5gFkQROXgGRRCNfX8becuKx+F8lJDEPge9xbhBypikQrB6SuCzb72z0A2IQLhoe
         6RIGKutLKFS90UYz2g8JnkBWOgrFF5DERVr+R0wCQ5zUHPELYWYq+IYaWGwyimN7feai
         m24kQcRxxGSFXgpA9lF8IlJGd18PvdHmt9iu/UO8imTwcj51k+/P9xfjz/WrO6CUll0n
         TfpZPoxr6osohUAPzimySJW5NzreW+PQtxKO+J+GZJ6OZdDLgUYj/+XhUn0PhIPk3UKj
         Z4UtCJJ0gDYk6FUFjs/dfSMJvXQ2fwiOSEcgy0NXKbW1AH4COqInDCVDWNyAwfWOD2TY
         f4rQ==
X-Gm-Message-State: ABy/qLayYGdDmUCwZWkhcvXNWggFJiuS8bnLP/Y9B2Wopa3XD7h6KFcV
	aexv+ElK5QsmtkHcG8cVrV2d55pLkrI=
X-Google-Smtp-Source: APBJJlGHOQ591JfApZ8THfZnSHgzN+MSYyAoPeR1h4t6+1y6LGBQsuLklV2KgJfnPiU38m7V2ogUBR0+WxY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1611:b0:d0d:587c:e031 with SMTP id
 bw17-20020a056902161100b00d0d587ce031mr20024ybb.9.1690591044658; Fri, 28 Jul
 2023 17:37:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:29 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-21-seanjc@google.com>
Subject: [PATCH v4 20/34] KVM: selftests: Convert x86's CPUID test to printf
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

Convert x86's CPUID test to use printf-based GUEST_ASSERT_EQ() so that
the test prints out debug information.  Note, the test previously used
REPORT_GUEST_ASSERT_2(), but that was pointless because none of the
guest-side code passed any parameters to the assert.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cpuid_test.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index d3c3aa93f090..eb1b65ffc0d5 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -4,6 +4,8 @@
  *
  * Generic tests for KVM CPUID set/get ioctls
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <asm/kvm_para.h>
 #include <linux/kvm_para.h>
 #include <stdint.h>
@@ -35,10 +37,10 @@ static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
 			guest_cpuid->entries[i].index,
 			&eax, &ebx, &ecx, &edx);
 
-		GUEST_ASSERT(eax == guest_cpuid->entries[i].eax &&
-			     ebx == guest_cpuid->entries[i].ebx &&
-			     ecx == guest_cpuid->entries[i].ecx &&
-			     edx == guest_cpuid->entries[i].edx);
+		GUEST_ASSERT_EQ(eax, guest_cpuid->entries[i].eax);
+		GUEST_ASSERT_EQ(ebx, guest_cpuid->entries[i].ebx);
+		GUEST_ASSERT_EQ(ecx, guest_cpuid->entries[i].ecx);
+		GUEST_ASSERT_EQ(edx, guest_cpuid->entries[i].edx);
 	}
 
 }
@@ -51,7 +53,7 @@ static void guest_main(struct kvm_cpuid2 *guest_cpuid)
 
 	GUEST_SYNC(2);
 
-	GUEST_ASSERT(this_cpu_property(X86_PROPERTY_MAX_KVM_LEAF) == 0x40000001);
+	GUEST_ASSERT_EQ(this_cpu_property(X86_PROPERTY_MAX_KVM_LEAF), 0x40000001);
 
 	GUEST_DONE();
 }
@@ -116,7 +118,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 	case UCALL_DONE:
 		return;
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "values: %#lx, %#lx");
+		REPORT_GUEST_ASSERT(uc);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
 			    exit_reason_str(vcpu->run->exit_reason));
-- 
2.41.0.487.g6d72f3e995-goog

