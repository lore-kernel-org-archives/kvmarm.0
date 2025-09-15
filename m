Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE3B2C1581
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 21:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973300; cv=none; b=cyE288qsKtr92t9cxiK+DD2qFg6o9cxqLDQzgnJ2bMbuwff1vGElIg4Y0ppg9c+8qu8G5qIvArlc2JEdqBhZM+udHN/Rr0HjAVv2foQ5NDjotnwIIK1kowtcgZuzOmMxyBFoI3dbHbPTXez31JlOlgAjLsGrhESDJsBNaEseRk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973300; c=relaxed/simple;
	bh=4pFJ7PlEmesvXr3cQL2H05B7Cqj5Q/UV1hXOSPL7QWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwkZDKToLd3TZGpVSjd/LztBi4HcGTJs1xIKv+ou0/IzeOFNPTBxvSAXsCEE7J4bhs7wOnpS526QxyxYei+TYh25J4/G4J9PdHdVQfKFWsk8ZZh46sNsxlFcttuH5WRToxTKHriS1iyeptfWIIGGA3kcR7aE0veLpjF/3fZE0ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=gCAkT2to; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="gCAkT2to"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-78393b4490cso13987126d6.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757973298; x=1758578098; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89dl8JzAtkZ/mNSRMgjqLcxEDRNkD5DRSw13EhLsQUs=;
        b=gCAkT2toBUuglqdmhyD4P7f4VXPx7XoW2v8U7z05R8OqVkgVyt0g8N2h84l4Zte/2q
         9ukI0pTnU0VbzFWZoWxWKa5vD4hek8bb+DXnsUd19WyzL38bVPzFVAgPyvGrkt+fAMXo
         D+BtaDu1nxizNd0GkbBOmHXoFuJCg+vudVdMJqt1vHlVJNspx8+lauPUTt4I+oopW/+j
         ZvobIy/zjla0QGFUbkt/AJbXF2iYSFmdwVKYwS9e39M7FqGzPbKvTEa8wBxq8Oa3mXcS
         dwXYnJIFjUnltaLygMgt8T7T6quJUTw+mTibmkEv1oBkRBqChrJ/XP6tX+LMmW1fQR9N
         z2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757973298; x=1758578098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89dl8JzAtkZ/mNSRMgjqLcxEDRNkD5DRSw13EhLsQUs=;
        b=E9UL1VT1FvIHGOKokH4wIC8GGwq8Ke1sKZmgmDQxjQkVGSNVLK4/jRTWwK6qrZ8QTA
         Vku41w5pvMkCnaElaQNJbknErTla01Qnp+H+SfH52NNQS/AOtrvzxwWn+BdiO1X87rMf
         0LJMTpaH8M+CT9RIBRKTwUS1b1lBwblYzxs127s65ZtZZSqpDWLjVJtIG4iGZLW+Ah7o
         gvem0N37cF8UhukHoSaohpZFpwnpjfdEM8AMKpbvKfnkrR5PZlT30kbeN2J3gE9ArD2M
         mrNcl/o8gXmBdzeZIu/8Vk/3oseaPSQGkuDMSScpiVn768v4sHOC9zRRbr/FtG5/PYxq
         L5PQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4qm62HjEFD0rG6O06n3/KL3QQtcSuWtenSCm2w8Kl73m1FwmnTRt1W2mK6bmOv2D4h1OLpl4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwE0Ias+7uirjB+9okbtIPVZT7jSDVfnNnrtPKPZdYQC/FTFRFC
	2tqtBsxZiGnKnPfM96ST9HMqfBoRiC0hzG2ocAqyzD5rIBgt+1WPfyk4x6BwMHW7vvI=
X-Gm-Gg: ASbGncsPLOO8dTZYpgmmefmO23nFl4dZbhivPKs2DofFnD2YLtOVfeSMlnfx2Lt2Eqy
	eN+FnBe1Gp6wTA782LdSldV6BMLxvb24z3AAFtgYb09tVrFEiYeXyJbt4PpGY3uD1Za5id91gwL
	Orj+fSDMpPfzVJz94FJhPFiRW43TX9ucNIo3/wiJNHXqco/A2jKwsXs1aZX5WD/DxuOGyeWa2CV
	tnNkMv+2660xYtCkEtEjNwhpWto/a3/APMsofyIH9rnsaaT66FB7KuoxANOce3+CdP182bRChFN
	zy5Vm9AhSIhx/PeaT0+ZhYF/FYaooSRJZxOxLza+Ss/otAl3YjTXS0S+iG792oEXdEBIsCaESVk
	YqEtyavfA5UzrVoqLwkAMgMHStjgxz3zJevoK9jxtR6RyNxtA61prc8k3rMoWve3W+NO2aePtGb
	sGgmc/O9pkJ8iI8inp69ScmfTDNm0a
