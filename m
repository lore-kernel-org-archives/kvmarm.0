Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF611F4E25
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 13:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440911; cv=none; b=FfpS9q0hS+QJGPPiQuSE+tYLb1qAXVjfsUWkPFyffVYytDSc+FGD78LTMMX77Wru53HmrAuZcN3PRyi8Vici7ERWvuMST0jdyVsSK2wtUqoOlr3Y32YAZv4kQ0PcYDPMpX1saUItXUdgGTmWeF5ttzXTBCjOhLhOYhnq4DbUbAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440911; c=relaxed/simple;
	bh=A15dhjFUApKDLBTkWTdNxfsteBwmhP1rdtBlLWCGnlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qsl0I8JYyM1qEuE78xUjQjVIkNioyYLPaAGNRdl2E6voxCO2Zb/xFMMYDYy9gPhf4jGKEklUNzweLyt/0axJmc9GWE1l8pLzBOszcBTKs4IpO3YrpUz7flcJKhxaibp+fBUDiGquTxBpDrS0dn5bZ5ffSFqPG1knzzkQWPI74wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yEnrOWYy; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yEnrOWYy"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3d0205bd5so7506938a12.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 05:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734440908; x=1735045708; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c8OYND6fn7kYwT+1ERcVanRX0/dhZjw7OVtcr6DSH24=;
        b=yEnrOWYyiYofR+xG8rXRY0M17zxLO3rcOCcbyEy+la21+DC4tHJuyhogCd2Oc/3FIi
         zTu9PxOdAVFDmY1dBoBfakPLLXhZho6JQzUkqcBVuyuEAWcMb0V8cFORBEeO++21jFPk
         B9H5DriFNwEA6+KGrGzqdhct5f4tPbp6tTPWtY7I/asmjkiMFb9ItzyADlH18M/yB+HH
         nyUBBJcKcx49Li/XC58j+IZhxPs4+pvozN5XR030CfhOiA4HtW7+A5LiUX04XF5vTN+7
         m+EVmJ6eo/tgeO+aFUfIR4ibcu2wrmawwxrXw0cxvFRW5yjy5dFYKOKe0LYggfmkHNPt
         eO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734440908; x=1735045708;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8OYND6fn7kYwT+1ERcVanRX0/dhZjw7OVtcr6DSH24=;
        b=omRXX4641R+e46ZfKAoWD7kcmq1WJLWnWatgm87qjjxmRwfw9tqmnkvhH38FLHsOXj
         T0ne/w9fYMpZ+/TpmuB5jE6cQcAUIFyZ1bKH12Ysw6RlqrmrgJ0nWoaZtZXe9vUusX3/
         gGr7vryp83yBTIwnaf2TqalmVQzIYJrblWRBrWqG6SDA3BKpQYUY9IuoR83VT0R1aASq
         cijPr4BGLIhnbeh3MTEhMU1VR8+cXUdTSbz8rIms49AF4TF5M8XslhpYhisLlWobyAxO
         mbJPNCLScIwPY38YB2x1gWTO/6NCRPMPkMnT8SmfKsLv5j6nSjED6wX7h9r+RNxVESQl
         lXxA==
X-Forwarded-Encrypted: i=1; AJvYcCX0XGgFJ23C24ivx+RrVfAfgGgAINjMapYNbtw/o0BkIsRHKHAVnEHftGI+iWg8Xj0pbce1S5w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxpDaS9t+qbHD0Z3K0hw412X0eoYp6sdRK5XLDHTcq9j+QnKR2O
	sf6xd+JsWUrD+CxLGw5uBRGt9N0uWZx8ZQzBpe7l0/wpFJC67XcZl0qSe/fxdw==
X-Gm-Gg: ASbGnctIimBHAJmr95W5bfDKmxqXz8azvIERpGE5z3elb21OVeP1/LpIFRlaFi1R0Ja
	/I87vJpWXcnR99S26ldxHMQlyb+pWLa8FOSfdq5hJVz7GL3fwQKrTJ6pFSYdT/2mVhA9OSkdljK
	kl2+QkjxEvklXSxjDN6jM2eKMqZaRu9l5lYqSh8RnpwKDqw8kC9RQCjob8I3vcxNDnlB2EXpe0K
	NOWCY89OBq3G/6ahA3CJ4NmGjtYcRCz2epK6IPe6+ECBrdgghsFdiV5KDX1hMioYRZg2MrJ5KMB
	qeL8b/BR3GoOmBQ=
X-Google-Smtp-Source: AGHT+IHU4tb4zHbFKvDOUJ9Ob7TRBXCdnvvA1xIyi35Z/f8YS65dxxBPeEBOCyi0d2KP9W+sPCa32A==
X-Received: by 2002:a05:6402:2690:b0:5d0:cfad:f6b with SMTP id 4fb4d7f45d1cf-5d63c30684bmr14855753a12.11.1734440908222;
        Tue, 17 Dec 2024 05:08:28 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d7c043e7d7sm2050482a12.35.2024.12.17.05.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 05:08:27 -0800 (PST)
Date: Tue, 17 Dec 2024 13:08:25 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/18] KVM: arm64: Make hyp_page::order a u8
Message-ID: <Z2F3yY6DwUBmTtnr@google.com>
References: <20241216175803.2716565-1-qperret@google.com>
 <20241216175803.2716565-4-qperret@google.com>
 <86zfkur329.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zfkur329.wl-maz@kernel.org>

On Tuesday 17 Dec 2024 at 10:55:58 (+0000), Marc Zyngier wrote:
> On Mon, 16 Dec 2024 17:57:48 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > We don't need 16 bits to store the hyp page order, and we'll need some
> > bits to store page ownership data soon, so let's reduce the order
> > member.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h |  5 +++--
> >  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 14 +++++++-------
> >  3 files changed, 13 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > index 97c527ef53c2..f1725bad6331 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > @@ -7,7 +7,7 @@
> >  #include <nvhe/memory.h>
> >  #include <nvhe/spinlock.h>
> >  
> > -#define HYP_NO_ORDER	USHRT_MAX
> > +#define HYP_NO_ORDER	0xff
> 
> nit: (u8)(~0)?

SGTM.

Thanks,
Quentin
