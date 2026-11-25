Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587418;
	b=kSkvGmt8k4QlWHWwTvwiWgZ88MVOxZpiaI9WRvqXi9sJnzbQVI7ALigCBaXZbgOMKndK
	 zQ+cQyZuJAjN606JTbMKoaHKlPGAok07VYXVHX4ErBlIQPRtSWrB1NQq0qAgi+jm00I+o
	 y6IHcRPBbpxU7X6iBUuH+jOK0q/z62mh8DcCrpovh0+64TwZQZm0Q6cPbRSK2h8h5DvZq
	 k+N3JmaL9qFVxwsLEiD1+j4vtlzdCw0ISvx+810AcsrT5f6QRHcMzh8L28KhpPB4LF3Mk
	 zfiySMowYWhMxkVym+ovnjkFeCD7xnbhGj5HPks+WkihooSGdthcWny4ANC/yiizhAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587418;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=B0szZcyaY7NP1HowgKnJWSVhbM1uN8jco8rE2rfxzUA=;
	b=qN3XG22u2G1OS3Bp+7VFuo0BAeD1gVdIE7MoaDUmS5OERzJ9CLisj+gMGFgX342EbLYw
	 sjtkg7jzaQpVkEtoFyWdeUsgS+kH+8dJxLpBv0kc3wRtiDPOgxW2MCnGdahztiKtr5QaX
	 cDFvTt8zs79KSq99WNkjKKYyzcczPkUrwqQXf+2usJpi4YTQqV7mzVprU4Y2NXBjCRMV9
	 wHSJr+y0YJUVRQBuGYR4//tMZsf2yqjtagPetVR19IdTpoJdaJcfHYgnPNwnLH5nZ6XbT
	 dEdZP9zvU9V78yRPkD398wYgvnvJcvz9sobu5ICNLSM+8Fe9YKc/ba50Ref3kzKMy3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OYtSOtL4;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A675606DE7D
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A675606DE7D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OYtSOtL4
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a0619b1fe5so4489390b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587418; x=1796192218; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B0szZcyaY7NP1HowgKnJWSVhbM1uN8jco8rE2rfxzUA=;
        b=OYtSOtL429vx8h9e8KmJ/oGhT4gkjeQ021DBdoDdRU0/PX54D7Rsp3lWJGAXyRL5mc
         bxCKAhao6ehgV/HDPNQ6tilImjkNYbBPOQ+CWdUdZgyOlaPtyLoKZZjAMSrmjVbdpBfi
         y6hrj6DUVXDXqpxh43Byxt5zWGMDLraUXXpyNClQC1ZM520uXfAdqLfry5TISAOxZiw5
         LKi1JFdlFSTj279EPNDz3stCVUDCoKhxstL4+T3Er9Nc31JKpdTMHQBfx4q85PlFf4ul
         fuOrvHqUZTJEP77DP5QY8LfmCtQBEGpg3gpMYg7eVHD8zJ0jdYCDA/nYS387hEjaN9EC
         uLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587418; x=1796192218;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B0szZcyaY7NP1HowgKnJWSVhbM1uN8jco8rE2rfxzUA=;
        b=ms/FNa4LtBxWAqpaYuAEY/arbAEEmuxr+5mligO7I7zIHyib1LBQXlJRO25gOt0DU1
         j35Nn4VOiuw5pi3UPaDpGtYotxUr5OzdzVqxWLz5YW55U77qV/6RSFzyyUcb7kms7kjk
         vwX21giR7K3a6iypS9p/EMzbaEWUEXJiPy7Dvsse4HapAXe6MIrI9EpmNcGLOOervWiJ
         eON/BosG8fGJbre+Puauulw9G9IFz9VVwqa1evwKfLHyNjQPA9m3pTfS4MrodGQebh91
         JITKDRSBakyO25mtpuNjJ7thbD325oivuMILLq1+rbF/ZNBu76Ja7drNSntKV2V5JLVK
         H8dg==
X-Forwarded-Encrypted: i=1; AL+hErF86BIv2wHS++2upoFehemFgmfqIWWvevQicItbztGgeuwpTUdkjv8YdxKSiEVoeMMsemyVC3c=@lists.linux.dev
X-Gm-Message-State: APuU4Z/XtUQnB5sgm1IM1J1EsjPuUZEMI3w28BiN6ZJMRtvHs1X3HgOg
	HefCjSxJ7xkvMn5KC+8kkjsxT5PxDdI9AetfFQMOr8ehsjjKTZoa2ekt/jLdOCtr9HI7cgYsuLk
	NK9lX+6nWCA==
X-Received: from pgin21-n1.prod.google.com ([2002:a05:6a02:8795:10b0:cdb:932c:948b])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:8095:b0:3dd:85a8:cac8
 with SMTP id adf61e73a8af0-4014c949c92mr14160775637.31.1795587417428; Tue, 24
 Nov 2026 22:16:57 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:23 -0800
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
Message-ID: <20261125061523.1540234-31-irogers@google.com>
Subject: [RFC PATCH v2 30/30] MAINTAINERS: Add DWARF CFI stack unwinding entry
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

Add a MAINTAINERS entry for Minimal DWARF CFI stack unwinding covering
the core .eh_frame / .eh_frame_hdr bytecode interpreter and KUnit tests,
the user-space PT_GNU_EH_FRAME VMA unwinder, the x86-64 DWARF CFI kernel
unwinder, the build-time .eh_frame minifier and analyzer scripts, the
standalone tools/unwind/ CFI verifier, and the deferred user-space CFI
kselftest.

Also add arch/*/include/asm/unwind_user*.h to USERSPACE STACK UNWINDING
so architectural unwind_user headers on x86, arm64, riscv, and future
ports are routed to the user-space unwinding maintainers.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 MAINTAINERS | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 44540a1eb2b8..0584279d745e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9496,6 +9496,21 @@ Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 F:	drivers/media/usb/dvb-usb-v2/dvb_usb*
 F:	drivers/media/usb/dvb-usb-v2/usb_urb.c
 
+DWARF CFI STACK UNWINDING
+M:	Ian Rogers <irogers@google.com>
+L:	linux-trace-kernel@vger.kernel.org
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	arch/x86/kernel/unwind_dwarf.c
+F:	include/linux/unwind_dwarf_cfi.h
+F:	kernel/unwind/dwarf_cfi*.c
+F:	kernel/unwind/user_cfi.c
+F:	scripts/eh_frame_min.py
+F:	scripts/min_eh_frame.c
+F:	tools/include/linux/unwind_dwarf_cfi.h
+F:	tools/testing/selftests/perf_events/unwind_user_cfi.c
+F:	tools/unwind/
+
 DYNAMIC DEBUG
 M:	Jason Baron <jbaron@akamai.com>
 M:	Jim Cromie <jim.cromie@gmail.com>
@@ -29300,6 +29315,7 @@ USERSPACE STACK UNWINDING
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
+F:	arch/*/include/asm/unwind_user*.h
 F:	include/linux/unwind*.h
 F:	kernel/unwind/
 
-- 
2.56.1.831.g720f3f5937-goog

