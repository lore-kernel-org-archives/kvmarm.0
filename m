Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A341EE006
	for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 23:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094207; cv=none; b=qtn/HGV6uD8yvznisvbyEMEYsB4Tg3UJpuBrwc4z6Z0uFaJfpRlk1mVQWsDF4Gqb72DWWyQDeXhbdsbxSZ3msxrI3OfjWdCvTLLflv3VVoNpFwCtPcppvDs/693VTuURA+SpLzz8JO+1uGjsF601HodISuvI6QlAKcnS+5UxeFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094207; c=relaxed/simple;
	bh=Fq8ncCchsrCrQKzLlD/2bWJsivf8RZKsUMKlivyOCis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z6khakHCRW4yDFlQ6rm1sKohl/I/bpLxmidSdK8zHlNn3aTvu+iL7ZOD1bnwgnjgWlGvy9zWInm6HP2Xf+TtqnmxkTuBbeND1rlovxiUVA15e950MYbbHHqPLQMqyg8xXXM0heDR/M2xluACU8uqX0hl7AHf0gQgmqCFe8zJq90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dydBAkTl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dydBAkTl"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso4843020a91.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Feb 2025 15:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740094205; x=1740699005; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GWRXbppsiEDXYIZyPawrnpzOZz1QBOlzbaekCOtPmh4=;
        b=dydBAkTli+7zrtSeSnHs+Q1RT9ArilfaABZXI9/sBguQIz0xTJoDXSAeWv4g4Ibgh1
         6ipM7wKFnUSnTv7vmnfji2SoMI2kxUQgPhr/LQ6Os3VIP9flTDLsjMulq8c9siLW1kyi
         q3O3oFx/HkU5lyoArNsB5TouxJ3ZB9PN5XSzilGQkPxKP5RPtGlycexNZNJlXXsK73rP
         coc79SIhDCK9Anf0j0U7OUYiSYHALVNcEiqJ+b9mSZIE8enmv8+HYtQL1kziFtXrP56m
         7sutmKjVGXQK0h92bztOQzSndZDnNgvyzWrpWa/Y25v3n4cCjmw99ka+OStXVs5sQ0Nz
         TDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740094205; x=1740699005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GWRXbppsiEDXYIZyPawrnpzOZz1QBOlzbaekCOtPmh4=;
        b=YNvvpzDpdB7hBcIZx2sBDlEX9aDeXx3W4H/OeVf1k3fwbQh4klGWQHrVc6Q6sVDlAD
         GaSRRDBfD/ynFxynp9AYoRJThsKK62EyGEOMoA2mUIKVGBTrZrngn3Pnw0SAQ/QrrubX
         BUcD0Pqgr5cXPpC+Ox8Nspp7T+yzoxknUNNR9T3XfqrRTmI/MrQqNwHlUM59bg781vD2
         EW8cYvt86L3SEfo1wbuhS5FOYirHAjDTVWwRQxq6OvxlcykNBsXj3u9nyhBXyJ6xaInJ
         PJNGO8bOtUag0bDIjfwo7BJsiBkx0PIxEe38+HWvl+IqKWFDw6anYHHzKbhXjMaabrLj
         49iQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ7E08b6YE/SP7xCBg0R8m++xh9oTdUzYlZ6rwu9UeKEq6B6/2HiKWfDTdh6H5ZKa2Oll59+w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAPj0mT7hT4xemDEAFc4cePIgOEeQRjuLCLenBvWKFB3TLUFSc
	ZJunaRMNay/NZpUEBg0f+zPlHSpvuLWwdexm0PcYVj7P8/THCUVCaGrK/EoOFRh+TeSfOeGyT6n
	TuYGEWkcL4A==
X-Google-Smtp-Source: AGHT+IEJgmi64wdMWyANqEO34cKSZI9Wuz5tHq4A/owmtalUI629cLYAyrOiwBDklXhEIDQhnrCFWifbpOyeVA==
X-Received: from pjz8.prod.google.com ([2002:a17:90b:56c8:b0:2fc:c98:ea47])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2590:b0:2ee:df70:1ff3 with SMTP id 98e67ed59e1d1-2fce75e1b18mr2115049a91.0.1740094205662;
 Thu, 20 Feb 2025 15:30:05 -0800 (PST)
Date: Thu, 20 Feb 2025 23:29:58 +0000
In-Reply-To: <20250220232959.247600-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250220232959.247600-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250220232959.247600-2-jiaqiyan@google.com>
Subject: [RFC PATCH v3 2/3] KVM: arm64: set FnV in vcpu's ESR_ELx when host
 FAR_EL2 is invalid
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Certain microarchitectures (e.g. Neoverse V2) do not keep track of
the faulting address for a memory load that consumes poisoned data
and results in a synchronous external abort (SEA). This means the
poisoned guest physical address is unavailable when KVM handles such
SEA in EL2, and FAR_EL2 just holds a garbage value. KVM sends SIGBUS
to interrupt VMM/vCPU but the si_addr will be zero.

In case VMM later asks KVM to synchronously inject a SEA into the
guest, KVM should set FnV bit
- in vcpu's ESR_EL1 to let guest kernel know that FAR_EL1 is invalid
  and holds garbage value
- in vcpu's ESR_EL2 to let nested virtualization know that FAR_EL2 is
  invalid and holds garbage value

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/kvm/inject_fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e6..2b01b331a4879 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -13,6 +13,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_ras.h>
 #include <asm/esr.h>
 
 static void pend_sync_exception(struct kvm_vcpu *vcpu)
@@ -81,6 +82,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
+	if (!kvm_vcpu_sea_far_valid(vcpu))
+		esr |= ESR_ELx_FnV;
+
 	esr |= ESR_ELx_FSC_EXTABT;
 
 	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC))) {
-- 
2.48.1.658.g4767266eb4-goog

