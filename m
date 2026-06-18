Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75FA2F6911
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797847; cv=none; b=jMYjKry9iBWz1XUwzPIkx53vNkTKgi0YPLEC6VYwb7kJFkYwFtOmgwYlUIpTHL9rf4BGvjYVECQ60egxFYKQ9a5uwpEKJ8bmQmbgCspUVQZXMJ+UeZpZZIr+F3hbqxlPsYCmxUr2mG+f2RD64iDBgJpwk1P7ccMI7P6htdjt2Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797847; c=relaxed/simple;
	bh=bRnY8fOypMVT0Ph5FZZFEtGJVpNYUHCPksvrdnGDBx0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BELUPczOUj6egEyW/tF22nbyg2NpjPK+r6W8+uzzKenOmG0/8P60gDM8MsD732SLLoOIVGpZYRNpn0SfwPzF5yGcLGlDhN6VZR6s20shGOnd5DkWOAUghBQP0B8BJtmh8D+/gCn2avW+z9vK07ybcIFldCJwD4ZoxcGXRNkqXhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=o1q+t7Hm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="o1q+t7Hm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAEF248FF;
	Thu, 18 Jun 2026 08:50:40 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF09C3F62B;
	Thu, 18 Jun 2026 08:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781797845; bh=bRnY8fOypMVT0Ph5FZZFEtGJVpNYUHCPksvrdnGDBx0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=o1q+t7HmdRRj37S2FcuSLCfvyeL4aSjCuajAoerz6VSXKq2wpa/n+ldVnCG5vsyIU
	 qgJWwA8YxDZpVxjwaFdl9/dveiOiBL4Ru2oT1eashH+lsMHHAIL7YDPqj14IZzIZxV
	 MyydYtB+nkLQ2wCwJGb+/iTQ3TLHNkZdPgwPeUeM=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oupton@kernel.org,
	jean-philippe.brucker@arm.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool v2 6/7] util: Allow die_perror() to take a variable list of argument
Date: Thu, 18 Jun 2026 16:50:00 +0100
Message-ID: <20260618155001.226266-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618155001.226266-1-alexandru.elisei@arm.com>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make die_perror() more similar to die() by allowing the user to specify
a format string and arguments.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/util.h |  2 +-
 util/util.c        | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index ac8515f8c46b..a6dba1147d68 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -41,7 +41,7 @@
 #define MAP_ANON_NORESERVE (MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE)
 
 extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
-extern void die_perror(const char *s) NORETURN;
+extern void die_perror(const char *fmt, ...) NORETURN __attribute__((format (printf, 1, 2)));
 extern void pr_err(const char *err, ...) __attribute__((format (printf, 1, 2)));
 extern void pr_warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
 extern void pr_info(const char *err, ...) __attribute__((format (printf, 1, 2)));
diff --git a/util/util.c b/util/util.c
index fc732200f2dc..6f41e2c1b008 100644
--- a/util/util.c
+++ b/util/util.c
@@ -1,6 +1,7 @@
 /*
  * Taken from perf which in turn take it from GIT
  */
+#include <stdio.h>
 
 #include "kvm/util.h"
 
@@ -98,11 +99,23 @@ void __pr_debug(const char *debug, ...)
 	va_end(params);
 }
 
-void die_perror(const char *s)
+void die_perror(const char *fmt, ...)
 {
+	char buf[1024];
+	va_list params;
 	int e = errno;
+	int ret;
+
+	va_start(params, fmt);
+	ret = vsnprintf(buf, sizeof(buf), fmt, params);
+	if (ret < 0) {
+		perror("vsnprintf");
+		buf[0] = '\0';
+	}
+	va_end(params);
 
-	perror(s);
+	errno = e;
+	perror(buf);
 	exit(e);
 }
 
-- 
2.54.0

