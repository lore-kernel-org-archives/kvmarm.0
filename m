From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 0/6] support KVM_MEM_INCOHERENT
Date: Fri,  6 Mar 2015 13:53:32 -0500
Message-ID: <1425668018-3649-1-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0344847F0E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CboBwQNZRWZh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:47:36 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3527847DA5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:36 -0500 (EST)
In-Reply-To: <1425667780-3449-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Add support for the new KVM_MEM_INCOHERENT flag, and flag
appropriate memory. (Only flags vram for now.)

Patch 6/6 doesn't appear to be complete. While the VGA output is
99% corruption free, it's not perfect, so it's missing flushes
somewhere... 

Andrew Jones (6):
  memory: add incoherent cache flag
  HACK: linux header update
  kvm-all: put kvm_mem_flags to more work
  kvm-all: set KVM_MEM_INCOHERENT
  vga: flag vram as incoherent
  memory: add clear_cache_to_poc

 exec.c                    | 16 ++++++++++------
 hw/display/vga.c          |  1 +
 include/exec/exec-all.h   | 41 +++++++++++++++++++++++++++++++++++++++++
 include/exec/memory.h     | 23 +++++++++++++++++++++++
 kvm-all.c                 | 28 ++++++++++++++++++----------
 linux-headers/linux/kvm.h |  1 +
 memory.c                  | 15 +++++++++++++++
 7 files changed, 109 insertions(+), 16 deletions(-)

-- 
1.8.3.1
