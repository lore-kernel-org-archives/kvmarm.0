Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7613F5BE1
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 23:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781651082; cv=pass; b=Qo48cvbexA33sPQtvaJeduvS4A2EIP3Df/NSiBcXhsAhbJTwoH7At1V6SRgFyElMy+upwJXkAufWYsO8uwCxKZCQAco//28v5x3sxRMtttvSlTNooN9Ax5Wp2bmRXKtwzY7u0ooH0mh61SB9o8cAscu7unUDyijrmzNyBHn4Ykw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781651082; c=relaxed/simple;
	bh=Bo53uHY0s3ADC/1KSIqS/4nXPxSM3WGq0VNZ9bGjaas=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rd55+gTFWuuyKibR3oTy+wcj6W58HhKOPhLXHGzOFlNOMJStj7KK2Qgfh+CpjxMnrXMenRQuFtOfcF/1ABzLqg4D9TX8f+uJp+y+RR83XsMEXpLOce5Igy4YMIZ7j0vORdJVPbJZHj8t25CO0AK971CPvRa0A3e4fS22Y4LrN7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tlMQuWhP; arc=pass smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tlMQuWhP"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-13981833e13so2496234c88.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 16:04:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781651074; cv=none;
        d=google.com; s=arc-20240605;
        b=jnc6uKJrBmBTqo8BS56iGZwd6vhsCYu6EkpfQ4AM0pFYCbKPCSg4G1jRf5uq1l2KLT
         ngSCGOEDUhGgTO4j7UY7znr7pfuIIt6v96PExmSNR8kHhBdYvZqQU9YGaonQA0+aMm6j
         7CDbleDm4KdXj5qUF+pGjy/7t4S43zCVQFQBF/2kFrR/7mofqYShMFHUoPrI6bIghe5t
         Wg1EnMniyo7qijsAMdYRBB/yFK0k558zx5cLP07qMJj+BAtbDpKZfjOpcysi6IDEXT+F
         wEey0Kd/sOm9OH9FEya5OgrLa3uR7GA3GBvjAWfnXvm5qH1gttOrhTXl0Hlp/ayJQ+wK
         wDcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=IDtlYzSJ10HUdDDSmXfhgs31EXUJLXgmuoKNNIFB6PM=;
        fh=pOUcKg5yiTTDlZm+P3ueiLwODtIQGWmScg2pwCRn78c=;
        b=Qm+3jgYIm6cTL/yxDTCpBDYy10U9LM0aKmH4qw1zCHC9duGT0CkAgwQtB7Z3xnmMw9
         FE3/rBdqQ1ng8B4TP1NAs+2Fdo0AMGtIOdMzRGA2XHbdshCNGf9IiVydlUhbesYa3ONg
         zQAMxmZoGJMCGkVARvqmCvHTXyaKmWxiFudN/6frJyK6tHdMfwQfks+X6dHdHr4cr3jF
         QoKIDsKe2GelpDTEogXtjGTl6GTHlDIlTM29VwX+YHr34KFq8NnfcDdiui4rpJbQTg3H
         B9xVuNM7eSDj8yyBi1fpiL+6EFacs7ciVv/MmUjbPeG+GypZvqCemFtWwT3eJFxCPQgc
         QOzA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781651074; x=1782255874; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=IDtlYzSJ10HUdDDSmXfhgs31EXUJLXgmuoKNNIFB6PM=;
        b=tlMQuWhPmBAz5RGP1LEzo8/C5BYbx/pFvgGQBhYGs+1IrKC87YtSGonJ1pa29aV3Ki
         hKmmsp+gDH4MOIJljxrIt6hkbVarXOCCKjUkyXtNLojSxJLmhEESRopZItAijN10AhGy
         hQ23Xh+Xp2ZOSaV2Irch6Xvhs2mllYriU3E4Bv73BokxhLT6KdsDxkSTTsRDbgmtipZs
         dz6xxG9PKojSd93xhCSaQgNaxtQLOoH/SB+9OduNiZpO1etkTWRHWFsgfBYFYocRR3Zv
         089bJYWVHTCHnv2a3XZmorXI6b/xFiUzJWcOrIcFrT+dAakDICoYb7scgz66Pug8JT7h
         CROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781651074; x=1782255874;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IDtlYzSJ10HUdDDSmXfhgs31EXUJLXgmuoKNNIFB6PM=;
        b=oh76JhwfYDY8HwmqYRWWjWAdWnFZwDJVZyffJ/lI3fE8qW8tgEO9RGX0TmJ1tIjag6
         A64gTtXklMiEijfEPnAA0qjAZi/ZhiQV6LnelPGmC864fM7A6t6y9gqrPMMX7/1lX5jJ
         6ctaIoY0u0tOr1nRU02P44Z8ekdqAfeoCpbAKPmbdcDM5Y7JpEk/s3ANOuJCJ+BodqB7
         biUOeRDkAZ4rmF2VHfTNMjQeMAln0qk3aGbUyRUZewYm3R1hgiuBVaWbh60WgzmoEUIY
         xPU/6Miapw2hfe/6IT36eXKQn0gRWPZMi+5XP0ulG+UfNTInNiNpjPhpLPERBrvhftnk
         YKEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+x4XZSlx3C4Gye4WP8SKVgG+of5LvOtYOcIY9aq2tSysQDOZKOQQ+R3u6YTyNPPqhxfpHjwT0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPcNl9jpG6b388081wvbsXZDVI87lX7oCkTwdsIHIYbjj0MGdo
	2+s5u1rFyW11XerJKzWCtMVtNQ3q8lpYaJ/+ULHQMu9kmZNIUFV/xMl5f76bgDx/FqVQqnvD0MJ
	Swk/x5hJxD+UYT7EDC4mCJibvbMlJbV2fOWVQs9b+
