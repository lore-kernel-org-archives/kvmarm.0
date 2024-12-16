Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAD92AF03
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346270; cv=none; b=u32LpKUpK7+IpIxs5VYBTZcWSkyxIPOV3joaSlwVg5MUxGYRSQYAEHS27pNgBZJqsLV3Vk9VF2+ccrpCX+voWeLoNVFij0f1pZDnesk8zuQm2KaSxTybiTHQ21FknP7zvwKw6PUxWIsYP1+l1p9/ZifQnNdnKS3tRqoJxd/ZT6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346270; c=relaxed/simple;
	bh=ysJZzz4bebqvQd+TA29ZFCU4GbTt6tCz9q+POCcSals=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ehf+63vPFpHqIonDMA3Fcem4+Kx4wjhQ4ElgS058eSWYXFpONmleVdeJkEq4AaKDSgRP0WGet7Eoib6QhlT4g2eseTBwCnUiGRQvHcU4YzY3CApz5Zwk6pF0lBYJRyfVD67uKZsg0eEVwPledUiPatPTUpeijRnumSpRJVIPiE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dGFNFUn4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dGFNFUn4"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361efc9d23so36756115e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346267; x=1734951067; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lFml3JSMGutEQ6gsrAJI0WkcZQLmE0G98yGh0i8+VMo=;
        b=dGFNFUn4I6s5VcQg6ojoRoqzsARiiRjsN7sBTVgfU3I8s1SUkMz+1zvvzFfL2K8TDO
         lGaxZHaMkebczdmLgg/d3WYM+RzEMD64/feg9QcHEMp98qnHUS6De6Kwdoh2MFY+Zp6O
         tBwu/mw8pcpl3XwpMHdC3gtAXsjxJbfoLEYYbMLg4tlR8BTR8cLuw6D7F30gv9grwsTk
         IC6txUHD0oF7YBxg0yRh+hozPFfxvDz1ijyigEIFAYBOT4RkRve6g9yt7K7AiUAgYoOV
         ZiXx4yMwCgYUKE/LYe/yVC7kwlW3uoPJJZYTnWjGe/zMetRBZNcdNEYBhkbyMVdPJZf+
         cdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346267; x=1734951067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFml3JSMGutEQ6gsrAJI0WkcZQLmE0G98yGh0i8+VMo=;
        b=nQawh6nEjhp0EYlwHvZI73XAtGm4/+onuxN57QyZCchiu1rr50ZbIK2yg0qCiPYg4Z
         JQtOKm67SZIfD1bTIU1VVOTCUnhb/NiSJ/o/jSzTES3Wqmkd/H42FDEaBgIR9fjQqQO/
         xxTzqwnVAIbaFsQPij+4uBXCvKfqXElyszvgdoxZSXRvpNIu93vYpkzENPfFMFlLY7JY
         UYostCaH42Gr0hG2XkA17UF4UmKL89Y9K24zaS3cIwT1QSUSd0ni+2/RCDAFNMiIIgRb
         ITEV3/bc4Xf7QppysUGDnBrfyQSZH/5BSS7j3x4Snvrntiimm1afTH+k5Tksv5f4eR+f
         Kb+g==
X-Gm-Message-State: AOJu0Yxg/jGDFZkRef97hbyA7lMh3yEfBt9rpydB5ii4Jemob9f4+s04
	U61n6z2fP3kMyN0eechWGibke/PE2C7eWYisu1f+uaIekOdWqNb5xDMqAFhMlpaXI9NGZAL3MCb
	Z4p3JG9spaTAui6//9/RTDvMrfmbp3HolL5yJjK+JuBmi1FyGfVwTY7il0NpIzZFG4nlLGmm0cb
	y+MZjIrd7ntW8CHf0CmKIdgfZnASk=
X-Google-Smtp-Source: AGHT+IFP4ta5i0lcC91zFRM638m44kb4PpoOHu3nr7DtprXQkYFF+xVd+4sDwByOyyfX7UPh0ah2h9SuIw==
X-Received: from wmbdx10.prod.google.com ([2002:a05:600c:63ca:b0:436:1a60:654e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:468c:b0:434:a802:e9a6
 with SMTP id 5b1f17b1804b1-4362aa1b2d7mr107265045e9.7.1734346267353; Mon, 16
 Dec 2024 02:51:07 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:44 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-5-tabba@google.com>
Subject: [PATCH v5 04/17] KVM: arm64: Remove KVM_ARM_VCPU_POWER_OFF from
 protected VMs allowed features in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The hypervisor is responsible for the power state of protected
VMs in pKVM. Therefore, remove KVM_ARM_VCPU_POWER_OFF from the
list of allowed features for protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fb733b36c6c1..d3f67189497d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -331,10 +331,8 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 
 	/*
 	 * For protected VMs, always allow:
-	 * - CPU starting in poweroff state
 	 * - PSCI v0.2
 	 */
-	set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
 	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
 
 	/*
-- 
2.47.1.613.gc27f4b7a9f-goog

