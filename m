Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793981575;
	b=wsaOJfeAH8ozq6Gqu5Cj/HoEZeHkLqZpy+qEiJoZVjoxPLXV1M1Jeb7QNUGuCIFbzqM2
	 RBHXdLGpGhrPxe4dQP3arhL/HXfwL1Eq7kT+/QfiMaQDGQ2ALgMjjLJGc0+1b1pgymPzM
	 /n/7h9HhiVjEs7ZaiDBFJo77Eh+H2IZWIC2G/fCVxNhJwEy1JrkOUE4IHMKkfwzkPQY+f
	 uFVaDeoZTivTqxBK4rHW/6G85c0dnb9urmMpZ/0mR8AGXeRORZInxXO3Xh6QdSNoTzYU4
	 u9mL+KT2D/TB53BHU+79RLoTMd8pKYQevWJAMttRcws4OYp5Dpwa0pe4ly6vXToPuqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793981575;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=IzYdba36GspgDjYCPt5LO98rRURFAs6wAt+eFJNJspY=;
	b=uSbCSJEEr8LxX5zlDk9gz4sUA10BceeT2ZJiyljPr5VHZDslkTiT999OJ0xKXSnvrexe
	 VsCJEpWQyHVdeWGmmaOWgjMraeQeEOBiUZ7oG9CFGdEOqHl58hgF5SBoe5odceEBqUCIz
	 xI8gkT/60+YiXswjOMzePHrL3nHRVHK2qFbKuy1S6Fvk6fUlJDewtVLEcbCWSRRua/8JG
	 xRUyBuMrcHltzwGVrMGXqM4ZapUIBrjV8dJhQA3bHqsLhFCGuvt13ZnwNVJAbLUFdRpNk
	 vyh61QW/Cqs4wvoiKqUyPyL5XzmYOBJRIRaG4iSTXR0A5wpCRYQ2rB2xfSgc7N8/wYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eA6Hxb7l;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BEE1606A99E
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 16:12:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BEE1606A99E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eA6Hxb7l
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EB281682;
	Fri,  6 Nov 2026 08:12:50 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B55EF3F673;
	Fri,  6 Nov 2026 08:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793981573; bh=Br5fuZ4ryUMLMGwj9gH1YIvLvzgbJoEJcgmiUYmIM+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eA6Hxb7laN0mQTfezkjmx/crOKl95bgN2ClQCvUp6O0uSUBdvpyYTzS4t+T2akrf0
	 RciWHgDoXqQfvCaK3ZeQfav3XnjvEhIEmRataJGjxg4WiCTLCo9i86ewbOL3rMLgFY
	 r7nn076YUyIDRaeEcq6lQllJTDpC62QRMOF8I1go=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v4 1/3] KVM: arm64: Avoid re-testing walk_continue
Date: Fri,  6 Nov 2026 16:12:36 +0000
Message-ID: <20261106161240.1345126-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106161240.1345126-1-leo.bras@arm.com>
References: <20261106161240.1345126-1-leo.bras@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1905; i=leo.bras@arm.com; h=from:subject; bh=Br5fuZ4ryUMLMGwj9gH1YIvLvzgbJoEJcgmiUYmIM+E=; b=kA0DAAoW7HZo80cCoa8ByyZiAGrt/HWh0IdRfCiNcvabr5HQs/y9ucx40eg3mASTh9Qu7zzuu Ih1BAAWCgAdFiEEHeKfqgz3lGjE1Pig7HZo80cCoa8FAmrt/HUACgkQ7HZo80cCoa/aRgEArRY7 EUqzjS3eacxXx9J5Y3d9lPF4N8cENW1e4NkNFkYA/irD9Cc0/MRCJvex/HFujfxUqXy9m7sgJqx 9RZHxwt8M
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

__kvm_pgtable_visit() performs a bunch of calls to
kvm_pgtable_walk_continue() to find out whether the walk can continue
further, and if not, 'goto out', which retests the possibility of
continuing the walk before exiting.

Given that it's testing the same ret variable again, there is no reason
the result of kvm_pgtable_walk_continue() would have changed since the
previous check. So turn this goto into an early return, simplifying the
code and paving the way for further rework."

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..7a51f78b6446 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -183,32 +183,32 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	 * Reload the page table after invoking the walker callback for leaf
 	 * entries or after pre-order traversal, to allow the walker to descend
 	 * into a newly installed or replaced table.
 	 */
 	if (reload) {
 		ctx.old = READ_ONCE(*ptep);
 		table = kvm_pte_table(ctx.old, level);
 	}
 
 	if (!kvm_pgtable_walk_continue(data->walker, ret))
-		goto out;
+		return ret;
 
 	if (!table) {
 		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
 		goto out;
 	}
 
 	childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
 	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
 	if (!kvm_pgtable_walk_continue(data->walker, ret))
-		goto out;
+		return ret;
 
 	if (ctx.flags & KVM_PGTABLE_WALK_TABLE_POST)
 		ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_POST);
 
 out:
 	if (kvm_pgtable_walk_continue(data->walker, ret))
 		return 0;
 
 	return ret;
 }
-- 
2.55.0

