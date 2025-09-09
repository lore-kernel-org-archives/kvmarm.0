Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4933469E4
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425005; cv=none; b=KwbBcqzQoBsPfRsUX9UW5jtKcCrukpXjXVnp/JUulp0kNU8fisE1VmZquCZwIGaB743GQBCnioKUpVsr10mWoYZjJu2LfzN+sTPiTFP2AakC6UHqyjphM1uyvETqil+mnMwGLgAmMs+rfoo6PCnTHAMlpt/xtKPznYUAYRU+DCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425005; c=relaxed/simple;
	bh=1jUbV2w9NIp9JNhFFgwdG1HeX8G5TcJfmUWpWozhTZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XXwf+JijJzis8zpIXAGGR844D+MvtVg1PJck2Py5endl42xN6nLO9JpjZQN12n9gux4HkCxLA4lvrZA0QdxFljf4rGMJ+oGI21exBJnwL02rfb7tEJJtbZwgbVMFDoPe2e6Po836zqDkj4x2xmhw9IpvmCgKKRu/YdkOALA7UG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uMjFe81f; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uMjFe81f"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45de07b831dso16744185e9.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 06:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757425002; x=1758029802; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ejP7jVX3oQKxjUP0aHsAIaSpTtnAmNmXF173kk9bzw=;
        b=uMjFe81fRiSRhH6VxPbqxfUmtJIrjCCd1s3HDXSMOMLCPQ028cP/gZGGPn5VgFCtlj
         EC8fCa3QhJurfcvc6WDvwIPAHyWAX84EagZwAtFZU6OU/QAXDNCz2n9CeiBdt5iD4ZUS
         tWFfzC+dVVApRxzW33WARXhaDGTHOQgYx2gqFKZyL2Hf2p+l1MghiufebUasP4O5sU/z
         WEILdHW9wDMltdWNT4JZKkEYrSGIGq1czlwInxDf91/iKYakoibsIy9FTfiyU734Jdcd
         gwHwIp2w2GrwMZO+c6kb8Qjd7Tu6UvD0C7O4N+y5ACCQjAfFD/NHyo0o3PQveINOYcBv
         uKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757425002; x=1758029802;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9ejP7jVX3oQKxjUP0aHsAIaSpTtnAmNmXF173kk9bzw=;
        b=m0TR827mbo9CB/PkZvmJxh51ca32wjX1Xnz6CAAiVBS+lllm0zmkBfcQHGEeBRkloo
         cyRqWlLZjuH/fWgwI4XqOq0qNjay9P6EOTtLz+uxDr3sYebF8gpbPVgF+nRTGdpx7E76
         R4PNzpkI9ZeLtBnYTdyNf9e3VaGb1bYhonlPsk2+j6MNuzWt3fTpWscm6S60tjMvC77M
         2D3wxpKhhURVZfyEN90fF1s7X8b0lAxw+fQtLXlp4V6xzrBNs6Z1hEYeC/Dnk9MhH+AZ
         ZjEmNm/GZ3LGrctIgjN8/YfUnKxhIko/GJ+IN9Wogg4eDBHR4j0GVE1SNvyCcBv7KK9Z
         Ttrw==
X-Forwarded-Encrypted: i=1; AJvYcCUQDvxNAjrVPgX8H/JvhyQ30SaJZ8SOQPmJ3ptXd+UOFIEw2dtDVmfMWcTUMhHajxwVInc0Y0I=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDuUT/gBhIEmB/ueQyxTOOD6i8S28cAySXgPbBEkkdVKA7zmED
	J+zcY4TaCb9zBiVWrqVn3KRGGRpHoFgZrx5p9K0WV3iU5npzDOKvTIHYUVHbDeBPDrMSCaLkRzO
	1EjwDQnO6it+TMw==
X-Google-Smtp-Source: AGHT+IEZ4MmWEqJ4zcjlEgRxSK3Lw+dH71yaATrmPGW/tzAa4gHwSjlPd/5GfSIOf/nbPGOdCuFEx5PEaVOpHw==
X-Received: from wmtk8.prod.google.com ([2002:a05:600c:c4a8:b0:45d:24fb:e425])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:470d:b0:456:fc1:c26d with SMTP id 5b1f17b1804b1-45ddde815a1mr94298705e9.2.1757425002214;
 Tue, 09 Sep 2025 06:36:42 -0700 (PDT)
