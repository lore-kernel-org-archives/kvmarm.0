Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58C120C48E
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441350; cv=none; b=u/hYFAQ45L1568J83+OBa+PDE302QFvSGNtEXjfkPga/za/0wGPLseVQQnoyF1ElUJDhpI2/OmXpdwRY/QHdAMvmUGuuRHx7J/XI3psymIFumi/Lg7PtVgaPLP6cbBCj2AP6kJF+tMRL0UtGtJLJwzp8/4rC+KOwNz1h92PjFQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441350; c=relaxed/simple;
	bh=eD5WSaoS4BIVKcmvcj9oK2wOfjdwtX85NN6YC8D+ij0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l9/bLcQpMhxq9dviK38O5ayahVLGsdClKymuSR29suiWFUnGB+/Xo46VS6fvH8al8zQGZPCelzdhiZzS+L+yAjftauL4nVc0VdTDqNBs2MmHP0ARtiG0I8GCYzyfmmfXlgfP/IeBhA1jlI7TH57p4O/GOpsob2NZkqOvpBbFO5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=emjhZb6q; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="emjhZb6q"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc46431885so16479497a91.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 15:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441347; x=1741046147; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VUFWBiQUtkyxtQjLqO6VHI65Q9aVoo/tjEK11vAPqoc=;
        b=emjhZb6quvu6AVAdWRR6HTTRaSkG+u/e+Y7Vfs9mr9ieuHAUKnDw4mH+xGyQn9PjzD
         32VTf2nwFtDccFhb5EzUmoavw4Iw/LCLp13TqSyTusx7J+TH1RL70luF5RFwhs+Lqocf
         cg4yHcOwp6DkN8JBNvsk+aRnfp1e2Cozwm+uiFF3SS7XVV/lRqeYZclr7QQf4Etdo42C
         zWBfGYYOgN03nLHO/6hisPbCT7VruGqzOtQ9QSKPflvJVWfb/esg0imBlU81HYEAe8fX
         jmIcjwj3R1eT0yxC+tuZiqf59d8jn/Ns1VhOdUGIAARCJbVBjd6hmbu7sv1f2e6m2/Mf
         K3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441347; x=1741046147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VUFWBiQUtkyxtQjLqO6VHI65Q9aVoo/tjEK11vAPqoc=;
        b=oNP0L8T3YB9Rckgs8ksD3kfC3CpCqId6EVSqxzrcX8EJTe997R0tTXjRdTyGH2I1J6
         FGdPo1Rz/qwjGGr9547Y+Oc3HJXTSI6Q8VBLwYpKcCeVDURIlzQ86O1Hzxxo/jIDI7xt
         VvtA4MOo1AVz6iDDuGUg5yh27XVrtA2lQEWegt1CaH1g2VHkwyUoimiL3Crqg7ijZ3U9
         M875zxf9eEUbOb8cPvuvTWnWVAnSYAZplLcCL3m/SOQJFe3aP3aL7B9SWeOSmdQ3s58a
         c0nmtneHWTuh76utcY71ZT4x9dGgsFtb47wBfQlRPht3jkq/sXplLCotzSdmiKrQuWZE
         br4A==
X-Forwarded-Encrypted: i=1; AJvYcCVCXFCz7f10+CajsKsX7e8o5BZyTvSUODSEr362dH9V8yGja4yJsPGTEsXK9cWqp4paD6QyCa4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs+4wF11MhLqbmEpo35Mue2/J9WxKbCordxxVw7bMacrfs6E11
	7V11YVLFIZLkThoX5/2IZome6NwobcnEHkY89yt/LnMjxCmax/d+MWazxM4LHAGE2lUke/pNcuS
	Rlg==
X-Google-Smtp-Source: AGHT+IEskcg8NGcMgI3lzGvHxN+7n9pLx0XcpaLq7IsEpPM2kCgPZOpZWimEzcKRut1Ut1sQ02q7DWsQk2M=
X-Received: from pjuw11.prod.google.com ([2002:a17:90a:d60b:b0:2fa:1771:e276])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18c:b0:2ea:bf1c:1e3a
 with SMTP id 98e67ed59e1d1-2fce86ae2cbmr28015424a91.12.1740441347216; Mon, 24
 Feb 2025 15:55:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:36 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-2-seanjc@google.com>
Subject: [PATCH 1/7] KVM: x86: Free vCPUs before freeing VM state
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

Free vCPUs before freeing any VM state, as both SVM and VMX may access
VM state when "freeing" a vCPU that is currently "in" L2, i.e. that needs
to be kicked out of nested guest mode.

Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destroy was
called") partially fixed the issue, but for unknown reasons only moved the
MMU unloading before VM destruction.  Complete the change, and free all
vCPU state prior to destroying VM state, as nVMX accesses even more state
than nSVM.

In addition to the AVIC, KVM can hit a use-after-free on MSR filters:

  kvm_msr_allowed+0x4c/0xd0
  __kvm_set_msr+0x12d/0x1e0
  kvm_set_msr+0x19/0x40
  load_vmcs12_host_state+0x2d8/0x6e0 [kvm_intel]
  nested_vmx_vmexit+0x715/0xbd0 [kvm_intel]
  nested_vmx_free_vcpu+0x33/0x50 [kvm_intel]
  vmx_free_vcpu+0x54/0xc0 [kvm_intel]
  kvm_arch_vcpu_destroy+0x28/0xf0
  kvm_vcpu_destroy+0x12/0x50
  kvm_arch_destroy_vm+0x12c/0x1c0
  kvm_put_kvm+0x263/0x3c0
  kvm_vm_release+0x21/0x30

and an upcoming fix to process injectable interrupts on nested VM-Exit
will access the PIC:

  BUG: kernel NULL pointer dereference, address: 0000000000000090
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  CPU: 23 UID: 1000 PID: 2658 Comm: kvm-nx-lpage-re
  RIP: 0010:kvm_cpu_has_extint+0x2f/0x60 [kvm]
  Call Trace:
   <TASK>
   kvm_cpu_has_injectable_intr+0xe/0x60 [kvm]
   nested_vmx_vmexit+0x2d7/0xdf0 [kvm_intel]
   nested_vmx_free_vcpu+0x40/0x50 [kvm_intel]
   vmx_vcpu_free+0x2d/0x80 [kvm_intel]
   kvm_arch_vcpu_destroy+0x2d/0x130 [kvm]
   kvm_destroy_vcpus+0x8a/0x100 [kvm]
   kvm_arch_destroy_vm+0xa7/0x1d0 [kvm]
   kvm_destroy_vm+0x172/0x300 [kvm]
   kvm_vcpu_release+0x31/0x50 [kvm]

Inarguably, both nSVM and nVMX need to be fixed, but punt on those
cleanups for the moment.  Conceptually, vCPUs should be freed before VM
state.  Assets like the I/O APIC and PIC _must_ be allocated before vCPUs
are created, so it stands to reason that they must be freed _after_ vCPUs
are destroyed.

Reported-by: Aaron Lewis <aaronlewis@google.com>
Closes: https://lore.kernel.org/all/20240703175618.2304869-2-aaronlewis@google.com
Cc: Jim Mattson <jmattson@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58b82d6fd77c..045c61cc7e54 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12890,11 +12890,11 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		mutex_unlock(&kvm->slots_lock);
 	}
 	kvm_unload_vcpu_mmus(kvm);
+	kvm_destroy_vcpus(kvm);
 	kvm_x86_call(vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
-	kvm_destroy_vcpus(kvm);
 	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);
-- 
2.48.1.658.g4767266eb4-goog

