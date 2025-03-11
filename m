Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D3478F5D;
	Tue, 11 Mar 2025 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741717333; cv=none; b=fE7+J2ZHvVX+8dbNxQD9qigeMnSTheARK3LrNpTNHG6ZwIHCvUkIbimwePuyvAQwH44mvW4Mn77EKOFh/oIAna1Tw1SwDL/pVH/ggq9g7wqdlI3Ka9rNgX90q1hlIi0Yc2oQCaQQtFUEguN0Qao8EoNZ8IJHQktPWCcZFmh9xHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741717333; c=relaxed/simple;
	bh=twBnHx5MxmQiJsuf5M4X8oH5jsM0d98je1kAJCezQRc=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=V4ezzyUpAg/aQTbq9/YybkrRx40JHfh+sUSSfhIEI/z+yh+Rkr2481L0s6chS5gxphhMiywhrrthwla1tBWD3u5bVZCDZ4EY4lgPFdVUW+5NbrcipnMwKIiat8PaY8Y/fiBRasdvWyPwXitKkC6zYdG9cSS7XKh3ijDXlTQZUs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aiSdc+/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aiSdc+/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A4AC4CEE9;
	Tue, 11 Mar 2025 18:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741717333;
	bh=twBnHx5MxmQiJsuf5M4X8oH5jsM0d98je1kAJCezQRc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aiSdc+/unKajtealI06ykugefgVZcMCiFo47wIxDcaoT17jRxCFqaSQxZpmcVtR7U
	 9hXlu6BKOnmmFAqgNaD0dzPhdyNZa3pZk3XMHk8Rw6iyjN7Ru0XKoa2Ic2MV8I2aOK
	 q31II4o92W4aBpvDg4xVZ3w7M+cm/F8q2tSAbJnAFbA3q5H2TFbYeDP1LbNbkvqNsc
	 TwQQbEfpemoj2ec04SeAvuKvNlAOPZjTsUqqgzjBLruVHMdchJMvcx/4/JPmSxbWgu
	 21uWULjuZJ2LgEM6qlL4xQzkYb7mnjt2Qvh0kZx7c2433MH0hjhLDX+c/vF17VA/mH
	 78wY9P7AXwDEA==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ts4F0-00CeC6-Ni;
	Tue, 11 Mar 2025 18:22:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 11 Mar 2025 18:22:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Anshuman Khandual
 <anshuman.khandual@arm.com>, arm-kernel@lists.infradead.org, James Morse
 <james.morse@arm.com>, Will Deacon <will@kernel.org>, Ard Biesheuvel
 <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland
 <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/8] KVM: arm64: ptdump: Test PMD_TYPE_MASK for block
 mapping
In-Reply-To: <Z9B8lyYEtL62ZzVb@arm.com>
References: <20250221044227.1145393-1-anshuman.khandual@arm.com>
 <20250221044227.1145393-2-anshuman.khandual@arm.com>
 <Z9B8lyYEtL62ZzVb@arm.com>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <43e4dd905ebc6424511bd230ceb47ac1@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, oliver.upton@linux.dev, anshuman.khandual@arm.com, arm-kernel@lists.infradead.org, james.morse@arm.com, will@kernel.org, ardb@kernel.org, ryan.roberts@arm.com, mark.rutland@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2025-03-11 18:10, Catalin Marinas wrote:
> On Fri, Feb 21, 2025 at 10:12:20AM +0530, Anshuman Khandual wrote:
>> Test given page table entries against PMD_TYPE_SECT on PMD_TYPE_MASK 
>> mask
>> bits for identifying block mappings in stage 2 page tables.
>> 
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.linux.dev
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/kvm/ptdump.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
>> index e4a342e903e2..098416d7e5c2 100644
>> --- a/arch/arm64/kvm/ptdump.c
>> +++ b/arch/arm64/kvm/ptdump.c
>> @@ -52,8 +52,8 @@ static const struct ptdump_prot_bits 
>> stage2_pte_bits[] = {
>>  		.set	= "AF",
>>  		.clear	= "  ",
>>  	}, {
>> -		.mask	= PTE_TABLE_BIT | PTE_VALID,
>> -		.val	= PTE_VALID,
>> +		.mask	= PMD_TYPE_MASK,
>> +		.val	= PMD_TYPE_SECT,
>>  		.set	= "BLK",
>>  		.clear	= "   ",
>>  	},
> 
> Marc, Oliver - are you ok with this patch going in through the arm64
> tree?

Yup, looks OK to me.

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
