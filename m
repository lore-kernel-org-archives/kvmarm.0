Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A350B470425
	for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 11:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792235013; cv=none; b=I6kTDAVtUbcTsOV09ECDl14Up4NEpOkHj5y25EnYcC1p/lN/0qY9wSWPmSvfM+TcnGVikyrjd1BGw0Nz8XOQA09abkVbkZ//DsJJPLdL+jrjAeQsbkh5gK6KHMh6qEp3kx5qLyiEyzZmuurBBxuhLHeQ/40zpC/12xPGptFbquY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792235013; c=relaxed/simple;
	bh=7GJpk+Zm7RfMxIWiA/UAYftsuVNurXh/QNUDx1LsL7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5Q8v6/x+mm4ePC/6wH8cLLBBzQNs8wkDB2+hQCxPciKRqo9WAGX57OwbehYp4YprOf3IFX5gcxTqsDHgE6tDHy2UmGttjL++GWm7t5DnQEpw6yt/pQhpiqFTXTWr8kUcgh+qEV5MpsjF8/LQXhMx8ne7QjCoNpK2KxjGMRL9VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFvWBp6g; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFvWBp6g"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e5fb79ce82so3356695ad.0
        for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 04:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792235012; x=1792839812; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tf4fy3DAykjNBLlmTR7a2o12P+Rb24NlY7yvH7wOMkE=;
        b=CFvWBp6ghNWpeSdaW0+tYUgVq/iVgnGl23MgN81uGBfn5J05fjqUSUDyOQJN+leUEO
         hjQT7Dl6XRiIxUDNg3/vKzjinb0wBv+P9Jj/7IdsFe4XLgVdRc4O0y3/yXtt1lMQGue+
         CuV67F20dHfoCYgUPIEa2SVyoBlyn3NEy8DyMrq3agHPnJhlkcHvFAHfEd9QE9q1EFiR
         6AOpNGtYAWsY/rwkyEdSWBW6VgwNuDZriesntu78tBpRuaTXKIBQ5LyQsJ1IXSHSCpYp
         5sLpLyxeOOFqeXm53vubFkmayi5ZEJg+f42tKBDJfBRv4yyLHyTW5e9SJWbo8ODGQrfk
         V4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792235012; x=1792839812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tf4fy3DAykjNBLlmTR7a2o12P+Rb24NlY7yvH7wOMkE=;
        b=K1UwAJC6dfa5VlUepk1eDVHSHh+d1nm/W0j2/XR/89Ct5IqFBovhQGtQ6O0csMBPU5
         grAQKhNjB0DcxIi57Vau06YIqhWR4GFiFeATg8OmBg+5vKCG4U2/qOkz/xAZ/jCJq4pK
         rqzWjzYu+wOaq5ubNdDFgKcztNvzRkEGi76MQVl2jMr5f17XO/GVFdYa+t11vm1sABJ2
         InCweZL74TJBQ/7pRXnjBhKULmvmOfm4diidGzlkfenThWyQUP7gSxuLJuwlAKZp7aYm
         Hz/7aGRO/FF5G90y4fR92+i/oTGt4xlF9OINLHneduM5Zkke1NyYwQ8uNRRhcwaKeDz4
         OOhg==
X-Forwarded-Encrypted: i=1; AKwUvBw5FYNpIP8F8zZtjK15jBT/6VfVYshqa3KrdvPjz706JWy9KT+Ek3R6Bpm+cWivCpDN6eMZNmA=@lists.linux.dev
X-Gm-Message-State: AFq9FYI4zEOdadQwB/P8Acq7QmL29Y1I0ewetBUtc542Ktlk3jm/QWVs
	3XIqOfewX6jaCFk6OuVbbwa2VlgVt0NMbVYyL7e58bP6WO2eKs5rPwtN
X-Gm-Gg: AYBFou2JzDFHetdwNrjFn17qpM+WJ5KeiZC3AHlF0yAkQQUaeATu4fDZVMABubvT6rG
	gOs0WllmmK6+qOgBYN8lx8Go4k+CtO0WaES4NsGu8QSyLNAVGilvH1WXkPtSsE0w64pOqF7YUqk
	vm2NxuOE4BXhPil/GxbfEZmBxRU585w8qq6zvDa2RhsVgeEDZ6nWXBRRyvdH92BlQgbKFz3GYT2
	G5B8OnLErcdrQLxwnlDuId6Inr0TZSya5AJIUjEqM4CdJ70kcAl1sykH5rkORT8GCwvhfgucYPV
	Y88eRFidgYM+WSIb0GvsJpVAJFQdCw2CS6RW5Cz+fUqxRPBHhAmG5QPXxjpqRJpB+VCqnFxFYJl
	qBeX+U/GRewF0K2NLJq0iP5x5jBEisilfc19DSGffa5abNu+bGa8DST7iM8p6e0Bb8bUZI4ZpUo
	zebovaKuwSnMgHXCkS9Ispi2osLNgZDv3MLmFrOpXgjEsm2OUmB+uDkK+lpWU4wi1LpG4ZH/eEM
	VoPiQfzN2XwOkf10d6Vow==
