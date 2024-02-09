Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEA3657A3
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 07:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462177; cv=none; b=tsvwl35O3z6yZ4FUMtfvEuFePTdONywwi5GEhSfTz14Ay5Y6/2dUrv711K73uInntBT0TNe0F483yyvLp5nx8T35eJnH9xgoZhBsgfNm1XR3yhQ9PoiyF4+UFurTuVsv+I1Wr8AeOgeU6Nq38UOxQuI4VHuFgk1iKbwguj71QVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462177; c=relaxed/simple;
	bh=IcS62kZkPfcgyZsoiOU+CF/aNai6/xamvdNLtmZr0zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCoLB7TzuABXB3bXY65XGn6mDjN5WSQD/llQK2GbXwyu81+I5IqUhHLe6QrBLpxKQU5RzXzUuuI6g13JMt4Q85jJC1LoV3RxtoSYRd8r/LsGgCoTZJ4xbYwz0FhIvNAom1DpAHSHcFvGtjIcOIduWlPv63H2PIj6k7eLW/H7RGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QqzZpx7T; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QqzZpx7T"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d8da50bffaso3300905ad.2
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 23:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462175; x=1708066975; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OVEm/pYZkdeEDIy5KjMBW2u/cmIIhledzwTk6k6esVw=;
        b=QqzZpx7TDNV4Tllh3y6JCbxtCieNMK69t7zjsvpYzmh9UNOVE2Ex5fEHQqfZ3ZriKS
         YrDnCL+wKuFf6x35chpkXetii9oyDfPsrz3h1rRWTOAYxJVZgAedWEeaBKLXcfdcp0kp
         woSiXcQlpqugwWck+2dQk4v4jv5hiUqXOfPu++MS+mvm9AVlDWrD9xMOoejehbZg1GzR
         H/eygDArJZaSXM9iyC0tPtscbpBtRPuHyXhH1yY6KwFzrVwB1q0DC0zEibAo0aqx6f2q
         gjQ4LFYRNZ0ZspOE5UXxd+IMxNFks1/8eTva10Phx96uWwphA9TX8gm6D4XqKW9IUnDN
         zYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462175; x=1708066975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OVEm/pYZkdeEDIy5KjMBW2u/cmIIhledzwTk6k6esVw=;
        b=fMwMXHF5UkDFcThda23lWFt69LFqkMVTKTSXLCxd9dnBsOjK+8fQvQrHwlPc26hZjo
         tHHnhzZPdHTTP3cTAtkSb4ObqiP9daES754/7Sji9XNsQxECLyWTrbcH3XNAuEwemDTj
         oRv1r6p2RjeRT8rbCmNslC6DOml2kQeXQzBIrkZGskCPwR0Vd/3ebRNbafvKauE8CdQr
         5nkiDkKNhqw1TYlqr9ah7878lX73mNCiwili4Trvor3XcCnZz95NL31j6TXofHHnCj2s
         tCgGiyQDwxVbFna0DnZq7vJegLBBlA1OftQhsZxB2YohBJUxrjVoBFJchDhu1l7O78w9
         6bgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWN/GDyVsIG9eW1XGf5tH1uBmWLMsyPKnc2j/7z2AnzJwLMQZLHnNmIppoWovjzluvEW2iuFSRzhNcDoAfE9q8igaJ0z36c
X-Gm-Message-State: AOJu0YzFanRSpCS3R8L0htLm8e/IQmR/HnycAd30wTzklBseh/mWAXAv
	7sK5fPtxwnIUxnxfWoVivn6XFltR5Tq0dJpsm45316bDbrXbz0Pd
X-Google-Smtp-Source: AGHT+IEQnwNqYZV7NMmdpTLfryCzZT99JVrOcx1KoOE4uHx45cY4W8kkhKefaUBVdiD8mo8fym4z7Q==
X-Received: by 2002:a17:902:fe0c:b0:1d9:7e40:6c2b with SMTP id g12-20020a170902fe0c00b001d97e406c2bmr719014plj.32.1707462174901;
        Thu, 08 Feb 2024 23:02:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVX4sftCfg4C1MSLp4Dd5cmlgcIFACd8suRXWy8FwyF/WhEh7XciVerXpPJy64oDODvV3AucCySya4eOUXdlcnXqW+f/Id3bqxOHfAkc+qYtY0JcJ0r9GRjOgjodKtFXzX2/2iNQDiL0P3bRbv0/FF8hTGhuR9RNSD9qHJ82fJ2SCmMmWU8UyOSROZG7EQWwQy0iT6waqxES1rsQOsaN0OtZh5CRa8kOqdx0M+hXPlx5UZPr4TSN3t3eiVb2EpVEXPtk1aAsNwP4jCOVqu6NBIojn5EWj3VU8oYvzq6Caotl3E5FoGRoxPWZA351D+KCGvV+iSyRuf5PPLAQUxJEmbCPTsaDqSIzscWMulQwIeMokUgpeubCaxA/5DZUEOhZKNUt7QYuKqidmO66aa+vVj0ylBNnLiouvSSLSVExjuBvKlaM/P/LrbzkNvcWllv4FCLaVJYzveyqGyuO6HZKGT5kLYI+rWXwPH822UknKvlMB5sXYgG90c+9zXk2cHUVIcdzl2g4VtKtRKhJoJSIzVseqGfETA72fyXW1hZoxqSk8Ix3QS7RI1x
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:54 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v3 7/8] Add common/ directory for architecture-independent tests
Date: Fri,  9 Feb 2024 17:01:40 +1000
Message-ID: <20240209070141.421569-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
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

