Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71C0A47
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:43 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d8141d6fbe3so3253523276.3
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824302; x=1695429102; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=11iXbA6RA96N2ihdzvT9DOzykVF8TPNgieg32BOfaCo=;
        b=qq/ex2tnH+J639m204mezpUlCRql/sUW6YFq9oxL0qIt1Fz7g58GXBVfybVqvjnV15
         i2l2Js+uxuFYZlR73MC69MDUCy76dXDuHR0sGEh22+Cv6vEbwMeumUiUb+edKFQdznkn
         uV/tkRXKL3EYkHXZWRm892OT+F0pxeljSc3zNDB/CQGG1IaT4DiDgw3AS/qFG94b/ZK0
         XRLHjaW1jLoEtK0hjIJ8U5E/PHT0TSUxGJXjpwRfr4ZZbjVuWORwzm9Ou+n1+O4edj/1
         at7gKZU1RzWC3qtDPmBRE2HX2R6mYgnDoUiylnuh4Zye2ZeZc6gN7UZJtM2YjHlgdhaJ
         hgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824302; x=1695429102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=11iXbA6RA96N2ihdzvT9DOzykVF8TPNgieg32BOfaCo=;
        b=BnRnYZ4W53FEy3bAv5wCEusRmW2oMnlmJyjhKuDZLgk2LOHJSLdeTSgM2bw+jxgAOV
         IvTzffvbDs6EpyQy5EMqvDCIjResSJpZoAEmbrU7zjisbfb13g1k019vryeX0egvk7Vl
         Pj0mHdtnoqxOQgWqyqTOh5oVDl0sRwBZRaQgTGpg2oMvOzCXtOA+6nxKFIX58QoSMbAW
         HpY8fvzo5uoUqFx3vUMJUNALm5sMf1Buf4QiDh5fHjI8UlC/SiMfQhNSvLhiJagOyYYN
         qFSYfJHBDA56y03y3zlcagua1H0CG26gWLqx5va61b+4MiPq20N4ALfVqOobfD8d9+k7
         Qv4Q==
X-Gm-Message-State: AOJu0Yx5MpNjcnD2m9vknq5aRSkzIn1SxgflOFWALQV2fLjbWSZmnuUI
	k78N+IS2WNgfNl31RH5zjnj0Wjdi8RE=
X-Google-Smtp-Source: AGHT+IEXzBZMjfoz19MMDpz0z/mfp5J4Xc54+oTqT/y9sTC3/YRTAU+NLkJhdnChwcXUDWkKwhep1BL4HMg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:138e:b0:d78:245a:aac4 with SMTP id
 x14-20020a056902138e00b00d78245aaac4mr82625ybu.1.1694824302614; Fri, 15 Sep
 2023 17:31:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:03 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-12-seanjc@google.com>
Subject: [PATCH 11/26] KVM: MIPS: Make HAVE_KVM a MIPS-only Kconfig
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

Now that MIPS is the sole remaining user of HAVE_KVM, make HAVE_KVM a
MIPS-only Kconfig.  Because most architectures unconditionally support
virtualization, advertising to the kernel at-large that an arch has KVM
just led to a bunch of useless and misguided #ifdefs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/Kconfig | 3 +++
 virt/kvm/Kconfig      | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index a8cdba75f98d..c4508f49caae 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -4,6 +4,9 @@
 #
 source "virt/kvm/Kconfig"
 
+config HAVE_KVM
+       bool
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	help
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index f0be3b55cea6..f7bb6c59658e 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -1,9 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # KVM common configuration items and defaults
 
-config HAVE_KVM
-       bool
-
 config HAVE_KVM_PFNCACHE
        bool
 
-- 
2.42.0.459.ge4e396fd5e-goog

