Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3387C3009D6;
	Mon,  3 Aug 2026 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785771933; cv=none; b=SvSf9ODBtzQq38Tlokz0AStrK8BVq2oMJoniFVojUhmdi9UekT2uIN20JgrDqmrco6e57ezILcJsCtyACmTTkKllFIS9Co7FcLi54dfLSBAxKWp5oloik+UhqjWcirDRNJKBdNQfOoSkeZsVKqPYypIlZnR7Mvp5QG6yQdaarEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785771933; c=relaxed/simple;
	bh=FlSxPZi9ON3WGFAwqN7D6TZRPmH4l3ZVoXYKF5UKdAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qP4QlL74b8ZFwwaLtdekA3l1NwXDNlUBa1e15P169IIpE2rtMpKOSsOrui031lyy8CCxsmUlctf58DPrNHeL6xvi+CFaYh1UaE3bD/DL+gTcVwsToV6PnvqkPXAlVtI4uTAD2U5nt1uEzxp0KrzlE3p+1uRm9uq0513g+BFTMQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IguL1cVX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IguL1cVX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86193143D;
	Mon,  3 Aug 2026 08:45:27 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 780863F66F;
	Mon,  3 Aug 2026 08:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785771931; bh=FlSxPZi9ON3WGFAwqN7D6TZRPmH4l3ZVoXYKF5UKdAM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IguL1cVXRmCDcxT1A3RGNMAQ4M3tfAzkCMVWpB7evx0IzhWKFj7LI3m5Fpv+kubjC
	 txI0I9fWDidReTJQ1w8IfzwNBONpqXH0RrVPy/KNDss0Um+BfYFIc4OoPHb5YSQlB5
	 3Wa6zsc+9gt/9tQT3CvExmW10vCVnBbEp1HyaaK8=
Message-ID: <643818bc-38b6-46ba-833a-0a5e825328f1@arm.com>
Date: Mon, 3 Aug 2026 16:45:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
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
References: <20260803134403.80630-1-steven.price@arm.com>
 <86y0enb64s.wl-maz@kernel.org> <57225daf-4319-406a-8328-e32835e8a980@arm.com>
 <86wlu7b58z.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86wlu7b58z.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/08/2026 16:20, Marc Zyngier wrote:
> On Mon, 03 Aug 2026 16:06:24 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> On 03/08/2026 16:01, Marc Zyngier wrote:
>>> On Mon, 03 Aug 2026 14:43:16 +0100,
>>> Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> This series is based on the guest_memfd in-place conversion v9 tree[1],
>>>> which is itself based on kvm-x86/next. It is also available as a git
>>>> repository:
>>>
>>> Well done. Series on top of another random series, based on a random
>>> tree. Unusable. Have you realised there are reasons why we (KVM/arm64)
>>> ask people to base their series on a *released* tag from Linus' tree?
>>> This means that Sashiko cannot, once again, provide any feedback on
>>> this series, as it fails to apply.
>>>
>>> Just to avoid any ambiguity: Sashiko reviews, as annoying as they are,
>>> are not optional. They are very much mandatory, and I wish I could
>>> turn back the clocks to run it on my own code...
>>>
>>> Running it on your own is not enough, because *I* want to see what the
>>> tool finds. Not to mention that non-Gemini runs of sashiko are much
>>> less interesting (unsurprisingly).
>>
>> Sorry, but I'm not sure what you expect me to do - clearly I want to
>> base my changes on top of the guest_memfd series which is being worked
>> on and not just ignore that work. So I've based my changes on top of the
>> tree that Ackerley published.
> 
> But that completely ignores the way the KVM/arm64 tree is managed. If
> you base a series on a bunch of unmerged patches, how do you expect
> people to do a sensible job at reviewing it? Now I need to ingest
> another pile of random patches just to review this set?

It's based on the same 'base' as v15 was - it depends on the unmerged
guest_memfd changes. I've just updated to the latest revision from
Ackerley. You've been reviewing the changes, and I've attempted to
update the code based on that valuable feedback.

Clearly I'm not expecting this series to be merged yet - we're waiting
for the guest_memfd changes. If you have a suggestion on how I should
tackle this in the future then please let me know. I could bombard you
with an even bigger series with Ackerley's series on the front, but I
think you'd shout at me even more if I did that.

> Not happening, sorry.

Well I'm off on 'holiday' or more accurately to move house. The new
house's (brand new) hot water cylinder is bust and the plumber is
currently saying we can't even have cold water, never mind hot, so I'm
going to spend the next week worrying about things other than this series.

If you provide review comments then I'll look at them when I get back.

Thanks,
Steve

