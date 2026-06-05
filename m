Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025AB3D75C0
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649015; cv=none; b=XWGBCH0dGyjyTu26zaDz32y2uf9/ErPXykDH7U/WDu4dqHeIEhxT7KBgc2bZX3lqDc2RV8xttuPsMTNXySSn+LMGShDUYP9tfXtyT0Dq1Yo6F2soN4VY3kduBKWTWopq7hg9Rtlf908O/FGeOUqN2yt5vzdyZ/akuFMNleayVgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649015; c=relaxed/simple;
	bh=RjIk4j1aUD9IqrrCQms3rV/mwtEdld0zNezAD5SNcmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoGMpCQ4DyHgCX/ujkZwPcRZEtyCwYS5SKv2g0cHySf4Pzq2jgZtFLDXgD1ihpsPlf1E0ecmfS02+MdGnGrJpfyz1QRgMJALtZntDP0MqfT3x68BJpqUV+j5zeUoPqALAwsLZV2KFO+2QYhmxKkO4TjaSDuuJFTNhHjTAlXzjkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxSEptM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxSEptM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5930A1F008A7;
	Fri,  5 Jun 2026 08:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780649013;
	bh=xomH7vFXWWtjI+devX73Or32J/jQoae12DQTVZVqU6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MxSEptM2U7b3TTvsRGnvsifV7/2mvhUon8g+ClkaM3W3XTRJlMSyNNELzD6lEOGuR
	 8ms6RqLA8oJtaUJRIxlfVa7Ajpecpkm5C0qLki/zwwVPY4xnVsFB6hj3oHYJ0v5QGF
	 /ljPAV+X1LdB+UoULpHhNqCIdeCg1YhEF7+2Hczm4flYNIjzKyTIsfD78NieftTSh8
	 6XbmJDFnv55i1GzKK8i6YwOZPWUz6NOAyWoxVWkqZMvGWt2NqJ5uR3FQN4QyXO+3KQ
	 15GMRsCJ6WZe9BgoDPhmZHsEhFCVrVF9lFHWZ3HQV5lEQpaR6RkjNyNdbnm8WjBvmK
	 jw10Oqk5rBf7Q==
Date: Fri, 5 Jun 2026 01:43:32 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com,
	jic23@kernel.org, timothy.hayes@arm.com, eric.auger@linaro.org,
	christoffer.dall@linaro.org, andre.przywara@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: vgic: Check the interrupt is still ours
 before migrating it
Message-ID: <aiKMNIUMv9GQiIbD@kernel.org>
References: <aiHnI1mu6SGQrgnz@v4bel>
 <aiJmBfXAxcytfGha@kernel.org>
 <87ecila0w3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecila0w3.wl-maz@kernel.org>

On Fri, Jun 05, 2026 at 08:42:52AM +0100, Marc Zyngier wrote:
> On Fri, 05 Jun 2026 07:00:37 +0100,
> Oliver Upton <oupton@kernel.org> wrote:
> > 
> > On Fri, Jun 05, 2026 at 05:59:15AM +0900, Hyunwoo Kim wrote:
> > > vgic_prune_ap_list() drops both ap_list_lock and irq_lock while migrating
> > > an interrupt to another vCPU. After reacquiring the locks it only checks
> > > that the affinity is unchanged (target_vcpu == vgic_target_oracle(irq))
> > > before moving the interrupt, which assumes that an interrupt whose affinity
> > > is preserved is still queued on this vCPU's ap_list.
> > > 
> > > That assumption no longer holds if the interrupt is taken off the ap_list
> > > while the locks are dropped. vgic_flush_pending_lpis() removes the
> > > interrupt from the list and sets irq->vcpu to NULL, but leaves
> > > enabled/pending/target_vcpu untouched. As the interrupt is still enabled
> > > and pending, vgic_target_oracle() returns the same target_vcpu, so the
> > > affinity check passes and list_del() is run a second time on an entry that
> > > has already been removed.
> > > 
> > > Also check that the interrupt is still assigned to this vCPU
> > > (irq->vcpu == vcpu) before moving it.
> > > 
> > > Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
> > > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > 
> > Looking at this and the other VGIC patch you sent (which should've been
> > a combined series), are you trying to deal with a vCPU writing to
> > another vCPU's redistributor? I.e. vCPU B setting GICR_CTLR.EnableLPIs=0
> > behind the back of vCPU A?
> > 
> > That is extremely relevant information as the off-the-cuff reaction is
> > that no race exists. But since the GIC architecture is awesome and
> > allows for this sort of insanity, it obviously does....
> > 
> > Anyway, for LPIs resident on a particular RD, there's zero expectation
> > that the pending state is preserved when EnableLPIs=0. So I'd rather
> > vgic_flush_pending_lpis() just invalidate the pending state.
> 
> Just clearing the pending state introduces a potential problem as we
> now have an interrupt that is neither active nor pending on the AP
> list. It is not impossible to solve (we now have similar behaviours
> with SPI deactivation from another vcpu), but that requires posting a
> KVM_REQ_VGIC_PROCESS_UPDATE to the target vcpu.

Right, I was suggesting that in addition to deleting the LPI from the AP
list we actually invalidate the pending state so that someone sitting on
a pointer to a to-be-freed LPI sees vgic_target_oracle() returning
NULL

> > Beyond that, I see two other fixes for lifetime issues around the
> > vgic_irq in the middle of migration. I'd like to see explicit RCU
> > protection around the release && reacquire of the ap_list_lock rather
> > than depending on the precondition that IRQs are disabled.
> 
> I'm not sure I follow. Are you suggesting turning the AP list into an
> RCU protected list?

No, sorry, I should expand a little.

We store a reference on the vgic_irq struct in the AP list, which is
stable so long as the ap_list_lock is held. It should be possible for
the refcount to drop to 0 between releasing the ap_list_lock and
reacquiring it.

So either vgic_prune_ap_list() takes an additional reference on the
vgic_irq before dropping the ap_list_lock or rely on RCU to protect
vgic_irq structs observed with a non-zero refcount.

Thanks,
Oliver
