Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B47D4369A
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 04:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771993961; cv=none; b=i90OvsgWZCiqwnOCiWJMG2kmNAvr/vO/6jol//6uSM1CwZ+rwR0i6YyVj+zzGEvkkqaJ4/F02vcNWDurOsQy7ZzXBTRki0FudR5nS6wxoQ8viC7122SYnAtTsWaTGxQ1859umYFdggbrBqi7NM8q2RTCXSDvgTssXQ4kefMqyN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771993961; c=relaxed/simple;
	bh=5XtVwyeXgb+yTy5ksSKN/Zir4fuzN7Do5I/MI3EfCZY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=cIB/3qM6ZiNqi9DeVi4F2PYVeleUR8e+TKEZHIIRhBYiAwyTCzBzOD+HdCmQMAKfUPqHq54+bbqbx6Pr+3a5U1RNmyb5xvZTyHyAMr/OLnZd1e9MRWlzwyRYIbIPXrV7mZc94Fy5uVH80sbCDuLdb+132wyUwOwvqea8GEhX/uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=s3K51MkF reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="s3K51MkF"
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 61P4VKpP082120
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 25 Feb 2026 13:31:24 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=MYO+XchwOpRTBTIhxbmQzhbl8T24Bkei/zh10k9CJ4U=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1771993884; v=1;
        b=s3K51MkFc/3//s1kyweOLqGgEpf6nlXdoRUL1yRvznAIaVnT2Ytnh7XjWWRxxM49
         R8i5A/xP7HU9X9/zINgMcMsb7wmCZN0NPfyXqZywQeqCfboTohQXtHtZv2nbhVNM
         Q7E8dEuq/sLiXkZteOvPonOCeOxdhT5gnI2d32wNFWDJ+rYgssiy3X0oGx1pznHH
         wAQ3ClS/ZnxV7/UC9oWIMi9cPoCkJY3VZQmSTdeEJVASaFI3HWu5pIpfAr3RazRK
         8A+mx0t3ontSTAiCiOixdRshouRjSQMLWzZ8NxeBFvp1y4zXI4OGevx47aPfgIEz
         bwvXtHfycRaHiK+Du7vA5A==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: [PATCH v3 0/2] KVM: arm64: PMU: Use multiple host PMUs
Date: Wed, 25 Feb 2026 13:31:14 +0900
Message-Id: <20260225-hybrid-v3-0-46e8fe220880@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABN7nmkC/0WOS47CMBBErxJ5TVtu50NgxT1GLIzdIQ0iBjtYR
 Ch3H4/RzCyr9epVv0WkwBTFvnqLQIkj+ymHelMJO5rpTMAuZ6GVbpXWDYzLKbADha4dhmZLzmm
 R4XuggV9F9HX85ECPZ/bNn6M4mUhg/e3G875KncReohI/7Mhx9mEpPyQscJmrcfc7lxAQGofGG
 VS0Ve3BmWXil8zC4kj6v9er7q+nQYHqOjRkazP09hDiWVqWLJ8w++vipbHychfHdV2/AVPJoR8
 NAQAA
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
Akihiko Odaki (2):
      KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
      KVM: arm64: selftests: Test PMU_V3_FIXED_COUNTERS_ONLY

 Documentation/virt/kvm/devices/vcpu.rst            |  29 ++++
 arch/arm64/include/asm/kvm_host.h                  |   3 +
 arch/arm64/include/uapi/asm/kvm.h                  |   1 +
 arch/arm64/kvm/arm.c                               |   8 +-
 arch/arm64/kvm/pmu-emul.c                          | 155 ++++++++++++++-------
 include/kvm/arm_pmu.h                              |   1 +
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 148 ++++++++++++++++----
 7 files changed, 268 insertions(+), 77 deletions(-)
---
base-commit: ef87500dc466ef424e4fc344b5063d345e18bf73
change-id: 20250224-hybrid-01d5ff47edd2

Best regards,
--  
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

