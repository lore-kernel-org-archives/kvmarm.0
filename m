Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840922;
	b=kSlZCvqzxe132gBRorOLzpWPr5kFbdl42A4HENPgsC6DdAKcmTD+zSmdyZ33dU1PhFKw
	 +Vil2QhE7hvBESWBUq0EF2rRDkZ8PNCDlT3Yh7cqq5p3Sd1fF1Ghu+1sSrbkM0csqoBSO
	 TvWzR2Brt92CVd5Q2mMXsbl1UsRLZKM8LX2GEDu6amoyK099LJZdJoqwTxd4Ri5uVGU0V
	 I+svcw1ZC8BQnOy36k8TWG8SvJ9TCDZ3aeZ1Hm3PPE6ndLl9SEAfeagqq+//CPWtqjv+K
	 J6P2LHZHxLYKz/Sd5AaJrZm2F7vcjoj8lzb/CqugwB0Kkh3lAYXLxxEjNjwzba1TYzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840922;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=dhpNbptHtWGeqwtJDxxu+ZKON7t1aC1UAEhp1vp/RvQ=;
	b=Q0WIywViTRbj013PNC7cRh35TJURCm9w3jjFjqRyjsou3DImjL6F5UkY31hxECvOIwgP
	 t/6nAN8t6bRL8H12otJqDl6HcIrWXRkMIFZQ8o8cLzLo/1x3ZdQB9ZGRuIoPwwhm8mn5r
	 rwixDtzsHo/HtJPlVbf1VtO1qU5kOwRPFyp3Z75T3FNWBIUZvSJa6YByBId1QITY0G6fR
	 7DZShj70fFElM9hOzWGzbK+tySBSDXk9gIm0bQdDt7ow4+IxlTLbCmDlPxIa1KoMPZFab
	 KZ+FBloUJECAU8f1gM/SU6uQ30naVFdFPS/sKcXCuFatqOtccoPN54xSh/Z/0hNIN/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eLtxxtnB;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF796606A31C;
	Mon, 16 Nov 2026 14:55:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF796606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eLtxxtnB
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B49EA1684;
	Mon, 16 Nov 2026 06:55:16 -0800 (PST)
Received: from [10.57.63.54] (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 351C43F763;
	Mon, 16 Nov 2026 06:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794840919; bh=Sp7fVwBe+QVG0GBjjUXT43r55ZA8pJUJowv4qnMKltM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eLtxxtnB3kbyPyVxz0I8NYvtZyDlTDjTDBxvVHLHHHSer6CfjCy71wmNwusyXm3sW
	 I6Xhgyi7yKx3n2aBaQxgdY5YDOYZowsl0TAnNIlNChL33P8ExyUXU87DGiZ89ibCxr
	 1Hg/6UdnY43fIPXvNlhhfH4Eig/Ve+4kgTyQ/IGA=
Message-ID: <7446568c-d794-4177-aac5-49746e2f05c9@arm.com>
Date: Mon, 16 Nov 2026 14:55:12 +0000
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
Subject: Re: [PATCH v2 12/12] KVM: arm64: CCA: Add Realm stage-2 MMU
 operations
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
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
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-13-steven.price@arm.com>
 <37a57d36-a516-4312-9e4e-fc151ab77c8b@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <37a57d36-a516-4312-9e4e-fc151ab77c8b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/11/2026 11:46, Suzuki K Poulose wrote:
> On 11/11/2026 14:57, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Register the Realm stage-2 MMU operations now that the RMM mapping
>> and unmapping helpers are available. Route unmapping through the
>> RMM, and use the existing fault handler for Realm memory faults.
>>
>> The RMM handles TLB invalidation when stage-2 mappings change, so
>> the host has no separate TLB flush to perform. Realm stage-2 does
>> not support access flags, including for shared IPAs.
>>
>> Dispatch stage-2 destruction according to the VM flavor. Realm
>> teardown destroys non-root RTTs through RMI, so the host frees
>> only the root RTT pages.
> 
> Minor nit: It may be worth splitting the destroy abstraction as a
> separate patch. Otherwise looks good to me.

Good point - I can split that out.

Thanks,
Steve

>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>>

