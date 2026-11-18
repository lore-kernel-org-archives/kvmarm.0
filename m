Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015123;
	b=k+9DBFcz4EtpDa3k+AOifDO/sigF7q1sX0n23LO92AIFf75MX0btBshNZLhlfZU4esB6
	 u7mZE8HKQYkO+hPob8/i7lbJsNIN3dbT6PVUdNMWnMZAFdUvwGhE6ritkGf0RZrr/i/+v
	 VBGCRL0/VZbmYXY//Ofgui2deBCvLvs9b4XaFQu6t5FfAh9wiR6qSdiTszFSVKn14egbA
	 eVvzbwMcWDg/1u3OYfvm/1qc7AeJ4BFfDkx3bCM0hD4AuLIUUHgfxU9pZw0CZOoX9umHW
	 nEnN0v0R6OGj3UBqOzrtEaLyLhMkP9F//nOiwF+X5V4ZjCLsCw6XmsNrKR4m+DFNOlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015123;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Content-Type:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To;
	bh=y2Daclv3pL9H+Z77v1N/YFpOGh7HbXy37WIqhvkcADA=;
	b=SfuT01LE4tx72wzOzFLcmT1P5h5UGR+hUWidmeB1Ngk+RlTv6lxV0w4KZ/TItlQfkuwg
	 A+6KQOD/7qDNttuwIHItLwX1dBijRHYkmNj72PDpTZI8My/qSZLgEaC6Hvl20tuWtUc99
	 ++KRK+wfTyWIw7FPsnfK9Hs2mAJb4pLEqCSVNP0S9PeO0lkqEOrfaqbQTVwx1V+Og9fsY
	 mpP96k49iPBGE+XwnjGgNUP5UVnZ9y1nTTA6G0CQMpFtJ9lJ2xNKtsFd9eVGaB0+tWJ7I
	 fLxnRKphHOmIyqWBY7LIpuJpQxydJHZjAp1biroE+tRooeeh/b+WqGiuu58OaHv8auQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="a/CjEp/l";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3CC60A2603;
	Wed, 18 Nov 2026 15:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C3CC60A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=a/CjEp/l
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A28B21655;
	Wed, 18 Nov 2026 07:18:39 -0800 (PST)
