Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A622F5337;
	Wed, 10 Jun 2026 10:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781086521; cv=none; b=HLdgdk06Ivvxg9i4zj4MTCuUe1hwyrdhLTpxwpHt1494yXVk3imr0/tN+PAI1RusvfKUNGO6Xo/wnnE1+l/bi/OfRTaUfmIWnhn8HoMiXkxXn275DxsaobYUxseU61wTnv605wKhLNz3hUk2PnZ8F1M2q8Va40JDauV8w/Fs2SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781086521; c=relaxed/simple;
	bh=ejTTByFAcBZR+8wtj1i8ZDTQde0R5SqbnzOwQddxHTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1nhdJ5xVfrggKdiW0VPrZY/hoDZEAISV3SqF++sMO4I4NUTLH18pQR+mXXy2htH8e1hVKm5hnKWmmPXwSds50Foy6r9azsdvmM2Qrf9ujvQGhGnM83XEEKWguzj4GhA+2AWiC612E3JaL7UxC4WzC5JB/gIr5fUW/Bp5vFUU6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7cs4Pu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7cs4Pu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7751F00893;
	Wed, 10 Jun 2026 10:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781086520;
	bh=BqtuY6893ZMKAPfP3UotyEfU6XvkTSj7lMBiTda4vZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n7cs4Pu3UQIrQN/8NOJW86bcYr5KD3XHreJlIMDp8MbvuBM20iyrF4JNMQaEeP+dn
	 Zv7TIT95ubvs1tHySw9OWRVhaj7Qoo0K0eiIYFBnteEM2UHNvpKnbsztEtqpWolMrr
	 cNMHVN17sOZIDrsDHpcln5wbzGtG7q6AwzUyjeTajksossw2afAk5MQumHXBp2C467
	 eD3Mnk639vXK4Bt+UIXQ7D10CYFSbXDJNqoQ9Fd8WRcQjoGh+JEP0IH9oO/+cbMuPi
	 VTaBum+aEyXvOicmFVMmdUKYrYNaTOKh5DC//c925Bqs6ir12dXOi9VIm5ZfXKrY4e
	 jKvKKpS8PBDvA==
Date: Wed, 10 Jun 2026 11:15:14 +0100
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
Message-ID: <aik5MtvOlnQDmzjr@willie-the-truck>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <aikt44sVnpL3_dYi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aikt44sVnpL3_dYi@google.com>

On Wed, Jun 10, 2026 at 10:26:59AM +0100, Vincent Donnefort wrote:
> On Mon, Jun 08, 2026 at 04:55:42PM +0000, Sebastian Ene wrote:
> > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > FF-A proxy. This restriction was preventing the use of asynchronous
> > signaling mechanisms defined by the Arm FF-A specification to
> > communicate with the secure services.
> > While these calls are markes as optional, there is no reason why the
> > hypervisor proxy would block them because:
> > 
> > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> >    Because all forwarded notifications are inherently attributed to
> >    the Host by the SPMC, there is no risk of VM ID spoofing
> >    originating from the Normal World.
> > 
> > 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
> >    operate strictly via register-based parameters, passing only
> >    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
> >    not contain memory addresses, offsets, or pointers, forwarding
> >    them doesn't pose a risk of memory-based confused deputy attack
> >    (e.g., tricking the SPMC into overwriting protected memory).
> > 
> > While the pKVM proxy behaves as a relayer, it doesn't currently have its
> > own FF-A ID(only the host has the ID 0). The behavior of the setup
> > flow is covered by the spec in the: '10.9 Notification support without
> > a Hypervisor'.
> 
> As it is only a relayer. Is it really important to check SBZ arguments and
> fields on behalf of Trustzone? It doesn't feel it brings any security. If the
> host passes broken arguments, I don't believe this puts pKVM at risk. Does it? 

I think the problem would be if an update to FF-A allocated some of the
currently SBZ bits to implement some functionality that we would want
to filter at EL2.

Will
