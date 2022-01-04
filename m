Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8423C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 19:49:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C26249F14;
	Tue,  4 Jan 2022 14:49:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 556NSdmml6xa; Tue,  4 Jan 2022 14:49:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2463449EE5;
	Tue,  4 Jan 2022 14:49:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E890849EE5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tkXf1xDoEQiw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 14:49:30 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E53D449F12
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:29 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 p4-20020a17090a348400b001b103a13f69so350104pjb.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 11:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=A6x6Pw7kLwqSVAYV5QWuRkaeBaCvukF54j0t8jOjIWo=;
 b=ptX0vg9YdIJXEIv+bPi9miN6Phs8Gqz7sBU2QWQsUtqw2kQGQwiABtW992ywk4hZ+W
 0Yjxd+YrHiAZDx5j9yYFCFkPbsVaZ0Me2jeZ8/Yp1nLtpTRU3glZ/AFWrivJ3Ne9PxOZ
 wEEkRcAX+0GHmJL3/IL+wNt/VFmeQ8X8mW6bJyPiNxpnLVbR0aLEbdEA2Ze9gi6qqQ3C
 poU1KuO3mU1pkPlTHi2tto1rMBI3uHO8ySMfK3Luj4uIlnnCmLez6qNGPpgKaKGbE9tx
 WkPLsVqsmNEpEEThs9CKJ8Tw+DYsrLXtA1p0adzY5K5eZnk7V3wXfESrD7ST2e9CTHW1
 RFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=A6x6Pw7kLwqSVAYV5QWuRkaeBaCvukF54j0t8jOjIWo=;
 b=nl+QXrkB+P+6CyUbQfnzL0WuZhPbASNB4i3ajEK543kD/NaRUYVn5/Zg6t9vPRbdFH
 djlkv6QnjHriFQcyMtLh+812y0AytgBlG7g8G1D7Y1BYQE3qEz1Tm5llvYyx3QhdZR9A
 uwxEBx4Vawfr7mBmY50WP5sTRYm0nW8lytJILHszS/n7Eplc0oflmLOBOaT8pFwJTzP6
 4MwN2kX1NL1WeK86Fhin7OP5c07FgEXH6J2GGiqtJfRtUnzwgK25Kyt4M1ryD1PI8/KI
 dUj5oeMTks+jC+P2BTT1RlphpS6dwGDBgKugBTNUPNFSssbu8C1/gn4ExabvfnYlLOo3
 CbzQ==
X-Gm-Message-State: AOAM532bKfuRuCIG8gQuSK+8MmnKboBISYul31YpbCxatYuz1yxZfOwi
 A1JkB1eqZe8cDf+UxKph0fiwUKj+qFpz
X-Google-Smtp-Source: ABdhPJwl3NnGF1TfkZRlci6WjMWULIHIZ/BPa4U45UMKx/oZHTzTtRdYJEOxN/Xl1feLxe+jPtf4xNYvI4PH
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:3809:: with SMTP id
 mq9mr62274740pjb.245.1641325768929; Tue, 04 Jan 2022 11:49:28 -0800 (PST)
Date: Tue,  4 Jan 2022 19:49:08 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-2-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 01/11] KVM: Capture VM start
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Capture the start of the KVM VM, which is basically the
start of any vCPU run. This state of the VM is helpful
in the upcoming patches to prevent user-space from
configuring certain VM features after the VM has started
running.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 include/linux/kvm_host.h | 3 +++
 virt/kvm/kvm_main.c      | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c310648cc8f1..d0bd8f7a026c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -623,6 +623,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+	bool vm_started;
 };
 
 #define kvm_err(fmt, ...) \
@@ -1666,6 +1667,8 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 	}
 }
 
+#define kvm_vm_has_started(kvm) (kvm->vm_started)
+
 extern bool kvm_rebooting;
 
 extern unsigned int halt_poll_ns;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 72c4e6b39389..962b91ac2064 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3686,6 +3686,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	int r;
 	struct kvm_fpu *fpu = NULL;
 	struct kvm_sregs *kvm_sregs = NULL;
+	struct kvm *kvm = vcpu->kvm;
 
 	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
 		return -EIO;
@@ -3723,6 +3724,14 @@ static long kvm_vcpu_ioctl(struct file *filp,
 			if (oldpid)
 				synchronize_rcu();
 			put_pid(oldpid);
+
+			/*
+			 * Since we land here even on the first vCPU run,
+			 * we can mark that the VM has started running.
+			 */
+			mutex_lock(&kvm->lock);
+			kvm->vm_started = true;
+			mutex_unlock(&kvm->lock);
 		}
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
