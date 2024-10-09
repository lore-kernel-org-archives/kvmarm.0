Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537C51714A4
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728502596; cv=none; b=nYEG2CZDhSuWvhQWuii+9dIjzkM9pwYm5D7q1dadKBozab8n7nsBKQ3ZDjIvdNbBl1O1+9ljQzt1SV239B6CViuUusSU9tYSXrNHEZOpPun29WJDcgsEA/57mcXr+C0eA1QpglgMjNKEC/+fZrz7dkdYM8RHG5llqQt04MvlBWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728502596; c=relaxed/simple;
	bh=tNX0yHtSx+2bxwChEjYCuylXCXHmQGQooGsI3FLrVUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=erUZAjUBJHyf+SLI8eoH8YgcZfhap/K8Z0+uiTTpvxNQMPHzudpLNblX16exwB0mlBxAG9Pt8qSc4yjPEL0R+9+QKBveda/CyhR8IDB87k4W2SHSXWK9sJx6JvXUw07tqfUb1bdqR35K6u7k+OnZc4vQPGM4zWMupw9hZopU6B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ABj+ArbY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ABj+ArbY"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7e6c40a5795so147315a12.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 12:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728502595; x=1729107395; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=knTcmc30pJl7doPnC19XGWX1FZIh862B8t2b0uPBIZw=;
        b=ABj+ArbYZetORZcGK4T248XAACS5JHio3LRTPSofi5C3dwu0SXSMm+VZXIYgmRQcfZ
         zgjTbZmif3WDfRzn2GWP/xjX/I9tvyi4D4k5m8RXVgzh9me7jjllE6mN/rmv8cwMGf5N
         aKSm72Hi8JLgVYA3RNQpmwMkODkQgbnIDo1VrT0fGDlTnRtbgvEYtNx09lbh6MfCU7s4
         lkfnXsIL/uDBF1h2fKifDhhudf+5ui8FX7ZGnTCrjWghR6BDUzuVQ9g8wSd7A+ZrQMck
         HrAA+gRl0J9HIo7X1ajD/MuvFtkP5MDW4nubU1sCFI6aoxohjY7Vyq2YGNNI3n+zZwe7
         Ec2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728502595; x=1729107395;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=knTcmc30pJl7doPnC19XGWX1FZIh862B8t2b0uPBIZw=;
        b=hB+1di6z5X/lHSNjQHEOrFbJh9kadDVkDM0yKrBGtILionIBYD2gtTNKzuIkTKt0Xf
         1UUDFj9jOWyrRpMWkN0Q0RIh+qL47Hw1vswTSfZC0rBtZvhS3ZtjbaEZ2oQHtn9lsHIA
         kASf4emAuM/kJ4eK1o1WZMvlU1iI7qsmD0lM7jdCP8dxsMmMyqq6/+C0fDmxUJk/zlqz
         sfi28sni8ZSftrrH7BWf/99HDptSVgMULSHFTDUXPOSVYaRSndU45U/R+mLTK+HVBQB0
         YSxGlOKDjWGpvGw5H9pJwRrG/TujgSMzbEnzXQ4agoY+PbOR5gNZ6wwz+fwdenFyyiuW
         5Gcg==
X-Forwarded-Encrypted: i=1; AJvYcCXUZPcfoqpcWvI18hYs5pEfbSaq9VOBPemjlPAJ6YrjVF8jSsgtqU5VHCX5uNnx0lJ+N+Wmd0o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQKbiYn6PKwRHtMw6URTldepciR24IxcaMxhgLyVLK1zJwgyEz
	w9MBF3822q/rDSYoX8QiXDf10OLQZKDEuiaveaaubtiMJ72lN92axutk2aOQ1FAR2KDd8FpqR5B
	9Rg==
X-Google-Smtp-Source: AGHT+IE6qbOZPjiPveauyRffk0TGKVOavv6JppsyQWCFko9+4i4AfWEW7C4di+OyANJtEcVOmeGbBoaiQLU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:5a46:0:b0:7db:539:893c with SMTP id
 41be03b00d2f7-7ea320ea266mr3439a12.9.1728502594375; Wed, 09 Oct 2024 12:36:34
 -0700 (PDT)
Date: Wed, 9 Oct 2024 12:36:32 -0700
In-Reply-To: <ZwbYvHJdOqePYjDf@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009183603.3221824-1-maz@kernel.org> <ZwbYvHJdOqePYjDf@linux.dev>
Message-ID: <ZwbbQGpZpGQXaNYK@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 09, 2024, Oliver Upton wrote:
> On Wed, Oct 09, 2024 at 07:36:03PM +0100, Marc Zyngier wrote:
> > As there is very little ordering in the KVM API, userspace can
> > instanciate a half-baked GIC (missing its memory map, for example)
> > at almost any time.
> > 
> > This means that, with the right timing, a thread running vcpu-0
> > can enter the kernel without a GIC configured and get a GIC created
> > behind its back by another thread. Amusingly, it will pick up
> > that GIC and start messing with the data structures without the
> > GIC having been fully initialised.
> 
> Huh, I'm definitely missing something. Could you remind me where we open
> up this race between KVM_RUN && kvm_vgic_create()?
> 
> I'd thought the fact that the latter takes all the vCPU mutexes and
> checks if any vCPU in the VM has run would be enough to guard against
> such a race, but clearly not...

Any chance that fixing bugs where vCPU0 can be accessed (and run!) before its
fully online help?  E.g. if that closes the vCPU0 hole, maybe the vCPU1 case can
be handled a bit more gracefully?

[*] https://lore.kernel.org/all/20241009150455.1057573-1-seanjc@google.com

> > Similarly, a thread running vcpu-1 can enter the kernel, and try
> > to init the GIC that was previously created. Since this GIC isn't
> > properly configured (no memory map), it fails to correctly initialise.
> > 
> > And that's the point where we decide to teardown the GIC, freeing all
> > its resources. Behind vcpu-0's back. Things stop pretty abruptly,
> > with a variety of symptoms.  Clearly, this isn't good, we should be
> > a bit more careful about this.
> > 
> > It is obvious that this guest is not viable, as it is missing some
> > important part of its configuration. So instead of trying to tear
> > bits of it down, let's just mark it as *dead*. It means that any
> > further interaction from userspace will result in -EIO. The memory
> > will be released on the "normal" path, when userspace gives up.
