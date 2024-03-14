Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B008D6CDC1
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 11:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710414560; cv=none; b=M2HqhMXFTYX0s/MaE+VP/jk/rpf5fB41h3/yEFLPSt8Xt2hXzjvSSKejSCYWH384fVkMsUkw/0iQx3BgEsT6G9YZ2uHCvfeTwx56Jeq6Wc6SLUYOo3XxvkIVq/sk4HVVGDShCTCKDBfbhCNi1xdVRXvvZjMPnH/+97HzSMneNLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710414560; c=relaxed/simple;
	bh=6BdARhoBU9tqSp7ir1itHAMzpT4LjrEbo4TEjprV4zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ag74PdRG98i9pfdOBdGqaJXNgFydSiG3n48WVFk9KdRtPQOlyB+LeHp5Ezu6WDUBUEdN9k4p4/3WlpZSW5OHVVWYdN2IxsABsgy2TnP+zvXd5KZuAsBqs0t5PWDpf1hdhkBMTaoACCZVD+xcEGJbOh3Dpe6kU3+a2wJa2FPD+v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15778DA7;
	Thu, 14 Mar 2024 04:09:54 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 929A73F73F;
	Thu, 14 Mar 2024 04:09:14 -0700 (PDT)
Date: Thu, 14 Mar 2024 11:09:11 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] arm64: Use SYSTEM_OFF2 PSCI call to power off
 for hibernate
Message-ID: <ZfLa1_TWArT7tCtb@bogus>
References: <20240312135958.727765-1-dwmw2@infradead.org>
 <20240312135958.727765-3-dwmw2@infradead.org>
 <ZfB7c9ifUiZR6gy1@bogus>
 <520ce28050c29cca754493f0595d4a64d45796ee.camel@infradead.org>
 <ZfHHlBgSNr8Qm22D@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfHHlBgSNr8Qm22D@bogus>

On Wed, Mar 13, 2024 at 03:34:44PM +0000, Sudeep Holla wrote:
> On Tue, Mar 12, 2024 at 04:36:05PM +0000, David Woodhouse wrote:
> > On Tue, 2024-03-12 at 15:57 +0000, Sudeep Holla wrote:
> > > Looked briefly at register_sys_off_handler and it should be OK to call
> > > it from psci_init_system_off2() below. Any particular reason for having
> > > separate initcall to do this ? We can even eliminate the need for
> > > psci_init_system_off2 if it can be called from there. What am I missing ?
> >
> > My first attempt did that. I don't think we can kmalloc that early:
> >
>
> That was was initial guess. But a quick hack on my setup and running it on
> the FVP model didn't complain. I think either I messed up or something else
> wrong, I must check on some h/w. Anyways sorry for the noise and thanks for
> the response.
>

OK, it was indeed giving -ENOMEM which in my hack didn't get propogated
properly 🙁. I assume you have some configs that is resulting in the
crash instead of -ENOMEM as I see in my setup(FVP as well as hardware).

Sorry for the noise.

--
Regards,
Sudeep
