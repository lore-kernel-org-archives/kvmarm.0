Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D7C23C9
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 03:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486152; cv=none; b=n+Vwnh54HOqIQl744CkmZCnmXU6EVF2NN94eYY3uKeliKmq42R6WCGrpu9MLHYi/x8Ft3pPaOaZdV82HRG2Ps5pUtTlMZxVxD4yRmuRPU6IFzT0qzrdIUsE6YFjM+pQaK6r1Vtc8lSDRZxKdxuUqHsRnuwFLFyDF6vpBXPfxy1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486152; c=relaxed/simple;
	bh=lE4WrwkyDtaQgF2D2jO1Cwot422cIfXq3YZMhla4BRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOns7qKaJHZw2zMGifNyWYsFws0QZed1u0oyZGZOJeY6g08PX5+Nh4eAJiR+/wP+sXuKYOrYJ8kJl9D1qV2EgqUtFwmgBgQUqsFeDYp6jaK8vMYzvlZOrnn2K8bMJINQW+H4jNaQiP+SmEyNfSgYz731T0J2zRgQlacbVTxNR1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZHxzQlr; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZHxzQlr"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e46db0cf82so127946b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 19:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486150; x=1709090950; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuBjCwoeaNr8AGy/7SQu2RQwLY1MBjVxyn5YkQsjDDI=;
        b=JZHxzQlrWDr3xDJ+gschAz5hwLx95666mgEirrITE/iu46DoPbLbBNZAz7df5vru8B
         hp3+ag3W8895ze4MUcSlMSC9au6J3o5imW4ruPQ6yfAgur8IifkEDGzclEojLcIqQDQd
         wqIwexufXNCRJ7Pzt1vN0nmH/P+wKHmm3eiTHMdpZOY28AgI+kKetCQB434xMsgd1jZm
         jRDrDfrOvrrfYwb5g10hggJCAF5LbNKIW3ej5d9KXpx0jx9GjunYybHyudLL0Ee1tLfH
         8/+MBVIMCkSOZXK5RiXZuj/P5zC2NXrybiOtQ53OAVVFTWCpvoYPhYoOu/lnqE1uVEYn
         rLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486150; x=1709090950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nuBjCwoeaNr8AGy/7SQu2RQwLY1MBjVxyn5YkQsjDDI=;
        b=fVlmg5h0CsUQvDgkRlpjTFrnW+LJEVRIaGN9V9ZRdu1MTdSgkIks9YQR5RumRx5g1j
         CkQLSzDFg7lkXnPu61MmEZkqJD0e4hCH4Z8DLRYJdh9nVnv4Y57wzLbicSv9OS8Zyyhq
         58fl/AFU0WpvV5B0vpE0iynN0Rmia5WaBV6yvZPGy3KMQTYyGDVpquPX5NUqr+NXZtzg
         mvTO5N+blJRFrv6IXvKdyIoRIprz1qnldVFajqdXmh2yjNPmYQOQt3Czejon0DzVMAAA
         CAarg0CnaRuEgYsrkKWjQhuPXGFkzjd3dTNP/G+k+TFiJxPDhCqfXw/4hEfoYxWGXWlT
         9uMg==
X-Forwarded-Encrypted: i=1; AJvYcCWEe+3muIrsnkslo62tcSGoF2Ng068xZOhbs+mDyXQdF/51aQdNGBos0NwPPn3j6ITRIOOV08oiH5pJHuFglys+336Xa6dO
X-Gm-Message-State: AOJu0YyWDvpdMW4Fs8TfPOtr0jp0zfOAH7TyvNeAf+D8DTCDZ2J67we3
	gRHSq5skbo7hUqqFVG9f79JZ6iA03f/QvWmXm0+LOPvX53bC7HCp
X-Google-Smtp-Source: AGHT+IFMU4gzIndebrpd/hVeeR/Ex4Y3al2xaliSFhhET1KuVUMyOzj4zCCOyaTOOsv8L4D8Foc82g==
X-Received: by 2002:a05:6a20:d703:b0:19c:6fb0:2b02 with SMTP id iz3-20020a056a20d70300b0019c6fb02b02mr17269437pzb.61.1708486150696;
        Tue, 20 Feb 2024 19:29:10 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:29:10 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v5 7/8] Add common/ directory for architecture-independent tests
Date: Wed, 21 Feb 2024 13:27:56 +1000
Message-ID: <20240221032757.454524-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
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
index 8f14a5c3d..fe299f309 120000
--- a/arm/sieve.c
+++ b/arm/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/common/sieve.c b/common/sieve.c
new file mode 100644
index 000000000..8150f2d98
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
index 8f14a5c3d..fe299f309 120000
--- a/riscv/sieve.c
+++ b/riscv/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/s390x/sieve.c b/s390x/sieve.c
index 8f14a5c3d..fe299f309 120000
--- a/s390x/sieve.c
+++ b/s390x/sieve.c
@@ -1 +1 @@
-../x86/sieve.c
\ No newline at end of file
+../common/sieve.c
\ No newline at end of file
diff --git a/x86/sieve.c b/x86/sieve.c
deleted file mode 100644
index 8150f2d98..000000000
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
index 000000000..fe299f309
--- /dev/null
+++ b/x86/sieve.c
@@ -0,0 +1 @@
+../common/sieve.c
\ No newline at end of file
-- 
2.42.0

