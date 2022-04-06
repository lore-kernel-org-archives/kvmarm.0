Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FCEC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 23:56:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7916A4B208;
	Wed,  6 Apr 2022 19:56:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xFLHGQrD8yj3; Wed,  6 Apr 2022 19:56:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 679D44B1D5;
	Wed,  6 Apr 2022 19:56:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 326FE4B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 19:56:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yzDMU08gh-oI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 19:56:24 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AF0449EF0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 19:56:24 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2eb2bc9018aso34721097b3.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 16:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=UE8U10PWA5ODRXn2/uykVggaoFMEeuBNkjbyKzrUnCc=;
 b=StweytVoVyZbt90ESUuB2VGZmpz69UiQywLFR+/3fhQYHNUTdQZloEgP4cirg0Kkhd
 ureLULbzCXKzEuVeyccV7zNNedLEQpO4ayhcybXsVmgxDbgKCBrnsMt4KcoGFXliCiDL
 p0yS3x603eqH2cuF0Jfgeumy6ZZXE4/Odao00WPCwWYzuYVheUOvU/y7PhYbkklz5J8P
 spP+ZBEnX4drhVit+1wCy6T9N9UoRJEFMu/pj0F3D0FqfNpLHeAMKkavfelwlloXm8Ki
 mtOpj9fHSSXtZbEZUujQ5kBOBV5TtTSNk278FllAny6hV6Rytjamf7Z1WSwRNnqUdxFb
 gBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UE8U10PWA5ODRXn2/uykVggaoFMEeuBNkjbyKzrUnCc=;
 b=LrkgLuZTtCt9kLUVY0vEzkBvIj/ZDBR1jk9aA095tnPtBhUth4TntocW57PyJTXjF4
 rVKl6cIY+BIMm3ifRkUHgI93b6XQaHQBWiZOWw0Hqc90cn291jplO0L1FCr8+mtPH4c4
 nTNp+Wz6ZS/+duAfO8sTkwVBp9tjYrCFyWvVUe716AuBMbUZFVsjKVG9vLBGgFtBdZ5b
 r3GFi9fBEkSbSsZtsQUF4mPH3XEapNEocxqqU1+iX60RI282s1A4kOW4ZmoUehzbPzih
 fCa6jFkR9A+C16i2nQ2FpMM5zJCrYQ2cgj0aHJGBSoZRO5lFNSAzp1crZ/4jtakrEI7s
 PlMQ==
X-Gm-Message-State: AOAM533bh9cOz3tFf3vTEpSIi4SGjYDEimjCScBB8oeKoydSs2Tn0aqm
 xpnehIPVzvvLX3eBG42B7qPhwnAKbS7l0ong/91bvXLiB3MylRbn4an1E+VOf51VP7pjg0juQVd
 crWFRbSuhy45VFi46+ZlSTLIDFh3ZM+7Twdu1Ex4Fc2RPvFc1OI8CbVh53Etl4umPVXuXRQ==
X-Google-Smtp-Source: ABdhPJydvJQ9YWsazIPz0K7K9LDxhja6MJh+d1QgvhsxpSx1I3YpvuashAMC5XHLhA33/FRzcSzrmPBE1A8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:100e:b0:637:7536:6582
 with SMTP id
 w14-20020a056902100e00b0063775366582mr8357978ybt.355.1649289383593; Wed, 06
 Apr 2022 16:56:23 -0700 (PDT)
Date: Wed,  6 Apr 2022 23:56:13 +0000
In-Reply-To: <20220406235615.1447180-1-oupton@google.com>
Message-Id: <20220406235615.1447180-2-oupton@google.com>
Mime-Version: 1.0
References: <20220406235615.1447180-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 1/3] KVM: Don't create VM debugfs files outside of the VM
 directory
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 stable@kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Unfortunately, there is no guarantee that KVM was able to instantiate a
debugfs directory for a particular VM. To that end, KVM shouldn't even
attempt to create new debugfs files in this case. If the specified
parent dentry is NULL, debugfs_create_file() will instantiate files at
the root of debugfs.

For arm64, it is possible to create the vgic-state file outside of a
VM directory, the file is not cleaned up when a VM is destroyed.
Nonetheless, the corresponding struct kvm is freed when the VM is
destroyed.

Nip the problem in the bud for all possible errant debugfs file
creations by initializing kvm->debugfs_dentry to -ENOENT. In so doing,
debugfs_create_file() will fail instead of creating the file in the root
directory.

Cc: stable@kernel.org
Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e05af5ebea..e39a6f56fc47 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -932,7 +932,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
-	if (!kvm->debugfs_dentry)
+	if (IS_ERR(kvm->debugfs_dentry))
 		return;
 
 	debugfs_remove_recursive(kvm->debugfs_dentry);
@@ -955,6 +955,12 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
+	/*
+	 * Force subsequent debugfs file creations to fail if the VM directory
+	 * is not created.
+	 */
+	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
+
 	if (!debugfs_initialized())
 		return 0;
 
@@ -5479,7 +5485,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (kvm->debugfs_dentry) {
+	if (!IS_ERR(kvm->debugfs_dentry)) {
 		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 
 		if (p) {
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
