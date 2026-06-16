Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD4C46AEFE
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 16:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626528; cv=pass; b=eM0OkTc8EmCNwyaXPyqCt+f/IwL9a8GgV6UHng76RW5rTXM8RGhh93QVSgxqFTFylTUTeKXRjqW0n9aiWGYauQ+dTylgYkwNYq4Ygz+kJeV6n9ViNPYqv8qAPZbPmByeAdIVemxc//uKivKnJKk2k4Q87rBvnVX4/2hWVmjB5l4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626528; c=relaxed/simple;
	bh=DDdeKaR8U8RPFe1zDZcNqCeadhs62T3BN0SHD5eW/GU=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dgVCJvFF5zbT+UY35DgxFbyJ29a5u+bkReAQ4b63azT2EMOmc2x4QinBXS8MorKk8bBb+cKtf3BKP6IyIGlVOhMWBa/jYbtB0jnY0DvIb6heQfsBxM/TFp9CclVOA7v/zQ/GZlckvcSrXygwh5FPNn5fVqT94ZSnZs+aZfJmCE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FYtj1l5t; arc=pass smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FYtj1l5t"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-307263ad0cbso7469992eec.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 09:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781626526; cv=none;
        d=google.com; s=arc-20240605;
        b=i7KH15beelPuP+QastUtaRR8TDOt65DY4vAuTMPD1PjimpdSQYex9jHV4eW7DozZoK
         28jXIYSkApd/IOM3GIo8EHMWdjkr7CYfQzi4E4yH87JUuKzgzPq2pRIuAYfWz3SoH6U0
         i7LCudG0vxvrvzoamCa88qSdwYcxW33eskzqJz8ooeBhfBG0s8R4Z17cgy21GDsh9Fpe
         io3EgXuHQVyrM8ysAgeg86KNKf8/VYHfD/TbXyzLiThy9a4MJpx4X1GEFFpYKaetNEIJ
         78Gswskg149lLjrmfwIukWXyS5oJi0PBrxdKYLsWGddZ0Pg1/JvSHX0POZ2KGgWfnffq
         cICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=KxrAh3gZox9w5915Zp8CYh2ybM8dKM0MmMGgcGgqfcQ=;
        fh=kFows0GG3seh/B0Guo30/EUNtTdrkIkTz6Jw+fs2xqM=;
        b=lh0Qf0uHjYmQ2Nsdo0LJGIhhebUpl0s49T2yQWN7oyYHUY3FqykyvZOZE/P3Bx6b64
         SNd5q7ZKVT1Gxi8RlFUNjbL4PEstiVk9CbKdVRDw22A02K0W9p876y7Ogj4Mt6z2al8s
         Q8M2PHIKTOH80lUIy42B2FYAcQdKhTLdpsQrQqZjo7hfRZun1QrxkqKHrQLwk2u8AuHG
         f8UNVWlWOO3lgKNHf2khCa8WnKybweoK4m027NKa8Hn4M+J+brW7t+ZKJw+GrjFWVylv
         gjfGhM+le45qgE736IHZUrQ6tYmV/pMZucxFcuvWoOCaJOlbohES72P0BbjZ6YhwkTZU
         dquA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781626526; x=1782231326; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KxrAh3gZox9w5915Zp8CYh2ybM8dKM0MmMGgcGgqfcQ=;
        b=FYtj1l5tpwyWRWwJMEJHWGFPeT0xjPUt4f8HJF1bwXgarN/CWQsNbxJP5KEr9TT3B9
         eMnjSsvO4n0R4xXqIuyr2m+9wXkPq9NFUNdjHbGZcLAaiKt/FsU+jwLh6xCBFeOZQHI0
         7jCnJ3T+Pq20K97+4MD3vIJqvC9yX0ON8cjebmGljux3sQYLMYMob3MAbyAhmq0t7iHi
         QfVrn0cunjrU3HXczApxHLQPyP81jfnrm6R61pMzex1I+DFk/MnqhG1nqBpi6u14zJOw
         wPwvWiXcN5W1fNusxT+bgbEBSsIpSk7fyCtrmAHaQrS9SRF7xYT5+0slIgvpzNhv8aMz
         dVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781626526; x=1782231326;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KxrAh3gZox9w5915Zp8CYh2ybM8dKM0MmMGgcGgqfcQ=;
        b=Bi+RDf3KHqUxijCFTUBS8jlKr0EkT2hvLYP9k8jwcovHEq0/a709zzzJwsPRyFSqxr
         5MHtU2eVJNEIgElSDqATah7H0gFqSWKirhOOUmW+3TCnoqu8eSZBtj2uDOihoetNRRcK
         zuoOJ4WmWXNAXNdAS8Cqwdg5rXnEBky0UMYtDYT3A9tJatzXqasA9lqXKzNKxQD8mYgc
         17g+eYS9HhMZB3eYYwlDlgFJ2OdaypusB/+Q9W3tf1SUEzGk3lERHWsLntwXNP+pobE6
         qyb8bsQoEUHjTgzeOWxevpJjnLMfZ4UzSyewPYAO091npmcsrYrlEz6Hk/VY51nItMzs
         5mTw==
X-Forwarded-Encrypted: i=1; AFNElJ9+6AWUQJbMpWivvFS9WbEbToUjwJWGQtGTE98x6iJLI7QtlwSDFF6BxaNFk+oOZEoD3BQHe9c=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTj1tv5EfVdTCwrUfr/ORcAyoq1Gj1ISxwbxyv6xuwnze+jVAN
	jBoDBERv7JeGXyoyNlulqtBID6CltqFpevGXiixuyMd/VeVofGYBOM51K0iOnX0IFR31RojSqBw
	swz7yvDUWtnr620M8hB9R9Rocy+qJeUKTDzQ2S2So
