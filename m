Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4DF18635
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 06:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857152; cv=none; b=WMDByQ/FhPHt2Cyz6Cib+YPzsI5oFmxCdmXEl+XWQg5Qug1bl8LNuhZhFi3Wu3dFPcWcQooKYm0MpKXaNzz56c/hUU966QOMd3mJcB0557QncCN5ECuvhyRKW1euinRFKGFNd3Es4xyFuz00hubih+EhJvKkyjMxXbRx/1NQs2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857152; c=relaxed/simple;
	bh=6JbG9et4ggNViHk+xpnp84ZGRBT58T7v98W3F6J80+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQLYp/q6Fm5dD4SISicFOl1Iy16tKCEzn2i4mwLZ9wqSaxAuaX3ESEY4ozoPzkTHKJQOYrAHmn3LhopUav+ZobM61+esTTO0jtsbXn2BLlg2qN0bnHj+PxcpVdUU/ZvE5hGh0tOmK4uKAly6XinSfzKCiFCZBwMpwapVba1ZlTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lPIhYpJK; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lPIhYpJK"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d93f2c3701so10667785ad.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 22:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857150; x=1707461950; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2A8b0YOIg6lGChxKQRkSufzy4suZ23mRhNBzFJEEdSM=;
        b=lPIhYpJKXKWaNbNj57B+12qK+wT0QreSVPbydvI15d4gENx4MehidwxpgWqvJdbbGv
         62+q6YAWxNuWgvO76iSXfdyux13GtfL3T4gahafSREzNu6g0m7Wy+CJAcS1BHe/chXhH
         Iet/MTT/twfy9/NZxVqSdKTjcXcgsAwvM6HwHnRPO947MYMusq8h8bm110vKvHWdFo+k
         xgnYcdXtrAOzRbpP8ahg2v8Fm1CXcUFABJ11NDHxb8GJXam/x+8u4Z/AFvRtvYAD8UrK
         BIABoUTWsky995IX0Atf2MxufocjL6un9GHGWr9w5f4ulvU3ZNSuvaKlw02DT4az7flM
         mdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857150; x=1707461950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2A8b0YOIg6lGChxKQRkSufzy4suZ23mRhNBzFJEEdSM=;
        b=jyXRmkVzXCO5/DWL9/FoNmMCY4Jjwaluo1+ybcvAFL/SRG2uJxivAUwdrpg71iWzf7
         njpyrHlweUdUHZ2dotPu766IB2xPVGkUCQOP0064G7xNVrIZIhD9VSm9RQh0OhAc3Z2I
         wmg9c6oL39V+vnnvxaDyCAPisHHSBuSj3QENb8AdzVMfYkEwmzkVEdfUYWaFsz3NtyfW
         eJphY2Bd35Z5XoCjCGU8OcynqRGyt1hWzVrUMnLtyGSy9U19r7ZR+HAk0g2v8W+KNFD2
         iMiElo2h/PooyhyAUJ2ijxINVaGd+r1FSzTk9HG1Wuc84sAnjJzqPcN5ZsI2NntA/EOg
         GIsw==
X-Gm-Message-State: AOJu0YzTS1GgrJMt+7OaRq9dVqwLCmA3k2wDE1IMsG5MqOVuMZLKmvRi
	qrTKltVlEDjK3eGnNhBdqR37NKzoVdz4p4wBVOccrnHIwBPmyjzQ
X-Google-Smtp-Source: AGHT+IEFt7kfJGu61jZUZZl3OY3s2dKrBdsO6NiQuZ9E3dIRck/n/RDkAL+FrMyrpMKk6m8nizxRPw==
X-Received: by 2002:a17:902:7c97:b0:1d8:fae3:2216 with SMTP id y23-20020a1709027c9700b001d8fae32216mr5679839pll.35.1706857150341;
        Thu, 01 Feb 2024 22:59:10 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUYncYvmvYyn1bIo4nQyp/+E/FnRz/SeAmt64eUXq2CiSJIqXGaPkB7FxwGpzIlNiEzEzB+LkGRAgVN2ozGXSgcLqCVtAOixnufvjh5CF4R7/qutE1ZgrgE8KPEDt4fEwlzL5vi4cWxKE2403WAfOQvf2qfTnsOZzjq6Bmn0UG5URuvkXMko5RrllOPDZ6rWDnfJe/g/oThk6+GyqcslLMVeLxnrFBw8vNdmX7qajZ8/TLHzwe4MC82JvQe07k0oMntr18YdbhE4iIh2XZVXmUOqvb/OUVvkCBThcjEti0ruRHPUECZ6k6xtj42LMpSwYOklQ9yQrKG5eg1EI/PkK11hDlHCljnGJcrbLlaaeWFCOQqUIS36VObLTPRw2jRtK0FVwVPAm9AWYvxfHOoGpAtpmnBkf8oFFpaUF//HU8VfpLXiNqo3RpxpdXdPQIsTmbOtlx+UbGTdVN/GI9VfcohRq7mEAffaqJs/ZAwZ5xRv1zdOrnEkFhJGpUJORVnhWanLA8LXQ7azRg=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:59:10 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 8/9] Add common/ directory for architecture-independent tests
Date: Fri,  2 Feb 2024 16:57:39 +1000
Message-ID: <20240202065740.68643-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
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

