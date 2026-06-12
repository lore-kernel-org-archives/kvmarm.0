Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135F139B960
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293518; cv=pass; b=jI0B45H5gWomaeZQN2vhXySbaQ7nWllNvh4nIbuj3pvAvrAqaZxOpeujcjv0ZI8OeTEiIqbdyhjcgOwJZae9xuuhEal3SQzFDjTtBn49lqofZkv+9l2SgFLfRFjeytN6IpUvt1PG4weXNuNvGtjryxvgZyqzpb3rmizzaFvmHmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293518; c=relaxed/simple;
	bh=7xDJxVjDk42Anpf5nFQLtzEUpQ3ex9C8K+TDkB8oE+w=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nBkz8hDAX4gwfpCPFtGYjwOnVONgW7F6aZdwuz6/BuLD3aMmRduj+RTGHBMcG5QHWMxXJwx0O+jmCHx2sMkJGB+CefnYzI6SFMkNOTvTU3HW993/mlOnudpLrGdgYNbaIoVDbZWtIC+77/RyJrvdTw7KsCrJ8RUc0lIkENNcMd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l1Cevs5g; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l1Cevs5g"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-138129a622dso2576890c88.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:45:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781293515; cv=none;
        d=google.com; s=arc-20240605;
        b=Kqtk1vIQ3CylzMnOrsgDiZoqPwpyw84Yd5u2SQn7wN6E8V/1BixJ/QET6jR+oaCLhy
         wVV+o704X7DNmSquE0LAVgO0lc4UHg+oMQIxqXPfEcsz8LaTM7PMyLn/PW6lz1T8RD2r
         wR1LT/jWqk2cfWKX37F8FZK0kFW9W/bEZ3kkZ3IXR3gKtbaavjeSIC2oRIgtMYIQL4eC
         tv8ICMbkiiNwgYjXVaIKP3LYAUQa2q/osuYi5wRqGeEud84nU+1UtRutJ+StUAyJ0hKK
         IsSUIiKzv4BS/il0P61T0q15rWL+NXM6RRm/99G5ulrLEdxg9TLUe9J72bhP3VzFO4AV
         7acg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=aLJTxmN0M9ZPVQW0kpELnacC0gVuFIrIwjygErMroM4=;
        fh=MVl6UPhPODUjfwiWHByjv1fIWJKOKwbdk582bdzIaiU=;
        b=NRHlyUCNdja30R11m3jtpVNJWabmPTHRG0hak7frFe4USMdlZcmyUKIbIv84zjJWVk
         /0evcnv+ljfNoA3YZcoQgYSnOwq5x0hAP4fAAQFf2UN39rP7WPnxMQ0fet//8gmyPq5H
         MWMn6e5UXteYMm+gFN0U5yx4RPj8EL01F6xA4YNMZ8745tul6P9kQjqvXGzX2u5BxtqM
         0bwNrEab1DgTZSAIyPGCsBgFM1FUGUCFOTTxQx0D4hq2lkXdj/2IQCJB78FMMwCiVLLz
         dvX/JA/WVPtIwIYbm9SjHjX1hLZqvilYavEX3Fekm4XUPLnoCx31JHjPewyy66xhe3dl
         6vKw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781293515; x=1781898315; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=aLJTxmN0M9ZPVQW0kpELnacC0gVuFIrIwjygErMroM4=;
        b=l1Cevs5gu1lVXcpaxpL1Ror9hUxCkXAyMzL7ex3v4tA2EkRkOXNzHObkWkA7Tm9o2T
         3JYIrvifFc5nqW+r9FqDPBdK1+UzUZFyCcZP18HITRu/a7guOVoujU4/y5hMLB9ltGSr
         G0aULefzjA/t1taAPoZJg0LfNZBtIBxGme5uUAyKENvOb9lqUX3sAdK+8tYxuo4jLGdN
         3PoMitBsgccOgByO0KquQmQZRCxutdSkuB5c4OK+EfwS0Lhuo49FPBNcA4B1lM4cUMUW
         8ooQQGLGuForkJ9Bia9ekrs34LL/s8wwxFs4qtztM5GpL2urpu3OHpcglhb+C9YpTlo3
         I38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293515; x=1781898315;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aLJTxmN0M9ZPVQW0kpELnacC0gVuFIrIwjygErMroM4=;
        b=g5+cC+Ma5H/PIqgt9CT8cDlpSXYEPM41E/qeBnBxubDC7w1kgVsFUh4tQXtilq7kh0
         ypnXZ9sz9pChpetTuxAEUgVFYAMAeIugFYR8XtFTd8iqy9ysPgZB54x5jQmA6gWk0I6j
         B3lkc3ADEBtp0uBXLjMAbTpRlImWteelw389V2JxbyLfbU+dhohMfK8PXN1zPW+wKvZ1
         XJYVCDeF0pksulsMqabtRxwo5y+ySThljg0F0lB6wkch+/j4OIEyTQt7LhyHJ8ziZi1s
         ZuJBjDQ4SMYO9FXfYVcJuex8EnB4M2uIsLXJ0FYHr1zQm4YRk5nA1l4Tevnc+CiJmV6P
         30Og==
