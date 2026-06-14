Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AB1146588;
	Sun, 14 Jun 2026 09:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781429381; cv=none; b=MXi/PS3OF5BwdIEYaM7ugKYk1CtL1eJU8602potZ5v36pHdvlueSONKQGdos4TfccOMYRMw7tV6F6lFWLCenhK0lt2ixrYPVpbtyp4GzE2EaamiV+QT5zsXjA5wJiRFdKmGCo+YpGpCE/4AtyuSVteUmuUOwOeIOAd5zNRyFLDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781429381; c=relaxed/simple;
	bh=I/bvVi6jc/VbHTiaCrhgjd5p5b9/upZ5EFx7TYNUhhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9i2IsUrS2xgMfH3LYxExrRRrYtwbzQgucP6hNoOaBQTwZGchO77kF7Y5iSmhRvl4XQI0Iye9bYAg7Co8JCb8xAV3pvbqbig1KOjH7Na3AsP2eYvCjpu8+qAMtJRy9oHirbMWRv9DtZCkod7vygCJRay/69s1Al3xbQwrR1AT80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfzpREgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfzpREgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FC71F000E9;
	Sun, 14 Jun 2026 09:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781429379;
	bh=VGipe1TnTsh2KYuYR/NW/LZHMBf92aj7lIaB8fElLLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XfzpREgdfgjZnpz1K2FzM/zFnUPUtOH7Ujq9RFyQCMpsJyAUo2qbz5Ua1DmUjeFkX
	 v9C/zzxYrKX4ssPoNa3i46rznV2XE65nGwzpek02L3/WPNW9cLnmJyfdifZb1NANKo
	 PsHrcacSLvd3iTwPypkUCU4XsIeC1tzPi4UmfVo+havuRMsSljj6nFsn/iPQrQenSm
	 5v76vIdUP12bf2AzgNU1Wp5guyIjFolf9JZDPX2JmBMlzZi7bAz47yG4WxVd60tz88
	 Wppq1I1qQXqMzvGxLN/htKKVgMtfMsOaA9PK8r+wYZPvmhZPvBMTTDmW/v+KyvNuu2
	 pUlMBo8GRPDJw==
Date: Sun, 14 Jun 2026 10:29:34 +0100
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Sebastian Ene <sebastianene@google.com>, catalin.marinas@arm.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <ai50fgNHGUqz0muP@willie-the-truck>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <aikt44sVnpL3_dYi@google.com>
 <aik5MtvOlnQDmzjr@willie-the-truck>
 <ailVcN-bxY30-XBF@google.com>
 <ailXKA1VG8vyKNfV@willie-the-truck>
 <ailtCAcEaJIgZ5Ap@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ailtCAcEaJIgZ5Ap@google.com>

On Wed, Jun 10, 2026 at 02:56:24PM +0100, Vincent Donnefort wrote:
> On Wed, Jun 10, 2026 at 01:23:04PM +0100, Will Deacon wrote:
> > On Wed, Jun 10, 2026 at 01:15:44PM +0100, Vincent Donnefort wrote:
> > > On Wed, Jun 10, 2026 at 11:15:14AM +0100, Will Deacon wrote:
> > > > On Wed, Jun 10, 2026 at 10:26:59AM +0100, Vincent Donnefort wrote:
> > > > > On Mon, Jun 08, 2026 at 04:55:42PM +0000, Sebastian Ene wrote:
> > > > > > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > > > > > FF-A proxy. This restriction was preventing the use of asynchronous
> > > > > > signaling mechanisms defined by the Arm FF-A specification to
> > > > > > communicate with the secure services.
> > > > > > While these calls are markes as optional, there is no reason why the
> > > > > > hypervisor proxy would block them because:
> > > > > > 
> > > > > > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> > > > > >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> > > > > >    Because all forwarded notifications are inherently attributed to
> > > > > >    the Host by the SPMC, there is no risk of VM ID spoofing
> > > > > >    originating from the Normal World.
> > > > > > 
> > > > > > 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
> > > > > >    operate strictly via register-based parameters, passing only
> > > > > >    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
> > > > > >    not contain memory addresses, offsets, or pointers, forwarding
> > > > > >    them doesn't pose a risk of memory-based confused deputy attack
> > > > > >    (e.g., tricking the SPMC into overwriting protected memory).
> > > > > > 
> > > > > > While the pKVM proxy behaves as a relayer, it doesn't currently have its
> > > > > > own FF-A ID(only the host has the ID 0). The behavior of the setup
> > > > > > flow is covered by the spec in the: '10.9 Notification support without
> > > > > > a Hypervisor'.
> > > > > 
> > > > > As it is only a relayer. Is it really important to check SBZ arguments and
> > > > > fields on behalf of Trustzone? It doesn't feel it brings any security. If the
> > > > > host passes broken arguments, I don't believe this puts pKVM at risk. Does it? 
> > > > 
> > > > I think the problem would be if an update to FF-A allocated some of the
> > > > currently SBZ bits to implement some functionality that we would want
> > > > to filter at EL2.
> > > 
> > > I suppose that would bump the FF-A version and the proxy would reject it?
> > 
> > Maybe? I don't think they'd _have_ to bump the version number.
> > 
> > > If we really want to check for those arguments to be 0:
> > > 
> > >  * Shouldn't we extend this check to other FF-A invocations?
> > 
> > yes, that's what the diff was doing in the reply here:
> > 
> > https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
> > 
> > but, as I said here:
> > 
> > https://lore.kernel.org/all/ahmxiFXXTupafbXw@willie-the-truck/
> > 
> > I don't particularly like the table-driven indirection (the checks
> > should just be inlined).
> 
> Ha, sorry I'm late to the party. 
> 
> Perhaps this series should start with adding ffa_check_unused_args_sbz() to the
> existing allowed FF-A invocations?

Yes, that part now seems to be missing.

Seb, please can you respin with that included?

Will
