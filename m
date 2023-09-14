Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A741FB0
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:56:01 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1c08a15fcf4so3865325ad.3
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 18:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694656561; x=1695261361; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IroGtA6z4X06VM4XXyW5Hwunrfyb2UP8Ai0nAjfYz+0=;
        b=cEn7WKdNpcooZlzLvQGE6E92FCHhmFkh02maMdfu8Qwzx9XHPs1Sqstpq0ex1bdIVm
         H0GX6OkDZqIS8Wq4iazN9Wnk6FqSicEUDyQjUY9AvD/wlkORJLfFxsZEfEp/a/xe/2W+
         aTbIu21+GGTQ4FAi67NRRPHriuiS0xBGayp1Qih5DussrO9O/TG0EQ/E0oQ2XBQrSjVr
         d32ttiOeUHyMJBDIeexIVXQwfY1sZH2sRaawNwDdF8mndZExdBpaJIq8XkkhabLaee+Q
         AXIEUPxcW+hvXqKVZz/RLxQLO0hWUF4e2mezGpg0GWrEywvFNgKzLUBsZxY8jtaBqUG0
         QlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694656561; x=1695261361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IroGtA6z4X06VM4XXyW5Hwunrfyb2UP8Ai0nAjfYz+0=;
        b=Ob8nNm6gCHo29vfc7szrddaRh3e4cQ+RIFAyC8T9ZTr4YV1dWL1KKWYSpx9rWbrrgG
         7yH8la9O1XpYHqHkPIMGxrtmG8p93pRbq4Oi/IPHpXjhtcrfT43CNpiuhwty2mZmhIVs
         IRES6UHcR73iZH5UUuYQB8ZDVLiM61/sUqBWY783o2pJlPEa1vsv4NsQ5d5FUl72NlOc
         vpnzRjYSSNE/3BgG9H9BqWWJb8QKxgbq4vdpIwvaDT17RzBLcZMZcjWAx8348oRv3pHw
         ZKJ24BU7nvCO6JVeh/IaKiyszQUYGkAtADnXn8W4A4q0XdJhLrrynJeqzCzzIlWuB71p
         hdIA==
X-Gm-Message-State: AOJu0YyLJ3lqKGWX+MVBZQ8m7TYQPe2IE5i99E7jYTAUd7iWTiZ0nZIi
	VW+TTJ1g72r1HcPweqrLoWwTm+Lr4Pk=
X-Google-Smtp-Source: AGHT+IGFyRd+BYegO6/D6beA7XY/sIg6slB9OxyqJyx+o15XvIYq7E/XS8tz54WBztwLFVG+Qn77mgnd2p8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fb83:b0:1c0:ac09:4032 with SMTP id
 lg3-20020a170902fb8300b001c0ac094032mr144135plb.9.1694656559883; Wed, 13 Sep
 2023 18:55:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 Sep 2023 18:55:10 -0700
In-Reply-To: <20230914015531.1419405-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230914015531.1419405-13-seanjc@google.com>
Subject: [RFC PATCH v12 12/33] mm: Add AS_UNMOVABLE to mark mapping as
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
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add an "unmovable" flag for mappings that cannot be migrated under any
circumstance.  KVM will use the flag for its upcoming GUEST_MEMFD support,
which will not support compaction/migration, at least not in the
foreseeable future.

Test AS_UNMOVABLE under folio lock as already done for the async
compaction/dirty folio case, as the mapping can be removed by truncation
while compaction is running.  To avoid having to lock every folio with a
mapping, assume/require that unmovable mappings are also unevictable, and
have mapping_set_unmovable() also set AS_UNEVICTABLE.

