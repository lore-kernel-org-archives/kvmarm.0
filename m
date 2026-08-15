Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FEC375F8E
	for <kvmarm@lists.linux.dev>; Sat, 15 Aug 2026 09:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786785948; cv=none; b=EtqM//shBLHww4psnDX9RHhGhkaJCF6adFdtZtb3lEAVxIciBDBVSqvRTrvkXZ5E00ZOCe5uNE1Vrooq6YxOgUpOFbZxgUguGnWcTGrbUYkMALrfNrGjNceTFQEd3P+raLtMXU901etCSGpLwQqWHpaDe26xChHakZLU1/0kVbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786785948; c=relaxed/simple;
	bh=ca1jM0fOCLIP9WuBP03SPXW8RpJRHt73yJX9//rI98M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mwpNm2lr4m0o1Mk3hmP/ZMumHw5+FvN6To9tU7RGF5Sl8YkAZFV8LK2okb+iZEQ+5bUv6qXOcNeBueRvlJdmDTLOyMY65cqan6LWMchZiBnTUzTPySs+ObiC8+rU/+VNIbcBBQaVJJqvv8ebxUZ4pwLMG62MXkAs+vfp+bTvZmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ob5sgtgV; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ob5sgtgV"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f71156e1aso759557f8f.3
        for <kvmarm@lists.linux.dev>; Sat, 15 Aug 2026 02:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786785945; x=1787390745; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hk8cmy7ROF0KR33i9zqmPXL+Xk26nOxz+b7oFhOL0UE=;
        b=ob5sgtgVo8L9MkLj+CE628DvdJii8vgXsbc4ktU8GkdlBqM1YwSnZDuAM3V639NwFU
         AcafxmJWXZUU6Immaomf7V96333LUJviBQWRP3RtikY0MwDH+C5JUXDaaffVwKtsPtG8
         HVMBfwS0SknnOsHHe3KKWtDaJoFkHivryqxp8oj2E8H6IEIGkV9HkPpZ0guCNGYqx3wd
         kJrQtPVJfzXElA47nQ7N5e2jeKm5zGBa0v0UQ37hkR0uzUDIeDduEsoaHGP3tmVt5ThZ
         dNQWfwgWF14W2AGrRujqsK/3tyaQrYFldxJJ0L8dX7oQfV0HtGbNTHNwNt6kDe01DV+1
         ChGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786785945; x=1787390745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hk8cmy7ROF0KR33i9zqmPXL+Xk26nOxz+b7oFhOL0UE=;
        b=mZ+wZQKHs1r1ymNlkukPlKwuObHwAE5N/gB4HarJtqUv9ckyyLX+c/jG2QDd2vd3BT
         QdJogdccEn/3cGDD6xaWXhJZrakmgvuPPB2a3qaL1tHFMbk30uErOLI8iGXgW3tRw4g3
         W69KrmtCJzSR9FN5pkZzg4aTMSa3UKHvGfrG+iFNCV21vhUQ5hVzKJlHUiQVQrHS9lOH
         kudPGM+PG6E8SoKDrrtbHJ7k4LtSf/bNF+/YVMu9vGdYJwyi5JwYhMnqMeE6EX6eHC0a
         AJCKsvhAewLPm8rvNW0lRo7a/E+ahJfnJZoGPwAB+lTOZs84IhLdEDY8yYA33+5krrwV
         wnpQ==
X-Forwarded-Encrypted: i=1; AHgh+RocBqCkwOfeJ++12ZQ2gPAQoxnF7pc3HrtZbZS86ejZdd5p0i5qAEC/5tTqPhZCBkgSto48fqY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmcPtRXW4ymWKrmI1Slgx+bBZ0fjdeleeKKofkpldH5CoCLoK9
	ZCgd8i9EPHCfs39bmXN5ikchjNYgPfGeQPleQjCrmS6wx3mGW7NWdkta
