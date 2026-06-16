Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D47384238
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 21:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781646196; cv=none; b=SA7LuNoJ2RBZZPJ+OjzTNQgkPnDj171qy5tzVFz4IAMpyogRxOPtprSQ+5K3+NW1MLHX5fnY2cGoc4uhtPygeiWuavjpsSrzlHdUtmYpWLzBunasvddS92KH6l01ljVC2+f3c+47cXunzxQW7RMnk5WvUyKGHN3fQqEcuASs0hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781646196; c=relaxed/simple;
	bh=Et+a5Lv4E82prCtza7xGjuFzolB2s5kqwAMAXq3oMHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnrD7vElkMsfW7DTyHjfXZ6bQCIXKqlh1qvzixJJ3ZGr1zrHoiSZ49IZ2u71tA/1mwcQgh1YXKqWswEf6SYuV4wy0ZIuw7PbiRMK17EtOmd2Bi7EPGMkZq4czIwW/cvaqBGv22fxsSbADb5kktgNN6V6oLbYBDdYf/OR/yOCOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qNrloCbp; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qNrloCbp"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c69fa0b1f8so22145ad.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 14:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781646195; x=1782250995; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YMGez037eq5i2gLRSfEcQdwkg5zUJPnIQY7TCbEX9MY=;
        b=qNrloCbpzh9ZTnPPKOQtQ2V0i5VwrbebW4Ld0KbMav8nm70B/ok+bIc1uB1xvEH55u
         rTbxif7WI+UPZJyCqGayhNwy0jpseaOX2W4jB3ob4p04nM28YrkEdOGvoajx1iAeTqLs
         PoeVrJlTUM1qyO90P1bpGF2saLSvZuqOd0i4eQNwotWvPt9307FTmp29VHJ4s33C2mox
         FcnyrApgsE1mtRqdaWKa5RoPyPnoOKTeWfj2FDCT4Bi3QWtHo4NvYyA15B8OJmhAJ6Ec
         cmf0U2BGNoCkTUK/9Br2Hm7I8X4Z9XzgVITVkL+QS0W/9i9ZObfezsQXTXcSDr7fBAkT
         PQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781646195; x=1782250995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YMGez037eq5i2gLRSfEcQdwkg5zUJPnIQY7TCbEX9MY=;
        b=Q2hnSjQjDb+dH3DWx6PiKNE96r99/AOU8w7Yt/x9CMpNYqy3/iihw/g09Y0jaW2FCa
         EiGfeq8PC/lr5sYAUntrwQj74XxjUXlqULz1ZUSOtlexxrSGFLcsiMJ4oOxXauF8ZOxk
         d6URn0HAWAVEOfMHRKy7lF8Tg8Sck7waGUL+8RTm0liqZ3JHrcBnlYWJQz3HiNV7laaV
         w9EN86sPL24gwXIA9/LGW44qih972BtYhOkF8DSVik4DiOzd5Vf8M7GHCBixfTh+EDNM
         GE2T1Se3RnMxw+K6bfBJP5vuv5AqafPOctyvq3GEqO6RjHZR4sKFPmO/kEY3kdzMm6S3
         wsFg==
X-Forwarded-Encrypted: i=1; AFNElJ8nEfZc5lBrz5/EinMVmFDOwUUS7DJq713OaCm3wEaN63NxjfK5BbVAh/JnxOFzAmTVv6paIwk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjlISg/6JJu7QRvsSUCmmmYNuKgZDv6fJcWwP0wNvC1eODRKV8
	cx0Jkyp3HzOveZqo3UfbHIzzZRkE6gicsRHu8PnJVobtXXLThtZuC3hAQ2n1pTeD4A==
X-Gm-Gg: AfdE7cmwjsXNmufRp2dioGhMmiIGTvAlq+nzksr15da9ChXOIjktAjQjiYqAMfE5IGw
	d6+nFjOSarfqUE9hxNLzEMrEs0f/UMWXLYPD1BaJ5yHpqLL2fzFKwaJ4ClwejNEaKxYZpJCCPeN
	KdVQxJvkdFnyFBcOo0yheanxCVo91rBfw84reNHGUKJRPz8DrLmL6Te/ctA7p+OxVzO7jrgkYRL
	TnrND2q/8CWvojKVhM83osQoNjdYd3y44QkUMXb5sqlWbLohnmyuIzl2R5JVcYGlYr7z0xOoTFS
	DBfGLMW0od/8itE3FEQ17CUKfgw3wryzZI9BVcoYmgQED9g8pUC7tkavFfx6rk+TXKeg7ijmX/9
	t+TXy3rZ9QA4Frc7/PUyti8NtWhbnVsKq1ob7VVhlWHZoLzPv77Ybl0zpzMVtwMA0iWL3hIhUKp
	q7IOJaBQyaOLOB6V+OTICmnpx8uwZJhTLdZREPV7HgfpLgBxkc4NVcN3Ch9h6PHsYXVZDJ
X-Received: by 2002:a17:903:1a8f:b0:2c1:4228:3321 with SMTP id d9443c01a7336-2c6bb8b16ddmr657765ad.12.1781646194557;
        Tue, 16 Jun 2026 14:43:14 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c5df3588dsm2346191a91.8.2026.06.16.14.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 14:43:13 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:43:09 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	anup@brainfault.org, atish.patra@linux.dev, zhaotianrui@loongson.cn, 
	maobibo@loongson.cn, chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com
