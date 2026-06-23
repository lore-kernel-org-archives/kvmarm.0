Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92ED21255A
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782229643; cv=none; b=borMHQDjHisZOXeAFHUFVycYh254IgCvsnCSfQuNXZieIe2jTeOSrgddqXezSyZcSoIBuNEFm5Q/HnufCpJXi0oG2ZipVPlWnL+4egzBw/SMfVmYVm3Fipkkcn+WF/W7Mw9acc+qgxILqCpSjOtbYwSJLyWcMVxf4C/mMmVQ+nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782229643; c=relaxed/simple;
	bh=I1EaV7xG/mJPqH58Pg0SDLR8MfIr1adiPK+6IK3bIDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lU9xoBnYkfWIGS1wW4rcrqbjrpUiOm8s8yMbGGSMHFhKfEtL7NpR7hdVsrGVPRJjNgpdS20h+DExXOJZIkmkfHmZzaKBFe3sfi0GrGMMA0f6hxAHbxI8pP0ewWx16lNUC4whlHhXLYAg/BMGY/TlJ6HAtXP9pGRY4dc/4oHkW3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Etg/VC8x; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Etg/VC8x"
X-Forwarded-Encrypted: i=1; AFNElJ9DYsOPv2Nxy13yXUMjBAahRoVKtj07NSR7JPWib07WhoEunFSt1XJ2yYjOWSbOE2tLHNRrxdQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782229639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IzQcYtj8kWYNRbeGvvHR4FtJasPw1L4TgvKaoF8K5u8=;
	b=Etg/VC8xvUgF3v2SMh05aVFvI1sRD2ifbm2JYJGFD5kKrelMOf4uJd7MinyGgJAU87yP3Y
	plYYsnx1QIwpojZA98bCJ+z2J7htOpJUPyNess+t6RcGGY0tHkZqA67KV5L5u2qml5vYhf
	BG4+Q+FbhSpnkRCCPyQ3CG8r0vTKkjg=
X-Gm-Message-State: AOJu0YzxE6Pa7Yq7hXan8L01EIc01R128grS3Jii0tZRxEt5uU8p4Wz2
	GZOt7O4/P/1IDbkxCjR1SOl3+jtfrSTp3chG8BmDi2mWeXA6WxAbfeF/PwgvnhPBtsbj7HV9uEs
	m0GKW4UMB4yLMhjjJLiGzkQNdhay+MkvvTuT8Vc/T
X-Received: by 2002:a05:622a:1246:b0:519:f8a0:16b4 with SMTP id
 d75a77b69052e-51a522c6f26mr10190471cf.14.1782229623483; Tue, 23 Jun 2026
 08:47:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260621213155.6019-1-include@grrlz.net> <178222278590.523236.18181071715501850418.b4-ty@kernel.org>
 <CE64C9AC-32D5-495E-B713-552921468FB9@grrlz.net> <CA+EHjTz+oNerTD3Ygj3EzOA4zm4BKfQYM45ydwVO=2amErkBAQ@mail.gmail.com>
 <54A2BB77-5E81-4730-82A1-DB457118784C@grrlz.net>
In-Reply-To: <54A2BB77-5E81-4730-82A1-DB457118784C@grrlz.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 23 Jun 2026 16:46:26 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx4t1zw_C8qd=NVHjCMzBfq9PGJRxGtqDGi5eF7T5nmFw@mail.gmail.com>
X-Gm-Features: AVVi8Cflc8_rf7lxBP42NY_9cWCjn7YBQICKN6FR5h2msr8y21OBnBEdKtU1bzc
Message-ID: <CA+EHjTx4t1zw_C8qd=NVHjCMzBfq9PGJRxGtqDGi5eF7T5nmFw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: account pKVM reclaim against the VM mm
To: Bradley Morgan <include@grrlz.net>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Bradley,

On Tue, 23 Jun 2026 at 16:11, Bradley Morgan <include@grrlz.net> wrote:
>
> On June 23, 2026 4:03:30 PM GMT+01:00, Fuad Tabba <fuad.tabba@linux.dev>
> wrote:
> >On Tue, 23 Jun 2026 at 16:01, Bradley Morgan <include@grrlz.net> wrote:
> >>
> >> On June 23, 2026 2:53:11 PM GMT+01:00, Marc Zyngier <maz@kernel.org>
> >wrote:
> >> >On Sun, 21 Jun 2026 21:31:55 +0000, Bradley Morgan wrote:
> >> >> Protected guest faults charge long term pins to the VM's mm. Teardown
> >> >> can run later from file release, where current->mm may be unrelated.
> >> >>
> >> >> Drop the charge from kvm->mm instead.
> >> >>
> >> >>
> >> >
> >> >Applied to fixes, thanks!
> >> >
> >> >[1/1] KVM: arm64: account pKVM reclaim against the VM mm
> >> >      commit: d098bb75d14fde2f12155f1a95ec0168160867ce
> >> >
> >> >Cheers,
> >> >
> >> >       M.
> >> >
> >>
> >>
> >> Hey, which tree did you apply it to?
> >
> >https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/log/?h=fixes
> >
> >/fuad
> >
> >>
> >>
> >> Thanks!
> >
>
> Thanks fuad.
>
> May I ask if this would be put onto ACK?

Yes, I'll pick it into ACK.

Cheers,
/fuad

>
> Since this affects pixel devices.
>
> (E.g, my pixel 7....)
>
> Thanks!
