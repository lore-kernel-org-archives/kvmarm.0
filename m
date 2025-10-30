Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504BB2BAF7
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761816988; cv=none; b=gjE5dDVQd3Le8MaeIMXKpRuYn6zVnswYn/ihCaxCK1guwLIQUffCXi26ydYQpaVnt2eIn1nG/C0tXgO9JZ7PLf6eUh1IgDepmYJuoxQoyOhOo6UXh1adn5QgKSfAFuoAfFqwS/hltDNnNLiULlGnZKisZURVphDyzqaGVo0PI0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761816988; c=relaxed/simple;
	bh=eld9SwythHyRpoVupK6ef+WDAEJyHPguSsQDrZISNXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QAvLDPiwwMtFInfqmP9c0TgKmGF22ovtszj8TwSFwl6N/o5FZ/sHr11GyqWNt0nnrTc4eSP5jku31shy9GAzpr4oLzHot2rbnYdG9c6EuyhL0nh1hCcVsm53RBV21hiGiB6OrRY0eQUtBJ8ALjzsxUKwagoo76/aYdFR7ORVs1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33C401063;
	Thu, 30 Oct 2025 02:36:11 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEE643F63F;
	Thu, 30 Oct 2025 02:36:17 -0700 (PDT)
Message-ID: <5ab27dd7-a24c-4927-891d-15359283561c@arm.com>
Date: Thu, 30 Oct 2025 09:36:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] KVM: arm64: selftests: Count test_guest_reg_read() as
 a test
To: Oliver Upton <oliver.upton@linux.dev>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 shuah@kernel.org
References: <20251014102108.2442391-1-ben.horgan@arm.com>
 <20251014102108.2442391-2-ben.horgan@arm.com> <aQJ9mC5_j6HQ_jbg@linux.dev>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aQJ9mC5_j6HQ_jbg@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 10/29/25 20:48, Oliver Upton wrote:
> On Tue, Oct 14, 2025 at 11:21:06AM +0100, Ben Horgan wrote:
>> The test test_guest_reg_read() is run without announcing its presence or
>> contributing to the test count. Rectify this.
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
>> index 5e24f77868b5..6878ee23310e 100644
>> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
>> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
>> @@ -655,6 +655,8 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
>>  			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
>>  		}
>>  	}
>> +
>> +	ksft_test_result_pass("%s\n", __func__);
>>  }
>>  
>>  /* Politely lifted from arch/arm64/include/asm/cache.h */
>> @@ -786,7 +788,7 @@ int main(void)
>>  
>>  	ksft_print_header();
>>  
>> -	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
>> +	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
> 
> TBH, I'd actually be in favor of a patch that removes usage of the
> ksft_* harness from this test altogether. I don't think it adds much and
> we use the KVM-specific test assertions anyway.

I'll give this a go for a respin unless anyone pipes up to say the
ksft_* usage in this test is helpful for them.

> 
> Thanks,
> Oliver

-- 
Thanks,

Ben

