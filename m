Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BE883CC7
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 00:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729558040; cv=none; b=IL0MWJ1BCTKx9ES5cJmeBsV9JDriewrlBc3XZwj1IeH4S/B9HhM3ypCsCD1E6Hggyay/1ffEcBdkffzWVlFiSatyn+Qe8qzwBN4DXfRgsOUYrsSDO0GsMxYV2/JCFEa2XsRgiIbSmE+wReWFs7HrmduYUiYrkexyS5bP7DLXr0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729558040; c=relaxed/simple;
	bh=3W9iajvimea6YrR9U732pMuKRx3PZLGRnnVS589DTvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I+/W1EyFpc2ZFgUVGhZOkZwLmQmG3lNCEcVF0DXFdEDM94b3r47uM0LF+Z1oRRixlCNVGa7FZRoQDiPqc6B9qp40KOCJjXTx9Lit4AMplHxgXfvNi22cRXosYeXJmPEVGrD9Yu5eLroGwIx9CAINAiGR2k4RiunnTgeG0iRwMyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n69I9pLb; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n69I9pLb"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-832160abde4so385569839f.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 17:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729558038; x=1730162838; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fFBeTk/ypl/mbwDh0gs/JhAq5wRwgc/prGa+mqCvt5o=;
        b=n69I9pLbB4WtFsqaTavpb+ri0rmmbJlvrJVnazSkdwqxPNvPN3Z6T8RECAH+8+xyWA
         l06vYoBpo+WUNx/XstAkfr8h4E1YX58O6H3P2WffXI6QsuL+WiOGxUo5kx/2NT1XZ7/4
         sA6V2vBkZcdSxwexCjl5ZvWwNjYl40TBkL0AOe9M4KVj49QJhAM1TfjcuBMx6+LIRQzr
         6v1APhMzZXNDEmIqFxS/4gn2JB9XypIPGnlv+pTCkrR76+PrMhlSMdFR+z0E0ROSDqdq
         6ArEXpXvVsxovw9SKa7jimv5qLTqv6V+SKJMc8Kx6sCjSXUywWsyp8yLGcf7RKDVTNXK
         zPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729558038; x=1730162838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fFBeTk/ypl/mbwDh0gs/JhAq5wRwgc/prGa+mqCvt5o=;
        b=LICpxHqdexDkPzyBMrq0QicpizQae41ZM+pH4Xo0BeaXOnwMGRaS1yCiFLdofv2cRW
         lQem8afBU467e1z9gyO3ZDbF3cyeej09FO8rXNeMV4jnbNNILrBnDfBu2pw6FHaoTIEI
         9YFIgUKYkxnVZXJ6f49K0DYYB2EzkQlUn2x0nh2vuXaypowYhs1JIy+eDNlw5Nqafv5s
         o2qo9z/rkgaUseN+BOHUNOU0aukKKrMPOQPNpYVsIjfr+GfsO9z0nBkv6x8CoEYQR+mN
         G7pwrgQCwtNYUaa1S2q+5I+sQa4oKiAwEbghtSPqwZFyS7v12Dgmg+ShcqZkZ5HsQMzU
         WY1A==
X-Forwarded-Encrypted: i=1; AJvYcCVTHfj4ZtrQQFgA2DZDPqgH+Cjue6qBwijq7qisB9il6EIwMjiqz3fyWItRuE+8RUo8hMiOEks=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyunkRO2DzA5vqg4O1qtB/fCsSYBl/sEukpEQdLcrbGxJE3bbg
	2zzYuVs5T/vNQMnkw+U2iK0s57aQJB2SAqNq7E1iIGivFWR6PxUgubpyKyegwnMlM8K4/1AklBr
	osIBQPw==
