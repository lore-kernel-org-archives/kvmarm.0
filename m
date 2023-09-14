Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D6EA53
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:56:14 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-58fb8933e18so6410667b3.3
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656573; x=1695261373; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TEdWNzKShragyniQ9J+Ve2p49++UXy1fA45JB0RVd2M=;
        b=Pwlyr5dd4O0Xv5SDFal5+v/mlomLrgZUHUEV+cboAJDci3BJW0JUeC+a3P/ZfV8doY
         GXo/aoJ6D+l8mxmKpxEE8BzxXaR4gIjhw28pv/qenNrLwLvUFOFMhHaT6ABzJp4pLEnn
         GFhm1+f4VweWNvUod1kwzv6k4kSjucFSzVKg5ob9H2TjaT9/d8tJVgF5EKkJC6HYlDcB
         EqrFzRhyVzJPhJWUjnlbXCpoEho5Aq2p0CSZahzvqK5LM0j6nGmJUyY2DGmTYCyZhPk1
         S125XsbNVDzXs6Z5osDpXBvX3KSkMyd/d9oWRAmnpRVv6wouFTGsxIULkjoumCDJv+6f
         1stQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656573; x=1695261373;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TEdWNzKShragyniQ9J+Ve2p49++UXy1fA45JB0RVd2M=;
        b=MVwmbot9RqVxEPScF1VBLMFQz7t0tV22pg1auK5LJOXFZSbRbu6cf51ytRm4fY+8hO
         DUE1j8LRXVf5gMDs5HAvrq3W/eR87P3D9jBF+8y1nkGs/UWsExXOQA5Ua7IiJHjCp4Xm
         oXHDuQLynFudMhn+tC0061/A7P6Jx4wG+Tb/rLfDiTPxvDExIvrbjg5Y0ucKDNa3efM2
         cQci5KBPl6IkHaI6rgHvjHe/WcG3SevmFTdJngMP/meeapNV1FymHtVA5M00+XYXe91k
         2jH8H4akVDDLH1W/jEt8Lqn8sscW/zNFayyG3Hog/okIY4v8w8maJFLKdlSMCtpOBUfg
         kJ/Q==
X-Gm-Message-State: AOJu0Ywz/pZvWfHcpSptc5kVVYMypny4Vw2zJ8y36e6BgF6YdGL21uXH
	ydLEWLk5yxl/vlMMXxESsm5EXu50qUA=
X-Google-Smtp-Source: AGHT+IGYm//r9vLVsRhCBexYLsW+kyUM6dthNH5+IPZo7SQZB/dk4at291uiQmKPgon5iad9USRf5MgW9tA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:400c:0:b0:589:a855:7af with SMTP id
 l12-20020a81400c000000b00589a85507afmr107415ywn.7.1694656573483; Wed, 13 Sep
 2023 18:56:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Sep 2023 18:55:17 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-20-seanjc@google.com>
Subject: [RFC PATCH v12 19/33] KVM: Drop superfluous __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 macro
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

Drop __KVM_VCPU_MULTIPLE_ADDRESS_SPACE and instead check the value of
KVM_ADDRESS_SPACE_NUM.

No functional change intended.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 include/linux/kvm_host.h        | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 91a28ddf7cfd..78d641056ec5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2126,7 +2126,6 @@ enum {
 #define HF_SMM_MASK		(1 << 1)
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
-# define __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
 # define KVM_ADDRESS_SPACE_NUM 2
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18d8f02a99a3..aea1b4306129 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -692,7 +692,7 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm);
 #define KVM_MEM_SLOTS_NUM SHRT_MAX
 #define KVM_USER_MEM_SLOTS (KVM_MEM_SLOTS_NUM - KVM_INTERNAL_MEM_SLOTS)
 
-#ifndef __KVM_VCPU_MULTIPLE_ADDRESS_SPACE
+#if KVM_ADDRESS_SPACE_NUM == 1
 static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.42.0.283.g2d96d420d3-goog

