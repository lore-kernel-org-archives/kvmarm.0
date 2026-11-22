Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391941;
	b=mpq4ZKUMPI87erlFYNEGSaJ2f6n16IgUSq+7pSsLF2y8m0RswiEphUyZuo8capeV9BPp
	 PWd+JiRBeIcfZU0Kvdvj6nIrR55+qin9PnxFNSvjaUEVNM8GtSFJSiNLC/n32pd8LeEAl
	 ApkjxyFQlRNfpYiMqYPfncRuxtMLhJFplfACr1g/kbkRHNgEFn0WP59LeuaXCnM2htbZu
	 vyzT0hH+EgPNDZOKy7op5zY+lxuMZDQTy0TwrnfBPKu7TrPXtqrvvK4QYmqULqqiq5gvq
	 66tM1ZQwFRKXESNSi/ZUlX3k/XSDlmANN/iPFWjSx0Fg0aUfKJW5XRXdEqfTixWrn+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=i8uld7tmFhu1BHNbYnDkojgUSUIEcHmlm+27ijCZsTc=;
	b=rTfFX487pB6510GxHFRSFnUC6xM5hnD7c6LRa7oZJh42e2FLwqTSoEmjHEqemJStC1DL
	 ypwqp5gwMtl9htMJZomf/k05lGCKDlXmAtCSKdTp1EGlCVGVocumRIefYQahr4QgwkqKf
	 ZNsiY8yKiqUuM6Wl2DGgOWFuKKRkND6fJ5CFAypmeu+51xnM89GD6a1oa+WIETl3/DIw1
	 9N1FMRudyos+u91vwuRH7nLTbO02SXRCSQWaQlGMo9Mt4t/tRPIh12Yv2qgoKIWA3hdki
	 mmP6MDGkeuvosg44Kg7PYry9D3qcsVANVjVM7WNQHkq98zwINWFkJxUGRmvd1tlDNWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=F2o7R+Fw;
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70D5606A32C
	for <kvmarm@lists.linux.dev>; Sun, 22 Nov 2026 23:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A70D5606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=F2o7R+Fw
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-341eff9e381so4592840eec.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Nov 2026 15:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391939; x=1795996739; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i8uld7tmFhu1BHNbYnDkojgUSUIEcHmlm+27ijCZsTc=;
        b=F2o7R+FwFeXGwsOBtfHQReJp7SGKtpt0gcoyRybQwU8qRXlDyJd4HbDRpPTjiZ0UCe
         rRgVhXdCi8YNEliM5MroEjRP8HXDbfFlIFnZTuoEAz1jRXYMYWOZ79unESJozqJcqhcn
         kRQpz7pUIbonvWvTx53KAmU3V1VQeARPwWK0KS3Mv48UO7dj4X9IaN02ZGDg6WBuj+c+
         dIK74dU3ITKkyAI+vbrdLIAFOlY08/sQ3oNrwaDSLN+YjzSNEinlAAB6gwXv3rU5sq1R
         zIKdeTCI1DUJDEkDp1CEMwCTf84hxum52w8B5bd2j6MTcdAlLPW30Vtie2tSD0T0MMqk
         +w0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391939; x=1795996739;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i8uld7tmFhu1BHNbYnDkojgUSUIEcHmlm+27ijCZsTc=;
        b=VSnxABXJuD0JuA/BgY9YsYtRrBJngSFc4+SegdbJDpd7fzdwhmlLCKWVuUOirq0aHQ
         ae2KaYeTHKTe5NwM/2m1bvhkdVXUl9XHoiiOEKJJTzhdnTsMf+rTtP680s8nHeYvSDcw
         N4SQI31QuA+99eMoZt2nOZlf3icXYzTzxB+Wh85sYUD+CpXhcx1tC69jyOTuQIbR0asz
         47fzGYmhGMGDOTHMH/hdn3L5zGo2lSZ00Gg1iRyzORll7+JTkBIrcr8udV0fbRRJo4oQ
         FUw01Ffik6kUgOJk76RQKsrCwccXG4RxWFFyvIIxid97WNf7w2mWm4HxPDVFT/8XvZnm
         Fq5g==
X-Forwarded-Encrypted: i=1; AL+hErHI0EgxA9f8300zoFHQB3C2Z90FpLNZRgKE2Kg1EzJSEyzPMW/wZ4uQt6VYc+gcqtLuL7DNXUM=@lists.linux.dev
X-Gm-Message-State: APuU4Z+wFb9ya++82yLOTS9h+ZFYgyB7SROGpeEHstMrUdj6SEMwMTdE
	5jQxFRhBRvlxcyCiEy5GJqKm/r5SueVY4zH6bAakkz4ihG9gyG2TdbOpAT+wMXNPm6X55L8YW44
	udnkd7hQWBQ==
X-Received: from dyclv5-n2.prod.google.com ([2002:a05:7301:6185:20b0:351:4a2a:1ece])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:1505:b0:384:df31:6a07
 with SMTP id 5a478bee46e88-386a87efea0mr3258907eec.30.1795391939090; Sun, 22
 Nov 2026 15:58:59 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:50 -0800
In-Reply-To: <20261122235757.3456048-1-irogers@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261122235757.3456048-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261122235757.3456048-5-irogers@google.com>
Subject: [RFC PATCH v1 04/11] objtool/ibt: Ignore .eh_frame relocations during
 ENDBR validation
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
	nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, 
	ojeda@kernel.org, rust-for-linux@vger.kernel.org, ardb@kernel.org, 
	linux-efi@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, 
	dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

When vmlinux.o is built with -fasynchronous-unwind-tables and
CONFIG_X86_KERNEL_IBT=y, .eh_frame FDE headers contain PC-relative
relocations referencing function start addresses across .text. Because
.eh_frame is read-only unwind metadata rather than executable code or
indirect branch targets, skip .eh_frame* sections during objtool's IBT
relocation validation alongside .orc_unwind_ip and DWARF .debug_*
sections.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 931c5c412f15..e631b0da9bad 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4644,6 +4644,7 @@ static int validate_ibt(struct objtool_file *file)
 		if ((!strncmp(sec->name, ".discard", 8) &&
 		     strcmp(sec->name, ".discard.ibt_endbr_noseal"))	||
 		    !strncmp(sec->name, ".debug", 6)			||
+		    !strncmp(sec->name, ".eh_frame", 9)			||
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
 		    !strcmp(sec->name, ".kcfi_traps")			||
-- 
2.56.1.750.gf70dc682cf-goog

