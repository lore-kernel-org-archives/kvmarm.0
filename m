Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DEF20D4F8
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 23:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441351; cv=none; b=mVwSUUmgCisuh9YlJM3CRzDk64cZjWE44Pj7oIFQNE7TGN8n/aFPOZMMqmr0GxBrPXeLmrRLzFnURsMONe2rgldrkldCBQJ+2j3USZBoJUN11qJmnnHEmE09WTHlHOoLCnujJpu4JtSFn5u3AMI3Atj0tOh1J00mPUmyzvKDwnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441351; c=relaxed/simple;
	bh=Pgnsnfhe7JEsCHeo8nxgfh9t3AoyozrxKe/Nn1f4YRk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OrjwXcGVjeMKbQhwYjmpZ1briQZarEd1A1zfwQeuJrPqQZ8xY2SwwFu5OzdgmC8wEj+XY7oJtc7U8mV0Wxkq23NzR9S+rpwVog/2k0Rkun57ACbgZd/J6Ugjit4UiYY4ECKEuQi/SL+stL8HsCdiijajX5xVYqqtHce5bY655k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MOArCPgr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MOArCPgr"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso16611815a91.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 15:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441349; x=1741046149; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TGU0ybTwy223eIpDzZVLI/W8vnqy8rZ9uLMIqzhcN/c=;
        b=MOArCPgr112C91pIrtdQg9v+yxPZTkMwPqWi4DXQS65aIe2J7U27KrZFPvAfRHVcVY
         RMGGzeEJaioqrvTl9zBwh6emM1G4O74iyura6zS7Nbxp1lkXx2WcVT6A3YfW3T8atF93
         HKp2C21Dozpe+d8BY7CYoZ8a/6eB0MhDFUsLxlhiTV6iu9Fjd41IsVDO1/nBVeBLik8N
         Tsc96Abe7Cvq6wbm6XRvEuD00RDla5C3NBh0XcOuIU4XGwii6+JS6Xw0FIAHbEp4mzgz
         z/d3J1AW16WEKJezN0h6ZoxDO3biTi5Lj0QXm2aJSZ2PReyAuyuuKtqUZ/FNsvlQTc1P
         bbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441349; x=1741046149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TGU0ybTwy223eIpDzZVLI/W8vnqy8rZ9uLMIqzhcN/c=;
        b=Kvd1cbWDMpPUXmISfwC61z2U0/LOEXNeILa3z9NWp66p3yctQiDJf/fzV9RvzqB3Ft
         CcY83D2crqcSb1KYUU9FohBLdIzmCznxOC+3jJBa0JzsBeDjlYnU0qEXeBxzAAU9WQdK
         FGIklHFse3xd6fnxdO8sKnBdfiM2/egrwsTdNtzRph2Yp+QaPezYLMgiAGoMskcNs27f
         04EJp4Qq3IzIr1Onct+18YZk7PXugeyV1wXX8KJM4PiRqNdt8IriajFR/KbXmKaKf+2o
         lrf6EHxM5BTDvwz1+whRAfsIw3N4XnzoFAZcjqrvfMsMq5Pj3R6RoJ0x9mP6+fYOU0Gb
         pljg==
X-Forwarded-Encrypted: i=1; AJvYcCWgExjvyZ3K8yHkSTAVeYtVK/D+APFPjunEQBc1Nu797V/wIbiV97rot/JC9P4SOCfcTBxAy9A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9soMroA8etWaa3QFFC/lSLIYOLwMkVLeUehZbb6fJk/fDs8Gj
	WiEUR5owVkLoD6KXrABuzCCPtDcCs/3MlEzNDZ/5PhRfXHbHTlUJy49CNQS3GkHsfUZHN7NBKuL
	bxg==
X-Google-Smtp-Source: AGHT+IHcos0szxLwYcsW2Q/WbhHjoZ/1wFjhF3Xa+8fw1kzKNZT2q6/VDS58iA2uFYrVe3USusRDS/R8AlY=
X-Received: from pjbnb15.prod.google.com ([2002:a17:90b:35cf:b0:2fc:b544:749e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7cd:b0:2fa:17d2:166
 with SMTP id 98e67ed59e1d1-2fce7b40077mr23992311a91.31.1740441348957; Mon, 24
 Feb 2025 15:55:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:37 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-3-seanjc@google.com>
Subject: [PATCH 2/7] KVM: nVMX: Process events on nested VM-Exit if injectable
 IRQ or NMI is pending
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

Process pending events on nested VM-Exit if the vCPU has an injectable IRQ
or NMI, as the event may have become pending while L2 was active, i.e. may
not be tracked in the context of vmcs01.  E.g. if L1 has passed its APIC
through to L2 and an IRQ arrives while L2 is active, then KVM needs to
request an IRQ window prior to running L1, otherwise delivery of the IRQ
will be delayed until KVM happens to process events for some other reason.

The missed failure is detected by vmx_apic_passthrough_tpr_threshold_test
in KVM-Unit-Tests, but has effectively been masked due to a flaw in KVM's
PIC emulation that causes KVM to make spurious KVM_REQ_EVENT requests (and
apparently no one ever ran the test with split IRQ chips).

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bca2575837ce..8220b09e91ce 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5084,6 +5084,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 		load_vmcs12_host_state(vcpu, vmcs12);
 
+		/*
+		 * Process events if an injectable IRQ or NMI is pending, even
+		 * if the event is blocked (RFLAGS.IF is cleared on VM-Exit).
+		 * If an event became pending while L2 was active, KVM needs to
+		 * either inject the event or request an IRQ/NMI window.  SMIs
+		 * don't need to be processed as SMM is mutually exclusive with
+		 * non-root mode.  INIT/SIPI don't need to be checked as INIT
+		 * is blocked post-VMXON, and SIPIs are ignored.
+		 */
+		if (kvm_cpu_has_injectable_intr(vcpu) || vcpu->arch.nmi_pending)
+			kvm_make_request(KVM_REQ_EVENT, vcpu);
 		return;
 	}
 
-- 
2.48.1.658.g4767266eb4-goog

