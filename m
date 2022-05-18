Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD71C43217
	for <kvmarm@archiver.kernel.org>; Wed, 18 May 2022 17:59:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC9274B32E;
	Wed, 18 May 2022 13:59:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n1BVJrl4+HLc; Wed, 18 May 2022 13:59:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D12134B343;
	Wed, 18 May 2022 13:59:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A05A64B324
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rq+vMfjP2BjZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2022 13:59:17 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 948F54B329
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:17 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2f4e17a5809so25564507b3.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 10:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wW/lYQK8VggoySTpe050tppXxqMna8Q7adRf7tVfVhg=;
 b=m7dz77VdABiVhTzfZaIE0LeeSvBl6t9Qe9hFsM9WYPe2IsqVOFN0CjpDqYmVm1IzVX
 lelo5I7GsEpdephGyPib6OfJPar543AGL0CyQXWm2mTzukn96l0CaUGRcaEOct9no4gO
 A5XScGLwYy9u48ePPFPh9hkTcjAZhnjw3riCuKtzo/lwuxduEUHbGS8vcrjl+dnb4m/L
 oQ9v7L4h//c5pAgL60dEsnNWnY/WfTj7W882amwZSRc96CGohagTca7JD1NDTSWfJdbr
 CdudJwHuEyUAeeTt6e34RcIMt4Y+q28oZCqtghHRxw8q7PFELQWtHBN7BZazYF49ApTU
 Mr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wW/lYQK8VggoySTpe050tppXxqMna8Q7adRf7tVfVhg=;
 b=dR/pAgN+CYmtC7RJwEl0/BmtcLKmovYAc5eMp0lgaoXyOi4LXP2DkdMJ/rCLy3cAS/
 M2hT5Swj5pNOIvxuDOYiVP2LLVhmZIJB6RumGJCjzysYMAGLsJ0lwZFWDx9mRHekntrr
 QA9jkrfl7ahcpu+ttERtFOWuUtU3vZM4+OgRtN5lzEs0Lny21sogRJMDR2qE3I4rHDyz
 bS8jlCVe0XfEh5iyqqS1kjsjn+p56oNqUgGB1yn3R+zaQmWbbO/x/lZq9qafbmJQbojL
 Odzr+GrJqjY1uZfod6VqiYJkHgPHvRA4rUMYpqdgyjw2TlMqpCO6SDj29CEcM82y+GBj
 1hcQ==
X-Gm-Message-State: AOAM533nvLB84SctBYdqJt24lj6TUtJXwd0E85NUxc2WTlxEV/RhRo9X
 +ZxxH1yN3TUeConN3dh3C0iG+uIlKuo=
X-Google-Smtp-Source: ABdhPJw5H1xUyMPhKN/sPf1QXyNfjUugFkOmTeSYbv+d8ETvnoloSmWGNmYxD/mOirbcPIE+KlziYPCyXNk=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:e20d:0:b0:64a:6397:1fad with SMTP id
 h13-20020a25e20d000000b0064a63971fadmr780425ybe.496.1652896757121; Wed, 18
 May 2022 10:59:17 -0700 (PDT)
Date: Wed, 18 May 2022 17:58:11 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-6-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 5/5] KVM: Hoist debugfs_dentry init to
 kvm_create_vm_debugfs() (again)
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

Since KVM now sanely handles debugfs init/destroy w.r.t. the VM, it is
safe to hoist kvm_create_vm_debugfs() back into kvm_create_vm(). The
author of this commit remains bitter for having been burned by the old
wreck in commit a44a4cc1c969 ("KVM: Don't create VM debugfs files
outside of the VM directory").

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aaa7213b34dd..558de6a252de 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -979,6 +979,12 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
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
 
@@ -1100,12 +1106,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
-	/*
-	 * Force subsequent debugfs file creations to fail if the VM directory
-	 * is not created (by kvm_create_vm_debugfs()).
-	 */
-	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
-
 	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
 			"kvm-%d", task_pid_nr(current));
 
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