Subject: Re: [PATCH v4 1/9] KVM: selftest: Create KVM selftest runner
Message-ID: <20260616194000.GC1675268.vipinsh@google.com>
References: <20260331194202.1722082-1-vipinsh@google.com>
 <20260331194202.1722082-2-vipinsh@google.com>
 <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgGrPKBXh=VA3QBLJOczKRpMOB4nDmZL0XRwV6B3PT_7+Q@mail.gmail.com>

On Wed, Jun 10, 2026 at 06:17:26PM -0700, Ackerley Tng wrote:
> Vipin Sharma <vipinsh@google.com> writes:
> 
> >
> > [...snip...]
> >
> > +def setup_logging():
> > +    class TerminalColorFormatter(logging.Formatter):
> > +        reset = "\033[0m"
> > +        red_bold = "\033[31;1m"
> > +        green = "\033[32m"
> > +        yellow = "\033[33m"
> > +        blue = "\033[34m"
> > +
> > +        COLORS = {
> > +            SelftestStatus.PASSED: green,
> > +            SelftestStatus.NO_RUN: blue,
> > +            SelftestStatus.SKIPPED: yellow,
> > +            SelftestStatus.FAILED: red_bold
> > +        }
> > +
> > +        def __init__(self, fmt=None, datefmt=None):
> > +            super().__init__(fmt, datefmt)
> > +
> > +        def format(self, record):
> > +            return (self.COLORS.get(record.levelno, "") +
> > +                    super().format(record) + self.reset)
> > +
> 
> The commit message above says the printing will be in colors when the
> terminal supports it, but if I'm reading this correctly, the colors will
> always be printed.

I meant if a terminal doesn't have support for printing color output
then it won't be printed in color. Almost all modern terminal supports
these ANSI escape sequence, so it will always be printed. Its kind of
a dumb statement I wrote in the commit log.
> 
> I was expecting something like if the output is piped to some file or
> like "not TTY" then don't print colors.
> 
> Would you consider not printing in color at all? Or adding some kind of
> "turn off all display magic" flag?

Good point about color on/off. I can make following
changes in following priority, starting with the highest:

1. If NO_COLOR enivornment variable is set then don't print color at
   all.
2. If FORCE_COLOR environment variable is set then print color
   (default).
3. If output is not TTY then don't print color.
4. Print color.

> 
> I also saw code for a sticky footer in another patch in this series,
> that's probably not nice for other stuff wrapping this runner.
> 
For sticky update, I can hide it if there is no TTY.

> > +if __name__ == "__main__":
> > +    PYTHON_VERSION = (3, 6)
> > +    if sys.version_info < PYTHON_VERSION:
> > +        print(f"Minimum required python version {PYTHON_VERSION}, found {sys.version}")
> > +        sys.exit(1)
> > +
> > +    sys.exit(main())
> 
> This shouldn't block merge: why not align with the kernel's official
> required python version?
> 

When I first proposed official version was 3.5, it got upgraded to 3.9
in commit 5e25b972a22b ("docs: changes: update Python minimal version")

I was using some APIs which were not present in 3.5 and 3.6 was the
minimum version I was able to run all the features I needed.

It just stayed that version and I never checked to keep it in sync with
the latest python version.

> > +
> > +        run_args = {
> > +            "universal_newlines": True,
> > +            "shell": True,
> > +            "stdout": subprocess.PIPE,
> > +            "stderr": subprocess.PIPE
> > +        }
> > +        proc = subprocess.run(self.command, **run_args)
> > +
> > +        out, err = proc.stdout, proc.stderr
> > +        self.stdout = out.decode("utf-8", "replace") if isinstance(out, bytes) else (out or "")
> > +        self.stderr = err.decode("utf-8", "replace") if isinstance(err, bytes) else (err or "")
> 
> I think it would be useful to capture stdout and stderr in order that it
> was output, so that the output being saved shows everything
> interleaved. I think the order could be useful in debugging.
> 
> I can see benefits in knowing which was on stdout and which was on
> stderr too, so is there some way of having both?
> 

Both approaches are useful, I am not sure how to achieve what you are
asking reliably.

However, I think separate stdout and stderr is more useful in automation/CI
tools. Considering, runner is for the human use I am more inclined on
having combined output of stdout and stderr as you are suggsting.

I will change it to combined output in next version, new filename will
be "out" consisting of both stdout and stderr. If there is ever
need for separate dumps we can revisit it.

One thing we will lose is in current approach, non-zero stderr is signal
of finding errored out runs. Not a big loss as same information can be
grepped using master log file.


> > +
> > +        if proc.returncode == 0:
> > +            self.status = SelftestStatus.PASSED
> > +        elif proc.returncode == 4:
> > +            self.status = SelftestStatus.SKIPPED
> > +        else:
> > +            self.status = SelftestStatus.FAILED
> 
> Using this class-based pattern requires us to do
> Selftest(test_path).run(). Would you consider using a function-based
> pattern, like run_selftest(test_path) instead?
> 

I find current class model provides an easy way to group data in
hierarchy. For example, test_runner has list of selftests which it needs to
execute. Selftests have their own test command, output data, result
status, etc.

Both are suitable to implement runner. But I am little hesitant to
change it now considering it is already written. If you can provide
benefits of using functions approach here then I am open to
rewrite.

> >
> > [...snip...]
> >
