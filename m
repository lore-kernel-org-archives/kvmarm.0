Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C51153506
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618305; cv=none; b=YgUdwiy9McPDzI972ybzZ1e0UJmJwqciwz8HMCFDgLRvF8gL0boYwkCZMyH8bBC9AIeUSPK9VjyMYtyyd3R1epybOvCTrMhWCWZmbpwgYaPa5PwI/z/TEacQoHpnft0tRk4Pssbssui1oXBkjUeY8cQ3hw6iyp3iqcP1BS2mugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618305; c=relaxed/simple;
	bh=c7Tct6JEztEi1hIJsezP9trwKsf7ghqb+Z/TRUVlQe8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f3He1zLQZrsZllkzunSCrYBK3T+cXAHvF0sVqGTDxGN7NVrqQ/CijefLStRFv3BTHp/Ia5AI0acpFoUcdOy8ZcUriIhYVtnUy9LvkO3Uf/zPPg3RNzuTnXWI5uMJ7iRY2gvdMiWNU80y3TW9J3QXxXQWMlTMNPHFjgwvhFHwRgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=36jBgTQM; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="36jBgTQM"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc657e9bdc4so10641705276.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618303; x=1709223103; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XojbdHrJujzsZqAAPdXW/Ko7J3fwpP4NgmuzfEiqbUI=;
        b=36jBgTQMPAAix6ihuuQKj0bGfY+vQMcfDhir8fps3iG6BX7ggAqPE6cgrowYA/OmtS
         SGGLXzeyEIhNSYbx8FIe6/eicx6yStV3LRfRffx3BLGPgyiAkLcljJOdOqg8jCrFc6fN
         ki+3vc8tolZZLwE7idM5ZGmzDn6LInXx9fQ9nnBEef2bxkK6C08mHlj0XbzoUCs+zaMl
         3Bd4lZ6FnFt15BjJTKM0pNaXhiEh0XF41oDUwr1S0ONzMhlyS99XfxKWoVGoklPOdpWH
         RsAX+w/CT/Vw9oqDspO653kLrCpkz6e9dLiz6ktpBBmA6qdSrenX2PnUKosVoSZmz2gG
         gjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618303; x=1709223103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XojbdHrJujzsZqAAPdXW/Ko7J3fwpP4NgmuzfEiqbUI=;
        b=Pg+10UKFtVkvo5rwyzA+xvu7NZB+B6F+P5Mi71ZLOZScsAMrMrMAZU8f8vPFcTRPnD
         s5fgHM1CZevXh3sb0RrEr0UrriwQMKx7sCihMAI2I7ip+29EvDRSXvKnxq1s5vjF/Lbq
         n+LsRZkFCM9Xpi8lGGdgzMWlt4ktbLhtts4MDNiV0KOkXnRfuvwZPyKvKyOf7kNf486h
         Tm9ILxmZKfBoTFsOj6qPbDUbqQS7rOSo7pzsste/20vXwQVHuEtqSZo2QcH/b/CtxBtY
         s8VZLPdrgcqrnQkvJTFbNacUKARXT3FgLL4sPjoYlfi5nwal8q7KCndLbQj3ucimawd4
         xs5g==
X-Forwarded-Encrypted: i=1; AJvYcCXYFQoc0byGIwUOaEq/rnfZUJWvqI3fuTzWQBYAOpxBKNwlQmQRwPLLxIy4cBIpyHiUgvrsHAqEtq61celdmNVbV6hUwk+O
X-Gm-Message-State: AOJu0YxCJgokdc4XVGe7sLYsQgoea6vkjLwwYZRFt2pCWVSGx2mo9bjV
	q1TvaDqgz5S+Cu0gWBU7P7xyaaqucFaU1s0w/q4tJhyhCU3g365xGBXJP+Z/pxxgVI0pi1cixg=
	=
X-Google-Smtp-Source: AGHT+IESoqL0M6mjy/MJ8LmmLb1XdvlAFvZ0ur8xoV3cDuHAn304J5q5vh8m433MSg+rVYhI4cB/urFKYg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5b:b05:0:b0:dbd:73bd:e55a with SMTP id
 z5-20020a5b0b05000000b00dbd73bde55amr139111ybp.4.1708618303039; Thu, 22 Feb
 2024 08:11:43 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:43 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-23-tabba@google.com>
Subject: [RFC PATCH v1 22/26] KVM: arm64: Handle unshare on way back to guest
 entry rather than exit
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

Host might not be able to unmap memory that's unshared with it.
If that happens, the host will deny the unshare, and the guest
will be notified of its failure when returning from its unshare
call.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 ++++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 22 ++++++++--------------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1c93c225915b..2198a146e773 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -79,16 +79,32 @@ static void handle_pvm_entry_psci(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 static void handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
-	u32 fn = smccc_get_function(&hyp_vcpu->vcpu);
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	u32 fn = smccc_get_function(vcpu);
 
 	switch (fn) {
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
 		fallthrough;
-	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
-		fallthrough;
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID:
-		vcpu_set_reg(&hyp_vcpu->vcpu, 0, SMCCC_RET_SUCCESS);
+		vcpu_set_reg(vcpu, 0, SMCCC_RET_SUCCESS);
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+	{
+		/*
+		 * Get the host vcpu view of whether the unshare is successful.
+		 * If the host wasn't able to unmap it first, hyp cannot unshare
+		 * it as the host would have a mapping to a private guest page.
+		 */
+		int smccc_ret = vcpu_get_reg(hyp_vcpu->host_vcpu, 0);
+		u64 ipa = smccc_get_arg1(vcpu);
+
+		if (smccc_ret != SMCCC_RET_SUCCESS ||
+		    __pkvm_guest_unshare_host(hyp_vcpu, ipa))
+			smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+		else
+			smccc_set_retval(vcpu, SMCCC_RET_SUCCESS, 0, 0, 0);
 		break;
+	}
 	default:
 		handle_pvm_entry_psci(hyp_vcpu);
 		break;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 4209c75e7fba..fa94b88fe9a8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1236,26 +1236,19 @@ static bool pkvm_memshare_call(struct pkvm_hyp_vcpu *hyp_vcpu, u64 *exit_code)
 	return false;
 }
 
-static bool pkvm_memunshare_call(struct pkvm_hyp_vcpu *hyp_vcpu)
+static bool pkvm_memunshare_check(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
-	u64 ipa = smccc_get_arg1(vcpu);
+	u64 arg1 = smccc_get_arg1(vcpu);
 	u64 arg2 = smccc_get_arg2(vcpu);
 	u64 arg3 = smccc_get_arg3(vcpu);
-	int err;
-
-	if (arg2 || arg3)
-		goto out_guest_err;
 
-	err = __pkvm_guest_unshare_host(hyp_vcpu, ipa);
-	if (err)
-		goto out_guest_err;
+	if (!arg1 || arg2 || arg3) {
+		smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+		return true;
+	}
 
 	return false;
-
-out_guest_err:
-	smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
-	return true;
 }
 
 static bool pkvm_meminfo_call(struct pkvm_hyp_vcpu *hyp_vcpu)
@@ -1343,7 +1336,8 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
 		return pkvm_memshare_call(hyp_vcpu, exit_code);
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
-		return pkvm_memunshare_call(hyp_vcpu);
+		/* Handle unshare on guest return because it could be denied by the host. */
+		return pkvm_memunshare_check(hyp_vcpu);
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID:
 		return pkvm_memrelinquish_call(hyp_vcpu);
 	default:
-- 
2.44.0.rc1.240.g4c46232300-goog

