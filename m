Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1A9459AE4;
	Tue,  6 Oct 2026 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791299676; cv=none; b=NoYVxAEQwhlgehBUh3MgrFm2812If6ZwV+2t8fxwkYqUHrHZ8bCBGjvkUrIhfH1ZvCKIkuI1O1ux89lWMOmoxvCM70DBo5z4KHmI0D3TtY9w+VZxGnJd1X1IVsyo814PeLOSRAMtMCnYXmAP8QVDOFKR2Iy3digrEB8riF9dnKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791299676; c=relaxed/simple;
	bh=ZmhMumn52cBVQaHkyzR0XIkkVAJp/l8twjtlqe6zjx8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mCVx15L95oBRopg0wK4W8CSU+h8Eh1q+l1Z2an20jmmX6DJq4/NQGUHudMvZA3ciY7FtxKTb313NE47AjF1NqCNCn9DsV7F2Tke3eshxhhFzUc9vumKaj+X0SfUi0955J9+MockweFmzFLHv6Hwkj/2k6FiENg5vycWoeRP0uuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DGsSEVOW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DGsSEVOW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DED31516;
	Tue,  6 Oct 2026 08:14:30 -0700 (PDT)
Received: from [10.57.10.233] (unknown [10.57.10.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99A543F763;
	Tue,  6 Oct 2026 08:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791299673; bh=ZmhMumn52cBVQaHkyzR0XIkkVAJp/l8twjtlqe6zjx8=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=DGsSEVOWURmhvfqK1LRZ1Ng27xl1EsFRu6r6JfQaBf0tEQl3nESaa2L2g0Llyzd8i
	 SJHUOrivH5wKaf0b6Z+TIOIKEcDyXCBFmvnPLuiLB8i6+sxMt29rrMz4izp8Gvdwrm
	 vXNAxztKKB8E24738HK+TeNx2hx036YGrb5GeYyU=
Message-ID: <1ab7e5c2-a492-4980-a50b-57c431b9d4e7@arm.com>
Date: Tue, 6 Oct 2026 17:14:27 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 11/23] KVM: arm64: Add VM specific callback for S2 MMU
 operations
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-12-suzuki.poulose@arm.com>
 <87a4or2nd5.wl-maz@kernel.org> <089e57c8-93ee-4384-a6d6-978bde917650@arm.com>
In-Reply-To: <089e57c8-93ee-4384-a6d6-978bde917650@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06/10/2026 11:36, Suzuki K Poulose wrote:
> On 06/10/2026 10:24, Marc Zyngier wrote:
>> On Mon, 05 Oct 2026 10:07:42 +0100,
>> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>>
>>> Add VM type specific S2 MMU operation backends which can be 
>>> initialized per
>>> VM flavor, to keep the handling cleaner.
>>>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> ---
>>> Change since v21:
>>>   - Define all vm_s2_ops call back. All calls are mandatory.
>>>   - Define callback for each flavor, disjointing the non-protetcted 
>>> pKVM and
>>>     normal KVM (VHE & nVHE) and remove the KVM_PGT_FN() hacks.
>>
>> It is a bit annoying that we still have part of the operations being
>> indirected by kvm_vm_s2_ops, and others by KVM_PGT_FN(), which is
>> still there. I was hoping that we'd have only one indirection. after
>> this patch.
> 
> I agree and I did think about it. The issue is, some of these calls are
> deep burried from the higher leve dispatcher callbacks (e.g.,
> user_mem_abort->kvm_pgtable_stage2_map). We could go all in and remove
> all of them if you are happy with that change. Also, some of the call
> paths aren't valid for certain VM types, that adds quite a lot of dummy
> callbacks (now that they all are mandatory. e.g., pVM or Realms).
> 

For the record, as discussed, there are callbacks that don't have a kvm
instance available, e.g. kvm_pgtable_stage2_free_unlinked() where we
only have a page and level. Further abstractions will be explored in a
future series.

Suzuki

> 
> Cheers
> Suzuki
> 
>>
>>     M.
>>
> 

