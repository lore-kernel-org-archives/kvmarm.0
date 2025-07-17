Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7934D23FC4C
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 23:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752796078; cv=none; b=FBoINxRv0c9aOe+jnnCXQv/dmAegFyUKddhTLG+pAmuRXSXivyJUsp62BwJQweXfdVcOW6WR6zm8dbt74XHdk2ZasBpTT5JfDUZS3XAjqf7syDGGsE1lL7B8PSjI+a6UliC6FR0IDUiaBAJR8/+wxH6XEb77tSY5Bgbdf0hrz30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752796078; c=relaxed/simple;
	bh=tdO3rvbLSuTpzfP82KhIVxFo9mNfKAFeekY7qAlj770=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aqvNsNr4fgrAPr7Lp8g4b/7yp0K/cwFTPOwLrXDAWbAjH7CZoU01lCMBXzIvVvHnqPUG+Bt/yiJmw3rWBAyeq57xBouOMRLrA9jvIsBtRVyN7b67QZP72o/7YXuG+DP+KEAFV4nffoJa13E1Ti5DgC3ZQjqxXcsq/icki1wnlFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YtPN9dwV; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YtPN9dwV"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso1106855f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752796075; x=1753400875; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LvbtjEj18PWGX0x1t0phF/x8ckso/td4YZy4kcOPVcw=;
        b=YtPN9dwVUAtLvwB/zv67IPyIwB3Z/Nb47TMmTGjtdowtPENWullvU/OzQi4AoiCTIc
         9ZkvJTouOYPUAPpjNQ56YN6R2qbZjwpbzBUCfrNM7Sb7ogn75uKaEkhRxzjQSYM3wyOz
         MPUEJPZFKx9A0UCsZOpHwGg4yYTVz9p6xTxrxbjEHHkZH2Nov9snhldaLwZ4zaoLmBmA
         82aY+oWPw3sreuVI52wG95I8UVJMXgnt28tLHLOJtwy4hopy/F07FRb4yhdqsx6FJrfs
         g7CIc4+mbsbYAZP5bfwaNe6bqxFKbT0MptoyviJ9ZBSX+ejaNoZZ7Sf6jCVyHbhU2oNU
         mvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752796075; x=1753400875;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LvbtjEj18PWGX0x1t0phF/x8ckso/td4YZy4kcOPVcw=;
        b=nzQsICH5HytOqBZmB+Z+EV1cWGO/LeUdTxfJfxXanex8DWML199ZnN7D05hig3J8us
         qZgb7zprn7C0WZ0YUpm020F6xZ/CJJD1iO0nTPDIWR3D5hbJdUK1a7CPRNKoRrgWjpyf
         4UDzgkPiQbTFvmRVstsdzpwix5pDt3aolyu1hQO4Zx2T7+uuVzXlAbKdQR+E4bmyfkTW
         pHYDnSK9UNna41dBt190x45M3lPP2hqSlLnjCLfmv9FEkUHm8VGEq8GKySgWtqnuYEmV
         a4SzS04KYA156aJvUKp2hfZVZdS7dhT0GI1bgCqyqphmLWM8v6ulP6mr/NwNfDKnHx/4
         jHjw==
X-Forwarded-Encrypted: i=1; AJvYcCXtRSb07lfX3NdYMcNdhsBFYbAXe7q3UZeirbdgNN33VwnoN1TaalRF4aUsw0eAvuk1N8S6iY8=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywk67JmmoTAtVouKQB9Ue1xoX+8uHZ1DVXSUEvISorlkWs6lxDX
	n07yWr4d/zMKL8lCA4yfLn5qH3KKuEr6pF7Hqs8wHsi3kdgaplYFRZoyOeWPYFXQM9cRnxpGRQ5
	Kr4OIBcrs19qM1g==
