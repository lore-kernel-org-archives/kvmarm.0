From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 0/4] support KVM_MEM_UNCACHED
Date: Wed, 18 Mar 2015 15:11:44 -0400
Message-ID: <1426705908-2765-1-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4AF5491A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n8HeYMIH+VWJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:05:11 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7F9E49191
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:10 -0400 (EDT)
In-Reply-To: <1426705700-2564-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Add support for the new KVM_MEM_UNCACHED flag, and flag
appropriate memory. (Only flags vga/vram for now.)

Andrew Jones (4):
  kvm-all: put kvm_mem_flags to more work
  HACK: linux header update
  memory: add uncached flag
  vga: flag vram as uncached

 hw/display/vga.c          |  1 +
 include/exec/memory.h     | 25 +++++++++++++++++++++++++
 kvm-all.c                 | 34 ++++++++++++++++++++++++----------
 linux-headers/linux/kvm.h |  2 ++
 memory.c                  | 15 +++++++++++++++
 5 files changed, 67 insertions(+), 10 deletions(-)

-- 
1.8.3.1
