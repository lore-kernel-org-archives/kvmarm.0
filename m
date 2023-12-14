Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA2D2E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FLd7wlP/"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbcd3819e43so1556489276.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548130; x=1703152930; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WrUatI3Cz0L0l26hy5tOUKXSSgihHrtUAipqZf1EAmE=;
        b=FLd7wlP/5y3KZW+8HrcNfrBMUVaK+/Mn8mLcz2WegsAA8yn3mohw2QHq1WIXCggzoq
         0xGd74CZJrCOOqe2zjZTtpOdCm5C0UYY1YroNXVEPVqF1j1I2aUo/mMyYDUZB9EKi2/E
         tEeGbAruPaFUo2R5DOoF/R925yvfrNbfzQMmfRyIGLqeeIkf7jNI9MEV82slz5vzUpps
         r4i/fOwzfI1H4MRQtGZu87TIyyWCDb4ZaJbPDUxCt/KaKcOWJ6sgItfulO/P2meUe3eB
         9sABXjQWiz1hxRMaKfiIQ9cnJ8uE+6j34lM8YEjBsrbE0Ye+UVNeh2hmSVNiCqf9esQT
         Ap3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548130; x=1703152930;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WrUatI3Cz0L0l26hy5tOUKXSSgihHrtUAipqZf1EAmE=;
        b=NibMEhZC8D+Ka6kJ1VcXCXsXXfO9vKXTqJsFQJnVEWhc3R2TJbjZcdsv9fz+zDZJM8
         6M0/UucxFp79FYZT8ixSA/TUDS1wWKcj0HMVAuxe36sqDtREP3m1ULfsXFjEIm0Bg/TV
         DDfPzSItDXATPehuejwyLzikNd0Ddm8vljS3EUB7sEYglKoTaNRXpYG+aRyHv0XhsliA
         Lk1r3ptVJ9IinskZ59fXofjZUrCHQSy6jznCdY2Ip0+d1mXSK4V+IlxPziAALQmA7cO8
         jtyGgfjJFb8UQP7Miq644LI8vEcF1RYVGO4Dg2uKVWNDU/9E1WcTf9r5YRFA2Pf2f1Bt
         UMNw==
X-Gm-Message-State: AOJu0Yx3Ld7d1wNJn1b4kiALFenN65F7Rl5DOZbCwiBrXemnQ1Jj2piI
	YTFJnAqaQU2FMP2VaQCAaTc3OPNxXVQtwXYdi8Tmvab5IItX9XtzsYLD49HAWzda3K3R486ZZBv
	Y6/NOawr/BlkFv5Rx6eCtRjnguEuOSkiUE0SnTpLkBkmFTgJd8elmGIT2R9I=
X-Google-Smtp-Source: AGHT+IExOHfYLnvhcVx/97MahYELrN89KnwOUt873aqjFXihCXT3Lm1RgNMDn1jKe1JdIwqgTZiOy41A9Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:534:b0:db4:6936:48b7 with SMTP id
 y20-20020a056902053400b00db4693648b7mr99336ybs.2.1702548129330; Thu, 14 Dec
 2023 02:02:09 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:44 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-5-tabba@google.com>
Subject: [PATCH v3 04/17] arm64/sysreg: Add missing system instruction
 definitions for FGT
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the definitions of missing system instructions that are
trappable by fine grain traps. The definitions are based on
DDI0602 2023-09.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9c2caf0efdc7..b320fb0de56b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -645,6 +645,7 @@
 #define OP_AT_S1E0W	sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
 #define OP_AT_S1E1RP	sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
 #define OP_AT_S1E1WP	sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
+#define OP_AT_S1E1A	sys_insn(AT_Op0, 0, AT_CRn, 9, 2)
 #define OP_AT_S1E2R	sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
 #define OP_AT_S1E2W	sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
 #define OP_AT_S12E1R	sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
@@ -781,10 +782,16 @@
 #define OP_TLBI_VMALLS12E1NXS		sys_insn(1, 4, 9, 7, 6)
 
 /* Misc instructions */
+#define OP_GCSPUSHX			sys_insn(1, 0, 7, 7, 4)
+#define OP_GCSPOPCX			sys_insn(1, 0, 7, 7, 5)
+#define OP_GCSPOPX			sys_insn(1, 0, 7, 7, 6)
+#define OP_GCSPUSHM			sys_insn(1, 3, 7, 7, 0)
+
 #define OP_BRB_IALL			sys_insn(1, 1, 7, 2, 4)
 #define OP_BRB_INJ			sys_insn(1, 1, 7, 2, 5)
 #define OP_CFP_RCTX			sys_insn(1, 3, 7, 3, 4)
 #define OP_DVP_RCTX			sys_insn(1, 3, 7, 3, 5)
+#define OP_COSP_RCTX			sys_insn(1, 3, 7, 3, 6)
 #define OP_CPP_RCTX			sys_insn(1, 3, 7, 3, 7)
 
 /* Common SCTLR_ELx flags. */
-- 
2.43.0.472.g3155946c3a-goog