X-Google-Smtp-Source: AGHT+IEqpHOI0zrJb9yR1cFU4cC/jK8HJFkKzvKnqDRgTErFGhbJbdyVNV2Vo7dJPqX0P3eL6UZg+etWnzq0eA==
X-Received: from wmbek11.prod.google.com ([2002:a05:600c:3ecb:b0:450:def3:7fc6])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:430f:b0:3a5:2e84:cc7b with SMTP id ffacd0b85a97d-3b60e4c94b7mr6619655f8f.11.1752796074851;
 Thu, 17 Jul 2025 16:47:54 -0700 (PDT)
Date: Thu, 17 Jul 2025 23:47:43 +0000
In-Reply-To: <20250717234744.2254371-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717234744.2254371-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717234744.2254371-2-smostafa@google.com>
Subject: [PATCH 1/2] KVM: arm64: Dump instruction on hyp panic
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, qperret@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Similar to the kernel panic, where the instruction code is printed,
we can do the same for hypervisor panics.

This patch does that only in case of =E2=80=9CCONFIG_NVHE_EL2_DEBUG=E2=80=
=9D or nvhe.

The next patch adds support for pKVM.

Also, remove the hardcoded argument dump_kernel_instr().

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/traps.h |  1 +
 arch/arm64/kernel/traps.c      | 20 +++++++++++++-------
 arch/arm64/kvm/handle_exit.c   |  5 +++++
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.=
h
index 82cf1f879c61..0d7e86a95d62 100644
--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -30,6 +30,7 @@ void arm64_force_sig_mceerr(int code, unsigned long far, =
short lsb, const char *
 void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long far, const=
 char *str);
=20
 int early_brk64(unsigned long addr, unsigned long esr, struct pt_regs *reg=
s);
+void dump_instr(unsigned long addr);
=20
 /*
  * Move regs->pc to next instruction and do necessary setup before it
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 9bfa5c944379..d692c05e3686 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -149,15 +149,11 @@ pstate_check_t * const aarch32_opcode_cond_checks[16]=
 =3D {
=20
 int show_unhandled_signals =3D 0;
=20
-static void dump_kernel_instr(const char *lvl, struct pt_regs *regs)
+void dump_instr(unsigned long addr)
 {
-	unsigned long addr =3D instruction_pointer(regs);
 	char str[sizeof("00000000 ") * 5 + 2 + 1], *p =3D str;
 	int i;
=20
-	if (user_mode(regs))
-		return;
-
 	for (i =3D -4; i < 1; i++) {
 		unsigned int val, bad;
=20
@@ -169,7 +165,17 @@ static void dump_kernel_instr(const char *lvl, struct =
pt_regs *regs)
 			p +=3D sprintf(p, i =3D=3D 0 ? "(????????) " : "???????? ");
 	}
=20
-	printk("%sCode: %s\n", lvl, str);
+	printk(KERN_EMERG "Code: %s\n", str);
+}
+
+static void dump_kernel_instr(struct pt_regs *regs)
+{
+	unsigned long addr =3D instruction_pointer(regs);
+
+	if (user_mode(regs))
+		return;
+
+	dump_instr(addr);
 }
=20
 #define S_SMP " SMP"
@@ -190,7 +196,7 @@ static int __die(const char *str, long err, struct pt_r=
egs *regs)
 	print_modules();
 	show_regs(regs);
=20
-	dump_kernel_instr(KERN_EMERG, regs);
+	dump_kernel_instr(regs);
=20
 	return ret;
 }
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 453266c96481..de12b4d4bccd 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -565,6 +565,11 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr,=
 u64 spsr,
 	/* Dump the nVHE hypervisor backtrace */
 	kvm_nvhe_dump_backtrace(hyp_offset);
=20
+	/* Dump the faulting instruction */
+	if (!is_protected_kvm_enabled() ||
+	    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG))
+		dump_instr(panic_addr + kaslr_offset());
+
 	/*
 	 * Hyp has panicked and we're going to handle that by panicking the
 	 * kernel. The kernel offset will be revealed in the panic so we're
--=20
2.50.0.727.gbf7dc18ff4-goog

