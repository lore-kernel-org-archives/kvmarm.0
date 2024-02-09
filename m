Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFE566B50
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 09:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469959; cv=none; b=eQVly6DDPO1TLqC4mRMN4aFol6RQ4QU7Dk2MICI9X8J3Jr/W1BzPVgW2SssW5ciyYldQTgUarAVrYNafYPgS6bvERn7s5Xd8nPCNwAoXtF1cz3pwpzMobjYRuubI7jgMuNbIideJnZek6a/HWXYTWyh95W60GBiXFJDrc844e1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469959; c=relaxed/simple;
	bh=3h89rZxZOC2oNaGXb+xtrg1aGJu/Sq2hVnRS+W6GlNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRgnDjEX2G1hh+uxgtyBGk0A1notuXu2ak/7jqLYH8AMS4twE0DsEsPmm5QufsKBMVPupeNy9nKCurk+tHGagmFju2lxL8BinDopoo0Q60djZeVfBh3XAIEln0ZJiHnFHMXoNNkEKXFQ4ItZpGinOSFkgy4tF61NHHH3d6g4Avk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRozVjzp; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRozVjzp"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3bbbc6e51d0so402793b6e.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 01:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469957; x=1708074757; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+AksW/xWOBo9VmX/69t4hhS8qRPramQT9Z7Ypigl0WA=;
        b=YRozVjzpvRwuv3AN1hUxyesXxWyUj8zsieA1JPFnWdY51MmO8Yvf8Q6cyhCGBSfyLa
         KyVfLErmK+XgEIMHNz/SrL+HWuks8k0bI99r0XT6KhFxSBFBPXxIs/tkldzAZHpwynbM
         jhbAJnWP8C0ZUGkWkdahduGhbaY7n0ko9WOYLZw7OL6fAa9RR1czoQZwECO3j5bHHc80
         +mcB019L/aqYHe9DzFirwiHQ2LTPnzLTzseKBDLxdN0A/7bVovnzUj014d9eBI2OEu0e
         OLqdp6ZE+mqwtzpGrrCVVOHhXCHd7NZItNNwksr7CrIfy5hX9gdQQ8BpWpkB9U7XsXQ9
         QXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469957; x=1708074757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+AksW/xWOBo9VmX/69t4hhS8qRPramQT9Z7Ypigl0WA=;
        b=Vrw0ptcwesAju8J0X1M+w0KZ5VoW/afzhkOafMZ+4Fayd3hmrwDdCpJJy5fu7pT+qN
         N2W7tOkEMq180J5IeieGPjRX6af11xinnk67pdYEuieKHtTsiSVItFkJ6faF0ZaaBoES
         /3O3m1cIb6E0IYR8OqJ9ZvfPoW9kPPFLctEBgG1mzZSY7+5Y4Ukc5EFcRdUqsyLjc8ww
         ZHCD6Ck2wDNiaXCVPcMVTetbROXp8AMftUhJceHEk7FiQZvZqzUj0IcseoHIVsxFY9tl
         aQndRgkPrsDgbR9CdXLPwIGe66GwvA5VP9u097yzOmLJwFiRC6JmBgxKBbulAGB1UMfG
         2KzQ==
X-Gm-Message-State: AOJu0YwMfGsSsVC1fn+nkEhaEdlpneLIgmpP6VHilQC+5penfo5kVl6I
	sJtsrLbCpitwiOu1w51uUq6yLGTPj+18r+l9ZtaFiwXLIw1b12MO
X-Google-Smtp-Source: AGHT+IEIHO/U6QjmJfygHFclXfxV0lUCeX5heQt+eUUVJ/hovB7xrXAgLx955AGicKrmFgk9n+BoKA==
X-Received: by 2002:a05:6808:2817:b0:3be:cdbd:5dd7 with SMTP id et23-20020a056808281700b003becdbd5dd7mr1020153oib.22.1707469956625;
        Fri, 09 Feb 2024 01:12:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVs4qVmLOg72KKuZcMy0BE7Ki258JyQKnchF94kWsJQhod9hUbwO0sAGfTmMkyPrrASwCq0D7tUe5yFIAgzO0TOZ3vHCBifsKHRhuln+uNTcU+E45AxYikhLN7WqNQA6kX0nJ1Mbk27Y3aPc8w0m3399xZKJKl4XgbLyCLXV6jdDt1jpJ1QrPjWfyx7OqDsM6kaSBg0zg6uHz/XNevzHcASmYePg5PlIFEqNew4wpWP4qHByjifIlUvbHfyZuHQdH8bcMLApowIbtbCpx9aSZ+2XpUdMAK3R/0FOQDsioy1JOYXZ8uQWSP5cJsmKg2QeSOfnxGt0iLNh0TcbTptf/op/dJkSilKsNT+sTB7czY0E+VkAViH4lfRfms072VbOoZ+zZXmVSsj0FCbqa7W7fO04f0u4e3GXuVizAvcjV/vKj3EMfWKOYbqKYB4z7wgxtwuqc1PrAMTIBhE09BejP9g6tlkYJzaPnRlSfJ5KHqlbElD0nn7ErsWzL+IhYYP3BHs6vh1wM+5kKO9rzOxxxnaqzwvTSJ1ZDtr4fqczCevhxa41nBzhKqi
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:12:36 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v4 7/8] Add common/ directory for architecture-independent tests
Date: Fri,  9 Feb 2024 19:11:33 +1000
Message-ID: <20240209091134.600228-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209091134.600228-1-npiggin@gmail.com>
References: <20240209091134.600228-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

