Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65C6C10F1E
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 618824BA0A;
	Thu,  8 Dec 2022 14:39:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oMG3nrv+Iwzy; Thu,  8 Dec 2022 14:39:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64B594BA24;
	Thu,  8 Dec 2022 14:39:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C2304BA23
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pMg-SxDfj1mg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:24 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 568954BA2E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:19 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 k7-20020a256f07000000b006cbcc030bc8so2527307ybc.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=mEYAACx6v3JZOsvV3yRlzSBm3UmWkX5/TtdUayg7qN+uomzNrq5Cbd7I9dqslvyxug
 lXKYviqyYZQXdgSaBKRf11rEv6mYuaKc+T7tsEnXMTJmffphwbU0hw4lvHaHU+vFa23n
 7yAqe3oEHWNiNgv2Xi6tatNMTbeGqcwqdfzZRZP6nPeR/ZCiAXlKBvloMvWAlMesjB0y
 MZA58a19+JWqrTC+CtXXdW2SlQ2ZYxCysLtXOWvjCfx9zODaCoCfF7z5Sd72zx4CxM3T
 xXJiGlymf82bdAvUnbR2ti576RjOe1VPsNpq/CBxt519WOcUGqQpiRWoAWFdEPUG66bj
 aTJw==
X-Gm-Message-State: ANoB5pmk98BG5SgJQtWc1+knCAtYegCSGIUaq4Nd+U5nmf1W1hrSm8q7
 PLxjO8tZ75orye1zL8cmTVfnwhot7WKsbA==
X-Google-Smtp-Source: AA0mqf4+9oetgR3uKpdfVrPGzq2N3r/JU0sb91m8xpA2HrSBGD0IqxC3Vg4zr/dJJfrFDGejU78ci1LRJL+iRw==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:9f85:0:b0:700:f93d:c7cd with SMTP id
 u5-20020a259f85000000b00700f93dc7cdmr16638924ybq.166.1670528358851; Thu, 08
 Dec 2022 11:39:18 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:27 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-8-dmatlack@google.com>
Subject: [RFC PATCH 07/37] mm: Introduce architecture-neutral PG_LEVEL macros
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
