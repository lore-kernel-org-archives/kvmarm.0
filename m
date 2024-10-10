Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127619F430;
	Thu, 10 Oct 2024 08:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728547960; cv=none; b=iHg1j+wIMoIW8eqj+gfJlUKPY8d3xAky85CPpYK5vQk1rZZwvw0tMU5lk7nGKy4FVhwl6wluhdslpVa/F/Y4NuUmFzOiyLpbeqbdOV1EGCVMg3JemYgAzA0RwqIhft+JDFKdork80sccTWMlRO/dCzPCkn3Fhxs3lWpQuPc47Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728547960; c=relaxed/simple;
	bh=RTVS/u/ErF8mhoG7gJZHkNjXnKzucP5XhkEC+vLSzYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TaIFxvE4Kh7EFe5MRcC2sQNHi9seNja+N7L4v07RKb707FaNlf6R/9fOe3+RvixIK943VZd/AnP7+pHTUilx1u5yMMIGv8kdlwWqMUotbMabdcocacALJdwIEphUewTK2pw28GJMxH6VSuB+02xKWvjy54KlqesLZtjhwzKiADY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=OsOOey/d; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="OsOOey/d"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728547954; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rSnUTJJgQiFQvK3VVOuqy3cV5F5MMcsoT+LmuvIhT0I=;
	b=OsOOey/d7KUwCi6U/SZU71ixXU6SFdvzYkWBywaZ+Aitke9lkhyVtjh42o4LsOKnbrBVnx98YIocvHSQKYkgx9ZKYh45Iiu3OHm3MtY3/y9s60LcamojQ+8uvRgaFM/24LwYPQLTNgxIli3UWIjrrF9Gnc08aJXDFHLxqXRarEo=
Received: from 30.246.177.51(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0WGljzdQ_1728547950 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Oct 2024 16:12:31 +0800
Message-ID: <b3c21234-73a0-43dd-8365-9039c62b7aa7@linux.alibaba.com>
Date: Thu, 10 Oct 2024 16:12:29 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nVHE: gen-hyprel: Silent build warnings
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20241009085751.35976-1-tianjia.zhang@linux.alibaba.com>
 <86set55yca.wl-maz@kernel.org>
From: "tianjia.zhang" <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <86set55yca.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/9/24 7:07 PM, Marc Zyngier wrote:
> On Wed, 09 Oct 2024 09:57:51 +0100,
> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
>>
>> This patch silent the some mismatch format build warnings
>> with clang, like:
>>
>>    arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:233:2: warning: format specifies
>>    type 'unsigned long' but the argument has type 'Elf64_Off'
>>    (aka 'unsigned long long') [-Wformat]
>>      233 |         assert_ne(off, 0UL, "%lu");
>>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
>>          |                              %llu
>>    arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:193:34: note: expanded from macro 'assert_ne'
>>      193 | #define assert_ne(lhs, rhs, fmt)        assert_op(lhs, rhs, fmt, !=)
>>          |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>    arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:188:19: note: expanded from macro 'assert_op'
>>      187 |                                 " failed (lhs=" fmt ", rhs=" fmt        \
>>          |                                                 ~~~
>>      188 |                                 ", line=%d)", _lhs, _rhs, __LINE__);    \
>>          |                                               ^~~~
>>    arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:167:17: note: expanded from macro 'fatal_error'
>>      166 |                 fprintf(stderr, "error: %s: " fmt "\n",                 \
>>          |                                               ~~~
>>      167 |                         elf.path, ## __VA_ARGS__);                      \
>>          |                                      ^~~~~~~~~~~
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> I don't see these warnings. What version of LLVM are you using?
> 

I compiled the kernel on Apple Silicon M3 Pro in macOS 15.0.1, Maybe this is
a special scenario that is rarely used.

Details of clang:

     # clang --version
     Homebrew clang version 19.1.1
     Target: arm64-apple-darwin24.0.0
     Thread model: posix
     InstalledDir: /opt/homebrew/Cellar/llvm/19.1.1/bin

Cheers,
Tianjia

