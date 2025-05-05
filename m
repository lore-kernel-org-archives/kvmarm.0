Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FAE25D543
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 19:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746474524; cv=none; b=QHzNT7n78iodUmbBc+wkj2+1cLhLC2rYoDxRd+wYM4zcJJO/AFsz/+R23aWWd36+jzXvlbDxCLj0DE40TuJLrCQOFnSe9M3EXWGrHpYCt9tSUBeXUM4gIFS1cWTleb+wFYYaQpNqWpBf3fEqWTvHBou7sen69m6dTx1QMpRpkkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746474524; c=relaxed/simple;
	bh=fb603dnZKrEHXFCOyM7IBHYhwlo7ERkqyByPNpSQRnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ld2egD0gQY219rnCWvHcGOKXTao/MEreQjZV6oEnLhqFr/GgH7Ke9U5+1Q4pGpO4MfE2XxUriBt0gYaOVlUHOcslSTDoCiUzxz9Luj1Zi4AjJSGQ6gjupevCCK9ukRlZz+hXgprr5zsKv4GerjrQmenLHUpIyLYLmsM8kERtsjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yXW7wtc0; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yXW7wtc0"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2240aad70f2so38265ad.0
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 12:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746474522; x=1747079322; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pAjw+RP1+6euq9Xnw3ss8KTaidRJzLLOan/6IZ94Dsc=;
        b=yXW7wtc0tvosfUF8wCBhGHKjArxq9H31XHy+2Z7vffX0NElKnQNHHPf6C6AjDSK1ml
         NNBp8Yh4lZE7UMu+1jzCPViJHE9QFVvV3Wj4HLtbjtThrbsD/yBoRdV4VJswFT4uxnus
         u4YbeBOke1ZsqErfBZvvDhFaphmZX5RTgsLpP+BPDpnrkm3Lg1KgoJF3UN3gPz0oweiB
         K2gi6vmW7qSWWV8ootXHkG6SRw24PKSgqNiZEyO7SkGgg0D7nmvj3msQO8pEw1ah7FEn
         xczRyF3iDCcA84eAU/PzEdYIfjwOnNkDhW/mlVAnCkELUBJRfp5ccM7Q7i6cwxwGmAtQ
         fzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746474522; x=1747079322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAjw+RP1+6euq9Xnw3ss8KTaidRJzLLOan/6IZ94Dsc=;
        b=MGeMBRQMR1Dy+U2Cblr6MlM03by+ef8WWyzPgtM1DnjMrxkWzgArZH0amcyvMMVCII
         AH39YYKsK5A4e9A50A9J3uECHQnmbNkaXzmcqfajqWTpSzPuuNsjcosL71gk67nPWF0o
         SDCQ+Cn9WfQBo0kkaZn44B9oCLNp6wtZQRppcuwGBGtoewomQWh9C6Chtq1a2UZx3L0v
         JiBo75a+h++SyJzaPsu8e3t8IMUavQFRwmW9qc7oHlWSEdePbWVJoTwB8h78HSwbCg8e
         WYBMd6S2Sdh34hcZ2hZFRrUreKn0s9t+EGUOER+GT0fSCDhJRW1wl9+ioQoaiMDtczAX
         2y+g==
X-Forwarded-Encrypted: i=1; AJvYcCV+z+yUdDN53brY8mch1GTrW21KNEiapVbASHEAlvRmwKLlhVGLDnpLcZI80/ye4ta5kR6uj3s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxXHPEJ1Eknyzk9Hhh50Jg8kedORnJ5dkvuWrLckIbTnr9ZE3h
	uwwd1a040ogIzE1gJiNlZrwqqtlgKKMbp8z0cJaHRKrkrseu1CbCXhwq+7IkiA==
X-Gm-Gg: ASbGnctkGnf3uXPFaQfhQ2Pkj/l2lkdLJKRSNx02BWvUezBGQc0wwK51cXzFmzmLsrh
	G+A+v3htXVZTJuC383uFU7dUtx4kc8KPXq1cw8jEFdlxF8VIqzsOWa1ethMtdXpN8njlGBpOjTr
	Ejy54ZxkQJmmyrUiAcz2/XbDoBk3MBR7co63zWvJoliILrYQW+k/5byFeVeUHdYfYYKUvC57uB5
	eSxePLeUItxB9jWm5nshHHiy9MoFsHT9/TqST9nj/enS5JHD1UxfhqQ2opLf5mClO9pPvd5pQ3V
	dOzMpQZEQmV3gBOrslFCbCZ30ooKwBKPc3iAHrMOmh/Bjzak0aScH0YA3MeQ2RpwAeaEr/l/WeH
	Wpw==
X-Google-Smtp-Source: AGHT+IFe81XCbK5uMeJoPJg1XV56xU76aNDTbL3/KYnGiZ31GOPdYKcEOgtVXzT/n5btxhacARrPsA==
X-Received: by 2002:a17:903:17c7:b0:22e:1858:fc25 with SMTP id d9443c01a7336-22e3534e345mr376965ad.9.1746474521506;
        Mon, 05 May 2025 12:48:41 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3c6a59bsm6010723a12.67.2025.05.05.12.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 12:48:40 -0700 (PDT)
