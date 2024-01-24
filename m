Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2A715AD0
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 07:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080704; cv=none; b=P0+geu6W78JzCdWAOeQ4Hcnltq/BzlsKDki8H4bXmaBn22I3jQLTG5rB0LsSurzUM3FnCcDKy+rnkx7hxpcxYiuavLl0f8b/RejlBn5dywIsjwPtq2OMAsplEWUMUjHhA1XtbHq9Jk+k4o3ksQJzimepy5cChVmGjdB3G4mWdXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080704; c=relaxed/simple;
	bh=TvGKx9PE2LQdflzahykhmmXUwwV2LOK32mU9wl4ebHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Y/8cXbAAa9TTxD4VdcHkttb2JNvwXRMIz3PtBKvVBQDhAqETWSP4TlMFft1ZAdS05sMW9vVfvg6Jm0pkPFKtBDAjIVT7QURkDDbnyKfjkh/ld3V9QbKsFeem0J98AhvP1vcHG2RkVjeB9qiQoHqsjhNmJdwlzlVtJmam7pkIw8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g1Q8JVsO; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g1Q8JVsO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=56+6YuwH1pajygwgjPeWEPkIUwB4yHAcEZLlPxo6Nbo=;
	b=g1Q8JVsOQ5fY2nyMvkaYZeQiDExELvpZlvTvfSyzASQqfOsnXj+Le5jRXO1zjDhGqQMnvF
	oDQAqOsHr2dEzUWrIb0PHmXiwbzQT1/nYsD3VO8jzMCo34HmjMKe/OS7QNNEdpJyY5DW1l
	ht5o7X7FdtWCngGhw8nBrh7TxvCX5hc=
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
Subject: [kvm-unit-tests PATCH 01/24] configure: Add ARCH_LIBDIR
Date: Wed, 24 Jan 2024 08:18:17 +0100
Message-ID: <20240124071815.6898-27-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
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

