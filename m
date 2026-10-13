Received: from mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC3051C342
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791909821; cv=none; b=ncUTIKcikXW3d+QDKfmHNdc5l75AfUZ/ip6O3F8n6H98Z8RsuNWgnis4nkWbXV5Bctp3IZ3Ju3kEmAgmr5/iQXhI2xvDOk4j5UmM7diBplbzJscoYrPAEzCOtCBPieSh9Ciy9pDfSRo0j2om+uBMchV5tMoXrg+MotLWK3OEhqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791909821; c=relaxed/simple;
	bh=PcPBi5Nzv8M4w/Sm2h+bvnujrs8RY53hUJG3UM3gd0I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FGJGMVwShBe7wYElNzZ78vXnGTQLxSUZnOHmQpaKw2DqthtsJ/CeDykqKPVTUq6Dp/rJIAWmjPaEI9t2HtfExT5Ew+BEDxjl3/GGIdrIUQY4dgQd8JjaWghdtYoJlEDqIsP8IkkW/8gKGIlH0AriyIdggeji0qcjbsLmI6itmKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L6p04Btx; arc=none smtp.client-ip=95.215.58.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L6p04Btx"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PcPBi5Nzv8M4w/Sm2h+bvnujrs8RY53hUJG3UM3gd0I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791909816; v=1; x=1792514616;
 b=L6p04Btx8ET30VezN/nEa1qBe5y3MeH1mXZpXDpTt9009wRfldTfd12Q6oFvZosbYE/xLAAN
 K+MCceZdnASpd4GrNzdBSNSwoosHlWy6D0COo3yiZqq1Yggmd4Hr216CXT3NzR9z6gH7dB0DylU
 6r5Di41lhSh31fILH+jAgudM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id bb0e231c7fdb8771;
	Tue, 13 Oct 2026 16:43:35 +0000
X-Mizu-Trace-ID: bb0e231c7fdb8771
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Don't WARN on SMCCC filter reserved range allocation failure
Date: Tue, 13 Oct 2026 17:43:34 +0100
Message-Id: <20261013164334.1492070-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first time userspace sets an SMCCC filter, kvm_smccc_set_filter()
inserts the reserved architecture ranges into the maple tree and WARNs
if that fails. The insertion allocates with GFP_KERNEL_ACCOUNT, so a
tight memory cgroup limit is enough for userspace to hit the WARN, even
though the -ENOMEM is also returned to it. The WARN dates back to when
the ranges were inserted at VM creation.

Leave -ENOMEM out of the WARN and keep it for every other error. The
two reserved ranges are fixed and disjoint and go into an empty tree
under config_lock, so any other error is a KVM bug.

Fixes: fb88707dd39bd ("KVM: arm64: Use a maple tree to represent the SMCCC filter")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260829055809.29AD31F000E9@smtp.kernel.org/
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
Changes since v1 [1]:
  - Keep the WARN for any error other than -ENOMEM. (Oliver)
  - Split out of v1 as its own patch. (Marc)

Based on Linux 7.3-rc3 (fd73f4a665989).

[1] https://lore.kernel.org/all/20260928152507.2116110-2-fuad.tabba@linux.dev/

 arch/arm64/kvm/hypercalls.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b11b8821c9fbc..c9d488c586e5f 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -197,8 +197,10 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 
 	if (!kvm_smccc_filter_configured(kvm)) {
 		r = kvm_smccc_filter_insert_reserved(kvm);
-		if (WARN_ON_ONCE(r))
+		if (r) {
+			WARN_ON_ONCE(r != -ENOMEM);
 			goto out_unlock;
+		}
 	}
 
 	r = mtree_insert_range(&kvm->arch.smccc_filter, start, end,

base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

