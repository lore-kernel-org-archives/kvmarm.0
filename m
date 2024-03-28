Received: from shrimp.cherry.relay.mailchannels.net (shrimp.cherry.relay.mailchannels.net [23.83.223.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BC481752
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 21:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711660612; cv=pass; b=muBE9d3PnzFR9jM2Lvs/wrVn9p1CvYFgGT+35QEDe/CTac8QbccvQjMI0IdFGY6jCuddHR3YaAlvNRxDPwstJz7c9p2f2oniXY5de2bqVvATzAtCxrSUdGSa73Be57Q93Xp+JmqNbGy1vX2rPkkh3Avj4k1oAjkaQYDOtxol+1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711660612; c=relaxed/simple;
	bh=gx9qPOOQKHzVmVAf8SKh3hRmJgVS3K5xbQ++1OuXNYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJpNtU2QE/Pjb2J3o0MfgPxEGDVBRLW+oe5+7IwUy9PkO8Qohl0NJfjVlGWbUm+kKtvwxSJh/ZIsK4CGQapSM+V6Hu2rU9xyxq00fzwN085Bytif36Ph2VQJli39f9J1BULDQEHvMqS3el2Nh4NlUK/pvEAs9gzYtAu2VrrvcMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=ZTJVk/uY; arc=pass smtp.client-ip=23.83.223.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="ZTJVk/uY"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6E07F6C3DE9
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 21:16:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a293.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id F3F196C3D6A
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 21:16:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1711660604; a=rsa-sha256;
	cv=none;
	b=sgcz8ElkOizwbJcAMC4YndRtLktrRkOS1iTgF+d2MKRVmcUslieblb1xR0CI9evEPYbM0P
	/7D9dVOAc+PDiaQ0ldxKmY8W1kGUKx9wNQ26cxGAjdJwEZAXRAA1Pp/aU6XzxCQpz+Tdg9
	xS/lROYX7TVnN5vMcE+yjHSmgYSI3V22dEcs+AvTOZCfEHYz0GROZbOfGmhXFOjpWOJYs5
	pmmSL+OY52KMX15m/Nhk6u+sfnRtqRPPz+RqM6FR37q6VP0O6Q2VGrhj0ot79PX4S0fsnB
	OSUAz1WNC8P7RxHDoV8wZAtSJ7PIVUK1KiU0zZA/CeCFzjTpMWA67WR7IstiWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1711660604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CyPAt3OCMyMrdjD1IpXOFJVGM6jxVVGih0kVtDn4WME=;
	b=JHRaujDV97hthNTX7uC8D4GezFNcL2HX9nvbHbxSmMA81opxsKHhj5C/kzCEuCJHddFSYy
	F0F/cDatEp/Jf5sDCFBZdOBHvNCr+BB9RjYr3m+i4jIG9D1ad/u+jJx89bcoFV2u/wIyPF
	HZjfjHUVv9AQuDIlKJXqRgmdm2DtPZLniX+QiYPBxI2tbcOpqt0V8OI3ilvXoG0yccpir1
	2MC0KGjvLjNp07QMY/EZYNWYdJxQTqZUUR4ZnzxRS9vu0J9HvfrulbiTeNtEPxBgv5gyd4
	Y8aUVHz9vIY3EO07vKDPHmTlqp3A9wDIfDwiZ/71+DgeqykQCAnqQdhL4QjjDA==
ARC-Authentication-Results: i=1;
	rspamd-7f6944c677-w49k6;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=johansen@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Ski-Decisive: 1a74d0b537fff340_1711660604230_3810375868
X-MC-Loop-Signature: 1711660604230:2670376611
X-MC-Ingress-Time: 1711660604230
Received: from pdx1-sub0-mail-a293.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.98.182.134 (trex/6.9.2);
	Thu, 28 Mar 2024 21:16:44 +0000
Received: from kmjvbox.templeofstupid.com (c-73-222-159-162.hsd1.ca.comcast.net [73.222.159.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a293.dreamhost.com (Postfix) with ESMTPSA id 4V5GZ35Phzz1g
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 14:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1711660603;
	bh=CyPAt3OCMyMrdjD1IpXOFJVGM6jxVVGih0kVtDn4WME=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=ZTJVk/uYWk69g01TCTqn8k6RNWO0f62R0pyVV46FNkL9sWnlHADoqLQ/w4WYRBaB0
	 5LJZQYgWDxNKtHCyKmiT+Wlew2hyJP4oOuckDwMiyvpU1M54XY/jayJFxwJDTbUxtv
	 MYslzz+IqG7YyF663E6eX16gsKgt3u9V0Odiz6D2CLESneXUv77XalQetLDJnB71mQ
	 6GtYOHGzfqqncFMoj+rwCuk5uiKXjvNF6E/UYD9HJUeoKiVXfXUxeWg0+2FwrsH19n
	 IdiK8vDAxzcQGxu3iHfGYvc1nLwiW7aJQDCJ7gvpIDc2X78vqk6q9iisbVvjxU+NQt
	 5yZ7CzjBX+img==
Received: from johansen (uid 1000)
	(envelope-from johansen@templeofstupid.com)
	id e004a
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 28 Mar 2024 14:16:23 -0700
Resent-From: Krister Johansen <johansen@templeofstupid.com>
Resent-Date: Thu, 28 Mar 2024 14:16:23 -0700
Resent-Message-ID: <20240328211623.GA5642@templeofstupid.com>
Resent-To: kvmarm@lists.linux.dev
Date: Thu, 28 Mar 2024 12:05:08 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ali Saidi <alisaidi@amazon.com>,
	David Reaver <me@davidreaver.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Limit stage2_apply_range() batch size to
 smallest block
Message-ID: <ebf0fac84cb1d19bdc6e73576e3cc40a9cab0635.1711649501.git.kjlx@templeofstupid.com>
References: <cover.1711649501.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1711649501.git.kjlx@templeofstupid.com>

stage2_apply_range() for unmap operations can interfere with the
performance of IO if the device's interrupts share the CPU where the
unmap operation is occurring.  commit 5994bc9e05c2 ("KVM: arm64: Limit
stage2_apply_range() batch size to largest block") improved this.  Prior
to that commit, workloads that were unfortunate enough to have their IO
interrupts pinned to the same CPU as the unmap operation would observe a
complete stall.  With the switch to using the largest block size, it is
possible for IO to make progress, albeit at a reduced speed.

This author tested network and storage where the interrupts were pinned
to the same CPU where an unmap was occurring and found that throughput
was reduced about 4.75-5.8x for networking, and 65.5x-500x for storage.

The use-case where this has been especially painful is with hardware
virtualized containers.  Many containers have a short lifetime and may
be run on systems where the host is intentionally oversubscribed. This
limits the options for pinning and prefaulting.  Although NIC interrupts
allow their CPU affinity to be altered, some NVMe devices do not permit
it.  Some cloud-block storage devices have only a few queues, which
means unlucky placement can have high performance impact.

Further reducing the stage2_apply_range() batch size has substantial
performance improvements for IO that share a CPU performing an unmap
operation.  By switching to a 2mb chunk, IO performance regressions were
no longer observed in this author's tests.  E.g. it was possible to
obtain the advertised device throughput despite an unmap operation
occurring on the CPU where the interrupt was running.  There is a
tradeoff, however.  No changes were observed in per-operation timings
when running the kvm_pagetable_test without an interrupt load.  However,
with a 64gb VM, 1 vcpu, and 4k pages and a IO load, map times increased
by about 15% and unmap times increased by about 58%.  In essence, this
trades slower map/unmap times for improved IO throughput.

This introduces KVM_PGTABLE_MAX_BLOCK_LEVEL, and then uses it to limit
the size of stage2_apply_range() chunks to the smallest size that's
addressable via a block mapping -- 2mb on a 4k granule size.

Cc: <stable@vger.kernel.org> # 5.15.x: 3b5c082bbfa2: KVM: arm64: Work out supported block level at compile time
Cc: <stable@vger.kernel.org> # 5.15.x: 5994bc9e05c2: KVM: arm64: Limit stage2_apply_range() batch size to largest block
Cc: <stable@vger.kernel.org> # 5.15.x
Suggested-by: Ali Saidi <alisaidi@amazon.com>
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 ++++
 arch/arm64/kvm/mmu.c                 | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 19278dfe7978..b0c4651a4d9a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -19,11 +19,15 @@
  *  - 4K (level 1):	1GB
  *  - 16K (level 2):	32MB
  *  - 64K (level 2):	512MB
+ *
+ *  The max block level is the _smallest_ supported block size for KVM.
  */
 #ifdef CONFIG_ARM64_4K_PAGES
 #define KVM_PGTABLE_MIN_BLOCK_LEVEL	1
+#define KVM_PGTABLE_MAX_BLOCK_LEVEL	2
 #else
 #define KVM_PGTABLE_MIN_BLOCK_LEVEL	2
+#define KVM_PGTABLE_MAX_BLOCK_LEVEL	KVM_PGTABLE_MIN_BLOCK_LEVEL
 #endif
 
 #define kvm_lpa2_is_enabled()		system_supports_lpa2()
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dc04bc767865..1e927b306aee 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -41,7 +41,7 @@ static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
 
 static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
 {
-	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
+	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MAX_BLOCK_LEVEL);
 
 	return __stage2_range_addr_end(addr, end, size);
 }
-- 
2.25.1

