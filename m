Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED12CC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 18 May 2022 17:59:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A61D14B322;
	Wed, 18 May 2022 13:59:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yDv3SdYALCa4; Wed, 18 May 2022 13:59:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3FCE4B323;
	Wed, 18 May 2022 13:59:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B3F4B32A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ROPTVr2r5V3u for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2022 13:59:12 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EAD54B31A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:11 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 nl9-20020a17090b384900b001df338b4b72so3540809pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 10:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fMGKhekV0sa/YRSHAxxD4jBJX+Cxj4sGMKO6wGVMLLU=;
 b=rDo4lZZNt9Jya8MiZXgjYNXvz5J37fb6AuEUs8DN3vWndBXOI1tlgJDwCnvUKvBPc6
 TnxRUc2etnh7q3vcNtEJshhc10uQivQXWKv6a8RKBrOUXLNW3i9tz5EGrsvAcVoADMiL
 PvNIKKOQMpui5nbSexy36l2tOwTHjFolG+IARW9zKt9E0WsklNY44NvY7EeSIM1LAImr
 Qdh1TwS91bwJhJQCqcCHxjySJSl0uXy2thSsDiVRnnjlIcxwEEC5/N6c0tEtDCClsxFr
 WAgaQSTqdu1IYn2f/p7uzC4BPyx+3E9A3cU+HE2HUs8/0d37lyEl4oXbbkNUg4GBWFXk
 XEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fMGKhekV0sa/YRSHAxxD4jBJX+Cxj4sGMKO6wGVMLLU=;
 b=p7gkM6xG/WhR0aUHRkcVymaYqYOlV8zCexGxQ/xBVsnznRDLIBq0mOYtWL2FlJpKwb
 5GYfZIWPZ0dAvIL6aoA3Gs+rD4hp0LEpoBMP0NhGqdEQ+VqFfSf1iYg7Ac092sUYs5ba
 FkB130IAljzmo4IkfUMuN+V30Z7SEZsZtJ6VS4ugwJ+wrcdIXB3+c2H/tghakOH06u0M
 B4g5VJjyQ8BeppQJ2rpotPlKSpkJyv8jc3Pt4o9zyf0ZeHKpCGLfMUSWFAd9SM0U93Pk
 JWNbd3Q//3hAJuEaqvAXcLJaaRQWF44rUee0T5zPQda4He/rCdkFlQHf38cBZgjf8Rvg
 1I/g==
X-Gm-Message-State: AOAM532mVqlJQQHgYzktqA3yJNxMP+vSuYtxsjwLT6pPs0FvDPHzmfVQ
 hgWMsBaygoYqil+cY4zDahC6ubA18Dg=
X-Google-Smtp-Source: ABdhPJyZ+5KTCDASJ2VzQHVK+2cDZhp3NrE9g00eRb9QNAZGfGNos3Q7HEHF07BETonFHNlM4Zm3P3D3UZ0=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6a00:24c1:b0:50d:33cf:811f with SMTP id
 d1-20020a056a0024c100b0050d33cf811fmr827317pfv.78.1652896749987; Wed, 18 May
 2022 10:59:09 -0700 (PDT)
Date: Wed, 18 May 2022 17:58:07 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-2-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 1/5] KVM: Shove vm stats_id init into kvm_create_vm()
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

Initialize the field alongside the other struct kvm fields. No
functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6d971fb1b08d..36dc9271d039 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1101,6 +1101,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	 */
 	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
 
+	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
+			"kvm-%d", task_pid_nr(current));
+
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
 	if (init_srcu_struct(&kvm->irq_srcu))
@@ -4787,9 +4790,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	if (r < 0)
 		goto put_kvm;
 
-	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
-			"kvm-%d", task_pid_nr(current));
-
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
 		put_unused_fd(r);
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
