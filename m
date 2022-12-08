Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDFB8F6F
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:19 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-37360a6236fso24935417b3.12
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yTAZyHH91Hz9k7OZtf9gLdlJIIrZMhdblzaFwMket5k=;
        b=GOQt4+sFqigGxf6Aa3fTvktBe1mjQiluGE/Jj6vv/IvtdV7LliPzUDKCSdDx4Qr+HY
         SefezSHoN8FcvlmM5v70XQPk/EyYEeJUQTBJUq5h/NPog1UINNQReWUqbVEFjNE5psNx
         aagqyJsONr1NaCPx7WLFrSAq/6+YU9H0nX9KZhJN95FCQM9/NOhRMdNzFnOuadNLctYN
         G+xWcIxFKNvCVcBGdVMIWulIdzku3X8ojhuncsVZJ/7ZuOiqyWG7OUDtS4/fr9vosjH0
         V6V8OE7BSYaG+WEMOpz2hhgLOVkbabsraMBHq3XN+o9hqQFkHr8FyeB1wUdGuE+kwW+d
         bbVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTAZyHH91Hz9k7OZtf9gLdlJIIrZMhdblzaFwMket5k=;
        b=K6GmW+NHRpeuo2fMiWL50ATp/0ogRjnKPRAaqo2I+u/HPqNa3gb8YTfsWe/BTE+PTq
         L0FCZRyC53sDr5VgIjdRTLroLAMZfxO3Xw+rbk7M6uhh8N+tPzkQWSZSsQ1jVwpYcpon
         Fty2rI8REdHSqD3curnoSRNv2fXXHbXCXw7RG3ZLanaAKuHayMrALVWxnj+OA2Nw5t3k
         crgKb6ywkgcUPQ9BH8Ye15Frnl1AldKr5WzrugDmIyDqU0Wxy4/5prNwqN7rnSKXkgw/
         WYGjHEZdUjiQNtBaJyYma32FzCDsNXggpDd+vVndHnn2Yv594rPT1eo4LjFQ+0/wRD/b
         LerQ==
X-Gm-Message-State: ANoB5pmT1KIfN2mzzxS3yHxKJxZ3a8icKNaPJCAsOBCiQSeYENt58A3T
	hT++doedSBBfNz7QzFLasd+Cnd8A4sNf2w==
X-Google-Smtp-Source: AA0mqf4+9oetgR3uKpdfVrPGzq2N3r/JU0sb91m8xpA2HrSBGD0IqxC3Vg4zr/dJJfrFDGejU78ci1LRJL+iRw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:9f85:0:b0:700:f93d:c7cd with SMTP id
 u5-20020a259f85000000b00700f93dc7cdmr16638924ybq.166.1670528358851; Thu, 08
 Dec 2022 11:39:18 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:27 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-8-dmatlack@google.com>
Subject: [RFC PATCH 07/37] mm: Introduce architecture-neutral PG_LEVEL macros
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Nadav Amit <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221208193827.7Fqn8uAiQX3uZXY9_Px_oW8EK3iYETbvp4ksmgGrReA@z>

Introduce architecture-neutral versions of the x86 macros PG_LEVEL_4K,
PG_LEVEL_2M, etc. The x86 macros are used extensively by KVM/x86's page
table management code. Introducing architecture-neutral version of these
macros paves the way for porting KVM/x86's page table management code to
architecture-neutral code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/pgtable_types.h | 12 ++++--------
 include/linux/mm_types.h             |  9 +++++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index aa174fed3a71..bdf41325f089 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -518,14 +518,10 @@ extern void native_pagetable_init(void);
 struct seq_file;
 extern void arch_report_meminfo(struct seq_file *m);
 
-enum pg_level {
-	PG_LEVEL_NONE,
-	PG_LEVEL_4K,
-	PG_LEVEL_2M,
-	PG_LEVEL_1G,
-	PG_LEVEL_512G,
-	PG_LEVEL_NUM
-};
+#define PG_LEVEL_4K	PG_LEVEL_PTE
+#define PG_LEVEL_2M	PG_LEVEL_PMD
+#define PG_LEVEL_1G	PG_LEVEL_PUD
+#define PG_LEVEL_512G	PG_LEVEL_P4D
 
 #ifdef CONFIG_PROC_FS
 extern void update_page_count(int level, unsigned long pages);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 500e536796ca..0445d0673afe 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1003,4 +1003,13 @@ enum fault_flag {
 
 typedef unsigned int __bitwise zap_flags_t;
 
+enum pg_level {
+	PG_LEVEL_NONE,
+	PG_LEVEL_PTE,
+	PG_LEVEL_PMD,
+	PG_LEVEL_PUD,
+	PG_LEVEL_P4D,
+	PG_LEVEL_NUM
+};
+
 #endif /* _LINUX_MM_TYPES_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

