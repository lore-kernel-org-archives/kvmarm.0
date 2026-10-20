Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514373;
	b=psqE5Jiso/ijUXDWjVzq5c6sRERi3d4Gw3q/fCT+/DgzwGjs85J+5kdJ5vm426p3MgKd
	 6co3x+gV9+AyCXCw80eUXuxjLlSHtQOoq5W5pr+7b2SxnYt0btN1N9E5uHD5+cJt7uyaJ
	 JrwPFPYkQUh/y9R702GjqTrFXq1ydIKTokwA0aoScCVmr68sKnTRFV9hhnD+lmTrbW6CW
	 Pfq4bmrvEFODunVa82Hd4hgtjqzX8ho1GRzrvaCVzXQdwN5uboUh+2lWQGOIKmla5KQYk
	 +TUSvrsuYE116/M9/3/TaAYq3Ugk4+NMZ8k4tclNUWcze7m0+yCtpxa25ddN1KNrVDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514373;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=830H2YTMFkD9IORfLXHCHq/I9Z/gK3pKXYSwz8rUqk4=;
	b=wI/KoBOp9qDvd/rvrLVnHvKJFGsdFS7EbxuInRJ1sSzGcHK++zJHYetBJwHker8oySVy
	 FF2BKZLQrXJ7NfCcAVZFDX+sOdBL6kUXLaCQiMyJUrLpcNsUgCowfRGO64rgSnP3ehwIh
	 g8YsFFag1I4iL23UArQ1xwjwUDCB95OxkwNBiygQrkvITsjYKNVwq5A7A6AWNt05B9b7N
	 OvbuC/e7XlUl0N3h/LUgdbf4LwAgP7G+wmZVRGFYt9KgxNDtfG0ONPZ0bTqkh6Ls4zKLy
	 U4VS4tup1cFb9LEfSXmUTsFvsY47OzNNS2j5ilUigq0/IXX6bv7sV/4U/ShtEk9WsBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b7Day1CE;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A79606A32D
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 16:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8A79606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b7Day1CE
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A83B11596;
	Tue, 20 Oct 2026 09:39:28 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DF2F3F7D8;
	Tue, 20 Oct 2026 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792514371; bh=5rR7Cm0/WLTiRNhzJ0pe4uv+L2juToro2br9wZ5Wk7o=;
	h=From:To:Cc:Subject:Date:From;
	b=b7Day1CEKJw+adAz90dZ+i2OF/o9tpbIQwSTwJ4ylGS+KplNNCbhZCKNN++pf9BBr
	 qFE6tFRuSCdkcl8+sYER64nWZigWMmAu2baN6JcHltYCx56t4ksOu99o1v7bLXndR4
	 bsYa/3TIyQWq7L81Ox3D77JOKo6n5XCDV1rjQhEM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: [PATCH v3 0/2] KVM: arm64: Reject mismatched VGIC/ITS models
Date: Tue, 20 Oct 2026 17:39:21 +0100
Message-Id: <20261020163923.1407856-1-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a GICv5 host with legacy GICv3 support, KVM exposes both VGIC
models to userspace. A VM can create a GICv3 ITS alongside a GICv5
VGIC, because neither creation path checks the model of the other
device. The ITS sets has_its, but a GICv5 VM cannot use a GICv3 ITS
for MSI translation. Creating the ITS before the VGIC also lets
userspace select an incompatible VGIC model later.

The same issue affects GICv2 on hosts with GICv3 ITS support. KVM
previously accepted a GICv2 VGIC and a GICv3 ITS in either order, then
ignored the ITS. The new checks reject this pairing with -ENODEV.

Record the VGIC model required by a GICv3 ITS and reject incompatible
device creation in either order. Drop has_its in favour of checking
that its_model matches vgic_model, so an ITS created without an
in-kernel VGIC is not reported as available. The second patch tests
both orderings of the GICv5 mismatch, skipping the test if the host
does not offer a GICv3 ITS.

This series is based on kvmarm/next-7.4+fixes-7.3-2.

Changes since V2:

* Check vgic_model in vgic_has_its(), as pointed out by Sashiko [1]
  and Fuad [2], so an ITS without an in-kernel VGIC is not reported as
  present.
* Document the GICv2 behaviour and make the first patch subject
  independent of the GIC version.

Changes since V1:

* Worked in Marc's suggestion to drop has_its.
* Check for its_model being non-zero in vgic_has_its(), allowing us to
  drop has_its.
* Added a comment to explain what we are actually doing. Again, Marc's
  suggestion.
* Changed the type of vgic_model from u32 to enum kvm_device_type.

Thanks,
Sascha

[1] https://lore.kernel.org/all/sashiko-outbox-177254@kernel.org
[2] https://lore.kernel.org/all/CA+EHjTzqKiWr2tnV0rUiA4VVCs5a0E2XQQTdwvH0bTKZ5dxe5A@mail.gmail.com/

Sascha Bischoff (2):
  KVM: arm64: vgic: Require matching VGIC and ITS models
  KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC

 arch/arm64/kvm/vgic/vgic-init.c             | 17 +++++++++++
 arch/arm64/kvm/vgic/vgic-its.c              | 15 +++++++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c          |  5 +---
 include/kvm/arm_vgic.h                      |  5 ++--
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 32 +++++++++++++++++++++
 5 files changed, 67 insertions(+), 7 deletions(-)

-- 
2.34.1