X-Google-Smtp-Source: AGHT+IGzqRDsg2PzRLzqCFl7gr4a8ftn+I8+zYOg3xTOpEKFCEBYRQxWqZwKNprPXM6RvFGVT+CQWKASwGCx
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a02:a613:0:b0:4db:e3a0:c40e with SMTP id
 8926c6da1cb9f-4dc44251858mr9721173.0.1729558038062; Mon, 21 Oct 2024 17:47:18
 -0700 (PDT)
Date: Tue, 22 Oct 2024 00:47:09 +0000
In-Reply-To: <20241022004710.1888067-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241022004710.1888067-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241022004710.1888067-3-rananta@google.com>
Subject: [kvm-unit-tests PATCH 2/3] arm: fpu: Convert 'q' registers to 'v' to
 satisfy clang
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Clang doesn't seem to support 'q' register notation in the clobbered
list, and hence throws the following error:

arm/fpu.c:235:3: error: unknown register name 'q0' in asm
                fpu_reg_read(outdata);
                ^
arm/fpu.c:59:10: note: expanded from macro 'fpu_reg_read'
                     : "q0", "q1", "q2", "q3",          \
                       ^
arm/fpu.c:281:3: error: unknown register name 'q0' in asm
                fpu_reg_write(*indata);
                ^
arm/fpu.c:92:10: note: expanded from macro 'fpu_reg_write'
                     : "q0", "q1", "q2", "q3",          \
                       ^
2 errors generated.

Hence, replace 'q' with 'v' registers for the clobbered list.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arm/fpu.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arm/fpu.c b/arm/fpu.c
index edbd9a94..587b6ea3 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -56,16 +56,16 @@ static inline bool arch_collect_entropy(uint64_t *random)
 		     "stp q30, q31, [%0], #32\n\t"	\
 		     : "=r" (__val)			\
 		     :					\
-		     : "q0", "q1", "q2", "q3",		\
-			"q4", "q5", "q6", "q7",		\
-			"q8", "q9", "q10", "q11",	\
-			"q12", "q13", "q14",		\
-			"q15", "q16", "q17",		\
-			"q18", "q19", "q20",		\
-			"q21", "q22", "q23",		\
-			"q24", "q25", "q26",		\
-			"q27", "q28", "q29",		\
-			"q30", "q31", "memory");	\
+		     : "v0", "v1", "v2", "v3",		\
+			"v4", "v5", "v6", "v7",		\
+			"v8", "v9", "v10", "v11",	\
+			"v12", "v13", "v14",		\
+			"v15", "v16", "v17",		\
+			"v18", "v19", "v20",		\
+			"v21", "v22", "v23",		\
+			"v24", "v25", "v26",		\
+			"v27", "v28", "v29",		\
+			"v30", "v31", "memory");	\
 })
 
 #define fpu_reg_write(val)				\
@@ -89,16 +89,16 @@ do {							\
 		     "ldp q30, q31, [%0], #32\n\t"	\
 		     :					\
 		     : "r" (__val)			\
-		     : "q0", "q1", "q2", "q3",		\
-			"q4", "q5", "q6", "q7",		\
-			"q8", "q9", "q10", "q11",	\
-			"q12", "q13", "q14",		\
-			"q15", "q16", "q17",		\
-			"q18", "q19", "q20",		\
-			"q21", "q22", "q23",		\
-			"q24", "q25", "q26",		\
-			"q27", "q28", "q29",		\
-			"q30", "q31", "memory");	\
+		     : "v0", "v1", "v2", "v3",		\
+			"v4", "v5", "v6", "v7",		\
+			"v8", "v9", "v10", "v11",	\
+			"v12", "v13", "v14",		\
+			"v15", "v16", "v17",		\
+			"v18", "v19", "v20",		\
+			"v21", "v22", "v23",		\
+			"v24", "v25", "v26",		\
+			"v27", "v28", "v29",		\
+			"v30", "v31", "memory");	\
 } while (0)
 
 #ifdef CC_HAS_SVE
-- 
2.47.0.105.g07ac214952-goog

