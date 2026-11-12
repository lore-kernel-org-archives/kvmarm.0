Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794506867;
	b=FJewTJQtKbaZm8DtIYHshwsHDAu5tkXaS1a2IXJ0tU8exNLmLQplJlLHZF0q33l0Pz+1
	 CQA9P9BQYCgbjP2D5GyhqjsTxIfDEx32w61vv9anq8+cbsOL0JNFqL8ZLuVxSyT8xzdyh
	 In/3RE1BQtYhktAi68sZIzCs87b6VTP6Xg8eyDSmR+oU5fg4o+I41FmhmYSW3k/mnVnuN
	 dsfRMj6eOJU6wpBnmyZyPrnA44l3Wj9dNMun/HGK5s4Wo5x+Bk5HMANtwuUHaEZwu683P
	 mBEpYEOSLmLMW1nykN2Ho5hJWQlYMQsvgJyPac3JG3qnEOyW++0GTVOEhjOptiF/S8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794506867;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k1iKJ3ce6I7V1KzAt6ijmlB03GjSeH93EgIWrRWokzQ=;
	b=mWtZB9zziT26OA17lRRS3K2Mr9FXispALinnURUpCWrRmbouh825heiXoLIMBnK+qzDE
	 ujnnRYrFYC42+6Yj8ZNAJKmrPLD605Bw7QuasjJ1XzIholRe+YtUjg9mAw/rs2PujfIlO
	 KdZteVOcrCbLrkuu7JDoaBPQpIOBVzjYe4P8xEk/pC5Ilxd9aI3g9qiE6ubpIb/qylul0
	 pBtjF2+vJjqXsJqU7DzxlMXBelrdMrFtdKokpq+fXNJorHLhwmJCM/B2vhH7y13IYAeOh
	 LpvDxrZLmRmHirkvTApSV09PYoy9nfG1jg084ynscb56dMn+PxTxe8c/oJkx0Xi3tlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sGBkcbTB;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407FB606A33A
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 18:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 407FB606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sGBkcbTB
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdba1bbde0bso54369a12.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 10:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794506866; x=1795111666; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k1iKJ3ce6I7V1KzAt6ijmlB03GjSeH93EgIWrRWokzQ=;
        b=sGBkcbTB+yOcpDkB6ywZmLgU3ywYg96lJn5LR+QwFPaauz1cvpogOD9rQCPF8MRJpG
         LFos4MFWugP0Sg5ikuLzTjtLM/kJLKxYarCD6FhqTxvQOXWjl/YtEmmCTXEPSRXAlQlm
         FGT0LNhBpx6jXflJV1UKfMDN9yFla/djmW+gf3/MZQ8sPK2/9o8lhebvkRXdSoLYu4m+
         0QatcqxbnSdVNviUGtIDkbUToiKH+LX4baURNqFjncxEN7c2LEMG9dcCKxgEBvDMfpHx
         h4ouAi1b0TxVwUojmN/RWK76nTekhJX9FXO5s7w7echMfSV+fUKN/O3w/n0QEwnslAT8
         Sr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794506866; x=1795111666;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k1iKJ3ce6I7V1KzAt6ijmlB03GjSeH93EgIWrRWokzQ=;
        b=f8AlQKL6YIVGp+OPNUMizFQ5pK3m5iMfhjtHnapROAy8Lx8uBIXjhCmHZsvTWOfNOV
         0CEEZIXqKMwIo3vFfuqKHEI3sj0TTxhlLIW1tcGqmKISILykVB5dXyMmSusAnjn1ynWH
         kBpR29LAlD3ujkSz2gcwFoE6jBovXgr39pg7XVOmOCxbgWqgbjSQftMF7fgWZK4qj/Iq
         6KBt4PLlqDFT4OskAodgJD1VOmBrRF4YCQLvc//pk9/8sixjG+MmStROoOO6tvHsfakt
         8gVQRncNn+A2/6u8o2ex+3sJ8VZAJ9spOW8qlqzxvItxP3kVQV8W6C2/XiREs3hvreYu
         yEgA==
X-Forwarded-Encrypted: i=1; AL+hErGwehHpFhx0Mn/Kra5JUtcJQWwBnDWA0KERkY0NEvA6rFtazL6CLDsgLxjOOpqQy8K3D+ez2xg=@lists.linux.dev
X-Gm-Message-State: APuU4Z92CfaSR7fQnymlH2RbgILF7yEis8YXDmPiYab2BeydWYSdnF10
	AWMJMRZbNBxsXkSVtaozrUfBNv2t2rJbPf1JnX2toS96fwrktJUDNKtQ
