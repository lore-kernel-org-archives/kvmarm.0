Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270685661
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098491; cv=none; b=WHaqqsT4eIDuXb0wiy+QiviIhBlc7P899p9AMBneQzrx2YiSxtrdj3DL+1/zOm6T1E5jHu2qPNPzGX1sbpi9TEejBO20IbctxceEgs8WkgJSPEhO9raQaNLmQGv2OSLpi92DpFeFkABSfmxd69qBUdvf9UJAbw3pNcU+8Sw1aoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098491; c=relaxed/simple;
	bh=RaFKs7NUWtXcrGPuqdMmkXEZpFhssJ/jE72lMQUkE9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R8XSff7HyLJUv3nl7b2oV3fpgWDGjhnd7BEDdI1WBhP7k+VLmolVTyaIiZIBxA3MieL4/dJ076q55WSwVSBTWvXPCI/Gm0T8TJCCH21CwVbP9JfCw9ucMjPhjjVs0gWBYx/Vt8uLmMIreZvg3S9OCfnETTSOmr0qVupNQ/3Id+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DzHxF6C3; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DzHxF6C3"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31bc3128fcso511234a12.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 15:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752098489; x=1752703289; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qPkxg71a8xKMOk7gRt6YiWOPIe8HfaUrT3StylJgAHI=;
        b=DzHxF6C3rJiYuP0heLfxdWcnaSBCo01ZO/Mm1Yb6c6mTY4L0wzL9DOI7h3ZwKfZzzV
         55THVLC1mVNykHRsOpnTOFrhdiFthWJM3hvY/s7/J8m3aMVUKkimzxuObNvn0z2mEeh7
         QEIsnhy+ARvucxboKGvJ5QZ4nMx+v+pstI5jNl7k1qQ6L+xoTkzT+ffPYFY/cdNrbZGJ
         rfSFjjKL8P+JyFXmJbiboMCY+4oEwzUczu+6qDQ/RmY++pqsylFDhQmtrAzx2K47zZO7
         mXWjX+c6vU/uBvBpeVwg+Bs53f7aVHJGEkVrYWI6fYGg5PrXtKVbPTvB43CyJji9crTe
         w87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752098489; x=1752703289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qPkxg71a8xKMOk7gRt6YiWOPIe8HfaUrT3StylJgAHI=;
        b=gQJxq5CmUUTVLJeuK02v4Mbj/ZfhlkjT4VZW4/Tqsl7u5usuB4+5dz/ja+GMp/HezV
         XvoY9dvG4t3cvkeKmms8QSwvH3YMRVB5gMJUDjHSa9Y3Ou0BJZLjqOb7bI7dy6SVY00V
         DNVycgKJv0xw3lvSmgYaSrjUvHmskSSICHC1TqO1XYz0XN5J70Y41LB0RwT3tGCZ31V8
         5l0WxbCbo/EjFeGXEkuOp3fEnV7X8Q2Nznne5uRY5jKpuGjxLquof9hRCH5/42lSysY2
         WC8fqTyn9vBOg3C/jutYAGuvft1VyUaZy5mON9de7GryhCCkIlK7Bmdt8Y9X71uJDFfs
         X7Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXW81Oqthc0ighqv4mdBCfchJloANvHyoW87yANbbDcwjpUOCkSTbwLxT+oxewKvpNEzCuybfk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX6pFtJ1uYwLthnn7n/39spSzUeJjXs9CM5ZjCW4uPWn+dZvzk
	2ct5IYf9uuxTzkOksPRCSDtLFMbFR4PuIjQMm8ki4Gk5IPBks1vEGvn7Tvi3flAT5Ra+I1x8Kqh
	to7Y4xw==
X-Google-Smtp-Source: AGHT+IGv5Auh5afur7rrmDtcmRu/ac16McioXeHVJV7IWM1fJ+YSaOB7uGrq5SXWMiQzxRu0kWJqhfgibQ4=
X-Received: from pjblw1.prod.google.com ([2002:a17:90b:1801:b0:31c:2fe4:33b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b43:b0:312:e279:9ccf
 with SMTP id 98e67ed59e1d1-31c3ef100acmr359390a91.5.1752098489536; Wed, 09
 Jul 2025 15:01:29 -0700 (PDT)
Date: Wed, 9 Jul 2025 15:01:28 -0700
In-Reply-To: <20250606235619.1841595-8-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-8-vipinsh@google.com>
Message-ID: <aG7muHNldvv8fRyH@google.com>
Subject: Re: [PATCH v2 07/15] KVM: selftests: Add various print flags to KVM
 Selftest Runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> Add various print flags to selectively print outputs on terminal based
> on test execution status (passed, failed, timed out, skipped, no run).
> 
> Provide further options to print only particular execution status, like
> print only status of failed tests.
> 
> Example: To print status, stdout and stderr for failed tests and only
> print status of passed test:
> 
>    python3 runner --test-dirs tests  --print-failed \
>    --print-passed-status
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  .../testing/selftests/kvm/runner/__main__.py  | 114 ++++++++++++++++++
>  .../selftests/kvm/runner/test_runner.py       |  10 +-
>  2 files changed, 123 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> index 3f11a20e76a9..4406d8e4847a 100644
> --- a/tools/testing/selftests/kvm/runner/__main__.py
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> @@ -64,9 +64,115 @@ def cli():
>                          default=False,
>                          help="Print only test's status and avoid printing stdout and stderr of the tests")
>  
> +    parser.add_argument("--print-passed",
> +                        action="store_true",
> +                        default=False,
> +                        help="Print passed test's stdout, stderr and status."
> +                        )
> +
> +    parser.add_argument("--print-passed-status",
> +                        action="store_true",
> +                        default=False,
> +                        help="Print only passed test's status."
> +                        )

Waaay too many booleans :-)

And they don't provide the right granularity.  E.g. I don't want stdout for FAILED,
I just want stderr for the assert.

After some fiddling, I came up with this:

    parser.add_argument("--print-passed", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="blah"
                        )

    parser.add_argument("--print-failed", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="Full = print each test's stdout, stderr and status; status = only status."
                        )

    parser.add_argument("--print-skipped", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="Print skipped test's stdout, stderr and status."
                        )

    parser.add_argument("--print-timed-out", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="Print timed out test's stdout, stderr and status."
                        )

    parser.add_argument("--print-no-run", default="full", const="full", nargs='?', choices=["off", "full", "stderr", "stdout", "status"],
                        help="Print stdout, stderr and status for tests which didn't run."
                        )

The const+nargs magic makes a bare option equivalent to "full", e.g. --print-timed-out
and --print-timed-out=full are the same.  That gives the user complete control
over the output, with _less_ code in the runner.  E.g. to print stdout and/or stderr:

        print_level = self.print_stds.get(test_result.status);
        if (print_level == "full" or print_level == "stdout"):
            logger.info("*** stdout ***\n" + test_result.stdout)

        if (print_level == "full" or print_level == "stderr"):
            logger.info("*** stderr ***\n" + test_result.stderr)
