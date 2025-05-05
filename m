Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB29B2D9989
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 22:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485841; cv=none; b=Tfag4bVrv6M2TsJAzTMHmJGPEP8QAzHP1JTeS04HVCtQacXcbl4tRo1Yfc5qQ+cE8aY0c5Lb6cMbikeH0QkbvsL1NUwjhddhocie1p/fsKpanM+5MnVBn3leWEAfT2G9VUZzIUR8dX5OVHgXpmloOReTZOetTHMX6fMhuy9hy4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485841; c=relaxed/simple;
	bh=qL9kqWpZtyzUbBfVfilzB5IvxTSPW+Sb2IbeCYPr8WU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dr919rhsIASHqNg+wiPYUVyqYwKrSlRVqc5NqkFIfOB0l4cfgrrRKij8u4fXp3peFA6hpuoWusbxVfU2Qlw/DLnEHBmkiX93E3Ebqb28Tk976ks+pL6hIHvR/hyloe7HMjtAnmTwcWAIuTfVfvDCPrXTZZ+ROpWX5aQgNjaycqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x3Fh/7JY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x3Fh/7JY"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff68033070so4539256a91.2
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 15:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746485839; x=1747090639; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7fTVD9mhjVGVNu76WgrWlRxCFOQNPlvAmlBjEqJWVdA=;
        b=x3Fh/7JYDO8JM3gogoH/kdbUrg5l3h0JFNQpI5fgEcd0a7qZiqLpl8CdKccUKVXFzU
         oJUUNaBeKktnkTg7etDhyIJnQaKiIFYUZivuo5+Q5RsuD7jkQC0Ld1RvAeqeeqHI3ohv
         tDC2+rN/5eVwJj54kK7ruIn061SL4LIDaBr7IFdqyN5mkjhggYL++9bEASfngo2NVrHv
         koQmaY9iI7VvSQPoJ8UuuPlYa8Amwlv8aKBQeC0WIWIK/4ibvStnI2FJtZiuaFA10qhJ
         N+alWZDwDsXHfCMpRbK/J73PhHG5gQXj5Id+z0f4QOxF1bGGm5bwHTeFSnU25VZnGib8
         P5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746485839; x=1747090639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7fTVD9mhjVGVNu76WgrWlRxCFOQNPlvAmlBjEqJWVdA=;
        b=dvtyMpvDn+OC9Wv8K+0iDrR8yvaf+aNObBbYCmEZ0Zg9X3bsyzapE9tyEluEbQ4DmV
         ancZj2vdhUP9vcOvw+/gvgfzsjeFfNRW6P8CYjqa5phu2LX2P23OtHSXhiwcXCFN7E3S
         ESz1hscOh8z/OpE0YZqaZaOSrpzEZXF5ufYzTPldZYcFVw7wx0fCwXz/N4C0tn9VVdhm
         t3XBT7iTwGD/LzU6KzW2HRFELNUnl1bQmjwHLGqaSHT5bvX0cLBbbwizZ84Kq3V7T64c
         a7D7IpgZYPBNlj62s+rrzeOh/uv0+vxnbqJR+Rad+xyc85PoHI6gKgu0MPlIC7IAEEJ9
         z7Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVxLI+Vvn994p8sihfC7oY69fsLJde2jTO1AduNnF3LNNyRKyYcgr5whcPjYPk1t3EKuymYrY0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4WT4hstT9fomgnJrVm/DT/2q24/WTWUCWKtD/m70FHTNu0h1J
	1oGA0K/t4KzTn//56h7rSKzgxFXphnOk662k4M8T46Dw3umRSgQIXSDIJfLA1PUieTQFWTg1utN
	1Nw==
X-Google-Smtp-Source: AGHT+IG+bLbnRwKacBdwKEqb+ZlVouYwYu6ROj9LxnI6DWLtn5iDtn6cjFYO/W3uF1RtCR2hFz2sG6ty2pQ=
X-Received: from pjbqn16.prod.google.com ([2002:a17:90b:3d50:b0:2f9:dc36:b11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e4f:b0:2f9:c139:b61f
 with SMTP id 98e67ed59e1d1-30a4e5a608cmr23836495a91.14.1746485839174; Mon, 05
 May 2025 15:57:19 -0700 (PDT)
Date: Mon, 5 May 2025 15:57:17 -0700
In-Reply-To: <20250505190538.GA1168139.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250222005943.3348627-1-vipinsh@google.com> <20250222005943.3348627-2-vipinsh@google.com>
 <aBJXabTuiJyRZb-O@google.com> <20250505190538.GA1168139.vipinsh@google.com>
Message-ID: <aBlCTfAlKOWG5orI@google.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Add default testfiles for KVM
 selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, Vipin Sharma wrote:
> On 2025-04-30 10:01:29, Sean Christopherson wrote:
> > But, I do think we should commit the default.test files to the repository.  If
> > they're ephemeral, then several problems arise:
> > 
> >  1. For out-of-tree builds, the default.test files should arguably be placed in
> >     the OUTPUT directory.  But if/when we add curated testcases/, then we'll either
> >     end up with multiple testcases/ directories (source and output), or we'll have
> >     to copy testcases/ from the source to the output on a normal build, which is
> >     rather gross.  Or we'd need e.g. "make testcases", which is also gross, e.g.
> >     I don't want to have to run yet more commands just to execute tests.
> > 
> >  2. Generating default.test could overwrite a user-defined file.  That's firmly
> >     a user error, but at least if they default.test files are commited, the user
> >     will get a hint or three that they're doing things wrong.
> > 
> >  3. If the files aren't committed, then they probably should removed on "clean",
> >     which isn't the end of the world since they're trivially easy to generate,
> >     but it's kinda funky. 
> > 
> > So, what if we add this to auto-generate the files?  It's obviously wasteful since
> > the files will exist 99.9999999% of the time, but the overhead is completely
> > negligible.  The only concern I have is if this will do the wrong thing for some
> > build environments, i.e. shove the files in the wrong location.
> 
> We can get the current path of the Makefile.kvm by writing this at the top
> of the Makefile.kvm:
> 	MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
> 
> Then MAKEFILE_DIR will have the source directory of Makfile.kvm and
> testcase will be in the same directory.
> 
> With this we can modify the below foreach you wrote by prefixing
> MAKEFILE_DIR to "testcases".
> 
> Does this alleviate concern regaring build environment?

Yeah, I think so.  FWIW, "concern" probably isn't the right word, more like "the
only thing I haven't thought much about".