x86/sieve.c is used by s390x, arm, and riscv via symbolic link. Make a
new directory common/ for architecture-independent tests and move
sieve.c here.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/sieve.c    |  2 +-
 common/sieve.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 riscv/sieve.c  |  2 +-
 s390x/sieve.c  |  2 +-
 x86/sieve.c    | 52 +-------------------------------------------------
 5 files changed, 55 insertions(+), 54 deletions(-)
 create mode 100644 common/sieve.c
 mode change 100644 => 120000 x86/sieve.c

diff --git a/arm/sieve.c b/arm/sieve.c
index 8f14a5c3..fe299f30 120000
--- a/arm/sieve.c
+++ b/arm/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/common/sieve.c b/common/sieve.c
new file mode 100644
index 00000000..8150f2d9
--- /dev/null
+++ b/common/sieve.c
@@ -0,0 +1,51 @@
+#include "alloc.h"
+#include "libcflat.h"
+
+static int sieve(char* data, int size)
+{
+    int i, j, r = 0;
+
+    for (i = 0; i < size; ++i)
+	data[i] = 1;
+
+    data[0] = data[1] = 0;
+
+    for (i = 2; i < size; ++i)
+	if (data[i]) {
+	    ++r;
+	    for (j = i*2; j < size; j += i)
+		data[j] = 0;
+	}
+    return r;
+}
+
+static void test_sieve(const char *msg, char *data, int size)
+{
+    int r;
+
+    printf("%s:", msg);
+    r = sieve(data, size);
+    printf("%d out of %d\n", r, size);
+}
+
+#define STATIC_SIZE 1000000
+#define VSIZE 100000000
+char static_data[STATIC_SIZE];
+
+int main(void)
+{
+    void *v;
+    int i;
+
+    printf("starting sieve\n");
+    test_sieve("static", static_data, STATIC_SIZE);
+    setup_vm();
+    test_sieve("mapped", static_data, STATIC_SIZE);
+    for (i = 0; i < 3; ++i) {
+	v = malloc(VSIZE);
+	test_sieve("virtual", v, VSIZE);
+	free(v);
+    }
+
+    return 0;
+}
diff --git a/riscv/sieve.c b/riscv/sieve.c
index 8f14a5c3..fe299f30 120000
--- a/riscv/sieve.c
+++ b/riscv/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/s390x/sieve.c b/s390x/sieve.c
index 8f14a5c3..fe299f30 120000
--- a/s390x/sieve.c
+++ b/s390x/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/x86/sieve.c b/x86/sieve.c
deleted file mode 100644
index 8150f2d9..00000000
--- a/x86/sieve.c
+++ /dev/null
@@ -1,51 +0,0 @@
-#include "alloc.h"
-#include "libcflat.h"
-
-static int sieve(char* data, int size)
-{
-    int i, j, r = 0;
-
-    for (i = 0; i < size; ++i)
-	data[i] = 1;
-
-    data[0] = data[1] = 0;
-
-    for (i = 2; i < size; ++i)
-	if (data[i]) {
-	    ++r;
-	    for (j = i*2; j < size; j += i)
-		data[j] = 0;
-	}
-    return r;
-}
-
-static void test_sieve(const char *msg, char *data, int size)
-{
-    int r;
-
-    printf("%s:", msg);
-    r = sieve(data, size);
-    printf("%d out of %d\n", r, size);
-}
-
-#define STATIC_SIZE 1000000
-#define VSIZE 100000000
-char static_data[STATIC_SIZE];
-
-int main(void)
-{
-    void *v;
-    int i;
-
-    printf("starting sieve\n");
-    test_sieve("static", static_data, STATIC_SIZE);
-    setup_vm();
-    test_sieve("mapped", static_data, STATIC_SIZE);
-    for (i = 0; i < 3; ++i) {
-	v = malloc(VSIZE);
-	test_sieve("virtual", v, VSIZE);
-	free(v);
-    }
-
-    return 0;
-}
diff --git a/x86/sieve.c b/x86/sieve.c
new file mode 120000
index 00000000..fe299f30
--- /dev/null
+++ b/x86/sieve.c
@@ -0,0 +1 @@
+../common/sieve.c
\ No newline at end of file
-- 
2.42.0

