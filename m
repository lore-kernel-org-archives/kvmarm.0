Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587377;
	b=Nf5rUeXtZpPwfhuydg+pLxKdwob044HPzJ7xVttDgdYigTK7pUbDHDItuU63CJ4EqN8v
	 O5yaH2BGxcoO+YDXiS1pN15E/VqbUgR6R001XXD0fqPM4fbC61bAH0AjuqM0CU03cxgze
	 7ZLwOIrgu6Tqy1BysQEepLDP8froTgxtadldrPSkFVia+KTjjYEjOBlcsYI94JmqPL3PZ
	 GKP4lt3t7bDXbr++8lHuXLkXjglDhAjf0xze2IaB6kQnhNo4qXu6JThpbVujOV6/wMvCb
	 dunQs+L4cWLPji2/GYBmRXM9R2AfmkHHLR7F1OE6EgrfVHTmViSusmXqiCmGLk9oLmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587377;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=GGDahMitB3LSpaFaJkVUo1Pzx9kbamS5IbDP2+gBQRY=;
	b=0Lbltz18MRD120V4gYNpv+Lzzt5rwM2J+H/xDMLvJiO1LAYpkjRaNQptAqK5onVG1VjG
	 KdS5gkWm03wlSomCBpeHWJ/b0axAtAqCPB6dStiiQ094/hPCGF1Hie7d7HHBiAFdjfiRj
	 +smsq/och5USOyvZDH9H9vd9FKUyUGdk6Fzyqx3twWEvI0E7k2fWcUaZ8T0eExMnTjRhK
	 J1AGxl4SpO6DPGloICIo3HyVlJtphCzlN6iuRxNSNOih3FJsSuvC25aWeqtuBXGsAIDoc
	 V8CZjS4I965QofmRopPKlBGeVWPewS6JHM1WtBXzzGhjWdzTDK6KYmRMD+y7HK0sjKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=moqQdJUI;
	arc=none smtp.remote-ip=74.125.82.69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C9160A381B
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15C9160A381B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=moqQdJUI
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1b3b45597c7so409815c88.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587375; x=1796192175; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GGDahMitB3LSpaFaJkVUo1Pzx9kbamS5IbDP2+gBQRY=;
        b=moqQdJUIReRNbA8CMjwP+P3b5n2gAx+4dRqAgVKQaD1ogQYe5swNCmo7067GO4JdO3
         it+X0W3BB+kHdQ87qZjKHYF4TzP4z3o3HAyWgLXokTANU5O9w/ytT8IBnV26+rdPn7ts
         DLecpi1dH1+0TK22sSDOetFLKLsUTcJ0hwEfgymc4Dx5qeDqdddDcYKh9FlsI89NoNJv
         ijmA9yB+Qo8DK0v7/wozHpqvW4cOHrx13Vj5PrxEOHVTS25AdH31/svlh1KFh1hL3GNf
         oW3MXiAyJv1pO/54hTxD88YIWIpi3CjZiFC2rkQxlVogpP9eJMmexT4Hurad5t6Bh8iO
         IBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587375; x=1796192175;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GGDahMitB3LSpaFaJkVUo1Pzx9kbamS5IbDP2+gBQRY=;
        b=rC8zN7+CGYpU5Smgz2MQSUzHUB0J4pY96VvXPt3uJjWHqxB+HwJHqEGmCk87h67ODY
         j/UtYnTLGdqImqO2nghZY9wbpNxR+Hjy52lZm9h72kP6R0bqWvcyGyu9cvKFywaC75A6
         eog5MAw59Gx+7k3Kskvo6h6dRUHrpa+qJPV5ViUYksxNybCb5ylDIAbtQcQlI3XURpBD
         WsJncBOKdPsm2cfw4pbKPs/v+2uzF5jX3u/gJFIG2flLL+MUdN27JAelusbSfIIlIwvl
         tGQRWxPWrGlP2lVCtugRmQ/C2Xb1sfQ7tXE847/GtZjIFdNfDEKmaPzvYkKOMRzqpqLV
         r97w==
X-Forwarded-Encrypted: i=1; AL+hErE8QgpH4nxIELKa5Nx2oUD9aa1KSBojAeaBE6Iz2a3fnrrxdSOw/5RWSMCLtJC+vsS0MEtv/08=@lists.linux.dev
X-Gm-Message-State: APuU4Z+vuZrtpIvj2lyXdfvykjubJngBQemW2oxZzvGcxuiqzDHZuIw+
	9xEOynFDXWsaMWlhUblNm9yYV330XSY7dTdjfov8hLwdKcD74UPkz7FWzWdPeovy4SunQgzWpND
	zdlw51yaudw==
X-Received: from dloo27-n2.prod.google.com ([2002:a05:7023:a5b:20b0:1b5:8761:cc11])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:b902:b0:1a5:9abb:fdd7
 with SMTP id a92af1059eb24-1b556877a2bmr15589113c88.9.1795587374885; Tue, 24
 Nov 2026 22:16:14 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:02 -0800
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
Message-ID: <20261125061523.1540234-10-irogers@google.com>
Subject: [RFC PATCH v2 09/30] efi/libstub: Disable unwind tables in x86 and
 RISC-V EFI stubs
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

Pass -fno-unwind-tables and -fno-asynchronous-unwind-tables when
building x86 and RISC-V EFI libstub objects so enabling kernel-wide
asynchronous unwind tables under CONFIG_UNWINDER_DWARF_CFI does not emit
unwanted .eh_frame sections into the standalone EFI boot stub.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/firmware/efi/libstub/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index bbab12b8eb4b..19c2822eb302 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -19,7 +19,8 @@ cflags-$(CONFIG_X86)		:= $(filter-out -mcmodel=kernel \
 				     $(PADDING_CFLAGS), $(cflags-y))
 cflags-$(CONFIG_X86_32)		+= -march=i386
 cflags-$(CONFIG_X86_64)		+= -mcmodel=small
-cflags-$(CONFIG_X86)		+= -fPIC
+cflags-$(CONFIG_X86)		+= -fPIC -fno-unwind-tables \
+				   -fno-asynchronous-unwind-tables
 # Nothing enables IBT while the stub runs, so ENDBR would only take space.
 cflags-$(CONFIG_X86)		+= $(call cc-option,-fcf-protection=none)
 
@@ -29,7 +30,9 @@ cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
 				   -DEFI_HAVE_STRCMP -fno-builtin -fpic \
 				   $(call cc-option,-mno-single-pic-base)
-cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax
+cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax \
+				   -fno-unwind-tables \
+				   -fno-asynchronous-unwind-tables
 cflags-$(CONFIG_LOONGARCH)	+= -fpie
 
 cflags-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= -I$(srctree)/scripts/dtc/libfdt
-- 
2.56.1.831.g720f3f5937-goog

