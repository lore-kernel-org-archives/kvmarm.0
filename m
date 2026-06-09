Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01071331ED5
	for <kvmarm@lists.linux.dev>; Tue,  9 Jun 2026 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781027860; cv=none; b=mXkBdXjGN0rkE13pbK0QGqhlSbD1GbXnwp15l/DesQSrB+uCtbRYVZtQ9QZ+lJGZ9ZUJIj2/BaXzTRz0FtCvrMIT7IJlvgKDtVKgfDZ4YBmrSS4kAzCfITNpAJheDRXTj0aoEEfS5bK7wriR8orZhr4FTUSEEUWcp0oXVTuSRcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781027860; c=relaxed/simple;
	bh=4aSgkWUhPzx8K4/mClsjqZv3PnnYgZuNJSn0DMQeoXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d5OBVcI6WhlgrxHZzmDv6/bnozd+DyotqfHnoCX5wYv1AvFnGD60yVDOOMAu15q4IwPctV3h61hxaqXODtFBGq9Sf1RI8fYhrVwkjjkNG4aIej6yaIfcPLlHkjwFjjBSnNHjTDvXyJhiRWaimIgSNYQGx4m7PQ7+SpjP69+9smM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LN/tXPw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LN/tXPw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB36E1F0089A
	for <kvmarm@lists.linux.dev>; Tue,  9 Jun 2026 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781027859;
	bh=4aSgkWUhPzx8K4/mClsjqZv3PnnYgZuNJSn0DMQeoXY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LN/tXPw8AXNYmFuAjkSA7IVKHeFaZ05LF1royqZl9sc1zcIoamIT+zZtZ1WVFqRa2
	 D+ICBldMrN/b1bC4KA7owAgjiEzBwlTMuaGBPqBKaOwCCwofdFUG543t/jvahPomwH
	 F3o7Dvpj3oLQQqTFQI5fr67OvEfVEQwQYtrXchKwxwJjJzONw7Mv0oRFokR7bmed7z
	 pucShdDe481EdQuxZ6O8iZzcRREpT7k4d+qBjByMUtVMNiHUqGH1P7/LE7hwsF4cxF
	 zz52MWE3dFrnrOdIWmGW8BDeWVCmlrDekijIq6xc6AcSJYbR/EGD3w4pxRP3sXk//o
	 55a+inVeDEt9g==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-68b482888c3so9336327a12.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 10:57:39 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzq6qyo4ihEc5d9zMi3+9ATEkuzlAxBSzxdPz5uc0pl7scNaMD2
	Eo0HV+oqXkKPm8X+sanxJEC7DRl/xjTLqxCwtZoR4uhWwhOOz2Dot9USpxt86kx2IDRbYiObmA7
	XxGowl9zcADq7kV+R/nGTkdsL3uvtjeE=
X-Received: by 2002:a17:906:d550:b0:bec:1632:eceb with SMTP id
 a640c23a62f3a-bf3a840d8bcmr919741066b.19.1781027858565; Tue, 09 Jun 2026
 10:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260608081108.2244133-1-maz@kernel.org> <aicqzM4W4NN-GndT@google.com>
 <86ldcotbub.wl-maz@kernel.org>
In-Reply-To: <86ldcotbub.wl-maz@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 9 Jun 2026 10:57:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMpvxoVcDvWn3q0C0Dv=0Kknt_BqZ8KqddwuKa5bd44Dw@mail.gmail.com>
X-Gm-Features: AVVi8CcBbJljDF-ob_nMqw_7wUVvIUirAOYqofuY07VBH15GCgGGqOLIaMxlMSM
Message-ID: <CAO9r8zMpvxoVcDvWn3q0C0Dv=0Kknt_BqZ8KqddwuKa5bd44Dw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Hold kvm->mmu_lock while initialising vcpu->arch.vncr_tlb
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

> > If yes, I think the code looks confusing, at least to a layman like
> > myself. It initially seems like the lock protects against concurrent
> > initializations, but then the NULL check is not done again under the
> > lock. The goal of the lock is not clear without the original report.
> >
> > Mayeb it's clearer to explicitly use barriers if the goal is preventing
> > reordering?
>
> This would require both the initialisation of vncr_tlb to use a store
> release, *and* all the other call sites to use a load acquire.
>
> I really don't think it is worth the churn, nor the (very small)
> burden on the readers.

That's fair. I was mainly just pointing out my initial confusion and
that others may share it. Avoiding the churn on the readers' side is
understandable. Maybe a comment here would help explain why the lock
needs to be held?
