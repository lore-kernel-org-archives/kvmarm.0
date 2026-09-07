Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C9A47ACC7
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778540; cv=none; b=IUReYXMmT1HpXuWe14jDahPOSj4waSkGrfjYrPeZjw01fyBUtT60NUSFGxLMow74/z19QM+zfVM0s+i7h15S0xbsHZseQNMue3Twz6tkQaPVq9kvzO7rpb6OMkb4yiv7yv7HpGnC4DCmLyK+a8FwUQtWsfhPt+7NaQv1ff4c+04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778540; c=relaxed/simple;
	bh=E3jYT8BbJ4w2SnMF/c5ygS3n4YeOF0/ZtH2+kO3O+tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=n4Dfns80bRH2bWrBDYWenmTqmYwEV2iAr0ZA7XkLwFX9RJRjW/SAV+t0kY03kEXz0YWmWKlGDLw6kohHRU8LdeRtFhf3579UFYjiI3Y0auUYc67sDVmJTBuCRmuTXdtsN0poXrt6qiFB9vjfV67VRZCrvy2YvuPmbHI0/5DpQPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZWS+gxZn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZWS+gxZn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5880A1476;
	Mon,  7 Sep 2026 03:55:33 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBBDC3F7B4;
	Mon,  7 Sep 2026 03:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788778537; bh=E3jYT8BbJ4w2SnMF/c5ygS3n4YeOF0/ZtH2+kO3O+tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWS+gxZnr2jYVFGXrj+ilBGofSnt06NhS2wsOsdAcq1JSep+u16p7gOkFuAvKkOoG
	 SsFOx35kMy4oRX9jfcOjj1PjPBrQDnew8q6KXbFYGmBwn+NF3Ak012Z1zwLnNWeo/z
	 8/BIDGukb9o4xSmnZX30qrlC346MeWYeaonT4+GE=
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
Subject: Re: [PATCH v20 06/14] KVM: arm64: Validate GCS exception lock when emulating ERET
Date: Mon,  7 Sep 2026 11:55:32 +0100
Message-ID: <ap6YJHB5JKtfjM3M@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aps-oNeG3RjzqHQs@sirena.co.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-6-f31750bdfadb@kernel.org> <apmUQETDlhTIuJIY@LeoBrasDK> <2dfd8a6c-42c2-466c-b3d6-2313466fc3d5@sirena.org.uk> <aprEsh-xogu8zFnK@LeoBrasDK> <aps-oNeG3RjzqHQs@sirena.co.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Sep 04, 2026 at 10:56:48PM +0100, Mark Brown wrote:
> On Fri, Sep 04, 2026 at 02:16:34PM +0100, Leonardo Bras wrote:
> > On Thu, Sep 03, 2026 at 08:22:44PM +0100, Mark Brown wrote:
> > > On Thu, Sep 03, 2026 at 04:37:37PM +0100, Leonardo Bras wrote:
> 
> > > > > +	if (kvm_check_illegal_exlock_return(vcpu, spsr))
> > > > > +		return false;
> 
> > > > >  	/* If ERETAx fails, take the slow path */
> > > > >  	if (esr_iss_is_eretax(esr)) {
> > > > >  		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))
> 
> ...
> 
> > > We need this because ERETs from vEL2 are handled in software, modulo the
> > > NV3 fast path mentioned at the top of the function.
> 
> > Oh, and this is done in __fixup_guest_exit() because vEL2 is not a 
> > nested guest. It would be it's guests' exit that would be dealt in 
> > fixup_nv_guest_exit().
> 
> > Is this correct?
> 
> Well, it's as much because that is the point where we handle the EC
> specifics.  __fixup_guest_exit() does general handling of guest exits
> that applies to all ECs and then dispatches to an EC specific handler,
> it is common code with nVHE.  When we have NV then fixup_nv_guest_exit()
> is run beforehand to do extra handling that applies to all ECs in the NV
> case, but any EC specifics for NV still go in the relevant EC specific
> handler.


Humm, okay.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

