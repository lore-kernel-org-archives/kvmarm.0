From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: linux-next-20180601: build error in arch/arm64/kvm/hyp/hyp-entry.S
Date: Fri, 1 Jun 2018 22:05:07 +0200 (CEST)
Message-ID: <457305318.78169.1527883507093@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.or, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

i can't build todays linux-next-20180601 and get the following error message:

arch/arm64/kvm/hyp/hyp-entry.S: Assembler messages:
arch/arm64/kvm/hyp/hyp-entry.S:128: Error: constant expression required at operand 3 -- `bfi x0,x1,#VCPU_WORKAROUND_2_FLAG_SHIFT,#1'

Related commit:
arm64: KVM: Handle guest's ARCH_WORKAROUND_2 requests

Toolchain: gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu
Kernel config: arm64/defconfig

Regards
Stefan
