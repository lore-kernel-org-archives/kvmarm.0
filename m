Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C382D5935
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 06:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773729751; cv=none; b=loWqG1A/Dqp41Biva8BWQLJSw67orwY5jH8NaYDlsMqraU4EpL3bUWNGx7Ynzxaa1+eZnr8B+30GHXwBnt6V/U62VxVFG9Ng7fGpc1ZK0hhq4mqrqjzyP5qvDUQD5w85BccSkd8Ze3C65i6x/UGCK7qpMq4FlqhIzeNPGtNonII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773729751; c=relaxed/simple;
	bh=p2jT3cj/dqZTMqBPRODxsJKcCAfEvHGxzp1GHCe76zM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GkEMsmxP+biIglikbKx26VzTub2xfxKQNY5YwhoTXWj1/uifTu33omV0mPH3UZS5PyTY2BT1v5ATJ/8n5pQIRSjfgKlN8dhVbjzV+HRjujnPPC/cDMehzLIuaMib+dFqef9sztEZU1eiFEAkkQAy1CBOHV8QWN7bWjpAd+l2egM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=T3VWcd1T reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="T3VWcd1T"
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 62H6aoNk004343
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 17 Mar 2026 15:37:00 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=tQPLRdcG2BXep0eW/gY1gtA4+gQ7V3cwSUUxElynWig=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1773729420; v=1;
        b=T3VWcd1TYTjORfLvRhbKQXTFPIx/BVQzEBmsUG8cr7eJaO/QTqKPJimcC/hR7t5r
         eADzWIjJ95qHfYNzy3ZahUpM77rolDmiRDbPunHJRA0x+69do3sjoB5XRVZpRxw6
         Lr/k1gF2GQWwrcQOzvpr1OvTerXfGawV8A+4dxUoS2keyVT20/s5z/N2SLbdEmXV
         bNW4/Ut2waJ7Isovenp+pTEBBxgrwQT58qm5MPxiorlUdzK8BsRqIE2BmBv3SxtZ
         T/5XcaV+Ltev9xBZtUVuP9F4Wuifs9DjPb7VaDVEJXW+WNV83s441nhDCGUq37qj
         Rjl9IPT2VvPGPenpVNoEAw==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: [PATCH v4 0/4] KVM: arm64: PMU: Use multiple host PMUs
Date: Tue, 17 Mar 2026 15:36:48 +0900
Message-Id: <20260317-hybrid-v4-0-bd62bcd48644@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAID2uGkC/3XPQW7DIBAF0KtYrAsaMCY0q9yj6oLAEE+r2Ak4V
 qzIdy/FSrrq8qM/b5gHy5gIM9s3D5ZwpkzjUIJ+a5jv3XBCTqFkpkB1oJTm/XJMFDjI0MWodxi
 CYqV8SRjpXqGPzy0nvN6KN22P7Ogycj+ezzTtm9kIaYUE9tvtKU9jWuofZlnLdV0r35/rZskl1
 0G64CTgDrpDcMtAd1HAaszqb86Cec0pDhyMkQ5966L1h5RPwpMgcePT+L2MwnnxddmM9mmYcmr
 3MtpiaIM2olJgLfxrrOv6Ay7e7ftRAQAA
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
 arch/arm64/kvm/pmu-emul.c                          | 190 ++++++++++++++-------
 include/kvm/arm_pmu.h                              |   2 +
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 148 +++++++++++++---
 7 files changed, 290 insertions(+), 83 deletions(-)
---
base-commit: ef87500dc466ef424e4fc344b5063d345e18bf73
change-id: 20250224-hybrid-01d5ff47edd2

Best regards,
--  
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

