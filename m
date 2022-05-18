Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F52EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 18 May 2022 17:59:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1F7C4B327;
	Wed, 18 May 2022 13:59:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9VLMxsW06ql5; Wed, 18 May 2022 13:59:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938814B328;
	Wed, 18 May 2022 13:59:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D8B4B326
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iOYb3OWcZsBD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2022 13:59:14 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C71C14B31F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:14 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 a37-20020a056a001d2500b005103aab8d65so1481322pfx.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 10:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OZkEtfeO16+WBXKIrEVzWaZgX0pGEVfJdhpX9jyjq9s=;
 b=XJnCL2DYM9o+Jy3j+sEoMXrtNq6JAflArhwOtUHIjrEJ8kcHsgAPojP2qMv6peZSpu
 AVnDrXhMKunZ+7DZv8Ykv0Xkyb4dOPzi3bZnMCqecQ2bk5JiSZNRSl5Ll4UYCVlHOF9l
 vrMxF6Hgc8ELAaEsQW04jMYqjYJulXTOreiHeNdsa5Zv6D+y5WW11Ee6AKmwybmm8JX1
 SBi5k0bDcYSbA9Q4cQNcBwwYLFFiPoU6k2ncYTfq6vQQGTST7+g+Ay8IDn63zRbNrdUq
 VdqpFcYBnP9M/mrXKdjnnCiIAKV+DZB4adpHjcpMLZeJb3vOBQodZed2QVril2oAvOZP
 CQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OZkEtfeO16+WBXKIrEVzWaZgX0pGEVfJdhpX9jyjq9s=;
 b=qKV9rwpQBvCr5nrzjSYqgT27C89UncMAjlNUNW3y174Eq6HEZ8bI/OQzFwrNODK7/G
 jHATCvZG14EGZejNtNG5paIfQiOxAWGjKN3gzDHxyp/qTcJBMKkCjNdahIC6xwjf3KXx
 6gbfoCmk1NFg78C4QV5rdpBnBYzsVdZth1ZwZs6i95LO5yNNNtHayT+tjykocMZadFfZ
 cN4KSI1PEIytER+YVJzt0469BOvnwECAqvqZoSKauW6FsQny2bW9Voktt4k5tqHq2J8Y
 AlkVnWZacAhk4amAjV95gMtj7kKo9p4Sqw/QjwJpIXz4X4nvZRa9aIsMD1UqbHpfWecd
 ehTQ==
X-Gm-Message-State: AOAM532WD8gBl1aQ9kiNA2Na7hjrZbWVcDd0qGihcK3gIO9Wl55MrAU3
 dZ7/Hgs7cso8vGqKB0Sdw5JX2PKiyfY=
X-Google-Smtp-Source: ABdhPJx5Hvz7aJKam/sS0xyXJXyVtOFQQc1blLiFh+vfuuj+mPAMcQ+wZ2ANZdo1mfsv8fBY7dTmpQyN9J0=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:22d4:b0:510:6d75:e3da with SMTP id
 f20-20020a056a0022d400b005106d75e3damr520307pfj.3.1652896753816; Wed, 18 May
 2022 10:59:13 -0700 (PDT)
Date: Wed, 18 May 2022 17:58:09 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-4-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 3/5] KVM: Get an fd before creating the VM
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hoist fd init to the very beginning of kvm_create_vm() so we can make
use of it in other init routines.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 778151333ac0..87ccab74dc80 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4774,25 +4774,27 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
 
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
-	int r;
+	int r, fd;
 	struct kvm *kvm;
 	struct file *file;
 
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
 	kvm = kvm_create_vm(type);
-	if (IS_ERR(kvm))
-		return PTR_ERR(kvm);
+	if (IS_ERR(kvm)) {
+		r = PTR_ERR(kvm);
+		goto put_fd;
+	}
+
 #ifdef CONFIG_KVM_MMIO
 	r = kvm_coalesced_mmio_init(kvm);
 	if (r < 0)
 		goto put_kvm;
 #endif
-	r = get_unused_fd_flags(O_CLOEXEC);
-	if (r < 0)
-		goto put_kvm;
-
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
-		put_unused_fd(r);
 		r = PTR_ERR(file);
 		goto put_kvm;
 	}
@@ -4804,17 +4806,19 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 * care of doing kvm_put_kvm(kvm).
 	 */
 	if (kvm_create_vm_debugfs(kvm, r) < 0) {
-		put_unused_fd(r);
 		fput(file);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto put_fd;
 	}
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
 
-	fd_install(r, file);
-	return r;
+	fd_install(fd, file);
+	return fd;
 
 put_kvm:
 	kvm_put_kvm(kvm);
+put_fd:
+	put_unused_fd(fd);
 	return r;
 }
 
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
