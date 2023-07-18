Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C294717AC3
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 23:48:39 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1b8af49a5d2so48846455ad.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724119; x=1692316119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WUfCrqcqzPgtS1UwKv933k1oCAb1hY7UF4nDFC6XfxY=;
        b=kxtMkPfBzSrDgFwiM6lTbnnV1ORifom1wTCX0JDc2o8v5mvJbgd+eW3FzBholZ+QF/
         ZB/tw1vxVtp6lnWfOuYWDBnkA/zcHKeYCxsNI4yLGBDWisxt2V2CGW6+/c9nKHHqWO0Z
         pwjXyxzIVoB/8QMRAPYJ2ESVagoDqveLkahmzeblrfSHi+C7b/LSvjVeGXXFBmG27xpW
         46+iHLUL/iDL1W1dNobEnmnSwB6oZXJ54GsRbQDHUEuzlNSG0pgY2rC5/BfRYynN9jnl
         9GH+3FZfZFTDU0qQSnRrsV2OdAHlQuwXUaGl7W047p5QIleFQWR+9FWJ+QSsSRbSbDcH
         Ypxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724119; x=1692316119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WUfCrqcqzPgtS1UwKv933k1oCAb1hY7UF4nDFC6XfxY=;
        b=O5UdbJXUixVpfKf4pKPZwXhl5rNl0neohSKrFULEBfodv3k0iZU5P0uknHF7a8WWvr
         xHeH4lg4WH7Z8EKtaCKs6lbu3ugmI/Bp4axReCc6rSn79AEfweRvX4X1CHNfxbg1+BcQ
         MYWtrS6n1JHp3CjGlwCJ2AoYAK/QSOPiknag5cCDMB8/KD/bd7uI9ibGFjdTq5hYe8wd
         l1k5Wj18dtdAH3/SHZLxxvnvPnMxssb6FhuMwBK7iW/f7JuHMrbPubVwz3M6A0/vc6AQ
         Z4WpxbG/4fLTyMcZ4Btbtd5tLjAKhuExo376qWWnE//o3RxfSWXvNaUBKQ3B5CN6/xiH
         ILsg==
X-Gm-Message-State: ABy/qLaFtIhWfMpIplEm2pZY2WNANDhy6JwCnwjtOJlLIOHRxD/ouf2I
	IED1IN3z/sBZGs+igrezvaSbaMObjtY=
X-Google-Smtp-Source: APBJJlEMcu/rfMRBwbQ2zq+ymY4hD2c5F3AYtj0FSwyildZO2Oo0gOzBKGYbg9jbJCtpjTvhx4PmM9/8MPA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f546:b0:1b8:a552:c8c9 with SMTP id
 h6-20020a170902f54600b001b8a552c8c9mr7279plf.13.1689724119324; Tue, 18 Jul
 2023 16:48:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Jul 2023 16:44:47 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-5-seanjc@google.com>
Subject: [RFC PATCH v11 04/29] KVM: PPC: Drop dead code related to KVM_ARCH_WANT_MMU_NOTIFIER
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
	Yu Zhang <yu.c.zhang@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/powerpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7197c8256668..5cf9e5e3112a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -634,10 +634,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYNC_MMU:
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 		r = hv_enabled;
-#elif defined(KVM_ARCH_WANT_MMU_NOTIFIER)
-		r = 1;
 #else
-		r = 0;
+#ifndef KVM_ARCH_WANT_MMU_NOTIFIER
+		BUILD_BUG();
+#endif
+		r = 1;
 #endif
 		break;
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-- 
2.41.0.255.g8b1d071c50-goog

