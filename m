Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF911C38
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:55:56 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d81646fcf3eso627238276.0
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656556; x=1695261356; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3EzYMZ/N2FtmFuyogL5CZw7tscjDCoW1YPbolbcS4Zk=;
        b=PhaYxzKkEglqsraZnyskQqDuW5Ih2nzLLvR6UDrjbqdtCQEgrB/MT/YVJYtDI2oAIc
         C+eWB5lzHbPGFAICwnmhsy+5kCA9rEMFNrYFuE7Gc2xtf7VPn5bCCiEfpzSg78VG3hXf
         Sf8hOgOdttUA7jsgcm8op950MQT9ohJt21iX6gl5tzRWFw04SbOAj0iyD7HH+7YolviJ
         Ge+2PvL7evAD0yFXWso6195/F9rIadTOL4+oC+NsHsu0Fs3109HbfS48zSrC1dEpst/6
         CaS5S2ewvalAT0l9DpIaXv7MmKElcPNRxi4Wf1F/oMzKq9m03O1Dg0GNwwkaNo5TsGgu
         7bXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656556; x=1695261356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3EzYMZ/N2FtmFuyogL5CZw7tscjDCoW1YPbolbcS4Zk=;
        b=p61I8xvYTbjYhkCm0OlG85JECkiGvB2Yb3g3eWX5wLzxKy41svWnFWK5gte/w29Hzn
         NZKuOPmTYDmeaiwm+Ga3cQO9E5tihREePD79qgim8SXiEoa3C7SHzdEns0Ugs0/f8xHc
         7GXMTAMdzrX8sNVWzVdNceL2l/Zvx+/v5ri077J4mR4bHIhGhnxnIcNbLk05zt6Jj2tn
         ozb1jctXQQbKacYKFoSBtK09C12PplmdJyXRjS8OTaudo62dFT4yEugJ4wIRY94f8mpi
         hg4KpfTfglPOcfUYHJojd4bPKE3q+mcDU9bXeLiqjRFYZY/R/ighiOn0E5tqS4virZDr
         ZbrQ==
X-Gm-Message-State: AOJu0YxwEiXDfoK7nCcU575UXajTOf5w4ok22R15/0lkahVq5fjaYbmx
	OFvMLmpOd3TLPeAzYvgRdeCM+qWqt30=
X-Google-Smtp-Source: AGHT+IG4OY/vWo0x9F6MnIXrirdXq2cFaaYhe2gVdWc98bocPGMoKEXe9xVAJF1f8jZjRLg8FYPwelhBszM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad87:0:b0:d80:eb4:9ca with SMTP id
 z7-20020a25ad87000000b00d800eb409camr101075ybi.0.1694656555915; Wed, 13 Sep
 2023 18:55:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Sep 2023 18:55:08 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-11-seanjc@google.com>
Subject: [RFC PATCH v12 10/33] KVM: Set the stage for handling only shared
 mappings in mmu_notifier events
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

Add flags to "struct kvm_gfn_range" to let notifier events target only
shared and only private mappings, and write up the existing mmu_notifier
events to be shared-only (private memory is never associated with a
userspace virtual address, i.e. can't be reached via mmu_notifiers).

Add two flags so that KVM can handle the three possibilities (shared,
private, and shared+private) without needing something like a tri-state
enum.

Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d8c6ce6c8211..b5373cee2b08 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -263,6 +263,8 @@ struct kvm_gfn_range {
 	gfn_t start;
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
+	bool only_private;
+	bool only_shared;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 174de2789657..a41f8658dfe0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -635,6 +635,13 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 * the second or later invocation of the handler).
 			 */
 			gfn_range.arg = range->arg;
+
+			/*
+			 * HVA-based notifications aren't relevant to private
+			 * mappings as they don't have a userspace mapping.
+			 */
+			gfn_range.only_private = false;
+			gfn_range.only_shared = true;
 			gfn_range.may_block = range->may_block;
 
 			/*
-- 
2.42.0.283.g2d96d420d3-goog

