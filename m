Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F0B1C4605
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 15:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697206; cv=none; b=fdxULojGpCzG4r2A8Mr9HYWuI5KWgNKgATLCi8P+ehw9GQJppWAyMVReKl31cz7xOmN55Mgss0xre58Fq2zQrQhXZ+VsrQx2UWwAFVeLTBlYMOEfsMtekgtA+EmAh9IHu5JU3MtqqDoxNZ9CY4Nyw7TdcE+jffmoX3UIYaiEZYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697206; c=relaxed/simple;
	bh=3W9iajvimea6YrR9U732pMuKRx3PZLGRnnVS589DTvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WrVWjMZtvdr0SntVCzkAxgLrSqAB7tB4rodHYM8wAv6j6oxIs1pgy2m+Fkj3R1rb3B/1wpSv3WXEIz3DLtKTQP349ffc79++/UsmFPKPNUVOcmQykuqMAurGSb+tnK3zFYV8VCMwIVkg4xPTefdojQAvHTBRZ8afR/8ioXiO2LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RRpau/kt; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RRpau/kt"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e293150c2c6so14394444276.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 08:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697204; x=1730302004; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fFBeTk/ypl/mbwDh0gs/JhAq5wRwgc/prGa+mqCvt5o=;
        b=RRpau/ktqJvh1ylDD8V8Bjg2czoKhHQpA+86IQVagmQdnap4ebdmaQDAbcfG4dYtYj
         Qjgp9C4UMD5pCUldlRQMXGuj+nkLXoSR6gwAJ/RbvraU0AcPdvYMepFb+XNcp3+icWO1
         Y2ZCYyL+sAQJPJpQDgz1uJ7YmGdSLA3KcxbC5WrdX/k12RH6d8e4n1hi5mhCtLo7vD9K
         dW/rFvysglHP6USTpa5P3fhTiadnCuCoP+l8/4OCkeiO8fzcrQ26yQCORf05di8wQ+xe
         qZsPfHk3UlQawn1OGLSfnnnklCx1QZ0NJTOGwrAfxSZdFY6RkfWOlG5dCIZPUJOVcBUJ
         +xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697204; x=1730302004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fFBeTk/ypl/mbwDh0gs/JhAq5wRwgc/prGa+mqCvt5o=;
        b=YXGd1SQYHKPWsSNVoWeiV9xHUjTGXGtYe9dNWCfXsmPtpsTFArD83W8+nw0bwNJGSX
         L+Nm4LRFfQ+wXNnSgXo5AdwgjMyUZHHOaaAsoJM6jn23XlPQmAohbcZ627I9eOvRl5Tn
         WwRfr5qbd/RFNB6x0emcNwQgqJr+B/HNwD2guswuZ7mMtFCAjQfQdhw0aRZg8hyom17y
         8mC0HvZHZ2Ci+oJKoue2jfNmlki1g/SlJXCqYtzUjYkZvcGfwIR15I/ERiQEjP1QKQg3
         PP3c+0T5k4cuTo+/xSmP3uKqQXMv6UZJ5zRUlnbhVmrmxiCFFluY4h3yOz5fGfQInNUt
         VkMA==
X-Forwarded-Encrypted: i=1; AJvYcCXdUqIU8ANHF0DM33pHlQIDMMhZC0fFAgI17o+w1W6Svrbz6i9ZPJ4HvjgznSfCfdeZacZ5gr4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/S43E3XCdcpMQ3RsvRG5hzbqhhWC5tYuTUNHXQdbA8YNqkdCh
	uJmlo6b/G1YkEoJI4IQij0u9T8OzClxhE4baYb0wxCnrCmAYkPLp1sNvoHvmXFnS/67QRD/ZiPJ
	a+IjWNg==
X-Google-Smtp-Source: AGHT+IFh0UYQGtbCtvsET0xrrd1Y/kAJ4FbXvNEzhh8lcJJcZvj2pTt+HaP9rNqWRxjhbRVfontBWLjAHjHZ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:acce:0:b0:e28:8f62:e735 with SMTP id
 3f1490d57ef6-e2e3a5f5d18mr1688276.1.1729697204137; Wed, 23 Oct 2024 08:26:44
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:36 +0000
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241023152638.3317648-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-3-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 2/4] arm: fpu: Convert 'q' registers to 'v'
 to satisfy clang
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

