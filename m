Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40892137772
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560969; cv=none; b=DboCt9SacuSUwcNIoHsKk4JttBu1PSF2Bc0BzipzlwGMN/YC0iUpK5rb8wMlVOKSY7V1eseGYgf+nyfgXZcMmIZmos1Gyj/A5mV/ujUf7bwFgmwCaR4ahIp2lDN42dHsh5tqDrfwVKQhRNE6T6LNgvg4jh1J5ISr9n8JPx5XEzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560969; c=relaxed/simple;
	bh=4JpBs4nX5E6PYNSti8bumQussTRq+/Fz7ZYRkvIV5DU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QRs6hx/SMyP4tIHM8UInPuvPV9wgwXQ+37G9a69H9zB805wfOkSoIKyA69gKeEf8AbfEBYtnMcb8ceBzc1xEcyB0FzWCYapBPw6jdZJP1ebYKcngVmtOU5sVU5IClv6VKkYpKDSl24aEnx0fjRymJVJ1+v0EMS7Pd6Zz0NtzAC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ChpPK2mW; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ChpPK2mW"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33ed26afd99so5503f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560966; x=1712165766; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gPDU6tcTVIj1YD8+r5NlUX8hsPBj63ihPINEIswvbIE=;
        b=ChpPK2mW8M8CEMKuXtWVxb0LszTb89dR4CrKo+MUm20eGgy3i8hc+Lm3P18Y8LET1g
         wewKFwGsF4rqMzw1AW3GLG0YHLh92askkir6jmdIJcFugfk75wqatXoqPPu3fqouwrcj
         amWmwLAEU7rCLcGe3R5oFaLebNli6IWEEma2dCCk+qvoh2BXUDUK30KKRbtU4lAx/C+e
         u8peMuRAaVxx5YcdwhueN1O76aCNTpuukupzXyxO2zoryr3wFe1ifW54eYrnUGAkmYgw
         6GYSJ/i8Wj+ARNW6F9h/2IHBS6qmjgB9sWTRVwiNeCEv2ei/zee3i2GRfClVZv0UE+zX
         Xx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560966; x=1712165766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gPDU6tcTVIj1YD8+r5NlUX8hsPBj63ihPINEIswvbIE=;
        b=aBYqaiEGmAfu+mdLG5ZG6//NyuX4d6v8g4MqGwjnDEUO9TANlClXQBhURSvCHav8kM
         ru9en7rvBfDgzP3OokTNfoHD57oxpYD1rAJuhBzHriRsWRYQfM6n7uAyRU2T4T84R4/M
         h1UKngmWaMJGeXTWtdnnh7k7j7MnjfzoR/JZHDFmCK/6JqJLibcfHGXP2Q9Sxh2n0Dko
         AHDnbdX3/zR59sbbyByiZo3g1GSZZYMAXosnrsZL0RpaTccm+vObN+9z7k+GlEHmnZId
         khm4PvSdFvvL/xBzngFlSMatovt+MVYckDhDvdIU1kDJGn7T8KRwKxIi5qPxMYZYbkBZ
         1USw==
X-Gm-Message-State: AOJu0Yy7oMNAVvt8ert8q9Ns17mkbipjrtOpNOmHYqbQppwT6KoN9eP6
	BqplnYP95vusWqxkZu5o/s4BrNSraXHWFheeLa4uYMpq+NuBZfTUzUThm7glBh15XDgl8EZC/TU
	/9v5dNcvdHtOUKW6WyZVMuYoH6s+5tGm1BozdpVAvXJmtcL3W25tKfi/NkL0osqQtBlcRL/KpGo
	On4qbpHdgSJR9M29NX66hi+GVRJro=
X-Google-Smtp-Source: AGHT+IHDw1JppkNE3Pc2vQueAAm78Bi4yzJd8yiAt0X04EEKarDJjeIUlzIoGHPyaDoU24MHjFJfRluhJg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:534b:0:b0:33e:c070:686e with SMTP id
 t11-20020a5d534b000000b0033ec070686emr72wrv.7.1711560966223; Wed, 27 Mar 2024
 10:36:06 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:01 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-15-tabba@google.com>
Subject: [PATCH v1 14/44] KVM: arm64: Refactor calculating SVE state size to
 use helpers
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

The main factor for determining the SVE state size is the vector
length, and future patches will need to calculate it without
necessarily having a vcpu as a reference.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7249e88ea13a..3d12fc2aeb9e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -843,22 +843,24 @@ struct kvm_vcpu_arch {
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
 
-#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
-
-#define vcpu_sve_state_size(vcpu) ({					\
+#define _vcpu_sve_state_size(sve_max_vl) ({				\
 	size_t __size_ret;						\
-	unsigned int __vcpu_vq;						\
+	unsigned int __vq;						\
 									\
-	if (WARN_ON(!sve_vl_valid((vcpu)->arch.sve_max_vl))) {		\
+	if (WARN_ON(!sve_vl_valid(sve_max_vl))) {			\
 		__size_ret = 0;						\
 	} else {							\
-		__vcpu_vq = vcpu_sve_max_vq(vcpu);			\
-		__size_ret = SVE_SIG_REGS_SIZE(__vcpu_vq);		\
+		__vq = sve_vq_from_vl(sve_max_vl);			\
+		__size_ret = SVE_SIG_REGS_SIZE(__vq);			\
 	}								\
 									\
 	__size_ret;							\
 })
 
+#define vcpu_sve_max_vq(vcpu) sve_vq_from_vl((vcpu)->arch.sve_max_vl)
+
+#define vcpu_sve_state_size(vcpu) _vcpu_sve_state_size((vcpu)->arch.sve_max_vl)
+
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
-- 
2.44.0.478.gd926399ef9-goog

