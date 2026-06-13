Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B774D1F09A5
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310040; cv=none; b=nSiJb9DFPt41PKgahJkvQcpqmgdWFbXO65VqTNpWvOospGDi4Zo3LZWA3asQB981lnDeK3RSULvG3qasoVxBmzBid/kk681Uvp0SCPgqROjNXXpfrGMeVNGTu2cGZn1+skLZUk9h565Enc1v1Cxr1Sve3E9p9KCTZfMbudM93x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310040; c=relaxed/simple;
	bh=2qrP8HGSKX83R6U67UnzcZDXWcrNXLbnx6XraVWtofM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n6PyzlaK8+JgNUExx7PnKBLU0UdXVapvgT/k21N6SozuF53KGVu41yZm6oz7rg7ywQz/MNop3oysmpcSimR+AJF3tkcCEV/DSSgd1ChG2beQ6IpmDIqjxuYBF6BLTYcjvMiek/HRnU1SRdZ6jab+R1O1jIpcQkLTxUd8go6QZpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t8+FvIZI; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t8+FvIZI"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bf32259e0eso19213755ad.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310035; x=1781914835; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/Iw6k9IvS6YCS0467Ck1NDjfIZOkbT+wEKpbw8XzGD0=;
        b=t8+FvIZIfTIeoAR25TRk1KfBq74FpwN+WVD+jpy7q/1UUpVJIZtSHvv7/c3KCsh3Rw
         Ka45Ohn6R7fpGmAsK+r7n49xbQ3FResdKbothz6lodbUos2XNqzbLvtM0aqcKJxwnrT9
         V/aYmj6n4uJpnpZ4XAeR0BzEfUUuSZMqfVLxa09gF7uby0bMxPEIVWJXWLjtZmWRprKu
         0LVTx1ToVqsY/rjoreihCdWiNBA3mveqmFE9nBCfjFf5esPrHtXEwmjf7FztbyV7oEwR
         blCIDj2TJs74slw8R1Yz4QTKcFOwBw96ZGun8xUAGnvVpFvUAWMRY4bfkPMNLIM++CWr
         mP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310035; x=1781914835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Iw6k9IvS6YCS0467Ck1NDjfIZOkbT+wEKpbw8XzGD0=;
        b=JopJu7RLZpL/HD4CDyYTZzoLsPX9Kqan8h/XEJlj3piul1xxLJrcTpge0F+V0Q+jYH
         04mL9uEhg4KhmXmQUmooXyCx2Yg7RMoAoMM+Dhm6DnN3+yupKEYHGM6vljZur2z7nH5O
         JPfpuHBpFv5eskeKcD7t+CFoddR57PNbDVN6vmXLTYdzvWzjz+NUciBE3Bfy122H1fbP
         40z/UpANCk4uwSFVLMk7HwDKZtf193vl8YnrPFwlwHAP/ulWahUidZDnYOi8DolMM2hE
         zPuAS5b2na95PpERAbxPIu8sRl4zHUW9M36yGBqZdRMBlnRSX6RAozWzZoHD4t0TVhn8
         82rw==
X-Forwarded-Encrypted: i=1; AFNElJ/R1LThGcDc/62KBoAcuys7mfBZaHf/zevkLNthivrUVWzENzBUvLIKN+qgEmBQC4dj5qn0KJo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxydyDlMRZ24dlj/FRqrXbfVqqz4GChVn3ZmNkr8fZ3NMVmSIgj
	u6OqrQGGCn+LApld45qcijuQWHxIEyFW4BnTNzJHiEA1e+HbSvxHSgt7Jd/bmMIhIrvuyxUf2nG
	Xv9kgJQ==
X-Received: from plbmf15.prod.google.com ([2002:a17:902:fc8f:b0:2bf:14c9:866d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea07:b0:2c0:d91d:c3e8
 with SMTP id d9443c01a7336-2c41050b2aamr61506165ad.4.1781310034931; Fri, 12
 Jun 2026 17:20:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:12 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-2-seanjc@google.com>
Subject: [PATCH v7 01/20] KVM: selftests: Build and link selftests/vfio/lib
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
index 9462919d2660..59ec232b1e93 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -258,6 +258,7 @@ OVERRIDE_TARGETS = 1
 # which causes the environment variable to override the makefile).
 include ../lib.mk
 include ../cgroup/lib/libcgroup.mk
+include ../vfio/lib/libvfio.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -312,7 +313,9 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
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
2.54.0.1136.gdb2ca164c4-goog