X-Forwarded-Encrypted: i=1; AFNElJ/sQFrvasDdGREWluk31WfshwpejcgP9lMlVREfZU5bJWQlm0zDcn16eYq05u3xMDXlhMyWWE4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIg0pnPKtpzfSoDQKvS1QEySuczYqPEQP5zqHjtLNjtprVhuhM
	0qJlDdF/T9ks4ofwwHyvLfIudRY9vU+/UET6UTXvlYTlLH2VCFh+HSOaYfRukRIGoFXysM6EJ7R
	eDZBKQVw0sI8oqFQmQf1JfBSHyU3unee9P0fRSNmc
X-Gm-Gg: Acq92OHez4Z/ay7i8KPZAv1HJ7Lc732bun0lE781wwW8tUfgcjdZVSOs7ts6MBlUGCc
	YwHrWa8nfeTDSJSs+hpSyV/wDF849Uitn1eCG+CShjt3iXELGRXir+3fFVEemo+LjQ74SHKgNOA
	mxHn0ltgg9ErYCH54rfRp/TfOaMhR9uWDfTzWXMVVUs3bs2iQdoxQDnQx6NkIX53oXqYRqcjvaO
	+5CJ07WD4DmVExlIbTcndl8SLm8eFg2q0QulX0RL0p2QbAe452NHct3KuocTEuGgB3NDcWVN/Wt
	Xe5WfAmB+d4kRqaGyBdQrg+G497fSWbs060LOFKMSaNoZ6z13p484ZODLhCQUCGi3KRCgg==
X-Received: by 2002:a05:7022:621:b0:138:4fb:f284 with SMTP id
 a92af1059eb24-1384bb38d6fmr1989806c88.15.1781293514036; Fri, 12 Jun 2026
 12:45:14 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 12 Jun 2026 12:45:13 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 12 Jun 2026 12:45:13 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aitbveI2Sdx4s4BP@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-2-vipinsh@google.com>
 <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>
 <aisHySKe0PwM5DSg@google.com> <CAEvNRgE-qt8DAjOeE5ANpXzrgEKs+2_wh4YSmY=pe6krngBXqQ@mail.gmail.com>
 <aitbveI2Sdx4s4BP@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 12 Jun 2026 12:45:13 -0700
X-Gm-Features: AVVi8Cca4ehyVmpS233WMcTKmiImcVUcWDNZomRwvPGwAtUbK8L6EJTEUMvzdMg
Message-ID: <CAEvNRgFLnGkqvvks3joAwPjqLz=ATmqiS0UWk71g+YEsxNsfsg@mail.gmail.com>
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

> On Thu, Jun 11, 2026, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>> > On Wed, Jun 10, 2026, Ackerley Tng wrote:
>> >> Vipin Sharma <vipinsh@google.com> writes:
>> >> My (future) use case is that with hugepages, I want to run something
>> >> like
>> >>
>> >>   ./guest_memfd_test --order=0
>> >>   ./guest_memfd_test --order=9
>> >>   ./guest_memfd_test --order=18
>> >>
>> >> And 0, 9 and 18 are the supported HugeTLB orders on the machine being
>> >> tested. I'd like to iterate over supported HugeTLB orders at runner
>> >> runtime instead of at build time.
>> >
>> > No.  The right way to handle this is to define testcases for the "interesting"
>> > sizes, and then rely on the test itself to SKIP if the size is unsupported.  This
>> > is no different than a test that requires EPT, or nested VMX, or nested SVM, etc.
>>
>> That should work too. So at build time I'd make it define all the
>> possible HugeTLB sizes on every arch, and then skip as necessary.
>
> Not necessarily at "build time", the testcases can also come from your local
> environment.
>
>> Why though, why not find the supported sizes at runtime?
>
> You can find the supported sizes at runtime, just not in the test runner.  I want
> the runner itself to be largely oblivious to what's its running.  Disallowing
> more or less _any_ test specific configuration/setup in the runner is the only
> way I see of keeping the runner strictly focused on running tests/testcases.

The runner should 100% focus on running tests, I think it's hard for the
runner to avoid the process of test discovery though.

The current test discovery process is to go down the tree of directories
and find files, 1 file == 1 testcase. Each file should (statically)
contain a single command.

Since you're not opposed to runtime discovery of test cases, how about
something like:

    if the test case file has executable permissions
        execute it and get back a list of test cases to be run.
    else
        read it as a single test case.

I'd then use the executable version, check HugeTLB setup on the machine
under test and return bunch of separate commands to be run (each with a
different HugeTLB size).

The runner still doesn't need to deal test-specific config, that's part
of the executable that tells the runner what to run.
