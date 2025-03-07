Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7781AB6F1
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 09:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741339115; cv=none; b=DmI4UOalMn+Vt2nbT1/bjGdyrwSAY4FfKhhKinyQP9BrafFHdbBm7rmVlnKyxVb/KRZGMTxGj6AIALN08v85MBNzd0RhxytY9L/syER2BykrbOei0Syp70svYJt7W2uKK3bvINmLxpGqrSJnmkHTmN/VLP1jWj3RpHCI682HcLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741339115; c=relaxed/simple;
	bh=bOIKtdlaOQMqgV6ghEveRdhfkbyzwmHzV3cRNq2qtcc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Uaq/9/4nUh9+jpMSu4qI+jW6jjovLiNho+g4rOoIPFUc1RmY7pcuZmBTJXGxugMOCnAwJsHNms15LZnl+b3LNwIoKtZtpnB7oJNGuxM2VVdCi3sz/d5VV0ZFcbXBacVjBCHFOFLiENezzyVPy5Pz0aqtbjS91d5kjExP3A5O3f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v/um14Qj; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v/um14Qj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741339111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y2FBvybRQ7hGNDuactnNvnWlcdQr0dcjdCw8K+WSDT8=;
	b=v/um14QjntUhD9/+RjAPoAqg5hVIFWfCDpaGuI3rZaVkVpnzjZ4cpDc2xZ3mkeysr6W9z2
	xbw+4yumPwu7bH4NmlPTKPqXmnDnAh2JsHoY5L/yMVAZYEQMBt0P+TSM4mxRcP6MI3jdoT
	lkxLHe4Zyn/2jMILuyMorKlQiFsHWWQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2] Makefile: Use CFLAGS in cc-option
Date: Fri,  7 Mar 2025 10:18:29 +0100
Message-ID: <20250307091828.57933-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When cross compiling with clang we need to specify the target in
CFLAGS and cc-option will fail to recognize target-specific options
without it. Add CFLAGS to the CC invocation in cc-option.

The introduction of the realmode_bits variable is necessary to
avoid make failing to build x86 due to CFLAGS referencing itself.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
v2:
 - Fixed x86 builds with the realmode_bits variable

 Makefile            | 2 +-
 x86/Makefile.common | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 78352fced9d4..9dc5d2234e2a 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,7 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
 
 # cc-option
 # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
-cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
+cc-option = $(shell if $(CC) $(CFLAGS) -Werror $(1) -S -o /dev/null -xc /dev/null \
               > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
 
 libcflat := lib/libcflat.a
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 0b7f35c8de85..e97464912e28 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -98,6 +98,7 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
 ifneq ($(CONFIG_EFI),y)
 tests-common += $(TEST_DIR)/realmode.$(exe) \
 		$(TEST_DIR)/la57.$(exe)
+realmode_bits := $(if $(call cc-option,-m16,""),16,32)
 endif
 
 test_cases: $(tests-common) $(tests)
@@ -108,7 +109,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
 	$(LD) -m elf_i386 -nostdlib -o $@ \
 	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
-$(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
+$(TEST_DIR)/realmode.o: bits = $(realmode_bits)
 
 $(TEST_DIR)/access_test.$(bin): $(TEST_DIR)/access.o
 
-- 
2.48.1

