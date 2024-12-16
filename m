Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43355203D5A
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346296; cv=none; b=WGNRR3JuoZ6gVtmikMpdXwfP4Am1pDHsqMW6NUXsIBuUcCmO33iFKZYqyQ7nk9/gSmjRgtAkcj3WdeijC3I9pdhHY0B83k8upP9VciBdjjf2Oizz71dn49PYN4dGPBaIswSL+fLO8lFYl1MKNv2gGULh49Qyi+xwRCq84Vs0yvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346296; c=relaxed/simple;
	bh=5+x5PdKqwqC9v0R+RZdvhIjiXfl3A0a3M7LGqElN/yE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VkAVSj1GBqYBJEpz0dQU1XOXHCnxox9G92+HP+LhXUDrDuKDIcZfMvgnLb46qp8hgHjA/An32D8WluhIAKB+sm6Rv4g1bSyCXgN1IKvMournA79KzgH0VGQIcOj9WPqWSBEo6fkQEghm7oegCajCUO/nK7PHvlVCqLjiFiU7sLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=he2WZECW; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="he2WZECW"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-436379713baso8883995e9.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346294; x=1734951094; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vkc2lJTmOE5SwiXWL8j1pu4J4OtvYGFDXBGNRHI6lfg=;
        b=he2WZECWxHq3PCOG6aURXMq9u//xw2pOEEUrbBcnItxZnkueEJ9ImH7pkYmg+SApB9
         sfe9YBpNq4666aBvz7e7xTzjeXqcrA5bMHuLox0Wmu8eq7rI4LdzVbDh59A8fAY/bI0i
         BBMHTnRvaG6WwZukbiQGTUqwhyC2G/wurjuowolidyuHg162tKcaD2lGCQI/m5xlDzXz
         TMQJFaCWhRRHJ7l6zgq7F9re3cPfNbjC1cw2x9GGJy8iTUC35ig1j9HversEykpQTUlj
         79MmFZ9k4RUVNsRtuo2KcTQcRx3IiJCbHhuzkDxdYDdFIBimLqX4Td1Kkua8voDkxgTz
         /QNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346294; x=1734951094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vkc2lJTmOE5SwiXWL8j1pu4J4OtvYGFDXBGNRHI6lfg=;
        b=OlbXJM89kLxFp3faa10kS+NcMZpO973TslzgZGXmv7w3LSCSnufG5CGPecoGppdFd5
         A9V1celIODAs/Mup3NspxKjyramKjnhcdMG/PATVRHYs8n+AjBhh0AdGF9FjtWU+wtA6
         tBKGGH3Gr0nUjU4Hp1wBmZogkQMmdu8/9lV2Dh+hFWO7jy8EVhhCkxppsUd4CPGdsssX
         vo9wDn6fS22UBedEw45jO2QIkPsrZ6qnBX5ZWw5wJn08A+1+PVUEK8iaWifQaua743dL
         ftinwxPeJpaLpUVW09OiPhnuNXFElufnRbPh3iJ30enyAa8sKSarQKuW4zBE2Kdv7RnR
         OXrw==
X-Gm-Message-State: AOJu0YyqlIpqo1R7WPJouk+tPu1rX0lGO1Fc1dAMrQAOAZsnfrc2xcWP
	Hm3zNKi1DztGra01iiM169OlKHXUq8T2j3iviSDNBP+ezNmCBy4IAD4KA2jFxA/cuRRExEYGc99
	0VjcQh/YHb3EwB3TB4VS4c4Z7U/BPr7fli8EobARmt7ep38NOEenZzIIC0BRDbd0sRn450UqvRi
	UG77DH+7uS+1aTp4BPBqbdnAomx08=
X-Google-Smtp-Source: AGHT+IE6dzPeC92Qjqfbxx0NlZAcvO57FuNuJtWGIFlLNf+nKTtzoaYF9JxHvI4ZxzEANAaeGwhjrxt5iQ==
X-Received: from wmsd5.prod.google.com ([2002:a05:600c:3ac5:b0:431:1903:8a3e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:871b:b0:434:f0df:a14
 with SMTP id 5b1f17b1804b1-4362aa147f8mr118538075e9.2.1734346293709; Mon, 16
 Dec 2024 02:51:33 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:57 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-18-tabba@google.com>
Subject: [PATCH v5 17/17] KVM: arm64: Use kvm_vcpu_has_feature() directly for
 struct kvm
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Now that we have introduced kvm_vcpu_has_feature(), use it in the
remaining code that checks for features in struct kvm, instead of
using the __vcpu_has_feature() helper.

No functional change intended.

Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/nested.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index aeaa6017ffd8..92e746040de4 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1021,8 +1021,8 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= HCR_NV2;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, IMP))
 		res0 |= (HCR_AT | HCR_NV1 | HCR_NV);
-	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
-	      __vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_GENERIC)))
+	if (!(kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
+	      kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_GENERIC)))
 		res0 |= (HCR_API | HCR_APK);
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TME, IMP))
 		res0 |= BIT(39);
@@ -1078,8 +1078,8 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 
 	/* HFG[RW]TR_EL2 */
 	res0 = res1 = 0;
-	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
-	      __vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_GENERIC)))
+	if (!(kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
+	      kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_GENERIC)))
 		res0 |= (HFGxTR_EL2_APDAKey | HFGxTR_EL2_APDBKey |
 			 HFGxTR_EL2_APGAKey | HFGxTR_EL2_APIAKey |
 			 HFGxTR_EL2_APIBKey);
-- 
2.47.1.613.gc27f4b7a9f-goog

