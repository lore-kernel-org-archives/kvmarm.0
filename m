From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH] KVM: arm/arm64: fix races in psci emulation
Date: Tue, 18 Apr 2017 17:59:57 +0200
Message-ID: <20170418155958.13406-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A406F40948
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Apr 2017 11:57:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IMkG2d4wPWuA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Apr 2017 11:57:32 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94F3C40625
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Apr 2017 11:57:32 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, cdall@linaro.org, lkurusa@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch is another approach to fixing what the last two patches
in the "KVM: arm/arm64: race fixes and vcpu requests" series were
aiming to fix.  This approach doesn't have any dependency on
VCPU requests, so it's split out now.  Tested by me on ThunderX
and Mustang with kvm-unit-tests and the kernel PSCI checker, as
well as a normal SMP guest boot.

Andrew Jones (1):
  KVM: arm/arm64: fix races in kvm_psci_vcpu_on

 arch/arm/kvm/psci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.9.3
