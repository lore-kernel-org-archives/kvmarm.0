Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5730DC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 18:21:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B84294B2C6;
	Mon,  4 Apr 2022 14:21:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kXJmqon0MXt5; Mon,  4 Apr 2022 14:21:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 971BD4B23F;
	Mon,  4 Apr 2022 14:21:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1A0A4B1CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 14:21:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id brmax97Ol9cO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 14:21:28 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DD144B092
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 14:21:28 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 s14-20020a056e021a0e00b002c7c03a5d81so6638049ild.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 11:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=8WwwRyCeCeMlIzr9SxYzcSTADq8P7PlbsRggytaLcp4=;
 b=VQaIdErXUgdjfuVxv831Q/UJ1CWc5wWY7lxH3zvCVtXh16fjW923ZCg+YZuUsWju3h
 4ILe42584P0T1xmue23EdXWW7PxQVhSS77wXAmPxATMxy/cGsyGIM6bUkch6ZVyRElCQ
 rYfBdRc5h8GB9QfjxeOjmesVjpoFyeeH8Zu3wSnbSfQxQ3f/BrQJ4KI3CO5dBC0PNy47
 Yq8oCV8PCHMfzHfZRdiUAWzfhsKGQ1Hpzi816xxYXKutJYAFxMS/T/Z1CZFLs+IWzaVH
 muqotKois0KT0BZ6aZswP/2F+KHpolFWLj99t2uLkL2he7pDHDC+m/o+W1S/4MwTh6cX
 aMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=8WwwRyCeCeMlIzr9SxYzcSTADq8P7PlbsRggytaLcp4=;
 b=KLFvJC0+/FQDxGGOsE0jkTTJW5ICNQslnIIDrYJ2dc8jcwqUmno9CDqtduLEDiRuFA
 ANYikC6QSbyKoBoKGRZR5/ITlvpK3Iqowxz4uqkbKs5XQOH5Ed0p7djAtFG2HxKRtP1N
 /vjtIfzUo0jU00QJxJNCF97g5+n3j1sZhJhv2CVyFsJymWQP1vD9ZwdNuWZe2ldkfkeS
 eaR56A848hAeexshzJA0bhPShzFpEh72SMcIHUCTf568qezdSEtM4gi6WEl+z3kcYdql
 RWGxai0gQeyt4xthzr4toCUBn9JJ3PC7RURw+rRa3WQgJf1rTrk5cEZNYitOXq8ySust
 lbbw==
X-Gm-Message-State: AOAM533hnLrRDwIdN9LRSdUkNDldLURYd5T8g0VsQz0DhAt958Tv743L
 YJVjGwwmcaGPSD6FHY/NYWNLclMJoYut/xZu9VM30RwMzOSG2MWDAU4EQoDVYvd0fdii0Dx6vUX
 +M9frJq8jvRi2LzDFiqHg28wQwMquSC/8xVcazSAUnWFCE2FBjYJcc3Y6lCdobuLyt0Y9RA==
X-Google-Smtp-Source: ABdhPJwvPmo526HelrAxxb/UEnfhShlEth+Y810soIVt6pAr1nUtlqyUQGi/Lx6WU18UFIH94tuineOFKlE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:e40a:0:b0:64c:8ce1:3757 with
 SMTP id
 u10-20020a6be40a000000b0064c8ce13757mr727788iog.106.1649096487896; Mon, 04
 Apr 2022 11:21:27 -0700 (PDT)
Date: Mon,  4 Apr 2022 18:21:16 +0000
Message-Id: <20220404182119.3561025-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 0/3] KVM: Fix use-after-free in debugfs
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Funny enough, dirty_log_perf_test on arm64 highlights some issues around
the use of debugfs in KVM. The test leaks a GIC FD across test
iterations, and as such the associated VM is never destroyed.
Nonetheless, the VM FD is reused for the next VM, which collides with
the old debugfs directory.

Where things get off is when the vgic-state debugfs file is created. KVM
does not check if the VM directory exists before creating the file,
which results in the file being added to the root of debugfs when the
aforementioned collision occurs.

Since KVM relies on deleting the VM directory to clean up all associated
files, the errant vgic-state file never gets cleaned up. Poking the file
after the VM is destroyed is a use-after-free :)

Patch 1 shuts the door on any mistaken debugfs file creations by
initializing kvm->debugfs_dentry with ERR_PTR() instead of NULL.

The last two patches ensure the GIC FD actually gets closed by the
selftests that use it. Patch 2 is a genuine bug fix since it will create
multiple VMs for a single test run. The arch_timer test also happens to
leak the GIC FD, though it is benign since the test creates a single VM.
Patch 3 gets the arch_timer test to follow the well-behaved pattern.

Applies cleanly to the second KVM pull (tagged kvm-5.18-2), at commit:

  c15e0ae42c8e ("KVM: x86: fix sending PV IPI")

Tested on an Ampere Altra system in the following combinations:

  - Bad kernel + fixed selftests
  - Fixed kernel + bad selftests

In both cases there was no vgic-state file at the root of debugfs.

v1: https://lore.kernel.org/kvm/20220402174044.2263418-1-oupton@google.com/

v1 -> v2:
 - Initialize kvm->debugfs_dentry to ERR_PTR(-ENOENT) to prevent the
   creation of all VM debug files, not just vgic-state.
 - Leave logging as-is for now. Consider dropping altogether in a later
   patch (Sean)
 - Collect R-b from Jing

Oliver Upton (3):
  KVM: Don't create VM debugfs files outside of the VM directory
  selftests: KVM: Don't leak GIC FD across dirty log test iterations
  selftests: KVM: Free the GIC FD when cleaning up in arch_timer

 .../selftests/kvm/aarch64/arch_timer.c        | 15 +++++---
 .../selftests/kvm/dirty_log_perf_test.c       | 34 +++++++++++++++++--
 virt/kvm/kvm_main.c                           | 10 ++++--
 3 files changed, 50 insertions(+), 9 deletions(-)

-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
