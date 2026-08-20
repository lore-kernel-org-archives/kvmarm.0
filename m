Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF9346D097
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787236133; cv=none; b=pDTuQ5D9GJaFjSrvEc3OhuxWh1zwpctv3WkGAa7jrmlRi6SPXcB7V/h1ZbSMztFW7bTL0lyTOB6zf4IQEDrVHb3zoU82C79t1hzpnYs+wGcuCXoCYRHmWvvrmGS04IQ4ZwC0kEJTLNNHXWkmIi7eLi6bevKrQAXbkh6hTUA9Bho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787236133; c=relaxed/simple;
	bh=j7vXC94xLC094gowguZtlDsLgDSpj+ra95W3BzjDxVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=CQJfJ+iEjowYKnvr1v/iN3nfzYbytFFXk7BsNcOWbhxyuWaWnkR9W8MTvGhdnZNkLS22KXAHTjxSbpxVxQOZGdymO2cDp+oC4Nu0PgZzBLWSE0SAPfEyTlgDcNTkjRrinkF5LVqK4RQlO6wP+qP9JLpy7cGAv4ckjFuqaofIy6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H7CDUD6w; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H7CDUD6w"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABDB0153B;
	Thu, 20 Aug 2026 07:28:40 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F31903F85F;
	Thu, 20 Aug 2026 07:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787236124; bh=j7vXC94xLC094gowguZtlDsLgDSpj+ra95W3BzjDxVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7CDUD6wGZ5VKrAa+aKPBjAVtsC54NTefYiyFrrhqBatxPHWP1zaZfdQiSbEdTEes
	 YhQnNCiKSRNV/geqiVkxRIY6dxZuDf0fE5e4wr7aYUyEf3qtCf7kU9F15d4vI9hMAt
	 MpI6oNq7/r07ILxe0J+Xnm/z7mldM2NVCf4P+DlA=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 03/14] KVM: arm64: Manage GCS access and registers for guests
Date: Thu, 20 Aug 2026 15:28:39 +0100
Message-ID: <aocOi3wjcliZqoe7@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <97ad6e83-b22b-4881-b644-66fa99f68d64@sirena.org.uk>
References: <aoXamcdKoMynTkpX@LeoBrasDK> <48be9e5d-357a-4863-8682-8b3f34c69723@sirena.org.uk> <aobUGyq8nInJYkdA@LeoBrasDK> <97ad6e83-b22b-4881-b644-66fa99f68d64@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Aug 20, 2026 at 03:07:14PM +0100, Mark Brown wrote:
> On Thu, Aug 20, 2026 at 11:16:59AM +0100, Leonardo Bras wrote:
> > On Wed, Aug 19, 2026 at 05:46:00PM +0100, Mark Brown wrote:
> 
> > > This is just because there isn't a preexisting ctxt_has_tcrx() check
> > > already there, FEAT_GCS architecturally depends on FEAT_TCRX and there
> > > was a request to make this explicit in the code to try to optimise
> > > things a bit.  The compiler should skip over both blocks at once if TCRX
> > > isn't there rather than having two separate tests or static branches.  I
> > > didn't add new checks where there were none since I expect that to be
> > > unhelpful for code generation, you'd get the reverse situation and emit
> > > two checks.
> 
> > Humm, but then why saving GCSPR_EL2 does not depend on TCRX/E2H? Or maybe a 
> > better question, why are not GCSPR_EL2 and GCSCR_EL2 saved in the same 'if' 
> > clause under ctxt_has_tcrx() (and E2H set), if they are restored in the 
> > same 'if' clause?
> 
> > As you mentioned, GCS depends on TCRX, so it should be fine, but just by 
> > reading the code I see:
> > - GCSCR_EL2 :
> > 	Save if 	GCS=1, TCRX=1, E2H=1
> > 	Restore if 	GCS=1, TCRX=1
> > - GCSPR_EL2 :
> > 	Save if 	GCS=1,
> > 	Restore if	GCS=1, TCRX=1
> 
> > Which looks kind of confusing for the as a first time reader.
> 
> > Does it make sense?
> 
> I agree that the current situation is a bit hard to follow, I'd actually
> originally written things without the explict dependency because of that
> but Marc wanted the optimisation.

Well, I am not against the explicit dependency thing, it just looks odd 
to me that some save/restore have a dependency and it's counterpart does 
not. As well as the dependencies for both registers being different.

>  There's similar things with other
> registers in the current code (eg, the PIE and POE registers are in the
> same situaton as GCSCR_EL2).  One thing I did miss here is some nesting
> inside the PIE checks for EL2, I'll update for that.
> 

Awesome!

> I think what would help here would be to move to generating more of the
> save/restore sequences rather than open coding them, we could have lists
> of registers and then use data about the feature dependencies that the
> architecture has (hopefully it's already in the MRS, I didn't check) to
> generate these optimised feature checks rather than having to open code
> them.  Possibly even list features and generate some of the register
> lists, though that would need far more special case handling and it's
> *much* less clear if there could be a benefit.

Yeah, that would automatize the feature dependency for register loading, 
but maybe code would not be that clear on how it works? I have questionable 
taste, though.

Thanks!
Leo
