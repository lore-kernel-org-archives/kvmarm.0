Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A520137C58
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 19:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711653129; cv=pass; b=COYQ82KnZ9eb6VwRmpeFZd0R76DPDYO0FJeokxwFn+zuLETuFo4RDFoI6FdRV457X9pNOo4PlxSRLUM5ptzjhcUfPDV5L75nrd9CKMqtCv7Lxs1UUYljDZXpcOBR79TLCuj6WCXmW45hTKKnmZ+Ncfq+OJHRwEoalcnaQ/vVfbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711653129; c=relaxed/simple;
	bh=qTPJImufvV5ASN7LhY3I4AeFqA1N1hCnHDloI+wmFfY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=n50CzciXEK4NSD5/cPoLDucetx0QEdOJCg/eDbkvI4KABbWBvYGLgRb8B/C3MD+tg2Dne2K9O8fzcXqMbUbYOTFBikdf1qW3ANijl+DnVlATCnrdRBMjcJLmkcnRooz7KWQ8h8zB8qxpy5gZo3ANUBp8m8enEiLTfSEOCdELBCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=WnHXoDHX; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="WnHXoDHX"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 1F0ED5020A5
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 19:04:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a310.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 995AB502509
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 19:04:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1711652683; a=rsa-sha256;
	cv=none;
	b=OpdAhgt7chzPfpBtI0FZZtw1a4cGkof+D2b5Or3a9hMOR8kUL2zUzht9lxNQziZP332UB8
	akZiZ9mqUxnQhm+12MDGy1zLtfE9t2N95XrjIft9iDs0JTopSonG9LZvoK4Zu8dY1T+ddB
	z/2IPjrqjqszJsNPt22+li4yfVuzEoylbEJwfCtmZHOn8MDA0vsC7hyEy8DjrmbgM0U/g2
	kmCdk8+imvabLPGZU0BeCfM5j0fCmbuG5fcHZJ9nHjxfFYwJdZKyvzd8NTeA9LaqPirt1q
	JDtsrU627ul80eGhE6XFX/l6H7dnLVJ9uv3YmxZnR0lU71qjyRkamyvoPhjT1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1711652683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=M4mKD0+XXr3iAcqde4xMt3RYAlgHRmBZwIlXckXewGA=;
	b=DVkSjQrkVvMy20UgW1BqGG0CMyQdxf/MC+qKj0WP6se+FSMRP50lsnTktOv4SXOmpwNe96
	R3CXpdUUax1kBdlll/xsitgtuhbtB9+ZiKKugLlv9ClROd1I0x9qBrtxrxgxqW5e2EvQa0
	uvAZfFpcSyoFUQKTS8FH7qNFvP9RCuYiwIrBdqgyB/4kWqJwHTN4ismYKidHXlH0RfrWyh
	K1/i3T57redu0+hw2I+X7LczaDEx06vc9fCF8B8q/4AmqT44X2diKlTX9b1jXo7x5tEnEG
	ZQwjfBSIf00el+VP1F2BwTOazy0GKJ81FuOqSTNS4eymxIz1zyJO87VVhi422A==
ARC-Authentication-Results: i=1;
	rspamd-7f6944c677-lnjt5;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Macabre-Illustrious: 102deb96556730c3_1711652683878_1119027454
X-MC-Loop-Signature: 1711652683878:3349719181
X-MC-Ingress-Time: 1711652683878
Received: from pdx1-sub0-mail-a310.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.87.146 (trex/6.9.2);
	Thu, 28 Mar 2024 19:04:43 +0000
Received: from kmjvbox.templeofstupid.com (c-73-222-159-162.hsd1.ca.comcast.net [73.222.159.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a310.dreamhost.com (Postfix) with ESMTPSA id 4V5Cdl2bxbzmx
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 12:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1711652683;
	bh=M4mKD0+XXr3iAcqde4xMt3RYAlgHRmBZwIlXckXewGA=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=WnHXoDHXUZidboTfj3roSTDzbx78PWzOsLwhc476sRls+4jUuF4xDVB2Ayod4B7Fd
	 aD8mm4lyqEjaUBeiRPkQ3KHx5Tg50DouCuB8HCuEXLrVvej7FmNMM9+AGexD4bouMI
	 f+TyZuORVetGCIVJglKsPSr2yamNSFamqULjS5JQzk7Z9M9LgZtZ1Mm7Q2wdusvJlG
	 +7JCQwN26yRX06tPWH8pTrulbL6Dv2q6YNruPKx2Tn7DHLd+MAjR2R276UUY4OqfDJ
	 Unh6y0n4LxRAsxZNGHyhJi2MsRTPxOgCQ190Zqp7eTWs1v+t2nizF/0AzO7q6rlHwI
	 qRhR1P3SH9uDw==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e004a
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 28 Mar 2024 12:04:34 -0700
Date: Thu, 28 Mar 2024 12:04:34 -0700
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
Subject: [RFC] KVM: arm64: improving IO performance during unmap?
Message-ID: <cover.1711649501.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
Ali and I have been looking into ways to reduce the impact a unmap_stage2_range
operation has on IO performance when a device interrupt shares the cpu where the
unmap operation is occurring.

This came to our attention after porting a container VM / hardware virtualized
containers workload to arm64 from x86_64.  On ARM64, the unmap operations took
longer. kvm_tlb_flush_vmid_ipa runs with interrupts disabled.  Unmaps that don't
check for reschedule promptly may delay the IO.

One approach that we investigated was to modify the deferred TLBI code to run
even if range based operations were not supported.  (Provided FWB is enabled).
If range based operations were supported, the code would use them.  However, if
the CPU didn't support FEAT_TLBIRANGE or the unmap was larger than a certain
size, we'd fall back to vmalls12e1is instead.  This reduced the performance
impact of the unmap operation to less than 5% impact on IO performance.
However, with Will's recent patches[1] to fix cases where free'd PTEs may still
be referenced, we were concerned this might not be a viable approach.

As a follow-up to this e-mail, I'm sending a patch for a different approach.  It
shrinks the stage2_apply_range batch size to the minimum block size instead of
the maximum block size.  This eliminates the IO performance regressions, but
increases the overall map / unmap operation times when the CPU is receiving IO
interrupts.  I'm unsure if this is the optimal solution, however, since it may
generate extra unmap walks on 1gb hugepages. I'm also unclear if this creates
problems for any of the other users of stage2_apply_range().

I'd love to get some feedback on the best way to proceed here.

Thanks,

-K

[1] https://lore.kernel.org/kvmarm/20240325185158.8565-1-will@kernel.org/
