Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795000477;
	b=PXomP9yhtgdy5Yp80gzwT7XQjRgapBs/a8iZzmmtdH7JNVJ2XKqo8hQGq5CBkN3HTNtP
	 SdDfhZbiujNl8m733/X9BgAKSSZQ5h2JvELKNThXzFePybvuuBo8rBDvG+DsK/6gNJ7v+
	 5ovPRgCzH61BnnbUAsvtcWDKHdDTCDCZrMnpE+Ji0B+cABKVoPoIw3Uh283k8pgyjDAAW
	 YWsnzaPzjILG9N49HbhHDncpetRALRqn+h3VkEil1vdDI6oTwU9MAZpc2A0EPsitfZQV8
	 A19Hw2pk3FB9LvbXBJXQy0iWj+S3ePi1SQScxU/XiTuA75skbcjYI6+BW/uh3eJt3Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795000477;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=kpFNtNivNFK5E09pZOo62DDo/NkEsRhWz34V2Kf54aw=;
	b=36WH/yXMJN6o1bsd7hLgCp5RTQJfMUsrj27S8T3hOPqHT0OJ/c2vbPvSYxyzLZBsL/fZ
	 yD+T52yFGZt3kfP5r+pqCeDz3TuZHLqoov/Nwn9kl5xE75/hf7XD0RM4mw/xPOVvxDAIO
	 fXv7tiNz7K1kTcd3/oIuLwKSQrRAtSgCstWvzHe2+R7WZnX3MdUgMPCE2dBNJhNOxbRWT
	 oJWzlGOT74A/DR3tWX0+gMiUbW7uQrPCL0WH99rfhjfPuzsE5aZMQv41c69UJUg4VdGya
	 2KWoMoxL/xFyyJRd+f3U1CjO6EP0cA7y2RBvQIjk4lrS9+3h1RdHoHKTqI5MqQf+eEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=E5gQTmv2;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA3EA606A320;
	Wed, 18 Nov 2026 11:14:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA3EA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=E5gQTmv2
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D56301596;
	Wed, 18 Nov 2026 03:14:32 -0800 (PST)
Received: from [10.57.62.206] (unknown [10.57.62.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 192D23F673;
	Wed, 18 Nov 2026 03:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795000475; bh=TKbqgMIPduy318TAL4Aa4U0sAxhaULPe1XRzCdumkbg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E5gQTmv2MiIyZx1MnDRo90tJYN43gume5p7d6KB3NmpM0o7uA6PCE2zYcpBmb8Jsi
	 t3YfPJKXHuK2Zrp0s0DHEAbc9gp1pTOZXTjE28mbBo8mvrgYgeYJhxuIMZjSTozrXA
	 vi/rEcEBJt1XoR6wS15Ak9Tq4KWaTk6E+nieQkTo=
Message-ID: <b1ef7241-54b0-4a17-83b6-0008e722f2f6@arm.com>
Date: Wed, 18 Nov 2026 11:14:23 +0000
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
Subject: Re: [PATCH v3 01/11] KVM: arm64: guest_memfd: Check mmap support when
 preparing memslot
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
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
 <20261116164358.142785-2-steven.price@arm.com>
 <CA+EHjTy5xBmavNWSYPjqU9qXtssV3ZHzsUr1s_4bVOt1GnDLVg@mail.gmail.com>
 <6bb490cd-ebbe-41d7-adf3-d6eaf0e53478@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <6bb490cd-ebbe-41d7-adf3-d6eaf0e53478@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/11/2026 10:34, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 17/11/2026 14:05, Fuad Tabba wrote:
>> Hi Steven,
>>
>> On Mon, 16 Nov 2026 16:43:47 +0000, Steven Price
>> <steven.price@arm.com> wrote:
>>> Check the guest_memfd backing file when deciding whether an arm64
>>> memslot has mappable memory rather than checking whether the slot is
>>> gmem only. A public helper function is added to be able to reuse the
>>> static kvm_gmem_supports_mmap() function.
>>
>> nit: could the message say why this is needed? It's a no-op until
>> patch 8 defines kvm_arch_has_private_mem(), which makes every
>> guest_memfd slot gmem-only.
> 
> I still don't understand why this is needed. For arm64 we have always
> prevented guest_memfd without MMAP, in kvm_arch_prepare_memory_region().

Fuad is correct, this isn't really needed until patch 8. Patch 8 defines
kvm_arch_has_private_mem() - that means that gmem_in_place_conversion
becomes true (see include/linux/kvm_host.h). That in turn means that
every guest_memfd slot is KVM_MEMSLOT_GMEM_ONLY including slots backed
by a file without mmap support.

But regardless the check for kvm_memslot_is_gmem_only() isn't really
what the code is trying to do. The fact that the memslot is "gmem only"
isn't really relevant. The thing we care about is the mappability.

But I agree the commit message could do with improving. I'll expand that.

Thanks,
Steve
