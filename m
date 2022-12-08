Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8948C001B2
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4BA84BA69;
	Thu,  8 Dec 2022 14:39:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ifBlSyw4yKul; Thu,  8 Dec 2022 14:39:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B8E24BA8D;
	Thu,  8 Dec 2022 14:39:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25BCF4BA1C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OrXN0BeScy+A for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:50 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 947324BA6F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:44 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 pa16-20020a17090b265000b0020a71040b4cso1725853pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=LgQMdy+BRV6etzCdcak09K9MMPBRYTlG1+oihaFX4ek=;
 b=HTWjIigcZ7WZjOnOg61QHaCTfbHLyHGvpSvV9l8zZQ5K6Grf0VUcQH9XdDcrgQ0qnO
 1QAcwSASOHpForiZANO2+68V5a8rNealSQ0apW5C0hOTyqLw/F+VPLY3asRhXgPKSuVc
 ATHZcBO/0vYL56E/Ir829fUHKApmsLZ4Axd/FvOUVfKwdR9J0BHthDhp0OlK+DWkEs9G
 8DbJlx/DyawOHuuPdY5BhEZwMd2ETb8lHyA5mmcw6iiBiq+/CMkbN4u0OnU/XPiCWYAg
 4c1jbNQi9nK7+jDlMHAK9qxmS0z+lVbXn90csRVgjpeYpmndVSm5rYF7D0TXl9GZ2RVc
 4lEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=LgQMdy+BRV6etzCdcak09K9MMPBRYTlG1+oihaFX4ek=;
 b=EjAXW9ir8dZ/h2L84m8lfafckH7UOWiycwO1WXsBSJ4X5wRK2Rcubj503Cga/SguOc
 cppDlBdXDbgdSoIESsubrYZbLt1E5K3l3GF+MP4XZU5utZHNe0favAzpzoLp6o/ND/km
 EKiv1EhkhEHtVe0E32fVi8qDOu75uvhl/oBW1iL7IutbCefAsgDWhee2vL47rZ5cIOFY
 /0aGUR7lVUfYuqzBgyIdgBOdg06ZOGr87/T2Bf0RJSjSq7gss+/1DaSvZ0NFYYf7uaYN
 9JOpLkzX5xqawCNOg0eEElxQUx1izIT4QfhynVNL3Zt0MZ0rdybk7nEN6HX/7aBILI7a
 r15Q==
X-Gm-Message-State: ANoB5pmePMte2/HFyNWnIcn8106p/Os0XwdwSYCq/wJN+0T2AxQj55Kv
 D31JQTWzXBZFRjXXc3LrWnDfxepdm2fTqA==
X-Google-Smtp-Source: AA0mqf6s5jpCYuu3sADTa5hiPGsaDUIFXQc5seS/2ekXFn3zxyf2G6r6oJqYRkkShhh/Mij7t3AhSFvHIH2QTg==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:11d6:b0:219:ce92:17a1 with SMTP
 id gv22-20020a17090b11d600b00219ce9217a1mr20111973pjb.235.1670528383766; Thu,
 08 Dec 2022 11:39:43 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:42 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-23-dmatlack@google.com>
Subject: [RFC PATCH 22/37] KVM: x86: Select HAVE_TDP_MMU if X86_64
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

In preparation for moving the TDP MMU implementation into virt/kvm/
guarded behind HAVE_TDP_MMU, ensure that HAVE_TDP_MMU is selected in
X86_64 builds that enable KVM. This matches the existing behavior of the
TDP MMU in x86.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fbeaa9ddef59..849185d5020d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -49,6 +49,7 @@ config KVM
 	select SRCU
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
+	select HAVE_TDP_MMU if X86_64
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
