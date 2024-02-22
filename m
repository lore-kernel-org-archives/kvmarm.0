Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DDC1509BF
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618281; cv=none; b=T5lnC6cxtCoN2pHswGQiRb00mZC6ASUM8nqEY8pyJWuRFle8NzhJouBCiycgSgcX/Fdx4HLvpLxGojXcDLt8k53KYBiPsfoqo1Wmob1avUv1lzRwybDAdPYeaLCJCsIcLs8EFqOhPqlRKxlL1RknYQm3kzrw5SEYXzXhQFpCRxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618281; c=relaxed/simple;
	bh=z/Ih8ZYT5NkMixOWg+Uyve5J68nFw5E7iGVbbYcEx3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ss37AdmZeN8UhtCE+IyiRegxwRrm0AtKJAbI0bHgv6J0Beb1qb3JSyNp3Bqof+jHn3ZqCnIqrm51RvJEvGs8QK8jSOb0dCy6wVHXotMNQYnseOMqNJ4ULryI6rC/UMVuIZ2ZcEJPCH9XL0scNGPU2oMxjYVX3K4YnPaBWJP2EBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B55l6qkp; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B55l6qkp"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc657e9bdc4so10640871276.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618279; x=1709223079; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R9jqiln8R3A9VFnaGPClstGN9r3EmzNYJZRGHFrLYA8=;
        b=B55l6qkp/2tLNdEevsho1TL0IUv+EnXZIlwVf39+SuoK1Bk0MXWcp4aO29L1bS7w/U
         HUFVYbg6CMOHt8MqPkkooL0Np6gPOtnYjOmx62sMoCbx+AZdhogxY88pAxHT2htZfwBn
         LJn/sjrXuVfUdnztd6H606Ypcq8NXwaYGS0KJsOBzH48yqW0yysyqKi6X1+WmZDbJDfN
         jwyAlZY6jS1J5fiedLRg1u9C32BgZUYi/El+GmCY5Te7oHnNxG0nzZTjSrMDCG4Dqn0c
         zgWuLokcYHqZeJ4P3NUfKFsH/LzJERnkQF6TjEBzsNiX0pYGB8hRYFnQ/Wf7ST4oHpq6
         lQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618279; x=1709223079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R9jqiln8R3A9VFnaGPClstGN9r3EmzNYJZRGHFrLYA8=;
        b=GTDXOIS2nO+4uDlIM+V2Fp+dQULJna/u29wArwg5Of/9Ph3uLTv4vCibmRmIyZK7wQ
         6+6wxYXXQ499DFSmJC8cB3juum/lbPF6t5SL7nA8r2Y1baTXJ0NYn8Zw81l8ZXK5+nhu
         aPVVyCTRdDmpvr7cxrd7G2Vzjzzo5iqXQ5lVBe/iAIhgB6CEvfS0OjoT/l/wavB57tkn
         hcAhctTeqXsYf2JiPI0bvjCTuXcqv07RvRqIjwSe4spKPat8z1IHDg24npCegiTfwxKT
         zz550FAdh2Mpr07ai3iFlc3tDBzJfqPbF9VR/bFEIE6v8diEHzhuNqAcHMExIwOuCKWF
         /HTw==
X-Forwarded-Encrypted: i=1; AJvYcCW3Cq8ADIw+TnRzghj2meaS5UpDIvDfGazS0snHvCKngT72rrt7OagcpFx4gdokBHPcblbZ5WWNTCmjEU5eDINqNinP+ttD
X-Gm-Message-State: AOJu0Yy9fWXP63MCSaUgyN/q9UZIFruoeMYG5U4jQDI1m93JSg5gd2Ui
	IQbF6bCHWoFfrwEPX7MkJzNtBK2bs+00sKuF0PBMPVDE5eHNm3yM7xJLAeK6gQTJKo7km+/CGQ=
	=
X-Google-Smtp-Source: AGHT+IGzluF9KV0uQ74p+P4M/V/9xG11z3AVlCw5UzMHVkr7rD/AoyFybmDhnZwJeOh0w7FWclLKEm9ISQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1081:b0:dc7:63e7:7a5c with SMTP id
 v1-20020a056902108100b00dc763e77a5cmr139205ybu.11.1708618279476; Thu, 22 Feb
 2024 08:11:19 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:33 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-13-tabba@google.com>
Subject: [RFC PATCH v1 12/26] KVM: arm64: Allow userspace to receive SHARE and
 UNSHARE notifications
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

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c        | 3 ++-
 arch/arm64/kvm/hypercalls.c | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cd6c4df27c7b..6bba6f1fee88 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -61,7 +61,8 @@ static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 /* KVM "vendor" hypercalls which may be forwarded to userspace on request. */
-#define KVM_EXIT_HYPERCALL_VALID_MASK	(0)
+#define KVM_EXIT_HYPERCALL_VALID_MASK	(BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE) |	\
+					 BIT(ARM_SMCCC_KVM_FUNC_MEM_UNSHARE))
 
 bool is_kvm_arm_initialised(void)
 {
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5e04be7c026a..b93546dd222f 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -83,6 +83,8 @@ static bool kvm_smccc_default_allowed(u32 func_id)
 	 */
 	case ARM_SMCCC_VERSION_FUNC_ID:
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
 		return true;
 	default:
 		/* PSCI 0.2 and up is in the 0:0x1f range */
@@ -132,7 +134,7 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	}
 }
 
-static int __maybe_unused kvm_vcpu_exit_hcall(struct kvm_vcpu *vcpu, u32 nr, u32 nr_args)
+static int kvm_vcpu_exit_hcall(struct kvm_vcpu *vcpu, u32 nr, u32 nr_args)
 {
 	u64 mask = vcpu->kvm->arch.hypercall_exit_enabled;
 	u32 i;
@@ -398,6 +400,10 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		pkvm_host_reclaim_page(vcpu->kvm, smccc_get_arg1(vcpu));
 		val[0] = SMCCC_RET_SUCCESS;
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
+		return kvm_vcpu_exit_hcall(vcpu, ARM_SMCCC_KVM_FUNC_MEM_SHARE, 3);
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+		return kvm_vcpu_exit_hcall(vcpu, ARM_SMCCC_KVM_FUNC_MEM_UNSHARE, 3);
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
-- 
2.44.0.rc1.240.g4c46232300-goog

