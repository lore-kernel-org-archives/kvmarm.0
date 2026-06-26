Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3223BFE31
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509739; cv=none; b=j8Meot6QEwLmZJhtpNvGsyCsRvzPqt0mFlSJKVilvYkI/AN6H6mi8l3R39Nzu3Bgym6AiVKUk100qT0AFX8kO3+g3BiJhR1D/ldtSeSpYqLFSJwAyT+TnuDRlSPg9LidQwAc708indr5QRUNyoMO3psc10IkRqSnWarnyCWFC4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509739; c=relaxed/simple;
	bh=2O0WH3pvR3gLzy2R+GyxwzyDg8G99Zdln+fhYAUluQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YX5UM6tjyrTgTaVrkv/uado5PQJifnZbTUQ98TLsqEM+jXhrT3cV+oj4ocBTStK/JXia0wASkzhtYbRXjcxEpEqjeWRmY0ofBtuaDFql0OSmbv6xQGI9xDV5vBy4W3DuTOS+zTaTxCjiVcG9CxMvjJtm6i8MIy2b9fhYBQ2SpYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KdL3NRXy; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KdL3NRXy"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c80f89b64bso18557345ad.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509738; x=1783114538; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SQrCOvI/gGqY/5lmFouPkrLmKsRGpPhinpGyhSDO7Ek=;
        b=KdL3NRXye+ZQOFuQwcv+DmFSLFyC/OsLLoR0rIdeC6Cz+onx/t2L1hTLjoEcUz65MH
         GBiSP8A5EzEC4JBocUXDW7mioBM7R/UUb1HCyPNMqYZhZmC5xgqNtXP+8fCe2iTdOVdM
         XQje+1wRtUg2YgO7Doqq/6zT4TfSnSwfeSAFlgcgygwwjOCXVZOpg0KpFdenqzdWqBcx
         +4HxjlgJZVju09jzfKboMgUz5Iz1q/qPhhjovs1xGGq8CgUncMNx/x2hGg3+xd7o2FNO
         jfMo7ALuydmfa+xroUMmZgIqOKiMUZzhRXSM1mZmaC930LqoePOZAuZ+IJpcbLPSvTkx
         sRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509738; x=1783114538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SQrCOvI/gGqY/5lmFouPkrLmKsRGpPhinpGyhSDO7Ek=;
        b=WXKehHreur/6nT0Yi0aV8awuh+L+pZ2ExJradYxgOd7JJ9foI3+AMVhnMqwJiyqOIG
         YQJ3Q6i4WO/mvg5LTyKofksFiihYNNe4iTB+E+P9Rjy3HoeHU0LZpMRrLo9AmlX8GDWd
         jpL95wcWLyOFRZZ7LAzj8TkHnXv3yD0yMM93LusIJ948pZLMNjjWL14zxLn3d1n0FiSn
         9ST9Au+8P8xGv+by96PvAuGLKaHfqfUhBhcOXs6nOY/6+PRvWVHS/tQ6lfZ0t3SHBBZU
         DMONTE+SmQ2h+TvQpVd69Klh4Y9Ac1/RySPEaz3p0D+YaA3D1gWbMksi2GdZsUWRRA/A
         7kXQ==
X-Forwarded-Encrypted: i=1; AHgh+RqLyzL8OLAOuSuWYNxptyGsBt7DkG2kC6n8KQS1aYFBaLreC7uYCFUCkmm5hkJvye0I7q4wfI0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWmSDhMuWm+9sEZ9RSeceMupSzwcBgg2lvzhMTCWbsB3AgXYrW
	k85k9F1qJa8PVTlARuxjdoDuudqvl7CZ+xm8U9P/ZNb75h7GQjGVec9fEFR/X7bOoaqb4oSfjuN
	7rdYrhA==
X-Received: from plq11.prod.google.com ([2002:a17:903:2f8b:b0:2c8:17d:91a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2304:b0:2c0:d91d:c3e8
 with SMTP id d9443c01a7336-2c7fc65423emr78308535ad.4.1782509737490; Fri, 26
 Jun 2026 14:35:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:14 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-2-seanjc@google.com>
Subject: [PATCH v8 01/20] KVM: selftests: Build and link selftests/vfio/lib
 into KVM selftests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Include libvfio.mk into the KVM selftests Makefile and link it into all
KVM selftests by adding it to LIBKVM_OBJS.

This lays the groundwork for future changes to utilize VFIO devices to
verify IRQ bypass in KVM selftests.

Note that KVM selftests build their own copy of selftests/vfio/lib and
the resulting object files are placed in $(OUTPUT)/lib. This allows the
KVM and VFIO selftests to apply different CFLAGS when building without
conflicting with each other.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4ace12606e93..ae0dfd67dd31 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -259,6 +259,7 @@ OVERRIDE_TARGETS = 1
 # which causes the environment variable to override the makefile).
 include ../lib.mk
 include ../cgroup/lib/libcgroup.mk
+include ../vfio/lib/libvfio.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -313,7 +314,9 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIBCGROUP_O)
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
+LIBKVM_OBJS += $(LIBCGROUP_O)
+LIBKVM_OBJS += $(LIBVFIO_O)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
 SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
 
-- 
2.55.0.rc0.799.gd6f94ed593-goog

