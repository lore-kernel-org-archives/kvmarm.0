Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2027D17ADB
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 23:49:14 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c0d62f4487cso5474431276.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724154; x=1692316154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JHyOFUOJNrHCsG8hxo3NWWS2w8rJ24DtuKIoDCRGyag=;
        b=xEjga5LwPPSSdY8SIx3jyoncD3GGf3WPGooyrkM0KnahhnaL4mCb4YwQt0GO0HS22c
         NEcfXNGBndDk4nsku/Y91YS1hHA5MX/cUUC80CuRLM1bK9lLy4VQpDRd1Xi2xWiJI6o1
         9/UCIe7gQuFQ2+gvKJ9C6ii8/xbm2jFSze0SQ3v0PRjd1NOqJPDidQ7wUtuL19wRUrTE
         yGaIkqqRPEKiBe0hyG7ZRrXgE8SEXgjc2KYKv831pMLCu06jrX+LffHvzIu5EPSPB+OK
         JqyI7fhSc4r9xeqc00aXehzDSyLGCvqUsUwXUuUYEMMNJQvdcAepZR51lMeVVKDz3MhJ
         Gd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724154; x=1692316154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JHyOFUOJNrHCsG8hxo3NWWS2w8rJ24DtuKIoDCRGyag=;
        b=XleJi0a2WrWhJfaBVyweYZ9ds2ye303WqFPie1Ra1wASiJiiHRRSLcptZoUHqBMvD6
         vcrNCmAZHLqmV5QqVkkeRv3IMd8wx+saVm5uov3YeNm9laTTeNq57giiwX9ZfaXX6dWl
         uvZydWSX7GEp95EM3v000ZEYLS58DMbkDLIrZymaazlgScZYLeat7T5S7G8RIGLz1Pl0
         godskgCJGTw4VfIVEDunyzNXRV8AURX3geVuL8JQSeVN2viSwfX0k6+wxODWj7qD4oTR
         kEFhRiRbPIMFEbm/CrTABEms+2Ldabcq9oE1ZH8wQ5UrtfNh8qy9KqUS7HmcUsyDi3xj
         vPdg==
X-Gm-Message-State: ABy/qLaXhsf12tVp3P86uQjAxgdgBFQB1DAnflvxf1/1HyBKSCviNeDT
	uRuK1uvp1bYhrFVt/MWy22DoRqq32EY=
X-Google-Smtp-Source: APBJJlG18o++4c+4o8gvKjis+x9wRH2pDI/AJGKQKbbl3lcmVj0vggAD6gv2GfLwBQuIOlyc9qDjI+M6sT4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a021:0:b0:cf2:9e82:a5b5 with SMTP id
 x30-20020a25a021000000b00cf29e82a5b5mr7746ybh.8.1689724154115; Tue, 18 Jul
 2023 16:49:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Jul 2023 16:45:05 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-23-seanjc@google.com>
Subject: [RFC PATCH v11 22/29] KVM: selftests: Add helpers to do
 KVM_HC_MAP_GPA_RANGE hypercalls (x86)
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

From: Vishal Annapurve <vannapurve@google.com>

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
[sean: drop shared/private helpers (let tests specify flags)]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index aa434c8f19c5..8857143d400a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -15,6 +15,7 @@
 #include <asm/msr-index.h>
 #include <asm/prctl.h>
 
+#include <linux/kvm_para.h>
 #include <linux/stringify.h>
 
 #include "../kvm_util.h"
@@ -1166,6 +1167,20 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 void xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 
+static inline uint64_t __kvm_hypercall_map_gpa_range(uint64_t gpa,
+						     uint64_t size, uint64_t flags)
+{
+	return kvm_hypercall(KVM_HC_MAP_GPA_RANGE, gpa, size >> PAGE_SHIFT, flags, 0);
+}
+
+static inline void kvm_hypercall_map_gpa_range(uint64_t gpa, uint64_t size,
+					       uint64_t flags)
+{
+	uint64_t ret = __kvm_hypercall_map_gpa_range(gpa, size, flags);
+
+	GUEST_ASSERT_1(!ret, ret);
+}
+
 void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
 
 #define vm_xsave_require_permission(xfeature)	\
-- 
2.41.0.255.g8b1d071c50-goog