Received: from [10.57.62.206] (unknown [10.57.62.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9A9D3F632;
	Wed, 18 Nov 2026 07:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795015122; bh=w8XDtw7u6zTGcD/Dwtz8Nec/j+mFGkTq9Cwd9QWx4y0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a/CjEp/lWJU4QLjpelP/JTZv2ruOnbBbt+JLSbKpYAP4VCqrHHdtlgkcAWih3sdxj
	 WYJKvmin5k2Qjivd13tyo7baEd5InyOwxPHvleh83xiTrhEYXBsYsilr0DlLJongQ1
	 fQ7iiucy60FJx40w9DUaxvWafVfHMCNzI7k8LEzc=
Content-Type: multipart/mixed; boundary="------------DUFNbHBbvPDY00EhsT6K87G7"
Message-ID: <cc27e6a8-6bfa-4c82-92a7-33175baf6803@arm.com>
Date: Wed, 18 Nov 2026 15:18:35 +0000
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
 <b1ef7241-54b0-4a17-83b6-0008e722f2f6@arm.com>
 <8a095a42-662a-416d-a5d7-79e10161201c@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8a095a42-662a-416d-a5d7-79e10161201c@arm.com>

This is a multi-part message in MIME format.
--------------DUFNbHBbvPDY00EhsT6K87G7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/11/2026 12:04, Suzuki K Poulose wrote:
> On 18/11/2026 11:14, Steven Price wrote:
>> On 18/11/2026 10:34, Suzuki K Poulose wrote:
>>> Hi Steven
>>>
>>> On 17/11/2026 14:05, Fuad Tabba wrote:
>>>> Hi Steven,
>>>>
>>>> On Mon, 16 Nov 2026 16:43:47 +0000, Steven Price
>>>> <steven.price@arm.com> wrote:
>>>>> Check the guest_memfd backing file when deciding whether an arm64
>>>>> memslot has mappable memory rather than checking whether the slot is
>>>>> gmem only. A public helper function is added to be able to reuse the
>>>>> static kvm_gmem_supports_mmap() function.
>>>>
>>>> nit: could the message say why this is needed? It's a no-op until
>>>> patch 8 defines kvm_arch_has_private_mem(), which makes every
>>>> guest_memfd slot gmem-only.
>>>
>>> I still don't understand why this is needed. For arm64 we have always
>>> prevented guest_memfd without MMAP, in kvm_arch_prepare_memory_region().
>>
>> Fuad is correct, this isn't really needed until patch 8. Patch 8 defines
>> kvm_arch_has_private_mem() - that means that gmem_in_place_conversion
>> becomes true (see include/linux/kvm_host.h). That in turn means that
> 
>> every guest_memfd slot is KVM_MEMSLOT_GMEM_ONLY including slots backed
>> by a file without mmap support.
> 
> But we dont support slots without MMAP anyways even without this series.
>  So, does it really matter for arm64 ?

So ChatGPT produced the attached test. It creates a non-mappable gmem
and tries to add it to a normal (non-realm/non-pkvm) VM. With v7.4-rc1
it is rejected. However without this patch it succeeds.

The issue is that gmem_in_place_conversion changes the behaviour for
normal VMs.

Thanks,
Steve


--------------DUFNbHBbvPDY00EhsT6K87G7
Content-Type: text/x-csrc; charset=UTF-8; name="guest_memfd_nommap_repro.c"
Content-Disposition: attachment; filename="guest_memfd_nommap_repro.c"
Content-Transfer-Encoding: base64

Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQovKgogKiBSZXByb2R1
Y2UgdGhlIG5vbi1SZWFsbSBndWVzdF9tZW1mZCBtZW1zbG90IHJlZ3Jlc3Npb24uCiAqIEJ1
aWxkIGZyb20gdGhlIGtlcm5lbCByb290IHdpdGg6CiAqIGNjIC1XYWxsIC1XZXh0cmEgLU8y
IC1JdG9vbHMvaW5jbHVkZSAtSXRvb2xzL2luY2x1ZGUvdWFwaSBcCiAqICAgIHRvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2t2bS9hcm02NC9ndWVzdF9tZW1mZF9ub21tYXBfcmVwcm8uYyAt
byAvdG1wL2dtZW0tcmVwcm8KICovCiNpbmNsdWRlIDxlcnJuby5oPgojaW5jbHVkZSA8ZmNu
dGwuaD4KI2luY2x1ZGUgPGxpbnV4L2t2bS5oPgojaW5jbHVkZSA8c3RkaW50Lmg+CiNpbmNs
dWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c3lzL2lvY3RsLmg+CiNpbmNsdWRlIDxzeXMvbW1h
bi5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgppbnQgbWFpbih2b2lkKQp7Cglsb25nIHNpemUg
PSBzeXNjb25mKF9TQ19QQUdFU0laRSk7CglzdHJ1Y3Qga3ZtX2NyZWF0ZV9ndWVzdF9tZW1m
ZCBnbWVtID0geyAuc2l6ZSA9IHNpemUgfTsKCXN0cnVjdCBrdm1fdXNlcnNwYWNlX21lbW9y
eV9yZWdpb24yIHJlZ2lvbiA9IHsKCQkuZmxhZ3MgPSBLVk1fTUVNX0dVRVNUX01FTUZELAoJ
CS5tZW1vcnlfc2l6ZSA9IHNpemUsCgl9OwoJaW50IGt2bSwgdm0sIGZkLCByZXQsIGVycm9y
OwoJdm9pZCAqaHZhOwoKCWlmIChzaXplIDw9IDApCgkJcmV0dXJuIDE7Cglrdm0gPSBvcGVu
KCIvZGV2L2t2bSIsIE9fUkRXUiB8IE9fQ0xPRVhFQyk7CglpZiAoa3ZtIDwgMCkgewoJCXBl
cnJvcigib3BlbiAvZGV2L2t2bSIpOwoJCXJldHVybiAxOwoJfQoJdm0gPSBpb2N0bChrdm0s
IEtWTV9DUkVBVEVfVk0sIDApOwoJaWYgKHZtIDwgMCkgewoJCXBlcnJvcigiS1ZNX0NSRUFU
RV9WTSIpOwoJCXJldHVybiAxOwoJfQoJZmQgPSBpb2N0bCh2bSwgS1ZNX0NSRUFURV9HVUVT
VF9NRU1GRCwgJmdtZW0pOwoJaWYgKGZkIDwgMCkgewoJCXBlcnJvcigiS1ZNX0NSRUFURV9H
VUVTVF9NRU1GRCIpOwoJCXJldHVybiAxOwoJfQoJaHZhID0gbW1hcChOVUxMLCBzaXplLCBQ
Uk9UX1JFQUQgfCBQUk9UX1dSSVRFLAoJCSAgIE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9V
UywgLTEsIDApOwoJaWYgKGh2YSA9PSBNQVBfRkFJTEVEKSB7CgkJcGVycm9yKCJtbWFwIik7
CgkJcmV0dXJuIDE7Cgl9CglyZWdpb24udXNlcnNwYWNlX2FkZHIgPSAodWludHB0cl90KWh2
YTsKCXJlZ2lvbi5ndWVzdF9tZW1mZCA9IGZkOwoJcmV0ID0gaW9jdGwodm0sIEtWTV9TRVRf
VVNFUl9NRU1PUllfUkVHSU9OMiwgJnJlZ2lvbik7CgllcnJvciA9IGVycm5vOwoJaWYgKHJl
dCA9PSAtMSAmJiBlcnJvciA9PSBFSU5WQUwpIHsKCQlwdXRzKCJQQVNTOiBub24tbWFwcGFi
bGUgZ3Vlc3RfbWVtZmQgbWVtc2xvdCByZWplY3RlZCIpOwoJCXJldHVybiAwOwoJfQoJZnBy
aW50ZihzdGRlcnIsICJGQUlMOiBLVk1fU0VUX1VTRVJfTUVNT1JZX1JFR0lPTjIgcmV0dXJu
ZWQgJWQgKGVycm5vICVkKVxuIiwKCQlyZXQsIHJldCA8IDAgPyBlcnJvciA6IDApOwoJcmV0
dXJuIDE7Cn0K

--------------DUFNbHBbvPDY00EhsT6K87G7--
