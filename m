Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587374;
	b=GwqH6TYC7FBJU2ULs0tIjLPvlt4mqiMFuUoZQqZ97UCz+ikz8wAEeM5KYexIyOuYXf+W
	 xkipkJsNDiiGkIQs4UZmHq+sGE39XJ6gQVTKNWGVe17xqR2ONri5gpND6FC16gvYqViwc
	 FlOX+heyQ9X1yA/FBsxRidVbeGixM6rt3sduSwnPzYL4HCqMhDtAWS5xHqGHn2SKeBy9m
	 2a0Gp88GFjqZ2LXiVmKG5i0OJB6pH0YrDFS8ng3z8HIKJCi6akB2ektrXbV0T+6666iah
	 mdDi3jBwDHZyU8NK4TDw8UhdiDmVNNhsjdEsaVV4+d/tjr1NGmKxGd1jcy7Hcl0wCjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587374;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=+3YNbw7npHYIz6vJpu6w5t/t1EQu1XAkIQnaB2DVcXE=;
	b=ygNULKWb03E4Gq/4IFdVaTgXpmcK7aUhc3V1UAQe7bFwNUK0XNxG54lS8V/XhQ6TgH9I
	 kSHMk1gGLze4ZpxvoftrF6dUuSg8iI5jQhbvjBrt6n1NwreZJTmlaHIEthStLV1XZpOH/
	 D/Hlrus7u7yUZfTaPP13pTIS5kBcv7ljCg442nL0XoLMmsGx/i/leuWGRCW05bV+BuvSh
	 ufiNc4y1aa2trLv3GJImJ1znP7+PlT7R7Ru93qJDE3vvpJjiFxkSeVf+HI3ZHKHANALs4
	 FaKX65biv2l14IOORFHLLRcq0Za8PwqlmWDa781oJtatpOcuf3NN025sUXZmqyNmS2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d4klhVga;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1DC60A261A
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:16:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF1DC60A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d4klhVga
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-386c3309469so1559990eec.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587373; x=1796192173; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+3YNbw7npHYIz6vJpu6w5t/t1EQu1XAkIQnaB2DVcXE=;
        b=d4klhVgaJDWC1YT66PV8x1JrKG2O6O6zJg1l3jM/5O7bM3Ma4rpboGY++0VbuNusHM
         tFdRfXlHvYvNp8UeIujgMPTlgyQcGoflppk7/Vh42QwPoUMK+rItLf2tZRxM7H1SZI7l
         R+p0inX+8uRSA76UWPJUds+Jl1Gcm+I4IEaRamMsVh+hH9gN3Pax0BdGBVDB4i/8lPRY
         0g/IB5Vm4Bcq6O+2cIuBAfejcaHzCjphsJrE8GoG8eHb5yRUZKBK/W/ZO+TrR392BB+d
         I3ykHTG0Qulh9xovkX13SeQW0JCZF82s5KoskhFAMlp+rNrkW7kuuTzijQYmPSnSROUd
         LApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587373; x=1796192173;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+3YNbw7npHYIz6vJpu6w5t/t1EQu1XAkIQnaB2DVcXE=;
        b=bc4nEiRCKUAb8PTpIVdGdrrBZRpUnwi/HsViJUobc6WoQ/uHHCHMBLbfpz3+TUa/3s
         RheFsaBJiVrRO8Q05YdmLvUvYwglEEy5OH2xfuDFXZqK7URzeR9amID6JWFHlpCmMOUW
         4tPSW/Qon8GNiqoDnl1AexPwkMnbzrxU/lw5WMD0Y/VSuiFuw4CzGndz+sdSor/vX0nB
         uV6S4biqRvyuFz/DhZ4u42liYsTN/BLP3wkhGT7nxrgaKguBv0/2tU6IQcXk2+DN4b9t
         8WdI27Cqp22nVSAvkZJgESb+1y4OAF68q3MRJyGagULh7vEZPLjEEvwNBigqF0prpUBb
         T//w==
X-Forwarded-Encrypted: i=1; AL+hErEC3Rt6LBNfaK0ZrCoWVgrlaI1hqOFZJmhn4MyP2lHaiwPLRj32BF6KUMLY9dHX9MI7rkf2Tnc=@lists.linux.dev
X-Gm-Message-State: APuU4Z/YFdpGrgDPPb1h2oytW6DQWo+1dfNN4vdvI6htCazGoiGFDj6j
	rLTejPkQpviT14gLc88MMGKHJ70IIyJBYRxLBvYxI1HlZnOuQZetKUro2hVTOl4phhpgizvWwLg
	unW97n98BuA==
X-Received: from dybou2.prod.google.com ([2002:a05:7300:e5c2:b0:384:c70c:3c65])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:d809:20b0:386:b070:6f1c
 with SMTP id 5a478bee46e88-386b0707151mr8742111eec.21.1795587372849; Tue, 24
 Nov 2026 22:16:12 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:01 -0800
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
Message-ID: <20261125061523.1540234-9-irogers@google.com>
Subject: [RFC PATCH v2 08/30] vmlinux.lds.h: Allow architectures to emit
 custom RO_DATA sections
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

Add an optional ARCH_RODATA_SECTIONS hook inside RO_DATA() so
architectures using runtime .eh_frame / .eh_frame_hdr kernel unwinding
can place unwind tables inside write-protected RO_DATA without leaving
them in unmapped rodata/data gap pages.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3eb732942d69..1bde7a2a19d0 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -472,6 +472,10 @@
 #endif
 #endif
 
+#ifndef ARCH_RODATA_SECTIONS
+#define ARCH_RODATA_SECTIONS
+#endif
+
 /*
  * Read only Data
  */
@@ -554,6 +558,7 @@
 	RO_EXCEPTION_TABLE						\
 	NOTES								\
 	BTF								\
+	ARCH_RODATA_SECTIONS						\
 									\
 	. = ALIGN((align));						\
 	__end_rodata = .;
-- 
2.56.1.831.g720f3f5937-goog

