Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E27332907
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787578704; cv=none; b=pxPuoDntozDG+TKxlf91fQgtnxFfEHY8dWwB8fRiOeC+0B8YG7cl2+NBO+QsU+AIvJIUBjeR2MTq4LIWXgTrs2Vb75o1JLXkP5Jr8YUmfdqR9CPm0NpgEt+GNjmHzG2dofsxUWG00TXHrI4gs5etvDNmLKBGN56qcL8heqlNetU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787578704; c=relaxed/simple;
	bh=GYHYebrAL0+TRGK1g/XM7dg2jWMltwNxv4cPMxYybAM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Xai/AGeMZxUzEl7gyf7zPXvCqZOFxtyhnlDkIh+28TPpVE7KFJFVfpiUwcCzePosxEUlGQCrQCkfvagpveHr9AKMItdKFYUXGrRYGyNNTvNs0v3wl0rYxGXNH8Qz67qFpLxphuY8wkrGNU6tEQdGB3fG125iKye40j0ydDc+Ays=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RWUiqeLt; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RWUiqeLt"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FC9116F2;
	Mon, 24 Aug 2026 06:38:17 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1E2E3F7D8;
	Mon, 24 Aug 2026 06:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787578701; bh=GYHYebrAL0+TRGK1g/XM7dg2jWMltwNxv4cPMxYybAM=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=RWUiqeLt7NX7jbsLD82QYFKmXgk2WxNgYjzJ3ekuCXsrhEXDkcW+uYrXfIfvQxHq7
	 2U+0v99DzGABm3HSj5KMTL6yM9MrCnAEVnkpTGTR/WYkC6h9JmJuF1FVw+fgGBOV57
	 0iTGwq0s0qiaXaxLuMA0MmLt4wRf+rXHS5zxmH7Q=
Message-ID: <67ab6c51-4511-46ab-931b-a4323551147a@arm.com>
Date: Mon, 24 Aug 2026 14:38:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH] arm64: clear_page[s] using memset
To: Linus Walleij <linusw@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20260306-aarch64-clear-pages-c-v1-1-77c1bb0f1c21@kernel.org>
 <ac7YJPo4Np2zxxEp@arm.com>
 <CAD++jL=G81=ueo7djqUETToE459kpFGniWvBwnYbJtmXrm8MFw@mail.gmail.com>
 <adULAT2xus5z3HdQ@arm.com>
 <CAD++jLmMxj1C7sGz-Yt8Y+NC1CbrUTTSH4QvcZfYuJAcNoYYCQ@mail.gmail.com>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <CAD++jLmMxj1C7sGz-Yt8Y+NC1CbrUTTSH4QvcZfYuJAcNoYYCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 08/04/2026 8:47 am, Linus Walleij wrote:
> On Tue, Apr 7, 2026 at 3:47 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>> On Tue, Apr 07, 2026 at 11:25:55AM +0200, Linus Walleij wrote:
>>> Quoting my own commit message hehe:
>>>
>>>> No performance regressions can be seen, the fastpath
>>>> benchmarks differences are in the noise.
>>>
>>> This was tested on hardware with Ryan Robert's fastpath tool.
>>
>> BTW, have you tried the perf bench mmap test again with the new
>> clear_page? Both with single page and multiple pages scenarios. And
>> ideally on more than one platform.
>>
>> Will pointed out (in a private chat) that current clear_page() uses
>> non-temporal stores while memset() doesn't. It may not make any
>> difference in practice but it would be good to have some numbers.
> 
> Hm interesting point, the perf bench mmap test isn't specifically
> in fastpath but since it tends to come up I guess we can add it?
> 
> Ryan: is it easy to add this test to fastpath? Or easy for me to do
> myself? I looked at the instructions but they were a bit intimidating...
> 
> The test is the following:
> 
>     We boot the kernel with cmdline like this:
>     "default_hugepagesz=1G hugepagesz=1G hugepages=32" to make sure
>     we have ample hugepages. This was then tested with the same
>     cmdline as the original series:
> 
>     perf bench mem mmap -p 1GB -f demand -s 32GB -l 5
> 
>     The first run was discarded as the memory hierarchy is cold on
>     the first run. Then I ran the above command 5 times and averaged
>     the throughput

I've ran tests for with 1 warmup and 3 repeats in 4 sessions (12 times). 

Results for SUT Class aws-m7g.metal:
╭─────────────┬────────────────────────────────────────────────┬───────────────────────────────────────────────┬───────────────────────────────────────────╮
│ Benchmark   │ Result Class                                   │   next-20260821 without this patch (base)     │   next-20260821 with this patch           │
├─────────────┼────────────────────────────────────────────────┼───────────────────────────────────────────────┼───────────────────────────────────────────┤
│ perf/mem    │ memset -k 1GB -f default -s 16GB (bytes/sec)   │                                63932542232.12 │                                     1.92% │
│             │ mmap -p 1GB -f demand -s 32GB -l 5 (bytes/sec) │                                63272579168.03 │                                    -0.57% │
│             │ mmap -p 4KB -f demand -s 32GB -l 5 (bytes/sec) │                                49692830849.48 │                                    -1.11% │
╰─────────────┴────────────────────────────────────────────────┴───────────────────────────────────────────────┴───────────────────────────────────────────╯

Results for SUT Class cesw-aarch64-ampereone-1s-a192-32x:
╭─────────────┬────────────────────────────────────────────────┬───────────────────────────────────────────────┬───────────────────────────────────────────╮
│ Benchmark   │ Result Class                                   │   next-20260821 without this patch (base)     │   next-20260821 with this patch           │
├─────────────┼────────────────────────────────────────────────┼───────────────────────────────────────────────┼───────────────────────────────────────────┤
│ perf/mem    │ memset -k 1GB -f default -s 16GB (bytes/sec)   │                                33895562998.71 │                                     0.25% │
│             │ mmap -p 1GB -f demand -s 32GB -l 5 (bytes/sec) │                                34338454210.17 │                                     1.16% │
│             │ mmap -p 4KB -f demand -s 32GB -l 5 (bytes/sec) │                                25687107580.90 │                                    -0.85% │
╰─────────────┴────────────────────────────────────────────────┴───────────────────────────────────────────────┴───────────────────────────────────────────╯


> 
> The x86 commit cb431accb36e51b64ce34b5cc4d5ed292895fd84
> also mentions this test:
> 
> perf bench mem memset -k 1GB -f default -s 16GB
> 
> I tried it on QEMU, no real benefits with either the previous or this
> patch, and no regressions either. (x86 passes -f x86-64-stosq
> which are some optimized memset instructions)
> 
> Yours,
> Linus Walleij
> 

Thanks,
Usama

