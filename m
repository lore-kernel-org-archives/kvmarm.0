Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA22F1C1AB4
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697205; cv=none; b=NUUP2YQfSgrGm4Kdy/f8fYJ/FumxHizOxVNb6i6bxKhvSGSz41c61He7ir6sN4xb/lhBQvu9jhsjgXxffKcLHixoV2bfpattsJmI86QtuHRrFw7hrK4cCGVLutPA7aY3GA5GSsV+P64Czquishpm76hXgB0WFYpDcr60H58kBGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697205; c=relaxed/simple;
	bh=esQoNZuXsR24jwPl1DfQPAsmfQfBH1AfjOxCgQQxj50=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I7Xk6w+pSxxoEQOZOJ7wJr3ccpXk2ZQ+yJt0VxHrIJI+3yfDH213WDas4H/bWH7ggRrIwIRSB+xREGwqAwaGl9HRM2ItVNMfa2209sGGmSkTLibat1xpn8LvhNb0/U9g4skW7cE8rqT4Sv48Z6UyXf/ARWEToNzBs8SFk6dBTxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J1ptQCEr; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J1ptQCEr"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e165fc5d94fso12568319276.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 08:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697203; x=1730302003; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpDcLprhbUi5YHe62ZQ4u0o+/QxbhbJTnRiVU+yROI=;
        b=J1ptQCErRk5YdoESLq2G9le7nNZlq4YKiDaZ+SgHpW2ceKbisy+VyO7TJZpNjLkT0C
         f/l41M7Z/5dW8HwPsuBBdzAaM7F0bwI6faQg+HpuCwEbbHmRezr7/atCGYuK+cKA3q1w
         7+NHWqLf76ntmwOs1Y3GxBMJcgvWhWkp/ylB2hHi/HmBnCrr9O/jo8DMBd1H72b2eQm2
         kz0+4sYGtHjtbVJ/ecI771pOa9WpS7940GSPnNq9FkpNLFcYnrTH679Pb+AhIBrOatjU
         LylEWt7Vf7/mfem8TkefnY+2K5Kv2YJVz+vQLWJQxonlnEBK4Kz5Wtkq3AVpbvpgVUYA
         UzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697203; x=1730302003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpDcLprhbUi5YHe62ZQ4u0o+/QxbhbJTnRiVU+yROI=;
        b=LakUAn4x4o8c2obNEF9LCQDDDU+wnoYXYtZ21P63lE1Up00AEk9Z3MausDnTID2hby
         fcqA4arTDuzJoAYH2KjuXwRNh0iwH600j2a4phMhXyyupWySN3QzBFeqAjSFfeTG41D/
         arR/ZnkmxmovNaxskmm9gm54HmCcQw0nWQXukkRCehL5ctnD3Cqd9Rbr9n8ka4OA/ovc
         gmBUh7prCX7E6n/l4TBw8vH5pu71B5cBtT38XvDad3DtXoIZ1R8kP9wbDvkdsaKw9yIL
         UtWQazdUu0JVt/go32lzh0N9xA7GstfzXpxyroYd6dvkslElA1+LXMVp9HUDVerlfJlA
         FjGQ==
X-Forwarded-Encrypted: i=1; AJvYcCV31L1zKLFDVJsb4pBrKVK5PQumWDD7CU2/8D/l17BPiqmGM7UGqQ5EIhmFrEwsfp0w2M3dQVI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yww3eYr9OJOhsOLkY1liFBzCsSjW6rKikBMW12TKOiLF7/AVlHz
	/CIaI3VdTm8hfZrUHVBUshg8ot44gaxRvaStGBwzT/KxpV7OQUyGW/ATr9F4GbT+egXbrujVlno
	+HksyTw==
X-Google-Smtp-Source: AGHT+IGyKD6tDsN1UOGbK0zHzy2EM8WTJ3RRqhXskaDYZzY4RpWhowWcPc5+5VKKdGJS9/5Go7f2MraDRssJ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:8e87:0:b0:e1d:912e:9350 with SMTP id
 3f1490d57ef6-e2e3a6bc055mr2784276.6.1729697202285; Wed, 23 Oct 2024 08:26:42
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:35 +0000
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241023152638.3317648-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-2-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 1/4] arm: Fix clang error in sve_vl()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix the following clang error in sve_vl():

In file included from arm/selftest.c:16:
kvm-unit-tests/lib/asm/processor.h:163:16:
error: value size does not match register size specified by the
constraint and modifier [-Werror,-Wasm-operand-widths]
                     : "=r" (vl));
                             ^
kvm-unit-tests/lib/asm/processor.h:162:14:
note: use constraint modifier "w"
                     "rdvl %0, #8"
                           ^~
                           %w0
1 error generated.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 lib/arm64/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index b28d41fd..e261e74d 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -159,7 +159,7 @@ static inline int sve_vl(void)
 	int vl;
 
 	asm volatile(".arch_extension sve\n"
-		     "rdvl %0, #8"
+		     "rdvl %w0, #8"
 		     : "=r" (vl));
 
 	return vl;
-- 
2.47.0.105.g07ac214952-goog

