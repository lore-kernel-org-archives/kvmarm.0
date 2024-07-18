Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E726BFA3
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 21:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721339739; cv=none; b=gGjx6Hy96jdpenmJ0pnLKeGXCoiNpR6TQWLLHyrFPHXby/qOfDjY/4eaZq2zmjrbjNvtwxo2wxNwVxRvJQGCAOmlVyBwkr1ho7ELD6a9MM89q3Vtrg0QGFQ39PVBzc/UOpgbkW8qGbMxhAwvq0KmCVo9yTNxgL4MHz8OiquLH4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721339739; c=relaxed/simple;
	bh=oy+xhyLxOF6scskKrZGttBuTtQp9Z+cIPmP+Qd92V1g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qvPHRR2Lnn9Mc+fJzmyHmdMJ9HP02CtOYAlLlERocKEvrJ19YzX6iNktN4ER6WU3oczIEfN9EZvCFzryx8Tj4aRLYjiKcRa1vvanaQGAUFd4iti85ne4ZAeHfdL3Hux/KKHz4cl0EU11W0wYJTzmOtOPZu2smvsvggriOgHhKDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ukUdXmbj; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ukUdXmbj"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6688b5b40faso24004557b3.2
        for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 14:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721339737; x=1721944537; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EypkathlExzRF6s7Pw1Va6Kut8AWRhF2PFYDjZMhs2I=;
        b=ukUdXmbj8NhIJ6zaiQpsL2yKffKQ/GK011kPZq5HS9yYExHQvz8mhS9qLsXiP2Qws0
         wBjh/FQXBjmaz7LEEbosJXMlaGO3oeNC1GhAd2/T3y4sUOpiogl08g8SoSsWXmtxP1yF
         6265oYmsAqoQHZISbLZ/fOvvxTD8+OlmN76hhYC9MLCKOx2JskADPf+dU/H7oASJRYmo
         OG4kq0+MPgbUEIvG8ORZfrwZ0Ni+4bfzm7/BDC9oO59NrPnhYM0T9jBhzJ3eVQBQ2DQb
         yuzwnAs68Q9Le6EMN+q1Kv/+v4fG97P50SjtYV7fK35MqSw9tIwLpVvhEgm2mIwqxrxX
         yxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721339737; x=1721944537;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EypkathlExzRF6s7Pw1Va6Kut8AWRhF2PFYDjZMhs2I=;
        b=WMYo45w1ASa7jmlVRdgnonyfdm4jbgFb9LrlDgS+hKHwzGU+i+cPa4Or2p3U+rxjaf
         QNURHhu2exZH9CvY4KqApSxWJEJNsShybXJSn7rsml+8jKHjz/svhGUGV/h7X+B87hDv
         aIFQ+oEJinDSYzaxJVCRKEEWzUR3QmiIzRXXRGkXyFooJkprnma2pEPJpDAruBlXZIfb
         3CHA8KtC0JOUs5X6P77hCNCRiU5hFPItrPM6FKxJsrPVt6ewtwA947gtsENfCD28xDE8
         C6UXPly0Ww+CD5aj9rs6BHjvfmVvSlq3I5UH6KNcX5lKBKnQeKJ2kxd3ufmLsgLoXN+C
         9Vkg==
X-Forwarded-Encrypted: i=1; AJvYcCVJv8H3SUDD14iQOBJoLMoL7nvKugIjKLtc5w+OiAEtlkhbcZiZFpw9AhS9Yfi//Idy2t6wVS+opVuGQ3nXrfQ3FJSJk5Y2
X-Gm-Message-State: AOJu0YxBATyPjvc1gtgxmfnAdUeHseWMGhsTEGc9Ydrlqk9zZigs4XBi
	Qf8SJoiI5iRv4IU7xF95ugwjB490DXYL1DqivXHPN4sJZExaJ6eO1mTY7Rymm0//tQsqcNdvK7R
	Sec1N7A==
X-Google-Smtp-Source: AGHT+IFixUR+r//SSF50MMiOX3++HyGfKjJb2WSupKJ5Es5CNqnpttrvuhfPOedVV7rtWVwhpror9bgKMQQv
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:180c:b0:e03:5144:1d48 with SMTP
 id 3f1490d57ef6-e05fec1f9d9mr6383276.11.1721339736356; Thu, 18 Jul 2024
 14:55:36 -0700 (PDT)
Date: Thu, 18 Jul 2024 21:55:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240718215532.616447-1-rananta@google.com>
Subject: [PATCH] arm64/sysreg: Correct the values for GICv4.1
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Brown <broonie@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Currently, sysreg has value as 0b0010 for the presence of GICv4.1 in
ID_PFR1_EL1 and ID_AA64PFR0_EL1, instead of 0b0011 as per ARM ARM.
Hence, correct them to reflect ARM ARM.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/tools/sysreg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a4c1dd4741a47..7ceaa1e0b4bc2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -149,7 +149,7 @@ Res0	63:32
 UnsignedEnum	31:28	GIC
 	0b0000	NI
 	0b0001	GICv3
-	0b0010	GICv4p1
+	0b0011	GICv4p1
 EndEnum
 UnsignedEnum	27:24	Virt_frac
 	0b0000	NI
@@ -903,7 +903,7 @@ EndEnum
 UnsignedEnum	27:24	GIC
 	0b0000	NI
 	0b0001	IMP
-	0b0010	V4P1
+	0b0011	V4P1
 EndEnum
 SignedEnum	23:20	AdvSIMD
 	0b0000	IMP

base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
-- 
2.45.2.1089.g2a221341d9-goog

