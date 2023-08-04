Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F13DA3B
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 00:42:33 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-58667d06607so16813727b3.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Aug 2023 17:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691109752; x=1691714552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zoisc0YB1XdzgL3Mform49pg3ZfKIVNUNR7ICgYhzqE=;
        b=a4GYzzIGruxXUnQRulR7Q7xPVPhglwcMI8dSt+2D0nS1HKiyVkOdEdTA22kHKgAdy0
         HTMrJvInhxVscUAT2jGAxD6GjetlDBEEjRbs5tgpCurFNtDO9srlbkGATO8A+j84QHPn
         LpTXCF+c1pA439z77TTyZdsi633JbNMsRox+apr+ntnTHhKnkysLOKyzwZ5Q5pXp59tr
         gtO1qSFLzwPBSFZOp5ceRlT+y/Fr2xvWXpQcJIcBI/Eu/Nnf77Qul2yHoNvPK84le3qc
         yZvzpyWSa2x/ElmpM+L8ZLi/IuMFNTuqvQUk6U2py9hi+gOnewe10HzpDZCYVmiCJipg
         Lt6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691109752; x=1691714552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zoisc0YB1XdzgL3Mform49pg3ZfKIVNUNR7ICgYhzqE=;
        b=f48ZZ8SOiUkgmR9smabrQclIwSq+eo4BaMqHC62Nkv0Dg0qjt4LEgea6q8bL2+sw/8
         Fg9TBJUDwTo8gomWpM5Te5mr0ahwEqRPd9Er1tFBfkx4vPxWjJei3KrtKXKoSDKtGJzA
         iwcNosHzb9xMSYUNHpWdF4B4w5yKFmqhVgFKD6cJo+n45O8FXIPRSk3YJgWfF2ggKHld
         d2tDBB3K4ieZTAO/Ar6WCkNAllk7ZAWoYhqQ0eyNi9bbKDn2BX1K2/1qXcWFguquS6k3
         DYy62jQtGi7BZ1JQg6hRItG4lRDgEoyBcAgttpdenC+49OMyDvTq/ycUOrkxZE7OBYmZ
         Iueg==
X-Gm-Message-State: AOJu0Yycv5FI0iRPtNEAdJex0THDXhlWAyHx2TAHEoDtBs2mAdU1MEvj
	j2D338NYESr4WYa5CjvsOnEp4Eg0AT4=
X-Google-Smtp-Source: AGHT+IEfIKaAO5uExbgPzBO0tfQZFXdYU8siIO4abEpJQBk+sr472KYhvYCdgm115nWDgEKOGaiceaxOXk0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad04:0:b0:583:6f04:4267 with SMTP id
 l4-20020a81ad04000000b005836f044267mr1388ywh.8.1691109752403; Thu, 03 Aug
 2023 17:42:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Aug 2023 17:42:24 -0700
In-Reply-To: <20230804004226.1984505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230804004226.1984505-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230804004226.1984505-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: selftests: Add helper macros for ioctl()s that
 return file descriptors
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"

Add KVM, VM, and vCPU scoped helpers for ioctl()s that return file
descriptors, i.e. deduplicate code for asserting success on ioctls() for
which a positive return value, not just zero, is considered success.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 39 +++++++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 17 ++++----
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 90b7739ca204..b35b0bd23683 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -253,6 +253,14 @@ static inline bool kvm_has_cap(long cap)
 	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
 })
 
+#define kvm_fd_ioctl(kvm_fd, cmd, arg)				\
+({								\
+	int fd = __kvm_ioctl(kvm_fd, cmd, arg);			\
+								\
+	TEST_ASSERT(fd >= 0, __KVM_IOCTL_ERROR(#cmd, fd));	\
+	fd;							\
+})
+
 static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 
 #define __vm_ioctl(vm, cmd, arg)				\
@@ -268,6 +276,14 @@ static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
 	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
 })
 
+#define vm_fd_ioctl(vm, cmd, arg)				\
+({								\
+	int fd = __vm_ioctl(vm, cmd, arg);			\
+								\
+	TEST_ASSERT(fd >= 0, __KVM_IOCTL_ERROR(#cmd, fd));	\
+	fd;							\
+})
+
 static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 
 #define __vcpu_ioctl(vcpu, cmd, arg)				\
@@ -283,16 +299,21 @@ static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
 })
 
+#define vcpu_fd_ioctl(vcpu, cmd, arg)				\
+({								\
+	int fd = __vcpu_ioctl(vcpu, cmd, arg);			\
+								\
+	TEST_ASSERT(fd >= 0, __KVM_IOCTL_ERROR(#cmd, fd));	\
+	fd;							\
+})
+
 /*
  * Looks up and returns the value corresponding to the capability
  * (KVM_CAP_*) given by cap.
  */
 static inline int vm_check_cap(struct kvm_vm *vm, long cap)
 {
-	int ret =  __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)cap);
-
-	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_CHECK_EXTENSION, ret));
-	return ret;
+	return vm_fd_ioctl(vm, KVM_CHECK_EXTENSION, (void *)cap);
 }
 
 static inline int __vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
@@ -348,10 +369,7 @@ static inline uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
 
 static inline int vm_get_stats_fd(struct kvm_vm *vm)
 {
-	int fd = __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
-
-	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_GET_STATS_FD, fd));
-	return fd;
+	return vm_fd_ioctl(vm, KVM_GET_STATS_FD, NULL);
 }
 
 static inline void read_stats_header(int stats_fd, struct kvm_stats_header *header)
@@ -558,10 +576,7 @@ static inline void vcpu_nested_state_set(struct kvm_vcpu *vcpu,
 #endif
 static inline int vcpu_get_stats_fd(struct kvm_vcpu *vcpu)
 {
-	int fd = __vcpu_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
-
-	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_GET_STATS_FD, fd));
-	return fd;
+	return vcpu_fd_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
 }
 
 int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..557de1d26f10 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -117,8 +117,12 @@ unsigned int kvm_check_cap(long cap)
 	int kvm_fd;
 
 	kvm_fd = open_kvm_dev_path_or_exit();
-	ret = __kvm_ioctl(kvm_fd, KVM_CHECK_EXTENSION, (void *)cap);
-	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_CHECK_EXTENSION, ret));
+
+	/*
+	 * KVM_CHECK_EXTENSION doesn't return a file descriptor, but the
+	 * semantics are the same: a negative value is considered a failure.
+	 */
+	ret = kvm_fd_ioctl(kvm_fd, KVM_CHECK_EXTENSION, (void *)cap);
 
 	close(kvm_fd);
 
@@ -136,12 +140,10 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 
 static void vm_open(struct kvm_vm *vm)
 {
-	vm->kvm_fd = _open_kvm_dev_path_or_exit(O_RDWR);
-
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_IMMEDIATE_EXIT));
 
-	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, (void *)vm->type);
-	TEST_ASSERT(vm->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm->fd));
+	vm->kvm_fd = _open_kvm_dev_path_or_exit(O_RDWR);
+	vm->fd = kvm_fd_ioctl(vm->kvm_fd, KVM_CREATE_VM, (void *)vm->type);
 }
 
 const char *vm_guest_mode_string(uint32_t i)
@@ -1226,8 +1228,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 
 	vcpu->vm = vm;
 	vcpu->id = vcpu_id;
-	vcpu->fd = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpu_id);
-	TEST_ASSERT(vcpu->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu->fd));
+	vcpu->fd = vm_fd_ioctl(vm, KVM_CREATE_VCPU, (void *)(unsigned long)vcpu_id);
 
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->run), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
-- 
2.41.0.585.gd2178a4bd4-goog

