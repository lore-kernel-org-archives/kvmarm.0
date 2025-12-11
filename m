Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0B030497C
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450039; cv=none; b=IJEK3EPeNytNBFAgpG0tgkI8shUD9R0l8ENndrzuNrsU0uwLuPCqMEzo++VDZpKI0ZTQJdlkAop4XrPWXXceSEIvRkU30FVlNZITH+PLfQxar4wZTV4D8cwf7ngzLYVv1nkh+kBayeDTe6GJWi7vnAwibA2MFe1ameP/Cu5NIdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450039; c=relaxed/simple;
	bh=G6xAO9iUhiJsb0iAfp+Tc1hPIB49GI9C9pSG8xtFscs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CfJWugp2bX2f1gdprAZkrA4x0zysdoZr7w6PeIZRu5ztPDVZBSzBmbQc+ZD42FUG0LXbY28Q0QtoGWdErgwbfPGr/LgRUeCh7aI834wYCeukbc2Yxp+8Bh4yFpe1xSKSEm8gSi1WjK0CxVQQ2qy1nugyGoZDnYMfZjYkARSYkzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tJe3od0s; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tJe3od0s"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779981523fso5943955e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450036; x=1766054836; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LhwV7f9asMHZiaDeExGO7dFsVYOrCmIj/2dE9NEaIr8=;
        b=tJe3od0sXi/wgj13CIMgCI6BElGGC73eN82PzvN0gBnkRSFVq/4uxjo6n2psCNEWFA
         64UedPsjYqMw7inOyu5rHVVBkVQWNTufiVXGAGAfJGde+uYgG7NJ8dBE6uHer121Jfm9
         z4B3vbWTCxrWApv9aJnkRzMaTteqQo+hz/HoRjkZeyGee7P6ejYs3wmn+9aeqBBK7Jz7
         qRI3Sx55wVDSqwKomyaiiNvIj6D0eeM6a3SR/KqScI9HfOFX2mdl3gJGzxYar48E3eWh
         mKlNbmJBIFvl5QyHm7fWDXzIgftJ3EazCvJiwQ2NMPUOnshsdja0LxG+YbIB6BY1i8j6
         LXCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450036; x=1766054836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LhwV7f9asMHZiaDeExGO7dFsVYOrCmIj/2dE9NEaIr8=;
        b=IVwe3QUgtd5YDVcXgdZrj+QQyGsEc38ggpmf0SuIjVUPa+7qjkKAO7oYY0G48o+SlG
         KeEGSRfzRTdc5vQ8QMKEaKK2utXWLc2nvmlN5PU8u30Vb8QftBFpjgwwLDtzqcVSO4hZ
         vJLzA1ReI7XepsOyrHbM+lUVkkHaxM3OCukNrgkxJYwb+yEY0gJGmai40dwRFpF29+eA
         gBHdJ59GfqD2CBSbfUfgpXl/9cUU6HCC+olTaStjwtR3A0khG2NAocidf0nRonWsQFf5
         G7U0wArwRZe95zmTW+ZRdTrhQRk8DijMac0glPOYQyFwnaMp7nXze4xF5g44hc/w5xHx
         38Zg==
X-Gm-Message-State: AOJu0YzbvaG/lH2ueVIq26qJlUsr0ymbxbAH8GmKQB3aCnep23LOGen6
	54m/CuQSUK75yaF0Mv/JUe5n6aNE2OOynRs0Y2rDRlDOzDeMQHeByiGw9kqVS1qXk6rJyPnSRcM
	xzKkXhssHrpVaQTtETAcaBAKOzvLIpGCywgqVpOjvnV4s3h7/EN6G9/yj8YzU6dzSbVHhiABKir
	3qX0tg4GBokx5ZyHyqNZFCE0BMptqUc1E=
X-Google-Smtp-Source: AGHT+IGddMYZDqjoM0os2VzLPgjYnQL3pqMGYeFRpzOdPX9ZWdrz06l4/4Li1Syb/xu5pe0iDfVKIhjoJw==
X-Received: from wmbjv23.prod.google.com ([2002:a05:600c:5717:b0:477:79a7:7d7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ec9:b0:475:dde5:d91b
 with SMTP id 5b1f17b1804b1-47a837925eemr62714245e9.17.1765450035947; Thu, 11
 Dec 2025 02:47:15 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:06 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-7-tabba@google.com>
Subject: [PATCH v6 6/9] KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Supporting MTE in pKVM introduces significant complexity to the
hypervisor at EL2, even for non-protected VMs, since it would require
EL2 to handle tag management.

For now, do not allow KVM_CAP_ARM_MTE for any VM type in protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 7195be508d99..5b564576160d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -44,6 +44,8 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
+	case KVM_CAP_ARM_MTE:
+		return false;
 	default:
 		return !kvm || !kvm_vm_is_protected(kvm);
 	}
-- 
2.52.0.223.gf5cc29aaa4-goog

