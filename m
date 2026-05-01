Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DEA3A7F48
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634439; cv=none; b=SVwlwzuKdRTqD3hH8rHllHnxGK590RztMPUpMH492j7kBtK4HXTzykiPmdOv1k6IhVKYSrzYUUagsXMhkPosK4gn7jjeSRb+o65a+BQrnP2gsH48NfzBiBzoctQvTbhHalhHWH7z++OD3xu9WINNWZ7a2QBr8gKQDUzdHk3hjJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634439; c=relaxed/simple;
	bh=hDWBK5NoJKy+6Kx7m6iUjizTKOjBwxg/U8Mh0br2RZY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VcAcPslipsKSAF0WBGdFdfz8C1J9ymGcR6gonklXPQxZxw8XAYGYuGmpELkOUXcjxmaH9PR4AVq6iohO6oM8rgdmAz+8OsbKpBWgwYto2uN3+6mFOnk++qjlKn2HoNmh+CQ49vkEJtYIGilOkb89YaR0aB/deWal7cMyxxeKA04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l82ZBOkC; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l82ZBOkC"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488ba2f4094so13260515e9.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634436; x=1778239236; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vwSpZfMSAme8K1/Tu2WzVQA/LKpXv4XDkU/OYSLP8lY=;
        b=l82ZBOkCINeoqgBW8yPimuRnl8dVXBMHWmehFtBgjLk1neQy4S+tFMVpPwMK8qRfoh
         4kuKyvxHLu2Hv1Zc9I6C62ca/0ykN6jTH6p6dsI41U4UwYieSb7AWqedZF1ESOnPHvxk
         ReM+waKScsMQCJsawAVp6emWTsMT07fPEUJ2wxJu4ciYI/vkDwDNW+9yEiDkxgtIg03Q
         utuqDUg+mrLh2PPIhCq/82Chc4a36jsyFQZVlW+TVpJ/FkRUPrl6EzGsDz2IiurUdwSt
         2kuMlRAC0NHmjbmD9rdWNgqAOf0VMm7aqpsXape9DN3pqzVpJykeTtP55KIaFpXrSwMN
         oT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634436; x=1778239236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwSpZfMSAme8K1/Tu2WzVQA/LKpXv4XDkU/OYSLP8lY=;
        b=WqDmNsSncZN3jeWgjD7vdteOt35aE40KAol3gkd/COhQSCAkwuIi8oxEd88OWfnR4q
         RsQjLZz56yaHpz0YGcYMObe8TtUzF+rzP2YeFvka7SprMlLz96od/kStdC+R3j+YZBPO
         BDLIMwp9ya7XE1iH18evFFmEOwbnb0RLBkWTzFshTLrKFZOlwi5Oi9HwvEgs0T8+kujT
         ARu63t1EJQ70rN7nrDFHBTtzDcgPr/tM6u2QgBsLMg6vvW9nSgsQ58ze6QI7AiS3dbA7
         xjdOhgVnxwK3tCQPRZn/Xq928IkgfwXv5msYHGsXohuFsJyEA73VhSYkM5janI+cLDBv
         RcwA==
X-Forwarded-Encrypted: i=1; AFNElJ/DDlWl36H7j71BBGUutaYVzw4ei1GjrDt+39ILTH5vnz0+lmvRd9PxhW4OBZR3lRFPcHkAEgk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyIgbyPdIWfx2pvGOq0IA8FudRu63O90+z1pUPFwPxUwd3LgEt
	LkYQmyTJ5IveEORiEdlmve1lyMNgPRfo5deWVthHWWwGMpLaQ1PECDHK6qljWQHjvx4mUGhSm5L
	18Y5oJ+nTqewkig==
X-Received: from wmbjn2.prod.google.com ([2002:a05:600c:6b02:b0:489:d74d:f20])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:64cd:b0:487:243f:dc3e with SMTP id 5b1f17b1804b1-48a83d6e17cmr115589325e9.6.1777634436116;
 Fri, 01 May 2026 04:20:36 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:27 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-26-smostafa@google.com>
Subject: [PATCH v6 25/25] KVM: arm64: Add documentation for pKVM DMA isolation
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Populate the section for DMA isolation in pKVM with the newly
added KVM IOMMU and pKVM SMMUv3 driver details.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 Documentation/virt/kvm/arm/pkvm.rst | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
index 514992a79a83..46e5c553646b 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -77,7 +77,24 @@ Status: **Unimplemented.**
 DMA isolation using an IOMMU
 ----------------------------
 
-Status: **Unimplemented.**
+Status: Supported for devices behind SMMUv3 supporting dual stages
+of translation.
+
+With ``CONFIG_ARM_SMMU_V3_PKVM``, the hypervisor will take over the SMMUs
+on the system and provide an architectural emulation to the kernel SMMUv3
+driver transparently.
+
+If some devices are not behind an IOMMU or behind another IOMMU architecture,
+DMA isolation is not supported, as a driver must be provided for that.
+
+DMA isolation is enforced by dual stage of translation; similar to the CPU
+where a driver can register their ops through ``kvm_iommu_register_driver``
+and implement ``host_stage2_idmap`` to shadow the CPU page table.
+
+This implementation trusts the systems firmware not to allow the untrusted
+host kernel to bypass the SMMUv3.
+For example by resetting the power. In that case, it is the firmware
+responsibility to save/restore the SMMUv3 state.
 
 Proxying of Trustzone services
 ------------------------------
-- 
2.54.0.545.g6539524ca2-goog

