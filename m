Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE924F887
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 13:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951908; cv=none; b=M7de859oR0tMt58Sq6a8whsunf9CarTKuq8UdpkuaKrsi+csdGNMr3MSvdet+w4RcAD78nT8qvu/ofaDeL9AlZe1XOxurQaDk9mTXsFEKocoj8evrDuxj4DFjP9RJ+jTFjKDrZUYrJf6KQs9sv/sPPC2NOH35L5N1yU7m0qxPVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951908; c=relaxed/simple;
	bh=w8TbPG1g8Rtt7U1yR+j4jG/fF2uIKQ2M1ORb4Q7veHg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yn8bBN9QDbxv3TpLgWGfOzz5ZstnbL3ExTpDwNa0ggZ9jR37N/fkWIk0LFu8Dg+T/I1MDCUKdKZsOxNmQVKsxG762nC+Z//IPJSgoM/hI7kL0C6GBffw1UhfBU2uU1V/VgXFNwzY+kIcO9Md+hOIHQJoVEF4k0USwZrLoyyoees=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G8zGgf8n; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G8zGgf8n"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be23bb01aso194138097b3.2
        for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 06:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715951906; x=1716556706; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGzcYzi3+PWootrDbUQUeQV1OCORneBcWbWpCTiVUeY=;
        b=G8zGgf8nKgKnEbsKYnEeZVNBh3oNFxMRiET0yZKfNi7c4645GXDkiDwlVYgYzVaP6Z
         taz3dpDo7LzApg7fpPSMByQj5QjJHDyi1vSU3vEk5vvzvnoG/7fX6ccFNImdw6pOvcUE
         NrcPHURTGY/pcjGlLCgqEzvJAu6+jobl51pwA26fx0AHS4Ih9XMcRNUIDU3aF2prkuSZ
         Z8haYAY2MokTfnXvjoBicBaSgx2+zqSS3T7wdBpoQIHhFYM0/FOeburKecokfbFI+03X
         rlIFfAiKZh2/dIhWFYvtcR82jS3XYxB8mhuKBsHNAQkWhFZ/HqriqHIO3eL86tq4Gp2i
         u/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715951906; x=1716556706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oGzcYzi3+PWootrDbUQUeQV1OCORneBcWbWpCTiVUeY=;
        b=PZDGc/PRi/rh+KXZk3c/QnNUe1Kfrzc4Kw/MCD85eE1TqGNIq4rcICt7X/9hQaYPB+
         7jgs8Jp25+xrhHuBfx5LmoSZS5hEavZ1fxjL+zuR19hDk5YJ/woIdAmFYi5pUV1Vhjqw
         Kg7c0mE1rxUGW3WcE/HbOY26/dceH4MMBgFdKiNgtAV/vCrAm1h4NbczEUMh2w1i9SAR
         NUeOlPPjbmLpdF+nT0vJlor8OwxyBhQ61ijSKzZ+P6tN8iOfp8J2etDpSA3Co/Y8cJFU
         nMi3WaEs2chOI0c3+OfWAawnxIptClz573jTQGbqZn5xgev4NLTNDsRugs0ps9V9I3R/
         M2og==
X-Gm-Message-State: AOJu0Ywpzj/IM9VDWl/syhcSSv/SM6/pz5dd8bOaUQGm9I5FlfAMNRj8
	pMKAJiaw5kw2Wv135Q5VSg6YKCI+MAuo9zqW4BGJCw4TpYbWncvGILCy5GyPm/4ZgORAfJ2NxFm
	iO+RzMkCVTktjU8i+YiQ49F+2Qbp+QnMxlWxWWs9q6EUgnJgj6DimtFNkZNgUNHEe2NgM552rBq
	deFR46iMOZENHyTSSF4e/UvyFpHDc=
X-Google-Smtp-Source: AGHT+IGXIa+K3nVX6jafvNxOx5USJ4mkcHs2cg8r+LYZjpoWaq7czvFYrkh6Frj1WfhRrns1sFX7/hOqGg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1546:b0:de4:77ab:5fea with SMTP id
 3f1490d57ef6-dee4f2d1110mr5389678276.2.1715951906168; Fri, 17 May 2024
 06:18:26 -0700 (PDT)
Date: Fri, 17 May 2024 14:18:11 +0100
In-Reply-To: <20240517131814.719933-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240517131814.719933-5-tabba@google.com>
Subject: [PATCH v1 4/7] KVM: arm64: Store the maximum sve vector length at hyp
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

In subsequent patches, hyp needs to know the maximum sve vector
length for the host, without needing the trust the host for that.
This is used when allocating memory for the host sve state in the
following patch, as well as for allocating and restricting guest
sve state in a future patch series.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/include/asm/kvm_hyp.h  | 1 +
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 2 ++
 arch/arm64/kvm/reset.c            | 2 ++
 5 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..0a5fceb20f3a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -76,6 +76,7 @@ static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int __ro_after_init kvm_sve_max_vl;
+extern unsigned int __ro_after_init kvm_host_sve_max_vl;
 int __init kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 2ab23589339a..d313adf53bef 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -143,5 +143,6 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
+extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9996a989b52e..9e565ea3d645 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2378,6 +2378,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
+	kvm_nvhe_sym(kvm_host_sve_max_vl) = kvm_host_sve_max_vl;
 }
 
 static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 16aa4875ddb8..25e9a94f6d76 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -18,6 +18,8 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
+unsigned int kvm_host_sve_max_vl;
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 1b7b58cb121f..e818727900ec 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -46,11 +46,13 @@ static u32 __ro_after_init kvm_ipa_limit;
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
 unsigned int __ro_after_init kvm_sve_max_vl;
+unsigned int __ro_after_init kvm_host_sve_max_vl;
 
 int __init kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl();
+		kvm_host_sve_max_vl = sve_max_vl();
 
 		/*
 		 * The get_sve_reg()/set_sve_reg() ioctl interface will need
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

