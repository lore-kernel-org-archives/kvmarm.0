Received: from out-164.mta1.migadu.com (out-164.mta1.migadu.com [95.215.58.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956A6369D40
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785868315; cv=none; b=nGp/PL9/PRigXihmS+GAEjDnjJW4CbDbwp9UH9RgIGS4vgLNkRzgNsXowz60gRfrbbDG3qPHo34VA42sAva3bmKcsT+xJXeFEy/2Rt31Kg15W2ctfODTm63955EqweUkhycndK6heB5KJ6Bh9SgKlfPWp3AS/Dj/1HK7jOjq+/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785868315; c=relaxed/simple;
	bh=PHqQmXEan2rhtVIJXjb8SeztqZQ/bWJotIQzmRcz2qw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KXK7gVEC1viVB1cla0WfxsaR1dhi9Rdd59v8X4oSk86KcygH3A/3ldFLFkN9vjwrcZfvFhuEpX28ukAF71P83z8/dJYE9wWzJQF8U2vPfCORs4VaWfwUxFngceg4xG3PAhOsvhpzhRIIMINrkkTLPwWc36sBMuH76cl1uIkTXpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JCwrTOLh; arc=none smtp.client-ip=95.215.58.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JCwrTOLh"
X-Forwarded-Encrypted: i=1; AHgh+Ro51qR1d3uRQPqZscNWxpZT8sGNfm2vQ5YmGBigqIEh8DeaIL8jt8YfDwr+gU5wSn1govML5C0=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785868311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EKk2rwqNObSX29y7QODtlnhHJqRzSQBC3KX0AgTlwX0=;
	b=JCwrTOLhrTUdD3Qpp8Kp6VzfvVtVkLLcyF1qHph9ICehCPs/Rtn9OAIsJBiLc7g3uAW1Nq
	xCjjElacDIsYst0vRgoY3Hlrg7E7SmgVZR1xxyHcmI2CgFoVjXw2onF9oKFod9FouQytAw
	TOEQNojOmBu8nA6kWmfMrQxvWe+52ts=
X-Gm-Message-State: AOJu0YyZDGXriR3IPKgHCYsR58YzLGww139Z+8QZEnv84eWBa/qGjb0q
	KWZf1UJwD5z6IXEJkp9En5fAqVovACXfcyCjoxwB5uOFg8PJSw1v8f4Uvm+6bZNXfnlLBlFef2L
	w4VBuqXXTfXJ4NSKG9MyRvb5JGb1NW73OofTMuPH6
X-Received: by 2002:a05:622a:e09b:20b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-52ce693a6famr1913531cf.2.1785868280864; Tue, 04 Aug 2026
 11:31:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260804092421.1728880-1-fuad.tabba@linux.dev> <7e660a4c-af62-4751-a8cf-49151054f0df@sirena.org.uk>
In-Reply-To: <7e660a4c-af62-4751-a8cf-49151054f0df@sirena.org.uk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 4 Aug 2026 19:30:44 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx9iLrnnaEVzV=3B+22bhh0DsPZRrBPvB6ZUT_CV5DvWA@mail.gmail.com>
X-Gm-Features: AUfX_my_-8pjyJaz0sfztFQlFvVHxrkE_nbOMypqyMRvyIlCd3fGeHs44ANLYm4
Message-ID: <CA+EHjTx9iLrnnaEVzV=3B+22bhh0DsPZRrBPvB6ZUT_CV5DvWA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Check ID regs are immutable after
 a failed run
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 4 Aug 2026 at 19:14, Mark Brown <broonie@kernel.org> wrote:
...
> > +     if (!found) {
> > +             ksft_test_result_skip("%s (no immutable ID reg field to test)\n",
> > +                                   __func__);
> > +             kvm_vm_free(vm);
> > +             return;
> > +     }
>
> All test result reports for a given test should use the same string when
> reporting so that automation can figure out that results for a given
> test from different runs correspond to each other.  It's better to print
> a diagnostic message, then the ksft_test_result_() with the result for
> the framework.

Thanks, will fix in v2: the skip will report under the same name, with
the reason as a ksft_print_msg().

>
> > +     TEST_ASSERT(r < 0 && errno == EBUSY,
> > +                 "ID reg write after failed first run: r=%d errno=%d",
> > +                 r, errno);
> > +     TEST_ASSERT_EQ(vcpu_get_reg(vcpu, reg), val);
>
> > +     kvm_vm_free(vm);
> > +     ksft_test_result_pass("%s\n", __func__);
>
> Mixing TEST_ASSERT() and ksft_test_result_ in the same test program also
> interacts really poorly with automation, TEST_ASSERT() just kills the

Agreed, but it looks file-wide rather than specific to this test, so I
would rather leave it to your series than convert one function. Happy
to follow once that lands.

Cheers,
/fuad


> entire program so no result is reported for the actual failing test and
> any tests the program would attempt to run afterwards also vanish from
> the results.  If the test program is using the kselftest framework to
> report tests as this one is it should report the results via kselftest
> framework.  A better pattern would be something like:
>
>         if (r < 0 && errno == EBUSY) {
>                 ksft_print_msg("ID reg write after failed first run: r=%d errno=%d",
>                                 r, errno);
>                 pass = false;
>                 goto out;
>         }
>
> ...
>
>  out:
>         kvm_vm_free(vm);
>         ksft_test_result(pass, "%s\n", __func__);
>
> TEST_ASSERT() is a good fit for tests that are just one test case per
> program, then it plays nicely with tooling since the tooling just
> tracking the executable result and any output is diagnostic logging.
