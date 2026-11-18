Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018392;
	b=M6mjcq6m2Wo5M63gC3QABz7fPjFG2+6nLPgKiAJ7Qz5ZCXIEKu1R8qyApgio5hnm/++I
	 ZcgRvI3GAvHSC8jxH1tcfJ+VaB+7hi5ySnaIp2qUNjZ6jetNzCA2tYtKe52N3L+fslIJy
	 htUSvoKy6zELvMy+jSHWFcM3Cbk9+dLNJT+WSGefXlf71wzAXDCxrFvUTMHT7wC63lLd3
	 Q/sGU3EYtvxuYAhdB4gUQxGS1mu3qD6CEzQg/KQpGpF9ss+mmuDfgOkYpZIDgXyNUlL/r
	 FdGbOu2hYHofXwjWN7g4zgLAkxXAMRthKfBXWlR+HvphHbXlEuWn71wFJOt8NZgc20w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018392;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=1IbllusjMRCIaAIXLA41cjwGt2hmRdKFmrBTakj2Av0=;
	b=zXwn+KdY+mUcVqLHSxIconPLXGUJR24MvuBjWOoXddxz8u5MeFQRYU/zIebAdMmxUTHI
	 wwF4QJO+PQSKHQVNjuDwkr4JYlnFf8WxjS9QMstK3ThZczIOkHozK/IeR43M10Xx66ggL
	 9u2juRVTClo7czT/DZWq9Bw+kCnPh2juXPS3UYB8O7LDUAe9U0u8OKme48GBuV1jnOKnW
	 YYjN6lq27dKXyIuC7ymq20sNRZ1+7m4DIDEttDGJJEQPWUMN68ArKY9jkfqADLse87xUx
	 ZxXqbNnhNy1f1Oim6rdTp3OBzLqFSCC4fCotcVLpsKV6PsNrhGBfF1TNTNYVzR9LOGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="gOtf1/KA";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BACB606A335;
	Wed, 18 Nov 2026 16:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BACB606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=gOtf1/KA
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0561E1596;
	Wed, 18 Nov 2026 08:13:08 -0800 (PST)
Received: from [10.57.62.206] (unknown [10.57.62.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C54163F673;
	Wed, 18 Nov 2026 08:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795018390; bh=nK7TBcSEp2JbydJ2xoCE0lvuJ2Yl2LRjmtzjJylPKjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gOtf1/KAKZj0LMreurjK+QC939uTJvImRh1Xm/OujjEONs/gFKqLMkCFvInwO66+E
	 urAh8koJGsYtsUadAI9jgqq8h9ix5b0q6/3JxMcNYtb277lkuF12K29garixfPWOYV
	 9zDoYMbQFXlvdFTnpzct0re30aKTlLViMKjThLAg=
Message-ID: <6f0f15ef-37c5-491c-9b71-f78ff5b50a23@arm.com>
Date: Wed, 18 Nov 2026 16:12:59 +0000
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
Subject: Re: [PATCH v3 03/11] KVM: arm64: Handle attributes in
 stage2_unmap_range
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-4-steven.price@arm.com>
 <CA+EHjTyeE0gbLgfiDePPVRR88GFVa7G-G8sr8k6vzM7v_uHxdA@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CA+EHjTyeE0gbLgfiDePPVRR88GFVa7G-G8sr8k6vzM7v_uHxdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/11/2026 14:16, Fuad Tabba wrote:
> On Mon, 16 Nov 2026 16:43:49 +0000, Steven Price <steven.price@arm.com> wrote:
> [...]
>> With the introduction of private memory support, we need to
>> handle invalidation requests with filters for a given type.
>> Add support for passing the attributes down.
> 
> nit: what this passes down is a filter rather than attributes, in both
> the subject and the message.

True - I'll update the commit message.

> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks!
Steve

> Cheers,
> /fuad

