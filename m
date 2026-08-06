Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DF53B8405;
	Thu,  6 Aug 2026 22:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786053935; cv=none; b=Ye75mLNUBP0xqCeVpTCgQjxLkW3md7x0hUrefL1IG/4mjIR0nyXSPLYXU7e+qN1eGNKJ+an68IJzy1BtwTVw9O1nWzsEAZqgmyM8Rx4Nat0KvhAvJemdYefTMoKKXIUoJxKiAywmZPk65j1Cf+NSuGvAetZpYGjvr1/ozgb5Ob4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786053935; c=relaxed/simple;
	bh=v/L2HSf1KNTXA1th8L9+b1jkT+PbXLtTdKC9CLCe6aE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bQzkhYQSQZIvo4KV/MLWfMIe4AfxQE3P9PBADiwAO2YuUtpv/daspeC8vHs6u8QmM0854NnqPdVDiq0yEr5AqVHjazuT29fGf8x6dcWSbdDM5guRjxn6wNAdRbWYptbtwzS/b/jpY9YxWydaVIIHR/9fdWhl9taieQjHz0MpE/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ggV3jSsH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ggV3jSsH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECAAE153B;
	Thu,  6 Aug 2026 15:05:28 -0700 (PDT)
Received: from [10.57.40.157] (unknown [10.57.40.157])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69FC33F86F;
	Thu,  6 Aug 2026 15:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786053932; bh=v/L2HSf1KNTXA1th8L9+b1jkT+PbXLtTdKC9CLCe6aE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ggV3jSsHif6GUt7ygEDwaca9HUMK4dxVMocg6ZDOcSTYTGW7gyBLCn/NxistwWIYY
	 ZhqNSDSTYi7IlWKSmhbKa/WvSzz0YuA93NktJ+rTZauHLz5QABYmi3axkC9VIrLpOC
	 BdR5yVpTOPRmtrPkEza5Ap0eiOFafFv3jBGAadQQ=
Message-ID: <42170467-fe36-4382-867f-49bdc6a7bc9a@arm.com>
Date: Thu, 6 Aug 2026 23:05:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/08/2026 14:43, Steven Price wrote:
> This series adds support for running protected VMs using KVM under the
> Arm Confidential Compute Architecture (CCA), including the firmware
> support needed to communicate with the Realm Management Monitor (RMM).
> 


...

> This series is based on the guest_memfd in-place conversion v9 tree[1],
> which is itself based on kvm-x86/next. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v16


> 
> Work in progress changes for kvmtool are available from the git
> repository below:

Here is a cleaned up version, rebased on to Will's kvmtool master
branch:

https://gitlab.arm.com/linux-arm/kvmtool-cca cca/kvm-v16

(This works with the v15 of the KVM series too)
Build on top of Fuad's Guest memfd support patches.

Cheers
Suzuki


> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v13


