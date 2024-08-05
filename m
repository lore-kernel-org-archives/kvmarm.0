Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925E615ECCF
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879237; cv=none; b=gH6k5JPrVSLlSsQzRcXHRn1+sjEd6JCmBTp6Itf89dH+ONiG9842xFeACdRekT0zPMr8lmKtByRoLliu6/Tj765ADEyHigqBWAepkDih9BBZK7xf+qVUyxsG6WDT2NCudJ/t2gLRP3ovq7iBe3U2NH+NxMbiExPUqCT1Ize5tZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879237; c=relaxed/simple;
	bh=OiSpS4ai9igT95TM6UTKgbAM28v6H3FL/Ec08qgdAZ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JRkZSydTR+lPZ98bmcfWNCUVDmzfNBX9CJXm/f5oJ0oHbWqsXACcDd+0oyCkOEqG8kAfPXftyb4LjdljwOQaVXuslUEvNxw3YboiM5h7LIQsfvJ/SC3/dn1GWFfRVoRbbd+4Mt36HE7a6sCRy5GyfLjTOMS4jP5BHaZam+RIn9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K8xbDqOm; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K8xbDqOm"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bebbbebeaso5792454276.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Aug 2024 10:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722879235; x=1723484035; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nHtiY8g6zc3G3UhjzfB0dFEogvNBRel6lFn+Ika4PDs=;
        b=K8xbDqOm3isJoJuVv2xeXyZWVLGy0nnqXgrXRhiGKMn37besD4diZpnzKJfnZxyT3V
         kn9sU1rmZ9Q8L3sPQivpV619HrY6p/cVMF/5mfj3NMwUpNl0NKVLRvtY/dlZiBGJH7VN
         7lZcvuEx0S5+Ax1uxZhxVhPfZ3RabJ5LLw4U0jnLQJ5/U2SSacHAmDJQ5KBwej5Q0vck
         kM/mGi3sgc6zdcir9/2OFlfk/EKl8B3vnJTPON0ElsxNn7lKmQ4HdwmfFRzjQlw3t+q5
         Q++t8h1BRXa6mJEZiC2VZ7NAlgCNuSoIcgMYI8AsecdVxz15+CfRK+bMXV2uZCIDDvtR
         m2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722879235; x=1723484035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nHtiY8g6zc3G3UhjzfB0dFEogvNBRel6lFn+Ika4PDs=;
        b=OVo7bl88wM8DnGmeAKiTVsUUGFDvedHZswyyYcJTKuuKlafleU8+T49CX/AxqnZNsL
         JVEZPD9TAMnygGL/0u77xNe2oa05qmtB2F3Ecu7XbEgliTbU7vNs43qWlccXWLaxRI5+
         we3dzdzN6pDy7/MPfxF4dGw/UXoQD8TIhucA5Y39xRbqjOLo8dZuwX/8DI93291Id0s1
         iTFg+qIqGr+gKycYXyTTlgVMAzVZCLSuyEJ/sr9Tynw0aAMM5owEJD6qU5jNtf9ndi0z
         6tZ+0TMcAkllM96O92hKrspglthBVe3Zd+Xtrhksb1P0uAPHO50K5QLKXUw2YIaZA515
         cIoQ==
X-Gm-Message-State: AOJu0YxW/Nh4Qn0SxrtJbsSh5xEtKjmsbrz37mFXJKwUssZ4WT2Sf0BE
	EY7T/OHFdJQG/kXCqL1ppgEBAMPAPyBzqlI4/+0Xn+nDgzAhxRBnsryPp43zT/HCKcvxNabNSgs
	1kTl31/Qs2Wdy5/BHFw==
X-Google-Smtp-Source: AGHT+IHAQn5scv+G1NulbR0lmlvOBq0nClmk6CxynmTzmIrwTJIS3U1ZoFNFwdgeo0LWSOfI0EvpGenXBHeD6ddc
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:6902:1b90:b0:e08:6e2c:69da with
 SMTP id 3f1490d57ef6-e0bde229235mr113410276.1.1722879234720; Mon, 05 Aug 2024
 10:33:54 -0700 (PDT)
Date: Mon,  5 Aug 2024 18:32:32 +0100
In-Reply-To: <20240805173234.3542917-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240805173234.3542917-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805173234.3542917-10-vdonnefort@google.com>
Subject: [RFC PATCH 09/11] KVM: arm64: Add raw interface for hyp tracefs
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The raw interface enables userspace tools such as trace-cmd to directly
read the ring-buffer without any decoding by the kernel.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index b4de7650cd8f..36c120aeabc0 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -649,6 +649,86 @@ static const struct file_operations hyp_trace_pipe_fops = {
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
 static int hyp_trace_open(struct inode *inode, struct file *file)
 {
 	return file->f_mode & FMODE_WRITE ? hyp_tracing_teardown() : 0;
@@ -723,6 +803,8 @@ int hyp_trace_init_tracefs(void)
 		}
 		tracefs_create_file("trace_pipe", TRACEFS_MODE_READ, per_cpu_dir,
 				    (void *)cpu, &hyp_trace_pipe_fops);
+		tracefs_create_file("trace_pipe_raw", TRACEFS_MODE_READ, per_cpu_dir,
+				    (void *)cpu, &hyp_trace_pipe_fops);
 	}
 
 	return 0;
-- 
2.46.0.rc2.264.g509ed76dc8-goog

