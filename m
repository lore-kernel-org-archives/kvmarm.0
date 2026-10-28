Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214190;
	b=F/N1M6biXDYOOujSMZK1PcAVIldPYONm1ZGlNcJT2j7xhijXVqS+4BYem5BtoLp877EC
	 lIujsj/TB6IMFoIVxGdYjHDsrx5B4VK5YNLtGq8bXIBTlOcfgo654ENnny/Uii8+D7XRq
	 HGgIevEU8ly8hIWUXFkGDRlsIw6eEoUfC6Le+8NsRNTD1Z0Q02u2tYgQpbYbCzZl3plRZ
	 WRe4gZXOyIsmUl7SJMOvWsV9RnBYOVMXp01eK33QWaxQpsXJpZV6xYKtxeawu1tzbetSr
	 utncKqLKsXiPwmAcBgYZw0yK40EWuAs2+z9Eg+mMNPtaJvv+kJyC5coWK6PfvP8q6Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Reply-To:Date:
	 In-Reply-To:Mime-Version:References:X-Mailer:Message-ID:Subject:From:
	 To:Cc:Content-Type;
	bh=KIzhXXz4HgfGAdkUpoWB/z0OMxuU8qDaDSAd1VOEpew=;
	b=q4av5aZXI59Qg1Q70ESDvYX8VpiYyjDdx0poMvTWnRHzNs7PmoXBotDHgcoemDVDTYiq
	 PLwx/lLF9CsZR/pxOLn5LeeyQRTP8PzbkUIv6ZYEtY2d6NZqhHhJpTDA9s8c4dO+eJSdO
	 hX+H12zDxYl3gJGP5CxYW3phCvNMa2k8VoKriKVG7563kbd0SJCG6nvSLSOF6D3LM+GMH
	 bLorLMk7/BaYqmZFPmfQTwyKScqTyW2HlSTQs74ClzG7YvNHBmM11WR9rbO69KPPVuqsC
	 piPq0e1ACz4q3gAGpn6gVTxuNboXc11FyWv3AWNUvYTGXQB7l9u9+/UDArb+BpyTQLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O7WLMUi9;
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0329960A382A
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 19:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0329960A382A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O7WLMUi9
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso1169582a91.0
        for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 12:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793214189; x=1793818989; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KIzhXXz4HgfGAdkUpoWB/z0OMxuU8qDaDSAd1VOEpew=;
        b=O7WLMUi95YQGfjKjJPzlp8akCOI1jTWhbnkOr7zCOPoMilKz4iJ3VVrcHIYr1H36iN
         uTreaY47LKeNgqAIir3Ygx6eRPRGVXU58BS4+izQ29iGv8bHkcNCA0CHlHS9ToPa80mA
         gnOs8SGnr4rGcP8kdOfq+p0VGEaEG0FrkwSdjy9JCB9moC6spvS5tul+N53cMQngMNK9
         ++1E+GDhyEdV8tOZi+TjhidGqLbwEYBl1+4qCld8nkSxV0I9VP+VMGrBOwA4ifoqR4Bz
         pgRCL2g1alTxMYRMKpQJmwyVxOW0Bh1i5JE1Z/S3s6WNyoSEFtQOYSvPnP2zQBSyjT+U
         da5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214189; x=1793818989;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KIzhXXz4HgfGAdkUpoWB/z0OMxuU8qDaDSAd1VOEpew=;
        b=Y6fXdeGd6EMEgytTaLA5HF0Ra5dARqjBbcD9vlmxVcUWQBHi0UTWCokEeslAZ5YMrH
         7QXhNC1rMRxbvbcigPmZIDxTHEacOEDP6PrMWsyQMvsgo+p5yd2OH2kcVldzrTa55Kzq
         uclUhtXlD67CsZCNiHCktzHhPOHguPPkM7mK2Vb3Pcf5Vj16ZVw8SJ5ayOi8T1ZtmYCZ
         /MBMeZdV4Ql5rvoHLxpoehFROt1OojjPQ14QIxlCH4LF8Yiin9G3sMamO1UJ6bA/KRtm
         hZfWkzLc9PPabgbiPt2H4KVAPUln1gH9ctFBZgIiZSoVMZf9EvwS0VH51Oz9Rb3tWpTX
         lpMw==
