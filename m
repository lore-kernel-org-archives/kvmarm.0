From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] KVM: Fix !KVM_COMPAT ioctl behaviour
Date: Tue, 19 Jun 2018 10:42:49 +0100
Message-ID: <20180619094251.8586-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3C9E4A0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jun 2018 05:31:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hGrMOuw5fDd9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jun 2018 05:31:10 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65DBE402B8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jun 2018 05:31:10 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Mark Rutland recently pointed out that a couple of issues with the way
we deal with compat tasks:

1) arm64 unexpectedly selects KVM_COMPAT, while offering no way for a
   32bit userspace to change any register

2) Even deselecting KVM_COMPAT, we end-up with compat_ioctl being NULL,
   and the VFS behaviour is thus to call the non-compat ioctl

(1) is completely unintentional and should be fixed. (2) is quite odd,
and probably just as unintentional. This series fixes it by installing
a compat_ioctl callback whose only job is to return -EINVAL.

Tested on arm64 with a 32bit kvmtool.

Marc Zyngier (2):
  KVM: Enforce error in ioctl for compat tasks when !KVM_COMPAT
  KVM: arm64: Prevent KVM_COMPAT from being selected

 virt/kvm/Kconfig    |  2 +-
 virt/kvm/kvm_main.c | 19 +++++++++----------
 2 files changed, 10 insertions(+), 11 deletions(-)

-- 
2.17.1
