Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F21352C2E
	for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 13:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769866167; cv=none; b=sP8Msgyo61Frghtn4N3DUxUNFOxXDKbBAFAUnMfEb3/giuaivUuM/Z+hdSrlfteafXD+qQ4yM1L58Le7DSA+GWFMHq7uK6KcaLwzGxd+5w+V3B9neQama/BpD5AYGoV8/9nKJ9vIxBiZfxf+1CzmUKtHq3YQF9fzPzyVLpE+QPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769866167; c=relaxed/simple;
	bh=RJWjeYAvcYE0G2q2xGvAOWGYBGJxgtvgmHt6tSOKAYo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ma6KXCVXI32CVZTh0N6UCDb7NXvAM6JyRnZl9ALlWzBHoXgXO6LQ4m4pvpQrlYIG5uA49owiSzjhnKOKONWhfNAM55kUnhlaVCK0iGBJIWKIbJeF4rMoVE9o2OZgYHWgYMDpbg2LRfzIKfnzPX5xII4nNo1w6ADTUTnw/0vz1ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ULvJpk0c; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ULvJpk0c"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-65828f603ecso3215466a12.1
        for <kvmarm@lists.linux.dev>; Sat, 31 Jan 2026 05:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769866164; x=1770470964; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tUISk/ccjHYHokYv6vg+0xvhja6CQE9jzscbfeu7VUc=;
        b=ULvJpk0cfAwGK8NwBqX/Mp0ZiiYSffrb/HlRkfxv1QBIzboATtqFp15jdDtTIvfVjW
         o6a+Jwlw5pjiQucFkOfs843Y4PPx2+XvyvccBIqxiGTBsoZG9Wd7uaohe9gQ+N3d6Uzz
         GFwRNYdk609TbIFZnKaceQVzpiK7naqgEMeg6rTpcV0MM3bxAHGMZaqVWeWHqHkt4bu7
         2DzP+3cjjzn81n5vyrqH8VMVSt9IuvXo408S6J/QJbzt88xsA1loxLENORNuhvAQzjXC
         uP/gnSUagsELqTErnpB6iOfKz+5HMEFaBaokVMXa2JFC3ibX+BPe9CLDDVGCVcPdl0IG
         89hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769866164; x=1770470964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tUISk/ccjHYHokYv6vg+0xvhja6CQE9jzscbfeu7VUc=;
        b=Mmv09zajsRrdDkVcGCF1RW/okIS6H9dg8xf6BUZr9BugCReozBRqtJa+HWL7Qm2yoJ
         dV20Xqx10EFJLXpqa1xAuDPTpKdI1GhOeMM38VTshJe/bQBte9fe0Sq6XnjlUAkVmhgJ
         BYCGCG0B/1/I8WmpArmLRw/n0qQV+7p0CkZ3nocL4b2fPKjxgIeGx6iE2AZtL3AUq8RW
         MLUbk1FqwzuJyIvdCE9RKyG06c/2a6ZWBAEIk+gWLwCXcWG7cOhNxnw5GaNmKSLET6vJ
         yxTGRkOoZ4b4dGYvOJT2QdELV85YuzsKzGzILRPz3T31hZRSFqFNoam4QSMAfApv5bK+
         UmoA==
X-Gm-Message-State: AOJu0YxPNbPVZtvu5G9mzNOQCRwVkbwMONvTp6VAwyjoq5nbdLp/Lyh7
	BaJU8IBbtowUK1js6fOJUF0JrOf3AiQedLhbUKqgbJr/bDzea1R118HIFCH5UDbz9/4wRkmfWsN
	I5Knm4+PhQ/7H6cOeV9mznw==
X-Received: from edad40.prod.google.com ([2002:a05:6402:4028:b0:658:817:e783])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2711:b0:658:11c5:2f96 with SMTP id 4fb4d7f45d1cf-658de5a9a0bmr3448451a12.25.1769866163834;
 Sat, 31 Jan 2026 05:29:23 -0800 (PST)
