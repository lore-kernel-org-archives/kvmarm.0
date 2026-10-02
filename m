Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5ED546EC86;
	Fri,  2 Oct 2026 09:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790933803; cv=none; b=ULIEsguY/Wh/zJDNq8VHA15nWxfgkSt7EbQ4lmhiz7YR7/QceyCewQ4eKAP4vCs8OP9EjBI9h77MHculA4/dfDt1QOncgJaYS6joPBR2GQ+4fNzJvl4CJU7T+oG37mMCRkgTC27Rrk8QSlRteDkWR/bsArZ5JOMVaqBO4dLb+fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790933803; c=relaxed/simple;
	bh=m6d1llwAmb/6rvyw6Fa3xaMJy1jmVRx3TAvoRSX48u4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GHJwg/UQUtas7PIxwKNgvPFc3yeabNRn1BBWRN5PEEmelgYP2S15bWS+fn9QWClt/W3OllYPxam8c3ke65Ag4kHpyfQjofL96HegKE/HJp4J4cccAhEjooYmdWzx2pcC7amx1TPiFgGuUYDaB5TKE/6yI8czzTdrtG5Wa+53Yps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S3JF48p0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S3JF48p0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99409497;
	Fri,  2 Oct 2026 02:36:37 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C3A43F86F;
	Fri,  2 Oct 2026 02:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790933801; bh=m6d1llwAmb/6rvyw6Fa3xaMJy1jmVRx3TAvoRSX48u4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S3JF48p0f8QJMV6r1pz19sdCCW4wn/aoQsLCt+GMjkj9L4mlxGoCI+0AHLYhunlPo
	 rktjKpOWNSjJGwMDb+CICRkSDYpuY8WgMA6POjYnD3/Glk3ZDfFYVcM3EMylfzXzGN
	 H1q3B8QEf/oy491jjkpob+aHb5iGVWUm3x9/WKQU=
Message-ID: <7c0846df-97ff-4461-98fc-7d094c91ba29@arm.com>
Date: Fri, 2 Oct 2026 10:36:34 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 18/23] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-19-suzuki.poulose@arm.com>
 <CA+EHjTyyKxW2TT9XpjSDkdjWEuGyWmA_isDpOnoyri8ikxZN4A@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTyyKxW2TT9XpjSDkdjWEuGyWmA_isDpOnoyri8ikxZN4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 10:34, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Thu, 01 Oct 2026 22:06:58 +0100, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
> [...]
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> [...]
>> +static inline bool kvm_vm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
> [...]
>> +       r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
>> +       if (WARN_ON_ONCE(r < 0))
>> +               return false;
> 
> The fix [1] is in -rc5, so a rebase conflicts here. Please make sure
> to carry it into this copy, i.e., a plain "if (r < 0)".


> 
> With that:
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks Fuad, like I mentioned, I have flagged this with Marc and he was 
happy to fix as part of the conflict resolution.

Suzuki

> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20260914093838.1082637-1-fuad.tabba@linux.dev/

