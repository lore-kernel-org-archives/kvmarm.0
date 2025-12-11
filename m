Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567D82D3A70
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 11:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765453116; cv=none; b=ORAtAuANedMYw6TJexzl2e7mGLPVqY6QVivgC/wa7xqglYJ9haC4kANW67ps6x9Ee1gdxI/aiI55asnRGdwkidvSsmATORhge50PHj/3L6ZCu9MKiCXNxDEMMXnGhgXcwF/1F7MAU0khBoKB8kqWe3g15FtqIeBlEC3BpDLvERE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765453116; c=relaxed/simple;
	bh=FwVtZH02ypx0byy3Lp21NxM+4uQpAXJS0s1Oig/VafU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lkgcOkGPL5rWfCfcsaKChadeUqMVnyvvZx5+pgZVr35iwAsrLVUfOwRW1LyKxwNiSqRly9+UJcDBi/oj7W1OTbAPmjnnKwY5/jWn7jJ6etGm9NL+lZYnZ8QQxtc9MJEnaGpXWNavcdPUkpou5zN72zC+LB3pPA2stFcBHzR2vWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HY0t21yJ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HY0t21yJ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2ad29140so392402f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 03:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765453113; x=1766057913; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FAKrVBNxWNzf5AFlwNKs8nwrXjTjocawMvN6/+Bemv4=;
        b=HY0t21yJpsTid+Lgrz8WjTZ+Y16FriJw8DHRoxGrhrjtpiRWAHs1XTykisA8zOfuHH
         zGdFrCD53O4jzRQJyxbzO1BbluQTmZcGYKakL8gRguR+rJNMIRvkm6x/tjW6vHl2Z4iL
         rojzZgltcscJPwe3ieBnMt8Mlh0ytVT20/wcAfA6AycywRM3bQIswaWTDoPL1qdrHVek
         svrDUuC6+oLSWDk3hIODLtepLUot2uh/SFv09YoTENeLewC/uGpmoc4/gp9YW+ynmOXd
         6wyhhPkGkV2i4Jw0Dh59+SbGu10jfM1CwEt8pHV6KLRiWZ707DN72PEfsZhBY06mEjEN
         Cv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765453113; x=1766057913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FAKrVBNxWNzf5AFlwNKs8nwrXjTjocawMvN6/+Bemv4=;
        b=W1RUp9J6M7zrafVeIy44Zt2knNR3il8Arr7lT/zisTzDbDNYJ2RTwJMGXeO27oxiN6
         UubVR08sL12SJiRZVP7BvED6HS8QRSYKvmI3MfcgZbac3YgOi7qcF0nRWUkJSOC+96CF
         osD+tz5K3rSKQ1DIjyDXxr5k76MYHuGxFgxuWEDeJcmRZBQierFMuF61Exhczqu44dj8
         YkBvEngpdz2qBqVlAB0pJc0Mc3gBgNhsLXlfbrXXHNpvFRht8vm0Ss4OI40X0oI22clt
         LuwJBvParNfVnxNo7EYy7cm4BRnVIF9+LCeB/q2yMqgYRc2f4tJ2wQ0zAEVwadve7tZl
         1lbQ==
X-Gm-Message-State: AOJu0YxxEdZLJC3giHj3CQwcKw+2ITWIxfPld7oO+O2VnczvAFhd7403
	6/Y6+ExzuyE/cFWEy/71wPpddKmP4qPH/1KKl5bCyZ62WFtBnhaZEEH9ExnxxIsGdw6aE8INOLE
	yMVN/7W6IynahLmKZOHEgJVssfsXi3gB1FRLzMBEKNgNOK6k6gVbR8CiLCmjW8CSU18aO10D9oE
	EZp2FXgG25+worHdSGMXiB1xB7FSkXP6k=
X-Google-Smtp-Source: AGHT+IFc7lvmfn5LPPjevpwMTfbx6/iGjar8gi/uBjkrJessLIYye4pzMI3sHwpXEb9c803ajpwdpY0YiA==
X-Received: from wrqr13.prod.google.com ([2002:a5d:498d:0:b0:42f:9f40:a5d9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:40da:b0:426:d5a0:bac8
 with SMTP id ffacd0b85a97d-42fa3b1eb9emr6657835f8f.56.1765453112715; Thu, 11
 Dec 2025 03:38:32 -0800 (PST)
Date: Thu, 11 Dec 2025 11:38:27 +0000
In-Reply-To: <20251211113828.370370-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211113828.370370-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211113828.370370-5-tabba@google.com>
Subject: [PATCH v2 4/5] arm64: Inject UNDEF when accessing MTE sysregs with
 MTE disabled
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

When MTE hardware is present but disabled via software (arm64.nomte or
CONFIG_ARM64_MTE=n), HCR_EL2.ATA is cleared to prevent use of MTE
instructions. However, this alone doesn't fully emulate hardware that
lacks MTE support.

With HCR_EL2.ATA cleared, accesses to certain MTE system registers trap
to EL2 with exception class ESR_ELx_EC_SYS64. To faithfully emulate
hardware without MTE (where such accesses would cause an Undefined
Instruction exception), inject UNDEF into the host.

The ability to disable MTE in the host kernel is used by some systems,
such as Android, so that the physical memory otherwise used as tag
storage can be used for other things (i.e. treated just like the rest of
memory).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 44 ++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 29430c031095..f542e4c17156 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -686,6 +686,46 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	kvm_skip_host_instr();
 }
 
+static void inject_undef64(void)
+{
+	unsigned long sctlr, vbar, old, new;
+	u64 offset, esr;
+
+	vbar = read_sysreg_el1(SYS_VBAR);
+	sctlr = read_sysreg_el1(SYS_SCTLR);
+	old = read_sysreg_el2(SYS_SPSR);
+	new = get_except64_cpsr(old, system_supports_mte(), sctlr, PSR_MODE_EL1h);
+	offset = get_except64_offset(old, PSR_MODE_EL1h, except_type_sync);
+	esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
+
+	write_sysreg_el1(esr, SYS_ESR);
+	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
+	write_sysreg_el1(old, SYS_SPSR);
+	write_sysreg_el2(vbar + offset, SYS_ELR);
+	write_sysreg_el2(new, SYS_SPSR);
+}
+
+static bool handle_host_mte(u64 esr)
+{
+	/* If we're here for any reason other than MTE, then it's a bug. */
+
+	if (read_sysreg(HCR_EL2) & HCR_ATA)
+		return false;
+
+	switch (esr_sys64_to_sysreg(esr)) {
+	case SYS_RGSR_EL1:
+	case SYS_GCR_EL1:
+	case SYS_TFSR_EL1:
+	case SYS_TFSRE0_EL1:
+		break;
+	default:
+		return false;
+	}
+
+	inject_undef64();
+	return true;
+}
+
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
@@ -701,6 +741,10 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_DABT_LOW:
 		handle_host_mem_abort(host_ctxt);
 		break;
+	case ESR_ELx_EC_SYS64:
+		if (handle_host_mte(esr))
+			break;
+		fallthrough;
 	default:
 		BUG();
 	}
-- 
2.52.0.223.gf5cc29aaa4-goog

