Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2272B1509BF
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618279; cv=none; b=TPfmOrOyzZTBZ9mE+kspm1nExlbN3te0tvHPGaLHb7l8ELLDca7LmiXi20dwGOHAgIrGv5hHxko79MwKDUKX0sXbsdHj1HOncvvOoqa8z+Z8RoL61bnXkTZshY/k+IvF3ZWo+1EM+BZvfbxprWtn2qZWhxUOOE0fv0kPsOkd79c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618279; c=relaxed/simple;
	bh=K2jUeoVXhrObEu5srpCVm7xwdKmVYTP7LlgnH3ByD1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DUATU1ie2iwGB/OAetDGOwgDcsNfEmJf0KTemLII2gXiVvCHeq5VZlxRvw5a+wBltE1Se4UqYXVAFHA+k4ed6xVIXGP1MhpDM8JxgnQ2REVoEwmWns/XLMamthSOs2aFzxC2lOm/QdpLrrPtXOI2f4FosHXfwKB5PkcAKuXJ9gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aw6N4kxL; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aw6N4kxL"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-608575317f8so59568507b3.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618277; x=1709223077; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yBF7jJN1+Xu+ov0cdEcK8kK8shoa2Uezv3Eymqp79xw=;
        b=aw6N4kxLq7EciabkeiyLqdDiTqERRzv6LKCzMtAxi8qS0HoND1bH+243YrYxNilRsr
         QR3PT9hFxm+3C4zK41OjiEyLoudLfxGoTL1GLQxNHL9skrzUp7wLlqTH2Rj1MJm6rQDC
         PgP1DcboVonC8n7A7DXDXTFgGqcFQv59DP7dm7jdwV+41iQFanNLC0kWY5OUQ8CVj+3k
         rKFBTUc1iDMYUz2uVQHiWUyDhc2GY7n4uheSW0ZN13KtOBnliO8NCuMxmayNYRd4x5mu
         WREE0VzA+beFAgOmjXKLSARKgmohB2YOcPKfzYbrsRRbEBl86cp1DKXUVoJumN/6Qa0D
         zSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618277; x=1709223077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBF7jJN1+Xu+ov0cdEcK8kK8shoa2Uezv3Eymqp79xw=;
        b=kWVaKSVDElukxekSTfM/ypdpghp0BgOX44+dEHxFjR7srXeJ+ogc/VVksKHmYdzh3j
         zaPU6NKcwhfZ66BdYGtspfsqoJpJNc7CHpXdM3/YUG3V80mQu2PzLXoy/wi75ra8UySH
         s+ZGfbdkwYZzAe8yhczNbODJcX2rgylZ1W1rSKsTdH4kCNH7bZ2yjH2JmOrOAth4xeYH
         mCqgqhdxn2nI0nGpNflSTOX3wxweU520rTXjP8KLwd7vn9vxQSwCbYC7uku4Z7GWYjl7
         T1m8gmeUsKj3Rb/YCSXW42tv/FBUDt65cazDy13Xbhs7Le/x8v5BEnizZ84ztXo+OuqC
         fRyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBtjsHXXJ5idGzroI9yS7AXqYsboh+eVG9sumZynjME9gUCfjkYjQA7t0nCC7pK8jhsbN7+OPXYOGZUWNkw9XRSjMKGlCQ
X-Gm-Message-State: AOJu0YxihDoq1lvpzxiF5cWyoFefct7gHGMBCrk600A7l/xj9tQaGNoc
	PR/K1IMSc1wpO6bCSS52w7GJrLbwWMYsnqNd8g1dWgcqVr2saC6Dza4su6/vZBXOGiuBqvphmw=
	=
X-Google-Smtp-Source: AGHT+IGrCya8m8uAuRpFxFybFUAEU0iwPgGXeWFUDgySqY7is6FBp4ITlzxd28T47Jmynwc+rSuknB6rAQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:d685:0:b0:607:7564:a830 with SMTP id
 y127-20020a0dd685000000b006077564a830mr3732341ywd.0.1708618277048; Thu, 22
 Feb 2024 08:11:17 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:32 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-12-tabba@google.com>
Subject: [RFC PATCH v1 11/26] KVM: arm64: Add initial support for KVM_CAP_EXIT_HYPERCALL
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

Allow the VMM to hook into and handle a subset of guest hypercalls
advertised by the host. For now, no such hypercalls exist, and so the
new capability returns 0 when queried.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 25 +++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c       | 19 +++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 55de71791233..f6187526685a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -325,6 +325,8 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+
+	u64 hypercall_exit_enabled;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c0e683bde111..cd6c4df27c7b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -60,6 +60,9 @@ static bool vgic_present, kvm_arm_initialised;
 static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+/* KVM "vendor" hypercalls which may be forwarded to userspace on request. */
+#define KVM_EXIT_HYPERCALL_VALID_MASK	(0)
+
 bool is_kvm_arm_initialised(void)
 {
 	return kvm_arm_initialised;
@@ -123,6 +126,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_EXIT_HYPERCALL:
+		if (cap->flags)
+			return -EINVAL;
+
+		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK)
+			return -EINVAL;
+
+		if (cap->args[1] || cap->args[2] || cap->args[3])
+			return -EINVAL;
+
+		WRITE_ONCE(kvm->arch.hypercall_exit_enabled, cap->args[0]);
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -334,6 +350,9 @@ static int kvm_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES:
 		r = BIT(0);
 		break;
+	case KVM_CAP_EXIT_HYPERCALL:
+		r = KVM_EXIT_HYPERCALL_VALID_MASK;
+		break;
 	default:
 		r = 0;
 	}
@@ -1071,6 +1090,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		ret = kvm_handle_mmio_return(vcpu);
 		if (ret <= 0)
 			return ret;
+	} else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
+		smccc_set_retval(vcpu,
+				 vcpu->run->hypercall.ret,
+				 vcpu->run->hypercall.args[0],
+				 vcpu->run->hypercall.args[1],
+				 vcpu->run->hypercall.args[2]);
 	}
 
 	vcpu_load(vcpu);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 89b5b61bc9f7..5e04be7c026a 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -132,6 +132,25 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
+static int __maybe_unused kvm_vcpu_exit_hcall(struct kvm_vcpu *vcpu, u32 nr, u32 nr_args)
+{
+	u64 mask = vcpu->kvm->arch.hypercall_exit_enabled;
+	u32 i;
+
+	if (nr_args > 6 || !(mask & BIT(nr))) {
+		smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+		return 1;
+	}
+
+	vcpu->run->exit_reason		= KVM_EXIT_HYPERCALL;
+	vcpu->run->hypercall.nr		= nr;
+
+	for (i = 0; i < nr_args; ++i)
+		vcpu->run->hypercall.args[i] = vcpu_get_reg(vcpu, i + 1);
+
+	return 0;
+}
+
 #define SMC32_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
 #define SMC32_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_32,		\
-- 
2.44.0.rc1.240.g4c46232300-goog

