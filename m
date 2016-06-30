From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/2] KVM/ARM Fixes for v4.7-rc6
Date: Thu, 30 Jun 2016 15:39:35 +0200
Message-ID: <20160630133937.2654-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1AD449B54
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 09:33:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id REFut7+2M9Xh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 09:33:33 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D016C49B4E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 09:33:32 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id r190so4460031wmr.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 06:38:49 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Please pull two small fixes for KVM/ARM for rc6 or as soon as it can make it:

They fix a build issue without CONFIG_ARM_PMU and plugs pid leak on arm/arm64.

Thanks,
-Christoffer

The following changes since commit a0052191624e9bf8a8f9dc41b92ab5f252566c3c:

  kvm: vmx: check apicv is active before using VT-d posted interrupt (2016-06-16 09:38:24 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.7-rc6

for you to fetch changes up to 591d215afcc2f94e8e2c69a63c924c044677eb31:

  KVM: arm/arm64: Stop leaking vcpu pid references (2016-06-27 13:08:10 +0200)

James Morse (1):
      KVM: arm/arm64: Stop leaking vcpu pid references

Sudeep Holla (1):
      arm64: KVM: fix build with CONFIG_ARM_PMU disabled

 arch/arm/kvm/arm.c    | 1 +
 include/kvm/arm_pmu.h | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)
