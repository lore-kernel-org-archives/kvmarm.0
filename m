Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C138F6F
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:44 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id md9-20020a17090b23c900b00218fa3308a9so1722055pjb.8
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=drMkFIyGxfwLuUh+nRU3o5bwt+WpfyQSv1Ph32+I27V1fedk0SrY1L4fSuh16PNu0M
         +FbAl/Yup7ad01Ho5x9HkuYAhuDH3JeICTwGbZnLuhTimnGP0Tn/G8ygSw8zUyaxU0xk
         J/x/Z69cGVQ3fgbo5Tx7mBMuWRCUNDo2gYiURBWe0X2ZlNA0z0HjvjjXFrYsauUKxxdA
         soCXHC0nmnOMNK77WZYdSsHUiGm5Pb6bYv8CscMBWOwsj7LUnY7dZk+hgUpca3OiPCj2
         8yPG+1H92EXBj1XdeIuOhzSa49QSnODdkMvzAQrKtG04xoRAFDG8tT/lCXfY4myOJDVY
         lsmg==
X-Gm-Message-State: ANoB5pkYS6E7Zr4P3x5WqjLdyci6PIKuGcEgUn087Z5XWMN75DZScIkR
	Su4/Ooc99yD+/Q/NkjNVCp1AJzlS1La2QQ==
X-Google-Smtp-Source: AA0mqf6s5jpCYuu3sADTa5hiPGsaDUIFXQc5seS/2ekXFn3zxyf2G6r6oJqYRkkShhh/Mij7t3AhSFvHIH2QTg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:11d6:b0:219:ce92:17a1 with SMTP
 id gv22-20020a17090b11d600b00219ce9217a1mr20111973pjb.235.1670528383766; Thu,
 08 Dec 2022 11:39:43 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:42 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-23-dmatlack@google.com>
Subject: [RFC PATCH 22/37] KVM: x86: Select HAVE_TDP_MMU if X86_64
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
Message-ID: <20221208193842.cCqiVpw1MFFxAaqg_J7VnbAm7T3frvBN7nLSot_J758@z>

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

