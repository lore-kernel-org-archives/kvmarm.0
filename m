From: Andrey Konovalov <andreyknvl@google.com>
Subject: [RFC PATCH v2 12/15] khwasan: add bug reporting routines
Date: Fri, 23 Mar 2018 19:05:48 +0100
Message-ID: <1ebd9c89a812711429ff6d38c1672255d860228b.1521828274.git.andreyknvl@google.com>
References: <cover.1521828273.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E73549F9E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Mar 2018 14:14:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CHroe3V0M2nX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Mar 2018 14:13:41 -0400 (EDT)
Received: from mail-wr0-f193.google.com (mail-wr0-f193.google.com
 [209.85.128.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3915402DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Mar 2018 13:58:25 -0400 (EDT)
Received: by mail-wr0-f193.google.com with SMTP id s18so12990095wrg.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Mar 2018 11:06:23 -0700 (PDT)
In-Reply-To: <cover.1521828273.git.andreyknvl@google.com>
In-Reply-To: <cover.1521828273.git.andreyknvl@google.com>
References: <cover.1521828273.git.andreyknvl@google.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christopher Li <sparse@chrisli.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, "GitAuthor : Andrey Konovalov" <andreyknvl@google.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Yury Norov <ynorov@caviumnetworks.com>, Nick Desaulniers <ndesaulniers@google.com>, Suzuki K Poulose <suzuki.po>
Cc: Kees Cook <keescook@google.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Jann Horn <jannh@google.com>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Lee Smith <Lee.Smith@arm.com>, Kostya Serebryany <kcc@google.com>, Mark Brand <markbrand@google.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Evgeniy Stepanov <eugenis@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

This commit adds rountines, that print KHWASAN error reports. Those are
quite similar to KASAN, the difference is:

1. The way KHWASAN finds the first bad shadow cell (with a mismatching
   tag). KHWASAN compares memory tags from the shadow memory to the pointer
   tag.

2. KHWASAN reports all bugs with the "KASAN: invalid-access" header. This
   is done, so various external tools that already parse the kernel logs
   looking for KASAN reports wouldn't need to be changed.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 include/linux/kasan.h |  3 ++
 mm/kasan/report.c     | 88 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index a2869464a8be..54e7c437dc8f 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -161,6 +161,9 @@ void *khwasan_set_tag(const void *addr, u8 tag);
 u8 khwasan_get_tag(const void *addr);
 void *khwasan_reset_tag(const void *ptr);
 
+void khwasan_report(unsigned long addr, size_t size, bool write,
+			unsigned long ip);
+
 #else /* CONFIG_KASAN_TAGS */
 
 static inline void khwasan_init(void) { }
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 5c169aa688fd..ed17168a083e 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -51,10 +51,9 @@ static const void *find_first_bad_addr(const void *addr, size_t size)
 	return first_bad_addr;
 }
 
-static bool addr_has_shadow(struct kasan_access_info *info)
+static bool addr_has_shadow(const void *addr)
 {
-	return (info->access_addr >=
-		kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
+	return (addr >= kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
 }
 
 static const char *get_shadow_bug_type(struct kasan_access_info *info)
@@ -127,15 +126,14 @@ static const char *get_wild_bug_type(struct kasan_access_info *info)
 
 static const char *get_bug_type(struct kasan_access_info *info)
 {
-	if (addr_has_shadow(info))
+	if (addr_has_shadow(info->access_addr))
 		return get_shadow_bug_type(info);
 	return get_wild_bug_type(info);
 }
 
-static void print_error_description(struct kasan_access_info *info)
+static void print_error_description(struct kasan_access_info *info,
+					const char *bug_type)
 {
-	const char *bug_type = get_bug_type(info);
-
 	pr_err("BUG: KASAN: %s in %pS\n",
 		bug_type, (void *)info->ip);
 	pr_err("%s of size %zu at addr %px by task %s/%d\n",
@@ -345,10 +343,10 @@ static void kasan_report_error(struct kasan_access_info *info)
 
 	kasan_start_report(&flags);
 
-	print_error_description(info);
+	print_error_description(info, get_bug_type(info));
 	pr_err("\n");
 
-	if (!addr_has_shadow(info)) {
+	if (!addr_has_shadow(info->access_addr)) {
 		dump_stack();
 	} else {
 		print_address_description((void *)info->access_addr);
@@ -412,6 +410,78 @@ void kasan_report(unsigned long addr, size_t size,
 	kasan_report_error(&info);
 }
 
+static inline void khwasan_print_tags(const void *addr)
+{
+	u8 addr_tag = get_tag(addr);
+	void *untagged_addr = reset_tag(addr);
+	u8 *shadow = (u8 *)kasan_mem_to_shadow(untagged_addr);
+
+	pr_err("Pointer tag: [%02x], memory tag: [%02x]\n", addr_tag, *shadow);
+}
+
+static const void *khwasan_find_first_bad_addr(const void *addr, size_t size)
+{
+	u8 tag = get_tag((void *)addr);
+	void *untagged_addr = reset_tag((void *)addr);
+	u8 *shadow = (u8 *)kasan_mem_to_shadow(untagged_addr);
+	const void *first_bad_addr = untagged_addr;
+
+	while (*shadow == tag && first_bad_addr < untagged_addr + size) {
+		first_bad_addr += KASAN_SHADOW_SCALE_SIZE;
+		shadow = (u8 *)kasan_mem_to_shadow(first_bad_addr);
+	}
+	return first_bad_addr;
+}
+
+void khwasan_report(unsigned long addr, size_t size, bool write,
+			unsigned long ip)
+{
+	struct kasan_access_info info;
+	unsigned long flags;
+	void *untagged_addr = reset_tag((void *)addr);
+
+	if (likely(!kasan_report_enabled()))
+		return;
+
+	disable_trace_on_warning();
+
+	info.access_addr = (void *)addr;
+	info.first_bad_addr = khwasan_find_first_bad_addr((void *)addr, size);
+	info.access_size = size;
+	info.is_write = write;
+	info.ip = ip;
+
+	kasan_start_report(&flags);
+
+	print_error_description(&info, "invalid-access");
+	khwasan_print_tags((void *)addr);
+	pr_err("\n");
+
+	if (!addr_has_shadow(untagged_addr)) {
+		dump_stack();
+	} else {
+		print_address_description(untagged_addr);
+		pr_err("\n");
+		print_shadow_for_address(info.first_bad_addr);
+	}
+
+	kasan_end_report(&flags);
+}
+
+void khwasan_report_invalid_free(void *object, unsigned long ip)
+{
+	unsigned long flags;
+	void *untagged_addr = reset_tag((void *)object);
+
+	kasan_start_report(&flags);
+	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", (void *)ip);
+	khwasan_print_tags(object);
+	pr_err("\n");
+	print_address_description(untagged_addr);
+	pr_err("\n");
+	print_shadow_for_address(untagged_addr);
+	kasan_end_report(&flags);
+}
 
 #define DEFINE_ASAN_REPORT_LOAD(size)                     \
 void __asan_report_load##size##_noabort(unsigned long addr) \
-- 
2.17.0.rc0.231.g781580f067-goog
