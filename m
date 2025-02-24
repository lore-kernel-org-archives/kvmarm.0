Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE29123C8C9
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399343; cv=none; b=GZMzR/ojPwC3bwTFBpItAwpCucLh1MxAkOJYp5bvQpCbdeMQ9XuyuvxhubjV5APNOihY4IdfnYXR0hyqkkLK6OPkOue85x01MkPUujZci3D7Tfeo0N8lXAlpx59e20JcozxYDlNKcvfvELOUE8+6W5WTdIyBv7Po5TYkEPPpMwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399343; c=relaxed/simple;
	bh=ZS31GA9EzXEB/v1lDZyHCoVFCGAVaKAjGLC9nk18GLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mb8e4Vn7VU/2FbVCEWFivm1OiLGk2pr2pN+x4i8MQZFzUGo5jU1HqsOwjgtnbFhZLXhgouCS28FXlttY4cWu+KJVK8nb7T8G5alg5AJSnM2iwG38jou3EqLnVczkQSJhzplFj4akf1tPimjDgWk0p7OqHZsR/Em5ysQGTkhvVCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S6RyyhUa; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S6RyyhUa"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4394c747c72so18250235e9.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 04:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740399340; x=1741004140; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DAhUrVqLivzp9jwXFDW1HJkTiMmByFJAoDrNGn0+mK0=;
        b=S6RyyhUaqmRUrkFYe0voa1pzb1Jf50H5jK89XFqU/J55XHd27iFtAq/gqbtG9RGBKl
         EAjmu0QfBEgnHtwuK+Xwww/gacBc29PqwE8mhTFu5EuNF5dxIQ0i8+gjCBaYb8aZwJ6M
         Q4O7mfe7rAD7wW06xG2ajCT82lMO/Oonm/H4HSF5zB+jNm3Oe9EESZg5ZUApMgYuL8Oi
         bBA6dKs/9yUJ9bm9R5lsgXOcWcVtJZhDsolfEu7K6JmTEPNeagzAmmxRgo1YlyAGl42Y
         0x342nrYxhwzECx7jsU80ioxLFsWxA8se0v1kboJwYFFpb8StiLD9iKYj6AsS29K2dQ/
         B+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399340; x=1741004140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DAhUrVqLivzp9jwXFDW1HJkTiMmByFJAoDrNGn0+mK0=;
        b=kQJpkNKDQnd+2CNPHDg5QRE+pYEUv527qAMcQ4mK0MOB9JcaWQgRxaygtWG3v1prO1
         t+v2T2ChCM7OlfkNzZzKRtsdJokPCMSD9/gGd2JdmZGOCi++ho4nJgpQS4OjB+JTvV47
         moJL1uPyLZcHTrmpLrQR6opnikxiLXSBb7NI03a1Dh7sjmzfo6aXCe2YXeSBlJ/0hBew
         O1tet+aBhnq1S0d7n52jlvRO1PBgvqdhyicCgeJRxAWTr3OcG93mw8jYXQNBM7HeKesf
         6UMGokbSxyw6UONUdY3fS6tSZIbloFKvlUKEOYcSXGeOMefPi5+vPCmbIf5GtrccDYE3
         WUqg==
X-Gm-Message-State: AOJu0Yy5iULHXA7YV7bA+BWfMuoLAtDKFlHwtL0XL1C6YO6Fiwp2Zhe0
	4wWdKOXigNVg/EeGsbDRs+w7A0Cf4YrqDy5k/c3TY/CYtte5NQFMS4oLxejsjvs5B32qb1PEqnJ
	1e9ozN3A9p0QEvMThrA==
