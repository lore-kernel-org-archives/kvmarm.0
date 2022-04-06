Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0741C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 23:56:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53EC54B1AF;
	Wed,  6 Apr 2022 19:56:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g+ew1XeEq6z6; Wed,  6 Apr 2022 19:56:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 406544B176;
	Wed,  6 Apr 2022 19:56:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 933B049F55
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 19:56:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ib6NX7fATiuZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 19:56:21 -0400 (EDT)
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com
 [209.85.210.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6252E49EF0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 19:56:21 -0400 (EDT)
Received: by mail-ot1-f74.google.com with SMTP id
 o17-20020a9d5c11000000b005b24a70c275so2009247otk.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 16:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=fwRsymA/7INPtz5uOlj06FEv7kVaB+utCnxy48AEBxo=;
 b=tHLPte6eqKvlyXBDRIPYKCLDrChMHfeEZx8L7EPrTciBSzA6GjKpM2hUwRIYgHL8Vf
 WbCFZFSQ9yjysfEoEe4joScrVi5mWuEF2Vob3FNBUpKhJeBqSQ5OUv0iGoQdYiOK3Fu4
 wpNOytV1B1GSyY1bwSDaky8abQgztkae3aVbObEoU+tWdOgD8KIv3x9c/q1kpnV9aZIS
 22nklc+Qm6pR7fNYrGUQ8dIFklA+X3FGgUoHCSvSGaoFRvqAVXXDZ7VJpPdOtnigUFx1
 88GQMckg6WyOIQp4YdnS0X6Y4sXKV8n49HaaujyeVOacYu/K7GGyZce1+22r1+vUdDZf
 MTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=fwRsymA/7INPtz5uOlj06FEv7kVaB+utCnxy48AEBxo=;
 b=jx7B9hl7p+Btqp0XgWTA336kzpPF6iPJiL41mdjN0XpYKgJXWfvTLOpVohjfuAHlg5
 jB5Q7tmhKGdZ1xUqQGHzHnUgahCSP3JFprbgHsaCABBFabL9oJsrQFAIsn+9zZ1rR5gi
 GuwONrsfG1vVmmrAQ0OONceRwRDEdece800q3hmP9VDL1BsceVmZWC8yR2/+1zfQsKH8
 uKEt7xtgeXS0/xincsJJhS1naKV6q5srNJSIcOyMj94g75JQLDdbhwf2loKlpFB6xmf3
 1P3eno56LzxRxGWVv+EhojRj/Zz4EpL3N7FjOwMpzetsnMgY3W4QYUG2rtcVV31zYfgy
 Tmqg==
X-Gm-Message-State: AOAM532+ppyBBP31hQvTHAi32HQVGyh2OwyeVw7Ia6dI1Tv1OsK9LpVl
 +HrADawhFtrm73QSovcywTc69CaEJ8mIrA0XYhL8JEJ+Jaa12rYmV+ykaVTXVTG3hk2DDh2xeF9
 HREGgY/Q4VA1V9F+mNJRhacOYavoWvznXyw6EB1SgFS+xESD4/EK1vJOYPag0i35wqZibIw==
X-Google-Smtp-Source: ABdhPJzj/VGxAMS1iBtHTXCMn1pekmLm2UMBGpiITgnFbH8BraR4aqQ8P5nQ2xVOA8GyeF2fPqDC5v3aSnw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:c698:b0:de:8a16:c37
 with SMTP id
 cv24-20020a056870c69800b000de8a160c37mr5259350oab.191.1649289380523; Wed, 06
 Apr 2022 16:56:20 -0700 (PDT)
Date: Wed,  6 Apr 2022 23:56:12 +0000
Message-Id: <20220406235615.1447180-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 0/3] KVM: Fix use-after-free in debugfs
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

Applies cleanly to 5.18-rc1.

Tested on an Ampere Altra system in the following combinations:

  - Bad kernel + fixed selftests
  - Fixed kernel + bad selftests

In both cases there was no vgic-state file at the root of
debugfs. Additionally, I made sure the VM debugfs directory was in fact
cleaned up at exit.

v1: https://lore.kernel.org/kvm/20220402174044.2263418-1-oupton@google.com/
v2: https://lore.kernel.org/kvm/20220404182119.3561025-1-oupton@google.com/

v2 -> v3:
 - Fix error checking in kvm_destroy_vm_debugfs(). Embarrassingly, v2
   worsened the bug by not cleaning up the VM directory... (Marc)

v1 -> v2:
 - Initialize kvm->debugfs_dentry to ERR_PTR(-ENOENT) to
   prevent the creation of all VM debug files, not just vgic-state.
 - Leave logging as-is for now. Consider dropping altogether in a
   later patch (Sean)
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
