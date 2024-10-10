Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBF11CFEC9
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584747; cv=none; b=tAiUyZkTuYX3qwz18TXTyBvh631MRfMl9Y/PZxCJnrvt5kv22cxk0q1Q8/mWRUqcAYAB2HoSvb0lz6CXq6UBe/vUQ8opInh8BETk5kthmjDFtDeNwg/je1J2sYNHOyydvHTNuJCH2ZSXjq0jvt+Sv9tsNdh5yFFQ3eslhC8YXzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584747; c=relaxed/simple;
	bh=H3zY/Xt0t+c4LMWpCCUO1umdZ2mHGDI4Sis4Gpw2f4E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V0HI4gfCzEjFycC/+wOYIV22+VWWgInbTRcNeORlSqKsMJe75U4kZuxLXoV/PUWCLsTOniKXswhiV6ywrioK/mageKeMZ69iSQyA/r6SAKvnRpHIbnpWUUgC7TIZYshL7UX3BJJyCDytBp+kZXyWBqNGR4Z4S6je//iJgY3ApZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ROIszr7o; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ROIszr7o"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e321d26b38so29252047b3.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584744; x=1729189544; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnti8P2TQudE7lvlkZdCl8Wq+TvGW4tpGYbCykNWsXw=;
        b=ROIszr7oMfTX5CnHqG1NxTDXMPA+tFXegkjVz77TsQNGt8PHV3pRkYEo6vXKEjZq5M
         f1kpUEiNMVNzN+RXAK6it5wSBn6mPt8wSTUz+YSpNjGGFJOVdEfPSNC61VaP+iVyHymR
         EJaJplvqO9ICKxXXIZlqkSCBgoyudMM5WrZHB9I4VpqA21ngzXEap3VadRBqS4/YqeH4
         XlPrvYaNDu2GWWMS0VPLnvqm+VGCfP4h9B1XEtF015omhf5GNgWgfigk6hwuMG7UoUUq
         fI7lM1WyFCzqS1Hm5Lhp9Kb4uboFr0RInPt878ZgKqzV97Zhd3RnMNsAb6AUlsUDbj3Y
         Wo8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584744; x=1729189544;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xnti8P2TQudE7lvlkZdCl8Wq+TvGW4tpGYbCykNWsXw=;
        b=R6deumdUxEuM6i6tb2vcoAgjmKiTVAuqdKsWeZo8an3pkxegsYqQuuCGKw5mNGfUzC
         uH8H7isMCR03d+rL1+iugb4V2kDnfQJ6dSYYVd07ZLIz2K1y5A299J+I7qOApU9Xas5w
         W/5mN597fy1Qqs9Q+PvbAvt39oENXKDI92LuT6XoSqR5TQsqEu9dIGurxxg6m1qNIj/Q
         njOK8zinAvV7TLzyXCnBQ6IkPBlnbb1fNoWknR9KIwmZEJKWQeVGdEBAIHHLhyCbts1h
         xG+J8GebuPZ2A+3XKSl3w9tGB9YSDkhHLvpavDRt0wk30IjL+g0/hU5+ko7daMzmGJO/
         qfuQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0wyX/6uTar77qXSb8sCmN/xNDD0/33LbESvXaY7waqXxLr4aqkAK2OndzQTf921NapmdoGC0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbYTueM+g4jQLi+UTslxuaYAMqTZarg8Bs0iXKGQkRVkPUXY9J
	UgtZnE0ya1Z0lZ4/GfUspU3pOODgiLZoeBOP4DrcrmNv3kwhbFmCzT0D+bguKBhLT4Xy0s0SmTY
	Jnw==
X-Google-Smtp-Source: AGHT+IEdX//xUJq0LlzHSFsWnzcNANrEE9KtnndGvFzP5BAu23zXYFVXA6eeBi51F5M5i08FgAsxiLe5HbY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:300b:b0:6e3:f32:5fc8 with SMTP id
 00721157ae682-6e32217bbe0mr502817b3.1.1728584744665; Thu, 10 Oct 2024
 11:25:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:27 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-26-seanjc@google.com>
Subject: [PATCH v13 25/85] KVM: nVMX: Add helper to put (unmap) vmcs12 pages
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
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a helper to dedup unmapping the vmcs12 pages.  This will reduce the
amount of churn when a future patch refactors the kvm_vcpu_unmap() API.

No functional change intended.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fb37658b62c9..81865db18e12 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -314,6 +314,21 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, str=
uct loaded_vmcs *vmcs)
 	vcpu->arch.regs_dirty =3D 0;
 }
=20
+static void nested_put_vmcs12_pages(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
+
+	/*
+	 * Unpin physical memory we referred to in the vmcs02.  The APIC access
+	 * page's backing page (yeah, confusing) shouldn't actually be accessed,
+	 * and if it is written, the contents are irrelevant.
+	 */
+	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.pi_desc =3D NULL;
+}
+
 /*
  * Free whatever needs to be freed from vmx->nested when L1 goes down, or
  * just stops using VMX.
@@ -346,15 +361,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.cached_vmcs12 =3D NULL;
 	kfree(vmx->nested.cached_shadow_vmcs12);
 	vmx->nested.cached_shadow_vmcs12 =3D NULL;
-	/*
-	 * Unpin physical memory we referred to in the vmcs02.  The APIC access
-	 * page's backing page (yeah, confusing) shouldn't actually be accessed,
-	 * and if it is written, the contents are irrelevant.
-	 */
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
-	vmx->nested.pi_desc =3D NULL;
+
+	nested_put_vmcs12_pages(vcpu);
=20
 	kvm_mmu_free_roots(vcpu->kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
=20
@@ -5010,11 +5018,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm=
_exit_reason,
 		vmx_update_cpu_dirty_logging(vcpu);
 	}
=20
-	/* Unpin physical memory we referred to in vmcs02 */
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
-	vmx->nested.pi_desc =3D NULL;
+	nested_put_vmcs12_pages(vcpu);
=20
 	if (vmx->nested.reload_vmcs01_apic_access_page) {
 		vmx->nested.reload_vmcs01_apic_access_page =3D false;
--=20
2.47.0.rc1.288.g06298d1525-goog

