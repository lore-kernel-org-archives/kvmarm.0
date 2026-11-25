Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587408;
	b=Z/6knIsEikeLlVS9IYGIB5mXhsCMBtwKzQ4MtZDJlDcU0MaWu21lvCIw3oAP08PMxN9d
	 UMTaITueowAeQrQVu+tV2UQ921zS8ygO2zRcP7GMj67ggZH6rc4DRhIpoTVADoItWcDbK
	 dXIWFlQvSA7nvuBUEBgNGLssJYgL6Shy4tPpMJUssFRyqVA1WJdt841t4pIX2sRmTqLXD
	 slDCRwng7gYVKFH6TXGB7XHhGu1SLdGcQzFizkVOC4HhUY+zSlwMJCVH9zXm5uz2u8okA
	 XguaAYuMDarItys6hnUmjBPA4QAIBqdCqfDZy89Ryb7TRgQ9wTvD8xbJDk0003tjyVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587408;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=XJ5Bj2HUeqnSIN+0jmezTl4ea1LIGCfrIoPbd+y7XVY=;
	b=d8ziozPFF0tQP1ft4D7LpTl6Wvm/pGKHIORzQf33inWfMxvwLvtFfQs2dkQD1BT1HXzx
	 Cz8CNz5DiRKu9Wz5PdZcsFBME44QyFMU2Nby+lznM3JrfPREVrp8nYF1hX1u/xqslaVI/
	 LFUn25Kcxh5ZVp9g2yzkPWn7lcjuAh8JB2nwTzdPxXX7wGVxqCSHx1jfJPebdvqXEwwnj
	 3zEKAz+uU7BblTVECRh3FJtTSZu+jRb93U3imBl02LX1SJdqZoMiekvHOTqcIj7NQZ51a
	 pBzVqcmHPlVfDKSAGi0TJulm4D0ipK1vNr2cXpW5ISI4sGa3m1j9rI8tRfVzNo7OVvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XyMjmpk0;
	arc=none smtp.remote-ip=74.125.82.69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A59607AC05
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66A59607AC05
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XyMjmpk0
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1383723dfddso5633034c88.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587408; x=1796192208; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XJ5Bj2HUeqnSIN+0jmezTl4ea1LIGCfrIoPbd+y7XVY=;
        b=XyMjmpk0p1sQI6umoHMQ6AksU8ombyl0wjvSiZmXtWVOGLLeIEWmVh4oRLMKyOVRI2
         e7g6JNTy9UDczToDW3ZOey+JdR04xMO/RqmccymmQhn3YVDoaOBFujBZaiRpLVUIDSf5
         SIO5ii3Shp9TPEalvrOovR1iWaYqusZjgMWtKljhzxIUrNdbEyLx/AWKmJ7VjNLvX70V
         /8nA2WOPM1M6PdR+Hxw9eJFMqNM6x7JgYKporglrxCHwWe27qMTzWPkYm4DF0I+iWDFQ
         39AK7ftCAA9I4tmfjEp9mIdJJLwOOFk1vKqSprXvr6iqE8rA0Wgp9cGGT2w55+St06Nv
         nyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587408; x=1796192208;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XJ5Bj2HUeqnSIN+0jmezTl4ea1LIGCfrIoPbd+y7XVY=;
        b=TVzKt4vVT0tOhFWurpWrYRD4XoVScuZ3w1qaYWoxLInh/CDvOcKWJxWqJDsYdVV6Tn
         WEvxFU/UEc0Hke+Pn1y9S7y9mp+NhnTRfiIu9o43B8VGIJQGnq8tykp4EKrJ+m7Jvdky
         t6SMvCMlocxTS53HVV/Nza5+i+lA1vE/pRohvWQ2eQZO3b4BhZRqEkqmwo2uQfmcNrOd
         YFG2rv6itPu35vLoHJIyxALW7Xb6WCMq0BEqlqeBC6MzTKrDG7BMjh6R2F1m5RoEWkhk
         y6ho/bJSKfYjQGDHaSf9uvvSQLW4gab7qaRyROqIVrfn+SF8aR8JwBzViJi5xWZdZTAw
         Xgdg==
X-Forwarded-Encrypted: i=1; AL+hErHyrdu2kaIeLU7esNTkRqZX5Q29092+HIWGfWyjlshEKbd4EPXmEKwwQOx9vxKpJ9Y3fxp8294=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ihyrob+CBc1chvGW4QpTxi4LIKqwRQqVsEldDXWP2cx8G5DJ3
	/iBN3IkJwVnhl18G8W6XS79VMeLr3WmKK03Z7yDDnkNLLwUZIWAC7x58i2rEwmq+vyDDJ13jOhS
	PwKDXsM4wUA==
X-Received: from dlar8.prod.google.com ([2002:a05:701b:21c8:b0:1b5:345d:ed30])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701a:cc88:10b0:151:6e80:ba7e
 with SMTP id a92af1059eb24-1b5567dcec1mr15970822c88.4.1795587407220; Tue, 24
 Nov 2026 22:16:47 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:18 -0800
In-Reply-To: <20261125061523.1540234-1-irogers@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261125061523.1540234-26-irogers@google.com>
Subject: [RFC PATCH v2 25/30] tools include: Add linux/uaccess.h stub for
 userspace tools
From: Ian Rogers <irogers@google.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a minimal tools/include/linux/uaccess.h providing a no-op
might_fault() stub so userspace tools under tools/ can compile shared
kernel code that includes <linux/uaccess.h>.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/include/linux/uaccess.h | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 tools/include/linux/uaccess.h

diff --git a/tools/include/linux/uaccess.h b/tools/include/linux/uaccess.h
new file mode 100644
index 000000000000..5a9e6bf4cfb5
--- /dev/null
+++ b/tools/include/linux/uaccess.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
+#ifndef _TOOLS_INCLUDE_LINUX_UACCESS_H
+#define _TOOLS_INCLUDE_LINUX_UACCESS_H
+
+#ifndef might_fault
+#define might_fault() do { } while (0)
+#endif
+
+#endif /* _TOOLS_INCLUDE_LINUX_UACCESS_H */
-- 
2.56.1.831.g720f3f5937-goog

