Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793919590;
	b=Wcbhfl6vAnltli3MFzZWmR5HBh6ZhHk6enpl27ayQU32dAxJINJj95w8PlwN4Z1C6Vp5
	 cQHEIPBTcNMBtMPi1CxxNNTkxRXH9uYP18ljWiPGLWD4okt0HAKOWVVwpCT5XwbYZzH+o
	 uc8HzjEkjjGbPsvE6s/qnfSBW0Jq1LbbTzYkrVTazE75D5q5ihCD+hLnjVquj3X9EfAho
	 SOxe9OTKU9BObxCgycnsFu4tNLQlGjdAJ7in5GwQJcL7bsr7zd1b+t6v07mlsC2I11Q8Y
	 lmOMaivq2ru1tziph1XiIxaLgsSZi83F0HUD6/rOifMEUb/caF9mqzOJnxXVIbFi8og==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793919590;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=BUrKgGzA4bbshZplaDoxIhNoQLXgAtDMSDD/aApCg/Y=;
	b=ua87rnnf2XFwf838FfUSMqpX12pn5clQ/2pXByKhQ8NsBrP8gJPm5tHL10M7u/yBeMl7
	 M/8p1iryoIWWj+NjBy1w1QmAjh6Sg3vt97it4eAMTlAkRFltwVUB6pQz0+2I6tPdTJWmh
	 wzTsZfaWCkM/x0+Un4ACAUMsqNsO+c9h5SUMbgBYB/GJzdtpHt49wb2KrntrBTka+B/ZU
	 3keGL5NzMUtIoUrbo9VbkmJta6+rJYBn8NY3lWOQsHXWHXqZxbc2MbvneRl5sfDVpw8PV
	 /iHsaYUQeCeV3JL2D3PL/69QHzkDJCkBNMJFjPX6GRTfuDhDdoLqhR0mgm60cEt61cQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g4tfZ07T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB4606A326;
	Thu,  5 Nov 2026 22:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g4tfZ07T
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793919589;
	b=PFQALOieoYNrqozxl52VwVusyCOEXfWDwZpbqzrQ62rUbSWFSp6SDxw18cFFLO1VmiFC
	 orujH7edfB3aguA+EBiL0hQvma+zld9Nw77tuBC+ftq3GeScDM9/D+SwOCuGFYAU/V5TX
	 /P0QUrqc5s0Jkfz0zrvrX+kKQWcw/EOk/+7zrGWA0tG1PL0HsXLtom7WpzVpFZDDJSBTB
	 vnGu3lqWzN290bNMzP4uwzXZXJiDvU5FE3nhjX5GZ0V3cMYHKnlPJfOsTWwwY2jMbtE+u
	 PwnGZQPdUyNzKVxlxSlcJ+i8BD0OV+T3QT+GVNkDpJLLX8VlYmWW9E8tNB2zfYqvBXg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793919589;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=BUrKgGzA4bbshZplaDoxIhNoQLXgAtDMSDD/aApCg/Y=;
	b=mpo7sB7a5MIlM3G7kLzPCEIC6JlvrmQynyVSvdGce1C1OqVWObV3bCvxT9mbFr0da1dd
	 UHhKf2a7VrT+Uzh1t7OrmwWTv5wqgmNdyFLH43b+UuvXthpL3NQsSuHHfxnc88+vcHRw3
	 kjQ5po5H0bVB2bqKBtppmC0Nrp7ZhRk4rpkG+5PWCf88MpzD/6z4GsdRJaAiNtW53BLiO
	 0WksetqYb+phvKQHf41WzwHiy/bzw/Ojb7/kRvBqs14zyZnPia202sJGwgfEbFiuF+l05
	 N0WHYmWXaFEvObVmE7+61zBvsiJsSLQ5bYIW7wpfrcn73U//k0rFProNVDDEJ0sTgwQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7276D1F0089F;
	Thu,  5 Nov 2026 22:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793919589;
	bh=BUrKgGzA4bbshZplaDoxIhNoQLXgAtDMSDD/aApCg/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=g4tfZ07TvA13GbI7bfVzM2uk1qTqlhMSMPmBfi1OPqi4wCueN9Zdg3WAHWO4FDRAv
	 /gtuPeJv89sjVPh4rle2di+pT2HSO12x7KmfNbCJprnWySQ0HJOurk9CFol4p2Foso
	 l2gaLF+VadXnqp1HpnZqG3adyTEW8JWbFziApBf31s5CsVDFvHQycTaKdDQhSRVg4B
	 vy689UK5cenTGzqC1oh7kqFyIileag9+cqRPQMwEKc9VaMs5ncigccv5hAs0B/XoLb
	 hKD5cN+zO8CZD2v1ai0iEeIXe9TKJBZkSSFNRwwB3amNj94bDLuKQaKCxBcfbwwJKN
	 uUAhwhMRBE0lg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EFBD245AD7;
	Thu,  5 Nov 2026 22:59:47 +0000 (UTC)
From: Xuheng Li via B4 Relay <devnull+xuheng.cs.columbia.edu@kernel.org>
Date: Thu, 05 Nov 2026 22:59:49 +0000
Subject: [PATCH v2 2/3] KVM: arm64: Check the host stage-2 PGD allocation
 for NULL
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261105-hyp-pool-and-map-v2-2-44a6ca90190b@cs.columbia.edu>
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
In-Reply-To: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Xuheng Li <xuheng@cs.columbia.edu>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793919587; l=1285;
 i=xuheng@cs.columbia.edu; s=20261028; h=from:subject:message-id;
 bh=XdIMBDSmGASRQbiHAq1YVe0xT84zqEKj8tGXxAjv0Fc=;
 b=IYseq6oMUYI7xPYqCu8HI+7gkAetQ3w4+ns34XBkZMS+HEwhZqz0Z138syy5KpNwBdnAztEdM
 r1OLdD/vZpkCRRh+5QHK3jlPcBtikNHnddgDeUPNg9SF53GdH3JP63Z
X-Developer-Key: i=xuheng@cs.columbia.edu; a=ed25519;
 pk=L1HVV+goqxYmEMO/OXakL6uf9isSpgk2QrLlFqyZ2Qs=
X-Endpoint-Received: by B4 Relay for xuheng@cs.columbia.edu/20261028 with
 auth_id=1349
X-Original-From: Xuheng Li <xuheng@cs.columbia.edu>
Reply-To: xuheng@cs.columbia.edu
Content-Transfer-Encoding: 7bit

From: Xuheng Li <xuheng@cs.columbia.edu>

host_s2_zalloc_pages_exact() passes the result of hyp_alloc_pages() to
hyp_split_page(hyp_virt_to_page(addr)) without checking it for NULL.
If the host stage-2 pool cannot supply the PGD, hyp_virt_to_page(NULL)
yields a bogus struct hyp_page, and hyp_split_page() reads and writes
through it, which ends in a hyp panic during pKVM initialisation
although kvm_pgtable_stage2_init() is prepared to fail with -ENOMEM.

The pool is sized so that this allocation, the first one made from it,
cannot fail, so nothing in mainline reaches this path once the pool
size is computed correctly.  Return NULL early anyway, so that a
mis-sized pool makes initialisation fail cleanly.

Signed-off-by: Xuheng Li <xuheng@cs.columbia.edu>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d4c332a91..ee0848f2e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -85,6 +85,9 @@ static void *host_s2_zalloc_pages_exact(size_t size)
 {
 	void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
 
+	if (!addr)
+		return NULL;
+
 	hyp_split_page(hyp_virt_to_page(addr));
 
 	/*

-- 
2.53.0


