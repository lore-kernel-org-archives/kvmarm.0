Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06491E1DF0
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 01:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781140653; cv=pass; b=T3y66s27T8c+YvxK6qm7SyJKrOToURcsymtUfQO3wR43/czc45czvgsu6/UWw8w3k7tqgDiWofk+nkvBfYd14JKS6tBjGrVe5chzsOWZX6CCUJey7/XbguZz1j9RyaA6gSqzt9R/w9r6fd/LhbYbsSnZaBicYZ3uz7Su2Vv+Jj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781140653; c=relaxed/simple;
	bh=Z8T+WqfW8gPngsoZIlqphQxVNZn8CAVdkbOPghqY/9w=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWKSk6O1r8Pyjs0IkoXAeDTm18zU4pPoabpd8tqSx1EoYmjkibvxGxUB6fJWxG9noG68W+3zunOgWEOdydm0jPBPLgNGmGdMIyh1PUxrYyIejqd3342UURBLYrmTCiUDv/mcApH3y8JqQ+ixLgc5Qk2ceJVdV7m3KPfMIveO3r4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BghvB0H3; arc=pass smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BghvB0H3"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-13721dfd471so9612665c88.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 18:17:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781140651; cv=none;
        d=google.com; s=arc-20240605;
        b=IYPJzDPtuGP2LWGEL7DC7G+jJ1zADrzKLDC55VDqsiTvwAlSHZ2Pgv7gcnXdhiIn+f
         +7bkI2Qqgs3UBnGDv9gtGEijztZylOQesHdwRi1YXRm/YcqQSH9nD/4gKDxO6ub+Mx5q
         UqlvYplCvbX47LpiKn/MmLH6BfYTTMSUy6R/ruJZSIypwVmT+FxpWlSqAvjd2F13MP0l
         vKy/56CgnzVU9Z9H0LCfmKcLyoohdN/79E4RJ8f59ESdf4VcLrINoTzk1Hpi2fQSg5Xd
         Jw4lGtc4ZBeVx9PxeK7vDu4RfMVvfin0noSCoDLTpVl77u1VDnVyaXmmMv9XeUZ2T7d7
         P1GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=bjdIvKAE9+v5d05DIespxf4RX/qjcteADqi92OtX9xI=;
        fh=RmvXQoNpcUwBYYfjwO9RDJaJ2oMw7SLKc8jO0Pmx1UM=;
        b=L2mTSqO5zNLlcELe8Y3MAlqJi9hxf4w+TstJO4lVo8c9E20cMGhjqBWtFw9DtJZXDY
         /yDpKB65FRZXW3PIXDZR4CxV+LL8YfAhJT+cJO8p9MwfJKyfCItY1USQ2ZBMh79qsVOP
         Fuv7hS5Zck3GK+M/cHFbdqOJW5hgU+cuMuGnWl0iLpcafAS7C1EQxaz8a4CwY5hgKEOP
         xeSJCGGaku5LAf31Q1H1rt7OR4GEnF3X0GfW6e7rbJLRlXXHHO3Bumks1bE5jG3X/yzU
         mPBymPSJ1iFVs7cN05mzwEuUtBElX85EvDP9AiVzGSoHZ5BtY7JLwhRGxbrCcRglldOl
         yxXw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781140651; x=1781745451; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bjdIvKAE9+v5d05DIespxf4RX/qjcteADqi92OtX9xI=;
        b=BghvB0H3WqSA2wShMhQaTfZVIVHAUwQmySpQidixx0wwJj1lLnfttxvoAuFwJG6cVZ
         VfxYWUezxjPT6GnTZtcd46mgwu7fGTisaP/d4rPwSl/4cORHJmk157jUiCObvvgGWUoe
         ml77TmM+msz7QhYFNzKuxYOVJtGI+xv7v/CMSsAA9xJMOd6fYoT/3PoLXphP2AJYy4Dd
         31QX4tAj19kP5MzxCmKtHTqaHc7n0F6fKVWeBJ3YS0f2NJl7Gt707Td4cZeNLAe+Y0SG
         kdRCL3K0QKR8Sjgt+3pUPTyUjdwgiXijXLJcwMej72K9HDGqv1z3XqjRlxAb9zgdOvgL
         BzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781140651; x=1781745451;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bjdIvKAE9+v5d05DIespxf4RX/qjcteADqi92OtX9xI=;
        b=U2E6YQ7q6gWeoU+vXTRQiYgCtGZ9JcPygNkrs0g0j4d8TVv6X+wpie2aCD4yIvgU43
         cvkrRqHMokuUNwISMvUp7LXGCShX9sVK1zPG5K2Z7AN0ADK3zydUvJy/4u2TPwfNyKIz
         4EF7aeybjzqDNOklA3tGZ1i7feH9w/ma+ID4NsL8xZK3NbuEafiyFRt5WY+YHA4iJMBE
         fZ5qS73B8m0auOYqjYtcLP9Ioy/Z34MKyr2THkCcaCCjwXMns4ceYtCrD1etFHI5GSJW
         CHYHIFvgDtC6yxfpL4I/rQACvbOl9jPAqnywui9Pq5UVAyUbQKEqlgk2A1Mua1Key6D3
         PW5w==
