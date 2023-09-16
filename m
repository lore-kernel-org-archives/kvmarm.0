Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCD6EA6
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:59 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bf6e47b5efso25507825ad.2
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824318; x=1695429118; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I1k7UlFLK1e3KB496SGnrZE1fwTPdTtkvkYnZUVfXtU=;
        b=Xqmna6J9N6WkXwHforOyOGco7kHycuxs4A9CfRaL7MeOaJoihY6XEJ1A78y8CG0LzR
         JwvJw0AEw1k1tBpuOF7hoWJ2TtqiizHQ0PIyOjnS+G+nxHaGMNLzidI3SHYwmU80Ap7l
         qrHsnbx/VD9Fc+0REf+nr4UJGRfe/j1rPQdiU2qSB1wA6/2SyQUTR+l1ANTbX3phbcbk
         CHpcsAk4Qd+uifiCOa10rCmUliRmsf2xTK7Pox6OhQoiAz4//KYR/7Rhy3HAiQwSi6Pg
         tCjFoaFnpjt8RxyPkJ2c9pBmkn+LCdIlBrV/Zxcer7JRQEbvWnqUOCPSyzJW/u5nlGvi
         jBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824318; x=1695429118;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I1k7UlFLK1e3KB496SGnrZE1fwTPdTtkvkYnZUVfXtU=;
        b=OUCrD6S4COO5jgBM8NLnfKRzQzblRCY5XbGYRoLisnNUpSAJK59H2hNqcwz1fFu5AT
         38oAOEx20XWBYck7LqHe0H4TvXl2d2Sv6eBUP8SyUPGjOkeAqwpORQADxJzP3CBx+MvM
         YF0mhDMS1zr+G1srMmp0Fen8BxbR3N3FDXzQ9rbVcIX+EdRuYzezjAQ7125DX+//1JLT
         ULu835f31mlRH2DFz/+9/WXqENEtwLqSptxl2//5+kA7SZNzC8tOn12ntuP4f8uG1Z6Q
         kcOs2s3mQqy+w7iYzIhJ7P8OLo12Kc8DQdEq2GQxDNPq3J60w9I9EqnXRvI4W+0uN67M
         uIGg==
X-Gm-Message-State: AOJu0YxMTZ334MRJOBxaRYVopJFDj+B0cn7o4XkYMk4dHovXj0tEZcWr
	dtDCaeHaQP+2LZBWOIDTm1+bIQpo6+A=
X-Google-Smtp-Source: AGHT+IFCF5MUMD869yhPhgA85k1sz5CoJq/QTd908FyvX67dvIc3xBcuRDs8mX3N7g5mT6MCs9yGRfwK12c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec8b:b0:1bf:cc5:7b53 with SMTP id
 x11-20020a170902ec8b00b001bf0cc57b53mr68748plg.1.1694824318653; Fri, 15 Sep
 2023 17:31:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:11 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-20-seanjc@google.com>
Subject: [PATCH 19/26] KVM: Standardize include paths across all architectures
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

Standardize KVM's include paths across all architectures by declaring
the KVM-specific includes in the common Makefile.kvm.  Having common KVM
"own" the included paths reduces the temptation to unnecessarily add
virt/kvm to arch include paths, and conversely if allowing arch code to
grab headers from virt/kvm becomes desirable, virt/kvm can be added to
all architecture's include path with a single line update.

Having the common KVM makefile append to ccflags also provides a
convenient location to append other things, e.g. KVM-specific #defines.

Note, this changes the behavior of s390 and PPC, as s390 and PPC
previously overwrote ccflags-y instead of adding on.  There is no evidence
that overwriting ccflags-y was necessary or even deliberate, as both s390
and PPC switched to the overwrite behavior without so much as a passing
mention when EXTRA_CFLAGS was replaced with ccflags-y (commit c73028a02887
("s390: change to new flag variable") and commit 4108d9ba9091
("powerpc/Makefiles: Change to new flag variables")).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/Makefile   | 2 --
 arch/mips/kvm/Makefile    | 2 --
 arch/powerpc/kvm/Makefile | 2 --
 arch/riscv/kvm/Makefile   | 2 --
 arch/s390/kvm/Makefile    | 2 --
 arch/x86/kvm/Makefile     | 1 -
 virt/kvm/Makefile.kvm     | 2 ++
 7 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index c0c050e53157..3996489baeef 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -3,8 +3,6 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-ccflags-y += -I $(srctree)/$(src)
-
 include $(srctree)/virt/kvm/Makefile.kvm
 
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 96a7cd21b140..d198e1addea7 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -4,8 +4,6 @@
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-ccflags-y += -Iarch/mips/kvm
-
 kvm-$(CONFIG_CPU_HAS_MSA) += msa.o
 
 kvm-y +=    mips.o emulate.o entry.o \
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 08a0e53d58c7..d6c6678ddf65 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -3,8 +3,6 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-ccflags-y := -Iarch/powerpc/kvm
-
 include $(srctree)/virt/kvm/Makefile.kvm
 
 common-objs-y += powerpc.o emulate_loadstore.o
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 4c2067fc59fc..ff7d5f67e229 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -3,8 +3,6 @@
 # Makefile for RISC-V KVM support
 #
 
-ccflags-y += -I $(srctree)/$(src)
-
 include $(srctree)/virt/kvm/Makefile.kvm
 
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index f17249ab2a72..f8153189e003 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -5,8 +5,6 @@
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-ccflags-y := -Iarch/s390/kvm
-
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..d13f1a7b7b3d 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
-ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 ifeq ($(CONFIG_FRAME_POINTER),y)
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 29373b59d89a..e85079ad245d 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -3,6 +3,8 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
+ccflags-y += -I$(srctree)/$(src)
+
 KVM ?= ../../../virt/kvm
 
 kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
-- 
2.42.0.459.ge4e396fd5e-goog

