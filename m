Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788B37FA
	for <kvmarm@lists.linux.dev>; Sat, 17 Jun 2023 01:32:26 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-66615629689so1389610b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 18:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686965546; x=1689557546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghZd0EKhf6zwbSGX8Xn3+2U2jGi5da3/3tMUOfzdgis=;
        b=LX1x0JRoF8m32vS2JI2nzAerxVhcE3UoWLK4m6IECKwHdvB2PwOynpXO9NeNYxTvkB
         RFearwiEFTNfAIUqEMmzZ5DYwVylYKCSe2bbGLARV8QIWDNJYxNTuf36DHN+3X9yLdzL
         j2m2emSsrssKh48EL3/EHRLmGbu2zUb8gezphQuIv4Ryb1OakI5fIdswOL/HIt1syShb
         QbRQoTt665T4m8YxSxjExB/FUKOCkPu0Q4COQYpMYnuUV4hHL4dVYR34AQbnBCg6acXW
         5MeWFqgTIef9XaT8thoTIw/7wwEH9NXXD3u1nt3XB+W/ocpsFgm/icS4bnXNR8s059i1
         s4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686965546; x=1689557546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ghZd0EKhf6zwbSGX8Xn3+2U2jGi5da3/3tMUOfzdgis=;
        b=kRD0ijCY4l9SlS/1IgNoDWDqbv47FLwKihUNFBzxnPItK5Kjp1N9w7LYSkXKgesb+X
         h6nadOBZDNLh8DUcAMZO5+atx1wrUyDvJRnT+TejqpfUYhUrsHzxfbg+SOOpYleeeJYG
         kbYHYO3yE/Z99d9qEH/BCMMVMdV9DFC7iiuKMk/uQT9ksM4V09AWh/MdgYVv8zfVV4I7
         1IjMT1JYRciY8A5UvHD7KhXKmgKXfP6idf/hKlr+X61y7xLNV5htemSnKpTt0Peq1JQh
         XScNSNf6kHsZRbsTdSr4pmJ+HuXU8XmyhDzM+mxzZdHzQZcyHPKMU1JQjz/t/zkML7LC
         8FWg==
X-Gm-Message-State: AC+VfDy/emK6JvfttYnSWhD0APJNsdd7o1VW5c/cuIHmRmHLaygv43DT
	iQp3F6u6HMOvFgkzN8kO0As=
X-Google-Smtp-Source: ACHHUZ46BQ3K9gzQ7cJPo8/KJowe2g5mNX6avWQEOC0XnZcU/OPBBS7o6/YbOlbJ9DYFXWuC3xaTlA==
X-Received: by 2002:a05:6a20:3d10:b0:10c:80a:480c with SMTP id y16-20020a056a203d1000b0010c080a480cmr4963821pzi.41.1686965545808;
        Fri, 16 Jun 2023 18:32:25 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id c15-20020a63724f000000b0053ba104c113sm455042pgn.72.2023.06.16.18.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:32:25 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Date: Sat, 17 Jun 2023 01:31:37 +0000
Message-Id: <20230617013138.1823-2-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617013138.1823-1-namit@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

Do not assume PAN is not supported or that sctlr_el1.SPAN is already set.

Without setting sctlr_el1.SPAN, tests crash when they access the memory
after an exception.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 arm/cstart64.S         | 1 +
 lib/arm64/asm/sysreg.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 61e27d3..d4cee6f 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -245,6 +245,7 @@ asm_mmu_enable:
 	orr	x1, x1, SCTLR_EL1_C
 	orr	x1, x1, SCTLR_EL1_I
 	orr	x1, x1, SCTLR_EL1_M
+	orr	x1, x1, SCTLR_EL1_SPAN
 	msr	sctlr_el1, x1
 	isb
 
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index 18c4ed3..b9868ff 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -81,6 +81,7 @@ asm(
 
 /* System Control Register (SCTLR_EL1) bits */
 #define SCTLR_EL1_EE	(1 << 25)
+#define SCTLR_EL1_SPAN	(1 << 23)
 #define SCTLR_EL1_WXN	(1 << 19)
 #define SCTLR_EL1_I	(1 << 12)
 #define SCTLR_EL1_SA0	(1 << 4)
-- 
2.34.1

