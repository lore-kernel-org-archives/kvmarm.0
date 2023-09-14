Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C589186E
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:55:42 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-58fc448ee4fso6046797b3.2
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656542; x=1695261342; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ipMZPiP5QxzJYr8+L2XHaFOQ2agfNk5lTTsPLIZe0Eo=;
        b=r9018dTeBRdLRLEc+Asy86Uoc7hGPF0nCXJe5898EL9zZfv5DtCoB8QvfrYUZrWffH
         slENGJUZYvu0+xz7trqM1+Dmv7kLq2Wf81pI70UFiMXPiyk1JfDZQ73/J+RVLlGhQrp1
         +7qnf5jtllu+Bt7Z1bHXkfcigGU6xxGYdYxLO6U3G5gy7JkvDsLuJrLHlL0tvKmirIjv
         6cgnqMjjvQ+TpluxK1Is6wVTXt/05HRhZ0o04IDoQ99eRyd6jZEGOugLc1647XNcIYT/
         MB0GIKmeFVHvmNrhSWJYC8YfDyggvFirkCoRl5vlu+Uuhmz/tY4GycV1EUABeKOxf1Ph
         ZmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656542; x=1695261342;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ipMZPiP5QxzJYr8+L2XHaFOQ2agfNk5lTTsPLIZe0Eo=;
        b=QuHTmAYemJjuFiOHd6cR+/Mp1UtwfYu2zYkia5aExPUcdwRIjyS3zaRilji4dorpMf
         lrJ7jWRKcoeIWYBPbkvTY50K3uWkXYgSN5BH96EDRv7C7NjwfeLB5XO1+xqjy8M8ZhYd
         M1QjxH+VCAaZUAivIJXyUzylUYEAQ3gaXH4f1x5HPLRDqFUHsjGZLe6LR3bBeqHb6HaA
         iGJRQuPPTfI5/E3ZavhYMFJroTSeoSf4en5bE6TKmbF/IcJZkYZPySoW5t0Exxk5nwB6
         JbmdmcxYtil+GS02DSU6c79DYLF81R6kPxll3x8pZWFXwgkV/yBvgTF+lZtHWDUx+Mlq
         4b9w==
X-Gm-Message-State: AOJu0YxDAYomk3CfvRx6ZayN/wxl+Oh7LCUughF9zi4w4Aer2+O+yZbv
	2vBYmakD1K5KzhG9vofDpndgVu1y5lU=
X-Google-Smtp-Source: AGHT+IHZ9maMkZbk/mDeS4QG3cCYdpuky8EXqvBvcYXtjkjg3bX1mPxWKIK7RZclMdxYQ1SdoMO1l2xcItw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:b0a:b0:59b:ebe0:9fd6 with SMTP id
 cj10-20020a05690c0b0a00b0059bebe09fd6mr14465ywb.6.1694656542028; Wed, 13 Sep
 2023 18:55:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Sep 2023 18:55:01 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-4-seanjc@google.com>
Subject: [RFC PATCH v12 03/33] KVM: PPC: Drop dead code related to KVM_ARCH_WANT_MMU_NOTIFIER
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Assert that both KVM_ARCH_WANT_MMU_NOTIFIER and CONFIG_MMU_NOTIFIER are
defined when KVM is enabled, and return '1' unconditionally for the
CONFIG_KVM_BOOK3S_HV_POSSIBLE=n path.  All flavors of PPC support for KVM
select MMU_NOTIFIER, and KVM_ARCH_WANT_MMU_NOTIFIER is unconditionally
defined by arch/powerpc/include/asm/kvm_host.h.

Effectively dropping use of KVM_ARCH_WANT_MMU_NOTIFIER will simplify a
future cleanup to turn KVM_ARCH_WANT_MMU_NOTIFIER into a Kconfig, i.e.
will allow combining all of the

  #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)

checks into a single

  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER

without having to worry about PPC's "bare" usage of
KVM_ARCH_WANT_MMU_NOTIFIER.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/powerpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7197c8256668..b0a512ede764 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -632,12 +632,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 #endif
 	case KVM_CAP_SYNC_MMU:
+#if !defined(CONFIG_MMU_NOTIFIER) || !defined(KVM_ARCH_WANT_MMU_NOTIFIER)
+		BUILD_BUG();
+#endif
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 		r = hv_enabled;
-#elif defined(KVM_ARCH_WANT_MMU_NOTIFIER)
-		r = 1;
 #else
-		r = 0;
+		r = 1;
 #endif
 		break;
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-- 
2.42.0.283.g2d96d420d3-goog