X-Gm-Gg: AYBFou1JQGJQoM6JrFletBliwbgP+1F6w7pz3S1rrr8EK4izFuWKxip2Wh3xOqueD1a
	y/rRe1zK9YiCzRPAztxn4vWCp8PcvaUXISYIMdvY2eqXR0EwWk+o/0CJwBOc9OAYyzLTBSTnLD0
	ithLL0aSIX6LPASlamcn0QroeW40PXf2UUDDOJVHt3mIa7RBr3LfbT7mBmPXnztP7QD4xpaLJcI
	4vGSTFDRDoDHGM113u6YwHM8W1mqdK9H9iKho8QBHwbPkHPujOUdA+3YUWMh6TlbBBp9IbHSthL
	QZATMXDNHZLEOa3hP1Wz9sK5mmLEwpOioh5++R49+DWsC7TzJZpZ6+fTrr+V2+vrm8oAlftU7qm
	qS3rNqnvbJDPtoXD2jwlNSa/hp5Z8Tw6WOpmQBJKgibiNq0kvK+jC/6jQYw0CnQvKoiPPya0KA6
	uvGexymF9gKCm/W0ZAxaoF03bj10Dt3hPQM4/flqocyNAhbaYNUiS9/T2lQ5WS79tGHiNwL1Zoo
	B/vu4Vo+jfIzwlb3tGooE0K4AbwCTOjC6XqrewJPwJEfo4jq8U/Gy/u80bhSrsE60FLDPPRHuJ9
	MIKGLreuI3dCAEFBctMKIpaWNYO5Po4w7YtZag7WYjDS7hELjsYhB1cQoh1hmALOpnEYB84VoHn
	n18BAUrjGSX8YteBtgf7KF1cZNCCdOB7aoVOIWJyR+h7RLpy3wRDl9zRYbwMAiYugH3SGAOKJGU
	xtqqjs+Wx4VnzR4ElrvRTyU7L9ChhJGAPjMfwcpvhV
X-Received: by 2002:a17:90a:e387:b0:3b1:8380:a9a0 with SMTP id 98e67ed59e1d1-3b18380ac2fmr4732901a91.46.1794506866237;
        Thu, 12 Nov 2026 10:07:46 -0800 (PST)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b181f8fd59sm5540773a91.1.2026.11.12.10.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 10:07:45 -0800 (PST)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Navneet Singh <navneetsingh@microsoft.com>,
	apais@microsoft.com,
	rlmenge@gmail.com,
	hargar@linux.microsoft.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Hide FEAT_LS64_ACCDATA from guests
Date: Thu, 12 Nov 2026 18:07:41 +0000
Message-ID: <20261112180741.17614-1-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <040cf379-baba-4e3a-bf3d-6bc009a9e28d@app.fastmail.com>
References: <20261023070110.1833446-1-fuad.tabba@linux.dev> <20261023070110.1833446-2-fuad.tabba@linux.dev> <86fqxwzul7.wl-maz@kernel.org> <CA+EHjTw08SZC_3Uodt6ew6vXVH-doW-8G41fVCF-rmaKsv+0fQ@mail.gmail.com> <86ecdgzp6m.wl-maz@kernel.org> <CA+EHjTy0jpY3sdVCENJRj_kfRDwbZ6TpkCAHQ2xUO-7ZuErpcA@mail.gmail.com> <ad724195-3452-495a-a50a-5e5c8093a483@app.fastmail.com> <CA+EHjTyLnAXanf9R7SuoL3gFZUNewX7QOnW=mc3qzwvaxg7jJg@mail.gmail.com> <040cf379-baba-4e3a-bf3d-6bc009a9e28d@app.fastmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, Oct 27, 2026 at 02:48:29PM +0100, Arnd Bergmann wrote:
> On Sat, Oct 24, 2026, at 09:14, Fuad Tabba wrote:
> > On a host that runs at EL1 (nVHE or hVHE), this also requires
> > __init_el2_fgt to set nACCDATA_EL1 in HFGRTR_EL2 and HFGWTR_EL2, and
> > __init_el2_hcrx to set HCRX_EL2.EnAS0. Without them, the ACCDATA_EL1
> > access traps to EL2 and the hypervisor panics, and so does ST64BV0
> > once SCTLR_EL1.EnAS0 is set. Happy to write those and the KVM change
> > once you're ready to post this.
>
> Thanks for the offer, that part is definitely not my area.

Hi Arnd, Fuad,

We are preparing to post the Microsoft Smart Data Accelerator (SDA) VF
dmaengine driver for Microsoft Cobalt SoCs, which uses IOMMU SVA with
direct EL0 ST64BV0 portal submissions carrying the process PASID in
ACCDATA_EL1.

Now that Fuad's KVM guest FEAT_LS64_ACCDATA series is queued, are you
planning to post the host ST64BV0 SVA + EL2/KVM patches as a standalone
series soon?

Either way, we have Cobalt hardware with FEAT_LS64_ACCDATA available and
would be happy to test your patches on silicon, or help put together and
carry any remaining pieces alongside our driver series if you prefer.

Thanks,
Siddharth