Date: Mon, 5 May 2025 12:48:36 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
	pbonzini@redhat.com, anup@brainfault.org, borntraeger@linux.ibm.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, maz@kernel.org,
	oliver.upton@linux.dev
Subject: Re: [PATCH 2/2] KVM: selftests: Create KVM selftest runner
Message-ID: <20250505194836.GB1168139.vipinsh@google.com>
References: <20250222005943.3348627-1-vipinsh@google.com>
 <20250222005943.3348627-3-vipinsh@google.com>
 <aBKWmRDBrjeZhAW0@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBKWmRDBrjeZhAW0@google.com>

On 2025-04-30 14:31:05, Sean Christopherson wrote:
> This is awesome!
> 
> I have lots of idea, but not all of them need to be address for the initial
> commit.  Some of them I would consider blockers, but I also don't want to end up
> with massive scope creep that causes this to stall out for (more) months on end.
> 
> On Fri, Feb 21, 2025, Vipin Sharma wrote:
> > Create KVM selftest runner to run selftests and provide various options
> > for execution.
> > 
> > Provide following features in the runner:
> > 1. --timeout/-t: Max time each test should finish in before killing it.
> 
> The help for this needs to specify the units.  I assume it's seconds?

Yup, it is in seconds. I will update the help text.

> > Runner needs testcase files which are provided in the previous patch.
> > Following are the examples to start the runner (cwd is
> > tools/testing/selftests/kvm)
> 
> The runner definitely needs a command line option to specify the path to the
> test executables.  Defaulting to in-tree builds is totally fine, but we should
> also support out-of-tree builds (or copying to a remote host, etc.).
> 
> The default testcases will have relative paths, e.g. $arch/$test, so the user
> will still need to maintain the same directory structure as in-tree builds, but
> IMO that's totally fine.
> 

I didn't think about out-of-tree builds. Thanks for catching it.

I will add a command line option to pass the path of kvm selftests
executable, with the assumption of same directory structure as in-tree
builds. Default will be assuming in-tree builds.

> > - Basic run:
> >   python3 runner --test_dirs testcases
> > 
> > - Run specific test
> >   python3 runner --tests ./testcases/dirty_log_perf_test/default.test
> > 
> > - Run tests parallel
> >   python3 runner --test_dirs testcases -j 10
> > 
> > - Run 5 tests parallely at a time, with the timeout of 10 seconds and
> >   dump output in "result" directory
> >   python3 runner --test_dirs testcases -j 5 -t 10 --output result
> > 
> > Sample output from the above command:
> > 
> > python3_binary runner --test_dirs testcases -j 5 -t 10 --output result
> > 
> > 2025-02-21 16:45:46,774 | 16809 |     INFO | [Passed] testcases/guest_print_test/default.test
> > 2025-02-21 16:45:47,040 | 16809 |     INFO | [Passed] testcases/kvm_create_max_vcpus/default.test
> > 2025-02-21 16:45:49,244 | 16809 |     INFO | [Passed] testcases/dirty_log_perf_test/default.test
> 
> 
> Printing the timestamps to the console isn't terrible interesting, and IMO isn't
> at all worth the noise.
> 
> The PID is nice, but it needs to be printed _before_ the test finishes, and it
> needs to track the PID of the test.  If getting that working is non-trivial,
> definitely punt it for the initial commit.
> 
> And presumably INFO is the level of logging.  That needs to go.
> 

Instead of removing timestamp, I can just print HH:MM:SS, I think it
provides value in seeing how fast runner and tests are executing.

I will modify PID to print each test pid.

INFO will go away.

> > ...
> > 2025-02-21 16:46:07,225 | 16809 |     INFO | [Passed] testcases/x86_64/pmu_event_filter_test/default.test
> > 2025-02-21 16:46:08,020 | 16809 |     INFO | [Passed] testcases/x86_64/vmx_preemption_timer_test/default.test
> > 2025-02-21 16:46:09,734 | 16809 |     INFO | [Timed out] testcases/x86_64/pmu_counters_test/default.test
> 
> I would really like to have terminal colored+bolded output for tests that fail
> (or timeout) or are skipped.
> 

I will add color+bold for test which fails, timeouts, or skips.

> I think we should also provide controls for the verbosity of the output.  E.g. to
> skip printing tests that pass entirely.  My vote would be for a collection of
> boolean knobs, i.e. not a log_level or whatever, because inevitably we'll end up
> with output that isn't strictly "increasing".
> 
> Adding a param to disable printing of passed tests is presumably trivial, so maybe
> do that for the initial commit, and then we can work on the fancier stuff?

You mean some command line options like:
	testrunner --print-passed --print-failed
	testrunner --print-skipped
	testrunner --print-timeouts
	testrunner --quiet

I can provide few options in the first commit, and then later we can
extend it based on usages.

