Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EEAC4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F247E4BA71;
	Thu,  8 Dec 2022 14:39:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y2YrRMjBHcaP; Thu,  8 Dec 2022 14:39:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 102E34BA81;
	Thu,  8 Dec 2022 14:39:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF85E4BA61
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZEFB8YmdWxtL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:46 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13DE74BA36
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:43 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 j18-20020a170902da9200b00189b3b16addso2193685plx.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=4Zxu59m+BC3IHN6G+DZ7Gfccf72aG4aOXJ0CWcNu+xQ=;
 b=SdJhXds2L90YC8FNHmtWh5Fh9TEgerNWhfkuw8x3d9CBnfm/9eipZjv0gPdpJNH4I0
 S+51SqBNWDjQiWTiQlTyu6PNy4niyZRnQhbIkbzuxQiNibwxH6mkZqPrFqBbyJTrkaSd
 9Mn4ob8QKmJos009LfgYNnOTusdfrKp1xLSuoRmHmtBWBuBrOTTzfiu5JzBu+friunut
 7j3QXKw2PfZd7vhhYsSAGJiGY/32mBAW8UAr3zD1WlpFMVlQcqneZ096cl3TmZsBGjzc
 3x4d21+FAOrJhsugApLkXvPF1NkwgnZMzvQRH+9jPPL4ZLADP+yEglXH2v1r5QVynX/K
 vjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=4Zxu59m+BC3IHN6G+DZ7Gfccf72aG4aOXJ0CWcNu+xQ=;
 b=T3aT+TUzVskGAD1/jJ2q5l+5h7d9Gj+C7ThbAPd+WyHRwfpA3VK8o7+Nixd7yoPOea
 +vSdBPxLlGUIGgTiz3PQ4A6RHoW42mFHza4RufqmnKZY7KmyzTNhw09ukk5EMEv1Op9T
 hv6DjVO3n1aobv3TuCE+jYZJr/JJjhs/QmqutT8e9YACRxZ/OoeaCoTIg/Cc3M3Wx3F3
 M+i05h8FE3rwVggAlPEvd8bzx1DX7wFNz8V63lBCpJA7+fVktpHUz3XyfaWL5tOL/JVA
 eM4dnkdUJu9EdEIQ7LK1W5cYHJivV/+dzegxZl+Yu/9FoYvyApWdek4IbRVcPmJe5vD3
 DuNw==
X-Gm-Message-State: ANoB5pnrsEpTCwpoR/JxfemJdgGJjE6lxylry3G5mwwqRH+FSBwpi+hZ
 T5N73URN+Ev7UlILWtzsM42wvAAJ2ab9lA==
X-Google-Smtp-Source: AA0mqf7xeoOaS0AA84SgKnbp6lpiXTBq7xMlUXV6MswQxMERGECN0IbonM/14NtNvPIycx9F8VqJbtOKzbBrCA==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:d3d5:b0:218:845f:36a1 with SMTP
 id d21-20020a17090ad3d500b00218845f36a1mr97581242pjw.117.1670528382072; Thu,
 08 Dec 2022 11:39:42 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:41 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-22-dmatlack@google.com>
Subject: [RFC PATCH 21/37] KVM: Introduce CONFIG_HAVE_TDP_MMU
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

Introduce a new config option to gate support for the common TDP MMU.
This will be used in future commits to avoid compiling the TDP MMU code
and avoid adding fields to common structs (e.g. struct kvm) on
architectures that do not support the TDP MMU yet.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 9fb1ff6f19e5..75d86794d6cf 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -92,3 +92,6 @@ config KVM_XFER_TO_GUEST_WORK
 
 config HAVE_KVM_PM_NOTIFIER
        bool
+
+config HAVE_TDP_MMU
+       bool
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
