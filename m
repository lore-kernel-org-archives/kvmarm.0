Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795607691;
	b=huI6uLJLzug4GfE47Z1Nzyv9I5Z/y7r3rFrn/mc+VgvojZNllNwV7942AZtg0mskyqZo
	 8+3xZlVztsMB5uB4lk8QBV78hkm0F7aKdI8vhS5JDpuoFgbNEiFKmcwpwFs1i9zWG8q/q
	 AIopcokwNz+lGnO6LiIPrr+VEWnSWSDAqkyC4a6rJ5NjuSLNL4aT9M1/3xfqdjxjLSkWh
	 n6I/D1c3xewHrLfRqrNWvPzSmZHEQMlCCb37b8AOyJ8whWCEF6Vf94pUEnbkyD7GkTX7X
	 mGv6TIh125EyllwSO4LlwZgr/2xfGVcC5QdbO8MtPAxwcSLyFTl0rq4ss+wEb8kmzsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795607691;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=hrdNgf41OVOvk7Q8wssfV4Th9fs8mNrOwxABB5Eu2AY=;
	b=WKfwV0mKb+a+/yrtKywUHpIYyaaQS9E6lKF6eSP8U2FVeDyUk58YY4asBL/TTcqkBUpu
	 mbojj4uj/q1rJixceVN2iHeCCMIpjINgmqQyFW6Tzoi8+S+azzwUUK7nc3QN3tn1rBCU7
	 Vfaw2I0NQ6ovavB1shg1OqSpKCiaWPpN6U5pqBZPKyl1PN2q7UJYB7hcSIOhag/ONA1JO
	 +xWqEDN07qwfPFILbiZwtBRaVSZCN4mLak18ov3s/BQED7dXYrgbyN2IKzcgCf6Bnv+5J
	 jjeTXureH0UPyPZgQ69uq2cmdOxgxSfX1rjRim4/IwKR09oYRC0afk3zVmMzi/P8BbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MYu8Ffnc;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B132606A31E;
	Wed, 25 Nov 2026 11:54:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B132606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MYu8Ffnc
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D288F2F;
	Wed, 25 Nov 2026 03:54:47 -0800 (PST)
Received: from [10.57.32.107] (unknown [10.57.32.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98C6B3F86F;
	Wed, 25 Nov 2026 03:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795607690; bh=FdD752s2MbSn6Ah8b6CmNxJRAfCF8aNL4kgILGt8wZA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MYu8Ffnc3RGgD74p37RZXJvnnXfG5ts2YdgdjMBhWpnabINb8oEcmFb7ELLqTmRIW
	 eNJ7Td43l6iZ9cO4MJBNv2gqBN+Mv2DNWHDa8x6+6qJM7KSnp1iMNNWty8iFEK6uKW
	 xTiuOraJkQ9+2AjE8dY/X/GInMjx2xB4moNQrAi4=
Message-ID: <8b3c107f-9f33-40e0-82ae-7d0373465acb@arm.com>
Date: Wed, 25 Nov 2026 11:54:43 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/11] KVM: arm64: CCA: Prepare Realm memory management
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
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
References: <20261123104233.95710-1-steven.price@arm.com>
 <awVZ0UrEKN9gLHIZ@FCCLS0092175.localdomain>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <awVZ0UrEKN9gLHIZ@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/11/2026 09:47, Kohei Enju wrote:
> On 11/23 10:42, Steven Price wrote:
>> This series adds the memory management plumbing for CCA, building on the
>> basic RMM support [1]. Thanks to everyone who reviewed and tested the
>> earlier versions.
>>
>> The patches introduce internal Realm VM state, prepare Realm stage-2
>> setup and teardown, and provide RTT mapping and invalidation helpers.
>> Realm memslots are restricted to the lower half of the IPA space because
>> the protected and shared halves alias each other. The final patch
>> connects the helpers to KVM's stage-2 MMU operations.
>>
>> This is the memory management portion of the larger Realm host series.
>> Realm descriptor creation, REC entry and exit, activation, and the new
>> uAPI follow in the integration stack. This series alone does not enable
>> Realm creation.
>>
>> The integration branch [2] includes Realm creation, REC entry and exit,
>> and the remaining host support on top of this series. The MM branch [3]
>> contains just this series.
> 
> Hi Steve,

Hi Kohei,

> I tested the v4 integration branch in the same way as described in the
> following thread, and I haven't seen any issues so far:
>   https://lore.kernel.org/all/avV-P2_fOkFWQVnM@FCCLS0092175.localdomain/
> 
> For the series:
> Tested-by: Kohei Enju <enju.kohei@fujitsu.com>

Thanks as always for the testing!

Regards,
Steve

> Thanks,
> Kohei

