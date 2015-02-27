From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 0/2] get rid of ARM/KVM bounce page
Date: Fri, 27 Feb 2015 09:11:36 +0000
Message-ID: <1425028298-17289-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3104D46BCE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 04:06:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BfgUUAnShk2F for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Feb 2015 04:05:58 -0500 (EST)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B198246BCD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 04:05:58 -0500 (EST)
Received: by wghl18 with SMTP id l18so18606369wgh.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 01:11:46 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: will.deacon@arm.com, arnd@arndb.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Updated the patch sent by Arnd last month, and rebased my bounce page
removal patch on top of it.

The extended VA range patches will functionally depend on these, but until
the core one lands in the arm64 tree, systems that need it to boot with
VA_BITS <= PA_BITS (such as AMD Seattle) will not boot anyway. There should
not be any merge conflicts, so these patches can go through the arm KVM tree
as far as I am aware.

Ard Biesheuvel (1):
  ARM, arm64: kvm: get rid of the bounce page

Arnd Bergmann (1):
  ARM: KVM: avoid "HYP init code too big" error

 arch/arm/kernel/vmlinux.lds.S   | 35 +++++++++++++++++++++++++++++-----
 arch/arm/kvm/init.S             |  3 +++
 arch/arm/kvm/mmu.c              | 42 +++++------------------------------------
 arch/arm64/kernel/vmlinux.lds.S | 18 ++++++++++++------
 4 files changed, 50 insertions(+), 48 deletions(-)

-- 
1.8.3.2
