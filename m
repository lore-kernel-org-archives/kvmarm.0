Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530F04399D7
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 20:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752045; cv=none; b=iPp4xWIGg93MxHi8C4C4xWXkx8xqrsd8XQ9egWsPImGGmvoDYOlyIsu/FVAnvEl8jrn6+nlI1LQXnlZtyQtm246Hh4mw8buU3kw94/BILOJv8BzlJGoMt8BkRxAOL50J8yqcDI52RXJRPaZWJUVfYTRl6plimKxrlzhmm4ws5EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752045; c=relaxed/simple;
	bh=hN9HnHzfzYH03enqf/d/PFa8LLaAg4NPGDd5QM6ZBlo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GopdohLGyMZHKH4MblZNak5mijxJp/cE0mkKvr65SZH2s7CiZUuiUwJnd7EMPfpih4zY4T3CmEjzIv9ia0uvlp/4So6eDR+oiDiIN2bxkx+VGd1Zv4ZkGDLC73+yft1AnRZtWdGhvV4KMMNyuAXYBBrwO/dPRDlFFfyBpiYZJCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=dCIOtVf7; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="dCIOtVf7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784752044; x=1816288044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/2r/FxGKWALSDQS7gcX3VsAvCtPvUfjfU8VvkzFAnw=;
  b=dCIOtVf7ptgaJJvSm3KhOQPNThBMLfL31xc0VxKaSFX8I9ewxkfsXgOV
   oD+pZcp46zSHsWgwVpP4oD3dkjkc34IvBBuxQW6doyAilwqWo1UD9hQ0p
   /bUDQpkK4y32p31/KFgHy5FqPi8RmBG9IEv3JrdZqkC47kMQWJ70tovBN
   8hk2/rJfL1YwVaBba855gao68zGrhtwKoCe5Q95ZTOuVpFQ86UmuQoYOI
   nsJ0jmOmkdJ2AeOGnAZRiLkYdXDWoO6ty/T1P97vkoqrr4OdhhHCzARNg
   dPXB7KiRy6joqhVC0CoarEmn4VJHGkxK72PJvYIFnnt/JaJrg0iPhvsU9
   A==;
X-CSE-ConnectionGUID: 07WjkSdJTRiNjRMtdabEcA==
X-CSE-MsgGUID: mpRXSEovSaOifgua35QxSg==
X-IronPort-AV: E=Sophos;i="6.25,179,1779148800"; 
   d="scan'208";a="24201992"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 20:27:23 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:6195]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.59:2525] with esmtp (Farcaster)
 id 8a451785-e587-4cec-becc-ac08e7c16abd; Wed, 22 Jul 2026 20:27:23 +0000 (UTC)
X-Farcaster-Flow-ID: 8a451785-e587-4cec-becc-ac08e7c16abd
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 20:27:23 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 20:27:23 +0000
From: Congkai Tan <congkai@amazon.com>
To: Oliver Upton <oupton@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: Congkai Tan <congkai@amazon.com>, Marc Zyngier <maz@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, "Haris
 Okanovic" <harisokn@amazon.com>, Geoff Blake <blakgeof@amazon.com>,
	"Stanislav Spassov" <stanspas@amazon.de>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/4] KVM: arm64: Ignore writes to PMCR_EL0.N when using strict UAPI
Date: Wed, 22 Jul 2026 20:27:01 +0000
Message-ID: <20260722202702.4165917-4-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260722202702.4165917-1-congkai@amazon.com>
References: <20260722202702.4165917-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Oliver Upton <oupton@kernel.org>

KVM allows userspace to configure the number of event counters by
writing to PMCR_EL0.N. While this makes a bit of sense prior to NV, the
value of the field is context-dependent whether or not the vCPU is at
EL2 or EL1. As such, the vCPU attribute was added afterwards and made
mandatory for NV.

As we're in the process of papering over old mistakes, force userspace
to use the vCPU attribute if KVM_ARM_VCPU_PMU_V3_STRICT is set.

Signed-off-by: Oliver Upton <oupton@kernel.org>
Reviewed-by: Geoff Blake <blakgeof@amazon.com>
Reviewed-by: Haris Okanovic <harisokn@amazon.com>
Signed-off-by: Congkai Tan <congkai@amazon.com>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4c6f608c4fe5..e93f11b90813 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1502,6 +1502,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	 */
 	if (!kvm_vm_has_ran_once(kvm) &&
 	    !vcpu_has_nv(vcpu)	      &&
+	    !kvm_vcpu_has_pmuv3_strict(vcpu) &&
 	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
 		kvm->arch.nr_pmu_counters = new_n;
 
-- 
2.50.1

