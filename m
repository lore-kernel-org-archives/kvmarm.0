Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB43F44470A
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386171; cv=none; b=tlDlvMcRxad9q3hmuSwVsYqsIz8SyfPN8UZRrRRM3ExDdAkeC+R6l5jQ7mmdKDPRgUqeRTXbM424otGtrzmCv9e/1nh0ZAGy0ctxZN1pkqlhBXpoZLvdf3046Xf1nOkJJg1WZ2JCE/rDd8elLTbfBEHN/TTeQBXoBO+j46f2WsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386171; c=relaxed/simple;
	bh=o8fTXStbLCDzi1cW4/ZSNSqXdyHDp4XBx+YdTvNXLLY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=rOLo3WIuDZewWjRsRQcucluZup228+WRrUFGdUfNlx6BKnnFLybKlf+8TcDEOxSdscLD90nmlx1L6X1JIQIHSCDx+cjwazX79yh67x9rfdU/mooagzGMK4nGgVWVgBXFo+lvHJATfJnKpKYgY0zMVDnLyhk9zrl+xWIDGheJVhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=eQOPaj6u; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="eQOPaj6u"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjs2084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:51 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=rvcVIldn9D1+tXkiYXT7bU726RTyCQhgaN36SI3Cr/s=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386111; v=1;
        b=eQOPaj6u1aqv/7jZy+RiJ8E+5DQBgBb+eMdMnEXjlFjOCkQc4p7WZgHH3sfFvR/4
         vrHkjepp4WPoiEFpEpwyhmqYI2ggJVzSUGE5HaaF6uCXCJTvfZM5AOa6Q+6Yzb8u
         qzxJvI2RI9txxj62suMm3CnHP7f0SsGmj1dlyuVxHf3mJe90qtAsu+Id1ugdfwRL
         MKdwTjQy/F4EvlIRFknFxq0LDFP36F7nc5VVWOu3zPocLX4lxlANJQzQ8sYCsOJc
         c+/y5gRv39Bsm/yDM2mFEDo2sHVzXZ7MQbvjv6bQ5GlvMABfTdtoVz/yoZw5JGCk
         PAua/UbEgv4+jWWnMYyH8Q==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: [PATCH v10 00/20] KVM: arm64: PMU: Use multiple host PMUs
Date: Mon, 14 Sep 2026 20:40:39 +0900
Message-Id: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33RS27CMBAG4KugrOtoxm93xT2qLvwEt2pCHYiIE
 HevAZGwaZbzy/ONR3NphlhyHJr3zaUpccxD7rtaILxtGr+33S6SHGrQUKACKOVkP7mSAwEMIiW
 uYgi0qY8PJaZ8vksfn4+6xN9TBY9LuM/DsS/TfdqIt/ThMjRPd0SChAe0wSJEBWIb7NTlc+v7n
 +ZmjHTp0yDnPkqAgJRoo2c2ab8tw671uc3tiRz776lvrW+/Dg+DPQ1ZdxKzwarBZdQpUgpaw6r
 BF4Ohmg1eDRckdT5wLTlfNcRicMTZEDcDOHM8mMRNXDXkq8FmQ1YjKhOUhKQSulVDvRp6NlQ1q
 EvM2ABgXFo19GIohNnQ1ZAUOZjErDB01TAvBl0Mc/+HQuYtOhH+v+31ev0DL2L9v9MCAAA=
X-Change-ID: 20250224-hybrid-01d5ff47edd2
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
        Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=8650;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=o8fTXStbLCDzi1cW4/ZSNSqXdyHDp4XBx+YdTvNXLLY=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu5m/J/Ee2uWnunWB68MpF896zbeZKN2Ynif76JfGp
 LPBBy73dZSyMIhxMciKKbKkFO3m1oiu/VSYEN8CM4eVCWQIAxenAEwkio3hf9B0A4eVJQUxE9m4
 LcpV4srSHwj0dehGcep85e9+uEKWneG/b1Wr7gbbp3nB9wV4W2J4dq0SFQs5Wyt1dkL4uyvnn8z
 lBAA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

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
https://lore.kernel.org/qemu-devel/20260706-kvm-v4-1-089cac8c25c3@rsg.ci.i.u-tokyo.ac.jp/
("[PATCH RFC v4] target/arm/kvm: Choose PMU backend")

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
Changes in v10:
- Changed fixed-counters-only pPMU migration to request event recreation
  instead of relying on an enable-time compatibility check.
- Clarified that fixed-counters-only PMU emulation is unsupported when
  a vCPU runs on a CPU without a registered pPMU.
- Checked guest completion after vCPU runs in PMU selftests.
- Added patch
  "KVM: arm64: PMU: Preserve EL2 bitmap state during migration".
- Added patch
  "KVM: arm64: PMU: Recreate events after reset".
- Added patch
  "KVM: arm64: PMU: Recreate events after PMCR_EL0 changes".
- Added patch
  "KVM: arm64: PMU: Recreate events after userspace event writes".
- Expanded the explanation of why a late CPU with extra IMPDEF
  PMUv3 trap support cannot expose host PMU state.
- Link to v9: https://patch.msgid.link/20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp

Changes in v9:
- Dropped patch
  "KVM: arm64: Disallow vPMU when pPMUs do not cover all CPUs".
- Added patch
  "KVM: arm64: PMU: Stop updating MDCR_EL2.HPMN".
