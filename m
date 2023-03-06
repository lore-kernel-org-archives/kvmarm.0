Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1691A6FCE
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 19:02:04 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id c192-20020a25c0c9000000b0092aabd4fa90so11554728ybf.18
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 11:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678129323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YtNaR+Rua5pfZ3i1GgJ4+hfSm+WXWk7IiLK4Wtb8+uM=;
        b=A42BX/LP2I7Yrldf83rjJjVVWP9EY7MIToR2w3fKfHNuwlJilnDlJG9Ga110/MBKfg
         bANY0GGZpHkSiBa5gtT3zYMm3kqQ6eoCd9XQbU1Nw97OaGmCCVTg5gCJq6SSBEjZs5D2
         WXuRcS2VBsFJxrimrp+JQlNpq+OFmS1Ohh71sBzmcc1MXrTW549F5OJ3aZCaRVfQfJrL
         Xl5df+WIcc/z0GU55ilZ3Am2ARcrEJpAjke5BrZTBJ9d+m4fByyPMgXYOtOtNovF1gQu
         M0K+F9OgIzJN5j3FpXghI6sTRl0hwMpb0KkZDbWtWBZRE7ORKqG1rS1sA7NOJROAsX6B
         zrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678129323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YtNaR+Rua5pfZ3i1GgJ4+hfSm+WXWk7IiLK4Wtb8+uM=;
        b=rnLVfNmluENtEoL1HYXWCUhoiP2vPNWWOVRo1OSptmyxlF43OT5qKfyNyhnAOFMvgu
         G+BvYrwl7sCC1z1OjQbN4kGV6XObicjmz0JZDMloFQbY3IZ8J/Barod7YYBMraOmvgGr
         Zw32vgaCVwzYfksoOncODyaAKcrskgllB8hriqVs13i+KrPOLJV7dafvLLtn1TM1ACJD
         wbNmBGMYA7OrPtkuOxXq8JCkTswylVS+eyyudmiGaKkJJXxM0nXP8n3JJvo0NtmjyJU5
         FXxz4NvWQs71w0OKFRBbQpVdf+FlbDWdgUaFf/aeH9nZKk2BC5Qn1ZhQapM5N7Rsz6A3
         0znw==
X-Gm-Message-State: AO0yUKVcQi98GSv40//80oAVl27o21uKU/82Sqhs1pMFmVDbQw3goovS
	+j8xC8hTc/RDPaTZ5WmYInSxXbQw94N+Rw==
X-Google-Smtp-Source: AK7set90Igml/rc2W0Ya1hk1eHjjJqlvHrIGVSaZmJTzp6vbZseA2XP1DWQDVsfl/YAYC2c0ne8CFj1tJ7LMiQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:ad0d:0:b0:52e:b635:5496 with SMTP id
 l13-20020a81ad0d000000b0052eb6355496mr7126400ywh.2.1678129323101; Mon, 06 Mar
 2023 11:02:03 -0800 (PST)
Date: Mon,  6 Mar 2023 11:01:54 -0800
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306190156.434452-3-dmatlack@google.com>
Subject: [PATCH v2 2/4] KVM: Refactor designated initializer macros for struct _kvm_stats_desc
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Eric Farman <farman@linux.ibm.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, David Matlack <dmatlack@google.com>, 
	Sathvika Vasireddy <sv@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Refactor the macros that generate struct _kvm_stats_desc designated
initializers to cut down on duplication.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 75 +++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 40 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 02b1151c2753..6673ae757c4e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1744,47 +1744,42 @@ struct _kvm_stats_desc {
 	char name[KVM_STATS_NAME_SIZE];
 };
 
-#define STATS_DESC_COMMON(type, unit, base, exp, sz, bsz)		       \
-	.flags = type | unit | base |					       \
-		 BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |	       \
-		 BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |	       \
-		 BUILD_BUG_ON_ZERO(base & ~KVM_STATS_BASE_MASK),	       \
-	.exponent = exp,						       \
-	.size = sz,							       \
-	.bucket_size = bsz
-
-#define VM_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
+/* Generates a designated initializer list for a struct _kvm_stats_desc. */
+#define _KVM_STATS_DESC(_struct, _field, _name, _type, _unit, _base,	       \
+			_exponent, _size, _bucket_size)			       \
+{									       \
 	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, generic.stat)   \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VCPU_GENERIC_STATS_DESC(stat, type, unit, base, exp, sz, bsz)	       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, generic.stat) \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VM_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vm_stat, stat)	       \
-		},							       \
-		.name = #stat,						       \
-	}
-#define VCPU_STATS_DESC(stat, type, unit, base, exp, sz, bsz)		       \
-	{								       \
-		{							       \
-			STATS_DESC_COMMON(type, unit, base, exp, sz, bsz),     \
-			.offset = offsetof(struct kvm_vcpu_stat, stat)	       \
-		},							       \
-		.name = #stat,						       \
-	}
+		.flags = _type | _unit | _base |			       \
+			 BUILD_BUG_ON_ZERO(_type & ~KVM_STATS_TYPE_MASK) |     \
+			 BUILD_BUG_ON_ZERO(_unit & ~KVM_STATS_UNIT_MASK) |     \
+			 BUILD_BUG_ON_ZERO(_base & ~KVM_STATS_BASE_MASK),      \
+		.exponent = _exponent,					       \
+		.size = _size,						       \
+		.bucket_size = _bucket_size,				       \
+		.offset = offsetof(_struct, _field),			       \
+	},								       \
+	.name = _name,							       \
+}
+
+#define VM_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,    \
+			      _bucket_size)				       \
+	_KVM_STATS_DESC(struct kvm_vm_stat, generic._stat, #_stat, _type,      \
+			_unit, _base, _exponent, _size, _bucket_size)
+
+#define VCPU_GENERIC_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,  \
+				_bucket_size)				       \
+	_KVM_STATS_DESC(struct kvm_vcpu_stat, generic._stat, #_stat, _type,    \
+			_unit, _base, _exponent, _size, _bucket_size)
+
+#define VM_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+		      _bucket_size)					       \
+	_KVM_STATS_DESC(struct kvm_vm_stat, _stat, #_stat, _type, _unit,       \
+			_base, _exponent, _size, _bucket_size)
+
+#define VCPU_STATS_DESC(_stat, _type, _unit, _base, _exponent, _size,	       \
+			_bucket_size)					       \
+	_KVM_STATS_DESC(struct kvm_vcpu_stat, _stat, #_stat, _type, _unit,     \
+			_base, _exponent, _size, _bucket_size)
 
 /* SCOPE: VM, VM_GENERIC, VCPU, VCPU_GENERIC */
 #define STATS_DESC(SCOPE, stat, type, unit, base, exp, sz, bsz)		       \
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

