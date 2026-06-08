Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9EB3BE647;
	Mon,  8 Jun 2026 14:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929637; cv=none; b=SQrN9PATt1RK2qt05xKPs3HkABvNzoKzRk+iHWkxUQYUAT+yhdkODSE8QFuld0/wswi/apjy7dcDEdd2LeibySQgwz8JtKs7wdDsveME3ebBE9hxv3YnzBPnG77+KSx0G7q3WOnmJ7VkG0ijWTFHfmhbYaa5QaY1YIKrJwAk14s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929637; c=relaxed/simple;
	bh=GDdD/1HLb8/TyOZdkQtSvYrCNpL55+xR88u3XZkUdWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZjtIzVUq7++5hlAon9QEFV4zFfpzToFyVs/B/Uz4KzJjZUF0eiJ3NmdEZg/sX40kcw4XcOB7c6Sw0CGNN2HI9v+1T6ekumGrmV/edsS9VafVjYqyp10YT5q9u0W/eKqRIbllni7gxp6gfWxqerl3qmFkmzhaobP74UATgBhvXTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Npzdjz3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Npzdjz3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18A81F00893;
	Mon,  8 Jun 2026 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780929636;
	bh=xlgzZtWkhSRLPN2fmw7RI5SY6ZXquR97nXbPnLUoA2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Npzdjz3Xq1UzjuuVBBG0NnSMVk5McHRhfN4uwjquRiwdcccTnwLPPF/7OYZTyDDz+
	 chk63GUPEjLI0kgRcnnTnn/bLRc9Ca7x4iwTsyb4E77a7C+E47YPzMkn1x74axwQYQ
	 jqkKBdGSkI3L9wcDkcvBLQXQ0gJH91RmSokyUPvKS7ztUjpXb7pRZVvs1ZZd4yw8yr
	 4e64YhLCIAUB3aMxBccNLLD/Ufe0FptHj3Ti5/hS3Q8xKVpLgs/H4SsOT0Ym8FJQu6
	 8UG8tI4ayI+HCSbG8lC9aew6k71VGwP3h7BHG457NDGBIkcPlcusrIqIj1KF7oa2Q4
	 bdHSaQ2aZKIdg==
Date: Mon, 8 Jun 2026 15:40:30 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: Marc Zyngier <maz@kernel.org>, catalin.marinas@arm.com,
	oupton@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Message-ID: <aibUXmzfDsVWcZjY@willie-the-truck>
References: <20260501114447.2389222-2-sebastianene@google.com>
 <86wlxgy00t.wl-maz@kernel.org>
 <afxuDpecPCVA56cL@google.com>
 <86se83xrwx.wl-maz@kernel.org>
 <afyd8u85L5XIl6dh@google.com>
 <86qznnxptx.wl-maz@kernel.org>
 <af3fW468-f1KXCrC@google.com>
 <ahmxiFXXTupafbXw@willie-the-truck>
 <aibQHiYimPP1ylk3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aibQHiYimPP1ylk3@google.com>

Hey Seb,

On Mon, Jun 08, 2026 at 02:22:22PM +0000, Sebastian Ene wrote:
> On Fri, May 29, 2026 at 04:32:24PM +0100, Will Deacon wrote:
> > I'd probably structure it as a separate patch per call, tbh. That way,
> > the commit message can talk about the specific fields that are reserved
> > for a given call. See below.
> > 
> > > Refactor the handling logic in pKVM FF-A proxy to support checking for
> > > SBZ/MBZ values. While at it, drop the do_ffa_mem_xfer macro and replace
> > > it with two functions that make it clear that we re-write the
> > > function-id with a 64-bit variant, to keep the same behavior as before.
> > > Keep each handler in an array of structures together with a mask that
> > > corresponds to the SBZ registers the spec expects.
> > 
> > Although I agree that we should be enforcing SBZ/MBZ paramaters (because
> > we have no idea what they might do in future versions of the spec), I
> > also think that doing this at the register level is too coarse.
> > 
> > For example, the VM ID parameter to FFA_NOTIFICATION_BITMAP_CREATE has bits
> > 31:16 as MBZ. So I think we probably need to do the checking on a
> > per-function basis, like Per is doing in his series:
> > 
> > https://lore.kernel.org/r/20260501-host-direct-messages-v6-0-3f4af727ed85@google.com
> > 
> 
> For the newly added calls like FFA_NOTIFICATION_* we can do that in a
> separate functions, but what about the other existing calls that have
> MBZ registers ? that was the reason for the inline proposal in :
> https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
> (to avoid duplicate checks).

For unused parameter registers that are SBZ, I think you could just add
a helper, e.g.:

	ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int reg);

which takes the index of the first unused register and then checks that
all the registers from there to the last unused parameter register are
zero. You can then just call that directly before you start parsing the
SBZ/MBZ fields on the used parameter registers and there's no need for
the table-based indirection in [1].

Will

[1] https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
