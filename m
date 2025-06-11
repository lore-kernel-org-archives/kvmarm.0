Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF51C36
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 00:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600650; cv=none; b=kIXdMgQi3ZoYSpIH/Q9YAER8Df49Ci/mfo957KtLRg21/fd/TyiJMB9o1xE84eJ8BJd41pGsiVGday0L/KBr0aJiJuWZ0FLEFIsg7CqfWoC4vkzxBwTPXVY2LZWEP/My88qYA9rhS86KVFhY0hBIa3iazblKvjLiYL+GDoXrGAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600650; c=relaxed/simple;
	bh=PdsO7KmCqCXh1u0m3hplmJorUCeZc5tHsh93uffqrb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mcGWXzV1T4aUi6Ez1AXiuJ1uJj8jE5x74GUiKGnR0NxYbOedOLh6Uwj3O+weV4qsz6Le2Q6hB7O1NT50zR7yN92VSpNMupvODzXA3TVK6IIZgI+0/HAx+XFyoSOlVvIt2B9GyW15BTP3uB45dCbosoKyIIjCJKKIR69vqgsIGDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z4yghq0T; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z4yghq0T"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3139c0001b5so1650350a91.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 17:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600649; x=1750205449; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6JPxC6M/8C78oUmZk1MgMr9DeqlObfjqst+28w3sGNI=;
        b=Z4yghq0TX0vFTHKvNiX5LOY10vV98qyqaJsEwbE2fyEUmWKt98ztq+xRe9ItGaDFd+
         wF0+eBp6a+oRjrkgIoSuWU2VohqB+fWNajkuZWwegoM2JMUHY06tFLbIRxoTSHm95gFa
         1mhOO8oN/rUiFr7Zetj/hDkVt8I7fPr4T/PDFeZ03KtXTUbjWm8RUjIIBqR2Pqt2K8bo
         iHThoHfpb/HO1KYsIpZ9UjKfBqkey/N9eu5dXUJ3VTUR36OlnPVaShn1Q7iajxOzEpmI
         8ahnzhDkTVDxkYjJYWEoWt47EuqrB7e/5JNbQSzN76lNAcYDVAvgpxSRzjMVkxnCib4Z
         jJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600649; x=1750205449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6JPxC6M/8C78oUmZk1MgMr9DeqlObfjqst+28w3sGNI=;
        b=GzmcT4Y1XIHIee1rbWeup0JbeR2KpkKwqpwkkqMDh1Mys213Uoudnab6KEATvwJZzw
         yUWd714692Cybb/4rVGUoz6xoRyp5DRg/i8VgZZKpnqjxV/JXDE/DzoVsvGezKtt3Bp0
         iNWfjJbLTnpyWLVf3NYKLxSrpHIJEmXMBe1cvXFZ0i0zLbzI7Y/OHqK0+89Hi/e+uT6l
         dsuMI8HCFvT9bmCxFsQkaYC5wHP+twgtNa+WVY24qjbcR3kPrQbM+TPeNzLzkzU8mVsK
         zdjwqtoua4f7UvYH/43RBYTSZVWW1WMZ7zzqgDocyTRYfa3Lw1MA29vm6c0M2yJ0PZ6J
         /Wrw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ2I6+LGFpcDgM0fVI38DzvWMRxZKCnWcJ9qhLde5b5zZkNVWCxbSnYuFm2YSB99n3M2LEY9g=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy0pOrM+pNYjY3s1tH86b8XKxFzc/bDYQJ14/pzQW11KY2VW9/
	mIAIseDdj4WlVmjVoSpYRz5u3RtLFT2J6GEIuOlFccgmo9WLhsRgvJ47ZFPc902BszhepGt+t9T
	0JfcIRA==
X-Google-Smtp-Source: AGHT+IH8G3icYEi+L3rUhxMgi7kY7xVjk4t0ltvPAXoSgaLu6NXS+iOsy9Z0A/wrYNq1F2Q9c5lqhoRbAbQ=
X-Received: from pjbsm18.prod.google.com ([2002:a17:90b:2e52:b0:311:c7f9:ca1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52:b0:311:b0ec:1360
 with SMTP id 98e67ed59e1d1-313b1ff8de6mr923707a91.29.1749600648794; Tue, 10
 Jun 2025 17:10:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:36 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-3-seanjc@google.com>
Subject: [PATCH 2/8] KVM: arm64: Include KVM headers to get forward declarations
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 include/kvm/arm_arch_timer.h | 2 ++
 include/kvm/arm_pmu.h        | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 681cf0c8b9df..22cce6843e9a 100644
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
index 96754b51b411..baf028d19dfc 100644
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
2.50.0.rc0.642.g800a2b2222-goog

