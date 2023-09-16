Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FBFA47
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:46 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1c08a15fcf4so25899555ad.3
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824306; x=1695429106; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HQNUEYOJ/ozgdrFnqx+YRCy2I1exOHPHuH58RF8SFNA=;
        b=Zi9UNSb/vtygTqFN4OqUC+EkWVCsitGAWqWsvPMy9rI9pyDdY9iLt42jzOQCGo0lDP
         ldoCZQLjYOFEe0X9veT8VjseWIAbGvYMjFRYF0cg9RH9Wl8oiqrHgC5+AGDQJnnvDWC0
         2HyO0pMDXQRujbAZLssuJgPi00tTs19NGkTdhPGqUpxtbu1kOWXs8fWUDJGoLWoPLR0P
         bUQVLJ54OcjjsUkN+RprdOEpObh6+rE6/GV4knr4l4XKc1M6NX9mZtDMb4RLhCIOPle8
         WPmgvu/Vvs8JHdYoC6VKcBccXyUOg+BUa/rnrkwVAnlkE6Hudiv5KZV2cG8gqnslyJUQ
         6y0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824306; x=1695429106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQNUEYOJ/ozgdrFnqx+YRCy2I1exOHPHuH58RF8SFNA=;
        b=aXEeJLl+kmezy0bXBGcY1TACPJR6vv5aVvINOzRL6xpsI/ro31apIeU/JJA4ry/F7L
         fvolE3PAaL/0c4/RdX86sA4gHZKUqPnd3YpDd+2laxwrG4HjfTk/Zy3T0981SCegoboN
         yCOYqlNYS4ayIq96A57pa4o1D9t/3rvwD1VKsax3hYfmZO6Wuvv22SGGZkwl1hHXpebG
         FPkx7qTfgHO+Bn0gILf+4kG3PHjR1gT1FO4doyYgeQbeuz/FLzne/sG5HCA/yMEPKTAV
         yNC0DMnox9DK9G8MzectVq0Lyo7IkpmYGPh/twT88EmIKrrIzQqZX1LUfALjM5jqunc3
         luEg==
X-Gm-Message-State: AOJu0YzgwlPKT+KHEoA4eDgPVEdK7L/E+ngYuQx8MkAYmlQ2argUOzRG
	9Gp0joIaofRLdo3ywiW0EF5v/VVW3QE=
X-Google-Smtp-Source: AGHT+IHwZjKrwGdEWszMvnFwhRAkOaZ4ZXt/sllxoteViYwmhz1Ar6ouDJgF8x4FFhszG2C3n1vTw2Lw6BE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32ca:b0:1b8:8c7:31e6 with SMTP id
 i10-20020a17090332ca00b001b808c731e6mr93755plr.1.1694824306427; Fri, 15 Sep
 2023 17:31:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:05 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-14-seanjc@google.com>
Subject: [PATCH 13/26] KVM: arm64: Include KVM headers to get forward declarations
From: Sean Christopherson <seanjc@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tony Krowiak <akrowiak@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Jason Herne <jjherne@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Andy Lutomirski <luto@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>, 
	Andrew Thornton <andrewth@google.com>
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
index bb3cb005873e..e22a15c66288 100644
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
index 31029f4f7be8..e80f1d090579 100644
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
2.42.0.459.ge4e396fd5e-goog

