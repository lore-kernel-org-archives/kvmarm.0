Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF83292901
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 19:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250529; cv=none; b=s1jZGp2s/tgm28vhEAnCINys+ypi+zb/i0eRIeAFB/fevstnORBw5UuXRbwx1+a7DX2A9c31QsvCKAAow+0fKE0g29mCG7tbPHmcU0nQro2l6+SavA8d4pKNVQI5Bd9AH5jzkNfXN7pXDpvtqAMjR1Ih5VaYhLLR+WexXbD/hg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250529; c=relaxed/simple;
	bh=jlT7oUjvJOznjnqnhNqTKsiR/OzaJm9QtnlVMZATBTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KJTbLDAm04JUEPlwWeAj2yqHTU5Nb+FQDZyxEmPEoDQuXR/YsqGltjNR7MBcsp1ZVgAza7Y0oJOLKf3O6b1D9qg9rxXlHiyBWPT7ghaQAEGgAPvVTBZyMuTnQtOIuoxtOU24lDL3OA2480Offe4j/qwEij32tVoujySqRODB+NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BWeEYJ4y; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BWeEYJ4y"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-85b3a6c37e2so16812639f.0
        for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 12:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747250527; x=1747855327; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1yNW4zWWpO6G9+zdCVIjhXgj8P623/AU8qHzqkHrm1A=;
        b=BWeEYJ4yNMiSwNLwK6+VhfuZr6UGT9qCIfei98QmWz38S0po3LwQs1JGvn5MZSTDcR
         5x5G4JSxTUjUDV8UbX/OWy45QcacZw64fcXwyLUUoCJ0RRr2KyEcpWmqRxB/p1TE0UTt
         csIxM8gmk5gObNUlLfzirPQH8oABxk57rto2OnRwsE0Mh33aMN80e2RG+naj1zIL0AU/
         VJpYMVWMTvuAxAFpzB8oRcEO0MLKepUaZ3R5JEtqsYGAb6AefoTWd/IRe1JAC1xUUsp0
         ikVfEgfI/AdXh3UDrACm5w5STGNHyo4JLd09bpuYLECGLgnX7tdhl+M4Hd5H7b5sFIf4
         DuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747250527; x=1747855327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1yNW4zWWpO6G9+zdCVIjhXgj8P623/AU8qHzqkHrm1A=;
        b=SsITtbBYiBva8ZZnZSu6jTS39slpiXkIAhefKMuC9UjcQobfQyTvXSTo94XOzGnaUv
         geSqZozNkBcE+ofg7hb6itOGxPZtEcVaz5i3XuJf8U3wmSVs8TSSiUDWmS/U9liIFItb
         k8wZZ9AXArbU6NuDWzYoMsTu8eVOSV3N8Rfl1oZhOdZHh9sLgIZmsUuptJHuN8evmMcK
         QeTd2THpCcxGpTtQpw03HjS2Pij8AD/is7+8rMv0dOq/LFInwXcjbyunKj1XkImGffGx
         /prKHkZwUSff40LYRD0eQzCpPY1xDmFT9LogS6k9bREOGehc+OMjzdOIoJ7GFM3m555k
         ieSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXv3+v1ulRVTjKGXiSb7l+5TqscPy3Jg/dxVKgXfB/T9qZikswmkQnaVkTUyMDxTxNBlYuH4uc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwM3SOdPCpmu6Rfl/xIa1ioWYzt/ct5EnLlfdY0VO+tA9O5nTd
	Dv84qg/cnbubiLzxh9gPNYc0gVZHRw5rPUCfxluMh/HbK9OORFR4ix8QmjSJbFB6+btVvoreuO7
	bMP9Y0Q==
X-Google-Smtp-Source: AGHT+IFKQuF2BacC5AkCgJDM9pP+9hGGYSCBt0jtM4p1OPWuCYZziCJSB8eP4NMiOU8nR7NLUAah4kaGb+Oi
X-Received: from ilbbs4.prod.google.com ([2002:a05:6e02:2404:b0:3db:6e7d:fedf])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3997:b0:864:4b3a:9e3a
 with SMTP id ca18e2360f4ac-86a08e6ef17mr571479539f.13.1747250527190; Wed, 14
 May 2025 12:22:07 -0700 (PDT)
Date: Wed, 14 May 2025 19:21:58 +0000
In-Reply-To: <20250514192159.1751538-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250514192159.1751538-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250514192159.1751538-3-rananta@google.com>
Subject: [PATCH 2/3] docs: kvm: devices/arm-vgic-v3: Document
 KVM_DEV_ARM_VGIC_CONFIG_GICV4 attr
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Document the KVM_DEV_ARM_VGIC_CONFIG_GICV4 attr under
KVM_DEV_ARM_VGIC_GRP_CTRL, that includes the values supported to set/get
and the expected error returns.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../virt/kvm/devices/arm-vgic-v3.rst          | 24 +++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index e860498b1e35..2eed2ac13542 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -240,17 +240,33 @@ Groups:
       save all LPI pending bits into guest RAM pending tables.
 
       The first kB of the pending table is not altered by this operation.
+    KVM_DEV_ARM_VGIC_CONFIG_GICV4
+      attribute to enable/disable vGICv4 for a VM. It supports three values:
+      KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE: Kernel is not booted with
+      'kvm-arm.vgic_v4_enable=1' cmdline, and hence vGICv4 is unavailable to
+      the VM. The value can only be read by the userspace, but cannot be set.
+      KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE: Kernel is booted with
+      'kvm-arm.vgic_v4_enable=1' cmdline, and vGICv4 is available and enabled
+      for the VM (default config). Userspace can get and set this value.
+      KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE: Kernel is booted with
+      'kvm-arm.vgic_v4_enable=1' cmdline, and vGICv4 is available and disabled
+      for the VM. Userspace can get and set this value.
+
 
   Errors:
 
-    =======  ========================================================
+    =======  ==================================================================
     -ENXIO   VGIC not properly configured as required prior to calling
-             this attribute
+             this attribute or trying to enable/disable vGICv4 for the VM
+             on a vGICv3 configuration in the case of
+             KVM_DEV_ARM_VGIC_CONFIG_GICV4
+    -EINVAL  Invalid configuration supplied by userspace
     -ENODEV  no online VCPU
     -ENOMEM  memory shortage when allocating vgic internal data
     -EFAULT  Invalid guest ram access
-    -EBUSY   One or more VCPUS are running
-    =======  ========================================================
+    -EBUSY   One or more VCPUS are running or vGIC has already been initialized
+             in the case of KVM_DEV_ARM_VGIC_CONFIG_GICV4
+    =======  ==================================================================
 
 
   KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
-- 
2.49.0.1101.gccaa498523-goog

