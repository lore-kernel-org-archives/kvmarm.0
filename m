Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3239117AC3
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 23:48:52 +0000 (UTC)
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-1b73ae7dedfso9641022fac.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724131; x=1692316131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=muvilKyoWvn1tarN80afquV4Wd3ZvyUZATzGD2ucPnA=;
        b=dy1/NFlQGuJqswhd4jyp5/5Y2DKjXWq8ZhDnL7jyfQUkTP7A9Hvq/HvrZglV4JQg4M
         0K4GnyosjYX3JEla9t9lm8LJXLHv4GUKKzg9xFm9cJWrlQ5Qmy5LmSHitAR/Xzi9H8/Y
         MjJIFDOPL8g3wik3LCZjllYyd45Gr2H0qgazCaqc+yiHTFw7sn+VQEAa9DzzRpRQoil4
         OF2suL13dOrJbxrD1Es2a+3MSZoSnJ4hgva3/KXiELtegBBB1WkzGy/iAanliFh6iYW0
         B8x8MynR4QN8rTTnTiUPKbxJnJ7ZIBs38bI6aS2sGXphM22HDrUDYnhUpurmEDIvnFzg
         o5tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724131; x=1692316131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=muvilKyoWvn1tarN80afquV4Wd3ZvyUZATzGD2ucPnA=;
        b=EG7Zw3/+fzcFrL1e4aLr2Pp0q4PrRug4jgTO/HYy0aiZoyduD1uTsPnAuLkemXYrmo
         GZ0vPcC7zzrP4ySBdzJpUhJ/9ML7+DpkWE8MCzok3Adq6TZrqUscTLeLz1UGoO25Gb+P
         K9S6nmPatx8S3PCJ8aja6QMnWpO4wFjyxdmRIy0ZG2UIqe0VTJdHhrhASaxv46vI0e5i
         VW948t3Gu9JH2Aq/CWZS7PW50HXDDLEhbApqT2NePtKxIChj83v9b8N7ONQGux+OTDIP
         phtM5auGCVvHyu17y9S32GGDvKEQYWHj+HGPnPCKGFLA0i0cPHo41770zr+GobTVlmCa
         Izew==
X-Gm-Message-State: ABy/qLb5GMorUz5GzPlkGm3oywte656+wYzTRNhhpJwWLMeywXkwINdZ
	u6VkiRCcnB9Jm1pcfewTad8CtEVhGWw=
X-Google-Smtp-Source: APBJJlE49QI+GKjHT7/jwtmKHpb+kXt66N6K7QDVRkzJgeGH+MWu0bF/51TSJcseqrb6U54aALrx+EClwNQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6870:c796:b0:1b0:20bd:eef with SMTP id
 dy22-20020a056870c79600b001b020bd0eefmr758790oab.2.1689724131216; Tue, 18 Jul
 2023 16:48:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Jul 2023 16:44:53 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-11-seanjc@google.com>
Subject: [RFC PATCH v11 10/29] mm: Add AS_UNMOVABLE to mark mapping as
 completely unmovable
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/pagemap.h | 11 +++++++++++
 mm/compaction.c         |  4 ++++
 mm/migrate.c            |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 716953ee1ebd..931d2f1da7d5 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -203,6 +203,7 @@ enum mapping_flags {
 	/* writeback related tags are not used */
 	AS_NO_WRITEBACK_TAGS = 5,
 	AS_LARGE_FOLIO_SUPPORT = 6,
+	AS_UNMOVABLE	= 7,	/* The mapping cannot be moved, ever */
 };
 
 /**
@@ -273,6 +274,16 @@ static inline int mapping_use_writeback_tags(struct address_space *mapping)
 	return !test_bit(AS_NO_WRITEBACK_TAGS, &mapping->flags);
 }
 
+static inline void mapping_set_unmovable(struct address_space *mapping)
+{
+	set_bit(AS_UNMOVABLE, &mapping->flags);
+}
+
+static inline bool mapping_unmovable(struct address_space *mapping)
+{
+	return test_bit(AS_UNMOVABLE, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return mapping->gfp_mask;
diff --git a/mm/compaction.c b/mm/compaction.c
index dbc9f86b1934..a3d2b132df52 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1047,6 +1047,10 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (!mapping && (folio_ref_count(folio) - 1) > folio_mapcount(folio))
 			goto isolate_fail_put;
 
+		/* The mapping truly isn't movable. */
+		if (mapping && mapping_unmovable(mapping))
+			goto isolate_fail_put;
+
 		/*
 		 * Only allow to migrate anonymous pages in GFP_NOFS context
 		 * because those do not depend on fs locks.
diff --git a/mm/migrate.c b/mm/migrate.c
index 24baad2571e3..c00a4ca86698 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -954,6 +954,8 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 
 		if (!mapping)
 			rc = migrate_folio(mapping, dst, src, mode);
+		else if (mapping_unmovable(mapping))
+			rc = -EOPNOTSUPP;
 		else if (mapping->a_ops->migrate_folio)
 			/*
 			 * Most folios have a mapping and most filesystems
-- 
2.41.0.255.g8b1d071c50-goog

