From: David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] arm64: Workaround for Thunder KVM hang issues.
Date: Mon, 24 Apr 2017 11:42:48 -0700
Message-ID: <20170424184250.667-1-david.daney@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>, David Daney <david.daney@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

We have discovered in rare circumstances, guest execution may result
in host not receiving one or more interrupts.  This does not otherwise
affect guest or host execution and/or isolation.


David Daney (2):
  arm64: Add MIDR values for Cavium cn83XX SoCs
  arm64: Add workaround for Cavium Thunder erratum 30115

 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 11 +++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/include/asm/cputype.h       |  2 ++
 arch/arm64/kernel/cpu_errata.c         | 21 +++++++++++++++++++++
 arch/arm64/kvm/hyp/switch.c            |  9 +++++++++
 6 files changed, 46 insertions(+), 1 deletion(-)

-- 
2.7.4