Date: Tue,  9 Sep 2025 13:36:30 +0000
In-Reply-To: <20250909133631.3844423-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250909133631.3844423-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909133631.3844423-2-smostafa@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: Dump instruction on hyp panic
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, perret@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>, Kunwu Chan <chentao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Similar to the kernel panic, where the instruction code is printed,
we can do the same for hypervisor panics.

This patch does that only in case of =E2=80=9CCONFIG_NVHE_EL2_DEBUG=E2=80=
=9D or nvhe.

The next patch adds support for pKVM.

Also, remove the hardcoded argument dump_kernel_instr().

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
---
 arch/arm64/include/asm/traps.h |  1 +
 arch/arm64/kernel/traps.c      | 15 +++++++++------
 arch/arm64/kvm/handle_exit.c   |  5 +++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.=
h
index e3e8944a71c3..e92e4a0e48fc 100644
--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -36,6 +36,7 @@ int kasan_brk_handler(struct pt_regs *regs, unsigned long=
 esr);
 int ubsan_brk_handler(struct pt_regs *regs, unsigned long esr);
=20
 int early_brk64(unsigned long addr, unsigned long esr, struct pt_regs *reg=
s);
+void dump_kernel_instr(unsigned long kaddr);
=20
 /*
  * Move regs->pc to next instruction and do necessary setup before it
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index f528b6041f6a..83e6d1409e1f 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -149,19 +149,18 @@ pstate_check_t * const aarch32_opcode_cond_checks[16]=
 =3D {
=20
 int show_unhandled_signals =3D 0;
=20
-static void dump_kernel_instr(const char *lvl, struct pt_regs *regs)
+void dump_kernel_instr(unsigned long kaddr)
 {
-	unsigned long addr =3D instruction_pointer(regs);
 	char str[sizeof("00000000 ") * 5 + 2 + 1], *p =3D str;
 	int i;
=20
-	if (user_mode(regs))
+	if (!is_ttbr1_addr(kaddr))
 		return;
=20
 	for (i =3D -4; i < 1; i++) {
 		unsigned int val, bad;
=20
-		bad =3D aarch64_insn_read(&((u32 *)addr)[i], &val);
+		bad =3D aarch64_insn_read(&((u32 *)kaddr)[i], &val);
=20
 		if (!bad)
 			p +=3D sprintf(p, i =3D=3D 0 ? "(%08x) " : "%08x ", val);
@@ -169,7 +168,7 @@ static void dump_kernel_instr(const char *lvl, struct p=
t_regs *regs)
 			p +=3D sprintf(p, i =3D=3D 0 ? "(????????) " : "???????? ");
 	}
=20
-	printk("%sCode: %s\n", lvl, str);
+	printk(KERN_EMERG "Code: %s\n", str);
 }
=20
 #define S_SMP " SMP"
@@ -178,6 +177,7 @@ static int __die(const char *str, long err, struct pt_r=
egs *regs)
 {
 	static int die_counter;
 	int ret;
+	unsigned long addr =3D instruction_pointer(regs);
=20
 	pr_emerg("Internal error: %s: %016lx [#%d] " S_SMP "\n",
 		 str, err, ++die_counter);
@@ -190,7 +190,10 @@ static int __die(const char *str, long err, struct pt_=
regs *regs)
 	print_modules();
 	show_regs(regs);
=20
-	dump_kernel_instr(KERN_EMERG, regs);
+	if (user_mode(regs))
+		return ret;
+
+	dump_kernel_instr(addr);
=20
 	return ret;
 }
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index a598072f36d2..99a8205fc104 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -559,6 +559,11 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr,=
 u64 spsr,
 	/* Dump the nVHE hypervisor backtrace */
 	kvm_nvhe_dump_backtrace(hyp_offset);
=20
+	/* Dump the faulting instruction */
+	if (!is_protected_kvm_enabled() ||
+	    IS_ENABLED(CONFIG_NVHE_EL2_DEBUG))
+		dump_kernel_instr(panic_addr + kaslr_offset());
+
 	/*
 	 * Hyp has panicked and we're going to handle that by panicking the
 	 * kernel. The kernel offset will be revealed in the panic so we're
--=20
2.51.0.384.g4c02a37b29-goog

