Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9941CA9A
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 14:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279016; cv=none; b=TeljRe96XWZXJj+0v/bjiix4Qee7fvSzgD0HpX2rYLm5nYC2wdr2SG3jv3xfEKEj5T/Ifwua+kSM83RJZfywEdgX7Cy3iA1UEekiMYZQXBAuEELG7DVI+/c6ppSIM68IjV+xoab0VnMmZdKic7QxaW1dJYS3z3c4tjQqW39bpI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279016; c=relaxed/simple;
	bh=QCrPmjYKyQurleHrqc0OW3NYMBB2h6Lj/T6vf83FNt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=snsiHQhXfIXwesuH6THZE6pRUBUn0xsy+X5hXvCsqDuqRKpbbtgzoZZUi/6JSxd29m2P/4dEA6Qo7h15z+xJK2J2igCWU0Rrd/01+OmMiKLd8LqT17Q98vtGEBoa3PiZdnY45V5voQV9Li2RJNEXFMlCE/hC2M05yKhx3ih+E6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s5DMnhRA; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s5DMnhRA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oGYFysMzf0klE0neQcv/RC548uW/mU4O4DCCVaYd5JE=;
	b=s5DMnhRApLbXGPc/Fwp+w20sfgAykxQQhFikFfoIT7JvLE78y+p7BtSnpb3af2FUiTxTYO
	k/gqOu6PjTQJIe6RYVmYANsJ5Em1YhaxVGHsKFlsntjV5b2zHOxddjnP0Jqm2XUqOZ+edq
	FSEQER20kzZ0+8K5ww6+p1qIikwcWSc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 01/24] configure: Add ARCH_LIBDIR
Date: Fri, 26 Jan 2024 15:23:26 +0100
Message-ID: <20240126142324.66674-27-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Prepare for an architecture which will share the same lib/$ARCH
directory, but be configured with different arch names for different
bit widths, i.e. riscv32 -> lib/riscv and riscv64 -> lib/riscv.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 Makefile  | 2 +-
 configure | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 602910dda11b..4f35fffc685b 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ include config.mak
 VPATH = $(SRCDIR)
 
 libdirs-get = $(shell [ -d "lib/$(1)" ] && echo "lib/$(1) lib/$(1)/asm")
-ARCH_LIBDIRS := $(call libdirs-get,$(ARCH)) $(call libdirs-get,$(TEST_DIR))
+ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR)) $(call libdirs-get,$(TEST_DIR))
 OBJDIRS := $(ARCH_LIBDIRS)
 
 DESTDIR := $(PREFIX)/share/kvm-unit-tests/
diff --git a/configure b/configure
index 6ee9b27a6af2..ada6512702a1 100755
--- a/configure
+++ b/configure
@@ -198,6 +198,7 @@ fi
 arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
+arch_libdir=$arch
 
 if [ -z "$target" ]; then
     target="qemu"
@@ -391,6 +392,7 @@ PREFIX=$prefix
 HOST=$host
 ARCH=$arch
 ARCH_NAME=$arch_name
+ARCH_LIBDIR=$arch_libdir
 PROCESSOR=$processor
 CC=$cross_prefix$cc
 CFLAGS=$cflags
-- 
2.43.0

