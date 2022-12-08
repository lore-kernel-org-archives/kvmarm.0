Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70C28F6F
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:42 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id m13-20020a170902f64d00b001899a70c8f1so2214694plg.14
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=eM2p/SYFOD2PDwQRTLeLrQzDaNr9a0uXG6SvJN3YLHTSww6KFFOeT92dpgZv5AmRqP
         4Xb9TcAN7MqPXtb7Zft6AN5Hv+U8dD0sob3Oph5D3ggj0PumiJpUGF5BO9vH5Dq/L5ez
         goXUYuzzeLy6yhcWl+ycAnMIwlh70pNqQA58Aaz6YhEmx9dTnaVVaIfU827edhDK84QP
         grrweqT+TUHQNtt8iCuByD2ZcuVwWLGpdRHOVo9TCW29N0WNA4iFMbuBXKv/cqHN1sjs
         bVH12GicJILpSdmI+YtQz1h7otCJEHq5pxlo3ukDL4bbcbUsTVmWZ+VOpgs8VlgXtP0D
         yOqw==
X-Gm-Message-State: ANoB5pmSBWe02yCcRd6BiRBXVGyQ8Qaa7ujEh8AaETh/NpSpT3nYwEfq
	LQ9U5z42fPZzR0EPCZ34wMN9DHPPQjyJiQ==
X-Google-Smtp-Source: AA0mqf7xeoOaS0AA84SgKnbp6lpiXTBq7xMlUXV6MswQxMERGECN0IbonM/14NtNvPIycx9F8VqJbtOKzbBrCA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:d3d5:b0:218:845f:36a1 with SMTP
 id d21-20020a17090ad3d500b00218845f36a1mr97581242pjw.117.1670528382072; Thu,
 08 Dec 2022 11:39:42 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:41 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-22-dmatlack@google.com>
Subject: [RFC PATCH 21/37] KVM: Introduce CONFIG_HAVE_TDP_MMU
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
Message-ID: <20221208193841.NTvv1y0o7PwZE4vJkJhOAwzSeUUp7oKf4gKsFZuMCM4@z>

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