- Added patch
  "KVM: arm64: selftests: Cover PMU state in MDCR_EL2".
- Added patch
  "arm64: errata: Require Apple IMPDEF PMUv3 traps on all CPUs".
- Added patch
  "KVM: arm64: Don't clear vcpu->cpu in kvm_arch_vcpu_put()".
- Noted that fixed-counters-only mode avoids relying on the default PMU.
- Clarified why fixed-counters-only mode hides PMCEID.
- Added patch "KVM: arm64: Serialize repeated vCPU initialization".
- Added patch "KVM: arm64: PMU: Freeze counter count after first run".
- Added patch
  "KVM: arm64: selftests: Test SET_NR_COUNTERS after first run".
- Added patch "KVM: arm64: PMU: Recreate events after MDCR_EL2 changes".
- Clarified why extra IMPDEF PMUv3 trap support on a late CPU is safe.
- Changed fixed-counters-only emulation to taint the kernel when it
  encounters a CPU without a registered pPMU; see the commit message.
- Added patch
  "KVM: arm64: PMU: Keep implemented counter mask EL-independent".
- Added a targeted bitfield helper type change to tools headers.
- Link to v8: https://patch.msgid.link/20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp

Changes in v8:
- Added patch
  "KVM: arm64: Disallow vPMU when pPMUs do not cover all CPUs".
- Split patch "KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY".
- Documented the FEAT_PMUv3_ICNTR support plan.
- Ensured KVM_ARM_VCPU_PMU_V3_FILTER and
  KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY are mutually exclusive.
- Ensured KVM_ARM_VCPU_PMU_V3_SET_PMU and
  KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY are mutually exclusive.
- Dropped the code to support KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS for
  KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY.
- Added a function to de-duplicate
  "test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, ...)".
- Link to v7: https://lore.kernel.org/r/20260418-hybrid-v7-0-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp

Changes in v7:
- Fixed the vCPU run hang in test_fixed_counters_only().
- Link to v6: https://lore.kernel.org/r/20260413-hybrid-v6-0-e79d760f7f1b@rsg.ci.i.u-tokyo.ac.jp

Changes in v6:
- Removed WARN_ON_ONCE() in kvm_pmu_create_perf_event(). It can be
  triggered in kvm_arch_vcpu_load() before it checks supported_cpus.
- Removed an extra lockdep assertion in kvm_arm_pmu_v3_get_attr().
- Fixed error messages in test_fixed_counters_only().
- Fixed the vCPU run in test_fixed_counters_only().
- Link to v5: https://lore.kernel.org/r/20260411-hybrid-v5-0-b043b4d9f49e@rsg.ci.i.u-tokyo.ac.jp

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
Akihiko Odaki (19):
      KVM: arm64: Serialize repeated vCPU initialization
      KVM: arm64: PMU: Stop updating MDCR_EL2.HPMN
      KVM: arm64: PMU: Freeze counter count after first run
      KVM: arm64: selftests: Test SET_NR_COUNTERS after first run
      KVM: arm64: PMU: Keep implemented counter mask EL-independent
      KVM: arm64: PMU: Preserve EL2 bitmap state during migration
      KVM: arm64: PMU: Recreate events after reset
      KVM: arm64: PMU: Recreate events after MDCR_EL2 changes
      KVM: arm64: PMU: Recreate events after PMCR_EL0 changes
      KVM: arm64: PMU: Recreate events after userspace event writes
      tools headers: Use u* types for bitfield helpers
      KVM: arm64: selftests: Cover PMU state in MDCR_EL2
      arm64: errata: Require Apple IMPDEF PMUv3 traps on all CPUs
      KVM: arm64: PMU: Protect the list of PMUs with RCU
      KVM: arm64: PMU: Pass the pPMU to kvm_map_pmu_event()
      KVM: arm64: PMU: Pass the target CPU to kvm_pmu_probe_armpmu()
      KVM: arm64: PMU: Implement fixed-counters-only emulation
      KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
      KVM: arm64: selftests: Test PMU_V3_FIXED_COUNTERS_ONLY

Oliver Upton (1):
      KVM: arm64: Don't clear vcpu->cpu in kvm_arch_vcpu_put()

 Documentation/virt/kvm/api.rst                     |   8 +-
 Documentation/virt/kvm/devices/vcpu.rst            |  42 ++-
 arch/arm64/include/asm/kvm_host.h                  |   4 +
 arch/arm64/include/uapi/asm/kvm.h                  |   1 +
 arch/arm64/kernel/cpu_errata.c                     |   2 +-
 arch/arm64/kvm/arm.c                               |  18 +-
 arch/arm64/kvm/pmu-emul.c                          | 258 ++++++++++------
 arch/arm64/kvm/reset.c                             |  16 +-
 arch/arm64/kvm/sys_regs.c                          |  45 ++-
 include/kvm/arm_pmu.h                              |   9 +
 tools/arch/arm64/include/uapi/asm/kvm.h            |   1 +
 tools/include/linux/bitfield.h                     |  26 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 329 ++++++++++++++++++---
 13 files changed, 591 insertions(+), 168 deletions(-)
---
base-commit: aa8e5dc6a7a2a1141ab40706a51010adcd0e57d2
change-id: 20250224-hybrid-01d5ff47edd2

Best regards,
--  
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

