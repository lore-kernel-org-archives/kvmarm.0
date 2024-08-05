Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D27915C13D
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 17:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879217; cv=none; b=jopuQq1X08gLWtueRY/HCq1IXJTxKrCWwVHS6MbIoIx3i/6eSUULROalA6Vs5vHZd26XushDRBbFe59yU1c8lXaSSXWgf34dJCByoL8dYDqqb/xm77fZo6A0AeXX1BZNGwmp8B6j5E0U+8mYMYd2QwDUIvyTuPfg45d6ySha2iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879217; c=relaxed/simple;
	bh=1NrPIOiaFcWy1pA7SeZO58DyGP+moHdFsjNSYGiQovs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vf3xt6j19T26zca8Uv8a6EFNfo78u3ZHPEj/WtsVXEXy6eTnXWeE1DKnEhFZh5eeOcU/6vOQ29pzYYxLznQsWSmtzMusWZkVLTsOpSPJj58WiZxBfjrOQwPcyGWWR+5s18iqnfDikKFj3Mt+zXq3AT+yqdr9OKJk3j5iLM48PmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nTf+jABe; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nTf+jABe"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-665a6dd38c8so215529547b3.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 10:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722879215; x=1723484015; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A2jd+nZ7zCydcSHS9qkv11rRGweV2pR3YmHjm/L+b6o=;
        b=nTf+jABe9uYvxISbIU+CseupW7V6XxqldR9hbAd/tm1yXlYTX0cpDhv+6WnlyUwz8w
         VrAZBheGXYySuji619ujjYq8pxFDs5Xuyq77K8hyayr5Clj1aMQJGm6+XYQBvFgPvX87
         GUqLgGCoYBb47lDcB/jHfV0grUk9/Q63PSsMDdQ4RJTVM8cUTwwImQWFfwj+aMeJ1pxX
         WjAmKGzbOJdnq8dFaoflsVM4tC6FqIjfC6nOHYe+jcPVb9rtJYZr6lUEfs/ixXjC8Wiy
         RTdRnV2KHuw6OZsk32p4jl8/v+Dl2E+aa1K1CAw70vzkK7ICdbC0MHliLxcl6PuZ9VV7
         Zf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879215; x=1723484015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A2jd+nZ7zCydcSHS9qkv11rRGweV2pR3YmHjm/L+b6o=;
        b=bU8iyOtRqgAnoo2utIHj4kCsn+JHHC8FzxSMsH+yq5Q0HjxBRdevrUwP61LCh9fGJw
         X/oDt91E3eEzJH2IfszbyqRA8MJaMj2Oi/TsRwWpSkrzjdsPVm2ZFTQ85Mn+H8sw6Omy
         4jh/cuycnMckBrowLExfXMg8O6uz2UlX+o2qy5uogLJwP5ETa9cOstqlg0EybH7Q3BWM
         OX9hOxAixDXJsP2ShLxGoCa9sk1JjOy5tgDKqDzs1hms+/yC7TOB53dHCy1SxKKPvrV+
         +nPA9nfhYr1OxiRN9D5WhoXjwrlIS/9iAnsgQ89wcs5fJVOA4J/SP5VwWoMx6OqNJwDR
         hEpg==
X-Gm-Message-State: AOJu0Ywd0jnwFmzBZXqmwprOm/m0t3LpbIAHh7TFeCJ9/dy6rluhfE6r
	GyYBG1bA6atujOnLdX6DVUtHM7nqEoidd/eRUK1SfHky8XR69hH67p9Xevga24c6sex9baXkThh
	JoffYde92eFzvh7GqdQ==
X-Google-Smtp-Source: AGHT+IH9rlAJCZiANrVd4cygC2GlEEarzxxTnrIG5AU1Lx9lNgnvYh5Ez2oOozI3CIzKmGFUVsO/YBSH0IL4yed+
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:690c:113:b0:61b:e103:804d with SMTP
 id 00721157ae682-68959c192bfmr3553157b3.0.1722879215017; Mon, 05 Aug 2024
 10:33:35 -0700 (PDT)
Date: Mon,  5 Aug 2024 18:32:24 +0100
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805173234.3542917-2-vdonnefort@google.com>
Subject: [RFC PATCH 01/11] ring-buffer: Check for empty ring-buffer with rb_num_of_entries()
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently there are two ways of identifying an empty ring-buffer. One
relying on the current status of the commit / reader page
(rb_per_cpu_empty()) and the other on the write and read counters
(rb_num_of_entries() used in rb_get_reader_page()).

with rb_num_of_entries(). This intends to ease later
introduction of ring-buffer writers which are out of the kernel control
and with whom, the only information available is through the meta-page
counters.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 28853966aa9a..f4f4dda28077 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3953,40 +3953,22 @@ int ring_buffer_write(struct trace_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_write);
 
-static bool rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+/*
+ * The total entries in the ring buffer is the running counter
+ * of entries entered into the ring buffer, minus the sum of
+ * the entries read from the ring buffer and the number of
+ * entries that were overwritten.
+ */
+static inline unsigned long
+rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct buffer_page *reader = cpu_buffer->reader_page;
-	struct buffer_page *head = rb_set_head_page(cpu_buffer);
-	struct buffer_page *commit = cpu_buffer->commit_page;
-
-	/* In case of error, head will be NULL */
-	if (unlikely(!head))
-		return true;
-
-	/* Reader should exhaust content in reader page */
-	if (reader->read != rb_page_size(reader))
-		return false;
-
-	/*
-	 * If writers are committing on the reader page, knowing all
-	 * committed content has been read, the ring buffer is empty.
-	 */
-	if (commit == reader)
-		return true;
-
-	/*
-	 * If writers are committing on a page other than reader page
-	 * and head page, there should always be content to read.
-	 */
-	if (commit != head)
-		return false;
+	return local_read(&cpu_buffer->entries) -
+		(local_read(&cpu_buffer->overrun) + cpu_buffer->read);
+}
 
-	/*
-	 * Writers are committing on the head page, we just need
-	 * to care about there're committed data, and the reader will
-	 * swap reader page with head page when it is to read data.
-	 */
-	return rb_page_commit(commit) == 0;
+static bool rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return !rb_num_of_entries(cpu_buffer);
 }
 
 /**
@@ -4132,19 +4114,6 @@ void ring_buffer_record_enable_cpu(struct trace_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_record_enable_cpu);
 
-/*
- * The total entries in the ring buffer is the running counter
- * of entries entered into the ring buffer, minus the sum of
- * the entries read from the ring buffer and the number of
- * entries that were overwritten.
- */
-static inline unsigned long
-rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	return local_read(&cpu_buffer->entries) -
-		(local_read(&cpu_buffer->overrun) + cpu_buffer->read);
-}
-
 /**
  * ring_buffer_oldest_event_ts - get the oldest event timestamp from the buffer
  * @buffer: The ring buffer
-- 
2.46.0.rc2.264.g509ed76dc8-goog