X-Gm-Gg: Acq92OF9svfl3e5yHsY+8HVPglu1fn2PF86wPxurXxilBZZE1CSUWVFWvAN7ZYBiIw3
	0mlrSce4CpEfz8HzWrKojELLzb5Lj/kPUBQqR/UL0OV4YYewnF79qLxJ6GpNAf3XV53GT/oMryO
	9njrvNSkWNQ1PyqAecNtuRiijqUuCDRNN836eh+kKB75lbXVIU9OICHLKLN1zNh5EAsAwT34xRe
	buI4jEiNhVjNY+4UnFSuqxC9z+c3H7GgqM6wLpcFVcCKDqlm8AwqqVoIcDKs9pWhF5DhCn6S2pB
	f1a2Txcw2n9kLj1MFJC99o/u0gUXHnqWiuugKXg5Ca23UdCyNGo+CM2tm5kGlRQPdNquTQ==
X-Received: by 2002:a05:7022:418:b0:137:fe07:8a2d with SMTP id
 a92af1059eb24-1386f24121cmr7479488c88.6.1781626525576; Tue, 16 Jun 2026
 09:15:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 09:15:24 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 09:15:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aiycmwMbhWuYghJh@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-2-vipinsh@google.com>
 <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>
 <aisHySKe0PwM5DSg@google.com> <CAEvNRgE-qt8DAjOeE5ANpXzrgEKs+2_wh4YSmY=pe6krngBXqQ@mail.gmail.com>
 <aitbveI2Sdx4s4BP@google.com> <CAEvNRgFLnGkqvvks3joAwPjqLz=ATmqiS0UWk71g+YEsxNsfsg@mail.gmail.com>
 <aiycmwMbhWuYghJh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 16 Jun 2026 09:15:24 -0700
X-Gm-Features: AVVi8CcVnuVCx19L_GWSZ2nltEautD7sT8OALv94LzUOkIdPu2pxUDWRobjVJhw
Message-ID: <CAEvNRgGkjcVN80W7cNd1-tEUXAfnFXEekokh_VbMDb9XdecVVQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] KVM: selftest: Create KVM selftest runner
To: Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jun 12, 2026, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>> > On Thu, Jun 11, 2026, Ackerley Tng wrote:
>> >> Sean Christopherson <seanjc@google.com> writes:
>> >>
>> >> > On Wed, Jun 10, 2026, Ackerley Tng wrote:
>> >> >> Vipin Sharma <vipinsh@google.com> writes:
>> >> >> My (future) use case is that with hugepages, I want to run something
>> >> >> like
>> >> >>
>> >> >>   ./guest_memfd_test --order=0
>> >> >>   ./guest_memfd_test --order=9
>> >> >>   ./guest_memfd_test --order=18
>> >> >>
>> >> >> And 0, 9 and 18 are the supported HugeTLB orders on the machine being
>> >> >> tested. I'd like to iterate over supported HugeTLB orders at runner
>> >> >> runtime instead of at build time.
>> >> >
>> >> > No.  The right way to handle this is to define testcases for the "interesting"
>> >> > sizes, and then rely on the test itself to SKIP if the size is unsupported.  This
>> >> > is no different than a test that requires EPT, or nested VMX, or nested SVM, etc.
>> >>
>> >> That should work too. So at build time I'd make it define all the
>> >> possible HugeTLB sizes on every arch, and then skip as necessary.
>> >
>> > Not necessarily at "build time", the testcases can also come from your local
>> > environment.
>> >
>> >> Why though, why not find the supported sizes at runtime?
>> >
>> > You can find the supported sizes at runtime, just not in the test runner.  I want
>> > the runner itself to be largely oblivious to what's its running.  Disallowing
>> > more or less _any_ test specific configuration/setup in the runner is the only
>> > way I see of keeping the runner strictly focused on running tests/testcases.
>>
>> The runner should 100% focus on running tests, I think it's hard for the
>> runner to avoid the process of test discovery though.
>>
>> The current test discovery process is to go down the tree of directories
>> and find files, 1 file == 1 testcase. Each file should (statically)
>> contain a single command.
>>
>> Since you're not opposed to runtime discovery of test cases, how about
>> something like:
>>
>>     if the test case file has executable permissions
>>         execute it and get back a list of test cases to be run.
>
> I don't hate it, but I still dislike the idea.  I am all in favor of runtime
> *discovery* of testcases, but I am staunchly opposed to runtime *definition* of
> testcases.
>
> If I define guest_memfd testcases for 4KiB, 2MiB, and 1GiB pages, but the
> underlying system only support 4KiB and 2MiB, then I want to see a SKIP for the
> 1GiB testcase.  If the definition is dynamic, then the 1GiB testcase simply won't
> exist.
>

Seeing the SKIP is a huge advantage over dynamic definition. Thanks for
explaining. Makes a lot of sense now to have everything defined statically.

>>     else
>>         read it as a single test case.
>>
>> I'd then use the executable version, check HugeTLB setup on the machine
>> under test and return bunch of separate commands to be run (each with a
>> different HugeTLB size).
>>
>> The runner still doesn't need to deal test-specific config, that's part
>> of the executable that tells the runner what to run.
