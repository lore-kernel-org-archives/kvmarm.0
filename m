Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA67F4EE875
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453634; cv=none; b=R77tEr5SQbiRtqZWOv1wLCS+UrK5OY3Cf7mB8r8b4UzdiCbuAHDcAa2Tq4X3OApw3Z1fSWygDcV8+ZjPGSgPW7A98FvfkwyqGLAYRQ1W8V/PPB5dNulJNfjaZJN9bNRVfRrUe+KPmI76jPYHsuFjhRLJdceNURC92NZB8g4A9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453634; c=relaxed/simple;
	bh=OSr2gscj+kDjyAWXtxyYR/gs/bwGrqEaiRW5/qbCIZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ZX1BUtH9MgJmBOfqGCfMGLG4zOakKt7Gsu084XuZEedMCcqVl2VLrJPrrd94kT9VagEWje9lzX9dEgoxFcpzqc1kdyTmrnLf1rP9VWTk3Si40zotrzLEh92GacxP1Sm+qnjESyEUYFQ0IAXtMTzrlzbhMVM6wggo94gH5FYr6+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=fYFwU0f7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="fYFwU0f7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60DB81596;
	Thu,  3 Sep 2026 09:40:28 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA2103F673;
	Thu,  3 Sep 2026 09:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788453632; bh=OSr2gscj+kDjyAWXtxyYR/gs/bwGrqEaiRW5/qbCIZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYFwU0f7t6o4OCU+/iylAHc5e01pAfXn4Gh0P5mqIl+Sb4zHG9QVJVGQ1d6dhtck0
	 L7K4Q4qXmw/xDige6jYLIjc/+39VF/2q5nlJpYLyPikD7Bny43n60HrtNgxy7sJZ7N
	 nCbU4IyZYpUdBVwZ8bPNza82EQkkJDTWxGsbwMSc=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an exception
Date: Thu,  3 Sep 2026 17:40:12 +0100
Message-ID: <apmi7HD54qGVVB7J@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <0c1c0d26-4e96-4076-8863-b4e871e38e67@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-5-f31750bdfadb@kernel.org> <apmDRXBvS-XOi1NJ@LeoBrasDK> <0c1c0d26-4e96-4076-8863-b4e871e38e67@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 03, 2026 at 05:20:32PM +0100, Mark Brown wrote:
> > > +	// PSTATE.EXLOCK is set to 0 upon any exception to a higher
> > > +	// EL, or to GCSCR_ELx.EXLOCKEN for an exception to the same
> > > +	// exception level.  See ARM DDI 0487 R_WTXBY.
> > > +	new |= compute_exlock(vcpu, mode, target_mode);
> 
> > Same nit: am I really setting one bit here? or could be 
> > more stuff depending on the parameters? Having an "if (cond) new |= bit"
> > seems more clear to what is being done, without needing to read the comment 
> > above.
> 
> The goal with the comment is to explain the rule that the code is
> implementing in a style similar to all the other field updates in the
> same function.

Oh, right, to be clear:
I am not questioning the usefulness of the comment here.

It's more about "new |= function()" thing, as it's not immediately clear 
what is being set unless I read the comment or read the function, as in the 
case "if (function()) new |= bit" I may not immediately see the condition 
but I know whatever it can be, it will only decide if I do or don't set 
this given bit.

Thanks!
Leo
