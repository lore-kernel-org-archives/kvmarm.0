Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129E57FA
	for <kvmarm@lists.linux.dev>; Sat, 17 Jun 2023 01:49:58 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-39a3f165ac5so1085523b6e.3
        for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 18:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686966598; x=1689558598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0aouI3DdNhfQmp4r40e0gBQGQY2MKk6L0dsEJY5MkQ=;
        b=J7OeJIZ8wEviVDqIZRl3Bl2hB7vfA673NwmzXNm6f4T7FEcD6i8KGymnPKa8rhhBYr
         X06AufW+zecDL+TxWQGF+LHMBvwx8YJCTrsTmOz4c4YPozhqSzKa+qwlgvyBtQkZA8rH
         yPZRdxOuJMswwTCo6hhihrohG+KBjItf0a05mggMxECoUmmzGcaNBrlZdMuY/ru+1feT
         7zV29Z8FYCpKqRfBl6MOSOlGJIyM+xBKNotAWdD7haqTcK65spHaQEiwrA5a3ESXyfwB
         UdsjLvpg27Kxujzzdd0+rTlgEJdgDjCo7bRNJwIKs/YJwlcylIArswWr1gNHHPXCQQ4u
         vh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966598; x=1689558598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0aouI3DdNhfQmp4r40e0gBQGQY2MKk6L0dsEJY5MkQ=;
        b=G+/eOqZCJYa4q59rYhOq05/i1J8AYlV/Q5BY/uACRYqTv/pm1qyK38UjCeKbKGn26Y
         44URxEf0Ft9Uap8bcZaZOrPVQFKJYWnbm72ext1v0QycYLV6ePbw2JWiy1JmmI51OHV1
         /3uag/PhheR3HeL4xjWIcyQVNWmGQbrTl46gzZ8EpGMHIibgEbcsbR5tIX9+LaCRaPOY
         OSnH3iblQ1PTk5YmP0bfulcQ8rEXnfrRx0+3mkCvi+45JR9oZzUeuk/Rbvl2aRKKb4k+
         KI1tJwAj5eFL7vHG/GR8giaQww/c8ybiUMfdFaUhGqUDCBmes2Yycj/mxJTr3i/TKGFY
         9BSA==
X-Gm-Message-State: AC+VfDxCUdvWmkTevABQs/sUv8bX/o4Lp/k6wLW4UbEoM2rli5qW6kvn
	NyLYG1ie4VqAa/+OshdkOW4=
X-Google-Smtp-Source: ACHHUZ6EdQMa4dxT/ZQbdcFF5Q/NvrnVakTMJuCcxJmrEe8+tW5IPfS5UGV69wVFmBIbGGLJ72iZjQ==
X-Received: by 2002:a05:6808:188d:b0:39e:5886:3dde with SMTP id bi13-20020a056808188d00b0039e58863ddemr4907310oib.12.1686966597435;
        Fri, 16 Jun 2023 18:49:57 -0700 (PDT)
Received: from sc9-mailhost1.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a031200b0024dfb8271a4sm2114440pje.21.2023.06.16.18.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:49:56 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 2/6] lib/stack: print base addresses on efi
Date: Sat, 17 Jun 2023 01:49:26 +0000
Message-Id: <20230617014930.2070-3-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617014930.2070-1-namit@vmware.com>
References: <20230617014930.2070-1-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

Making sense from dumped stacks when running EFI tests is very hard due
to the relocation. Fix it by adjusting the address back to the original
address.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/stack.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/lib/stack.c b/lib/stack.c
index bdb23fd..c3c7c24 100644
--- a/lib/stack.c
+++ b/lib/stack.c
@@ -6,13 +6,38 @@
  */
 
 #include <libcflat.h>
+#include <stdbool.h>
 #include <stack.h>
 
 #define MAX_DEPTH 20
 
+#ifdef CONFIG_EFI
+extern char _text, _etext;
+
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	unsigned long ra = (unsigned long)rebased_addr;
+	unsigned long start = (unsigned long)&_text;
+	unsigned long end = (unsigned long)&_etext;
+
+	if (ra < start || ra >= end)
+		return false;
+
+	*addr = ra - start;
+	return true;
+}
+#else
+static bool base_address(const void *rebased_addr, unsigned long *addr)
+{
+	*addr = (unsigned long)rebased_addr;
+	return true;
+}
+#endif
+
 static void print_stack(const void **return_addrs, int depth,
 			bool top_is_return_address)
 {
+	unsigned long addr;
 	int i = 0;
 
 	printf("\tSTACK:");
@@ -20,12 +45,14 @@ static void print_stack(const void **return_addrs, int depth,
 	/* @addr indicates a non-return address, as expected by the stack
 	 * pretty printer script. */
 	if (depth > 0 && !top_is_return_address) {
-		printf(" @%lx", (unsigned long) return_addrs[0]);
+		if (base_address(return_addrs[0], &addr))
+			printf(" @%lx", addr);
 		i++;
 	}
 
 	for (; i < depth; i++) {
-		printf(" %lx", (unsigned long) return_addrs[i]);
+		if (base_address(return_addrs[i], &addr))
+			printf(" %lx", addr);
 	}
 	printf("\n");
 }
-- 
2.34.1

