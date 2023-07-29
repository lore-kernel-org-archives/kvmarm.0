Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CCA38E
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:52 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d2a7ec86216so468998276.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591072; x=1691195872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Yb5xazjAjbiDk0o4gEkkEuwr9pc6IYfbApM8E9AAcm8=;
        b=YO9ijSHOh5J1cVuChDXZrdsVMawU/dKC3CusW0Frvs07EOOTfINmzinv3GCCjT5pnx
         rOBnaYJ1R1OxykK+OmmG9x2M32byq/ygaqkkxRor1oohX534+fRV0Fzb/g+Z9GJAAFnW
         jexdmXQtuj7Yuu1Yap+4hcJXPNpYrAz7Y0Iw6sVCZTa347oPpKJaGpHJFiBeeTjF0raL
         UHcE4kvGQCnvr0Q42EmvlTszcZBmYKHtuPzFuNbbVtZFsYxggy0fjjFWI9bye8ZychB7
         V+Xqe9MeAa+YJY+J/TBov5lI1fOh7IPV6YbaCwxhJGiYJp20yNxXDngwT0t7StyBgLNo
         R6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591072; x=1691195872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yb5xazjAjbiDk0o4gEkkEuwr9pc6IYfbApM8E9AAcm8=;
        b=aPLkCE3X98OOZcsM3D09++fTl6axdj6YhogfUGF1KJG3bmgEHRySfmHlO/aRi92ARa
         oli6LRrl2hxvoDjhQ+Mm/8oYolq4trI1o+KoTftj7VnBiExWG5bXQ0cu89LDuq5B0XsW
         g6K9YAaCxfu+I490sUJPtVd0lGEyRm+26VYIUYde4cVeWNDNTM/DRz3xZWLohpZE2CF1
         HDILrq/QkS7JPxfnwe28VdtjR8E9t2aRjP9MCkVsmQv5vzv9ysQtLrFqr93b06OQRgoV
         gUYWlxxKqQElt1ULbWELNuqwLbIR+7DAkEs2+K1xjg+xyOM37l8Wp4AEdflu9dEL0OcW
         E/wg==
X-Gm-Message-State: ABy/qLaxO2iuLZ3RsRRFCDy/n02NPToMCwFfh4+Z9drccWl9hHGY3A21
	M+uu+ER7rGzkvaOTwCwYhgH209UZlyI=
X-Google-Smtp-Source: APBJJlHAddbDc2cMcbZUidB0HowWy2488J/QjMe6Knuj2J162JyE2GJ2xbHLQj0Pd31iUQBNjID5BYp2vlY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1582:b0:d0a:353b:b93b with SMTP id
 k2-20020a056902158200b00d0a353bb93bmr18375ybu.3.1690591071769; Fri, 28 Jul
 2023 17:37:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:43 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-35-seanjc@google.com>
Subject: [PATCH v4 34/34] KVM: selftests: Use GUEST_FAIL() in ARM's arch timer helpers
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Use GUEST_FAIL() in ARM's arch timer helpers now that printf-based
guest asserts are the default (and only) style of guest asserts, and
say goodbye to the GUEST_ASSERT_1() alias.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/aarch64/arch_timer.h       | 12 ++++++------
 tools/testing/selftests/kvm/include/ucall_common.h   |  4 ----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
index cb7c03de3a21..b3e97525cb55 100644
--- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -41,7 +41,7 @@ static inline uint64_t timer_get_cntct(enum arch_timer timer)
 	case PHYSICAL:
 		return read_sysreg(cntpct_el0);
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	/* We should not reach here */
@@ -58,7 +58,7 @@ static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
 		write_sysreg(cval, cntp_cval_el0);
 		break;
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	isb();
@@ -72,7 +72,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
 	case PHYSICAL:
 		return read_sysreg(cntp_cval_el0);
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	/* We should not reach here */
@@ -89,7 +89,7 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
 		write_sysreg(tval, cntp_tval_el0);
 		break;
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	isb();
@@ -105,7 +105,7 @@ static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 		write_sysreg(ctl, cntp_ctl_el0);
 		break;
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	isb();
@@ -119,7 +119,7 @@ static inline uint32_t timer_get_ctl(enum arch_timer timer)
 	case PHYSICAL:
 		return read_sysreg(cntp_ctl_el0);
 	default:
-		GUEST_ASSERT_1(0, timer);
+		GUEST_FAIL("Unexpected timer type = %u", timer);
 	}
 
 	/* We should not reach here */
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index b7e964b3182e..4cf69fa8bfba 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -102,8 +102,4 @@ do {										\
 		    (const char *)(ucall).args[GUEST_FILE],			\
 		    (ucall).args[GUEST_LINE], "%s", (ucall).buffer)
 
-/* FIXME: Drop this alias once the param-based guest asserts are gone. */
-#define GUEST_ASSERT_1(_condition, arg1) \
-	__GUEST_ASSERT(_condition, "arg1 = 0x%lx", arg1)
-
 #endif /* SELFTEST_KVM_UCALL_COMMON_H */
-- 
2.41.0.487.g6d72f3e995-goog

