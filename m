From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH kvm-unit-tests 0/3] Add physical timer test
Date: Thu, 13 Jul 2017 21:20:06 +0200
Message-ID: <20170713192009.10069-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Andrew Jones <drjones@redhat.com>, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add a test for the vtimer. I've tested on
 accel=tcg
 accel=kvm                     : on seattle, and mustang
 accel=kvm,kernel-irqchip=off  : on mustang

I first fix two issues I had running the basic timer test on APM mustang
on using TCG.  I wonder why the vtimer tests worked using TCG for Drew,
since they didn't work for me, and I don't see how they would have
without patch 1.

Then I introduce a test for the physical timer.  If you run the ptimer
test on a kernel before support for the physical timers was added you
get a nice error message plus some spamming in your kernel log.


Christoffer Dall (3):
  arm64: timer: Fix vtimer interrupt test
  arm64: timer: Fix test on APM X-Gene
  arm64: timer: Add support for phys timer testing

 arm/timer.c       | 205 +++++++++++++++++++++++++++++++++++++++++++++---------
 arm/unittests.cfg |   9 ++-
 2 files changed, 182 insertions(+), 32 deletions(-)

-- 
2.9.0
