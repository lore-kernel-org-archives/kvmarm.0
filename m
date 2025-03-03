Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB3A1E5732
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 06:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740983164; cv=none; b=JDhOIsxmBIFQKBRfiM+3U5cOh2DFltTLxcot1KqxYBpYX3buRCwBTQ//XaqK+GWuA+46+4GOW2NVOBGxQWV6hsTEgVlJ3y/D6zUno8ID+qLvoZqIqzUxcrx9OPFpKOK4X4mXmA9W9Q2Y+9Ioh8VR/B45U8G29jhfJJj/P9sGWPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740983164; c=relaxed/simple;
	bh=7M+DRz2hm03rBgj2x3UrNt6vpeHXng5+xitohQvfcAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jK3zwDKndudcNAw2C0esBYC6I+DrLxLj3VlwefKSpvrz15PVMNRHu0xD1HxNrINaFX08AsbZ44SZuHz9rSYwK2pS87Re4PLOvzGtYTneib2iFwxjWDiYRI4RWgDxVlbcamcpyLIujnxMg/b75twcIEhbvimzdkocwUXDcygct3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VbzRUEL4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VbzRUEL4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740983161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N+ANXerGfs05Qx5JuBBnd1YtOYkq281duKe5pNwiLBs=;
	b=VbzRUEL4BJ1tK9xVtyFrKDH7D5CeIwRxTGiCxnMchIX6r1pC9rFOFb3B6a+fhZ7eijqm+C
	2F24CThDrq2ekadrNDoszAJ+8RXCyGvf/5TZlOFeE62J9VFCNNCbRcfIGpvXLP9qco5Z3Z
	T9C0vpyhZYsDXsN38+/kWUidt8r+LLk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-xsbYwIm3Mx6MJp4az-3TmA-1; Mon, 03 Mar 2025 01:25:58 -0500
X-MC-Unique: xsbYwIm3Mx6MJp4az-3TmA-1
X-Mimecast-MFC-AGG-ID: xsbYwIm3Mx6MJp4az-3TmA_1740983157
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-22366901375so62021555ad.0
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 22:25:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740983157; x=1741587957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+ANXerGfs05Qx5JuBBnd1YtOYkq281duKe5pNwiLBs=;
        b=CRSqFRjLi195Z+7d8CGLCH10C0jWrlctMIoPrI7xbBfvC+rRK4IrsPnAu8yVw2ZZN/
         dG+xFoYSfuCXu42Fld2H/kPE7Bq2Ip533FwY2xgcV2j3VRBxPGsQlaiL2/jCBWQAanVt
         r07/WSKwyx5Ah33huwjOrMYl7FSd/8ueq/tiSB5jzSFG+I5VNpBjqoT3qsd3dHxCEYHG
         /Klg7exM4fQf0ouQFR0dXaNTBffpL1iUzNY3wa5tapxH0dFDjIgTwtODG3JUXhbg7Im/
         2dPIvDOP0Q4MON/U3ZBSuws21Hy6BXahVEB4ByGrqxalJ/IRuAHum/isw4UsDyOMUtqn
         GDyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpzZS3k6QEJQ4fCtegACFT5wZWO5iH5fDJV2mcjHkb6lWOwxmRO/+zB5v2PpTCbamAuIpVD9A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2lEgQp4FZ9SBybNkH83FhxxjHW1BoCnuDQpN73RvqmwiQM0zq
	+L21tdB2lyLWNAqtxqeEV3nBtVbogkA/JotyUl4eAPfjTRpQ5oVABmvnQbnk58tvuCjZctzThoP
	K6HVlYGL55uqRU+PLt1y1pZNAQD3F8+zIrDVj/l0O2iLI0oGmfnsNug==
X-Gm-Gg: ASbGncsGWvw/zQc6Xi3O2bPDsemxeqo8wK74aiCO4TKicssDrNtulVmguWxwmd6sLRk
	b58xOBKkyZaFL1MgUvP4jlay/u/JIvcsNxGrtzHvZ4e773a2bAwhXbsVhkN7blmGOZFu9AyNkGs
	IwlFER4dLcYS1AUMqqviZc05ADAFx1nhc5j1L/Ql3GGAyciQGp19Rqaqws7D/V9TImsDjT1s9AX
	GHLHS4p7BPeZPJ7SwGZlwcgL3SrMsgmDPLEECWeJPQRbkBgsY9xTbgrPb+z2G8kzPowARZ4yLnf
	nglP46UndEv+VMCqMQ==
X-Received: by 2002:a17:902:e5cf:b0:220:ff82:1c60 with SMTP id d9443c01a7336-2234a4891c5mr239752355ad.14.1740983157572;
        Sun, 02 Mar 2025 22:25:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpXtcArHUqT2hI5ax8evJjGCyGJEtPHCAmH1OVzs9dnw0tbzauezRsGnlG5Grz1mEDveiZtg==
X-Received: by 2002:a17:902:e5cf:b0:220:ff82:1c60 with SMTP id d9443c01a7336-2234a4891c5mr239752075ad.14.1740983157279;
        Sun, 02 Mar 2025 22:25:57 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504c59e1sm70112765ad.158.2025.03.02.22.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 22:25:56 -0800 (PST)
Message-ID: <e432ee67-6afb-40c8-9542-48770834ee40@redhat.com>
Date: Mon, 3 Mar 2025 16:25:48 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/45] arm64: RME: RTT tear down
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-12-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-12-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pDkk0lRmDdcrhkln53Gx6yyj8oibS-PyCqsldfIT9KM_1740983157
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 
> Creating new RTTs is the easy part, tearing down is a little more
> tricky. The result of realm_rtt_destroy() can be used to effectively
> walk the tree and destroy the entries (undelegating pages that were
> given to the realm).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v6:
>   * Move rme_rtt_level_mapsize() and supporting defines from kvm_rme.h
>     into rme.c as they are only used in that file.
> Changes since v5:
>   * Rename some RME_xxx defines to do with page sizes as RMM_xxx - they are
>     a property of the RMM specification not the RME architecture.
> Changes since v2:
>   * Moved {alloc,free}_delegated_page() and ensure_spare_page() to a
>     later patch when they are actually used.
>   * Some simplifications now rmi_xxx() functions allow NULL as an output
>     parameter.
>   * Improved comments and code layout.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   7 ++
>   arch/arm64/kvm/mmu.c             |   6 +-
>   arch/arm64/kvm/rme.c             | 128 +++++++++++++++++++++++++++++++
>   3 files changed, 138 insertions(+), 3 deletions(-)

Reviewed-by: Gavin Shan <gshan@redhat.com>

