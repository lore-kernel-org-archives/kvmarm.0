Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793917732;
	b=oCrVliA9HBF63N3/mqDzJ0Ted96m+gQnUUacAmDUScdeRlfZjzCzpKvHlFHPW4wl1DB+
	 Pq2eB2uP7g66YCWqw7fSz6KX1ZPWGSq6rx8G9VL76ZC7meiGSeryPW+PyEItHmQzXVfjD
	 kCXPQUUFl3yxMJcwjStVyI+BNI5zpAfqKGseUOd4OMiQZnibxSLPcOWuCqIezqqlu6ynT
	 PqfGDWGpDzhXj6DTdF3bguzXeRTxC7nPToOtJnkbuQGDy1u8zkrNihBjMZ+bW0Ympcx8U
	 gIDze4STLfp7a66bkAvqdc35Zsn/hnVPFPKQRMngyBmQMCIWdcKkiT4bIIcpzPI+/wQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917732;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=BUrKgGzA4bbshZplaDoxIhNoQLXgAtDMSDD/aApCg/Y=;
	b=ZhunS0jT3sBqZ1RfPzZszgvKvlNmH0CT9a7xBuFW+yGn6XPoXRAcE73YBT4KnBTMvaZA
	 BlLty5ON8nyJ4MPsx+u8KTOM5uVDJYCLtPTNSjkq7aKzmg/POCssti0hWxBAjkZkEnATX
	 2nDEiLRIeNzNgPQvihrnalrGgDnLSJZAZotWhtvto9ZGKp0WfNPa4XXRi3IUnWP7B4uhB
	 cm7rVpSiFg/4M4AliEItN99h6VXBx0WoGr1X8ww7RbeCiZiqAIuS1mirpIYo1fum+RpP0
	 Z9EawtugHgKetQh7Fi59ZlSUg+GHkcTLNQANgPcG3M7leCYE/0MbmiJdRkREc68WUgw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iA8AMR+H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA233606A328;
	Thu,  5 Nov 2026 22:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iA8AMR+H
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793917731;
	b=qG+Uh4ECXfh5t97SnOnZzKzy0nLAwiX8OBw2fexDRYujDN+a+i09s40j/8QAr/XEUvrg
	 gLvg9dI70lHhHnq8b+HbV18/RSvtvzp8PF/74XzvJLC0WcS6Yfprxp40xHRRN7THVyB59
	 d/S2SUfGnjd7+qcZ4Mb3C3fU3FZu/uff47GEhBrgSJXc1eZMv4hIp3p3BytMLmUp4U5mW
	 LR9kgfqvo1cGGirhRMW0HcdxQdui8Ij/sGTCBXWFdUonaQa7H981Uvi1SNRMMKE/OufrC
	 Y6aHxQPaaZ9r9kwRm0JZpnBQpeHfTZzBRQeKU0kNayoVZ0pto+q0PS8jso91pnX1X+Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793917731;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=BUrKgGzA4bbshZplaDoxIhNoQLXgAtDMSDD/aApCg/Y=;
	b=SPg08KktR5zF3/iPiJ/F/WppIGXa2Kh2SXSV8mOWyLvTUU+OF+NIIqtT6Mhp9O/IcSpC
	 +oYd2GIXkw/S9aTxBF9IHdDFAughAhjz7jr2T6c5jaobRVC8M+iQKUmsw1RFRfSYzwDjH
	 NoTE8D1MctciDbQv1q8zKy9sey6ugNcCFv5nWseU21gJDilACmshE8LwZPVK/KYC5IhFK
	 kjS/Vs8CMq11+T9xwESdoYbMKtS722hZs1W+fU3Mq/XZVm76tHqz/c7/BCZVppdXafQab
	 n9B0Rma1Vk7jZ2gemL9BKIb409f3sDv++3PM81tAowCkyz5nnD+zbGPG+1EJsp1wJ5w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 79BBC1F008A2;
	Thu,  5 Nov 2026 22:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793917731;
	bh=BUrKgGzA4bbshZplaDoxIhNoQLXgAtDMSDD/aApCg/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=iA8AMR+H7h7PBofyQ0b9o1dHQdNZsIQleHkRVExT0jYVwqUgD+WiuaUZCkjvjxVF4
	 IyS5h8/uHt3QicIwpqpxNwXKD/CquG1E5+y5QAzgPShfWtlBVZyHz+rHqEfKwxerRU
	 Xk+JPDL+PASifg46eZao/n8WArFhwNqFGAwBczeh1UWOHfM9LHgyJtQZE6RyKghpBf
	 wlZV1Sdndo0wAs657gEOJAyADMD8jx/ewIN4SYweUDnR9eaCVVvSAE2wtL/ccpHLA7
	 ECTP2mNo16XOoc27Zw749kDF8pr3uYVzRh+V/piU2+II9DNRSMWIwTj+ayys3sGCvr
	 7pviLfBK5cHAw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0570045ABB;
	Thu,  5 Nov 2026 22:28:50 +0000 (UTC)
From: Xuheng Li via B4 Relay <devnull+xuheng.cs.columbia.edu@kernel.org>
Date: Thu, 05 Nov 2026 22:28:51 +0000
Subject: [PATCH 2/3] KVM: arm64: Check the host stage-2 PGD allocation for
 NULL
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
Message-Id: <20261105-hyp-pool-and-map-v1-2-756bb5d8e067@cs.columbia.edu>
References: <20261105-hyp-pool-and-map-v1-0-756bb5d8e067@cs.columbia.edu>
In-Reply-To: <20261105-hyp-pool-and-map-v1-0-756bb5d8e067@cs.columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793917729; l=1285;
 i=xuheng@cs.columbia.edu; s=20261028; h=from:subject:message-id;
 bh=XdIMBDSmGASRQbiHAq1YVe0xT84zqEKj8tGXxAjv0Fc=;
 b=zdxMZTP1ibxSaWoIJZCsCe1ZYXxUtb0lDuKtMIn1ad4RQ5OA8he3O6H1zy9UIpexvI1IJQU+e
 voejNVx2PkuDEQWrUzeAPzgPZ8jUMFUElP2T1SshCeE144SQiVs1u5O
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


