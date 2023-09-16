Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20436EA6
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:53 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d81e9981ff4so1098861276.3
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824313; x=1695429113; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pl7bBxxWVXjTf9iTQwKV6iNN5dTCLVhIVjlh92R6IC4=;
        b=xWntFzxpOn56PVzBp8iDDaYaEyExV0IWqE205QaaHKMLDKYs02FywQip+2b3rCfHJh
         0DMr3U33lXsdhJr78cLRQhjcupLpphyemE1+UnoTTxFZ0IICuHIygpSC7OLhF7FjtGGm
         M+PkmMX6+O0Jny4pd5mKzul/fcwycXCcOn/eGmFpiuX8Vy+cj0C/YJ0/QxeWJEOCQm6J
         6Yy9nII5m4VUteiAn5pgoDVNtVpcCchFozm0yjn/Ex7Yxr4GYm7646vRUpSX1aqH+vMg
         1lAHd5u/QLWKsczZnHDUCwTnwGGKCHYkyQUbVjsO+o733+VhuqRt82t8t46Y/amPiFD/
         ld5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824313; x=1695429113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pl7bBxxWVXjTf9iTQwKV6iNN5dTCLVhIVjlh92R6IC4=;
        b=WsDlpA/K5VKk2+eF4EBgZaWGwoSU6SSdd7MdEzkFU9g58d6bmyK6X5sxKUUL5ZNXPz
         KkkX47nsWVTVcCcz7LcZo4wr/WAlP+QXjeg6821IDR22OtRzaFXcS+nSNlOBsyzhp8iq
         xYCHKAGTSjMBWnh7NdbyjpW1USeJ7ezwmGWekoNF1/w3VZw3KCJwsweS8HsbqiLc6e5T
         38SEKrdJ8PPa/UXfEAjJN91ot+/BsGhkmtH+hZIK/pUZuTAy5vIoddVvJlmA2UFJ2kH4
         fmwwbTV1epE41VkmPw4jT5r6yHtceaNvJ5uZQZooJlQQ662DZvJEiWmqXO3sSjAs4ehQ
         anaQ==
X-Gm-Message-State: AOJu0YxzCKPD4yDUaSL5EIQE2kZMx+Hvxw10G5USg9CA8fV9AwxgjKBv
	xY/pzRETeiGjjo2wHm/2GLjG0uSp6X0=
X-Google-Smtp-Source: AGHT+IHIEoJ5Qp0cT7058FSDnFlcgu0NfKZ+k2cnwo0UQE0i+ifeNt8ssvIZEJlieWuqLdMggeWcLX6T9W4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4cf:b0:d7b:92d7:5629 with SMTP id
 v15-20020a05690204cf00b00d7b92d75629mr82335ybs.8.1694824312956; Fri, 15 Sep
 2023 17:31:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:08 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-17-seanjc@google.com>
Subject: [PATCH 16/26] KVM: MIPS: Stop adding virt/kvm to the arch include path
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

Don't add virt/kvm to KVM MIPS' include path, the headers in virt/kvm are
intended to be used only by other code in virt/kvm, i.e. are "private" to
the core KVM code.  It's not clear that MIPS *ever* included a header from
virt/kvm, i.e. odds are good the "-Ivirt/kvm" was copied from a different
architecture's Makefile when MIPS support was first added.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 805aeea2166e..96a7cd21b140 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -4,7 +4,7 @@
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-ccflags-y += -Ivirt/kvm -Iarch/mips/kvm
+ccflags-y += -Iarch/mips/kvm
 
 kvm-$(CONFIG_CPU_HAS_MSA) += msa.o
 
-- 
2.42.0.459.ge4e396fd5e-goog