X-Google-Smtp-Source: AGHT+IHUQeSFbd5uMK2kqS+/fPHkKVOSrTvADLumpaByKCM49cbxczNpu9T8V9R7sDVfxCx22JSMZQ==
X-Received: by 2002:a05:6214:5009:b0:780:600d:b93a with SMTP id 6a1803df08f44-780600dbc1bmr63952606d6.41.1757973297685;
        Mon, 15 Sep 2025 14:54:57 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-783edc88db3sm25104796d6.66.2025.09.15.14.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 14:54:57 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 4/4] arm: Fix backtraces involving leaf functions
Date: Mon, 15 Sep 2025 23:54:32 +0200
Message-ID: <20250915215432.362444-5-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When backtracing starts in a leaf function, it'll cause the code to go
off the rials as the stack frame for leaf functions is incomplete -- it
lacks the return address, likely just causing recursive exception
handling by trying to follow an invalid pointer chain.

Unfortunately, -mno-omit-leaf-frame-pointer isn't supported for the ARM
target as an easy fix. Make use of -mapcs-frame instead to force the
generation of an APCS stack frame layout[1] that can be traversed
reliably.

As Clang doesn't support -mapcs-frame, make the stack walking code
handle this by using the (old) more compact standard format as a
fall-back.

Link: https://developer.arm.com/documentation/dui0041/c/ARM-Procedure-Call-Standard/APCS-definition/The-stack-backtrace-data-structure [1]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>

---
I failed to build KUT with Clang for ARM for various reasons, the code
is clearly lacking Clang support for ARM, so I doubt this fall-back will
be needed / used anytime soon.

 arm/Makefile.arm |  8 ++++++++
 lib/arm/stack.c  | 18 ++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index d6250b7fb686..7734e17fe583 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -39,4 +39,12 @@ tests =
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
+ifneq ($(KEEP_FRAME_POINTER),)
+# Force the generation of an APCS stack frame layout to be able to reliably
+# walk the stack. Otherwise the compiler may omit saving LR on the stack for
+# leaf functions and, unfortunately, -mno-omit-leaf-frame-pointer isn't
+# supported on ARM :(
+LATE_CFLAGS += $(call cc-option, -mapcs-frame -DAPCS_FRAMES, "")
+endif
+
 arch_clean: arm_clean
diff --git a/lib/arm/stack.c b/lib/arm/stack.c
index 66d18b47ea53..b2384d8eb4c1 100644
--- a/lib/arm/stack.c
+++ b/lib/arm/stack.c
@@ -8,6 +8,20 @@
 #include <libcflat.h>
 #include <stack.h>
 
+/*
+ * APCS stack frames are generated by code like this:
+ * | mov  ip, sp
+ * | push {..., fp, ip, lr, pc}
+ * | sub  fp, ip, #4
+ */
+#ifdef APCS_FRAMES
+# define FP_IDX -3
+# define LR_IDX -1
+#else
+# define FP_IDX -1
+# define LR_IDX 0
+#endif
+
 int arch_backtrace_frame(const void *frame, const void **return_addrs,
 			 int max_depth, bool current_frame)
 {
@@ -27,10 +41,10 @@ int arch_backtrace_frame(const void *frame, const void **return_addrs,
 	for (depth = 0; depth < max_depth; depth++) {
 		if (!fp)
 			break;
-		return_addrs[depth] = (void *)fp[0];
+		return_addrs[depth] = (void *)fp[LR_IDX];
 		if (return_addrs[depth] == 0)
 			break;
-		fp = (unsigned long *)fp[-1];
+		fp = (unsigned long *)fp[FP_IDX];
 	}
 
 	walking = 0;
-- 
2.47.3

