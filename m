Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3F7157E61
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618313; cv=none; b=VQjbH9SO4S6++oLWjqGvKQ7Sg7XUhWNVNxx4ixaDMfQS4zc3ESpdBMjYg29Wbalcs9+ScpE2JSeamW7DsCd2ZAQbu14cPUG2oO4ExoqPr/hZa5l+CznsTFJij8lTZHwRwgCY6nBWf4d+JI5WiTJdfW2/kEYrzhkpUEekRhH6M4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618313; c=relaxed/simple;
	bh=TUyoIAvN6Obzks9YjN2BA6l8SNXm7pOIcGDdO7heG78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dITprpLUZoxlO6B+7L4gqumLU1QqD9FrXRmxrpx9TgNvrvaebjOFTRDd81OrKXSNGL5Q8pcGyN9iU68rjxRKa+foQL6x9zlp9qO3N6kxpONdizCZ72pXluXZcrewbg+I+jLVmvMEQLSOcLCxriGR5vdUYQ/FCL91Oa/vbbwndvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ReZZnZgO; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ReZZnZgO"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-40e4478a3afso5313605e9.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618310; x=1709223110; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2/q45XBasvpokurDmrqajFJwCgekoEBMYCvgW9GhGQo=;
        b=ReZZnZgOy2RnXH67k8vY009YGxJ8LCMTAHwzivLNdLCDQSGKJG2zcEwZDTjAhQ6XlF
         knhwrU3BFMk6zFWSN/U2K8rcI//nc/wk59Ixy+Qk3Pv/TST+NHTZG1xjYKOwkrgLZAz3
         GKoDse3u4BTU2idojne/IKf1e5VAzMjG7IzbcGkVh+XvIpm5seSN796w5mGCBgq2PMGf
         ICsizAfLNiryQifbTgH4/SdVcy0EjJPaYIRbs5BqokU1E483Edgk9Q6Uuey7uQFJfeGq
         hU0hYc22OTvwfpB4x5nnxcBvoqPzAUkMyAl88rsTiNgPqNL2GV8ZsaEpW+ERcUoB9C/u
         O16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618310; x=1709223110;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/q45XBasvpokurDmrqajFJwCgekoEBMYCvgW9GhGQo=;
        b=QnVhaYohLrJ7j2N2o9j4R4a6I/17Y4X863jBWfPivPH89mSdqKpaE3XZhbjNgongZS
         psILVNe2FWEen7kqjDJMDGqRGovY8SyHfB7yVx6OuhcM9GmYw0Z3k+IDfPX/AvBysWn3
         G2QpbK0uN/UbMDtAoSB76jmCrUGWRbkL+DRlz9lZchIIeXQrFlj7EdyXZ/9iUXkJVQbV
         9/YZlmJEkQCbzaJn7/kve+Y3nTRxF5mPOQ+AmpEb0HNG8RaMFGa345e88HFhteuMgu0Y
         cwFVkswBuURF1Cp5LxZFFZ1Gg0lCl7R8Doi8vLS0mqPOedeION81EM0wWa3Hw82A//9e
         M36A==
X-Forwarded-Encrypted: i=1; AJvYcCWog4SLwTilRIyckd9aYT2VcCg28YuygG/8fUqRK+b7+V+aQ0KTvqXyFpm7smBnqlTGzGD192c6DMpl6ELMZ8me9mVlIZko
X-Gm-Message-State: AOJu0Yw65UUZSiklteHzxlRAYRcn9ZNM/so1AQ3jipzk7OzUpXLUiCZ1
	k5gHHoKWD/GaCP2EFJBt7wmeRwQMnPLYsdLs/YNYnvDTExxGGoNYsFuO76EqbXJIROY5mCo9VA=
	=
X-Google-Smtp-Source: AGHT+IH2AJdryfzgBjtwoYEiaqYJq05TPCfxK/pLtpWJryi75TzpSiXs2AMbdpb+STC1Oqvl/vDFO15AKg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:a399:b0:412:7677:3e4f with SMTP id
 hn25-20020a05600ca39900b0041276773e4fmr136786wmb.4.1708618310147; Thu, 22 Feb
 2024 08:11:50 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:46 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-26-tabba@google.com>
Subject: [RFC PATCH v1 25/26] KVM: arm64: Enable private memory support when
 pKVM is enabled
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

Mark the support for private memory in arm64 as being dependent
on pKVM for now.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ab61c3ecba0c..437509b5d881 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1263,4 +1263,10 @@ static inline void kvm_hyp_reserve(void) { }
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_KVM_PRIVATE_MEM
+#define kvm_arch_has_private_mem(kvm) is_protected_kvm_enabled()
+#else
+#define kvm_arch_has_private_mem(kvm) false
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.44.0.rc1.240.g4c46232300-goog

