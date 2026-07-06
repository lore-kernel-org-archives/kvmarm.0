Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80424399D0B
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333900; cv=none; b=T8Mx9RUGoSnImql5FLuWzArDWVHrBRkTjZLO+klZNeDeDb4iu8pwvxHCI4/FRmEdN3E6CyF53WEr+83nflT9iM24Lf8xg1JpOMf2OD4re7PBSvgufONd0QQ2HmCwVzhBepB0P0SWQSMEk60me0YoKV96q4zMUOIY3i+EpgD8Zss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333900; c=relaxed/simple;
	bh=1Z2XhL+3hKgRZI6GDMz8mA84rT1nUUZh8LtzZRCAPhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DdYpAVfuR3thIlHnF8bslz2FRN9kvY6Zui62CZOmT+m6BZR+SDunDDl/jYdzRFYmTfnw7/Dc63RyJgC+SFNTD4NgoqINQ444fQRc5rZKtKNM30uR5hkYTwQzGIE9pjB8V3NyXaDRWOnqjmPRHDUo/hzFGRxdo9zTgLFA6ejuZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IajJPIGl; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IajJPIGl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783333895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CuO72JfKDbuNyxGesiw5wyOL5OP8x9v+ytvsBtPJ/oU=;
	b=IajJPIGlCBtTgI6HpIM09f/HVfCMzO/d7TI5MpyP5N7DWtHPYYtN/91t6wptSy7NI1V+4x
	l3oFVy70/b7AdYWG1IhV6GeoW5yN5p7D9Rm3WQYe4VT8dPsPuVTa5kCnlZw7apTk1QgxMs
	f0T2CRyJlTXPbuLE4HCc7H+L/EFN87k=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Keir Fraser <keirf@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: arm64: Drop the unused EL2-side is_created write
Date: Mon,  6 Jul 2026 11:31:27 +0100
Message-Id: <20260706103129.706974-2-fuad.tabba@linux.dev>
In-Reply-To: <20260706103129.706974-1-fuad.tabba@linux.dev>
References: <20260706103129.706974-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

init_pkvm_hyp_vm() sets is_created on the EL2-private VM struct, but the
hypervisor never reads it: pkvm_hyp_vm_is_created() and every other
consumer operate on the host's struct kvm, a distinct allocation from
the EL2-private copy. The field is write-only at EL2.

Remove the store; host-side is_created tracking is unaffected.

Reviewed-by: Keir Fraser <keirf@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3b2c4fbc34d8e..c54aa5031336b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -433,7 +433,6 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
 	hyp_vm->kvm.arch.pkvm.is_protected = READ_ONCE(host_kvm->arch.pkvm.is_protected);
-	hyp_vm->kvm.arch.pkvm.is_created = true;
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 
-- 
2.39.5

