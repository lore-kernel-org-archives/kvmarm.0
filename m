Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0E1186E4F
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 09:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047070; cv=none; b=STRYCnnf0oSyln8cD6Fdx0CAf+BB3imP2CLmNTwzBgdMu3m23tl1+KApOQI8Q4yfHOd07BXDzzMuskxF7WUxR6EpywOnFfotfBMs61lkCjF2OddC/FaXqnPYyoAFY5j7/+CTofzQmE3SR9uxt8J6tu+/DXS7iye6dfBVdfJUBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047070; c=relaxed/simple;
	bh=+C1Mr6Eih+8GBOgaIA5ob9ph+NaEjJpwr6bdsWTV2h4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kztnGNsqrpKpbKQvQZLyXX3sKaOsb9cEz5Q5PRf6tubPPr/+qaiBb676SEcN2u0ruqmigv6XaIabPO82BYaK8cs5Sku8XcPHNrK3q9UbbNnbU9RFaVGrwGTcoA7cvZJTqbocb51bpikCZfR2qbR76Q/Ix4qiZBzPr2ioUV7Zt+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BZFix/St; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BZFix/St"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6db7a8c6910so91474367b3.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 02:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726047068; x=1726651868; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hy3Znb+Dwqyrq2cJ7HorL7uStGBaHWkuWbAR2JZBqCQ=;
        b=BZFix/StczZ+mqXR7qg4uGAIGMtXggP7tvbfacMoysy7JL70hlV1oC85ur6ov8le3U
         vE1SAUxOci9gU9taYjXkW8AmI96XyKfToI2jNIKxPrhQJ4HprDuYjLVD1sEKWz5QrwK5
         YkqVLXTWBS137GDl971S7SMgi3ETVQmraAe3ansaWgjYQVSQNqwGx5nOi9N5JdaUMtvo
         96n0+OnJmkKS+LLcr5ocfHBkEReE1exe+ODueI7CGSv+if4aPyfAj5GciU977H0/lKxb
         bs0nbrVgH1UwbrdnEmKCwrZuVhCmbb5k+M0EpXQouG7RJV/D4Yw+IZTmNfZoRk42q087
         1kcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047068; x=1726651868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hy3Znb+Dwqyrq2cJ7HorL7uStGBaHWkuWbAR2JZBqCQ=;
        b=Ps02EX5Gtw4qCi/5R1l9BKSXpERxqqVlWCOltws0QrIjN/MTK42G1D0bP24VqzvsYp
         5VDbSY5YFIrHMQAPeIv2ObPypl34W8I68ksGsyjDN2aD59Ubm2E2mF9nECb9lz1+hfag
         CgECJOQG7OpGkgXNL0i8QBT/1WsNg+3xIhVmR8PPjzJyMq65BIp+J7Xmk13sYTfBpSaa
         iyGkV5+MTBh5lB5o/IQrtxBah7m2qHehGrNXIE61NXGSVSQv93sPSbiyXqgEJzJHK3Dz
         gG/fBszACdIkGxFUuq4KxavPwwwRGxyQRqMiRYuiaLdm9i0FQUf8stNYESlzsOSNNw31
         OyXg==
X-Gm-Message-State: AOJu0Yyggx2K3H7q7giDQsI5mRZ6unKWQrdQfVbypsnNBmIZCG4eETv2
	1hk4Q03Iiuncdy5wDosO6/zGJ5ZzfXXr4Xivxxtgpi7GlgliEN98UNAK+AWxlTDuW6YmAkBKc4j
	S0QcEnS92Um2BYfMq0A==
X-Google-Smtp-Source: AGHT+IFSAGx//hRZK4AAM97oklvEIfq79G7ievWf/yDgvOrEXJqZ7cy+6snJMt8gT5Wm1/gNBfGcYxIfKSWjx/Ue
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:690c:2f89:b0:6be:9d4a:f097 with
 SMTP id 00721157ae682-6db452739d0mr2138547b3.7.1726047068233; Wed, 11 Sep
 2024 02:31:08 -0700 (PDT)
Date: Wed, 11 Sep 2024 10:30:26 +0100
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911093029.3279154-11-vdonnefort@google.com>
Subject: [PATCH 10/13] KVM: arm64: Add raw interface for hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The raw interface enables userspace tools such as trace-cmd to directly
read the ring-buffer without any decoding by the kernel.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 1720daeda8ae..0d0e5eada816 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -740,6 +740,86 @@ static const struct file_operations hyp_trace_pipe_fops = {
 	.llseek         = no_llseek,
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
+	.llseek         = no_llseek,
+};
+
 static int hyp_trace_clock_show(struct seq_file *m, void *v)
 {
 	seq_puts(m, "[boot]\n");
@@ -794,6 +874,9 @@ int hyp_trace_init_tracefs(void)
 
 		tracefs_create_file("trace_pipe", TRACEFS_MODE_READ, per_cpu_dir,
 				    (void *)cpu, &hyp_trace_pipe_fops);
+
+		tracefs_create_file("trace_pipe_raw", TRACEFS_MODE_READ, per_cpu_dir,
+				    (void *)cpu, &hyp_trace_pipe_fops);
 	}
 
 	return 0;
-- 
2.46.0.598.g6f2099f65c-goog

