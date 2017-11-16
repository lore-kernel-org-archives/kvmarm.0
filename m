From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 3/3] kvm: arm64: handle single-step of userspace mmio instructions
Date: Thu, 16 Nov 2017 15:39:21 +0000
Message-ID: <20171116153921.21991-4-alex.bennee@linaro.org>
References: <20171116153921.21991-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171116153921.21991-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

The system state of KVM when using userspace emulation is not complete
until we return into KVM_RUN. To handle mmio related updates we wait
until they have been committed and then schedule our KVM_EXIT_DEBUG.

The kvm_arm_handle_step_debug() helper tells us if we need to return
and sets up the exit_reason for us.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v2
  - call helper directly from kvm_arch_vcpu_ioctl_run
v3
  - return 0 (ioctl success) instead of 1
---
 virt/kvm/arm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 95cba0799828..b40440defca1 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -625,6 +625,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
 		if (ret)
 			return ret;
+		if (kvm_arm_handle_step_debug(vcpu, vcpu->run))
+			return 0;
+
 	}
 
 	if (run->immediate_exit)
-- 
2.15.0
