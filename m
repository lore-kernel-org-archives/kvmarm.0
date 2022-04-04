Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DA6C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 18:21:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCDC54B2DE;
	Mon,  4 Apr 2022 14:21:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eDEKk5oJJjnI; Mon,  4 Apr 2022 14:21:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8CC74B2C8;
	Mon,  4 Apr 2022 14:21:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96EF14B1C5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 14:21:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MrbEtBMxnm8a for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 14:21:29 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 707B34B1B4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 14:21:29 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 q137-20020a6b8e8f000000b006495204b061so6831493iod.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 11:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9C6w1rezdQTRbXbtrJY1SOnX+wuE5x8FHrvORNXkiH4=;
 b=ntCvfuIdi9xMnMJP+WEKYAhtFIzNV0vgJkusexYCHVXmFsHxjRL0ss7NhSk+fRH55U
 IOVUf2f/dRvRvNUW8QStwvlNrurraZnMphm1VQ5851zbUGzrqT8d4cFxbhOP8vn/G+8w
 fYDJB9Rxyhu+dtkt733HYqDqzN0cNBBuG/RDzaBHjtz1lf8He19cAQunaA+tgo0ZkWqj
 nHmF5lg/twg67wMwdeQKzJW2OZCiSL+/Gp9K+7ik47gg7kTJlOLrCUwmO42RVRKax3/6
 WKnNSA2mnNTHeyQVF4+axB8WRxkGTfeRQFfs7yonAUtqLzbwxah4SnDga35oAG2BGmbE
 8fKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9C6w1rezdQTRbXbtrJY1SOnX+wuE5x8FHrvORNXkiH4=;
 b=FphVZDMLQ0uiEWjzsHRAPfN4Feg2qoO/6tv2UNxOwpcRklwn29FJkV4EhWrnR/gw/f
 H1MI2hwP+v05PfkIv6D7tHTYCHPsy6pDC+W5bUCFpmdN2SWgXJFzWPS8ivtsDwDHEqGJ
 wNeKfZMl5Bh0+kes6h0chuqNRcRMHCGhFXe6cHVSKJdzOYikzYHAQUF4twV2bncvRshh
 Km29fP1C3BRELoJ7b7CPWMK0ifSALehhnYJOqkvw8xcOwcBXYU0L4JzR4VjX5k5JJLFs
 gq43ENdu0RWwU90z/f7Id4OBtEGF5LELirwcgEi5ukSqEMKNzTkPpnPu6LahZn8GH7j1
 pgxw==
X-Gm-Message-State: AOAM533eyGO2UqWPKujUuyCyH7QiqDPBtMCCIiXqwZFwdlv8vCNwDshj
 0Vum5HGJjPmU0QLzgyhBghGMMQnyop+ZjKP0PKH7J0cNKo1XHUWf/WA5rILiD1dZ0vCu9bmSnLm
 xUdOyiAnL8V3nzQBObT9KzGDxijYhc4bzanjZ49LX+vCQxnbpI+Xi06QWkQxF5l2OsMfszg==
X-Google-Smtp-Source: ABdhPJw742AYzEqFaE6euki5t9MMfZCGGI9PjjeQy1BTQ6eXyn3wAYraEjyHb6JW9iO7D2ml2hNsob2+TpA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:17ca:b0:2ca:42d8:81d
 with SMTP id
 z10-20020a056e0217ca00b002ca42d8081dmr510403ilu.249.1649096488828; Mon, 04
 Apr 2022 11:21:28 -0700 (PDT)
Date: Mon,  4 Apr 2022 18:21:17 +0000
In-Reply-To: <20220404182119.3561025-1-oupton@google.com>
Message-Id: <20220404182119.3561025-2-oupton@google.com>
Mime-Version: 1.0
References: <20220404182119.3561025-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 1/3] KVM: Don't create VM debugfs files outside of the VM
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
index 70e05af5ebea..04a426e65cb8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -932,7 +932,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
-	if (!kvm->debugfs_dentry)
+	if (!IS_ERR(kvm->debugfs_dentry))
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
