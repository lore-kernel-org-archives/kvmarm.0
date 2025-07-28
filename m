Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A71FF603
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 21:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753736862; cv=none; b=rqJ1RMbrJsoyRVS8NzkzwIKXIDCI8iggBmt8p+z4zi+wNXWNskYsClHqAitgB2hBWPoypLtjuyuif/8DqmGkiXLDaT4xqxKUY41bwKwA3lkxSCoX+W6ZL3i3/OsjvBPTMpTBpDgnt24sO+H9qKDbB64J+NTHWDEvKar9TVPY6kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753736862; c=relaxed/simple;
	bh=VYvyAPR2rjDj8OeNJRruAu8npV1N/RHzlGka234BYnk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Yb0wUJTmr1LGPQQVlUgjULZCI/WKicjl9Ua7e7fEU9groaT/E8+z6csiaUsi33CG8zCpQYPBVGeYOIEpcxabH5uoa5UxF2uKVcUmmh+PcMIyTZieeIaEkUFUMS1OQmLjprMS51RgaimKzaRnd3gKuRkk6eGUTBUW6K3jTMmUAME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cJH4oTYL; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cJH4oTYL"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-73d04d16ab0so4400709a34.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 14:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753736859; x=1754341659; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=slHkTPTO23OubaoGcLALPC4EFvq2t1/SJARmRLWq8ek=;
        b=cJH4oTYL35CUucg9hHjMBjTjgrESkSQOQBj4gVoi6/svTe5cCh+FnVUd6COWwnEik5
         PUS8oLm2ZoUf/fnf9sTfAYpba+pUN1fEtsqAL60rx4RigJS4PP5NmEUKoS+yNUZkCOtb
         YoN3ALNlCw00TXW2ADwNab2JvM1He4oPFsabhQgAx7PU9tgn+1E6NKr4FLU+1bdI4ybK
         oCC8RIxPDk3ai0OfLRDMhe4dMFFKT80ijwce2FIYboC8GZ5kD6xTm5kGBXCb9P3d2I+g
         fhnAtWmc3q1obWZ/Hg+49YIGxDn69qs3gBeNBlSKfCyA0pQkA91ZkEg4rHZTwQDTNGkJ
         sR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753736859; x=1754341659;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=slHkTPTO23OubaoGcLALPC4EFvq2t1/SJARmRLWq8ek=;
        b=oAE4s6aDP/NrwM8v5l0uOI99/0SOdvlD3s1tNPZGEC3E/9w3nmiBoEcwIDmbmDKUvY
         lgLmWp3jBjkBJO/TkHi3AHVKUSwcvDaOciB8fTmtXgu6KN6otGamNd8HUAJVOseboWb2
         yvqjpIn74g8DIX6pg3G0MK4zEmmjiI/05MzIThFYAl99mwDgW64GsKfrxUivvOCxY1c+
         gyjXk23z97ujTVsYRaG7+bJij743Cc39jbRAKbcn85+e3sYoLdBuED6WID6hMpSSlnst
         J0a1N79akWv39CsdIaszChAA3TH04q7dH1NYDTbjvVuZQm/d+FRWA5DKSlwsvLl70ysr
         lAVw==
X-Forwarded-Encrypted: i=1; AJvYcCXB1mleb/xv+E9qrf1U6bDhzTndLT3SHZPU6hiOPJMEFlKriQQtGNNKaCACPyV6UHNQU80P3+8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvHcmzLvT7ooTv3Pmm7++gtu7HjrUjtHbTEhIWSAqKAyCcEhQu
	qpmyiWVXMXDvBG8LtH/eydWO4r2rPbpmQZEeUcl0ANVaWiKp6nQE5GdbcL+Mbcbxi6yOliwJSpU
	zngNVvvnAvFSyNsz7Y6lU/1CZMQ==
X-Google-Smtp-Source: AGHT+IE47Z4A3+D9s5HwxzIu2gGt99OXTdaSbCqZ0hKtmsL0LHdSzeDVlhRw2PjDnFeNQYwtxQNiod7Q3hr1gALGAw==
X-Received: from otbca17.prod.google.com ([2002:a05:6830:6111:b0:73c:b634:7b70])
 (user=justinstitt job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:2641:b0:741:5d00:e86a with SMTP id 46e09a7af769-7415d00e9efmr3612294a34.8.1753736858551;
 Mon, 28 Jul 2025 14:07:38 -0700 (PDT)
Date: Mon, 28 Jul 2025 14:07:36 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJfmh2gC/x3MQQqDQAxA0atI1o04EdtpryJdjBo1UKaSTFtFv
 HsHV5+3+TsYq7DBo9hB+Ssm75jhLgX0c4gTowzZQBU11Y08Wgrdi3EQO/uJknBJir+gEcm7kdl TU997yItFeZT13LdwLV25wfM4/t3NQ751AAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753736857; l=1926;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=VYvyAPR2rjDj8OeNJRruAu8npV1N/RHzlGka234BYnk=; b=HlGzpA+TYc3ck5X9eKZ/5YyDluZ21Hq1Gvc/SoBUkfkiAD8EgpqAOtMwdmCUD0dG6UEsL7Jja
 ZVx2abnVmotBHZV+zPnLise4jybp/uEsKfEPTnW+S6eenOBCzZVTrLu
X-Mailer: b4 0.12.3
Message-ID: <20250728-stable-disable-unit-ptr-warn-v1-1-958be9b66520@google.com>
Subject: [PATCH 6.1.y] KVM: arm64: sys_regs: disable -Wuninitialized-const-pointer
 warning
From: Justin Stitt <justinstitt@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, stable@vger.kernel.org, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

A new warning in Clang 22 [1] complains that @clidr passed to
get_clidr_el1() is an uninitialized const pointer. get_clidr_el1()
doesn't really care since it casts away the const-ness anyways -- it is
a false positive.

|  ../arch/arm64/kvm/sys_regs.c:2978:23: warning: variable 'clidr' is uninitialized when passed as a const pointer argument here [-Wuninitialized-const-pointer]
|   2978 |         get_clidr_el1(NULL, &clidr); /* Ugly... */
|        |                              ^~~~~

Disable this warning for sys_regs.o with an iron fist as it doesn't make
sense to waste maintainer's time or potentially break builds by
backporting large changelists from 6.2+.

This patch isn't needed for anything past 6.1 as this code section was
reworked in Commit 7af0c2534f4c ("KVM: arm64: Normalize cache
configuration").

Cc: stable@vger.kernel.org
Fixes: 7c8c5e6a9101e ("arm64: KVM: system register handling")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
I've sent a similar patch for 5.15.
---
 arch/arm64/kvm/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5e33c2d4645a..5fdb5331bfad 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,6 +24,9 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 
+# Work around a false positive Clang 22 -Wuninitialized-const-pointer warning
+CFLAGS_sys_regs.o := $(call cc-disable-warning, uninitialized-const-pointer)
+
 always-y := hyp_constants.h hyp-constants.s
 
 define rule_gen_hyp_constants

---
base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
change-id: 20250728-stable-disable-unit-ptr-warn-281fee82539c

Best regards,
--
Justin Stitt <justinstitt@google.com>

