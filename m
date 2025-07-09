Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A6E35897
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752097583; cv=none; b=TeK9vvPCuxj6bxpShUOcWLUa1w9l8VO72l9QPVldeiDa4NGDyUcmLE1csEzdhvHxvTcmUYZc4bf5sY/vTBVSuMF/v7qIcuH7Una5TfYP3dNzzA6EsUYGC9vx+CbMCi7ctN5cL7fCIkW659xiaET0zFRtGOnEvGwvqWmP16f60ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752097583; c=relaxed/simple;
	bh=L9LVrS8VhpVhZDH5rGUCmQfvq+9qwn0aD/goPecosqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dbMzbJLLPiI6iUEM6tNDCaBtOxELfQo6QaYqKdDk2HAtJ9Jj5aKfVlue3QxxjamzmCGvpD8elbYT8BHs26HOVx+358AyH53LwvmEqdiXOcV7OlhsFebYK9yLM0Huz1IJ+9DufZkoehp2iblVTX+QFA2JpIKBUxyACtU6uA5seJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cu/XtrE4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cu/XtrE4"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138f5e8ff5so356710a91.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 14:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752097582; x=1752702382; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WaqfKSmh/HmFIuS+sSnBu07GpBGE4YrxsliW83zfkFo=;
        b=Cu/XtrE4tczlf7JZUKOEB/YKdKR5Ms0CzyR59aUTUZc7NkB4JUiTugbiNZacYeYoVm
         KZVXoPJSt2FDIURPVCKOLADfbTmjx5cIAq2bBdWxW3B3k4fQwk9GorMmE9YS/1Uz3zop
         hzuRCOrsxdn1c9n1ofaWInipuxcoQsecszl26pm0Jffvav/sbOzHmg8zQmEmlJKn/uED
         aRhSmuIy87ScnMXvlp41uVOSYRNfCTcdMUOfWdK8q7TsphJUpCLVyYshwgQvQNSsf7q0
         Pgpc+htE5PEjg9rOFsDIW3vUovV9tIte6MFKpfppDmHIj7Q/9UJ1AvKUUbtQs9RtscXg
         a6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752097582; x=1752702382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WaqfKSmh/HmFIuS+sSnBu07GpBGE4YrxsliW83zfkFo=;
        b=p0Gf+CH3dryrLLxh9qy5BBnkkf/2bRCwdknbaUK1Mz4E1OJxlCUephJzPLtxwLjoQ8
         lG0vbcDhBIuzww+cF8dv9LOS8uKvD5dPqtyiJvZAemmrGkSA9hbna6NcsoVcaBb1fRbf
         JYwRtHa2jC8ZAGPyrA4cx6cgAO6dbOV7ldLhQBtdKWePKGlpFuM7JK34QLW+3fGD/Onx
         YEVkr8MxWDOdFgw9YTrdr7P6KtZUYWt4HAC+ajwS0IR38lFKCtbNTBNlKTVxKQVX7V4z
         THTFN2euchRffTPfdH4UeroAhG6/YC3Lq1KPPXqfTAGRQqZiQM5FJueY5i9zk7gY+vOK
         mfeA==
X-Forwarded-Encrypted: i=1; AJvYcCUOqjIyUfk+0pGMKMR1y/oMRnKDQm72UjpyXLNesJ8STmFt/g/Mron2GuzOxsIPh2B4HEApBcU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfSY4uQ4oFPiupuKUBgJ3LYopf5PjQcB1hJupI20ExbfU6StzJ
	yygAiMQI/eA3ZN3jF/JNTLlTYzw1yu7SAb+M1KQISJQHHoa2+9KCKB2vGI/0rXknkPNKulbiErT
	K2Fdfrg==
X-Google-Smtp-Source: AGHT+IGcqFJmd+hfGvHB0iLaIOFTZC36nD5olbTkWzVffAwi5c8bazohN60XOEuv/ND8XITKiAvhLA/8GEg=
X-Received: from pjboh12.prod.google.com ([2002:a17:90b:3a4c:b0:313:230:89ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dcd:b0:311:b0ec:135f
 with SMTP id 98e67ed59e1d1-31c3c2f158emr1976074a91.30.1752097581827; Wed, 09
 Jul 2025 14:46:21 -0700 (PDT)
Date: Wed, 9 Jul 2025 14:46:20 -0700
In-Reply-To: <20250606235619.1841595-4-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-4-vipinsh@google.com>
Message-ID: <aG7jLBAqo1F3SjCl@google.com>
Subject: Re: [PATCH v2 03/15] KVM: selftests: Add timeout option in selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> diff --git a/tools/testing/selftests/kvm/runner/command.py b/tools/testing/selftests/kvm/runner/command.py
> index a63ff53a92b3..44c8e0875779 100644
> --- a/tools/testing/selftests/kvm/runner/command.py
> +++ b/tools/testing/selftests/kvm/runner/command.py
> @@ -12,14 +12,16 @@ class Command:
>      Returns the exit code, std output and std error of the command.
>      """
>  
> -    def __init__(self, command):
> +    def __init__(self, command, timeout):
>          self.command = command
> +        self.timeout = timeout
>  
>      def run(self):
>          run_args = {
>              "universal_newlines": True,
>              "shell": True,
>              "capture_output": True,
> +            "timeout": self.timeout,
>          }
> @@ -48,10 +50,13 @@ class Selftest:
>              self.stderr = "File doesn't exists."
>              return
>  
> -        ret, self.stdout, self.stderr = self.command.run()
> -        if ret == 0:
> -            self.status = SelftestStatus.PASSED
> -        elif ret == 4:
> -            self.status = SelftestStatus.SKIPPED
> -        else:
> -            self.status = SelftestStatus.FAILED
> +        try:
> +            ret, self.stdout, self.stderr = self.command.run()

I don't see any value in having both command.py and selftest.py.  TimeoutExpired
*really* should be handled by Command, especially with respect to stdout/stderr
(more on that later), but that complicates converting return codes to SelftestStatus.

And even if we do figure out a clean split, one of Command or Selftest would end
but being little more than a wrapper or trampoline, with more boilerplate code
than novel logic.

I don't anticipate turning this into a general execution framework.  The entire
purpose is to run a selftest, so I think it makes sense to scrap Command and just
have Selftest deal with running the executable.

> +            if ret == 0:
> +                self.status = SelftestStatus.PASSED
> +            elif ret == 4:
> +                self.status = SelftestStatus.SKIPPED
> +            else:
> +                self.status = SelftestStatus.FAILED
> +        except subprocess.TimeoutExpired as e:
> +            self.status = SelftestStatus.TIMED_OUT
> diff --git a/tools/testing/selftests/kvm/runner/test_runner.py b/tools/testing/selftests/kvm/runner/test_runner.py
> index 104f0b4c2e4e..1409e1cfe7d5 100644
> --- a/tools/testing/selftests/kvm/runner/test_runner.py
> +++ b/tools/testing/selftests/kvm/runner/test_runner.py
> @@ -15,7 +15,7 @@ class TestRunner:
>          self.tests = []
>  
>          for test_file in test_files:
> -            self.tests.append(Selftest(test_file, args.executable))
> +            self.tests.append(Selftest(test_file, args.executable, args.timeout))
>  
>      def _log_result(self, test_result):
>          logger.log(test_result.status,
> -- 
> 2.50.0.rc0.604.gd4ff7b7c86-goog
> 
