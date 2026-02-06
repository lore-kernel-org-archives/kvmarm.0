Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8D43112A5;
	Fri,  6 Feb 2026 22:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770417024; cv=none; b=Gdaks7+8vrpUgj7otPxaZUkcTpY3MmEm7V4Z4f1WnDLDZ4gv2XUnb9HLxe87NnGXyugclskDhUhyZfW728H636rz9N2f5eLqjijdUL20rXC+CWObWzBYkCoAaPu4rRiDT0MsdNFyr1rGnPo/fG55a73SHk+XJCzCfzOyixMC09k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770417024; c=relaxed/simple;
	bh=Z+P7HrDrYZhvrXjWO/SCgx6Wkp8oj6hqSqLe9QpQvAM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sYAUvX554PkI8/aeh7O2ONc1JJGd2QBmaF7ywsv2UFdJqqJFXNWn9TWi7TsLn874OZ18gmyrbBoByo9g4axS0K2+Caki4V4e3K5r2k1bT5kNNdDnLCyD6NBSjgPRJkNUpFaDXrx8rwOk4cDclTbUxCIcdX3QNOo/XscKqhEQbds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZixVzDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZixVzDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A29C116C6;
	Fri,  6 Feb 2026 22:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770417024;
	bh=Z+P7HrDrYZhvrXjWO/SCgx6Wkp8oj6hqSqLe9QpQvAM=;
	h=From:To:Cc:Subject:Date:From;
	b=RZixVzDlQcmxliDsdgbBvba8CQr/38HpatiUFUEio41v7SzCNDKFkyw7r5mxlyWv2
	 BFuYfwiRfCZiBi0NFPJyT5zx9heNWOJ1Q2q/gn38L195rvAEFzMWi2vEn+9AJnBfao
	 +vjLEp+TI4VwQmYYm20rnp4aicmPAG1tiMlv6RAlJROYBBIZho71UEuEbrH8yCefLV
	 f4NagEmymUmRFHjsOIL/j6P4Upw/DFHiUuSdmMtYbf57b02LGp6wxN2fWhsFaVTwH6
	 NE0d17ppKXpdceoJc2URuqHFR7TR5XVR6jUxB9tsrKJIRvybfrjwjMFB+SuPpA1f4S
	 0W9S+nSw6FI0Q==
From: Kees Cook <kees@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Timothy Hayes <timothy.hayes@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Keir Fraser <keirf@google.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: vgic: Handle const qualifier from gic_kvm_info allocation type
Date: Fri,  6 Feb 2026 14:30:23 -0800
Message-Id: <20260206223022.it.052-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1571; i=kees@kernel.org; h=from:subject:message-id; bh=Z+P7HrDrYZhvrXjWO/SCgx6Wkp8oj6hqSqLe9QpQvAM=; b=owGbwMvMwCVmps19z/KJym7G02pJDJlt2XXH+BYzTOSa/XXJ0Yj1H2MCn/2M2yqvucMk69/l5 YWT0sQ5OkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACbyKILhv/Pt5RPPBTXwM8wV nhicN3vj280Pa6e6sogzn/jy7ndLvzHDf693SgXyNXuSl138vm/+UYbU8w51X1lsDNb3/lgcLjT vKycA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct gic_kvm_info", but the returned type,
while matching, is const qualified. To get them exactly matching, just
use the dereferenced pointer for the sizeof().

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: <linux-arm-kernel@lists.infradead.org>
Cc: <kvmarm@lists.linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 86c149537493..a53f93546aa0 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -654,7 +654,7 @@ static struct gic_kvm_info *gic_kvm_info;
 void __init vgic_set_kvm_info(const struct gic_kvm_info *info)
 {
 	BUG_ON(gic_kvm_info != NULL);
-	gic_kvm_info = kmalloc(sizeof(*info), GFP_KERNEL);
+	gic_kvm_info = kmalloc(sizeof(*gic_kvm_info), GFP_KERNEL);
 	if (gic_kvm_info)
 		*gic_kvm_info = *info;
 }
-- 
2.34.1

