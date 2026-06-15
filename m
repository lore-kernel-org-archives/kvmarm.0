Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6023DB62E;
	Mon, 15 Jun 2026 09:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781516872; cv=none; b=o8mtI3BuSt6aX6+sNryP7yu82n0GhIQwh2h53kUezcpWeoJZ7/lrOhe15q8Fy7mW4wPjUY71JiA5OGzjAaqLgdp0ECmbBIvgaOUK1swqHnPQK3FHQZPWrUg1KXu2OTrr5+uN/dPmT3TfHxF/c6wb9jS/Mu43sKTrdwLw2LLCkk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781516872; c=relaxed/simple;
	bh=bvQXQ1kIESnQ+HQjakpvXFPSMUZ8dtSsfrpoIxj2Y0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H5h9J372Zp7rqfBLakIZIAMTIQBpaPAC4y77dAPNUOiVvzXObUl7wwFjW6KESRNS/dya/+BhTWi4FotJG6DI2uFNxE8vsEECyYnFx3GMTBLFGRZngmU7R+gPMwroQURHpbdwyFezuwsz5qCoRNkfc6HsS6EStBAK7o38ekfjq68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljbq4CVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljbq4CVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75D01F000E9;
	Mon, 15 Jun 2026 09:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781516871;
	bh=+gQRnY18Yf5sZLa9hrEMVv61/7uAFGlQA3UH4id3Xkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ljbq4CVw7HtTGNgedrO0+X1vR12DOmPfi7xAw2UAwbjguH24snP5E9jJoNwjrVTzk
	 wwnVFTAGwZchN/h3Hm60eLpY1K6xrbTYrRQ1IAgKRoI9SL4nlRs4WmNbEWJ4kMUa1g
	 OiqgWyjDV5T39W4A50850awfndvdfqzTcoeQoiUuDSfN8sPXbGPD87h0iwSWnkvDEr
	 GUef+xwYnxCPSFoQKo56cR2XjkaOTTT2A5CGaUs2ZhBFFXws6/+wTLkUmntdl2JOYc
	 xB1tZmq+pdVNIjMgBSvNnhJZHyjIxXTNsc+9TV/UtyowabnWbaLkcyNtmtby8vBwPn
	 AcO5wTzJMTN1g==
Date: Mon, 15 Jun 2026 10:47:45 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <ai_KQTJj4n1dZS6F@willie-the-truck>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <aikt44sVnpL3_dYi@google.com>
 <aik5MtvOlnQDmzjr@willie-the-truck>
 <ailVcN-bxY30-XBF@google.com>
 <ailXKA1VG8vyKNfV@willie-the-truck>
 <ailtCAcEaJIgZ5Ap@google.com>
 <ai50fgNHGUqz0muP@willie-the-truck>
 <ai-tO-sSNGp7mjAU@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai-tO-sSNGp7mjAU@google.com>

On Mon, Jun 15, 2026 at 07:43:55AM +0000, Sebastian Ene wrote:
> On Sun, Jun 14, 2026 at 10:29:34AM +0100, Will Deacon wrote:
> > Yes, that part now seems to be missing.
> 
> I am a bit worried to apply for all of them the check from the relayer
> (ffa_check_unused_args_sbz) because of how it's written in the spec in
> (11.2 Reserved parameter convention). To be more specific, there is no
> mention of what the relayer is expected to do here (which is what hyp
> does). It says 2 things:
> 1. the caller (in this case the host driver) is expected to zero out
> unused args
> 2. the callee (Trustzone) ignores the values in these registers.
> 
> If we enforce SBZ in the relayer but (1) doesn't comply with it, we will
> introduce a regression. I left it on purpose without enforcing
> ffa_check_unused_args_sbz for the others.

I think that's ok -- if the caller isn't passing zeroes when it should,
then it's already on borrowed (no pun intended!) time and it will need
to be fixed.

Will