X-Gm-Gg: Acq92OHIN1uTP56i7n6hD33xadg0LTPNds+FNI9bMHCXoLqNdam+kUIs7rdR6mMrGFo
	cZclvNKQUAZG9cdr07aVBnOJlVlUDUFyCrcbYGS57CeIU11is8AkDepEY7RZCy/e7BHl/sbfqfw
	KCxeseAic0mGpiIRekPx3dYp4JjSCpgYgpR098Me5kDZbNXe3uG6WzkSyzlEiciMphuZmStn8tu
	xI0OnenHRwP9O5ZDonj0KoFbVJpBgu9ZYgOF/zuUSRdDo64lSYuKy/rhWBMj6cAPtKTDq/kqA83
	+5kEw8mOMzeLWRXN8kg9RZtjhxhJ5MoTwqbFkLZ6eqohLAZ2dphvjUuPh3rPnpfNPl+jlg==
X-Received: by 2002:a05:7022:fd08:b0:137:1ae1:bc2f with SMTP id
 a92af1059eb24-1398f6547damr476392c88.13.1781651072971; Tue, 16 Jun 2026
 16:04:32 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 16:04:32 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 16:04:32 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260616194000.GC1675268.vipinsh@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com> <20260331194202.1722082-2-vipinsh@google.com>
 <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com> <20260616194000.GC1675268.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 16 Jun 2026 16:04:32 -0700
X-Gm-Features: AVVi8CcXGzWmHVP01yNQ9cwcnpEans6MeetfVkGQMij7VBGAo0JuOj3VXMX_DH4
Message-ID: <CAEvNRgF3a7BPBzqDOc0pXe4V1qxXfSHx49VyBHVRzJa0Mch+Bg@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] KVM: selftest: Create KVM selftest runner
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"

Vipin Sharma <vipinsh@google.com> writes:

>
> [...snip...]
>
>>
>> I was expecting something like if the output is piped to some file or
>> like "not TTY" then don't print colors.
>>
>> Would you consider not printing in color at all? Or adding some kind of
>> "turn off all display magic" flag?
>
> Good point about color on/off. I can make following
> changes in following priority, starting with the highest:
>
> 1. If NO_COLOR enivornment variable is set then don't print color at
>    all.
> 2. If FORCE_COLOR environment variable is set then print color
>    (default).
> 3. If output is not TTY then don't print color.
> 4. Print color.
>

I think we can take reference from what grep does.

+ --color=auto (default), if output is piped or redirected, no color.
+ --color=always
+ --color=never

>>
>> I also saw code for a sticky footer in another patch in this series,
>> that's probably not nice for other stuff wrapping this runner.
>>
> For sticky update, I can hide it if there is no TTY.
>
>> > +if __name__ == "__main__":
>> > +    PYTHON_VERSION = (3, 6)
>> > +    if sys.version_info < PYTHON_VERSION:
>> > +        print(f"Minimum required python version {PYTHON_VERSION}, found {sys.version}")
>> > +        sys.exit(1)
>> > +
>> > +    sys.exit(main())
>>
>> This shouldn't block merge: why not align with the kernel's official
>> required python version?
>>
>
> When I first proposed official version was 3.5, it got upgraded to 3.9
> in commit 5e25b972a22b ("docs: changes: update Python minimal version")
>
> I was using some APIs which were not present in 3.5 and 3.6 was the
> minimum version I was able to run all the features I needed.
>
> It just stayed that version and I never checked to keep it in sync with
> the latest python version.
>