X-Forwarded-Encrypted: i=1; AFNElJ83KCkpm8qA6l4fPvpC3jhm90aosDccBiPwY0AGzxrLASPQuEvrHS/3x+SanBNSa+sBmTrWuGw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJyU9lKEeuHuA+/DBMvQVvhK6iJmHFcU6k4h1P0LCZpGJkUSU3
	4Eh0wONJbasA7x3sH+Pptkl1U6D0G4mbWqWBq+pS+5vD9RXU4EIpmYjFQ09WcKowUPOeCSuhba/
	hlO6o+9hGcaKNAFB0zlAiYyasufTuTLGqZ2Ud0GzE
X-Gm-Gg: Acq92OEYXEqtipXOmGKMEDrE8ny2HMGVHy1SBNN5o8MIno3V1YfrjnkkXNvfFd1xA5a
	j1ORM2F8nNGRIHUGJPtfxyVftQAsjBKLjQa5sjlUzknJuBsfiNJXMd1+aotrTwFUtF9RzumHscV
	DK736yx9cq2loWqIaZ7X06RpSxUiDY92MykvqWnDhTzK26bJFYe2KxcxO8B5XX7QbSiR6eQXmx9
	p6RjWeCjnCI+izhNBC1XFCN50CAsAB+kbPupzL/t1Itye15vGCCxfFsDN7wKMhGVQ42AH7s8hKY
	9XCemC9J2qaBikIhHxxMdQvoqlYTlCsBhmJ/aghECLZ+vx0A1A==
X-Received: by 2002:a05:7022:690:b0:135:e455:e1e0 with SMTP id
 a92af1059eb24-13842161934mr353073c88.10.1781140647800; Wed, 10 Jun 2026
 18:17:27 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 10 Jun 2026 18:17:26 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 10 Jun 2026 18:17:26 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260331194202.1722082-2-vipinsh@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 10 Jun 2026 18:17:26 -0700
X-Gm-Features: AVVi8CdzGmaVWznPyG5AyMjnV1Z4iECS6hmJp8c16LmKO_AaXBZJcKDEnsuZUaA
Message-ID: <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] KVM: selftest: Create KVM selftest runner
To: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"

Vipin Sharma <vipinsh@google.com> writes:

>
> [...snip...]
>
> +def setup_logging():
> +    class TerminalColorFormatter(logging.Formatter):
> +        reset = "\033[0m"
> +        red_bold = "\033[31;1m"
> +        green = "\033[32m"
> +        yellow = "\033[33m"
> +        blue = "\033[34m"
> +
> +        COLORS = {
> +            SelftestStatus.PASSED: green,
> +            SelftestStatus.NO_RUN: blue,
> +            SelftestStatus.SKIPPED: yellow,
> +            SelftestStatus.FAILED: red_bold
> +        }
> +
> +        def __init__(self, fmt=None, datefmt=None):
> +            super().__init__(fmt, datefmt)
> +
> +        def format(self, record):
> +            return (self.COLORS.get(record.levelno, "") +
> +                    super().format(record) + self.reset)
> +

The commit message above says the printing will be in colors when the
terminal supports it, but if I'm reading this correctly, the colors will
always be printed.

I was expecting something like if the output is piped to some file or
like "not TTY" then don't print colors.

Would you consider not printing in color at all? Or adding some kind of
"turn off all display magic" flag?

