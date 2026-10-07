Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E3447F793;
	Wed,  7 Oct 2026 13:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378681; cv=none; b=f5az2Gcq+oWQjfC0E/HuKK0P6Z//VPxAiWXwf2Utb2x0dj4Ol6TM1PVMrkwi9bOtYx9UOwqtYqTAk8CCgKLU+Rbr/DKFLyjujekei4BpyBRrJOTXUVHXeXDjCicCNmhd8zd7/5CAHVFqLCevgG2uey5LOAyNO8tjkhgqfFQp95g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378681; c=relaxed/simple;
	bh=aQPC+Yw1LXnFEbwa2Z4tr5U+8DNSNTgby5HUOWLpEkQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AR3GDh3QtrOmwOzon8ibKwVzdJeMgtgJ+JsmabZgB81uMnlkgrIubnfpYEH4w34P2/QThDLE/XSoEVfX6KcHWOOSau9lh4w4Z3pXIwdWxjp6vMrFC7fUUI9wcLm7vtR0fxfOQzk/xfSBqZGjHHDE3JPOanDQixhmlQ+q+AAfXQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=U9sRHUeu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="U9sRHUeu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A2031595;
	Wed,  7 Oct 2026 06:11:01 -0700 (PDT)
Received: from [10.57.10.153] (unknown [10.57.10.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9716E3F66F;
	Wed,  7 Oct 2026 06:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791378664; bh=aQPC+Yw1LXnFEbwa2Z4tr5U+8DNSNTgby5HUOWLpEkQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U9sRHUeuLEhsrHnA+pCnGFP1F7eIFMBxSK4cMcQ48GUMGIU9jmj9OMP/kbwdDtvgD
	 yX/7zMMyJMhwsw5oP8/tPZ4nnTt7cg2CobLtBcpJDqTc9DE6ehnevr3pGfCT/6m1ab
	 T3SxDxXmEdhUeQFi7n2OIlMVc1ZRyxiihQX95zbI=
Message-ID: <f88b3cf5-8312-453a-bbf6-c5cc3e5ac119@arm.com>
Date: Wed, 7 Oct 2026 15:10:58 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 02/14] KVM: arm64: Disable Steal time accounting for
 protected guests
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
 <20261007073537.2454351-3-suzuki.poulose@arm.com>
 <CA+EHjTyb3-QoLa6P-dGXVdMh9E_vO3p8HceH3TH8h8gPJSd1Kw@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTyb3-QoLa6P-dGXVdMh9E_vO3p8HceH3TH8h8gPJSd1Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/10/2026 11:51, Fuad Tabba wrote:
> On Wed, 7 Oct 2026 at 09:35, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take into
>> account the kvm instance. Even with that, a VMM could skip the CAP check
>> and proceed to configure the PVTIME as we don't do further check on the
>> DEVICE_CTRL. Tighten this up by passing the KVM instance around wherever
>> possible and catch things early.
>>
>> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Someone beat you to it. This is already in kvmarm/next as a5b0f36a045e :)

Thats fine, thanks for the pointer.

Cheers
Suzuki

> 
> Cheers,
> /fuad

