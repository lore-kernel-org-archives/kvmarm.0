Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3BB48033E
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 14:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787669228; cv=none; b=kFg0K+iF694YG+AK4val/76msamlAo0uSZ8MdjWSAQkCY24MRejZBZGQJJd3dRR1T/RJt2jJuZHpOmGKjQk+u1aBzi/6tLvfI5UzJXEuWjOWOqMVOgdJ2Yr6hfiNQMgMqoJVPKCj9qcy7QElseFypRIY04z6VgsfSlknE9Po4hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787669228; c=relaxed/simple;
	bh=0TFZjKRxbYc4+FJR8PgySJ9w/WGb5uGwbC5pPWd/UW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VbVnUnlVvmasvn4RQfTqr8xbxQU6LvMBkoVicfLzuyu4NEvl3BDdwIvaZCkKVJ0gdrh0Q+cgAErogtJHzfADO9RRB4dH8YokhQT72wdNRVZ4lsUF+2WL3cZT+d3NniyOFIhQgf3UK70Py6uOX3B6taFsT6m9x/btobiYsbserAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MuTpbfyW; arc=none smtp.client-ip=91.218.175.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MuTpbfyW"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0TFZjKRxbYc4+FJR8PgySJ9w/WGb5uGwbC5pPWd/UW0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787669222; v=1; x=1788274022;
 b=MuTpbfyW2mOtsFZ3F535tLr556VN27Vv3Ga6AyBijJ+Wcz8u63Zylyi+GGDna+v5Q0YDiSZn
 Zkgi3ci4VsTqwSK4zBlqMRq1HJTysFzeZcC8LGtenVuXauCoB8MCxEbDzwEE62qk1URyj3fSDPF
 OjzDOFvGZoPO6mVhnawWTD+c=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f47.google.com (209.85.167.47)
	by smtp.migadu.com with ESMTPS id 26ea7f16dca978ac;
	Tue, 25 Aug 2026 14:46:52 +0000
X-Mizu-Trace-ID: 26ea7f16dca978ac
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b2a8173142so3701e87.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 07:46:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq5OlKJklV38wb7YzKOgNg1rH96hthAe7+qVI1+Zy/Xd5DcvrqlYmlun8xTumwkXcDeNI+l4bo=@lists.linux.dev
X-Gm-Message-State: AFuF++klYOU9Y39bu9Q2wuRtYD7WDU8T5tFn4FCL1zi+OpewaAiQ5Z8z
	MvoZHQJgAqwR3XQys3Ki1+10uGgOQFzCzxP+JrNHtaMQSf5YyMqMg89HaFTM4NSF88/65TumZQ1
	mrLHfc3knUOXcjhT3+dKfXSgUrL6geizqoAXR0Y7F
X-Received: by 2002:a05:6512:3049:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5b49de6a523mr92553e87.8.1787669211662; Tue, 25 Aug 2026
 07:46:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260824184155.2644646-1-fuad.tabba@linux.dev>
 <aoypji6EJ8zToWvh@arm.com> <CA+EHjTwueqEAVq-7_ioRN+1h3LNPAqHX3rTqbXODViJJM-D_pQ@mail.gmail.com>
 <ao2jNDv8tOjnimEH@willie-the-truck>
In-Reply-To: <ao2jNDv8tOjnimEH@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 25 Aug 2026 15:46:15 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx93ERXZV1visdfBOGtH7wHff6TAoeJe+pNtikPrRp8Qw@mail.gmail.com>
X-Gm-Features: AcwNN1UXT1Fu6A7fHijzE1Tq--IpkMbS8FLzylOjcibifcf5PlkAtmwgTVzAKGk
Message-ID: <CA+EHjTx93ERXZV1visdfBOGtH7wHff6TAoeJe+pNtikPrRp8Qw@mail.gmail.com>
Subject: Re: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Aug 2026 at 15:14, Will Deacon <will@kernel.org> wrote:
...

> > Agreed it's separate, but v3 applies the override without checking
> > that the CPU has MTE2, so id_aa64pfr1.mte=2 on a CPU without it reads
> > a GMID_EL1 that isn't there. On the boot CPU that's before the
> > override is sanitised. Should I check the raw register before applying
> > the override, until the clamp lands?
>
> At which point, why don't we bite the bullet and implement Suzuki's
> idea so that __read_sysreg_by_encoding() does what you want more generally?
>
> https://lore.kernel.org/all/afc5bd00-28ca-413b-b047-ee53589c285d@arm.com/

v4 will be two patches: Suzuki's clamp first, then the GMID_EL1 gate
on __read_sysreg_by_encoding().

>
> > > If you are worried about additional trapping of the MRS, we should go
> > > for Will's improvement to always read the cached values in
> > > __read_sysreg_by_encoding().
> >
> > Not worried :) __cpuinfo_store_cpu() has already read ID_AA64PFR1_EL1
> > a few lines up.
>
> But if you go with __read_sysreg_by_encoding() then you'd still be
> reading it (and trapping) twice, no?

It would, and I'm fine with that on a CPU bring-up path.

Stay tuned!
/fuad
>
> Will
