Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C956A3081D4
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313553; cv=none; b=New4mIaXNYMc+6rhwcb4q17JjQTQcXVqXj/BKZM+AalAogVNfvAs1y9/Ffo8BN0TfU+qWFEC2i3c2cSQgRQeXOGpLc53dsjJpkPFdlNFII6aaIxIVsLvG7A356nCcDhSb+bF+SDniJUcxkYxUwG0p2EYQRtu3XgEMuD4YW2rBgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313553; c=relaxed/simple;
	bh=k/nMGCP44lTyxOTDNhpSpKnt2VfnuuwutQPmX8YXDEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iTenA3AoytBMEgpj37dSQ4qBYsFtFDFWiJ11+AYA7o7LLIqVxM980CV224mXLXKrbDSi60A9Iy5UeSjPHIsRCKACHops/KlEDYxqMdefC6tnlNzgGMNNnv/+bHqBD17n0ooEC/ywymEIp31/lk11QjRhz/XhqsN956Ubl74e0FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qMuOe7w6; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qMuOe7w6"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7c6ce3b9fa0so6819624a34.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313549; x=1765918349; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=avZ9OXi40r9I3tBhG1OZSSWwPglo/DoIFRIQKLTo7zA=;
        b=qMuOe7w66mgSG4sCO6IXAvdtGdNDgGjqYRHLp8yQPTnwQ7YU9RxGwlj0XuUygmZzlH
         auZC86yFe7qWggqiI23e3mi7tyGgm8lqUrYHJ4V64ro6hwsxurpz4k5BKSwnE4KuQaKQ
         45o2dmdDiira/9+IAw8XQ4VzKTso/UYjHL9fixdf79xqjYSdBPKeoHKgi74SGKoZS1V8
         aD5+qfOBW5jvebh6QeC1jXVmpaHWxudAFpP+/C+oHevVWwaLklz4MtcoP8kz31A7nq6B
         eljk/LituHqCgPpxPoGsx88j+mYd9ttgCC3WvcaaLqxewJPGZAlVUwRQX+qc7iZ77TVr
         567w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313549; x=1765918349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avZ9OXi40r9I3tBhG1OZSSWwPglo/DoIFRIQKLTo7zA=;
        b=sD5SwG2ON10oowSZUNorQ9MOeP9KO2dATY9AgGxBLkzuS1/8vXXVR/ekbdTJM5I/0x
         t8KH3qjHiBvzfcqz8TEQwi1MzMiCafir0b1935yqNBb34Tu9YtpOAqVj00veLx9PygIC
         WWYQUL+XemVbISC0t4kgdba4WRlf17cq0JGYrjWHqaEAjG2vhp6ZoD57LgvIyKIoA8wZ
         eiAymJWcNQNjCa11YECvsmjVEPZziI76bUgK9of5gxB/J9Crd/kbtThH8yiCPYrL47Uv
         pyaGpmSBTkksch0elKrzNShCWhK0dixP8xfXg2MIGwQYJwLgRaCe/K+omBDDK6aoN78N
         w0Zw==
X-Forwarded-Encrypted: i=1; AJvYcCXnWnRwCtXwEurbKliYydovs8NewTro3HmvqU0c0z9MjW33oDMZkrRjvwmYXaL3gt3PXn1yBBw=@lists.linux.dev
X-Gm-Message-State: AOJu0YywkhNL1az0B5BvxKAslFRGyrntJaRlTj7tk0h2bY1Raj4Moa4a
	U65C0o/RJ0cObhwZ9COx14Lq2OkutnXnbeejtuawhlOA9rqityW49xvCZA7fQL9V3sakstwLwpi
	o08CwU2afVlJm5SaPYpUP1g4dTg==
X-Google-Smtp-Source: AGHT+IGBJBO46UR3T81/n2L+V0opSJVwtEO5cO1rJLAwUl/wZGtRFy5mrcug0+A8VGtDI6JSlEB8C9Gz2V+VpcB2Qw==
X-Received: from otbbq1.prod.google.com ([2002:a05:6830:3881:b0:7c7:583b:2e9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:4411:b0:7c7:1e8a:c9e0 with SMTP id 46e09a7af769-7cacec42631mr79191a34.23.1765313548734;
 Tue, 09 Dec 2025 12:52:28 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:00 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-4-coltonlewis@google.com>
Subject: [PATCH v5 03/24] KVM: arm64: Include KVM headers to get forward declarations
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Include include/uapi/linux/kvm.h and include/linux/kvm_types.h in ARM's
public arm_arch_timer.h and arm_pmu.h headers to get forward declarations
of things like "struct kvm_vcpu" and "struct kvm_device_attr", which are
referenced but never declared (neither file includes *any* KVM headers).

The missing includes don't currently cause problems because of the order
of includes in parent files, but that order is largely arbitrary and is
subject to change, e.g. a future commit will move the ARM specific headers
to arch/arm64/include/asm and reorder parent includes to maintain
alphabetic ordering.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250611001042.170501-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/kvm/arm_arch_timer.h | 2 ++
 include/kvm/arm_pmu.h        | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f45121..d55359e67c22c 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_ARM_KVM_ARCH_TIMER_H
 #define __ASM_ARM_KVM_ARCH_TIMER_H
 
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b4116..baf028d19dfc9 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -7,6 +7,8 @@
 #ifndef __ASM_ARM_KVM_PMU_H
 #define __ASM_ARM_KVM_PMU_H
 
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
 
-- 
2.52.0.239.gd5f0c6e74e-goog

