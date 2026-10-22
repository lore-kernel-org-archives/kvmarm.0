Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792677735;
	b=NNu/GQUbHGaqIpZW0JurnT0N9FThazTYwVNRcMB2iJLIo+wW3JdGzFQhkpnhMX+US0Dl
	 8TTQXFQRwfHzAx2KUFb3Nwu9sbp9gCmAHme4nJUhR2nWQL1yzORUplipwZfiCZb1w5+ro
	 ZXvEeQ7Kz8cDAB2zQcue5JhMRzbdid0+/JKkxohzyeF3o+7J0S6G2gciHDdBU6O9LEJTA
	 poD2RmnfCva2yIxp/BcJYNUIQYMgGGXQcRH4O4MR/lwWx/0rJpEOt/EwQF+gi8pbB3i8o
	 nYOiNg3bqYBCOMHl3lr8TwhrxIrnM7/WNGmORx16HgUu+pPO3N3a5yG+oPk4KKn80WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792677735;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=7SQmolXx9Gu1yzUrM62wAZ0O9GWKQf6abuquBr/LlHA=;
	b=JL3yIDNL0nbIT0Z0rcmE3cTKDxEoweIfEUKAATYOJiaYG/qBGDJJOLXdwWEiRoDXmJDE
	 376Phlb5D9jldz/APoTr8fB+uUonFLdSW1A/zzwI1HBZIc55pvm2dnWMMcbN/Zc37ix6g
	 C4vhXE8SqVv42UhoJ3+1cogQJkNgmkTdSclgQ6Jb/F0LRm9bbTY4rPoKDhjH0YcFLYczr
	 eHPsFg22YkGv+xtmOMUd21d92dRM00+K2n+CXkm15Y+u0iqIS4fJAJthcrKKgDgWFdmhZ
	 YsvxKMYDLR+osnYBPq08xeJZsdL8wEJpoUWjxOvoy+7bDLyVxG2H+74Wki1Gti5ufiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=juJNfuny;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD8C606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 14:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BD8C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=juJNfuny
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a0284121c6so17808215e9.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 07:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792677734; x=1793282534; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7SQmolXx9Gu1yzUrM62wAZ0O9GWKQf6abuquBr/LlHA=;
        b=juJNfunyt6lhkeIi4urQa8s+py7rXIcdK8Q6Bz4ht4BQa4lUZn579p5D3t3LY7kF0D
         yhjUC4HvVhZoTfrC58PGc2Ldx5yFxSVCHMcwPxS9bIo8yy8dSUUX8CT8iWeixxLac4MD
         hxixZMI8+svScBMB525o8iK/xguyZhS8pr8ATMvhWopeXRozN7OOSYTLoCpG4WkYJlLK
         1NRJ3IcI0Bb6Vxj+WuWEiM0JeRpR7YnQkwyDBWXHSE8SKjlPalVCJ57pUNu9DzLItOyr
         DPJPyOBU2j/gTQWYQNzLkhKb42JL5rtinodnoJywciog04jOkNL3NrNMGqKW9KBA1hVN
         ce3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677734; x=1793282534;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7SQmolXx9Gu1yzUrM62wAZ0O9GWKQf6abuquBr/LlHA=;
        b=ksxmuwG/TyMq026sPL7JD/4nxYhmeZqALmRjADgoVjOYgHsCvawdD7o2lSLQLTdNVi
         eObGbBzrT901hu1bqIWet2OJtBCE8z7MiiMEvWJlmNNwF4fAiN4Xa9B53yO3YsVdPvef
         2Ikv+2kKQisiEKgWAuVdP+GZYJ2nG2Re/Nq/parfJg3yFHkn3pdBAn6rR6Ih1Kkenaox
         iTZgYHpVdCXakenjIJCbLFlaBw4tPQQ+48KeqnNnn+WMEvxUFU9Kiya4a0M0kTWirztq
         Pvq5YwhLQmrnd2yxtcm2X1eMYRp6l8zjuR0IgrfrU/7O0mO4G+IWwUptyeUp80Zgzm+R
         QGvw==
X-Forwarded-Encrypted: i=1; AKwUvBzUWMJFB0cwSgpAKnRQhkFuDdFn0lBC1QNL3JoXqVMOML+LgJRwUDjYgPwrYTiUjVBT3Kw/jUY=@lists.linux.dev
X-Gm-Message-State: AFq9FYLCFySFa8uBHIlge8E00CP/pDqIP/RnXL6UAn8Ow6uHAs/pv3e1
	6DL5fM2E0MLs+25A39kVVQ9wTe5apQVLo844zUenLWWS3v923EYRDk1OToJm2ZleHRF06lB7QS2
	BJpoDn1sOcwERwCXM9KkNNQ==
X-Received: from wmbgz7.prod.google.com ([2002:a05:600c:8887:b0:4a1:a2ef:38dc])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3514:b0:4a1:d248:25c4 with SMTP id 5b1f17b1804b1-4a1fdb17706mr114255665e9.13.1792677733445;
 Thu, 22 Oct 2026 07:02:13 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:00:47 +0100
In-Reply-To: <20261022140048.2522787-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261022140048.2522787-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022140048.2522787-4-vdonnefort@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: pkvm: Reset GICv3 LRs in the hypervisor
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

After the host is deprivileged, pKVM can't trust the host for resetting
the vGIC LRs whose value is architecturally UNKNOWN when the CPU boots
or resumes. Add a blanket cover in the CPU_ON/CPU_SUSPEND path.

Fixes: cdf367192766 ("KVM: arm64: Intercept host's CPU_ON SMCs")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index e20db999e328..890ced64fb18 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -213,6 +213,10 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
 
+	/* We can't trust the host to reset those registers */
+	if (hyp_gicv3_nr_lr)
+		__vgic_v3_init_lrs();
+
 	trace_hyp_exit(host_ctxt, HYP_REASON_PSCI);
 	__host_enter(host_ctxt);
 }
-- 
2.56.0.257.gf7497c7d27-goog

