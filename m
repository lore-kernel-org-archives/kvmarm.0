Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587384;
	b=fsdb4/UYJkFeonRlv9Eh/yDfcjQ6KoihAqSsVRSBR5nQz527WqoTxvVsB+rzX8ESBHP5
	 sMD8FHNGqHYC1ByZOh+ymWnJbiuRQu9M1og1GkK9Y5zN2ur5Q2xTR2i0arQGW85ty3JSL
	 eRCdVt96+7QYcaO6bI69JMMdOZEb/wNZgfjCGc6LSxm9AFUwi2Y/iuSFmJhDH+9Im1/yG
	 5sddAjk8cQpJYA/S5DorP3aCW67xChrUu3nRUDiTHik0rKWEOQQQ7PZkavcZADvzx5umY
	 RXFLVtkZBbXrdpT11ROJmY6DfwX2rWsGj2IYEROX4wPPUM9ZnAqQsnQGuoaro1OeQuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587384;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=8IYxPCQoD7cmdiQr4ia+kH+yRcXKtjpnJvYpxZTFR9g=;
	b=sBdnonYiKc9aqoZp8dJmTX2T72DnmQk9goocb5EvAq7TOvbijkjyVcJOjEBDf3ECzePC
	 KQ0/ieoYTB/yY4je1tkNt1+SQ+RnOhJ1YX4esF+Zudh/O5oTPUfLnL5AYm5wBcEcol3Ai
	 kCkrf/i0BoVb+0G50pP/iQ8+HFKbOYGJNMLoq8o9E7bpebNxrvldJW20cySssm1wisCQk
	 aLlm2kDMouxzCp3ZvlnfbrzFrJEzDIXSmf7PtjaxftZO5issvaUv4G7XELxi25ADf+w/R
	 5hofAorxkHBajzZg5FkM9qf9rHGzbS8i5k6hUFIqRtmOWYUv4QruS2Q2vOS9ZsXD7ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=olfEXirj;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B5A60A6F6D
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 06:16:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24B5A60A6F6D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=olfEXirj
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-386a0f79047so5633729eec.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 22:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587383; x=1796192183; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8IYxPCQoD7cmdiQr4ia+kH+yRcXKtjpnJvYpxZTFR9g=;
        b=olfEXirjtN/IsgkGaGYuHVhDjzUBJs50RJ4E+8CcGyTQfmNEeahxek3/ZanBcZvpJ5
         rX1e5rOgmucoSljS7RB9PfVHXQf3DVgFvT1acMR9v4ul5ucaYoYWlZUJIatDPb/Oy+8Z
         KMLqKDvNEkEUn3LaeVsncFV/R9RtdwiHVmRQsAZtmk7eVgCumJe4TkGTFuYFBwZJBeze
         nDrloJSMMVz6AflXsIsuJYrv5RnPvMT6ZEqZ+7OQNNl2Vf/ZmRmdSC/ctvGTi8ZG1WWH
         d2KY4UscbQyOwnQ9HmW9Gh8V/77oRhHtteiHB1umbpUbzWUJnJfIN8AxoBGBza3oNjLr
         wubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587383; x=1796192183;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8IYxPCQoD7cmdiQr4ia+kH+yRcXKtjpnJvYpxZTFR9g=;
        b=urEv9xR9tDZSLnDTtzbGq9T2BPOt9trZulPubWX6ttqAThZqotWbdAGIVnZMVI+75x
         REKHB13WIU+NX1f8MmM222UvUzgCMvHdz5uo0g4CwT3f+CnUnad4PXIJ4x3n1soixswn
         ZyUQokvS5dJjvu5ZgBItmCMsRNwjTbLMf2rcKfwtOb8vXjgW7zpsqAnBsXWA0BBm1Ceo
         mxRo9kIx5/xe4wSzKgcxNeccZq2CUCVcIdvnT3fFGNndPLTdiPkF4TH58GPI2nV3BWVF
         TiJLYp6HugGWuCilW/mXbu4fVjCMidd8hlfxalLSqsmJ3slTay38DrTcrPmb01H8KQ3t
         0MDw==
X-Forwarded-Encrypted: i=1; AL+hErFqgHoAXi/ud4QRGnGrZNRLh3LObtOx52UH0vwRNGbuOVFN56TuzP6rcTgiEYbFwkxJaTYnpVw=@lists.linux.dev
X-Gm-Message-State: APuU4Z9lWZyuBYl67qmt2G2/CuIufRDNrPY6UifIESQXmNIwXiwKLsRu
	NYF/zezlkTWfCzN88tfTVe4tSbTtAYvtxc/5Vw89u3Ckr/+WahILVnSFaso2RzN+Obe7Fh2TozZ
	oqiUNPo0HFA==
X-Received: from dycmb10-n1.prod.google.com ([2002:a05:693c:20ca:10b0:386:c377:5335])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:e91e:b0:384:2780:8757
 with SMTP id 5a478bee46e88-38570a3e793mr19421900eec.22.1795587382798; Tue, 24
 Nov 2026 22:16:22 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:06 -0800
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
Message-ID: <20261125061523.1540234-14-irogers@google.com>
Subject: [RFC PATCH v2 13/30] lib/Kconfig.debug: Allow LATENCYTOP and
 fault-injection filter with DWARF CFI
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

Allow CONFIG_LATENCYTOP and CONFIG_FAULT_INJECTION_STACKTRACE_FILTER to
be enabled on architectures using CONFIG_UNWINDER_DWARF_CFI with
-fomit-frame-pointer (such as arm64 and riscv).

Signed-off-by: Ian Rogers <irogers@google.com>
---
 lib/Kconfig.debug | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d22638ec13a..650ed105860d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1893,7 +1893,7 @@ config LATENCYTOP
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 	depends on PROC_FS
-	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
+	depends on FRAME_POINTER || UNWINDER_DWARF_CFI || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
@@ -2188,7 +2188,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION
 	depends on (FAULT_INJECTION_DEBUG_FS || FAULT_INJECTION_CONFIGFS) && STACKTRACE_SUPPORT
 	select STACKTRACE
-	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
+	depends on FRAME_POINTER || UNWINDER_DWARF_CFI || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
-- 
2.56.1.831.g720f3f5937-goog

