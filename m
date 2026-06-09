Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F17231832;
	Tue,  9 Jun 2026 04:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780980887; cv=none; b=VqgHK7lyI663hVXV2cfwFr4JrzIwx5RcXSmaTpu8Zh029sLPvsvDlAbK8mjvJwW+9kNNz0ulInclqAdchu100tLrbQcYpdaHFGdbk0NYAXG11z1xmxDqrTw4B6dQX0UgFzbBnukiP7t1r8J1c6isi9U535a5sMFsGBDYa0ewaes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780980887; c=relaxed/simple;
	bh=nBo0F7y76zX9TksfaY3qtRi8YhP4U/zCjnht0O8fF88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zxtou3t4+guKarsmdyYKQbaA3YI0XCQKZ1rDPmNFnMHppjBr+IOM9LwKMvqTx+QQiuLc/T89BTeuPmzTSfvrB8dapy6eK5ZjAmOmeacOJlMqF7hRbwbz7swlZOXVQINqwddhiJZ2ee1I/Nc/QMbQFgdUzZbEDzj2CLIcoI2FA7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndfLh693; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndfLh693"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406D51F00893;
	Tue,  9 Jun 2026 04:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780980886;
	bh=IakrioQ8Jg2ZmHSWbWnKO0K2u/rTTc8tCu7uH9uLXFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ndfLh693pkooJpd668JTpzrLBIVvyb5QmE44oEsPZ89NsOCOpfGJmjBgMuvXiyBWQ
	 uZTZL0VxQu/NPB7HLue477LQxKhXn1d0hiPCcTFsFr0qPoG9JgTAea7b1XppxqtmXf
	 k9VhPFnaVaC0FNmH8Hd3AiLkTcuQ3sFRRaGJj9tO5wTB/ETA5MIcpU1g26vC2N04vL
	 i91bH7MkiVn3TaVzPQKj3GKzsIEw+RG7mky3o4Ohu34XmnjRYN3T6/yWL9X0DHIi/p
	 wq8sE1CO118xxbNsITImP7aP9pujk9kdDuBQQaAt3603c5eqlGTYyW+vi3QrNK4ZZR
	 1veYMM9BciQaw==
Date: Mon, 8 Jun 2026 21:54:45 -0700
From: Oliver Upton <oupton@kernel.org>
To: Congkai Tan <congkai@amazon.com>
Cc: blakgeof@amazon.com, catalin.marinas@arm.com, harisokn@amazon.com,
	joey.gouly@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	mark.rutland@arm.com, maz@kernel.org, suzuki.poulose@arm.com,
	will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Message-ID: <aieclTmL1op0AYfS@kernel.org>
References: <ah3mObchzwb80_3S@kernel.org>
 <20260608210359.1757125-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608210359.1757125-1-congkai@amazon.com>

On Mon, Jun 08, 2026 at 09:03:59PM +0000, Congkai Tan wrote:
> On Mon, Jun 01, 2026 at 01:06:17PM -0700, Oliver Upton wrote:
> > We can't change the value of PMMIR_EL1 unconditionally since older KVM
> > treated this register as RAZ/WI. This also mixes poorly with the default
> > PMU garbage that we have since as the value of the register can change
> > based on where KVM_ARM_VCPU_INIT gets called...
> >
> > Considering everything, I'd like to see this wired up where:
> >
> >  - PMMIR_EL1.SLOTS takes the value of the underlying hardware PMU only
> >    if the VMM explicitly selects a particular PMU implementation
> >
> >  - KVM allows userspace to set PMMIR_EL1.SLOTS=0 for backwards
> >    compatibility
> 
> Thanks a lot for the review! Makes sense. We'll work on v2, and here is
> the high-level design we plan to follow:
> 
>   - Introduce a new VM-wide field, e.g. kvm->arch.pmmir_slots.
> 
>   - Seed it from the underlying hardware value only when handling
>     KVM_ARM_VCPU_PMU_V3_SET_PMU; otherwise it stays 0.
> 
>   - access_pmmir() returns whatever is in pmmir_slots.
>   
>   - set_pmmir() writes pmmir_slots to 0 if the user input is 0;
>     otherwise it no-ops or rejects.

Reject is always better heh :)

So I was previously under the impression that we already expose PMMIR_EL1
to userspace but we actually don't. Grr.

The UAPI around PMUv3 is crappy enough that we should just add a new
vCPU feature flag. When that flag is set:

 - KVM will not create a 'default' PMU, userspace must select a PMU
   implementation to init the vCPU

 - PMMIR_EL1 becomes a user-visible register with the behavior that you
   outline above

 - No PMCEID masking for STALL_SLOT* events

There's a couple larger PMU features underway (e.g. Colton's partitioned
PMU, Akihiko's fixed counters PMU) that we can also condition on the new
feature flag.

Does this sound OK to you?

Thanks,
Oliver
