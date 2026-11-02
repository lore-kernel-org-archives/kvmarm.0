Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631813;
	b=rPLH7KUQ6OIZnL9PrzGZ5+GIobnrwym5eXx80iaoFuA8Co6tzwsVKfclYcf79FzRZcY2
	 lOOGa5FN0313IHYdqlq+yMIYpQMhtf3tkD46Tmwl1r9cxpeEjeodGH7srXQW25cX1afRh
	 PVx7dtZKMcsQopp6QAFbx7lafds1FD/1lPjB/3Bs5pSFdqGDxZ6Rwp+YekRYbVzt1XjcX
	 TQfxXBUHwT95T8b0AmRgaRmUBV01FCFDRI26eVGdyAHNKIHN8y3QKWOH0tPMSBX/9iBMy
	 1CpRVw/xlYxtLBO2ArwB2xgjvmkaKMlasj2WGoZ1XdsdHUstCf/NOjkuSU54pRTReFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631813;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=3ZxJdgjDA0OfZkHT1nltrt+fZftauqzpRenxqzTVLvE=;
	b=3OBiYE4Q5PU7ZYxuUdWCwVl6GRWCf2081AqeyKYx6VSEEjwFTZphWd9Q9GQFqqxvdhE3
	 RKSKIjGHBywCdYZFjkXOGSnIxdv3OxycWp1Ar/8Vgq9qT8py+a25MBvSQZzi2QD7m8vxt
	 2R25ZYLjI0Xk1GLVsHPGp+pTRgV97zlwGgp8hjx4Ppwm0EMqfQqRimZAX5fhvvcn+0SXe
	 UwBFm9EwGLuqOy/LGZZpMniEs3K0+kwxrorzrDfEmrSv/O45KpoQXacjIYEBwayG5JzMn
	 yBW30MFW9krNsRvjcisvMujxMMY5iz3hbdPCuE+ZD462cf3uFtsZgryYLcSj1C6i4mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QQbdLQCs;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D986099950
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 15:03:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46D986099950
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QQbdLQCs
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C90D1A2D;
	Mon,  2 Nov 2026 07:03:29 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CA1B3F673;
	Mon,  2 Nov 2026 07:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793631812; bh=8i8ugBRaP7hgcxk3uDp+fPMwqwaO4C5du0Yjd4app/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQbdLQCsQgmltl7+Ykkt7ll804V/Mtn/FDbPemPE2r86Hyb8IY4XxVv/2L+q+6k1U
	 cJMtjqXsbtaYtANFmBATF793gIv7UIlNACyCp3rRx7tNUiBjy5C+yUH8cZX6vdQpaO
	 YaQrwd8ataTW1eO+S10xGw0jql0G5jjUM+Qi/8zw=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 12/15] KVM: arm64: Derive the VM hardware dirty mode from dirty logging
Date: Mon,  2 Nov 2026 15:03:26 +0000
Message-ID: <auimPtktqZ1cwk3-@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929103655.85107-13-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-13-zhengtian10@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 29, 2026 at 06:36:52PM +0800, Tian Zheng wrote:
> Both HAFDBS and HDBSS flip VTCR_EL2.HD at memslot-update time. Two
> independent toggles allow an intermediate HDBSS-set/HD-clear state,
> an illegal combination, and need locking against concurrent updates.
> 
> Replace both with kvm_arch_update_hw_dirty_mode(), a pure function
> of the static capabilities and the number of logging memslots:
> 
>   - logging && HDBSS-capable  -> HD|HA|HDBSS
>   - logging, no HDBSS         -> off
>   - !logging && HAFDBS-cap.   -> HD|HA

This last one is gone now, so I guess most of this patch has to be 
reworked, right?

Thanks!
Leo

