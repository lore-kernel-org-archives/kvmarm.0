Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7386231C58A
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 12:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246139; cv=none; b=uErkB5R0PKcUHP0x64v0tVE+UKXQ+OrQwR24IkwtxyjccyaHF5bTEMYAkcsb4dTm7C6bFlnTFedRA/k0z3iRNa8Vk77+9ysgc1pVusNDx8sM0MABDNLoaiGuup5hrtUxmkrH5GWz4qBtimfoUEf+66EY5D3c/MG7JS4jwW8QFMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246139; c=relaxed/simple;
	bh=ye9wtMymb6x2G3R6emod//jw7UBCk20rZW5iTdiNDjc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sgn23rKuTE12up4CMFOhwl80ZpxbAEwmXgjzxMu836hiWqmitWe0PIzbYHvkrgKMa1rVEHekZ5LniyH8G5lC9sqX1Cbmh9d6HzAuXnedqHw2VlTZltZzVmAmaJAtKGPq89HaFw9jACKBDLIi+f04tHmuXDAKCr9E491kvp5FjuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jWGBpJy7; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jWGBpJy7"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47910af0c8bso4555795e9.2
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 04:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764246136; x=1764850936; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=spMh75a0LWmahxh8o8eZW/bsUDLucQjxyd3BG3Z+aI4=;
        b=jWGBpJy7EPn2+9GOuBHjkW5I7aeVnbiPCv4Znztk7C2/NhRZf/lMWSU6RJiFH58sdp
         WSY/uzh/Y1zOtrvJ050jF6/R3CFHc1coIkg5pqugCPtGYlPiF+q0rDQfhG5tKS95EZ0R
         61fxv0Ly7mHXlLjxPzWTWIM+Y/nmjXZvGYE2NZLjrG3RcVQ2zos70z763LP+ujKn9rT0
         DZwuu1Nw+H0JnkCg44z9PI2N023QcNI7RpfJEn65tqBuT9BhdLohIt9k6xPok9IFuGme
         qva4iDhx3tUSEPBJvwon7XsKWBfvsEQPbn91GCFbePDw0kh3oeuDQsVx2NwThG6JAZjT
         3TXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764246136; x=1764850936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=spMh75a0LWmahxh8o8eZW/bsUDLucQjxyd3BG3Z+aI4=;
        b=AkuvINSWP/c5lZwL07ifBeKoWLIOChlkkrKRl3hrsog3OtZGfxkHHMTmFNWCZ4bnTo
         lZnzs1sk0HDdANey8n77lUR9bMEjnR3fK/ZOSdHnb3B6d2+at504fgXagQp/Ip15aZTV
         umK2xKWeAXacJLOG4B/PdoG+TB7hx7PySJPpbuHGf063OgCRz34LF3ptlgwETgS7lTAj
         GCNuFfflS9tyigSxAOQsNX24Cf+4/ReNqAX6eX4h6cK2+5Wwwg/5tRF1aU0U31O1ec3h
         GVZwGRCWa1HvcmgvOfa+3SVrX9gZdufJogZJvnbBvhj3DXbiCtjZSiFF0uwVv18GSkzD
         vSXg==
X-Gm-Message-State: AOJu0YxZahkDDf6tRDpqEUsxMcHvdrEyeWmNvfw5EoWvJBLh6yuGQZwa
	j+uHf82qOeCYIeMKd+3tAzkOiVWlD0WmOYdRC0/0Wtrw0NP4mqfDUgLX/Yq2YLiNT1eLoVT1izA
	9g7n/sx9F+uuQuE2hPOOKCACjiedmt5LWAxFj7ZNB2J+TwS4uDMcdVMSaxfigRtHWkCdICzMl2Z
	2Cs4UBDij20JfW8iPKQ03G5E01NSCHlBs=
X-Google-Smtp-Source: AGHT+IFk1TWbWQo0Iwg116ubt+VmEH+PIxu0LQh4swg+M7nIgheUq+mboH69dOkqzZxJ3flErP0k6D3VJg==
X-Received: from wmpo25.prod.google.com ([2002:a05:600c:3399:b0:470:fd92:351d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:458c:b0:475:dd7f:f6cd
 with SMTP id 5b1f17b1804b1-47904b36881mr107364055e9.35.1764246135871; Thu, 27
 Nov 2025 04:22:15 -0800 (PST)
Date: Thu, 27 Nov 2025 12:22:09 +0000
In-Reply-To: <20251127122210.4111702-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251127122210.4111702-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251127122210.4111702-5-tabba@google.com>
Subject: [PATCH v1 4/5] arm64: Inject UNDEF when accessing MTE sysregs with
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
2.52.0.487.g5c8c507ade-goog