I see, no worries, not a huge issue.

>> > +
>> > +        run_args = {
>> > +            "universal_newlines": True,
>> > +            "shell": True,
>> > +            "stdout": subprocess.PIPE,
>> > +            "stderr": subprocess.PIPE
>> > +        }
>> > +        proc = subprocess.run(self.command, **run_args)
>> > +
>> > +        out, err = proc.stdout, proc.stderr
>> > +        self.stdout = out.decode("utf-8", "replace") if isinstance(out, bytes) else (out or "")
>> > +        self.stderr = err.decode("utf-8", "replace") if isinstance(err, bytes) else (err or "")
>>
>> I think it would be useful to capture stdout and stderr in order that it
>> was output, so that the output being saved shows everything
>> interleaved. I think the order could be useful in debugging.
>>
>> I can see benefits in knowing which was on stdout and which was on
>> stderr too, so is there some way of having both?
>>
>
> Both approaches are useful, I am not sure how to achieve what you are
> asking reliably.
>
> However, I think separate stdout and stderr is more useful in automation/CI
> tools. Considering, runner is for the human use I am more inclined on
> having combined output of stdout and stderr as you are suggsting.
>
> I will change it to combined output in next version, new filename will
> be "out" consisting of both stdout and stderr. If there is ever
> need for separate dumps we can revisit it.
>
> One thing we will lose is in current approach, non-zero stderr is signal
> of finding errored out runs. Not a big loss as same information can be
> grepped using master log file.
>

Here's an idea to have both:

        import selectors

        process = subprocess.Popen(
            command,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,
        )

        sel = selectors.DefaultSelector()
        sel.register(process.stdout, selectors.EVENT_READ)
        sel.register(process.stderr, selectors.EVENT_READ)

        output_lines = []
        stdout_lines = []
        stderr_lines = []

        while True:
            events = sel.select()
            for key, mask in events:
                line = key.fileobj.readline()
                if not line:
                    sel.unregister(key.fileobj)
                    continue

                if key.fileobj is process.stdout:
                    # append to stdout_lines... Might need to deal
with newlines?
                    # perhaps even print it from the runner's stdout, so
                    #   the runner gives faster feedback for a human
                elif key.fileobj is process.stderr:
                    # do something equivalent for stderr_lines

                output_lines.append(line)

            if not sel.get_map():
                break

        process.wait()

I'm also okay if it's first combined, and this can be an extension if
it's really needed.

>> > +
>> > +        if proc.returncode == 0:
>> > +            self.status = SelftestStatus.PASSED
>> > +        elif proc.returncode == 4:
>> > +            self.status = SelftestStatus.SKIPPED
>> > +        else:
>> > +            self.status = SelftestStatus.FAILED
>>
>> Using this class-based pattern requires us to do
>> Selftest(test_path).run(). Would you consider using a function-based
>> pattern, like run_selftest(test_path) instead?
>>
>
> I find current class model provides an easy way to group data in
> hierarchy. For example, test_runner has list of selftests which it needs to
> execute. Selftests have their own test command, output data, result
> status, etc.
>
> Both are suitable to implement runner. But I am little hesitant to
> change it now considering it is already written. If you can provide
> benefits of using functions approach here then I am open to
> rewrite.
>

I think the classes approach introduces more boilerplate which isn't
necessary. I don't think there's any state stored in the classes and so
this is a good fit for using functions. After removing the boilerplate,
we might actually be able to put everything nicely into 1 file! That's
not to say classes can't be in 1 file, I think we're more used to
classes being in separate files.

__main__.py is already mostly in a non-class style, which makes the rest
being in the class style more jarring.

Most of the kernel is C which is mostly procedural where you need to
implement your own OOP, so I wish the accompanying python would follow a
more procedural/function-based style rather than directly reach for OO.

I'm also heavily influenced by Jack Diederich's talk [1], which is a fun
talk but may be too long to watch, so [2] is a text overview.

[1] https://youtu.be/o9pEzgHorH0
[2] https://szuckerman.github.io/stop_writing_classes.html

I guess this might be more of a philosophy/preference thing, feel free
to go ahead if others express preference for the class style.

>> >
>> > [...snip...]
>> >
