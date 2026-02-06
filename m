Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D45223183F;
	Fri,  6 Feb 2026 22:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416815; cv=none; b=McWy2GkWuFJPPmoLQn0EVYR2X9pRy53ZSXbIUAQIGzjfQEc6mWTfKLvPErrMvApU9tndbfu3jLsuknG0nThMbHMhoF6aPMNxzlFbaDbgpeJYjSkyU2K+8hzqs7cL6qBwhwSknR7Q7UWqTqpx9bKzATZUHOi36Vq6vEo2TKutjWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416815; c=relaxed/simple;
	bh=Z+P7HrDrYZhvrXjWO/SCgx6Wkp8oj6hqSqLe9QpQvAM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OfoqdnRYB142kX7PVjKjwvk+JpLZIRAOZ+9naFkvtUCur2XcBl8loDAasZCf80lf5G5rYDO3MVOboBCGnhu5wiQdXEYfjt6oT9yoFfXNVdAs9K/Q/n3kcbxspEDaqfJtAJDIpYNUMWPAxLeiNDLIiS1nEiZmAs03F3HfcpY04yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/maTH/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/maTH/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB44CC116C6;
	Fri,  6 Feb 2026 22:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770416814;
	bh=Z+P7HrDrYZhvrXjWO/SCgx6Wkp8oj6hqSqLe9QpQvAM=;
	h=From:To:Cc:Subject:Date:From;
	b=M/maTH/1GyOlJkiHrZKDc6WK0xeBjxKw1HvwqPCvah5JK1++SWHgWMbV3Y0mSGTjK
	 CpZZXdUyhd4rU410K1s3yW626p1577koXehF3YkzRVQ8p8ORHQfwlNvphsqbC398aC
	 q5SVGaB23LNdFvF8/d8WsN+JsU+LwPDKSmSgCqw5QYRO9kVM5xLM+Y6BUjKHOxwdhd
	 Xs7uJ+Ia0OCGL+oAweuGhGdb/ltItYQ2owycnyHTlSNzmf2iLJPB4LYobVkfoLUesK
	 Ga6njLR/hvHpNCFpoRx/00jjo3lXCc4XB0ozknFOSmCxObWz8oiIhgEjSEv6rYeuDr
	 +0RE1J+g3K06g==
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
Subject: [PATCH] KVM: arm64: vgic: Handle const qualifier from clusters allocation type
Date: Fri,  6 Feb 2026 14:26:53 -0800
Message-Id: <20260206222651.work.438-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1571; i=kees@kernel.org; h=from:subject:message-id; bh=Z+P7HrDrYZhvrXjWO/SCgx6Wkp8oj6hqSqLe9QpQvAM=; b=owGbwMvMwCVmps19z/KJym7G02pJDJltWWsm2YrXNq9aeMTh01VWJk/NwpdsFbfYLBvUdOU+z V628/m8jlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIk8fcHIcDYzXplRz27B+tNP fjwydD3mzqdebzrJ5XL6Fjaj7Ik3eRkZntRbnppy8lRV/s+d/65kK+3+OYHpxeIJE5m56m7etGD azwIA
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

