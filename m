Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A351534E8
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 12:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973174; cv=none; b=AWk+fHnSf26+VsO+fka1yHYi8NawaRfhaEX1ljJ8ZZxjVGkS2lvTu5SJtI3jgjIGSnkmOxldvj74LhClGqsI0V9S4IcjQfi37QIH4R0pzxTURz0i6sCpVYiA3iQY5yzPvV6+j3xWQEan+bfA0BLUP8nYlS53FgVFnOn/sAWEbsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973174; c=relaxed/simple;
	bh=VKEiAQ5rnCpzkwoGU9Kf5JbSpYjqjdSM0fujBxiasBI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=isyMV7LdiwePaImRstNKy+Yaot/T8SV+dyCRV4IYF3+gjIvcb2vs3JhJi8FHUhTvVhxmALHfKoCQoAoqcA3slFMjGqXh6hgLeqLd9YuXI7ju126fsvRQIjoh5fA+VGWFYHLq5ZuAdPjQyenMFAWjwW3kqlO2C0s9MVwsp7G8shw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E1omcTI9; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E1omcTI9"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfab38b7f6bso3090468276.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 05:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718973171; x=1719577971; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GaoTyRJP5MVoQ4Wx1amDUxzz/OCpulWviUJ5XDAG08I=;
        b=E1omcTI95L2HhFEHfZdinclDHOT2yn9ylyhfVDNxM/ODyVkefwJ4oaX6xnjcISngZe
         rlxmbCEhzRTl23kT9byrrIKfB+paoBtfqyh6c6j/OhQikvfO6NbbOomznVi3oWsDYv5s
         LVs9orHhxRrMFHPmnKmDfGwWahMUJaZwWE1fVnhzU3MdZgnwiMvCll1Cgs3Vz/D6SNoE
         q+zsXlZkHQImk42SCF1sJmYhGY91Sn6+BZh+XB9Wt8vLSrRoxalEciDiAEzNPBHpFqF0
         Ea6Nq96c/z+3ybsp/Tfp133kBTuLhULm3vgoPzyCyfsrOiD0V+Nj7GPMETHrCV+9nMQL
         HcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718973171; x=1719577971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaoTyRJP5MVoQ4Wx1amDUxzz/OCpulWviUJ5XDAG08I=;
        b=bBrDCFjX+O3y8m+8g5DqD9PDNXiOLHhNgxVJ6Lb9ZAajXLfJikryRWQm8C6CmR0s6m
         3cZQqLXy7nNvsedfIKWNev1B8KC3N5cMwKz0eA/IqzF+Ucw1t8xJHWwtj/f69PXwWBBt
         yES9txOJiJGi7XBXXEELORorXnwOD5ZssR3iqBJwn9nCcmf9sJ+Cvj62EpOsnAJ2mMqp
         metY00lBxExDCaPKOquGJiz+DCSoYX9Q2G43nEvkwBOpAKVGWw8qUYn7ZyPw9LWsglKp
         p4bbUFaKwNnQ3WVruZxoy6fgmTl1/TaBQT0Wk/be1uPZn32YpbaeAv4sT7BjrOE7Ykrj
         shmg==
X-Gm-Message-State: AOJu0YxADVGb0eg+yCm9fO3OTHc1SYia8WxlacOXH3CKN6fJ+3y9LZye
	/TsEuRiwqe4pZj0/CDK3gQvw30nWNEErooRtOvjTf+kGjaDv3c+ZxQPbGd/UKcROofhAJMZmVrz
	8fI8BoNyEImvlw1/fVuyILbERjw==
X-Google-Smtp-Source: AGHT+IGj7AHqrKDUhBWO+SmknG8+pCJKbMlt4EBG61XGF63G72cpdFy+hwEXTIOexf21bNWp4h0sUsTwv0bTgFiHF64=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:2b12:b0:dfa:7278:b4c4 with
 SMTP id 3f1490d57ef6-e02be18dd87mr1713995276.4.1718973171319; Fri, 21 Jun
 2024 05:32:51 -0700 (PDT)
Date: Fri, 21 Jun 2024 12:32:30 +0000
In-Reply-To: <20240621123230.1085265-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240621123230.1085265-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240621123230.1085265-7-sebastianene@google.com>
Subject: [PATCH v7 6/6] KVM: arm64: Expose guest stage-2 pagetable config to debugfs
From: Sebastian Ene <sebastianene@google.com>
To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, 
	ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, 
	james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, rananta@google.com, 
	ryan.roberts@arm.com, sebastianene@google.com, shahuang@redhat.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Make the start level and the IPA bits properties available in the
virtual machine debugfs directory. Make sure that the KVM structure
doesn't disappear behind our back and keep a reference to the KVM struct
while these files are opened.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/ptdump.c | 50 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index cc1d4fdddc6e..17649e3cbc8f 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -215,8 +215,58 @@ static const struct file_operations kvm_ptdump_guest_fops = {
 	.release	= kvm_ptdump_guest_close,
 };
 
+static int kvm_pgtable_debugfs_show(struct seq_file *m, void *unused)
+{
+	const struct file *file = m->file;
+	struct kvm_pgtable *pgtable = m->private;
+
+	if (!strcmp(file_dentry(file)->d_iname, "ipa_range"))
+		seq_printf(m, "%2u\n", pgtable->ia_bits);
+	else if (!strcmp(file_dentry(file)->d_iname, "stage2_levels"))
+		seq_printf(m, "%1d\n", pgtable->start_level);
+	return 0;
+}
+
+static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file)
+{
+	struct kvm *kvm = m->i_private;
+	struct kvm_s2_mmu *mmu;
+	struct kvm_pgtable *pgtable;
+	int ret;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+
+	mmu = &kvm->arch.mmu;
+	pgtable = mmu->pgt;
+
+	ret = single_open(file, kvm_pgtable_debugfs_show, pgtable);
+	if (ret < 0)
+		kvm_put_kvm(kvm);
+	return ret;
+}
+
+static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
+{
+	struct kvm *kvm = m->i_private;
+
+	kvm_put_kvm(kvm);
+	return single_release(m, file);
+}
+
+static const struct file_operations kvm_pgtable_debugfs_fops = {
+	.open		= kvm_pgtable_debugfs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= kvm_pgtable_debugfs_close,
+};
+
 void kvm_ptdump_guest_register(struct kvm *kvm)
 {
 	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
 			    kvm, &kvm_ptdump_guest_fops);
+	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry, kvm,
+			    &kvm_pgtable_debugfs_fops);
+	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
+			    kvm, &kvm_pgtable_debugfs_fops);
 }
-- 
2.45.2.741.gdbec12cfda-goog

