Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975CD1CACDE
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697209; cv=none; b=X8LhKmhDrz6cyV81WV0XC9Jyq6rT5u7e6Xlk3S4WC4fspBIRmjRbSNvmY55G+CAihe1i7Et5cFpvQhHaVqHjGTk79lnVXJzpyrNGrzpGbsj5SndKPv6YCmO9onqHj+WW7BeY/DYQA/H47nNYrSnK98T5BO7SWWgu/VCHljAMfC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697209; c=relaxed/simple;
	bh=B5fYkslRkwaBuwyV1YpAJJzIGleZ/3nKyW4XhZgaP44=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mKlDnEmVVsY3eUZK+w2tmtFmRXhqETp1SpXtMybFkTQ0xNAuHd0JjISrTuUNwhAvemGuaRqYsc7q9TQkGKu5e5iiVhepwyWa1JcQtsA7bISCZtjrWNzmYbCphpdFu5G50Gbrb+Z5znHU+AIsRNCtYnsiO9QGsdd4YZAAS3Px0zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JwfMgQ8O; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwfMgQ8O"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e290947f6f8so12050063276.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697207; x=1730302007; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A2EE3sVxYqIJ1dH+QTH0uydlcXtt1ReqMB1Nu0t+juU=;
        b=JwfMgQ8OF65itoBeLgyEhfBiXBsxpKtdbizRqFXWWKzQsOUsyKKmcsjrPwvpxkUZUa
         ww4dZAYWRKSbITdHC39Hq2QkRxTtn+/H3uGnFa7m5yenVlH5NOIlYEPa3LjdclsCCIUO
         0/+hRzIl6mzyuz09q/6ZwmBdyqodNGC/2apvuqMkGltqzDBnut+4lI8oN+QwQOtq6yls
         WhBtriYwXNhhHywJ3ekr5fi8qt6gCGCel3uidbQcKiLT2IV9ul8rnob9ykZaDQiUGjIk
         FMXzufgV0tqAVUR+0vpyNndcvZQZBOZhSLxySXz6RHiAbNL+i08c38rxKj+r0fQBXXoJ
         z1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697207; x=1730302007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A2EE3sVxYqIJ1dH+QTH0uydlcXtt1ReqMB1Nu0t+juU=;
        b=OgW4xGDBhiJjXrYKimW7NhnCA2MZWyWJ9IBGj3p6oXihOPLWqEaoV3+yaElwVN5H7+
         5A6DdBDqOiv95+f9EvcyWgIv/npx4mwnPyBaDUkYtSeNQESvQwPBTmwrZ72pyVfP2t2B
         k1ZHvgJ7BRMjMt1wWjpLdSTwoWE/7A5tBorBMPvoLLck0xa70y5DD1fOUugU+zkGtzB2
         b3g7IeZiSzUgOR2Dp0n15ppfKRD2NtBMOdwv6lzFo7p85WW6PGjkfKPsRSMBNalD8dCm
         s6Wd1/yGOdXeJZ4mXrSvxEy9yMvYFOq+1eRBIMspyrvaunSxr97dnpLzbBIYfBW0i3N+
         aqcg==
X-Forwarded-Encrypted: i=1; AJvYcCXHyFsqhGtz4oCRvCGOQovyxYN9Y8PwqVuCXFtegT9jAWTqOdJsLXv0pVT+P+R3R9PXK7JDy5E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+oftf+naTBsQv7XRp7wdG11ymPlDmuasYaAyEKrwacI5+5AXU
	CbsAi3TrIN4hMgmG7e5VBo1QxgqytKH3ffz7qdQdj/ovCcDZDw+TfHezsYMwjyGFacWFiIEvGfu
	gvci3vQ==
X-Google-Smtp-Source: AGHT+IFIvoDWzY92c7Ql5MqDK4/LO8cFIPrnyxqxIgb86cVrW0eQyRyYu3QqngJF51cWPwSpHNgspMn0AOrE
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:df45:0:b0:e28:e510:6ab1 with SMTP id
 3f1490d57ef6-e2e3a6c91cemr1496276.8.1729697206388; Wed, 23 Oct 2024 08:26:46
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:38 +0000
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241023152638.3317648-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-5-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 4/4] arm: fpu: Fix the input/output args for
 inline asm in fpu.c
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The macros fpu_reg_{read,write} post-increment the '__val'
pointer register as a part of 'stp' and 'ldp' instructions.
As a result, mark it with "+r" for the compiler to treat it
as read-write operand.

On the contrary, sve_reg_read() never updates the value of the
pointer/register. Hence, mark this as "r" for the compiler to
treat it as read-only operand.

Without these adjustments, the compiler can potentially perform
optimizations over the registers holding the pointers that could
lead to data aborts.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arm/fpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/fpu.c b/arm/fpu.c
index f327a349..f44ed82a 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -55,7 +55,7 @@ static inline bool arch_collect_entropy(uint64_t *random)
 		     "stp q26, q27, [%0], #32\n\t"	\
 		     "stp q28, q29, [%0], #32\n\t"	\
 		     "stp q30, q31, [%0], #32\n\t"	\
-		     : "=r" (__val)			\
+		     : "+r" (__val)			\
 		     :					\
 		     : "v0", "v1", "v2", "v3",		\
 			"v4", "v5", "v6", "v7",		\
@@ -89,8 +89,8 @@ do {							\
 		     "ldp q26, q27, [%0], #32\n\t"	\
 		     "ldp q28, q29, [%0], #32\n\t"	\
 		     "ldp q30, q31, [%0], #32\n\t"	\
+		     : "+r" (__val)			\
 		     :					\
-		     : "r" (__val)			\
 		     : "v0", "v1", "v2", "v3",		\
 			"v4", "v5", "v6", "v7",		\
 			"v8", "v9", "v10", "v11",	\
@@ -140,8 +140,8 @@ do {							\
 		     "str z29, [%0, #29, MUL VL]\n"	\
 		     "str z30, [%0, #30, MUL VL]\n"	\
 		     "str z31, [%0, #31, MUL VL]\n"	\
-		     : "=r" (__val)			\
 		     :					\
+		     : "r" (__val)			\
 		     : "z0", "z1", "z2", "z3",		\
 			"z4", "z5", "z6", "z7",		\
 			"z8", "z9", "z10", "z11",	\
-- 
2.47.0.105.g07ac214952-goog

