Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4102AC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:11:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC6E1613A1
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AC6E1613A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D7684B0BC;
	Sun, 15 Aug 2021 20:11:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hnFaSHFuqzLL; Sun, 15 Aug 2021 20:11:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 325724B0D9;
	Sun, 15 Aug 2021 20:11:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C474B0CE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:11:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2fOO6GCZjDqs for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:11:34 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C89D64B0AC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:11:34 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 d23-20020a056602281700b005b5b34670c7so1335395ioe.12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=iJYsu7fpasA4KCIA5cuNFhT9/QgsjAss3yu7wk60u8Q=;
 b=aQj/I1mY6r1r03IW3BWlNheUhL3RDYxx/4BIrimzwkzt2gfhIN0A/tEFP0+K8V90Cb
 zKOXBSuylCsQDzsL6PKOCbhHzPGaGBvEjREeSHMXlsWBrwkycNJXsX+SXhJltmySqdbK
 0cP3Dur3EwL6skxpgnFzlPK4SKLVQkZ3dYumZnisLLglIrZdTmu6K+DSv77KoVVtKS9+
 XU3+hWyiPbJPXOwf+NesHBYEuz9EfXIqrStikdtcpAorkuSS1tERCKbQqUPs7FYKEZY3
 O1roXtb6SaQoT+f3WJVvzZ1103URmkOQIs2VyJAu7ES9jAZAYzXa2e1wv7mCIVAjrSo3
 hyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=iJYsu7fpasA4KCIA5cuNFhT9/QgsjAss3yu7wk60u8Q=;
 b=NvGR17r8qFlQDugyq/Y0qEcDB58NG/hY40fuKBcCKIjvzFePdi4YdGAGXRdHV5HyIu
 FWuUg1n9IotOk5jpf5ECVZ6OCFos4TgRvk2fjO7tbEvGuDpddavF1fdPPrUchxGJr5YT
 x+yJ3BAvpXvb4vUVIfOwH50XkqdkVMUWTBH5WQhaj2VSWW0XnAIYs5yE+RfdfsIpPIma
 uO+eZRM72FFEfi9lcAseHjsB8lfpnAmzGRmvdp+CvDNeOoDjvjfk4BmFMRn3PSAR1fiU
 axjE5pb6+XXUUyO50KCqJKCa+Lh0tT4PRuBUQxg8euMH0rr+QoRgBqcpIYNaiHvzcogz
 o03Q==
X-Gm-Message-State: AOAM531QnYOtBxNVgEyY2LaqdpNMfx3hP0pjhF+9k0+7CT92h9oNVr8b
 GwZebDyB19AbH5qjapTMt8e2cVHZItE=
X-Google-Smtp-Source: ABdhPJyyEq1JPYrQ+owXHLwmCeY/SoZMfZe5R92+IYuMRt/23mdj7nVwa7/HPh0wkyoJLBOG25OQdvvomhs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5e:8915:: with SMTP id
 k21mr4192645ioj.137.1629072694172; 
 Sun, 15 Aug 2021 17:11:34 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:11:24 +0000
Message-Id: <20210816001130.3059564-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 0/6] KVM: x86: Add idempotent controls for migrating system
 counter state
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

KVM's current means of saving/restoring system counters is plagued with
temporal issues. On x86, we migrate the guest's system counter by-value
through the respective guest's IA32_TSC value. Restoring system counters
by-value is brittle as the state is not idempotent: the host system
counter is still oscillating between the attempted save and restore.
Furthermore, VMMs may wish to transparently live migrate guest VMs,
meaning that they include the elapsed time due to live migration blackout
in the guest system counter view. The VMM thread could be preempted for
any number of reasons (scheduler, L0 hypervisor under nested) between the
time that it calculates the desired guest counter value and when
KVM actually sets this counter state.

Despite the value-based interface that we present to userspace, KVM
actually has idempotent guest controls by way of the TSC offset.
We can avoid all of the issues associated with a value-based interface
by abstracting these offset controls in a new device attribute. This
series introduces new vCPU device attributes to provide userspace access
to the vCPU's system counter offset.

Patch 1 addresses a possible race in KVM_GET_CLOCK where
use_master_clock is read outside of the pvclock_gtod_sync_lock.

Patch 2 is a cleanup, moving the implementation of KVM_{GET,SET}_CLOCK
into helper methods.

Patch 3 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
ioctls to provide userspace with a (host_tsc, realtime) instant. This is
essential for a VMM to perform precise migration of the guest's system
counters.

Patches 4-5 are some preparatory changes for exposing the TSC offset to
userspace. Patch 6 provides a vCPU attribute to provide userspace access
to the TSC offset.

This series was tested with the new KVM selftests for the KVM clock and
system counter offset controls on Haswell hardware. Note that these
tests are mailed as a separate series due to the dependencies in both
x86 and arm64.

Applies cleanly to kvm/queue.

Parent commit: a3e0b8bd99ab ("KVM: MMU: change tracepoints arguments to kvm_page_fault")

v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com

v6 -> v7:
 - Separated x86, arm64, and selftests into different series
 - Rebased on top of kvm/queue

Oliver Upton (6):
  KVM: x86: Fix potential race in KVM_GET_CLOCK
  KVM: x86: Create helper methods for KVM_{GET,SET}_CLOCK ioctls
  KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
  KVM: x86: Take the pvclock sync lock behind the tsc_write_lock
  KVM: x86: Refactor tsc synchronization code
  KVM: x86: Expose TSC offset controls to userspace

 Documentation/virt/kvm/api.rst          |  42 ++-
 Documentation/virt/kvm/devices/vcpu.rst |  57 ++++
 Documentation/virt/kvm/locking.rst      |  11 +
 arch/x86/include/asm/kvm_host.h         |   4 +
 arch/x86/include/uapi/asm/kvm.h         |   4 +
 arch/x86/kvm/x86.c                      | 362 +++++++++++++++++-------
 include/uapi/linux/kvm.h                |   7 +-
 7 files changed, 378 insertions(+), 109 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
