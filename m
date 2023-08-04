Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C8664A
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 00:42:30 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bbbc4ae328so12083655ad.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Aug 2023 17:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109750; x=1691714550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TPdXiND7N94yuFEwSbECpKkQfmAanLh9RZ+A6BrvR7M=;
        b=2tZIajDGiYM8LOP6oRS7sIm2pcBnaXfZ7Wymplbdn69KUU8q53NcZ7y0HFK8pN3rJv
         XsgnlEdOHLu6ZqLedVwaja+dve26SOtilLHroxOKcn1gMKyUuqCKj30/Z97mg+qQ0A5R
         3Ikj3Cg1e6W0kaLu9miTZWiHb9zsHokxrA3qv+mc/lCMvO6k2YOsSQj0EFs1erqLxsGU
         3tJpi1uPKeG7pLmg5VlnYlIpw8x0qWFmi2sg4OydjUAuuqTERt756yyvc0gyoig//M6H
         5fTKOOVxD2iGkXDjRyyWPE5G1u+8j6kSj/3rqzdeuj9Xdr5V2hQG6q1B7q16VMnrsqdk
         zf2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109750; x=1691714550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TPdXiND7N94yuFEwSbECpKkQfmAanLh9RZ+A6BrvR7M=;
        b=c/4RFaBIS7qzSbxGss328K4UbIc1flxjh1F4CEPkb6uVTqZM8Pl8LalgsGkGfXbCVo
         +HTkG4GSQKeNMht0NaGaC2VFK38vZLHKvQHIDW1cqxbPlt6QpokvNnFlXTWljjQFF1xf
         WBjE/p9rqFJh+OSinK2E1NXXRcb9KDbmjtlEH71nENdqE+6B1o3Lf62TOOoAjIGewqZu
         XztYLmzfjgDZgthgoWnAGsfuvkkVlyJucOkNcQ9MSXtQR+0zp/+FRZ5tnl9QotXVxpNQ
         XgH9f/OiBd0sXWk4EcJDSv1COoH9deYUC/ezGehI3x0auN8z3WEbIFZmDMk7Ixqg9xQC
         dRtA==
X-Gm-Message-State: AOJu0Yxvt8pD3y9WYx13GM7CeWysdCOXtHGoWtaQZiDGnPdyp5nJMtHX
	mCBlsE5wuY9d73J58r4nZ3abPskSu/w=
X-Google-Smtp-Source: AGHT+IGxPWjxkWB9Y/JG84vlZ7jPt3zPsnr0k+1ejtlvOppoogL05sX+e7/sQkS50kBaur8MYBj5ozDKMXE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32d2:b0:1b8:5541:9d4d with SMTP id
 i18-20020a17090332d200b001b855419d4dmr1307plr.6.1691109750368; Thu, 03 Aug
 2023 17:42:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Aug 2023 17:42:23 -0700
In-Reply-To: <20230804004226.1984505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230804004226.1984505-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230804004226.1984505-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: selftests: Drop the single-underscore ioctl() helpers
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"

Drop _kvm_ioctl(), _vm_ioctl(), and _vcpu_ioctl(), as they are no longer
used by anything other than the no-underscores variants (and may have
never been used directly).  The single-underscore variants were never
intended to be a "feature", they were a stopgap of sorts to ease the
conversion to pretty printing ioctl() names when reporting errors.

Opportunistically add a comment explaining when to use __KVM_IOCTL_ERROR()
versus KVM_IOCTL_ERROR().  The single-underscore macros were subtly
ensuring that the name of the ioctl() was printed on error, i.e. it's all
too easy to overlook the fact that using __KVM_IOCTL_ERROR() is
intentional.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 42 +++++++++----------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 07732a157ccd..90b7739ca204 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -227,6 +227,13 @@ static inline bool kvm_has_cap(long cap)
 #define __KVM_SYSCALL_ERROR(_name, _ret) \
 	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
 
+/*
+ * Use the "inner", double-underscore macro when reporting errors from within
+ * other macros so that the name of ioctl() and not its literal numeric value
+ * is printed on error.  The "outer" macro is strongly preferred when reporting
+ * errors "directly", i.e. without an additional layer of macros, as it reduces
+ * the probability of passing in the wrong string.
+ */
 #define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
 #define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
 
@@ -239,17 +246,13 @@ static inline bool kvm_has_cap(long cap)
 #define __kvm_ioctl(kvm_fd, cmd, arg)				\
 	kvm_do_ioctl(kvm_fd, cmd, arg)
 
-
-#define _kvm_ioctl(kvm_fd, cmd, name, arg)			\
+#define kvm_ioctl(kvm_fd, cmd, arg)				\
 ({								\
 	int ret = __kvm_ioctl(kvm_fd, cmd, arg);		\
 								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
 })
 
-#define kvm_ioctl(kvm_fd, cmd, arg) \
-	_kvm_ioctl(kvm_fd, cmd, #cmd, arg)
-
 static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 
 #define __vm_ioctl(vm, cmd, arg)				\
@@ -258,16 +261,12 @@ static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 	kvm_do_ioctl((vm)->fd, cmd, arg);			\
 })
 
-#define _vm_ioctl(vm, cmd, name, arg)				\
-({								\
-	int ret = __vm_ioctl(vm, cmd, arg);			\
-								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
-})
-
 #define vm_ioctl(vm, cmd, arg)					\
-	_vm_ioctl(vm, cmd, #cmd, arg)
-
+({								\
+	int ret = __vm_ioctl(vm, cmd, arg);			\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
 
 static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 
@@ -277,15 +276,12 @@ static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 	kvm_do_ioctl((vcpu)->fd, cmd, arg);			\
 })
 
-#define _vcpu_ioctl(vcpu, cmd, name, arg)			\
-({								\
-	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
-								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));	\
-})
-
 #define vcpu_ioctl(vcpu, cmd, arg)				\
-	_vcpu_ioctl(vcpu, cmd, #cmd, arg)
+({								\
+	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
 
 /*
  * Looks up and returns the value corresponding to the capability
-- 
2.41.0.585.gd2178a4bd4-goog

