Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0745E2D877F
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510301; cv=none; b=btvhUWjYlFnw3LRPy/VkSLaqXYWcnMLQbkDNFS/M43WPXSOrqi1cEodJysuDzVlvG4lvrmAEkqk1JaT+j9es0ThfLxbv1t9LiPRXpxGskxmXtXGUaCkHHYm38BDTeuPo8BJ9npVihNNqdtkqA4L2Z1XpLkST1crv951dyszB+VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510301; c=relaxed/simple;
	bh=jAkcPQi41ZRUiWgI9bcgpSonHu4bIB2ojvxbKVROfG0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GyMxKh19zYB0h2nbDrnShhskv2+MuGynCMJ8lhDH89WtkCWBaAlUWX3Oqe1RhNig2RMDyzkYHhFZWQBWXNWfiUKrZn8to13mgbeVrqpPnTbcaic7i17e5ACdOoryoF5HXsDlQ/csAk8aqQ08Xo3TFa1lGABVMFJ8JcviteEtdBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oF9bSfLX; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oF9bSfLX"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b421b03d498so121494a12.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510297; x=1755115097; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=z6mRW3QO5+v30hMhQPo0nMlPZQjpAzxmFKtx3JiIrDs=;
        b=oF9bSfLX+pAE0mhkQh1/Ai9AV/sHhxfTeqliryyaQLu3SkB2IfSiR6G888rcdHXcMZ
         k09XqOgZUyTJP2Z2uWhap6FuM/4PMmzzg8RDqtuwrAu87VxuipruKI/V6esgh41FM4/y
         zpc6xrxLkr0IkL2RBvYic+OBPErvtJcoFTP//Ara/gsdTJs9nXKORmAHbhHbywJsHL3P
         BrPmttYawfvleXcCKl4U7lpsDxEmY9Uez/e0EZKwOayUtHX+wEJOLw++Ub5aCjT7q4Bc
         8FgyLu2HQVKg/zuMO6RclDu45gPBdS8Yr7yZfjOidnryjZKa8WDvdT/qZ9fXKfF7btkd
         aLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510297; x=1755115097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z6mRW3QO5+v30hMhQPo0nMlPZQjpAzxmFKtx3JiIrDs=;
        b=F8FidmAnVBDIP8E9ZHQIYCJiB5CYhU/XeVsak4VoeB2VC3ynGgmkL99WLJrCBjO2Rs
         dJrjjY47LawpZ1lY+CvLbq/jG6v9aCAkKgsDKZjN8pLjhG3vPTbzRhyCcmIl9gkKc6sW
         srYRqDLYOILe+yTQcBD2r80wfD713pz/BfDee8bdk7/fsNyKcxNiv5C+7xg5vZ/nf/WV
         g+oT/kYdeR/zkV6Ge5fyyCPVhzEb2JM2X+L6t+HOd79SJSBXcYduTsKpk8yTwfDnKdSl
         VUbiRwPYNZn9tXEYHPbGNM47KXeFrUTfdw2WWm4ohzyqr4VP1qP3LVY5FbTsJM6beX5g
         nhjg==
X-Forwarded-Encrypted: i=1; AJvYcCVf8RwuLJ2rCMbScazbxB918S5A95drJfqNHPpF10QT0MlHLaFI0IwODx5DKVwmrwB/cJ+eWpo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcI0DAP3DGfbbvxgBLWTPcnhtpa7N9HtO0DV9upDGup04FLXAl
	PDGJov/Gl0LNcbu++xs24tt1t3X7jC5h8ia7UBnWKm73JdnJhTleF11H1IaVik+yg6eXF7OcL0l
	njNmzCQ==
X-Google-Smtp-Source: AGHT+IF1L5jDO3EJUjPLOXu/s6M1eVdU0dJDtzEbPUmRbyNFn2oUqefjt3C97kWpA7IvjzuPBYgNpNpIe1I=
X-Received: from pgbcv5.prod.google.com ([2002:a05:6a02:4205:b0:b42:49c8:5488])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:548d:b0:23f:faa0:2c27
 with SMTP id adf61e73a8af0-240330367c3mr5937028637.20.1754510296766; Wed, 06
 Aug 2025 12:58:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:48 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-27-seanjc@google.com>
Subject: [PATCH v5 26/44] KVM: VMX: Add helpers to toggle/change a bit in VMCS
 execution controls
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Expand the VMCS controls builder macros to generate helpers to change a
bit to the desired value, and use the new helpers when toggling APICv
related controls.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 +++++++-------------
 arch/x86/kvm/vmx/vmx.h |  8 ++++++++
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6094de4855d6..baea4a9cf74f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4356,19 +4356,13 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 
-	if (kvm_vcpu_apicv_active(vcpu)) {
-		secondary_exec_controls_setbit(vmx,
-					       SECONDARY_EXEC_APIC_REGISTER_VIRT |
-					       SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-		if (enable_ipiv)
-			tertiary_exec_controls_setbit(vmx, TERTIARY_EXEC_IPI_VIRT);
-	} else {
-		secondary_exec_controls_clearbit(vmx,
-						 SECONDARY_EXEC_APIC_REGISTER_VIRT |
-						 SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-		if (enable_ipiv)
-			tertiary_exec_controls_clearbit(vmx, TERTIARY_EXEC_IPI_VIRT);
-	}
+	secondary_exec_controls_changebit(vmx,
+					  SECONDARY_EXEC_APIC_REGISTER_VIRT |
+					  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY,
+					  kvm_vcpu_apicv_active(vcpu));
+	if (enable_ipiv)
+		tertiary_exec_controls_changebit(vmx, TERTIARY_EXEC_IPI_VIRT,
+						 kvm_vcpu_apicv_active(vcpu));
 
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d3389baf3ab3..a4e5bcd1d023 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -608,6 +608,14 @@ static __always_inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##b
 {												\
 	BUILD_BUG_ON(!(val & (KVM_REQUIRED_VMX_##uname | KVM_OPTIONAL_VMX_##uname)));		\
 	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);				\
+}												\
+static __always_inline void lname##_controls_changebit(struct vcpu_vmx *vmx, u##bits val,	\
+						       bool set)				\
+{												\
+	if (set)										\
+		lname##_controls_setbit(vmx, val);						\
+	else											\
+		lname##_controls_clearbit(vmx, val);						\
 }
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
-- 
2.50.1.565.gc32cd1483b-goog

