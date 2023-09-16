Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBA2EA6
	for <kvmarm@lists.linux.dev>; Sat, 16 Sep 2023 00:31:55 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59bee08c13aso30185807b3.0
        for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 17:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824315; x=1695429115; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PzobvpQc4vWfR42iy4RjYEgAb/kHLuzC5INLwcS+RqY=;
        b=Vf/EUnWLofWvIRl/QIuZ5ro6+Qq7+G8fyun8Sn2MFFfIoadDtXp1oiBJqK80pp938d
         GAK9dw/f3TRhl0C7Mrt5ODf/KfFoMKtfala/LaMjT8JvAH9FwT4ZNtJ68i2LcsUfIccW
         aRHMTPszizgiFsWdEkCDJ9cOXwZdRTjraYUwJOGb6qnr/fxSeuU6mkBPLQPi5g61qamt
         fUx0gmbCFUEnmvSigAqwVw3TqQBoYsNkDb0NQa8r3MY55G+YkIqxXRBAfWyFUbEWHbpN
         inXadaXxRkUnKtMnl/xS9YR0NfhaT1CZ0i/oZ8r1GRCi/yv6Covrxc8tOMfmaDmkogop
         0s5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824315; x=1695429115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PzobvpQc4vWfR42iy4RjYEgAb/kHLuzC5INLwcS+RqY=;
        b=O9qZDmfB9bBd60wH7THwoLR9DmD0T9jdNUR9EOrHEjSW4zSsbkWvsVm9SQrBNnaOBe
         yrog5hgCAdJvDH3kaNjDlGc7pdmG3fPd5+oxnQh8+8bd2iE+1ItvI0WyPiPTxQ6silPo
         zO4vqBJidaJ4OIPSlX7X6ByIr0MiVMPVZnzWO03eK4EJmIXnmoH01V3teDCHystHop7S
         e83qJv4xOuUT9td6Tubo5HR7XerzT7U3f5K6USt7Z9/Csm52GQO89CH8PoDa3vUW8wsE
         U+5XE5pSPOCsfrys0qyJnEdrUVILnK0Am6NPswhutKgkqf1hHc0AoI5whWvrBjakrLhY
         uVRg==
X-Gm-Message-State: AOJu0Yynax/RsgF8WydpfzxxDjyFrLVYUt5laLCCcg0YYIudyui0IoHX
	w5h6B3kb+14BeST43OVf7VaavlobKp8=
X-Google-Smtp-Source: AGHT+IEHyBaVn0yDFSDy5XyxKJ2PGYyocUtrZpuSTqYnDVflp7SqStNr9ZpB4/OYXqxtlzASuEez5Ye4vGU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2e06:0:b0:d77:fb4e:d85e with SMTP id
 u6-20020a252e06000000b00d77fb4ed85emr78448ybu.6.1694824314795; Fri, 15 Sep
 2023 17:31:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 15 Sep 2023 17:31:09 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-18-seanjc@google.com>
Subject: [PATCH 17/26] KVM: PPC: Stop adding virt/kvm to the arch include path
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

Don't add virt/kvm to KVM PPC's include path, the headers in virt/kvm are
intended to be used only by other code in virt/kvm, i.e. are "private" to
the core KVM code.  It's not clear that PPC *ever* included a header from
virt/kvm, i.e. odds are good the "-Ivirt/kvm" was copied from a different
architecture's Makefile when PPC support was first added.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 5319d889b184..08a0e53d58c7 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -3,7 +3,7 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
+ccflags-y := -Iarch/powerpc/kvm
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-- 
2.42.0.459.ge4e396fd5e-goog

