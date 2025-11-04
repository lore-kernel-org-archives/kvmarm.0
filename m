Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6011A2EC542
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261155; cv=none; b=MYBZr8PamFsZjyVVMtUDsR+WmPPhw/waCK23PU3ic+fluYwom1+BQxya/NH5dfFxQ5cYQMmqMPx95esDHCZszul/0H+v8lu762tO5dQQwVtenjoZBeuWd0FEQH7hZtYS0WXZGLjc8TzSKXY212Y3pwvHHEbZP824pWF2EzV7h/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261155; c=relaxed/simple;
	bh=8RS3083Mfdwf5IZsUL+iolWOJ7X7pDocDiB4GYbmxXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BEJ0RZguodfxEGayrl244c7f/tSGchtYqnM93ZhjyBHyxIdt3M0n6e9HiUWD1a6jzEymlWhfx2SRri5GVH3BHcs15QiV34/nsCxZxKWH4Ku/YejHBayuzRpXJzo3dbHIqcLJylCNYk2nhnBCLGP1cEQ4iaKRZQ3RBiUkjpLwLAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BmHTTdJz; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BmHTTdJz"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47496b3c1dcso65324035e9.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261151; x=1762865951; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uk5VtD5Dd7LbENAYytw7INJT4NVu+9j4B2UId8tkh5M=;
        b=BmHTTdJzqgeE+e30n+9BieEIZI1GYNvhvoKq2qOrK/UWTwnCOY8K8Ejsi5T65jHgjf
         iEa0y5b/1qof9rmkP72ozQf6BE8OryGTx9eCe6QVNjpx7iNGSZHZZNja996il7rG796k
         2O86xvR3ddp0HNsdjVN4M1q9WJ28DoX1bbwBrmWlSChHBHywjHXBGxhA0+t1UE92AYb0
         ZysO+M+v+DwSyTdSP5+CXHPw7xMy0HvAGOVktqoa2LO+zPICAJepJBpkRVPBiU4ngk6j
         pEmoSY/WCmOk1v68bzyv+X7cyw/XrqiX8hitTzOUeIM2gcRFInrGQy3AfLNC68Izy5u2
         aHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261151; x=1762865951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uk5VtD5Dd7LbENAYytw7INJT4NVu+9j4B2UId8tkh5M=;
        b=biDqfHBqUhJ2+L3ZwYtqGBu/ZwdxyqW5mCehrFLbjxTijsaTePaMFe4p4xKQsHUL8s
         TYn7Yu87oKCBQfRq7FMPlil9Y/usVWW2wyojTzynuEkaPeueUkLRlSXmBk7kOiUqn028
         Fun2G9RGLwt4ARiwlLSwMywdWdKH5spPsnTzMki9++yqzGFy3EFusye1ZOFfXVTT/NOu
         3iqr+78M0c0IS+oEXfrrPXxM4AT3GfTJUhY0ACdqULAR8763Y0SiKFBI77efvAMXl/7d
         DAHhFQHC8/QG68Rt9O3KmcLr2f+OSgx63B/WbMsdi+gcyC95ZvnhhMQESOrZc3H7tYoC
         rMIQ==
X-Gm-Message-State: AOJu0YyRZd7VUJ2+cpscMJmf3k6fYIXCNBF2HYhnApjXDC9Rb07ggc+O
	y/4imqOUXJwvetI89cLpo/Lx/+tlF2Ykv8v/OyxrnVeh6MUtazpgE46qmJKduXFz1aaJ/HnwGEe
	ojJcgkNlNtwRj4KgTIM1kyOLgpwTWkMJIx1c7RaVG748lNJEsokf9uFMLmNvu4lpPsKcOCHAG4g
	Uc2mCFnCaS7HH0JU5THmPNnKIPtrlt6lQ=
X-Google-Smtp-Source: AGHT+IGism7LbQKy6ZqLAEKd9DnR+1VbuHstFtUryMoMnYhRFZtVWfFSLXUMcBJb/XR+uSkPEq7kurVWiQ==
X-Received: from wmbd7.prod.google.com ([2002:a05:600c:58c7:b0:46e:5603:f679])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b6d:b0:475:df91:ddf0
 with SMTP id 5b1f17b1804b1-477308ce089mr156752655e9.33.1762261151514; Tue, 04
 Nov 2025 04:59:11 -0800 (PST)
Date: Tue,  4 Nov 2025 12:59:03 +0000
In-Reply-To: <20251104125906.1919426-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-6-tabba@google.com>
Subject: [PATCH v1 5/8] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
register accesses. These accesses are trapped to EL2 when the bits are
clear.

The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
had the polarity inverted. When a guest did not support the ExtTrcBuff
feature, the code was setting E2TB. This incorrectly disabled the trap,
potentially allowing a protected guest to access registers for a feature
it was not given.

Fix this by inverting the operation.

Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43bde061b65d..df0c59a29b35 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 		val |= MDCR_EL2_TTRF;
 
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
-		val |= MDCR_EL2_E2TB_MASK;
+		val &= ~MDCR_EL2_E2TB_MASK;
 
 	/* Trap Debug Communications Channel registers */
 	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
-- 
2.51.2.997.g839fc31de9-goog

