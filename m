From: Rob Herring <robh@kernel.org>
Subject: [PATCH 1/2] config: move x86 kvm_guest.config to a common locaton
Date: Thu,  8 Sep 2016 13:41:01 -0500
Message-ID: <20160908184102.8592-1-robh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_guest.config is useful for KVM guests on other arches, and nothing
in it appears to be x86 specific, so just move the whole file. Kbuild
will find it in either location.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org
---
 {arch/x86 => kernel}/configs/kvm_guest.config | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename {arch/x86 => kernel}/configs/kvm_guest.config (100%)

diff --git a/arch/x86/configs/kvm_guest.config b/kernel/configs/kvm_guest.config
similarity index 100%
rename from arch/x86/configs/kvm_guest.config
rename to kernel/configs/kvm_guest.config
-- 
2.9.3