X-Google-Smtp-Source: AGHT+IHQGpayqqEkTmw/Zvqr6LdF1E/ueJfO1lglmZUQzjDwUDQWHOMK/KK1dg4emFnGMwfhnTYT5JRRxbk4ic04
X-Received: from wmbhc15.prod.google.com ([2002:a05:600c:870f:b0:439:858e:8ce6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e23:b0:439:987c:2309 with SMTP id 5b1f17b1804b1-439ae221d7dmr101374675e9.27.1740399340381;
 Mon, 24 Feb 2025 04:15:40 -0800 (PST)
Date: Mon, 24 Feb 2025 12:13:50 +0000
In-Reply-To: <20250224121353.98697-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224121353.98697-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250224121353.98697-9-vdonnefort@google.com>
Subject: [PATCH 08/11] KVM: arm64: Add raw interface for hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The raw interface enables userspace tools such as trace-cmd to directly
read the ring-buffer without any decoding by the kernel.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 3f91ad69c25b..38d97e34eada 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -746,6 +746,85 @@ static const struct file_operations hyp_trace_pipe_fops = {
 	.release        = hyp_trace_pipe_release,
 };
 
+static ssize_t
+hyp_trace_raw_read(struct file *file, char __user *ubuf,
+		   size_t cnt, loff_t *ppos)
+{
+	struct ht_iterator *iter = (struct ht_iterator *)file->private_data;
+	size_t size;
+	int ret;
+
+	if (iter->copy_leftover)
+		goto read;
+
+again:
+	ret = ring_buffer_read_page(iter->trace_buffer,
+				    (struct buffer_data_read_page *)iter->spare,
+				    cnt, iter->cpu, 0);
+	if (ret < 0) {
+		if (!ring_buffer_empty_cpu(iter->trace_buffer, iter->cpu))
+			return 0;
+
+		ret = ring_buffer_wait(iter->trace_buffer, iter->cpu, 0, NULL,
+				       NULL);
+		if (ret < 0)
+			return ret;
+
+		goto again;
+	}
+
+	iter->copy_leftover = 0;
+
+read:
+	size = PAGE_SIZE - iter->copy_leftover;
+	if (size > cnt)
+		size = cnt;
+
+	ret = copy_to_user(ubuf, iter->spare + PAGE_SIZE - size, size);
+	if (ret == size)
+		return -EFAULT;
+
+	size -= ret;
+	*ppos += size;
+	iter->copy_leftover = ret;
+
+	return size;
+}
+
+static int hyp_trace_raw_open(struct inode *inode, struct file *file)
+{
+	int ret = hyp_trace_pipe_open(inode, file);
+	struct ht_iterator *iter;
+
+	if (ret)
+		return ret;
+
+	iter = file->private_data;
+	iter->spare = ring_buffer_alloc_read_page(iter->trace_buffer, iter->cpu);
+	if (IS_ERR(iter->spare)) {
+		ret = PTR_ERR(iter->spare);
+		iter->spare = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+static int hyp_trace_raw_release(struct inode *inode, struct file *file)
+{
+	struct ht_iterator *iter = file->private_data;
+
+	ring_buffer_free_read_page(iter->trace_buffer, iter->cpu, iter->spare);
+
+	return hyp_trace_pipe_release(inode, file);
+}
+
+static const struct file_operations hyp_trace_raw_fops = {
+	.open           = hyp_trace_raw_open,
+	.read           = hyp_trace_raw_read,
+	.release        = hyp_trace_raw_release,
+};
+
 static int hyp_trace_clock_show(struct seq_file *m, void *v)
 {
 	seq_puts(m, "[boot]\n");
@@ -800,6 +879,9 @@ int hyp_trace_init_tracefs(void)
 
 		tracefs_create_file("trace_pipe", TRACEFS_MODE_READ, per_cpu_dir,
 				    (void *)cpu, &hyp_trace_pipe_fops);
+
+		tracefs_create_file("trace_pipe_raw", TRACEFS_MODE_READ, per_cpu_dir,
+				    (void *)cpu, &hyp_trace_pipe_fops);
 	}
 
 	return 0;
-- 
2.48.1.601.g30ceb7b040-goog