X-Forwarded-Encrypted: i=1; AKwUvBwlXPWw6Qxm2i3dHonfUAKz5tVYdcDTEcPMaCS0acLigOhmIWAv2vRnxFZxZjJVO5eC7pHQQIQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYKan+6CiYFuux0hGFCVGQD2yY0LTfeCw/JcpXQli3YVgpap0xA/
	5+fRCS+wO3ri9TJV5Yy20sSxpX7z+Hwg81pNXcgAq9/1yJ4A5nvwhHdwGI+sNyHVHB1+t4wBvBr
	S93Hxmg==
X-Received: from pghw14.prod.google.com ([2002:a63:f50e:0:b0:cda:c74c:ca8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b86:b0:3ac:a11a:7c84
 with SMTP id 98e67ed59e1d1-3ae58195de0mr2519930a91.65.1793214189231; Wed, 28
 Oct 2026 12:03:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Oct 2026 12:02:58 -0700
In-Reply-To: <20261028190259.1819571-1-seanjc@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261028190259.1819571-1-seanjc@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028190259.1819571-7-seanjc@google.com>
Subject: [PATCH 6/7] KVM: Plumb the full request into __kvm_vcpu_kick()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Atish Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Stefan Teodorescu <fane@google.com>
Content-Type: text/plain; charset="UTF-8"

Plumb the full request instead of just a "wait" boolean into
__kvm_vcpu_kick() so that it can use kvm_request_needs_ipi() instead of
the flawed kvm_vcpu_should_kick().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  2 +-
 include/linux/kvm_host.h           |  6 +++---
 virt/kvm/kvm_main.c                | 17 +++++++++--------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index bbe7378ad0ef..011dc422af78 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -38,7 +38,7 @@
  */
 static inline void kvmppc_vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	__kvm_vcpu_kick(vcpu, false, true);
+	__kvm_vcpu_kick(vcpu, 0, true);
 }
 
 /*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9db42f58c561..035b1bdd8c09 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1570,11 +1570,11 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
 
 #ifndef CONFIG_S390
-void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait, bool force);
+void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, int request, bool force);
 
 static inline void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	__kvm_vcpu_kick(vcpu, false, false);
+	__kvm_vcpu_kick(vcpu, 0, false);
 }
 #endif
 
@@ -2314,7 +2314,7 @@ static __always_inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
 static inline void kvm_make_request_and_kick(int req, struct kvm_vcpu *vcpu)
 {
 	kvm_make_request(req, vcpu);
-	__kvm_vcpu_kick(vcpu, req & KVM_REQUEST_WAIT, false);
+	__kvm_vcpu_kick(vcpu, req, false);
 }
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e1a9da8b43d7..f1792256576b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3913,7 +3913,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_wake_up);
 /*
  * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
  */
-void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait, bool force)
+void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, int req, bool force)
 {
 	int me, cpu;
 
@@ -3948,14 +3948,15 @@ void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait, bool force)
 		cpu = READ_ONCE(vcpu->cpu);
 		if (cpu != me && (unsigned int)cpu < nr_cpu_ids && cpu_online(cpu)) {
 			/*
-			 * Use a reschedule IPI to kick the vCPU if the caller
-			 * doesn't need to wait for a response, as KVM allows
-			 * kicking vCPUs while IRQs are disabled, but using the
-			 * SMP function call framework with IRQs disabled can
-			 * deadlock due to taking cross-CPU locks.
+			 * Use a reschedule IPI to kick the vCPU if the request
+			 * doesn't need to wait for a response (or there is no
+			 * request), as KVM allows kicking vCPUs while IRQs are
+			 * disabled, but using the SMP function call framework
+			 * with IRQs disabled can deadlock due to taking cross-
+			 * CPU locks.
 			 */
-			if (wait)
-				smp_call_function_single(cpu, ack_kick, NULL, wait);
+			if (req & KVM_REQUEST_WAIT)
+				smp_call_function_single(cpu, ack_kick, NULL, true);
 			else
 				smp_send_reschedule(cpu);
 		}
-- 
2.56.0.313.g2479322e68-goog

