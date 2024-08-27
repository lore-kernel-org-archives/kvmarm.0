Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C811C68AE
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 13:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764117; cv=none; b=Qgpmwg5zWrAHAgmtAH5z8ZdfZNDUhmVtYVmmCsWjna2L5Y6tZ1rZ6lpb3LzXbNlZbYhC966WCsTGzM9xTokgAnc7R8+TWop0UnHfImwQZcHW3WPYzTYbfM2juLXpriBFQAx3PQM1MZFXwvXJzjrwz6+ObtWW+rIjXlxLPzwfbDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764117; c=relaxed/simple;
	bh=DKZ2PjINcn2iG38PL7e/2uFqlx0qNbPScgOvJPCEMaI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fX/boZfyHsKNMrsow9qJgYhTQmCGz+OZuQztV83y7l9UnDjge2UdcnRmqyzvcFCtnkBOC2sj2zpL3ziJMG7LU4t2373vkAUgs3J0r+Bscj9D1L7EU+niFzyasY1DHPeP9IVVlG6OV0Hh9uu2BR7M15HqkvJMAPdPWDJ0s8IMQPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NQ1sDj+U; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NQ1sDj+U"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-428163f7635so46969155e9.2
        for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 06:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724764113; x=1725368913; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KqRcAFW8nUzDZ1FEN66jGQtx4LYaSNAvAG+5szB8q0=;
        b=NQ1sDj+Uy0a3iVgNAAEUIPJcoFmwAjmY+sauzUBt3tkEJIPMfI5CgmYn9wWenQENai
         WygWT3MvyKZXgsA/BrWhRrkb8pKJXwiCnXvTD+k+zeaNuHXx34a62+k5m8WdThQvsQGF
         sOS5gFBN3MTK6lI4j2Kq0jv76Yd3tn9iQFFGmgW1EBIL7qOfdZe8SuXzUKlfnzEYJZe7
         X8joPa1leVSeMPwlcT1epKHBVcc0XArtiYFPJ5QXVVQ13yawsSM1/ArhlFRCmJBScQdo
         4BjSZgqHFtptzEou9poqRlo8T2MDTw+IMCq/kJhR9izKBc5ibT7ClJB4D3S2MuOSx90L
         j/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724764113; x=1725368913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KqRcAFW8nUzDZ1FEN66jGQtx4LYaSNAvAG+5szB8q0=;
        b=Sym7BSqqcmyzAgutYbrUmnPrQHknYUNFSI9JRAwZgIlsd7Sby37b/V5CESSvsPH4F7
         kMlpBWUm3QzrdIvJNo/B8xFc487Ixj1ELw5EYfWCtbmHAGkrtn/rPN6imkDSmZCFHzWS
         BzBpmjWBAl8T72AHhU9l+t6dAaf+Qhuohh13bvktuwD543CATaI5vfIKZ6ayckUxvx5G
         2wIirztsYz2Np73XP17sEI8aME5JgOBCjSnYP2Aon9Ncl+qnJO++W0mZOUNx/P1jCwkj
         fXGbln1Nci3KgAKcskEzlNDpOYVNk9Wr5SZDmsop/eqyMXsEj2Pu654vKJlxrMvqIMv8
         lS9w==
X-Forwarded-Encrypted: i=1; AJvYcCUpJBYLmlX4HrwKJiS3Aigk2Zt7uQLjaJu4mTHWXYoHsv0K2FihwNqPn7ujtLZxuEqexvAnGA0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyG8WlCUn6J4PTgQ1gT4sfR7TuL9dDlMbjlYe3NxIeU6LVHMUcX
	C1zP4G0oEhWAf1avUVMChXPaxQ7lb5/howJbYS98ttdSjY9L5h/lfUDzu+NpjxU=
X-Google-Smtp-Source: AGHT+IFlcKOK92s/UxJ1kIhXDpRFVT9AfPK9EVRV4+49EEVGWs+1h7/ccWiUMy3fn1r+RZMCd6eVbg==
X-Received: by 2002:adf:a351:0:b0:371:7e46:68cb with SMTP id ffacd0b85a97d-373118c6b95mr7484089f8f.50.1724764112624;
        Tue, 27 Aug 2024 06:08:32 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3730813c1e3sm13012590f8f.35.2024.08.27.06.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 06:08:32 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 380E35F9FF;
	Tue, 27 Aug 2024 14:08:30 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	arnd@linaro.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 3/3] ampere/arm64: instrument the altra workarounds
Date: Tue, 27 Aug 2024 14:08:29 +0100
Message-Id: <20240827130829.43632-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827130829.43632-1-alex.bennee@linaro.org>
References: <20240827130829.43632-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is mostly a debugging aid to measure the impact of workarounds.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arch/arm64/include/asm/pgtable.h   |  2 ++
 arch/arm64/mm/fault.c              |  9 +++--
 arch/arm64/mm/ioremap.c            | 11 ++++++
 include/trace/events/altra_fixup.h | 57 ++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/altra_fixup.h

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f4603924390eb..26812b7fc6d93 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -679,6 +679,7 @@ static inline bool pud_table(pud_t pud) { return true; }
 
 #ifdef CONFIG_ALTRA_ERRATUM_82288
 extern bool __read_mostly have_altra_erratum_82288;