X-Gm-Gg: AR+sD11Mf5vtrB8/hZPKvV4bqv0cZUbbLc7wDLYPaBbrZhtf3vA8583jGR9m71gc39R
	gbkkhjiuWVQFHJdR9zZ+OAgia5scz9kTOi1/rnDAyfMKSFIf9YLznIoE6lKs80mpHJBERtCrD+M
	m6wWMzTAB2IsCa2ieqk7+gqxcZH1vLOb2RSwQVkanBVKLMxhR4sSh05wQ0/7IxPnsLsD+Vpz5Ie
	CAQ54990KtTuW/g4p1DxI9y07J6bVood3bbOp/pjs9eYAqfrpz4HaRgAuqmNffvtrwR6wRK3eab
	4Uf6Abybxi7scopOqkTMkZpa4mcvQc/bneJDaEh08iChCB4h97MaUlLkAF+AczJajb6uNBph9yb
	1ayMSwuknm7Os2UC4pAjKD9dVCdKLZ9hcgykILJZ59aA7OfNA241LIW1SD16t82tDVTliOgyH9W
	Djotim78XrhAX+toCHOCsdXVd787x6MgjuOOPMCCGtdBo1A9SOxdgXAHwzYOE8rCtx92lb5RU9i
	yuNaXwg+60Lb5JZPspvK+/Too7iU3naBH0qH6PTTqIqBonbueZpk/IcqBnZTpBaVk7aH19ewSS6
	ufXPJlx/MGytbWALlHJNUMRd3iaGb27etWyK8KhNUloIOE5ofH6IczA0KuAtzSlLMbyNopfnag=
	=
X-Received: by 2002:a05:600c:3b1d:b0:499:87b6:f3c0 with SMTP id 5b1f17b1804b1-4998807e4c9mr158343345e9.14.1786785945038;
        Sat, 15 Aug 2026 02:25:45 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-aecb-d601-fc34-eb31-14a1-3704.310.pool.telefonica.de. [2a02:3100:aecb:d601:fc34:eb31:14a1:3704])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998ca63e5csm29202615e9.2.2026.08.15.02.25.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 15 Aug 2026 02:25:44 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Timothy Hayes <timothy.hayes@arm.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH] Documentation: KVM: Fix the GICv5 KVM_IRQ_LINE PPI range
Date: Sat, 15 Aug 2026 11:25:37 +0200
Message-Id: <20260815092537.31737-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM rejects GICv5 PPI irq_id values above 63, while the documented
range extends to 127. KVM also rejects PPIs not present in the
KVM_DEV_ARM_VGIC_USERSPACE_PPIS mask. That mask is populated by
KVM_DEV_ARM_VGIC_CTRL_INIT; reading it beforehand currently succeeds
but returns all zeroes.

Correct the range, document the mask restriction, and require the mask
to be queried after VGIC initialization.

Fixes: b88d05a893cb ("KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/virt/kvm/api.rst                  | 4 +++-
 Documentation/virt/kvm/devices/arm-vgic-v5.rst | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e3003a241d5b0..6d8fd74174492 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -912,7 +912,9 @@ The irq_type field has the following values:
 	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
 - KVM_ARM_IRQ_TYPE_PPI:
 	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
-	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
+	       in-kernel GICv5: PPI, irq_id between 0 and 63 (incl.), and
+	       only if present in the mask returned by the
+	       KVM_DEV_ARM_VGIC_USERSPACE_PPIS attribute
 
 (The irq_id field thus corresponds nicely to the IRQ ID in the ARM GIC specs)
 
diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
index d328cf1e22c1f..e24aed0c4afcd 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -35,6 +35,9 @@ Groups:
       populated with the userspace PPI mask. The lower __u64 contains the mask
       for the lower 64 PPIS, with the remaining 64 being in the second __u64.
 
+      Userspace must query this attribute after initializing the VGIC with
+      KVM_DEV_ARM_VGIC_CTRL_INIT.
+
       This is a read-only attribute, and cannot be set. Attempts to set it are
       rejected.
 
-- 
2.53.0
