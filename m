Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579BD28DB6
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b4jbNOet"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-542d5dd0c8eso1379155a12.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 09:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700068625; x=1700673425; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRY8TG/l5J/FMDXcrN4aaEldbJZIXmAxT86BWF/4hG4=;
        b=b4jbNOet5WbxY1nhzutiApU2IA5dGJ3nyAiRU4q3Q/tkmb+EhUILFGZHf8eMql6dwg
         C9GpfOtc9LEGVRmuz6nXjqTO3qGa6sXnir/2ZmFnxPgu0u7mxYRG3zyY69377NleZqaT
         m931y+lVKGIUVVQoadxrGxqgyirlAv4BfrTD25RcalqLA3SvVrlvyux5tui4l5wmNKOy
         a2KWHr/A1i91i9R8A9sa/ZqQYDEoY6bI1hwBYWzRqSg8sh6SUlHD2qnPg+HmHuh6fp4f
         Y/U2qcTa+25MUro4JSt1IV+eu6dWkql/lW9dZ+sDjXzzXxciRkw1rQxcODvvoaOjQGpF
         d+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700068625; x=1700673425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRY8TG/l5J/FMDXcrN4aaEldbJZIXmAxT86BWF/4hG4=;
        b=HecZSHhaVrSQw7BpF0S4dA8DVIWEIjQ4s2MsDR5sib6eq3dLKzZsFuhLh6HY9aCiA/
         JUAS3LrndKDjU00OVUI6OQA0rNyMeLWaOa1ZKn43L5eMR0XrXcIgpppw4zsa0v8ZDnSg
         mndcVIMGaZ+1czPlWWnZHraDTFE4GfL7SKQ+JRQ1c9/X0lv1RjqbluRNg+MgiUSVgfDX
         67f9xu++nZhI0JuM79QzNcf5wFmCyjssjoFt9T0oUmlWdCRgQ21CroBpQH0ykUrrZi0P
         p8NSDu3B+rf8PbCuMvM5O1qw5OLRGpddvXrao7ZXIfQIv2G4MR/1+jDnoS1+M/VjzlPu
         8wMQ==
X-Gm-Message-State: AOJu0YyP5HYl6ob8Zm4w5ru7WIDHar1hSdvJ4hVAXjVevWlT6NlKbQ6n
	2gDIFTTG9wJWTVdhtEGUwUxJB61XQ1JqvXQpdK4=
X-Google-Smtp-Source: AGHT+IEOG5AerWV4vOx8AuRc42o64gL06+fbFGWcKCfeIT2GBbZFlEcOhn/Yr4W2MhCZYOUvUqW8pWEYcTbHukKLs3o=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6402:156:b0:53d:ad8a:b0bd with
 SMTP id s22-20020a056402015600b0053dad8ab0bdmr104536edu.3.1700068625280; Wed,
 15 Nov 2023 09:17:05 -0800 (PST)
Date: Wed, 15 Nov 2023 17:16:35 +0000
In-Reply-To: <20231115171639.2852644-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231115171639.2852644-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231115171639.2852644-7-sebastianene@google.com>
Subject: [PATCH v3 05/10] arm64: ptdump: Add hooks on debugfs file operations
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com, mark.rutland@arm.com, 
	akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	qperret@google.com, smostafa@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce callbacks invoked when the debugfs entry is accessed from
userspace. This hooks will allow us to allocate and prepare the memory
resources used by ptdump when the debugfs file is opened/closed.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/ptdump.h |  7 +++++
 arch/arm64/mm/ptdump_debugfs.c  | 53 +++++++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 1f6e0aabf16a..9b2bebfcefbe 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -20,9 +20,16 @@ struct ptdump_info {
 	const struct addr_marker	*markers;
 	unsigned long			base_addr;
 	void (*ptdump_walk)(struct seq_file *s, struct ptdump_info *info);
+	int (*ptdump_prepare_walk)(void *file_priv);
+	void (*ptdump_end_walk)(void *file_priv);
 };
 
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
+
+struct ptdump_info_file_priv {
+	struct ptdump_info	info;
+	void			*file_priv;
+};
 #ifdef CONFIG_PTDUMP_DEBUGFS
 #define EFI_RUNTIME_MAP_END	DEFAULT_MAP_WINDOW_64
 void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name);
diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
index 7564519db1e6..3bf5de51e8c3 100644
--- a/arch/arm64/mm/ptdump_debugfs.c
+++ b/arch/arm64/mm/ptdump_debugfs.c
@@ -7,7 +7,8 @@
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
-	struct ptdump_info *info = m->private;
+	struct ptdump_info_file_priv *f_priv = m->private;
+	struct ptdump_info *info = &f_priv->info;
 
 	get_online_mems();
 	if (info->ptdump_walk)
@@ -15,7 +16,55 @@ static int ptdump_show(struct seq_file *m, void *v)
 	put_online_mems();
 	return 0;
 }
-DEFINE_SHOW_ATTRIBUTE(ptdump);
+
+static int ptdump_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	struct ptdump_info *info = inode->i_private;
+	struct ptdump_info_file_priv *f_priv;
+
+	f_priv = kzalloc(sizeof(struct ptdump_info_file_priv), GFP_KERNEL);
+	if (!f_priv)
+		return -ENOMEM;
+
+	memcpy(&f_priv->info, info, sizeof(*info));
+
+	ret = single_open(file, ptdump_show, f_priv);
+	if (ret) {
+		kfree(f_priv);
+		return ret;
+	}
+
+	if (info->ptdump_prepare_walk) {
+		ret = info->ptdump_prepare_walk(f_priv);
+		if (ret)
+			kfree(f_priv);
+	}
+
+	return ret;
+}
+
+static int ptdump_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *f = file->private_data;
+	struct ptdump_info_file_priv *f_priv = f->private;
+	struct ptdump_info *info = &f_priv->info;
+
+	if (info->ptdump_end_walk)
+		info->ptdump_end_walk(f_priv);
+
+	kfree(f_priv);
+
+	return single_release(inode, file);
+}
+
+static const struct file_operations ptdump_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ptdump_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= ptdump_release,
+};
 
 void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name)
 {
-- 
2.43.0.rc0.421.g78406f8d94-goog