+void do_trace_altra_mkspecial(pte_t pte);
 #endif
 
 static inline pte_t pte_mkspecial(pte_t pte)
@@ -692,6 +693,7 @@ static inline pte_t pte_mkspecial(pte_t pte)
 	     (phys >= 0x200000000000 && phys < 0x400000000000) ||
 	     (phys >= 0x600000000000 && phys < 0x800000000000))) {
 		pte = __pte(__phys_to_pte_val(phys) | pgprot_val(pgprot_device(prot)));
+		do_trace_altra_mkspecial(pte);
 	}
 #endif
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 744e7b1664b1c..6cb3c600cc56a 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -45,6 +45,8 @@
 #include <asm/traps.h>
 #include <asm/patching.h>
 
+#include <trace/events/altra_fixup.h>
+
 struct fault_info {
 	/* fault handler, return 0 on successful handling */
 	int	(*fn)(unsigned long far, unsigned long esr,
@@ -1376,6 +1378,8 @@ static int fixup_alignment(unsigned long addr, unsigned int esr,
 	u32 insn;
 	int res;
 
+	trace_altra_fixup_alignment(addr, esr);
+
 	if (user_mode(regs)) {
 		__le32 insn_le;
 
@@ -1414,8 +1418,9 @@ static int do_alignment_fault(unsigned long far, unsigned long esr,
 			      struct pt_regs *regs)
 {
 #ifdef CONFIG_ALTRA_ERRATUM_82288
-	 if (!fixup_alignment(far, esr, regs))
-	 return 0;
+	if (!fixup_alignment(far, esr, regs)) {
+		return 0;
+	}
 #endif
 	if (IS_ENABLED(CONFIG_COMPAT_ALIGNMENT_FIXUPS) &&
 	    compat_user_mode(regs))
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 8965766181359..d38d903d8a063 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -5,9 +5,19 @@
 
 #ifdef CONFIG_ALTRA_ERRATUM_82288
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/altra_fixup.h>
+
 bool have_altra_erratum_82288 __read_mostly;
 EXPORT_SYMBOL(have_altra_erratum_82288);
 
+void do_trace_altra_mkspecial(pte_t pte)
+{
+	trace_altra_mkspecial(pte);
+}
+EXPORT_SYMBOL(do_trace_altra_mkspecial);
+EXPORT_TRACEPOINT_SYMBOL(altra_mkspecial);
+
 static bool is_altra_pci(phys_addr_t phys_addr, size_t size)
 {
 	phys_addr_t end = phys_addr + size;
@@ -25,6 +35,7 @@ pgprot_t ioremap_map_prot(phys_addr_t phys_addr, size_t size,
 #ifdef CONFIG_ALTRA_ERRATUM_82288
 	if (unlikely(have_altra_erratum_82288 && is_altra_pci(phys_addr, size))) {
 		prot = pgprot_device(prot);
+		trace_altra_ioremap_prot(prot);
 	}
 #endif
 	return prot;
diff --git a/include/trace/events/altra_fixup.h b/include/trace/events/altra_fixup.h
new file mode 100644
index 0000000000000..73115740c5d84
--- /dev/null
+++ b/include/trace/events/altra_fixup.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM altra_fixup
+
+#if !defined(_ALTERA_FIXUP_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _ALTRA_FIXUP_H_
+
+#include <linux/tracepoint.h>
+#include <linux/io.h>
+
+#ifdef CONFIG_ALTRA_ERRATUM_82288
+
+TRACE_EVENT(altra_fixup_alignment,
+	    TP_PROTO(unsigned long far, unsigned long esr),
+	    TP_ARGS(far, esr),
+	    TP_STRUCT__entry(
+		__field(unsigned long, far)
+		__field(unsigned long, esr)
+	    ),
+	    TP_fast_assign(
+		__entry->far = far;
+		__entry->esr = esr;
+	    ),
+	    TP_printk("far=0x%016lx esr=0x%016lx",
+		      __entry->far, __entry->esr)
+);
+
+TRACE_EVENT(altra_mkspecial,
+	    TP_PROTO(pte_t pte),
+	    TP_ARGS(pte),
+	    TP_STRUCT__entry(
+		__field(pteval_t, pte)
+	    ),
+	    TP_fast_assign(
+		__entry->pte = pte_val(pte);
+	    ),
+	    TP_printk("pte=0x%016llx", __entry->pte)
+);
+
+TRACE_EVENT(altra_ioremap_prot,
+	    TP_PROTO(pgprot_t prot),
+	    TP_ARGS(prot),
+	    TP_STRUCT__entry(
+		__field(pteval_t, pte)
+	    ),
+	    TP_fast_assign(
+		__entry->pte = pgprot_val(prot);
+	    ),
+	    TP_printk("prot=0x%016llx", __entry->pte)
+);
+
+#endif /* CONFIG_ALTRA_ERRATUM_82288 */
+
+#endif /* _ALTRA_FIXUP_H_ */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.39.2