> 
> > 2025-02-21 16:46:10,202 | 16809 |     INFO | [Passed] testcases/hardware_disable_test/default.test
> > 2025-02-21 16:46:10,203 | 16809 |     INFO | Tests ran: 85 tests
> 
> It would be very nice to have a summary of things printed out periodically.  E.g.
> if my normal run has a few failures, but the current run has already failed a
> decent number of tests, then I'd probably kill the run and start debugging.

I can add a sticky bottom line which prints the current state of the
total, passed, failed, skipped and timeouts.

> 
> Alternatively, and maybe even better, would be to make the runner mildly interactive,
> i.e. to accept rudimentary commands while tests are running.  Then the user can
> query the state of things while the runner is still doing its thing.  E.g. bind
> a few keys to print the various statuses.
> 
> > 2025-02-21 16:46:10,204 | 16809 |     INFO | Passed: 61
> > 2025-02-21 16:46:10,204 | 16809 |     INFO | Failed: 4
> > 2025-02-21 16:46:10,204 | 16809 |     INFO | Skipped: 17
> > 2025-02-21 16:46:10,204 | 16809 |     INFO | Timed out: 3
> > 2025-02-21 16:46:10,204 | 16809 |     INFO | No run: 0
> 
> A not-quite-mandatory, but very-nice-to-have feature would be the ability to
> display which tests Passed/Failed/Skipped/Timed Out/Incomplete, with command line
> knobs for each.  My vote is for everything but Passed on-by-default, though it's
> easy enough to put a light wrapper around this (which I'll do no matter what), so
> my preference for the default doesn't matter all that much.
> 
> That could tie into the above idea of grabbing keys to print such information on-demand.
> 

This will be very involved feature, lets punt it to a later versions, if
needed.

> Also CTRL-C handling needs much more graceful output.  Ideally, no stack traces
> whatsover, and instead a summary like the above, but with information about which
> tests didn't complete.
> 

Should be doable.

> > Output dumped in result directory
> > 
> > $ tree result/
> > result/
> 
> The runner should have an (on-by-default?) option to abort if the output directory
> already exists, e.g. so that users don't clobber previous runs.  And/or an option
> to append a timestamp, e.g. $result.yyyy.mm.dd.MM.SS, so that all users don't end
> up writing the same wrapper to generate a timestamp.
> 
> Having a no-timestamp + overwrite mode is also useful, e.g. when I'm running in
> a more "interactive" mode where I'm doing initial testing of something, and I
> don't care about
> 

We can provide user an option like:
	testrunner --output result_TIME

then internally runner will replace TIME with the current time?

If user doesn't provide _TIME then we can overwrite the directory
provided.

This sounds reasonable to me, what do you think?

> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -11,3 +11,4 @@
> >  !Makefile
> >  !Makefile.kvm
> >  !*.test
> > +!*.py
> 
> Sort this alphabetically as well.

Okay.

> 
> > +def fetch_test_files(args):
> > +    exclude_dirs = ["aarch64", "x86_64", "riscv", "s390x"]
> 
> These are now:
> 
> arm64, x86, riscv, s390
> 

Yeah, I will make the change.

> > +    def __init__(self, test_path, output_dir=None, timeout=None,):
> > +        test_command = pathlib.Path(test_path).read_text().strip()
> > +        if not test_command:
> > +            raise ValueError("Empty test command in " + test_path)
> > +
> > +        if output_dir is not None:
> > +            output_dir = os.path.join(output_dir, test_path)
> 
> This doesn't do the right thing if test_path is absolute (or maybe it's if the
> output_dir is in a completely different hierarchy?)
> 
> I was able to fudge around this with 
> 
> diff --git a/tools/testing/selftests/kvm/runner/selftest.py b/tools/testing/selftests/kvm/runner/selftest.py
> index cdf5d1085c08..3bce023693cb 100644
> --- a/tools/testing/selftests/kvm/runner/selftest.py
> +++ b/tools/testing/selftests/kvm/runner/selftest.py
> @@ -30,7 +30,8 @@ class Selftest:
>              raise ValueError("Empty test command in " + test_path)
>  
>          if output_dir is not None:
> -            output_dir = os.path.join(output_dir, test_path)
> +            dirpath, filename = os.path.split(test_path)
> +            output_dir = os.path.join(output_dir, os.path.basename(dirpath), filename)
>          self.test_path = test_path
>          self.command = command.Command(test_command, timeout, output_dir)
>          self.status = SelftestStatus.NO_RUN
> 

I will fix it in next version. Thanks.

> Lastly, please don't wrap agressively (off-list, you mentioned it was due to a
> formatter?).  E.g.
> 
> diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
> index b9d34c20bf88..5a568e155477 100644
> --- a/tools/testing/selftests/kvm/runner/test_runner.py
> +++ b/tools/testing/selftests/kvm/runner/test_runner.py
> @@ -12,8 +12,7 @@ class TestRunner:
>          self.tests = []
>  
>          for test_file in test_files:
> -            self.tests.append(selftest.Selftest(
> -                test_file, output_dir, timeout))
> +            self.tests.append(selftest.Selftest(test_file, output_dir, timeout))
>  
>      def _run(self, test):
>          test.run()