Date: Sat, 31 Jan 2026 13:28:20 +0000
In-Reply-To: <20260131132848.254084-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260131132848.254084-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131132848.254084-3-vdonnefort@google.com>
Subject: [PATCH v11 02/30] ring-buffer: Store bpage pointers into subbuf_ids
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The subbuf_ids field allows to point to a specific page from the
ring-buffer based on its ID. As a preparation or the upcoming
ring-buffer remote support, point this array to the buffer_page instead
of the buffer_data_page.

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1187d632dd5d..a5d11487337e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -554,7 +554,7 @@ struct ring_buffer_per_cpu {
 	unsigned int			mapped;
 	unsigned int			user_mapped;	/* user space mapping */
 	struct mutex			mapping_lock;
-	unsigned long			*subbuf_ids;	/* ID to subbuf VA */
+	struct buffer_page		**subbuf_ids;	/* ID to subbuf VA */
 	struct trace_buffer_meta	*meta_page;
 	struct ring_buffer_cpu_meta	*ring_meta;
 
@@ -7013,7 +7013,7 @@ static void rb_free_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
-				   unsigned long *subbuf_ids)
+				   struct buffer_page **subbuf_ids)
 {
 	struct trace_buffer_meta *meta = cpu_buffer->meta_page;
 	unsigned int nr_subbufs = cpu_buffer->nr_pages + 1;
@@ -7022,7 +7022,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 	int id = 0;
 
 	id = rb_page_id(cpu_buffer, cpu_buffer->reader_page, id);
-	subbuf_ids[id++] = (unsigned long)cpu_buffer->reader_page->page;
+	subbuf_ids[id++] = cpu_buffer->reader_page;
 	cnt++;
 
 	first_subbuf = subbuf = rb_set_head_page(cpu_buffer);
@@ -7032,7 +7032,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 		if (WARN_ON(id >= nr_subbufs))
 			break;
 
-		subbuf_ids[id] = (unsigned long)subbuf->page;
+		subbuf_ids[id] = subbuf;
 
 		rb_inc_page(&subbuf);
 		id++;
@@ -7041,7 +7041,7 @@ static void rb_setup_ids_meta_page(struct ring_buffer_per_cpu *cpu_buffer,
 
 	WARN_ON(cnt != nr_subbufs);
 
-	/* install subbuf ID to kern VA translation */
+	/* install subbuf ID to bpage translation */
 	cpu_buffer->subbuf_ids = subbuf_ids;
 
 	meta->meta_struct_len = sizeof(*meta);
@@ -7197,13 +7197,15 @@ static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
 	}
 
 	while (p < nr_pages) {
+		struct buffer_page *subbuf;
 		struct page *page;
 		int off = 0;
 
 		if (WARN_ON_ONCE(s >= nr_subbufs))
 			return -EINVAL;
 
-		page = virt_to_page((void *)cpu_buffer->subbuf_ids[s]);
+		subbuf = cpu_buffer->subbuf_ids[s];
+		page = virt_to_page((void *)subbuf->page);
 
 		for (; off < (1 << (subbuf_order)); off++, page++) {
 			if (p >= nr_pages)
@@ -7230,7 +7232,8 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long flags, *subbuf_ids;
+	struct buffer_page **subbuf_ids;
+	unsigned long flags;
 	int err;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -7254,7 +7257,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	if (err)
 		return err;
 
-	/* subbuf_ids include the reader while nr_pages does not */
+	/* subbuf_ids includes the reader while nr_pages does not */
 	subbuf_ids = kcalloc(cpu_buffer->nr_pages + 1, sizeof(*subbuf_ids), GFP_KERNEL);
 	if (!subbuf_ids) {
 		rb_free_meta_page(cpu_buffer);
-- 
2.53.0.rc1.225.gd81095ad13-goog

