Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C07E34B693
	for <kvmarm@lists.linux.dev>; Fri,  5 Dec 2025 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764954022; cv=none; b=baIR9ljNxDm3wfs/R4/5HXDQXHlNgOwl5E8sfPxJgC46sO8ps6qQUTEHYr+fHrcMB6XpKr3Jeugm+fRoQoW0uilcbMalEjW9wPKzFK1JrTgHmQSYdtPrBEohg0JlpLVN9oYIloifUyABrTN2NQeBgIWV1e512YfhLJppc8Noi88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764954022; c=relaxed/simple;
	bh=bQaicZElGWpPclJv8Q7F14L4vqc96yraUR5va+jry88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsXJw8sNM+/RfJqdbR9TUrt7XLb1CGcTMJxp5TfTBMg1dhIbr5e0T5bpdT5FHsHNTL0craMX+ugF5qY7R46LfmT1bUtXpYX1UXmkUbdkiyQNrUCBkHCMJVmdKMLO4mkqy2Xt/HTM7H5r9rAoBMy1rPGwtIv325KUBox+PVu80g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwWy473R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwWy473R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9686C19424;
	Fri,  5 Dec 2025 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764954020;
	bh=bQaicZElGWpPclJv8Q7F14L4vqc96yraUR5va+jry88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EwWy473Reu64vPTt4Bj3ZOib9vBdWVZ4je+3cT3NlXAffYDSQi3YYjoIx2ymawyel
	 04Ub+oXS9uB41rITYFfzywYfM7Yw9xArA0Fs9ilkdf0lZNFuFVFsqHA+qMHn4pgtwx
	 fUGSWeZdByeLm5ItzsalPUQL+48kA+XxVkylkCC7V2wU25T5s4UVEz7guUg74VhbZG
	 szEykXG4ownraWcIj0dSSONcgGsT4QLdRUGZBtrebHOHNwtBPVJZ6mDupbfgwCWgCC
	 7o4eXJaVke3x7W2UhL6+YDf3DrPwV4kYrw1ty52jBU2B7/hyTG47woFnGWYLw5D6sf
	 T9JJnBdm652Tw==
Date: Fri, 5 Dec 2025 17:00:15 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com
Subject: Re: [PATCH v1 0/5] KVM: arm64: Enforce MTE disablement at EL2
Message-ID: <aTMPn0dBbSVUwwJ1@willie-the-truck>
References: <20251127122210.4111702-1-tabba@google.com>
 <aS9rmMgNna7I5g4F@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS9rmMgNna7I5g4F@kernel.org>

On Tue, Dec 02, 2025 at 02:43:36PM -0800, Oliver Upton wrote:
> On Thu, Nov 27, 2025 at 12:22:05PM +0000, Fuad Tabba wrote:
> > pKVM never exposes MTE to protected guests (pVM), but we must also
> > ensure a malicious host cannot use MTE to attack the hypervisor or a
> > pVM.
> > 
> > If MTE is supported by the hardware (and is enabled at EL3), it remains
> > available to lower exception levels by default. Disabling it in the host
> > kernel (e.g., via 'arm64.nomte') only stops the kernel from advertising
> > the feature; it does not physically disable MTE in the hardware.
> > 
> > In this scenario, a malicious host could still access tags in pages
> > donated to a guest using MTE instructions (e.g., STG and LDG), bypassing
> > the kernel's configuration.
> > 
> > To prevent this, explicitly disable MTE at EL2 (by clearing HCR_EL2.ATA)
> > when the host has MTE disabled. This causes any MTE instruction usage to
> > generate a Data Abort (trap) to the hypervisor.
> > 
> > Additionally, to faithfully mimic hardware that does not support MTE,
> > trap accesses to MTE system registers (e.g., GCR_EL1) and inject an
> > Undefined Instruction exception back to the host.
> > 
> > This logic is applied in all non-VHE modes. For non-protected modes,
> > this remains beneficial as it prevents unpredictable behavior caused by
> > accessing allocation tags when the system considers them disabled.
> > 
> > Note that this ties into my other outgoing patch series [1], which also
> > has some MTE-related fixes, but is not dependent on it.
> 
> To be honest, I've actually been having a bit of a hard time
> rationalizing some of these targeted fixes for pKVM. It has been in a
> half working state upstream for O(years) and we haven't made forward
> progress on enabling pVMs.
> 
> Fully aware that guest_memfd has been one of the long poles here, but
> I'm becoming less interested in fixes addressing "pKVM policy is XYZ"
> without having the full picture of the feature.

That's completely understandable and we're similarly frustrated.

> What are the upstream plans on enabling some basic implementation of
> protected VMs?

Funnily enough, I've been hacking on this recently and I've ended up
with something that I think serves as a good basis for enabling pvms
incrementally upstream. I need to clean the patches up but I'll be
flying to Japan and back next week so that gives me a good opportunity
to do exactly that!

In the meantime, I hope you'll still consider fixes for non-protected
guests under pKVM (e.g. [1]), as that is an area where I think we've
made some reasonable progress.

Will

[1] https://lore.kernel.org/all/20251128141710.19472-1-will@kernel.org/
