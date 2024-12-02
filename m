Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C720842AAD
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154491; cv=none; b=etYQiVTzqPxLWsoOC5lMjBNInknUYDHpOE2GLGEF1gL30HbJqFblhclovtLL4D7J2WW7hiw1ckqCsOT0gx7nQC8qSFwWqsiwG9RTGWG5nhOxmakI7twytQIizKNPnnUgGE2kamRJD/WDVuQo+CWB1+U/BlsW3OVp2+/Pd1mFmwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154491; c=relaxed/simple;
	bh=MTY2H3Auab2VIXlBY0r2PYSSEKu0VmctnjJ6ypbLHwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KOMydbmDtE8/rUWgYHwNqYQ9HaE8CZbQX8+SWq5ziOpuagxB0UFYvCUt9hkkqv5vLeMgb28JV6KeA9xljl4SIoHOEAmUpaG8HNFuvyhiC4Z8vzp+c0IfkACCKzos9sWxqA/RZhItWLdTkniZq30kBvJOM6F7mDb/d82jXR+CxYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yF/8oLm8; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yF/8oLm8"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-385e1339790so1629216f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154488; x=1733759288; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGNx4KryUAWkUrEyK556nEdWmNkAb7CXLB+nZikEwWs=;
        b=yF/8oLm8um3ZkP3WOrXRDPc3N/EpY9/vnXvTrg24wqn34vC3mPgOD7Ui7Jz73VNETs
         chC+Usie0lomi8o4Arb4sJZhDM+ajRICgt5cB7U+ms9VXPKsVG3HalOPY4WFTGEYiDXS
         H+obyb/c0AUWgbGFdH6B9ywhZ9Al7mXsdjDwDZidKyygEBD2OWQfF2th1/KeOrtEp4DA
         Vg/TioxK/uko/nJDQSymej3t1Um17Dt4GcfEGc3qwNteDOMJcQJNVUxkklWhGoGhQ1YC
         hC8Aarcxfg8cEPoxRTljDvic/nKGK8JSQDSMskdvRZQRfYe3Mp1vfKOo/kMgIs0nYDM2
         QIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154488; x=1733759288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGNx4KryUAWkUrEyK556nEdWmNkAb7CXLB+nZikEwWs=;
        b=gofL2/6neBE852Klpgt7+YM19bFVe/YyWMLvmDBeiucMvKJeeQnOpAlP4kiPuQcCQk
         bm3dcVFSSK9O7Lqsh3BTl/Y6Dg3LMe4LoGNw9AbCu3goOXPjd1DsjMDCvFx5eJ3VZufz
         N7N2uP5HBEt3ooUn074Z9lcoEZcT45Vla5kFdEwgqPl1YgL+mGgv5dIYwgwxoG5KeSiz
         2nOz2hFCSL+MmiPc63uw/GTNtZ6Hj5TvGc//nGJaNPpNdCddIFqhOj+5pT/C+ySt5ZuW
         wTM8pVufxnXRvRcda4ULJkzOOSyZMya1Tz3OQCjw4EvnZxipfpLAfYkwHKRVplYItBrg
         nN4g==
X-Gm-Message-State: AOJu0YyKaDA13Y/kyPJoWJEFeNeeV4jp++RGlU3nYCnZs3GtD6WZXCNx
	C4Fv5W13/MHSSiNjiz0YQGzY64Wsm+9wWXRDP3jRs7zimtP7SB5e/AVpW3WDsRfEuTEpTq2Ewkn
	yno5DcwYLSeCm3TVbopGBT5CUXcjAqKKOUx2LtQsDBV7Fenp9vUeCYQ68T7VAcSyQYvbAc39XPZ
	c3TSlbuREV3JJ4xeCtkHmObO5kvZ4=
X-Google-Smtp-Source: AGHT+IE+TCs+se5ONyXKqcos0wiRI1E/t7OZ3N4PjzO6JlH3kIzyJ0HixavxVlrNIbbs/fsbkOGIjUeMMQ==
X-Received: from wmaq11.prod.google.com ([2002:a05:600c:6c8b:b0:434:a981:26f1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:156e:b0:385:f062:c2d4
 with SMTP id ffacd0b85a97d-385f062c49emr5948044f8f.37.1733154488244; Mon, 02
 Dec 2024 07:48:08 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:39 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-13-tabba@google.com>
Subject: [PATCH v4 12/14] KVM: arm64: Fix the value of the CPTR_EL2 RES1
 bitmask for nVHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Since the introduction of SME, bit 12 in CPTR_EL2 (nVHE) is TSM
for trapping SME, instead of RES1, as per ARM ARM DDI 0487K.a,
section D23.2.34.

Fix the value of CPTR_NVHE_EL2_RES1 to reflect that, and adjust
the code that relies on it accordingly.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 2 +-
 arch/arm64/include/asm/kvm_emulate.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3e0f0de1d2da..24e4ac7c50f2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -300,7 +300,7 @@
 #define CPTR_EL2_TSM	(1 << 12)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 #define CPTR_EL2_TZ	(1 << 8)
-#define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
+#define CPTR_NVHE_EL2_RES1	(BIT(13) | BIT(9) | GENMASK(7, 0))
 #define CPTR_NVHE_EL2_RES0	(GENMASK(63, 32) |	\
 				 GENMASK(29, 21) |	\
 				 GENMASK(19, 14) |	\
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7b3dc52248ce..6602a4c091ac 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -640,8 +640,8 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 
 		if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
 			val |= CPTR_EL2_TZ;
-		if (cpus_have_final_cap(ARM64_SME))
-			val &= ~CPTR_EL2_TSM;
+		if (!cpus_have_final_cap(ARM64_SME))
+			val |= CPTR_EL2_TSM;
 	}
 
 	kvm_write_cptr_el2(val);
-- 
2.47.0.338.g60cca15819-goog

