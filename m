Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A693C30
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 00:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729124597; cv=none; b=Nr3EWjnejQmhFlomR23Ix7rdJ3mbxuwvF2Q9FbFLJ5HZ6UutYgjBlgoqTwUt4SYQBUbYetBSrCTdqjCTDLesVtL3zDusXGvGDjY7/yz0YDjvXbtapHiVOQaE2/uxDngyTwYeT0At3HJGXm3gD9kbBR5wPSq5FS9eTFtRXbERO2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729124597; c=relaxed/simple;
	bh=5bW49bD+EKSiVYlir+v4FtgYuuOeWvwSTqfDO39iuXY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tg5GwZacj+q+aloaG7TicRNP608fQQrfA9X2uj92q8q1pQsY5BLKKt8jJFPJh2TKKU+jXfIU1fRzXDsZTEezTMH/xazUGZGrnI7LoeTmLPOko6QCSu2cboAgnX5eZ7P5J0j0dRE/1MJ/vvF8azKxTPpIB71cz6e+lQRzKXnSzQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qBqSuZ1Z; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qBqSuZ1Z"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e315a5b199so8334657b3.2
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 17:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729124595; x=1729729395; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BDOAcCratkcKDtlnVKA6PegGNWwglEUHg+hVzvt764w=;
        b=qBqSuZ1ZHvuE0hOPiZcrswiOQ27GYxkEZjU7yv0KMv72tMvuyaMlBT6AxdJX5L7Uri
         tc5+LisJgF5fz9SXBcTo3YjBJUsudmAzQJTczrhE65ZX6fw5SAOvUP34Jnd+GrmKUnyS
         a8AxC8ex7pCG2J8vCbyCnenaIoCkBNIMwCsCG82zbF5oksSHIzxa6ywkcROnhyaPuEGo
         YXj3ZSgto75hgU2uF9BpMZ1vAnidcewP5RN8LR7q/OLiUgKi9BnatI5nmHCCbighEzlf
         xr2YbZZCTu8F+dpVcsgW9sZK5d5QbWc9QjUdU37kNF7wR3QfdGL3EBMbzf2f/pywmehP
         wKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729124595; x=1729729395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDOAcCratkcKDtlnVKA6PegGNWwglEUHg+hVzvt764w=;
        b=sp56w3SKQjjdImylACWkGexFhq07G18Sw5qwGwUb1VM1+jk5W+6NFCOb3VXxW9V64r
         wXqkpPPRYUEiDlqh1/ItrZiS7u7htV5YC9db4JDr2E3+B5heQJ1zjgmlZ4tMkpi+jPNE
         jxk8UIt7gJZ9vvLOlL3ZYLSFRvC/K6B/CFaVnr2mIHyXA0ycOUOj42QoiwVf3c2oTI/H
         7oBl0hHZmn0DCu9uH75HAScVb/0PhRoruPqZS9zEPyLDrTidFzyYMu8sX730/hO1Hojy
         Mocbr7v8Rc+I0hq0ym1LxmHetZtx76CEGSiIP+RIJvQvwhoSUtwDIxuct/Tvg1pjQlc0
         0sRw==
X-Forwarded-Encrypted: i=1; AJvYcCXQz3gGiOUdeu7H3NmNkCrkh/DWSJQP1l4stqdb+MoJRIkSw72HAGYqP1bwUZU48IVRcEqBWNc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzkYVNjQ3O1Y68N5Mvk/sp//EStYDa43WZwHtqvlXJRbLxle8x
	vBUKcz/LW0f9tTPa0sE5//klriWp3aaQEprOXoqevoIO1z6gzbyROQQ8ay8b9FYyqFo/LTvARrt
	FbQ==
X-Google-Smtp-Source: AGHT+IE4l3MvTYNAOyrgYg8GdkVRXTmVWgsHaliM139NqF14S6D92z4C9+5nCmagCDbGXLX8HkyuisI1pSg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:aa6b:0:b0:e25:d46a:a6b6 with SMTP id
 3f1490d57ef6-e297857f664mr5460276.8.1729124594453; Wed, 16 Oct 2024 17:23:14
 -0700 (PDT)
Date: Wed, 16 Oct 2024 17:23:13 -0700
In-Reply-To: <Zw6Svts5hqpIoKwN@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240926184546.833516-1-dwmw2@infradead.org> <20240926184546.833516-5-dwmw2@infradead.org>
 <ZvwWM7rQd075o6nb@linux.dev> <408b137dbf60ff4d189cbd98b7cf8cd833579f61.camel@infradead.org>
 <Zw6Svts5hqpIoKwN@linux.dev>
Message-ID: <ZxBY8S6wO7tymIeC@google.com>
Subject: Re: [PATCH v5 4/5] KVM: selftests: Add test for PSCI SYSTEM_OFF2
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-pm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, 
	Francesco Lavra <francescolavra.fl@gmail.com>, Miguel Luis <miguel.luis@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 15, 2024, Oliver Upton wrote:
> On Sat, Oct 12, 2024 at 10:28:10AM +0100, David Woodhouse wrote:
> > I suspect the real answer here is that the individual tests here be
> > calling ksft_test_result_pass(), and the system_off2 one should call
> > ksft_test_result_skip() if it skips?
> 
> modulo a few one-offs, KVM selftests doesn't use the kselftest harness
> so it isn't subject to this comment. Since there's no test plan, we can
> skip at any time.

FWIW, I have some ideas on how to use the nicer pieces of kselftest harness, if
anyone is looking for a project.  :-)

https://lore.kernel.org/all/ZjUwqEXPA5QVItyX@google.com