Cc: Matthew Wilcox <willy@infradead.org>
Co-developed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/pagemap.h | 19 +++++++++++++++++-
 mm/compaction.c         | 43 +++++++++++++++++++++++++++++------------
 mm/migrate.c            |  2 ++
 3 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 351c3b7f93a1..82c9bf506b79 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -203,7 +203,8 @@ enum mapping_flags {
 	/* writeback related tags are not used */
 	AS_NO_WRITEBACK_TAGS = 5,
 	AS_LARGE_FOLIO_SUPPORT = 6,
-	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
+	AS_RELEASE_ALWAYS = 7,	/* Call ->release_folio(), even if no private data */
+	AS_UNMOVABLE	= 8,	/* The mapping cannot be moved, ever */
 };
 
 /**
@@ -289,6 +290,22 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
 	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
+static inline void mapping_set_unmovable(struct address_space *mapping)
+{
+	/*
+	 * It's expected unmovable mappings are also unevictable. Compaction
+	 * migrate scanner (isolate_migratepages_block()) relies on this to
+	 * reduce page locking.
+	 */
+	set_bit(AS_UNEVICTABLE, &mapping->flags);
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
index 38c8d216c6a3..12b828aed7c8 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -883,6 +883,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
+		bool is_dirty, is_unevictable;
 
 		if (skip_on_failure && low_pfn >= next_skip_pfn) {
 			/*
@@ -1080,8 +1081,10 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (!folio_test_lru(folio))
 			goto isolate_fail_put;
 
+		is_unevictable = folio_test_unevictable(folio);
+
 		/* Compaction might skip unevictable pages but CMA takes them */
-		if (!(mode & ISOLATE_UNEVICTABLE) && folio_test_unevictable(folio))
+		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
 			goto isolate_fail_put;
 
 		/*
@@ -1093,26 +1096,42 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if ((mode & ISOLATE_ASYNC_MIGRATE) && folio_test_writeback(folio))
 			goto isolate_fail_put;
 
-		if ((mode & ISOLATE_ASYNC_MIGRATE) && folio_test_dirty(folio)) {
-			bool migrate_dirty;
+		is_dirty = folio_test_dirty(folio);
+
+		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
+		    (mapping && is_unevictable)) {
+			bool migrate_dirty = true;
+			bool is_unmovable;
 
 			/*
 			 * Only folios without mappings or that have
-			 * a ->migrate_folio callback are possible to
-			 * migrate without blocking.  However, we may
-			 * be racing with truncation, which can free
-			 * the mapping.  Truncation holds the folio lock
-			 * until after the folio is removed from the page
-			 * cache so holding it ourselves is sufficient.
+			 * a ->migrate_folio callback are possible to migrate
+			 * without blocking.
+			 *
+			 * Folios from unmovable mappings are not migratable.
+			 *
+			 * However, we can be racing with truncation, which can
+			 * free the mapping that we need to check. Truncation
+			 * holds the folio lock until after the folio is removed
+			 * from the page so holding it ourselves is sufficient.
+			 *
+			 * To avoid locking the folio just to check unmovable,
+			 * assume every unmovable folio is also unevictable,
+			 * which is a cheaper test.  If our assumption goes
+			 * wrong, it's not a correctness bug, just potentially
+			 * wasted cycles.
 			 */
 			if (!folio_trylock(folio))
 				goto isolate_fail_put;
 
 			mapping = folio_mapping(folio);
-			migrate_dirty = !mapping ||
-					mapping->a_ops->migrate_folio;
+			if ((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) {
+				migrate_dirty = !mapping ||
+						mapping->a_ops->migrate_folio;
+			}
+			is_unmovable = mapping && mapping_unmovable(mapping);
 			folio_unlock(folio);
-			if (!migrate_dirty)
+			if (!migrate_dirty || is_unmovable)
 				goto isolate_fail_put;
 		}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index b7fa020003f3..3d25c145098d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -953,6 +953,8 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 
 		if (!mapping)
 			rc = migrate_folio(mapping, dst, src, mode);
+		else if (mapping_unmovable(mapping))
+			rc = -EOPNOTSUPP;
 		else if (mapping->a_ops->migrate_folio)
 			/*
 			 * Most folios have a mapping and most filesystems
-- 
2.42.0.283.g2d96d420d3-goog

