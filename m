Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0851A70A
	for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFI3BvPt"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d3cfb1568eso16309015ad.1
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 05:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253123; x=1703857923; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2A8b0YOIg6lGChxKQRkSufzy4suZ23mRhNBzFJEEdSM=;
        b=iFI3BvPtQ+eoxgROX+mEeKD56UYFgcEFnANV31qsVg8xnwH7/phBt5DksKvQ8IdBeT
         lOAMRSQLjbuv08AVLj5dgJAX354RFXn4sPAjTVcJXRn2463/LTzrQPkCVssWNKFuSHtw
         ODHqSbQZCOQit/5CZaMgcQwrfDI6jL7lGVOytJLvNW2x314+/Rb+HeQzB1sTRDLCkfKn
         97A4tiQ9/Uzt/cYg9jgay1i2zEeRAjYuq76W3Z5dolvrzmn8O7Y/etnYw+JZvvehfhZo
         hye22MLDAywVRfAA9iO9lEcCs0hLVngnS4WliufxW2RV8UYO/vXTnE0jCtdguEm7v+Bg
         KLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253123; x=1703857923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2A8b0YOIg6lGChxKQRkSufzy4suZ23mRhNBzFJEEdSM=;
        b=OcH69qLeevLEhSW5kKPL9oh/UOR4bGUNQT4pQg1/TzXFvNd5yZPRPCvKamNFXOjDLs
         7tFD/1vUUg6q7akVfABFIueUjDRVoDplI+WPZFzNOe9tzqE72F3o5BxpU6jFHy0wg9YM
         Dlp8MhnQ/woADB0pPZBHGvFYNPFDd4jQUM+USw0GQ1eT+EGgjw36T5KnnUXm0XsuR6dC
         RMHTouKKe9Ll3DSxLXUUa5J211zOYKz4ANYIV6C7OygZ3gRHQv7lPdEB1E3xfAAFFUvm
         LjWk2fm3e53PEFQ0BsfIJUKKiBzJIfjwbGNfTC7G9F76v6Mj/6h0TjP4LZUpbYCiHE3M
         XbNw==
X-Gm-Message-State: AOJu0Yx7Joo2/ghaY7mf33kD7JVKmdcDbeAQVd22Ip9EuDzr6Ci3xTRP
	JTSkLMjnJdW9tiPHGJbzLAQ=
X-Google-Smtp-Source: AGHT+IFQvmq4OO8RZRqoYdZH+NyCux5jSToZv3wFAzfmemzYuCnTc4PXXs3gZ8OTO3g8gRr8Oh1Jgg==
X-Received: by 2002:a17:903:32ce:b0:1d4:223f:3c26 with SMTP id i14-20020a17090332ce00b001d4223f3c26mr829886plr.38.1703253123349;
        Fri, 22 Dec 2023 05:52:03 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:52:02 -0800 (PST)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 8/9] Add common/ directory for architecture-independent tests
Date: Fri, 22 Dec 2023 23:50:47 +1000
Message-ID: <20231222135048.1924672-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

x86/sieve.c is used by s390x and arm via symbolic link. Make a new
directory common/ for architecture-independent tests and move
sieve.c here.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/sieve.c    |  2 +-
 common/sieve.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/sieve.c  |  2 +-
 x86/sieve.c    | 52 +-------------------------------------------------
 4 files changed, 54 insertions(+), 53 deletions(-)
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

