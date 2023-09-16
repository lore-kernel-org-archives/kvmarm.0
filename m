Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347E8A2A
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:39 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-cf4cb742715so3251783276.2
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824298; x=1695429098; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OjnVLG9a9LJLqorH8Rj1ZnrY26noTE5ZeEoscx0wCrE=;
        b=uLCsFA9q8FXyfKoZxa6n0MNURM9M9kJSl18QCDq/BuAtYFyr/lmgUb8geYll2P8m9B
         ANOXEx6Bxy4uBZqLTJ8/Yw389k8zdoj86E5Khqd8/NeRKpCFR1i04vzzehZGrF3afd38
         0cxMtryqRDNKY9o1MAQ7DltqtbR5dcldS24KYN0+hNAoOCRVPLSNUa38a8McAzgsZtcP
         mTTMggPNbdbu6uFiJdlxyNM7nj02ClPoqQVedJwN9Qn+S4YFA5Ou9v758zItNceFwswW
         FWpqTk1rVnYPGUCtgB7r4k0HPn5mqF8Dkp9SnfjbqXdFEFmmAdfiX8f+0f3ZKzunsZD6
         fXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824298; x=1695429098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OjnVLG9a9LJLqorH8Rj1ZnrY26noTE5ZeEoscx0wCrE=;
        b=NB3iSkG7crR3JBQhClfL/6DbWKQZk1cuI3LxnbmyystOGwwHtgFfGQCHHpMvDrXq8U
         1bP0iML74BDOnJVfJ5D68CmlWPkbTuxKZFEvpzUDyffdXeh6xyQXZt488pBzxfIxg3AW
         DQxYllcNJjbgKLH4L+w598MguEnG2krK/2yrMoPUn32/gFKtw7p6cXEJLfuGHkQYzrgG
         GXObmANnZy5pwehux7NwY/DxHp/Ya3p/rvyyKnyX9Y/8uEqWnb8u6RvhjJulR5dpDiwv
         3ngv24dQg5U2M+2A09BS0qrNbOJvCaSaVzCFnKjTiwYwtFUP5tiPs8N18B1jxVfMEZDh
         jrZw==
X-Gm-Message-State: AOJu0Yx+M2B9eoO1Zp0kqUCXwq2s5XeBoJlbbzzdZcOc2gcvC1sKVNFJ
	mj7gm4WIN/9/buezLTrve7DGwj+8fS0=
X-Google-Smtp-Source: AGHT+IEejUplN0yThqJglSyf2PAl899GMvDcyB4OaKD9HL7AL2P8QSuIFDWAjhltJc72cwzADimsWD5lopA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:138e:b0:d78:245a:aac4 with SMTP id
 x14-20020a056902138e00b00d78245aaac4mr82623ybu.1.1694824298283; Fri, 15 Sep
 2023 17:31:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:01 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-10-seanjc@google.com>
Subject: [PATCH 09/26] KVM: arm64: Stop selecting and depending on HAVE_KVM
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

Now that nothing in arm64 or architecture agnostic code consumes HAVE_KVM,
stop selecting it in arm64.  This is one of several steps towards deleting
HAVE_KVM from the common KVM Kconfig.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/Kconfig     | 1 -
 arch/arm64/kvm/Kconfig | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b10515c0200b..7d99f132e57c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -214,7 +214,6 @@ config ARM64
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
-	select HAVE_KVM
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PERF_EVENTS
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 2b5c332f157d..c76af1973315 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 
 menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
-- 
2.42.0.459.ge4e396fd5e-goog

