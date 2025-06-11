Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B06F189912
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 00:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600661; cv=none; b=AsV3N8mLYYn8PfxXylxLSsLO+cEx3a7Aksiym3F5TFoG6BGkPHkQBgwE5Y8h3pxSZK7hvG/3uiZiQPf5+CfHcUZE5nhpPPPyPAkSjp4R2LVaGSXV8V5/Q3j7nQFiO+0kajmW+wcYYCGRCyRi9Wy+aQQVcC0MeFgkbMwzAYtdirQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600661; c=relaxed/simple;
	bh=AcY3H8bGfIWZWHawREnW4VSuG2ZvHv2SK1gbpEk3yi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AwaRFHcGcP0VEwfTso6bDXgIc6I1G7+L/Nb7thrChf05V992yjbkpvSm6x8oCtVCY/fQkaSgpM+vro5jxDSJD0f4twBSsxCiq7bXK4tgRT/ZIn3y5vzwF8Qq2U3/aWdypmJjPWGxeFRy8My+D08z5C3xjZx/1rGPPIojl5KTfcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mIjnNA1Y; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mIjnNA1Y"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742d077bdfaso8443482b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 17:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600659; x=1750205459; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=t+Mj+r8r7UAjF4+0LNUZhsvI8NJHwfinPsCt24LIifo=;
        b=mIjnNA1Y5FlpFTil0r0Nxbsgb3syuAF/n1BmDCYd0CLcyajTqm1ZdBKuWDmQ0ttAtm
         Qy8l6z3nuJz85roHZ0s9uDmx4NQ0tWSMG7tG98tMqiavCQlWMJ32QWaEpeAjcLhfN0zX
         WIwKSdRxHSCV8u87G7jh6Djcq+Oe769S4mvl6blJ4FFI5E68ZvKjahRVl0GLhMRCvwBu
         N0IbCi8b0aKkquu3Z2spYJt/ck8aUtYwQOr0yrfLZi8KxgwDNzdN0I5b7BvtcfBDVREl
         /iPVt5jhROBN62aNAQstFtS9aSLn+IZeOiUi8fyjmhuqhU0SEKLBHtj13JZZl3Tm6oIO
         xMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600659; x=1750205459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t+Mj+r8r7UAjF4+0LNUZhsvI8NJHwfinPsCt24LIifo=;
        b=Tx5FSRYiqO+mdZeJm+sIMgAm2CgSrNhLdadjOQaPAJUHRXDooFxsBi8JKXM0HMaZLj
         OsYThre9b5+nOIcEWH14DsVie7vEkyYX90I4QUsISXk/RX0WCZfmJFRPP/adQS1Exeb3
         un+kxWbRJCTc/rvXx+FZeQStROhgHaCE1+zRJNH/D+4akig4ZH3JccN06ncwfKJwVwIa
         aGOKQHH3IOwwPu5ICXoiN/8woWwJHx/sW8KnDX9XThuwA92G8V61vOmSG4zluDwVwGv9
         0WgifR37mGVrgDkq9Z7BSruMAyR2khNQgVIi04pHs803ENESSXoG04tXXMJ1CSN2FilU
         5aSg==
X-Forwarded-Encrypted: i=1; AJvYcCW+S+iTbUMCBNaJosGhdR8952fTPgDAXAVVnZmCGyEN/YnEsjWz/+155cHO3UEaKpq/u+s/ALI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/MNB8TMyH7xZ/A+S/oq9UwEMqLb/fWUpinuQ2LosFeFin2Cmm
	alQ/LHT/e9sSXehDMkg9xLsMS5IF2xhuch+RFBdqy3rmIq3shrWfP7YQxAeBs809EhZpXD7lSmD
	4dSHyAQ==
X-Google-Smtp-Source: AGHT+IHdKstC+XlYUus8Wdm0HR7HPxHMBlUy5ahB8xm3L+Y1hmecIZTBPJ5vhN4Gi0qdwz1eVbXtQ9xfH68=
X-Received: from pgam16.prod.google.com ([2002:a05:6a02:2b50:b0:b2f:6348:f715])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9012:b0:1f5:8f7f:8f19
 with SMTP id adf61e73a8af0-21f8663f76dmr1960513637.10.1749600659002; Tue, 10
 Jun 2025 17:10:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:42 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-9-seanjc@google.com>
Subject: [PATCH 8/8] KVM: Standardize include paths across all architectures
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

Acked-by: Anup Patel <anup@brainfault.org>
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
index 7c329e01c557..86035b311269 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -3,8 +3,6 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-ccflags-y += -I $(src)
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
index 1a575db2666e..6f12edd465df 100644
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
index 4e0bba91d284..dbe61a398cc8 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -3,8 +3,6 @@
 # Makefile for RISC-V KVM support
 #
 
-ccflags-y += -I $(src)
-
 include $(srctree)/virt/kvm/Makefile.kvm
 
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index b742e08c036b..5cbcaa7f241a 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -5,8 +5,6 @@
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-ccflags-y := -Iarch/s390/kvm
-
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index a5d362c7b504..f78f11b582d2 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
-ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 include $(srctree)/virt/kvm/Makefile.kvm
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 724c89af78af..0e7ba49026fc 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -3,6 +3,8 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
+ccflags-y += -I$(src)
+
 KVM ?= ../../../virt/kvm
 
 kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
-- 
2.50.0.rc0.642.g800a2b2222-goog

