Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6B73C09F
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W36BX7mN"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1cc252cbde2so6358815ad.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430955; x=1699035755; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JgU06SXMv6nm3bYLetCIh2Atkw0AeiFtLr3TWBcGDvg=;
        b=W36BX7mNJaIsipPjytPOSR1PVgG3v8CA/9af9h7Ska8Kh5HywaBWc5KJOf2gKbJqsj
         RWqiz+L2Mh/XJH62RgJ0jliOHJUelELJ5L5OcZt62M7IUKJg6GN31AfpXz9Es1XiHybo
         7suhDARsU2dEJ5k1ZWtSD7F7jEN3Kzq6nd+7iKJ10yaKtkiulpHatsVpbUctE5MG6vPE
         TEbNeYeMzTralIwVcLn5tjMge5WGWQXlLZD+uYiWqbY9wXTiJf/p01rwBStDlyb+GY5+
         G4S4fE2vR7tuwCtn5p1TYAuZSZ1a9iyA9FXKZyK1SgHz6TPgh0rEyMNljf8TfsQ7ASUL
         Wyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430955; x=1699035755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JgU06SXMv6nm3bYLetCIh2Atkw0AeiFtLr3TWBcGDvg=;
        b=wyDjlFsDUHqumt+1uTaHCx9hUpFqTuHC4jHlq1bWgomuQ1J0YfT7rHTeipy7caCrNa
         +8jtMJQodn2LccNAkuU9CaRH9lsZP1n0mv14XnjDy+SRe1Lfju9V6OgEYM7ahSOnfnUE
         gZCWBdU3ovf4QT8ObmcqbktQRw+3wdjtxnb+ZtlMSYuskdqxothGpb7AoEImYU6z25PW
         kO8NtrNa9ZIY0Fh+IREREH9LgrlCDoDquQh84DRLGJpgPMJlB3UH8dhRob6I2QCX0GBZ
         6wi74R2NWPMG0NAqJjMokhBGmDR7P3d156O3ehQtjR0h+Ch5ooh6th3dWLXDCmISxio4
         ZAhw==
X-Gm-Message-State: AOJu0YzMMyL7mcp+vGZAaHFP3QUx+S37/F++ZLXfNx7NwzJJ9PYWc8R6
	VEGlFWYLEajRi2K7Gr7tvEzHbaV90mY=
X-Google-Smtp-Source: AGHT+IGtvUvxtvF0vLnhcz0wuwQy/3Gylfgr5sP9pToido+ZyPcnNi9qskOerQDKma1HuMTn89KXKiciq2s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c144:b0:1cc:281a:8463 with SMTP id
 4-20020a170902c14400b001cc281a8463mr32525plj.7.1698430955693; Fri, 27 Oct
 2023 11:22:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 27 Oct 2023 11:21:47 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-6-seanjc@google.com>
Subject: [PATCH v13 05/35] KVM: PPC: Drop dead code related to KVM_ARCH_WANT_MMU_NOTIFIER
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
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
2.42.0.820.g83a721a137-goog

