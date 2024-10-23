Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F54D1C830D
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697207; cv=none; b=htp3Z/MC35tAYWkmiKqGxiFS2jLDF9sWHjFlt+nl9ZWSG1XwygOpt5PwmALKXpP0T5P++eLu/1w36rHJkParXhHRuOXgxluE5kjX5Y90NHIv5/Y+n7jySdjTgQUHGvwN6+cskg8iuydPqkv1jH/V75q7/wekJxHCyt27OdfxpFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697207; c=relaxed/simple;
	bh=sTMEe8hKVyhG4n3/J0S0bVeWZJkoFNBIjGAvrfLzml8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OACSFZKynOMlPw1BW4YpqMV0IWpcga9OqIWywpkXKOTSz/NBaKP5OX8gPcCl/HvxTwKXJu/NAmVIYVGEDebxwc8eLRaF82fY4TW3A/hifagRcqd6SzI3OaXXOKuaP+ljekZXkhi58i4KEdRxnyYi23AO8XDajB2lzqn4W49f24E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JUA20cPc; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JUA20cPc"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e6101877abso56452127b3.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 08:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697205; x=1730302005; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7NioyoNb1tbeyUGY4RlitjUeF9A4E3KRPhc6ahZCNVQ=;
        b=JUA20cPc0S1MlwRUJzB59//FRU282aOevX/CEVKGA/lGlTqDWxSAZpWP3JbUVSg/Sv
         lf+QFcU223Rm6dzcJwtfzC82f9erX7fdieQ8BadZXYEg8hmYK1RD7fNq2Jpo1CPtFPL6
         UoryRl+KNDl0xdXU0krG4REc4+X1XQUIDyK35UgKqHdb2Q6XUs91G8h1+CCCqqeL66ex
         X89EhKTe1IlYjugAVbhSP421ypgM0Ry3/Q8HtVWD8w6SzQLCEYAufqRRRkuBAP1bbyQJ
         rx1TyhbpkCHqkeKBFCpmd5ztC36umCOb0+3k4lMdlbgiqUTe4Q7Y1XnqomkSATOx7NGU
         Zh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697205; x=1730302005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7NioyoNb1tbeyUGY4RlitjUeF9A4E3KRPhc6ahZCNVQ=;
        b=D5cZuZUKofjkesjcBn/mPUStALbcBATRsW8PKVzZZyQYqKlbYb+H0BqpXi7EZFPs5H
         7cXU4hvdJQxrkIA1g3jMwch0XCNRSKLFQxTSWO+8ee349A18mdoQ9a0/zwRdej+cA/7v
         FxQVbMH4JuzjgfJzHx4dDmzuHmG64W2Jrm3xY98Op7shltRa2Z/dUHletQJLx1gRzr54
         dXF0FyK6l9En8yB39vTAYgDH1teG79b/BbjdqGrN06L5dSIEfA1a+lxwjDn0EJNEX5XG
         uBmMEWUIf41UNVWm+RlWaHHfbXkAzbTYKNOprahSbOJv+i0UNMeGOOQ7DWhFAoVK5Djl
         7p6Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8KpFLFigPuVBmGLFzJYfS55ItlX4rxygZ2ucFnNJx/j0aYW7zfEvyzGPZBv/E52hfydgYERE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbVuaBXty9C4SnQIrM8yu+LWWaM/zgw6/V/aiCdUeLjTyNr8Uh
	hCLp3l2xB0vxx27ScAXYq4L1kYNUuilL76TZ1KtPgfWMaxFEQuR2mQavonLlTY7E4h20+IpCw+8
	FU/peew==
X-Google-Smtp-Source: AGHT+IE9OyKSIQFj5g+9JOMt/US00gq7iSxNgRTSGWr8GfQo9rufdELdBzRinCot5ZkBU1YALlbhI9gWX/bZ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a5b:947:0:b0:e28:f454:7de5 with SMTP id
 3f1490d57ef6-e2e3a6b78d6mr6103276.6.1729697205144; Wed, 23 Oct 2024 08:26:45
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:37 +0000
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241023152638.3317648-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-4-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 3/4] arm: fpu: Add '.arch_extension fp' to
 fpu macros
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since the tests are built with '-mgeneral-regs-only', clang-18 tends to
push 'q' registers out of the scope and hence, the following error is
observed:

arm/fpu.c:281:3: error: instruction requires: fp-armv8
  281 |                 fpu_reg_write(*indata);
      |                 ^
arm/fpu.c:74:15: note: expanded from macro 'fpu_reg_write'
   74 |         asm volatile("ldp q0, q1, [%0], #32\n\t"        \
      |                      ^
<inline asm>:1:2: note: instantiated into assembly here
    1 |         ldp q0, q1, [x8], #32
      |         ^

Hence, explicitly add fp support where these registers are used.

Reported-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arm/fpu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm/fpu.c b/arm/fpu.c
index 587b6ea3..f327a349 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -38,7 +38,8 @@ static inline bool arch_collect_entropy(uint64_t *random)
 #define fpu_reg_read(val)				\
 ({							\
 	uint64_t *__val = (val);			\
-	asm volatile("stp q0, q1, [%0], #32\n\t"	\
+	asm volatile(".arch_extension fp\n"		\
+		     "stp q0, q1, [%0], #32\n\t"	\
 		     "stp q2, q3, [%0], #32\n\t"	\
 		     "stp q4, q5, [%0], #32\n\t"	\
 		     "stp q6, q7, [%0], #32\n\t"	\
@@ -71,7 +72,8 @@ static inline bool arch_collect_entropy(uint64_t *random)
 #define fpu_reg_write(val)				\
 do {							\
 	uint64_t *__val = (val);			\
-	asm volatile("ldp q0, q1, [%0], #32\n\t"	\
+	asm volatile(".arch_extension fp\n"		\
+		     "ldp q0, q1, [%0], #32\n\t"	\
 		     "ldp q2, q3, [%0], #32\n\t"	\
 		     "ldp q4, q5, [%0], #32\n\t"	\
 		     "ldp q6, q7, [%0], #32\n\t"	\
-- 
2.47.0.105.g07ac214952-goog

