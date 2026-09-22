Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B3E3321C2
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062726; cv=none; b=WxmdDG8t0W0UJHFTIvStBOSWz9awei9vHbVqM5lCcGCobtTioRTcE8ya/nMKA+vNc89d8SroXvnilo2tYq+PPo6GUKVczIEvX6weoq4sjbJ+s3zcgVeQwkFWEWGZmKfX69yT0bjcVPeVBvUgRvQfVRy4e09iWjCxr6VWg6w2VhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062726; c=relaxed/simple;
	bh=KUW89faoHHYWgqCz8nIDgkYnfX7c9yryPkJWlGTaNK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mD6eGORsNSIJv4D0PW3ehn52NP7915GN3MCYFMD5zwLI3WAevFz5Jf26IAmehp+4xvna80+yYy/XBk9jLVu9QsrdvvQjO1MkpbCiR1VEN0UHZ/uajHEKGUnFYz3kKtl0C+D+za2yiteM3Od8kZmxRfsokboOIIZR24d9GlOBNX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OSYdRr0f; arc=none smtp.client-ip=91.218.175.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OSYdRr0f"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=KUW89faoHHYWgqCz8nIDgkYnfX7c9yryPkJWlGTaNK8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790062722; v=1; x=1790667522;
 b=OSYdRr0fGPy2D1S9U6xWX44CKWx8Jjqulhl3rC8oOpJmHxUI/awWk1r6QZM5OP8myxIOJ4ok
 2VV1cRSlHUw7Cr9E/KDDuOLQwAgl7TzHbTaEVNDqnjdxaKfCAp9QoqQDs/jNsYTS73ONi/G8Xal
 nsdXNFzMKRDOT0gXbXJuvH1M=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2b90d64f45864352;
	Tue, 22 Sep 2026 07:38:42 +0000
X-Mizu-Trace-ID: 2b90d64f45864352
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com
Subject: Re: [PATCH 6/7] KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
Date: Tue, 22 Sep 2026 08:38:37 +0100
Message-Id: <20260922073837.705872-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915123846.2317931-7-fuad.tabba@linux.dev>
References: <20260915123846.2317931-1-fuad.tabba@linux.dev> <20260915123846.2317931-7-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

On Tue, 15 Sep 2026 13:38:45 +0100, Fuad Tabba <fuad.tabba@linux.dev> wrote:
> can_access_vgic_from_kernel() excludes only the GICv3 system register
> interface, so on a native GICv5 system without FEAT_GCIE_LEGACY it
> returns true under nVHE. The kernel then saves and restores the CPU
> interface from EL1, where ICH_VMCR_EL2 and the ICH_PPI_* registers are
> UNDEFINED, and the nVHE world switch already does that work at EL2.

FWIW, I've since run this on the FVP GICv5 model (support_virtualization=1, kvm-arm.mode=nvhe). On kvmarm/next at 23ddf997ab16b the vgic_v5 selftest oopses the host at the first KVM_RUN:

  Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
  pc : __vgic_v5_restore_ppi_state+0x10/0x9c
  lr : vgic_v5_restore_state+0x28/0x3c
  Code: d503245f a941240a d0012448 91160108 (d51cca0a)

d51cca0a is the ICH_PPI_DVIR0_EL2 write, from EL1. With this patch applied the same run passes.

Cheers,
/fuad
