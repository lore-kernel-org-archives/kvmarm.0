Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32571FB0
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:56:28 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-594e1154756so6572637b3.2
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656588; x=1695261388; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UjBddbZXLqwDqs/dRSKLKY4HwUhf6Ai3WxLtYL+KxyQ=;
        b=iHCv0UXnTImnw2hloEbm1wl9BS9OSXLrQ0+EHadLxCD6PznfcOS8E+bnaQd/DOJJvi
         Hmhhy3dcJIxzwlVzPH3voJikZtV1t5OKdShFUmVq7gr28p1hSsB2/VhJp3vemfQQ7woB
         xdSucBT695sCg7vbtI9LUudwMprfvouDDCrazjedyfidB0uWzR4bhBZUfAyy7FxB2tae
         dQhC4iVFUaCzmxWRTeZr00EaXCJ6QSpPYntPfbzfG6CN0MuDeQ26E5OsruYtwI+c61/K
         yu4Pb1FX0BiV+24b0+/EtKlKrmyfUIsRXMqaWPtIcDhL7UL1y2tFa2MjJvVHIdstuF5U
         iMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656588; x=1695261388;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UjBddbZXLqwDqs/dRSKLKY4HwUhf6Ai3WxLtYL+KxyQ=;
        b=GQqo8wmhyzWfL3ElWKThObG+WMUH/WB++ERHDH+9qp2aaiQtcDuyAq8iy7ZXBXiZpc
         TfvdWvei8mJhJuCGA3lM1SVHrL2gqvuUAVTvFL/EmSjMLBp++S74QeLbTq8eCILJ5Or5
         lW613VVenHz7zQbFv411yXdBNOvbFq7kJdOaNEq4JLsrBpVg3pXQ30aFWQ11KDWbrKYw
         5ZPs/e496lIw1X5nDH8tcwb4wL4QPz6IzMYfQaHU26K83xgOBDL56jXE5RUeVy7lIuUm
         EvbuTSMh/G65/l//mfslesJnbcvymafMqim7LJO8fA4W3dg/5v1xM2/YGZ25G1BLtO0z
         PzcQ==
X-Gm-Message-State: AOJu0YzR0L6KHoJ4yzHsCKY4AdC35ZnnqIuViaGh0kj9PkDCgBwnZjnz
	gLyl1gliS9gwks5RElsHD+QwNziec0o=
X-Google-Smtp-Source: AGHT+IH0gGeX6zOzLjc3uszP5L1cVBy/yaTsK9vfF/9VEoisKrc6F33BJumlmtJCwJ85BnFPZfgq0s7SPdg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e05:b0:59b:e1db:5633 with SMTP id
 et5-20020a05690c2e0500b0059be1db5633mr53066ywb.1.1694656588217; Wed, 13 Sep
 2023 18:56:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Sep 2023 18:55:24 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-27-seanjc@google.com>
Subject: [RFC PATCH v12 26/33] KVM: selftests: Add helpers to do
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
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Vishal Annapurve <vannapurve@google.com>

Add helpers for x86 guests to invoke the KVM_HC_MAP_GPA_RANGE hypercall,
which KVM will forward to userspace and thus can be used by tests to
coordinate private<=>shared conversions between host userspace code and
guest code.

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
[sean: drop shared/private helpers (let tests specify flags)]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 4fd042112526..1911c12d5bad 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -15,6 +15,7 @@
 #include <asm/msr-index.h>
 #include <asm/prctl.h>
 
+#include <linux/kvm_para.h>
 #include <linux/stringify.h>
 
 #include "../kvm_util.h"
@@ -1171,6 +1172,20 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
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
+	GUEST_ASSERT(!ret);
+}
+
 void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
 
 #define vm_xsave_require_permission(xfeature)	\
-- 
2.42.0.283.g2d96d420d3-goog

