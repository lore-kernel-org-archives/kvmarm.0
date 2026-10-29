Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793308524;
	b=tfs0BpchwR/RteM1AVfAGDoEo9z7lvcoTxKUevEWsA2THjHctx8+qlEJftTqb41k0ItC
	 gruU+tzuipG0sCEZX+J92woHTGm1qfHzj5gZ8UQqfJwG1ZsMhxS7GRAHhCFleSPOIDwTh
	 QVZXcEqIjJjIRZLe9QxvnH437TbNWQBqudwML3vh5MZM3d817QaOnCNgnAyuKBaKAP4EC
	 XgMiHxi46AWxrePhCEZ0aSvv5GZ5CvF2uS4wi9dY8K7HY6BLN1KDiGqW38ZfydPSVT9KS
	 jkWMwUnzUwIFb6nwPI/HT3TR9EWFkKV9+kXP3CuZ7XaQQxuXnmzo8SJvnp2ake2xQfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793308524;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=uUOoxh5FjWUwpph2LqQnLF50bqkpEqoE20tLRRD+3zY=;
	b=BEwbMm2CgIaOa9ySpY2Q2eN7YybplHW0fqChKknguhxFeDcekxCEW+CfMlC+WPVHqL5j
	 QnPmfep25OC/yllQvoADzBeXsVxMVIb1EAicqY/1UzB89NjjNY+B3InP1hRuS61hY6tuG
	 bmuUrnOOK6bIO+x7ItbPNflUrjLFP0Vecg02+mNGFT2wYUHgtMSZbG29XuB+6fsioE1pd
	 CG3IptG56kGirNB8OGZVIL8/KfFIe/CroAHlWW059PYQtEKK76e7XGO9KzYIRDETyIQ8P
	 QRra55GxV/fxrl/oKurjAe0Amvf0ZL3iNGkUnVRnnhGyeHDdc1GB+QqpYi1NKv//nAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=g8Ac2snP;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3BC606A323
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 21:15:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F3BC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=g8Ac2snP
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F6711682;
	Thu, 29 Oct 2026 14:15:19 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CED13F59E;
	Thu, 29 Oct 2026 14:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793308522; bh=cLLb8kTBxnx4UA1bZ7blmuTf4w+v25p4Ofqywv52Tv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g8Ac2snP/yP6eE1gMl5eSWsRnObRxt4TKvv7JwVEnOV/kho0T5s+Ll5cxuy0oypZS
	 OzFHVvh/5N8rSHvnPETiD9ah02AzfUsabo/JDjP9K5JkXElI053yHln7/VWq8aKRCp
	 QOatav4wSox4p9lwpJ4gSOt/tbvtIl1Wc8PtPt4c=
Date: Thu, 29 Oct 2026 21:15:18 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Zhou Wang <wangzhou1@hisilicon.com>, Arnd Bergmann <arnd@arndb.de>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] KVM: arm64: Add context-switch of ACCDATA_EL1
Message-ID: <auO3ZuB74waA_bPD@arm.com>
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
 <20261025075138.2919734-4-fuad.tabba@linux.dev>
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
In-Reply-To: <20261025075138.2919734-4-fuad.tabba@linux.dev>

On Sun, Oct 25, 2026 at 07:51:36AM +0000, Fuad Tabba wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Add ACCDATA_EL1 save/restore as part of the EL0 context. This is
> conditioned on the guest's view of ID_AA64ISAR1_EL1.LS64 reporting
> that this register is supported.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: 58ce78667a641 ("arm64: Add support for FEAT_{LS64, LS64_V}")
> Link: https://lore.kernel.org/r/20240815125959.2097734-5-maz@kernel.org
> Cc: stable@vger.kernel.org
> [Fuad: rebased; switch ACCDATA_EL1 for guests only, as the host never
>  uses it; gate it on a new ARM64_HAS_LS64_ACCDATA capability, since
>  in pKVM the host controls a non-protected guest's ID registers, and
>  an EL2 access to ACCDATA_EL1 on a CPU without the feature is UNDEFINED]
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
