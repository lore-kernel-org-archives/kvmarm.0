Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B387233C52F
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783682170; cv=none; b=jrVyHuedyfzdjtwpeF6RkR8G0YT1wvuB14dAiSQmGIr3sd28NWBjjf7zFzwCBjsZCo2+D1iWbaCnnB6dobWMfmpoZjPprzA2OAUiL+fcx5aE9XWnB1K9xx6pCKRYQtkHxACKqXeJr/fOr2IQbpGjrf6Vfo/rxZ9NM8aYDFbeYmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783682170; c=relaxed/simple;
	bh=3aaGkxuWYeIHEXxQ7jK2xLPaTuF44GG9raRCIo26jOg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=euWSgD0uspD/kmL4Gl+W/8DF29QoGdVnFI9k1+Gg5SXJh55ZIqP35QAMKcPeN6BG4vbxPCzoFmnGq0xGntxt5ewQjj6QjryNzXX+vtBZRabVQQVCFa63qtkQPZs2A/jE4/SPedjfZiP8ID1kgyHKIP7jndyhXGvUlhqDhVFPGFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=WFCDYw6U reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="WFCDYw6U"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66ABEvsE024946
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 10 Jul 2026 20:15:09 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=KGB+NKL0JfhCiL8lQAxj2/85FwyywY4aNanasRFKkk8=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1783682109; v=1;
        b=WFCDYw6UwvD01zELlgqWWQoilYBDJd876u90Q9LWxE0DzNG/4H/ncS1wa4ByRtD7
         42qpGj0Oi6BB3NOcHNO+Biwcksblt/HN1jBHyv1gVI9wtVMA34nNKKo5oN+C1Wgx
         IXhAgM1jqUFHq+EBt8IKQE7R3xKru10jMPx8zyW2HT167rD5pNfU87hFhcyT4xph
         dQOqSiS/96vwp7N58zdhknJgZyK/uQD0N9edcBI8s+ow0cGy4GAjVElIkgvzDaWW
         Dz8kexKiVA5XoT81MtnakTmS+lPVG8b7kvXm4YQ6/A+9qyLbnyGRp/iOr/tvWlIg
         LATdvOWMJZkc7xlkeUGuQQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: [PATCH v8 00/11] KVM: arm64: PMU: Use multiple host PMUs
Date: Fri, 10 Jul 2026 20:14:54 +0900
Message-Id: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33Ry27CMBAF0F9BWdeRHxM/WPEfVRe2ZwxuBaFJi
 IgQ/14TRGBTltfyHF+NL1VPXaa+Wq8uVUdj7nN7KMF+rKq484ctsYwlV5LLhksJbDeFLiPjApu
 UwBCirMrlY0cpn2fo8+ueO/o9FW+4H1bB98Riu9/nYb0SRNKgj4EajICUwArjAK1zqE3gCI3h3
 EF1s3a5H9pumjuOYsbmOkq4R51RMMEAhUcvOBnebNBPh3yuy4OzMcrnnOV6mZOMM6618BSVTzZ
 uun5bx1zn+sSG9mdqax/r7+PdUA9Dl1U0i6GKAZpsIim5tfytAU9DCbMYUIyAWoaIYDXAW6N5G
 iDEYjQ3g4MKgC6Bo7eGfjXUYuhikHFoNE8mifDWMK+GXQxTDBmSch7LH4b0r3G9Xv8AO8RVVIE
 CAAA=
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=6022;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=3aaGkxuWYeIHEXxQ7jK2xLPaTuF44GG9raRCIo26jOg=;
 b=kA0DAAoWKJ19aUZYEjEByyZiAGpQ1DOjADdd99DcVYORyjtI+t88DTfQUdvgMtOperExO9rXD
 Yh1BAAWCgAdFiEEZHK7CyhbffJxYF+EKJ19aUZYEjEFAmpQ1DMACgkQKJ19aUZYEjEN2gEA+2De
 2VjJrhKOkt/4XcDubhTXeZN+3XmBBa+PbVtQr24A/iFHmD5h9H3xKCIWyNP1J6+prxFIAzFdp8E
 oR9TdNfMA
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
Akihiko Odaki (10):
      KVM: arm64: Serialize userspace MDCR_EL2 access
      tools headers: Sync bitfield.h with the kernel
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

 Documentation/virt/kvm/devices/vcpu.rst            |  30 ++-
 arch/arm64/include/asm/kvm_host.h                  |   4 +
 arch/arm64/include/uapi/asm/kvm.h                  |   1 +
 arch/arm64/kernel/cpu_errata.c                     |   2 +-
 arch/arm64/kvm/arm.c                               |   3 +-
 arch/arm64/kvm/pmu-emul.c                          | 185 ++++++++++++-----
 arch/arm64/kvm/reset.c                             |  16 +-
 arch/arm64/kvm/sys_regs.c                          |  39 +++-
 include/kvm/arm_pmu.h                              |   2 +
 tools/include/linux/bitfield.h                     | 175 +++++++++++++---
 tools/include/linux/bitops.h                       |  19 ++
 tools/include/linux/compiler_types.h               |  13 ++
 tools/include/linux/typecheck.h                    |  34 +++
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 229 ++++++++++++++++++---
 14 files changed, 635 insertions(+), 117 deletions(-)
---
base-commit: 1ee27dacbe5dc4def481794d899d67b0d4570094
change-id: 20250224-hybrid-01d5ff47edd2

Best regards,
--  
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

