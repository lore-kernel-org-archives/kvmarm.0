Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D518C90B
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 07:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729237727; cv=none; b=IjozFxsqZqCf6m+j6QgDMuMfHUBGPJdYDBTY9liEhF4KWyzmp3L/Qxxk8dnOw01EM1DxMO6yDk8E5iO+727Nx6AKeknXdlic9nNgpFl0f8IjjwJnf1DLxa6vTz36CsoiwRyQbTUyEIdkhy8wmh+h1y/JfXvQivdk71l+Vq/16Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729237727; c=relaxed/simple;
	bh=wPB2+9vq3z9/fT6tL5vujYWbi9RZPxX+3wU8K7vCLC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kN4B54medXiOkW1y/wPlP4Q6Ukwlbe9kzyxlREYtUYe1gmLhnj7IR254sZPK25QVdiZdElGTBysxc8sIrzfSdYG5fmFyNJKaJ46ISMrEXnav2MqjoCShoVsBcyJP98iP3hhmhN8e8JpmyNQzbVlyI0cXpMDVXCGh8QrS1God038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T5mOwVa+; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T5mOwVa+"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4315af466d9so9916875e9.3
        for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 00:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729237724; x=1729842524; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DVPqRF1uy1Cyfm77ewVS7qMbDMP457fSAd9j1wk7Ti8=;
        b=T5mOwVa+4smZ0jGarRkJcqQcBfyzW4vLL1smAqn1er/JkMBpQMYOCUpkvbUIgVgQZs
         BwE9VwomzaUVzd5ExH0ewjZjMCmNv78exiliO3bVj0ULVVoteThTDKauFV09SZeapVWq
         GrDrSozQib/ie6pTedEkIX7OkSCQ1m8NSQtAVQ7fcEkmO0C1N1odl11svMaXT6IQARXy
         Qw593ue8T0JY8TmD5RBAqZ+GwHBp07DU8lA9H3g2hkqe3DmYoOfqALIeTbBPVtHjcMqM
         iKaNwNYC4yGRuBphaeV6ifxqCxFIlbDZIR/y3Ydjp8nlrHzlBSmAJ2u1kR2Y1URD/7SX
         K49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729237724; x=1729842524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DVPqRF1uy1Cyfm77ewVS7qMbDMP457fSAd9j1wk7Ti8=;
        b=Yo+kYgMwE+RyBdjj13b+2VrMBcmVw2+3mpjLnOwEJOjEIqruEk1gWLDOeiLtoSIca/
         gS0qM/17XMTktkOd8zp/DgqaWwf8IHdZt89UR4JisHrcHPNWf56Gd3TmLlB/mvwHc+mr
         tkDUWJDlOCy5vLSFpu4+cYp7s9YxH9YS/6su6smItbar65fqg0X65cgBe8fkv9lZZBUX
         cvoOyOH+3GdLRDFYoxb68w9OIsAwTv3EQrB63CD4L69MXGb1VsbW1mExqaIf8BEbR9DN
         TBa7CZp/ZmCmIcLe3jXRZ/9CGBhtObl/OgeiFjV0rX57cxpykyz4tAFCBZ9eEAVeUiJ3
         hL/g==
X-Gm-Message-State: AOJu0YxKB3CG8jqmTHjNqp58T5pufooqrVYqb/zMJU5YIps0c0/x/kF7
	Su/QEZk+S3P/UT80wDmBU66IQGoHxiIDPX+bW0XwEf6xyX9rm3AB9pZ/ryNwFewK1vbMTZTfOqt
	cs/8aLdv5FWe2OoDgRij7wXzVp/nDJMbWwmORC4wR6HYUAELFX+XvGO1AtHPEsIG5mpxwIcbz9d
	Xp6Ne3ewTLPWL/lm6d4cfrpe+Zbhc=
X-Google-Smtp-Source: AGHT+IEWQSRNPjNgVR3iDFOrgklS3iS1swdRuyY35lMMq3zlJvhh4DhoeKMWUXJRHF2aNaV8mHoOsrYCEA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:6a12:b0:431:3c67:fb8f with SMTP id
 5b1f17b1804b1-43161683bf2mr112525e9.4.1729237724442; Fri, 18 Oct 2024
 00:48:44 -0700 (PDT)
Date: Fri, 18 Oct 2024 08:48:32 +0100
In-Reply-To: <20241018074833.2563674-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241018074833.2563674-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241018074833.2563674-5-tabba@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: Initialize trap register values in hyp in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Handle the initialization of trap registers at the hypervisor in
pKVM, even for non-protected guests. The host is not trusted with
the values of the trap registers, regardless of the VM type.
Therefore, when switching between the host and the guests, only
flush the HCR_EL2 TWI and TWE bits. The host is allowed to
configure these for opportunistic scheduling, as neither affects
the protection of VMs or the hypervisor.

Reported-by: Will Deacon <will@kernel.org>
Fixes: 814ad8f96e92 ("KVM: arm64: Drop trapping of PAuth instructions/keys")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 +++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 35 ++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1a224d5df207..6aa0b13d86e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -105,8 +105,10 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
-	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
+	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
+	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
+						 (HCR_TWI | HCR_TWE);
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 954df57a935f..01616c39a810 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -204,11 +204,46 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+
+	if (has_hvhe())
+		vcpu->arch.hcr_el2 |= HCR_E2H;
+
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		vcpu->arch.hcr_el2 |= HCR_FWB;
+
+	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID4;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TID2;
+
+	if (vcpu_has_ptrauth(vcpu))
+		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+}
+
 /*
  * Initialize trap register values in protected mode.
  */
 static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
+	vcpu->arch.mdcr_el2 = 0;
+
+	pkvm_vcpu_reset_hcr(vcpu);
+
+	if ((!vcpu_is_protected(vcpu)))
+		return;
+
 	pvm_init_trap_regs(vcpu);
 	pvm_init_traps_aa64pfr0(vcpu);
 	pvm_init_traps_aa64pfr1(vcpu);
-- 
2.47.0.rc1.288.g06298d1525-goog

