Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFBF2EC54A;
	Fri,  8 May 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778259452; cv=none; b=JtdbNg/hnJyDTmBP1ZBScwQf6cuxpQxuPon5iIMfd4FlTHxtVUTUAnNx+sGfdkU+bhh7cpGn8Bf4jsfi0tUjS+Pg5YMOR+rP3rRPPXEbqWbrWvDM9kDTtUbB1l26sqXNXbOuB0B5WRQTF2fDVuDMzfILDZMqwPCiupsID5SOw5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778259452; c=relaxed/simple;
	bh=HhzF7Y4usesMvKmsaK0V1Ngy3fy45+8vuFUEdZrFH90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHlbC3nQxmRWR6f0UuuQIkAADu5xl16BMLzhzzml7RhUiekz+b95DpEbYzt/eAJzey4dI37IxwWx3uGXntXcKLh3R3uqGBdAjDVN7ufjiIc/bJQSLQEWWIRygzyIV3WSbscw6XQX6VUiBILQw9nHqUZm1h5AFx8sw/4FrESBRNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFO0Hsj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFO0Hsj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C7DC2BCC7;
	Fri,  8 May 2026 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778259452;
	bh=HhzF7Y4usesMvKmsaK0V1Ngy3fy45+8vuFUEdZrFH90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jFO0Hsj6gAmt8pTNQyaG+4aj9mEqQKEUiAk3HY3KaciG5/Y+uGR1sqgGnETAwDxo6
	 Ps0YuwWur6gRsO0dmxVtgzoAhfNSoYnL9Ot9mf71wSQV7Uac0DkpjBr59AJXXxcYci
	 tMBNi8MsZL6w9Qt8GswG6+Wk0Dl9bU+E24l6CA8TyABZqeosdUwzegPQuiJhsPwDdS
	 jSORFznJjVQI5ce/ILfZXGOToBq0y/pEGO7jLyBt63vTS2SevvynGsgKAZKexMBCpO
	 Pv037UE2AXpzOvL9sCCvsS2i0e/G58k8PBBzmt5GWIt4/efdeMbR4VtazTziKgJTL3
	 v8twujL/UVGdA==
Date: Fri, 8 May 2026 17:57:26 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: Marc Zyngier <maz@kernel.org>, catalin.marinas@arm.com,
	oupton@kernel.org, will@kernel.org, joey.gouly@arm.com,
	Sudeep Holla <sudeep.holla@kernel.org>, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Message-ID: <20260508-spicy-alligator-of-reading-7678bb@sudeepholla>
References: <20260501114447.2389222-2-sebastianene@google.com>
 <86wlxgy00t.wl-maz@kernel.org>
 <afxuDpecPCVA56cL@google.com>
 <86se83xrwx.wl-maz@kernel.org>
 <afyd8u85L5XIl6dh@google.com>
 <86qznnxptx.wl-maz@kernel.org>
 <af3fW468-f1KXCrC@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3fW468-f1KXCrC@google.com>

On Fri, May 08, 2026 at 01:04:27PM +0000, Sebastian Ene wrote:
> On Thu, May 07, 2026 at 03:21:46PM +0100, Marc Zyngier wrote:
> > On Thu, 07 May 2026 15:13:06 +0100,
> > Sebastian Ene <sebastianene@google.com> wrote:
> > > 
> > > On Thu, May 07, 2026 at 02:36:46PM +0100, Marc Zyngier wrote:
> > > > On Thu, 07 May 2026 11:48:46 +0100,
> > > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > > 
> > > > > On Wed, May 06, 2026 at 05:29:22PM +0100, Marc Zyngier wrote:
> > > > > 
> > > > > Hello Marc,
> > > > > 
> > > > > > [+ Sudeep]
> > > > > > 
> > > > > > On Fri, 01 May 2026 12:44:48 +0100,
> > > > > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > > > > 
> > > > > > > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > > > > > > FF-A proxy. This restriction was preventing the use of asynchronous
> > > > > > > signaling mechanisms defined by the Arm FF-A specification to
> > > > > > > communicate with the secure services.
> > > > > > > While these calls are markes as optional, there is no reason why the
> > > > > > > hypervisor proxy would block them because:
> > > > > > > 
> > > > > > > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> > > > > > >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> > > > > > 
> > > > > > Where is this enforced?
> > > > > > 
> > > > > 
> > > > > There is no enforcement in place in the hypervisor since we don't proxy
> > > > > FF-A from guest VMs, there is only one non-secure user of this which is the host.
> > > > 
> > > > And again: what makes that VM ID 0? Why can't the host pick VM ID 32
> > > > and use that?
> > > > 
> > > 
> > > The host discovers its id through the FFA_ID_GET and TZ returns 0 in
> > 
> > Does it? How do you verify this?
> > 
>  
> It is written in the spec under 13.10 FFA_ID_GET ("ID value 0 must be
> returned at the Non-secure physical FF-A instance").

Sorry for chiming in late on this thread. Yes the spec states the above.
However, I am not sure how the host FF-A driver instance with pKVM FF-A
proxy needs to be categorised. I assume it plays a role of Non-secure physical
FF-A instance.

-- 
Regards,
Sudeep
