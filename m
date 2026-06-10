Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456D41F872D
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052825; cv=none; b=f9fi/xRmJ+EoDbXz4XUEOwj3S2EduKj20ZOLMY1WjMaSxMlQvTYIHXFychIFDMFNXd+9NO0d+oEzJdTtPFWSszdT8Nrigfvs4pFORhUqXQ1KK6ELnx1ZnARP/0OMLApQ0GQ3/mKdTPeFgjXe/lBKOHooPQSOCLLCbOxdpPSMyv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052825; c=relaxed/simple;
	bh=ZICe4hE+bdgo/mmBoriJdsV7FkTThoAxxO0XvehbVwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YF96A6v/r32VLlqD0EYWHD44Rieab/vm6ocEgv+mhMqFrD1Tku4GNn5juNtAJJDFD8s992DbJ3J7S8pM151MbqZtPTnB+QRFMTsAzwVZoIqA42t/KPr3x4q/4d3xJpUUDpKFY6lw3hkRskhqI+ij+DfLNDvJnMOGWehnoYTn7Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=axALYQtW; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="axALYQtW"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c8584e80bfcso2667383a12.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052822; x=1781657622; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=E3dsDf1mwPqE6CLqG/GF7U0hvBMIyZSe2b/ARirZzXU=;
        b=axALYQtWoDRO7T3ulLDbC0D2sgNAbO0Pzqmrdb31Qi6anUfVSbVmGd7/PVDjVQGds6
         YJ2qq3CeiY7cyXrq0VAnkgGFMHvAwAKcExnvo26W0+NZdI/kI2bEL5xWzKJheDIQ95ge
         gvIDhNivQ966yV5TvXAl02uOxhCCwiWMhVAtJnhicuHE+q6sC/2NoyN4fQK/QSECgZJo
         +JyrJOQktbyCyAw1ggm42DtCYB/LC3ooABh3uqEqA20alkoc5XvskTWU5c1g/SrKY0uh
         S5cNiCrhoD3so2XlneFvPNelFtou9QEIorMsnjgL5dKHxazDDOXiFNl5zHx/70wpzDgy
         Q5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052823; x=1781657623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E3dsDf1mwPqE6CLqG/GF7U0hvBMIyZSe2b/ARirZzXU=;
        b=Z3GMrs9aiYsi7hhgWJA81nRivPyadspPWFTNkc4NgAEuLl1el0TK5/qgHCc94303tx
         neMSJwhH8NG0DilMX0nBpsSkgtr60/m+dH7I8lgH0Q+KCTqmRE5dchlbnCNxT2UlooCD
         LXO9y2LSkgYclAaUcc4X6jRZtv+JKYqZPf5nvPJtSVyh0OD/ldwQEEpocmqLKBpqr/f7
         12JavcZgfXX5Xn1g73R4fZ4JprzVQpjYiD6QalNzb4ln1iZw8IgqTXL9GZTZ+45gyut8
         H7QqXArxfSqNk5I1LzBqrUUDbLOf/j/HkjMtwJVNKurJKS7i0VH1t0mHtbo6Z+kJCChy
         O5Ig==
X-Forwarded-Encrypted: i=1; AFNElJ9nS+os/TK97P1s6LFdU9qUdS2GAKcQNRdbCOls0oYaAVLc5KaMAHX8Jtxy7TYLWW+O7fNeI1Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQcuy9pEQmx4PKsF4INU8qkLDIr7PQSU7zCdU6sLUynto9EI07
	zc/KPThHVinlxnOcjYWu7xRnnv3qOwUwPes6nO8A7OGXTJXsSUk/TLxqj77RxCEsIhJAMPaYywO
	SxXLX1Q==
X-Received: from pgwa8.prod.google.com ([2002:a65:6548:0:b0:c86:2164:9671])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:b87:b0:3b4:8268:23e8
 with SMTP id adf61e73a8af0-3b4ccdf102dmr28032201637.21.1781052822397; Tue, 09
 Jun 2026 17:53:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:21 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-2-seanjc@google.com>
Subject: [PATCH v6 01/18] KVM: selftests: Build and link selftests/vfio/lib
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
index e0ddd3ff9472..14316358fd9f 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -257,6 +257,7 @@ OVERRIDE_TARGETS = 1
 # which causes the environment variable to override the makefile).
 include ../lib.mk
 include ../cgroup/lib/libcgroup.mk
+include ../vfio/lib/libvfio.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -311,7 +312,9 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
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
2.54.0.1099.g489fc7bff1-goog

