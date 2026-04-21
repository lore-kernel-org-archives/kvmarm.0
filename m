Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885632C11D5;
	Tue, 21 Apr 2026 09:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776765292; cv=none; b=jYwOVAd9ywYr5kIq/jgmEUIh0zo0ukE7tGK3K9HsltTQcUAU6fJy0xoPHF98i1MI6XnVPKm8E8xnMnTCkxA5rSYj0ULtV3sf5KZw4DTtyxETpJ8ZxOT8lVP0BSa2HGmsJJEmMfbHyEaeBPBwt7aDJ2xlOSrR5qJFhwxSxUqQRTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776765292; c=relaxed/simple;
	bh=005nSr9PcwcpWMrkMnnLw5KzGHpwsyQmbaNI4ETSzOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZuhPTsloM8CfR5p34LhDBnuWVv3fQRtpHo/ISwcpOz/J7sKESFkmDVF3H/LoKHqFy4dH6QACc0vJ8djJv5jxYyueLEnizRESUi6QgW0IckzueP56ahuZXT2V3Duom7mD7P5NMTg4S42cGPyTT+UyXh3cv/ni/JjtjwKtFKit1nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlHQavFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlHQavFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A36C2BCB0;
	Tue, 21 Apr 2026 09:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776765292;
	bh=005nSr9PcwcpWMrkMnnLw5KzGHpwsyQmbaNI4ETSzOI=;
	h=From:To:Cc:Subject:Date:From;
	b=JlHQavFR7vQNlGyJp7mtx9//PUxdrDZHk+LJOVN0FG8mlDMEqmeZP5cFRkyPcA0rt
	 jE1HfcDyVsTc/zWGZdnpnjEyNjblvo3QUO09Xyfi3SoTj6zrIrOboukX+IYtPzjAoY
	 Dcc0YSC5rSCvNVltb6VxhYFCEiZkpIGxOyOZ1qwipAlrAvJJWmvtW31n/Q1D/ydM67
	 fHz1UKyOQ8Nte7Fihp5S5V9Yomdfyb526jt4lUV6p39A77uw5oc1+pQXcJ2BcES8UU
	 WDjL4ZDvmsv6yLTCMtLjZ0KeVrCrFZLjx7d2j2SF4tIzYxiU/CqNpBYG4p7kJ4Aub/
	 mQkZlHXxHACHg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wF7of-0000000DNJ6-3Sf8;
	Tue, 21 Apr 2026 09:54:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] tracing: Make undefsyms_base.c a first-class citizen
Date: Tue, 21 Apr 2026 10:54:46 +0100
Message-ID: <20260421095446.2951646-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, torvalds@linux-foundation.org, pbonzini@redhat.com, vdonnefort@google.com, nathan@kernel.org, rostedt@goodmis.org, arnd@arndb.de
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Linus points out that dumping undefsyms_base.c form the Makefile
is rather ugly, and that a much better course of action would be
to have this file as a first-class citizen in the git tree.

This allows some extra cleanup in the Makefile, and the removal of
the .gitignore file in kernel/trace.

Link: https://lore.kernel.org/r/CAHk-=wieqGd_XKpu8UxDoyADZx8TDe8CF3RmkUXt5N_9t5Pf_w@mail.gmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 kernel/trace/.gitignore       |  1 -
 kernel/trace/Makefile         | 23 -----------------------
 kernel/trace/undefsyms_base.c | 14 ++++++++++++++
 3 files changed, 14 insertions(+), 24 deletions(-)
 delete mode 100644 kernel/trace/.gitignore
 create mode 100644 kernel/trace/undefsyms_base.c

diff --git a/kernel/trace/.gitignore b/kernel/trace/.gitignore
deleted file mode 100644
index 6adbb09d6deb0..0000000000000
--- a/kernel/trace/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-/undefsyms_base.c
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 4d4229e5eec4b..0b0b8f5b9d2bf 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -140,29 +140,6 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
 # undefsyms_base generates a set of compiler and tooling-generated symbols that can
 # safely be ignored for simple_ring_buffer.
 #
-filechk_undefsyms_base = \
-	echo '$(pound)include <linux/atomic.h>'; \
-	echo '$(pound)include <linux/string.h>'; \
-	echo '$(pound)include <asm/page.h>'; \
-	echo 'static char page[PAGE_SIZE] __aligned(PAGE_SIZE);'; \
-	echo 'void undefsyms_base(void *p, int n);'; \
-	echo 'void undefsyms_base(void *p, int n) {'; \
-	echo '	char buffer[256] = { 0 };'; \
-	echo '	u32 u = 0;'; \
-	echo '	memset((char * volatile)page, 8, PAGE_SIZE);'; \
-	echo '	memset((char * volatile)buffer, 8, sizeof(buffer));'; \
-	echo '	memcpy((void * volatile)p, buffer, sizeof(buffer));'; \
-	echo '	cmpxchg((u32 * volatile)&u, 0, 8);'; \
-	echo '	WARN_ON(n == 0xdeadbeef);'; \
-	echo '}'
-
-$(obj)/undefsyms_base.c: FORCE
-	$(call filechk,undefsyms_base)
-
-clean-files += undefsyms_base.c
-
-$(obj)/undefsyms_base.o: $(obj)/undefsyms_base.c
-
 targets += undefsyms_base.o
 
 # Ensure KASAN is enabled to avoid logic that may disable FORTIFY_SOURCE when
diff --git a/kernel/trace/undefsyms_base.c b/kernel/trace/undefsyms_base.c
new file mode 100644
index 0000000000000..3db5adf918cce
--- /dev/null
+++ b/kernel/trace/undefsyms_base.c
@@ -0,0 +1,14 @@
+#include <linux/atomic.h>
+#include <linux/string.h>
+#include <asm/page.h>
+static char page[PAGE_SIZE] __aligned(PAGE_SIZE);
+void undefsyms_base(void *p, int n);
+void undefsyms_base(void *p, int n) {
+	char buffer[256] = { 0 };
+	u32 u = 0;
+	memset((char * volatile)page, 8, PAGE_SIZE);
+	memset((char * volatile)buffer, 8, sizeof(buffer));
+	memcpy((void * volatile)p, buffer, sizeof(buffer));
+	cmpxchg((u32 * volatile)&u, 0, 8);
+	WARN_ON(n == 0xdeadbeef);
+}
-- 
2.47.3

