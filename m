Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08CA3E1D1A;
	Thu, 16 Jul 2026 09:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193661; cv=none; b=FNLw7X5JgJgUB7FB+5mn2dC4u9MRcTeUthkgb88BARKuHXqfiZ6QyIltBtFAW+D0JJ9vmEGiA5F7bjvPl3NfinwXx8yxO4iEs0dZ3bXFkjStmNFItTUQULGMaKJl1+2er2iLhuL04Tnb8p35zQHT5uzVYVkg3bQPkQInRtdAlpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193661; c=relaxed/simple;
	bh=mAmygk40Q0mJC5G0SZA+g5cL2Jls+CkcOyQ0X4Opiec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HHXnVgwDHOx7DAXuiL/vP/s/p3OQ3oA5qj5dvV7zy2NsMTKjdqWVOhN3tmNr+02x04MmbTzOLs4eBCqXC/324+Fvn/H8mUcn09nxuW34s4Q2OpPYfQUG7u8KQhxc0u72QLWrx5ovMfaYZ+eEd4zNRPHCjbSnnDNmLmaVbBfbSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XCngUfCt; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XCngUfCt"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 146822B;
	Thu, 16 Jul 2026 02:20:53 -0700 (PDT)
Received: from [10.1.25.27] (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACF2E3F905;
	Thu, 16 Jul 2026 02:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784193657; bh=mAmygk40Q0mJC5G0SZA+g5cL2Jls+CkcOyQ0X4Opiec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XCngUfCtXkZbA+ocAbat2Ig0u77nubEABa336hDNq57vrwTORg4rpsKTctAVRUC93
	 RoOu5AAAHlZydxttMoBU52GjH7HUmBuS39Z+Jmn4yefRwpweYWXEZMhEz4UjpcqHAl
	 YKOCa/NNQUSg1sFPIM7zYgWqG+LUhNeUy0BmkGDw=
Message-ID: <2aba2dc2-eac5-474f-9bed-af2cb3003136@arm.com>
Date: Thu, 16 Jul 2026 10:20:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 00/37] arm64: Support for Arm CCA in KVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <868q7bnxf3.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <868q7bnxf3.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/07/2026 09:36, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 15:28:02 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> This series adds support for running protected VMs using KVM under the
>> Arm Confidential Compute Architecture (CCA).
>>
>> It is the second part of the Arm CCA host support that was previously
>> posted as a single 44-patch series. The generic firmware/RMM support has
>> now been split into a separate 6-patch base series[0] so that it can also be
>> used by other work (and hopefully make reviewing a little easier). This
>> series applies on top of that base.
> 
> Splitting the series this way means that no Sashiko review can occur,
> as nothing applies on its own:
> 
> https://sashiko.dev/#/patchset/20260715142841.80544-1-steven.price%40arm.com
> 
> In the future, please post this with the relevant patches as an
> integral prefix, so that we can make use of the tooling.

Ah, I wonder if there's a way to teach Sashiko to deal with dependencies
like this? Anyway if you're happy with everything in one series and
(hopefully) merging a prefix earlier then I'll go back to that - it's
easier for me too.

Thanks,
Steve

