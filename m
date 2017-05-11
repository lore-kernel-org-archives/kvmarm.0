From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 0/2] plug KVM ARMv7 debug leakage
Date: Thu, 11 May 2017 13:46:10 +0100
Message-ID: <20170511124612.11212-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2372D40BC4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 May 2017 08:42:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7ATrkG0f++C for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 May 2017 08:42:07 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFAD840187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 May 2017 08:42:07 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id u65so2692472wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 May 2017 05:45:26 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This is pretty much v1 + comments from Marc and a minor re-factor of
the trap path to make it cleaner w.r.t. cp14/cp15 trapping.

Zhichao Huang (2):
  KVM: arm: plug potential guest hardware debug leakage
  KVM: arm: rename pm_fake handler to trap_raz_wi

 arch/arm/include/asm/kvm_coproc.h |   3 +-
 arch/arm/kvm/coproc.c             | 105 ++++++++++++++++++++++++++------------
 arch/arm/kvm/handle_exit.c        |   4 +-
 arch/arm/kvm/hyp/switch.c         |   4 +-
 4 files changed, 80 insertions(+), 36 deletions(-)

-- 
2.11.0