I also saw code for a sticky footer in another patch in this series,
that's probably not nice for other stuff wrapping this runner.

> +    logger = logging.getLogger("runner")
> +    logger.setLevel(logging.INFO)
> +
> +    ch = logging.StreamHandler()
> +    ch_formatter = TerminalColorFormatter(fmt="%(asctime)s | %(message)s",
> +                                          datefmt="%H:%M:%S")
> +    ch.setFormatter(ch_formatter)
> +    logger.addHandler(ch)
> +
> +
> +def fetch_testcases_in_dirs(dirs):
> +    testcases = []
> +    for dir in dirs:
> +        for root, child_dirs, files in os.walk(dir):
> +            for file in files:
> +                testcases.append(os.path.join(root, file))
> +    return testcases
> +
> +

Sean pointed me here from guest_memfd tests [1]. The Makefiles allow us
to generate test configs at build time. For [1], I could configure all
the test parameters statically or at build time.

[1] https://lore.kernel.org/all/aiHeDZEPkAcWcSkn@google.com/

Perhaps for a future extension, but would you consider taking the output
of some program as input for cases to run?

My (future) use case is that with hugepages, I want to run something
like

  ./guest_memfd_test --order=0
  ./guest_memfd_test --order=9
  ./guest_memfd_test --order=18

And 0, 9 and 18 are the supported HugeTLB orders on the machine being
tested. I'd like to iterate over supported HugeTLB orders at runner
runtime instead of at build time.


> +def fetch_testcases(args):
> +    testcases = args.testcases
> +    testcases.extend(fetch_testcases_in_dirs(args.dirs))
> +    # Remove duplicates
> +    testcases = list(dict.fromkeys(testcases))
> +    return testcases
> +
> +
> +def main():
> +    args = cli()
> +    setup_logging()
> +    testcases = fetch_testcases(args)
> +    return TestRunner(testcases).start()
> +
> +
> +if __name__ == "__main__":
> +    PYTHON_VERSION = (3, 6)
> +    if sys.version_info < PYTHON_VERSION:
> +        print(f"Minimum required python version {PYTHON_VERSION}, found {sys.version}")
> +        sys.exit(1)
> +
> +    sys.exit(main())

This shouldn't block merge: why not align with the kernel's official
required python version?

>
> [...snip...]
>
> +class Selftest:
> +    """
> +    Represents a single selftest.
> +
> +    Extract the test execution command from test file and executes it.
> +    """
> +
> +    def __init__(self, test_path):
> +        test_command = pathlib.Path(test_path).read_text().strip()
> +        if not test_command:
> +            raise ValueError("Empty test command in " + test_path)
> +
> +        test_command = os.path.join(".", test_command)
> +        self.exists = os.path.isfile(test_command.split(maxsplit=1)[0])
> +        self.test_path = test_path
> +        self.command = test_command
> +        self.status = SelftestStatus.NO_RUN
> +        self.stdout = ""
> +        self.stderr = ""
> +
> +    def run(self):
> +        if not self.exists:
> +            self.stderr = "File doesn't exist."
> +            return
> +
> +        run_args = {
> +            "universal_newlines": True,
> +            "shell": True,
> +            "stdout": subprocess.PIPE,
> +            "stderr": subprocess.PIPE
> +        }
> +        proc = subprocess.run(self.command, **run_args)
> +
> +        out, err = proc.stdout, proc.stderr
> +        self.stdout = out.decode("utf-8", "replace") if isinstance(out, bytes) else (out or "")
> +        self.stderr = err.decode("utf-8", "replace") if isinstance(err, bytes) else (err or "")

I think it would be useful to capture stdout and stderr in order that it
was output, so that the output being saved shows everything
interleaved. I think the order could be useful in debugging.

I can see benefits in knowing which was on stdout and which was on
stderr too, so is there some way of having both?

> +
> +        if proc.returncode == 0:
> +            self.status = SelftestStatus.PASSED
> +        elif proc.returncode == 4:
> +            self.status = SelftestStatus.SKIPPED
> +        else:
> +            self.status = SelftestStatus.FAILED

Using this class-based pattern requires us to do
Selftest(test_path).run(). Would you consider using a function-based
pattern, like run_selftest(test_path) instead?

>
> [...snip...]
>
