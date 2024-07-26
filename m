Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E4E17A5A9
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038007; cv=none; b=gPUMjGQXFKLP4//1k3tx236U3U1o8UM2iEwU6iynEOLKDKh7ZVM545d74poQyxTNEgnkaLrqNsE1sHnFECirUfk0y6BzHEhuWsVAqtOZOeYP1wT5yrJyaJcUdLWmpnAqVibf+OAi5H3+HJNvoP5R0AjP1X9Y3IbPRHCzXM/9e4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038007; c=relaxed/simple;
	bh=hTCJS839o2gRLTMMefhng3YEMkDWbv7HNmHQt1L2Wh0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N7SVhv0zp9P+txmvgNLVA+aJkab1uPbtQ1ybnioMbV+hvghmEei15WaLnZnYk6tDaPC7qyYvLcgbMYa4VdepQeCNlfaB2pCZvFmscd85ezcaTnT8HcupeL3OX1Xp3Duy7uZjUBsUEF3uNvpnkGqIDDfB6mRBSJycCXEYLKuAxQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vlf9WQla; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vlf9WQla"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02b7adfb95so380402276.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038005; x=1722642805; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xlV4Qu7sFx9TmbqoV45yeLGjyM3cIO8KzptAxLEtfNk=;
        b=Vlf9WQlaEpxuz5XwQXmwDDW2U7II1xD4xSr/r1UG7jLM+I6sGzUiVCLxY51xHQC+G/
         AjkXIYCd5LKLnjidWOiulVgiVs75kqk0cM23eKdKFKHAtXkByUd7L77BJaOEWw5sFmpq
         80QJMd7PqhlEkFiz6RZqtHV0DLV7FlscGynHGuh5DXHAZUpTyw8oKhPMM4isI5VKbUIF
         +Sc44gfv9PB6sVRg/l4ATw8O+I95lRkrFOMBFgK8de1d2S6a8yCZswwq/aOEHCxAFEj/
         XGCiyAG2vBqwnYGnFqbrntowUitiHnaA0SzKkQbTQX5Jluonv37ELuaCkxfwbrLlbuwK
         VP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038005; x=1722642805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xlV4Qu7sFx9TmbqoV45yeLGjyM3cIO8KzptAxLEtfNk=;
        b=fSLFolp/p1aQYaFV4dpqHToi4E5fpgnokf/aKCE7SOFLxrmOa5GyFpTNRcojMxXOcn
         knNKDrkxU1tnKZiuQ2nl8yr3RK8j5Fwp9/zdze5YyMBv7ahgymSBrtc4riWPtlVUTZE5
         RBbCwHVp8xtZNrthHeq1UoOnOSGHTVOludt/JCojgiko8+4Dasz+I6F/3LnNYmxggxhk
         p0ur0YwwNPPHyD9ydmCsb2J5J5yDJI/TAwWhuvHkLoT6aRA8qBzhln4oP9FsCdyLVQGK
         5Q+cla0yOoydBmdv+rXDLAGMZ8MLYR9FGwk/dcoqewjg39LCbvjlGhqcYWPIKbC7U6GY
         O4LA==
X-Forwarded-Encrypted: i=1; AJvYcCWs5MYouD4JkpvtQEaIrQcOWk6SEoRBvoh2kOj2bXOzD6KPOU4XkC8/X5EC/dqW4o1LEfltyFLi5g2tVnjny5KuO4Vlz02C
X-Gm-Message-State: AOJu0Yz4Hsph/0onyRu0c/CW1I9+4otYO2BdrakVLtyAj7tthuQJBYeA
	GXz9yvwcOFdGHiVXTRURDegl+MSoICtXVzcseT/H+5nuWwDYpe4LAftL0A0Hi7LupIsuUoE1yek
	Lkg==
X-Google-Smtp-Source: AGHT+IGzjee8SmO1Sa/b53YWKn3FsBJYizAY4tObHxd1ZNVi3RptE5IxRlqmItgGIGNjjqk15j+5giHmBC8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:8d2:0:b0:e03:53a4:1a7 with SMTP id
 3f1490d57ef6-e0b5454c840mr15153276.10.1722038004800; Fri, 26 Jul 2024
 16:53:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:32 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-24-seanjc@google.com>
Subject: [PATCH v12 23/84] KVM: nVMX: Add helper to put (unmap) vmcs12 pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Add a helper to dedup unmapping the vmcs12 pages.  This will reduce the
amount of churn when a future patch refactors the kvm_vcpu_unmap() API.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 372d005e09e7..8d05d1d9f544 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -314,6 +314,21 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vcpu->arch.regs_dirty = 0;
 }
 
+static void nested_put_vmcs12_pages(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * Unpin physical memory we referred to in the vmcs02.  The APIC access
+	 * page's backing page (yeah, confusing) shouldn't actually be accessed,
+	 * and if it is written, the contents are irrelevant.
+	 */
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.pi_desc = NULL;
+}
+
 /*
  * Free whatever needs to be freed from vmx->nested when L1 goes down, or
  * just stops using VMX.
@@ -346,15 +361,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.cached_vmcs12 = NULL;
 	kfree(vmx->nested.cached_shadow_vmcs12);
 	vmx->nested.cached_shadow_vmcs12 = NULL;
-	/*
-	 * Unpin physical memory we referred to in the vmcs02.  The APIC access
-	 * page's backing page (yeah, confusing) shouldn't actually be accessed,
-	 * and if it is written, the contents are irrelevant.
-	 */
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
-	vmx->nested.pi_desc = NULL;
+
+	nested_put_vmcs12_pages(vcpu);
 
 	kvm_mmu_free_roots(vcpu->kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
 
@@ -4942,11 +4950,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_update_cpu_dirty_logging(vcpu);
 	}
 
-	/* Unpin physical memory we referred to in vmcs02 */
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
-	vmx->nested.pi_desc = NULL;
+	nested_put_vmcs12_pages(vcpu);
 
 	if (vmx->nested.reload_vmcs01_apic_access_page) {
 		vmx->nested.reload_vmcs01_apic_access_page = false;
-- 
2.46.0.rc1.232.g9752f9e123-goog

