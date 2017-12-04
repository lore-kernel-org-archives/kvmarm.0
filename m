From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 12/19] kvm: arm64: handle single-step of userspace mmio instructions
Date: Mon,  4 Dec 2017 15:03:41 +0100
Message-ID: <20171204140348.21965-10-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Alex Bennée <alex.bennee@linaro.org>

The system state of KVM when using userspace emulation is not complete
until we return into KVM_RUN. To handle mmio related updates we wait
until they have been committed and then schedule our KVM_EXIT_DEBUG.

The kvm_arm_handle_step_debug() helper tells us if we need to return
and sets up the exit_reason for us.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a6524ff27de4..322c570d211e 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -628,6 +628,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
 		if (ret)
 			return ret;
+		if (kvm_arm_handle_step_debug(vcpu, vcpu->run))
+			return 0;
+
 	}
 
 	if (run->immediate_exit)
-- 
2.14.2
