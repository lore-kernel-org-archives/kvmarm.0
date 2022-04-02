Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D539C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 17:40:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 966384B2B9;
	Sat,  2 Apr 2022 13:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id os78Ud4JxBWK; Sat,  2 Apr 2022 13:40:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 716E44B292;
	Sat,  2 Apr 2022 13:40:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6594B28B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dq2cFphRHXBA for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 13:40:49 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78F664B26B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:49 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 y7-20020a92d207000000b002c7f55e413bso3751066ily.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 02 Apr 2022 10:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=RL+g93Fijo1SZ8lwfn+Xp7o4bffPLL5ZnXUT6dIwBzU=;
 b=jczsRYruEZAo5WKmoWBK5h9QZfLDn8n1TXFMm6z7O5w5ywolfcnyEixifD0NojlNnV
 KAHqCd/80lYyWIxinRrWpQ6WI+9qcgcD/wT3SQMYw1TPYNWDO3yxvq5J/KUV+5zfUFHn
 N39L/g8DKNJXDMxWHTc+MtWTYW78lMwhKUfqG2kbIxFFEpvIZTO5xLeT4YHvil+DTTee
 nkg/53P1GB18loNhh6P4ztw61Rsa+JbDMPj+g0zX9HZ1CCi8nYLa29eQlnjUiXyyXu2D
 v6t/VdoaGhi/g9jKMdnpb1eNlcGnA8E4iU4S/Ti2iqU3vH90pLUfLeiG7SyeESxPYDQE
 oTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=RL+g93Fijo1SZ8lwfn+Xp7o4bffPLL5ZnXUT6dIwBzU=;
 b=kVYDcVqRBcpcMBV6XCSLI9m69Z5doUUqB5orNKpiKbUsNuNGPWHs5nIO1Wqr2tKIGm
 Enw1XfCoxHf37DG2iFXAF5uBOj7lq6aNGoTI4zFVnpjkmZiBAR8qthuw0a1HwD6YkCWy
 QP+DA2qcddJB8gNE+47BsQ3IBl7dcJHcl3D2gl3Qok+RvWTw7klzqqdAf2O14yvdWsv6
 gZOnQoFfMGhFVJHcYg1gJLRCkdw57Af3K9yDzJQPejOw9Z/5nxcG+j533jydFvhwHcKm
 McZOYhR+keACW+G6cJoW+wW1rGAm+/CXiz/0ZmfpE7KSYbtccwr2YxnO2LT1lLIhHSHW
 vC5A==
X-Gm-Message-State: AOAM5335NpEUrG2gIulbWN1j/2k/hy1SxG+vfISSYPNi8VI2gNStt4XC
 6oJYe/ISRetBLWd6eiKvjdxnR8LAAAHomi427t1quGJVd+s3BUV9oY6SepQ822TP794ruZzyLk+
 DB/zf10ml0ShOyvz8a9HOBj8jDkoEuGePBE8gvpEhlrjpO4dKXiOXywOcokEIbbZs6nOYHQ==
X-Google-Smtp-Source: ABdhPJzYn6lVkuhXlh2hTOvp36IECh6AGHkLwh7F6GtH58BHozTY1KxCiZKAVNa+Y+rlLwHIPZK/zxqBLAA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:1645:b0:646:4780:fc28
 with SMTP id
 y5-20020a056602164500b006464780fc28mr2144945iow.194.1648921248546; Sat, 02
 Apr 2022 10:40:48 -0700 (PDT)
Date: Sat,  2 Apr 2022 17:40:40 +0000
Message-Id: <20220402174044.2263418-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 0/4] KVM: arm64: Fix use-after-free in debugfs
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

Patch 1 takes care of the immediate problem by refusing to create the
file if the VM directory does not exist.

Patch 2 tones down logging around debugfs collisions. As demonstrated by
the selftest, this is most likely to happen for a userspace bug, not
KVM.

The last two patches ensure the GIC FD actually gets closed by the
selftests that use it. Patch 3 is a genuine bug fix since it will create
multiple VMs for a single test run. The arch_timer test also happens to
leak the GIC FD, though it is benign since the test creates a single VM.
Patch 4 gets the arch_timer test to follow the well-behaved pattern.

Applies cleanly to the first KVM pull (tagged kvm-5.18-1), at commit:

  c9b8fecddb5b ("KVM: use kvcalloc for array allocations")

The series is intentionally *not* based on the kvmarm/fixes tree because
there is a small dependency on commit:

  456f89e0928a ("KVM: selftests: aarch64: Skip tests if we can't create a vgic-v3")

which isn't present in the fixes branch.

Tested on an Ampere Altra system in the following combinations:

  - Bad kernel + fixed selftests
  - Fixed kernel + bad selftests

In both cases there was no dmesg spew and no unintended vgic-state file
at the root of debugfs.

Oliver Upton (4):
  KVM: arm64: vgic: Don't assume the VM debugfs directory exists
  KVM: Only log about debugfs directory collision once
  selftests: KVM: Don't leak GIC FD across dirty log test iterations
  selftests: KVM: Free the GIC FD when cleaning up in arch_timer

 arch/arm64/kvm/vgic/vgic-debug.c              |  3 ++
 .../selftests/kvm/aarch64/arch_timer.c        | 15 +++++---
 .../selftests/kvm/dirty_log_perf_test.c       | 34 +++++++++++++++++--
 virt/kvm/kvm_main.c                           |  2 +-
 4 files changed, 46 insertions(+), 8 deletions(-)

-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
