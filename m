Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B411FC8
	for <kvmarm@lists.linux.dev>; Sat, 11 Apr 2026 10:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775903189; cv=none; b=pozPsoj1wWUypx+o5QvxOo7eVnsNE5+GdUveaD4Em2wF0qm4dUdKyPMH9CB1qlENTrnYfy+AMFlpH+OQe2p0I9tqEeiWQowPvim21XXa2u1VjpTJPyOTr7rPkwUume7dg0ND8tVeyQUiPlNmwSRqmGk/vBhSOd0mbK3CyUpofWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775903189; c=relaxed/simple;
	bh=YzhVc9Xj6RUQ96zQ8gZZ1wl3Wvk3OUuyYYRE1ztdNCQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=YYwCxQktaOQFD56oVaCmAuicquUHfsYntxynqDP9EKP8llintaLHYTu/Nhdtx/SzNuaVHc2QUG6925KEMsC1fatZgtiOQ41TcxKUzUeR33yK6RzjDb91B8ra8vz0xLRv6hHgM05RHewHOAGvygXKCP+n4r2yVNsBgwr+caKcXO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=ty/jo9vb reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="ty/jo9vb"
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 63BAKqRl021769
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 11 Apr 2026 19:20:54 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=oyjFfLOVr4/tAinbTSgmI+kMMDNqw+dYn58LCXlZnV4=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1775902854; v=1;
        b=ty/jo9vbXApetQXw8+YlWhkBNzXcBxBdxesTaFhYeoUO0PbR+z/rky1YMxteHQTt
         vshKPTx/sTCPSoiX2pMhgFwwWxu1m6lxhhfMVFxaYwvB4S8vGFkYA9quLuxsU8dN
         /C8QkS6rHtxErl/lZQXbX7xwnt1apFNbOVmBbm+WuoXoFl6IPMZ1yOzszbIMeCQY
         gc/RUxvAknkyaTlSsDiVPmVyyzyEdE1FTOupqi2+wpOhYAd+nzD1zlCQ4D/J9ehi
         AKbpMYdOw7MRN6y0DSp8w82mFcpcekIEBRn3qVAuHtpmI8pBY2k2fQ3IyGnVGGll
         J9D0xhZcZ3uV2ANx7ipDeQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: [PATCH v5 0/4] KVM: arm64: PMU: Use multiple host PMUs
Date: Sat, 11 Apr 2026 19:20:30 +0900
Message-Id: <20260411-hybrid-v5-0-b043b4d9f49e@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33QTW6DMBAF4KtEXtdo/IvJKveoujDjIbhVIDUEB
 UXcvS4oZNUunzXzzZMfbKAUaWDHw4MlmuIQ+y4H83Zg2PruTDyGnJkEaUBKzdu5TjFwEME0jS4
 pBMny8DVRE+8r9P6x5UTft+yN2yOr/UAc+8sljsdD5St0SAoAg3KmQnRlrcFRY4zEYKsSUfq6Z
 L9WG4exT/PacRIrttZRonrWmQQXXAfhgxdAJZhT8HMX70U+uBqTfO05sPue5MDBWuEJlW8cntJ
 wLjAWsbjxsf+a+8Jj8XndDPU0bP4KsxsqG9qSa0hKcA7+NfTLUKLcDZ2NOlhZY9DOav2nsSzLD
 03leFO1AQAA
X-Change-ID: 20250224-hybrid-01d5ff47edd2
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-5ab4c

On a heterogeneous arm64 system, KVM's PMU emulation is based on the
features of a single host PMU instance. When a vCPU is migrated to a
pCPU with an incompatible PMU, counters such as PMCCNTR_EL0 stop
incrementing.

Although this behavior is permitted by the architecture, Windows does
not handle it gracefully and may crash with a division-by-zero error.

The current workaround requires VMMs to pin vCPUs to a set of pCPUs
that share a compatible PMU. This is difficult to implement correctly in
QEMU/libvirt, where pinning occurs after vCPU initialization, and it
also restricts the guest to a subset of available pCPUs.

This patch introduces the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
attribute. If set, PMUv3 will be emulated without programmable event
counters. KVM will be able to run VCPUs on any physical CPUs with a
compatible hardware PMU.

This allows Windows guests to run reliably on heterogeneous systems
without crashing, even without vCPU pinning, and enables VMMs to
schedule vCPUs across all available pCPUs, making full use of the host
hardware.

A QEMU patch that demonstrates the usage of the new attribute is
available at:
https://lore.kernel.org/qemu-devel/20260225-kvm-v2-1-b8d743db0f73@rsg.ci.i.u-tokyo.ac.jp/
("[PATCH RFC v2] target/arm/kvm: Choose PMU backend")

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
Changes in v5:
- Rebased.
- Fixed the order to clear KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY in
  kvm_arm_pmu_v3_set_pmu().
- Fixed the setting of KVM_ARM_VCPU_PMU_V3_IRQ in
  test_fixed_counters_only().
- Changed to WARN_ON_ONCE() when kvm_pmu_probe_armpmu() returns NULL in
  kvm_pmu_create_perf_event(), which is no longer supposed to happen.
- Link to v4: https://lore.kernel.org/r/20260317-hybrid-v4-0-bd62bcd48644@rsg.ci.i.u-tokyo.ac.jp

Changes in v4:
- Extracted kvm_pmu_enabled_counter_mask() into a separate patch.
- Added patch "KVM: arm64: PMU: Protect the list of PMUs with RCU".
- Merged KVM_REQ_CREATE_PMU into KVM_REQ_RELOAD_PMU.
- Added a check to avoid unnecessary KVM_REQ_RELOAD_PMU requests.
- Dropped the change to avoid setting kvm_arm_set_default_pmu() when
  KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY is not set.
- Link to v3: https://lore.kernel.org/r/20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp

Changes in v3:
- Renamed the attribute to KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY.
- Changed to request the creation of perf counters when loading vCPU.
- Link to v2: https://lore.kernel.org/r/20250806-hybrid-v2-0-0661aec3af8c@rsg.ci.i.u-tokyo.ac.jp

Changes in v2:
- Added the KVM_ARM_VCPU_PMU_V3_COMPOSITION attribute to opt in the
  feature.
- Added code to handle overflow.
- Link to v1: https://lore.kernel.org/r/20250319-hybrid-v1-1-4d1ada10e705@daynix.com

---
Akihiko Odaki (4):
      KVM: arm64: PMU: Add kvm_pmu_enabled_counter_mask()
      KVM: arm64: PMU: Protect the list of PMUs with RCU
      KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
      KVM: arm64: selftests: Test PMU_V3_FIXED_COUNTERS_ONLY

 Documentation/virt/kvm/devices/vcpu.rst            |  29 ++++
 arch/arm64/include/asm/kvm_host.h                  |   2 +
 arch/arm64/include/uapi/asm/kvm.h                  |   1 +
 arch/arm64/kvm/arm.c                               |   1 +
 arch/arm64/kvm/pmu-emul.c                          | 188 ++++++++++++++-------
 include/kvm/arm_pmu.h                              |   2 +
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 148 +++++++++++++---
 7 files changed, 288 insertions(+), 83 deletions(-)
---
base-commit: 9a9c8ce300cd3859cc87b408ef552cd697cc2ab7
change-id: 20250224-hybrid-01d5ff47edd2

Best regards,
--  
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