X-Received: by 2002:a17:902:e84c:b0:2e9:6b5b:3db6 with SMTP id d9443c01a7336-2e9a69e93d4mr22504755ad.30.1792235011936;
        Sat, 17 Oct 2026 04:03:31 -0700 (PDT)
Received: from x1c ([2405:9800:b670:b64b:7c65:ff3e:80ba:b06])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e804dd9sm20559955ad.16.2026.10.17.04.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 04:03:31 -0700 (PDT)
From: Tharit Tangkijwanichakul <tharitt97@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>
Subject: [PATCH 5/5] KVM: selftests: Test protection of the ucall MMIO region
Date: Sat, 17 Oct 2026 18:02:13 +0700
Message-ID: <20261017110213.46199-6-tharitt97@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017110213.46199-1-tharitt97@gmail.com>
References: <20261017110213.46199-1-tharitt97@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify that creating a memslot overlapping the ucall MMIO region
fails with EEXIST and that ucalls work before and after the
attempt. Skip when MMIO ucalls or read-only memory are unsupported.

Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/reserved_slot_test.c        | 61 +++++++++++++++++++
 2 files changed, 62 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/reserved_slot_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 1f4bc2a1322d..ff4a5e9733e9 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -68,6 +68,7 @@ TEST_GEN_PROGS_COMMON += set_memory_region_test
 TEST_GEN_PROGS_COMMON += memslot_modification_stress_test
 TEST_GEN_PROGS_COMMON += memslot_perf_test
 TEST_GEN_PROGS_COMMON += vm_types_test
+TEST_GEN_PROGS_COMMON += reserved_slot_test
 
 # Compiled test targets
 TEST_GEN_PROGS_x86 = $(TEST_GEN_PROGS_COMMON)
diff --git a/tools/testing/selftests/kvm/reserved_slot_test.c b/tools/testing/selftests/kvm/reserved_slot_test.c
new file mode 100644
index 000000000000..4a908017ca73
--- /dev/null
+++ b/tools/testing/selftests/kvm/reserved_slot_test.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define CLOBBERED_SLOT		TEST_MEM_SLOT_BASE
+
+static void guest_code(void)
+{
+	GUEST_SYNC(1);
+	GUEST_SYNC(2);
+}
+
+static void test_slot1_protected(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	u32 nr_pages;
+	size_t slot_size;
+	void *slot_mem;
+	int ret;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	nr_pages = vm_adjust_num_guest_pages(vm->mode, 1);
+	slot_size = (size_t)nr_pages * vm->page_size;
+
+	run = vcpu->run;
+	vcpu_run(vcpu);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_MMIO,
+		    "Unexpected exit reason = %u", run->exit_reason);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC && uc.args[1] == 1,
+		    "Expected the first sync before clobbering the ucall GPA");
+
+	slot_mem = kvm_mmap(slot_size, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANONYMOUS, -1);
+	ret = __vm_set_user_memory_region2(vm, CLOBBERED_SLOT, 0,
+					   vm->ucall_mmio_addr, slot_size, slot_mem, 0, 0);
+	TEST_ASSERT(ret == -1 && errno == EEXIST,
+		    "Expected the ucall GPA overlap to be rejected: ret=%d errno=%d",
+		    ret, errno);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_MMIO,
+		    "Unexpected exit reason = %u", run->exit_reason);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC && uc.args[1] == 2,
+		    "Expected the second sync after attempting to clobber the ucall GPA");
+
+	kvm_vm_free(vm);
+	TEST_ASSERT(!munmap(slot_mem, slot_size), "munmap() failed, errno=%d", errno);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(UCALL_EXIT_REASON == KVM_EXIT_MMIO);
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_READONLY_MEM));
+
+	test_slot1_protected();
+	return 0;
+}
-- 
2.53.0

