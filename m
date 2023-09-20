Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CD63CCE0
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 18:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D5CC433C8;
	Wed, 20 Sep 2023 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695233858;
	bh=/y9HzY5TIAg0wJ9FXal5ol60ZymjtYxZJXoPcuNKC/0=;
	h=From:To:Cc:Subject:Date:From;
	b=d6AFn//dui2vK48P4qfwcxzTclqV+sUoK4oZBzlMjudHkJzPhwaGQueT2Mi+zVwR/
	 jR8V0XqgLrvIVgFGE5FwwuR88qxs+fDc3XtRoyRonS2LFFeKs3JmzrEwQbR4EwFb+1
	 eG5AyjdOkvWd3cHPl+FVOvzB1CRkdlT4xhoZfDLT1A9cWKhcxMngtJfBgdJDc6so+D
	 sRtednYSaj4ko/2i5FxJseJr9G8wX+sUvRB+GdFNatSyAlZp4VSMejLlz2kEHAXYZA
	 VH5zUJYvgHRIwKujhltXE9yZCVPEhRWOvz4nt+Ntk+XuoaO/kQUhMkNQqHdWGlwqyW
	 1UHZyA1rEFhFw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qj1lY-00Ejx0-Nc;
	Wed, 20 Sep 2023 19:17:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 00/11] KVM: arm64: Accelerate lookup of vcpus by MPIDR values (and other fixes)
Date: Wed, 20 Sep 2023 19:17:20 +0100
Message-Id: <20230920181731.2232453-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is a follow-up on [1], which contains the original patches, only
augmented with a bunch of fixes after Zenghui pointed out that I was
inadvertently fixing bugs (yay!), but that there were plenty more.

The core of the issue is that we tend to confuse vcpu_id with
vcpu_idx. The first is a userspace-provided value, from which we
derive the default MPIDR_EL1 value, while the second is something that
used to represent the position in the vcpu array, and is now more of
an internal identifier.

To convince oneself that things are terminally broken, it is easy
enough to run a kvmtool guest with the following patchlet:

diff --git a/kvm-cpu.c b/kvm-cpu.c
index 1c566b3..520d759 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -287,7 +287,7 @@ int kvm_cpu__init(struct kvm *kvm)
                return -ENOMEM;
        }
 
-       for (i = 0; i < kvm->nrcpus; i++) {
+       for (i = kvm->nrcpus - 1; i >= 0; i--) {
                kvm->cpus[i] = kvm_cpu__arch_init(kvm, i);
                if (!kvm->cpus[i]) {
                        pr_err("unable to initialize KVM VCPU");

and witness that the resulting VM doesn't boot. The only combination
we support is to have vcpu_id == vcpu_idx. B0rken.

So this series, on top of trying to optimise SGI injection, also aims
at disambiguating this mess, and documenting some of the implicit
requirements for userspace.

With that, a VM created with vcpu upside down boots correctly.

* From v1 [1]:
  - Added a bunch of patches fixing the vcpu_id[x] ambiguity
  - Added a documentation update spelling out some extra ordering requirements
  - Collected RBs/TBs, with thanks

[1] https://lore.kernel.org/r/20230907100931.1186690-1-maz@kernel.org

Marc Zyngier (11):
  KVM: arm64: vgic: Make kvm_vgic_inject_irq() take a vcpu pointer
  KVM: arm64: vgic-its: Treat the collection target address as a vcpu_id
  KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
  KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
  KVM: arm64: vgic: Use vcpu_idx for the debug information
  KVM: arm64: Use vcpu_idx for invalidation tracking
  KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
  KVM: arm64: Build MPIDR to vcpu index cache at runtime
  KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is
    available
  KVM: arm64: vgic-v3: Optimize affinity-based SGI injection
  KVM: arm64: Clarify the ordering requirements for vcpu/RD creation

 .../virt/kvm/devices/arm-vgic-v3.rst          |   7 +
 arch/arm64/include/asm/kvm_emulate.h          |   2 +-
 arch/arm64/include/asm/kvm_host.h             |  28 ++++
 arch/arm64/kvm/arch_timer.c                   |   2 +-
 arch/arm64/kvm/arm.c                          |  90 +++++++++--
 arch/arm64/kvm/pmu-emul.c                     |   2 +-
 arch/arm64/kvm/vgic/vgic-debug.c              |   6 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   2 +-
 arch/arm64/kvm/vgic/vgic-its.c                |  21 ++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 142 +++++++-----------
 arch/arm64/kvm/vgic/vgic.c                    |  12 +-
 include/kvm/arm_vgic.h                        |   4 +-
 13 files changed, 195 insertions(+), 125 deletions(-)

-- 
2.34.1

