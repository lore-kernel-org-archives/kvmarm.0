Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26801C84BB;
	Mon, 22 Jun 2026 16:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782147310; cv=none; b=oLEQlV+Wz19W2/LHpQmNMTKY7GA/S1pHN9h8pdOtxp0+H3K/fmv3IbwivX9KGowx8oGyDYuwi56VK+uwg+VGC54c379lVIYomwNGElrplwVrPeLw6XwlNANPcVI+UgKUGxd8TZaecUJl9NdBDTzgL+zDMxcnBfLk2VHnEaSJH8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782147310; c=relaxed/simple;
	bh=yukAW+Z8i9v3NIhazZ5NRNFfxHqpLVDGViMLnKkkEOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1lFRJIoTVh/lTugIhUpqVxd2eejnmlkoHcsB2y4DwwTNCKDlVtT+cmlLHVw+dpC1kNwqCG0JyzwGnZPYsjSKx970Mhv7y+2/xY4JnKnp4nhxUufVbSuadpWO7FenI/SeP8jKpjJj86Haev8wx9jrW1C+HIUxM0RSefQ8Msikus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zx4jUC0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zx4jUC0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3F51F000E9;
	Mon, 22 Jun 2026 16:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782147309;
	bh=tkrUBunzzSd0lpNk16EVteU8HoOMNZNuJe8m7GqVJPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zx4jUC0aWCq9VEBJoN0kOOYcuNOKSkjJSz+tdDvzkInO8/80PWmPij3R6QgCfsqJA
	 Ks+EYHJ2O+Idv5Oydi4cbp6Qq2+eowtNM3er63+S+6oUoAJfF4agBpyZU3i+PAvTGK
	 eiwCTwJslDKypU2fvhBUL0rKyUA+CRnjyzkXCNqyjtdETxDlJIMmJfJMFKXGUbX/XB
	 Cvrff97ZJ5ppUCNUOuQIYsUEihP9KZduCey39sBUCp9G1Qn285RDMJHjJqEjUi0i4U
	 ERu5PkCov6Dtbb6QmTDloCC60FozrSeBxYOvf76gCS/TPR8BpGPvj5j325lbBbUbrY
	 WRSuhKLQ9d9Ng==
Date: Mon, 22 Jun 2026 09:55:08 -0700
From: Oliver Upton <oupton@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	jean-philippe.brucker@arm.com, andre.przywara@arm.com,
	suzuki.poulose@arm.com, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool v2 7/7] arm64: Improve KVM_ARM_VCPU_PMU_V3_CTRL
 diagnostics
Message-ID: <ajlo7Arpi7XrGjFs@kernel.org>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
 <20260618155001.226266-8-alexandru.elisei@arm.com>
 <ajRBpMnlcNkhWzQL@kernel.org>
 <ajj6oGxytFm2NE4T@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajj6oGxytFm2NE4T@raptor>

On Mon, Jun 22, 2026 at 10:04:32AM +0100, Alexandru Elisei wrote:
> Hi Oliver,
> 
> On Thu, Jun 18, 2026 at 12:06:12PM -0700, Oliver Upton wrote:
> > The whole if (ret) die_perror(...) thing is a bit repetetive IMO. A
> > treewide cleanup replacing this with macros would be nice, then you could
> > stringize the ioctl under the hood.
> 
> Thank you for having a look, that's a great idea, it will avoid out of bounds
> array access if KVM gets a new PMU ioctl and the name array is not updated at
> the same time - that's quite possible since ioctl numbers are pulled by running
> update_headers.sh, and the dependency is not obvious.
> 
> I think the compilation errors are a bit higher priority than this, and a
> treewide change would more involved, possibly involving a change in behaviour
> (the gic seems to propagate the error instead of calling die_perror(), for
> example), would you mind if for this series I'll only introduce the macro for
> the pmu and convert the rest of the code in a separate series?

Fine by me, thanks Alex :)

Best,
Oliver
