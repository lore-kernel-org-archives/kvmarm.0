Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A302E2850
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 05:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781502226; cv=none; b=apZsMKvfrzYioledaVstqKVTey1E8IJ5eiGsy3vUxNMVBoqMNbwwTk5ZcKl7RfmUb0ZeZCihwsXiFOnYtwLClG32NYqVNREEGn7sFPHntWzjMWQcjFYeAnCiY8hZCrvMoM+p8yc6cIq03e4uYP3OKzA/fNHQfe73lOxcSC1GhDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781502226; c=relaxed/simple;
	bh=PAyBZ/v68XkJTiOFdQlAcbZEIASTp8CtcjFV43Wyop0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjRFM7jju3d3vCH4h/fUVsRxGcC0RCVl3L3ci8iei4+Y+Il57PWZpn5b/cSBCCACx4+0KoAnCpU0PcF0JGDq7Tj2tAJMHeD0zos5Xc6uOPdgfUE+dN9Mu6py2ovan1oqhRTC6ZIuaSE6COEqBU7vZ6FXo6m17KUJjc22i0VfrcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y8e7h7M7; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y8e7h7M7"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84236f9b638so1393532b3a.2
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 22:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781502224; x=1782107024; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BoUQNrGqm47SfMzQQZnlUAHB757FjtGMtZ/e1e1ss9E=;
        b=Y8e7h7M72LK9sAjzf+9UheZBHLm4EG98elacyJx3XDmfmc6fF3eRMn6lc9X/v0+/PH
         VDEC0yRbIs7Kj+trYPHLj4eoCdK7nUMbsdvY7n55FE37BN7jxKcXkvO27bJ/lLjubc1x
         myuzUG3ItuqeiX9ojsiSwawkZKzMcXgLsMwlFc109zEQUuleo9P/xA5wSXdRRpK7xc8M
         X9UkBOYRosq9zc2llmMcar6UOOdCzG0q7nLem/R6yLBQdxZvFuBLq4QpbD76dIpugepo
         h1ko7k5kou4NZrQSKr/4yNXuDZzUTDmrZY2rFZe6xFNS6mTThVx41PkOoJthodsuyqYy
         yYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781502224; x=1782107024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BoUQNrGqm47SfMzQQZnlUAHB757FjtGMtZ/e1e1ss9E=;
        b=Dmyebm7woDp7AyZ8NyWEcSH74rFB7ongEF4mDldRUrFffj7/5J+I1G2dr78rjhP1VB
         OqAYU5Yt16svBEqaBcZJiDeLbXwoKUHkSWxGIg+Y6P//+xnyEbNSfFwu6uUtRUFUgIbL
         tbQVbDBDJnIjZ4gqrj7eP9cmGxtLZnttLD7D/WuflMO+bqs/Xv8wnngQlXq626s2G7zF
         14ZE0JOIFKNQkltN2rzTy4yDS7NNygrQoFKB3vYfpBJ7r9wc3jZEuRrkfbjFPCFcRJk8
         Ist9Qx7i9L3U1xJ2w0jzQXdsmi9hfrhMxm8eDuZSrprcPSUOsmTtoIyW3bW3kh1IqlBN
         ChRw==
X-Forwarded-Encrypted: i=1; AFNElJ9PaLBrJjMLd2xtfhI8os326jGQdLJJW1zU9cOYpyFfw5WIUU0hPbs19wS7PgcOzOGqVl+BCAw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKP9ERZur+I/+PQaae4JXVWY5SfkqU9cf+cExFjXdQMqYd/4d2
	sUzYyLS69wTVRXl+pNk16G6J0iRkflBXhQHExPZmpBVds3EGNrOS/qtP
X-Gm-Gg: Acq92OFgUnGsw5cHHJJ7K/HZuIQGZuJ4mw9aFCBDNMfMawch4yXhQixjg02XUB+T5+y
	QbdSU36oGqb3uUG4wkMq+85oyoZaIATelOAN9G9BHn/3nu+ule8KDLf0NTNuV0OacO/zFtlIMnA
	D+nn2BulY1pWYVMNWAy1X6o8cQ2fHKsBBnOz7Ajn+DV7oDGap5jLRqLAwAHK9339RRgTcMHhVY8
	aKDDGDdQELAPktWOqUqKAjgv/wh3MDs50Xyu3fu+URGPb18ECXouaa2p6F4l3vKqk77rgiIaaJG
	NLYfQ6hkdRiQqonVtjOBLeCAcj2Pb0KdRxJh/b0B4POFtAnh7D7Ifs+cROulrYub+Kp31Xd4WHR
	WiQ8+vlg0GWFwWoSkpZspUngB/WWrwTmgVJSA8CCbDvmsQNwk0P3gYTU9+1N5l9LvMSslhn5gzU
	iis6Xp/taC12f56HKFRjKpB6a3CodVWTgMzQlvu5nqwrw=
X-Received: by 2002:a05:6a00:4089:b0:842:40f8:74d0 with SMTP id d2e1a72fcca58-844e193a46fmr10195772b3a.6.1781502224229;
        Sun, 14 Jun 2026 22:43:44 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b020b53sm8483438b3a.47.2026.06.14.22.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 22:43:43 -0700 (PDT)
Date: Mon, 15 Jun 2026 14:43:39 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, Sascha.Bischoff@arm.com,
	jic23@kernel.org, timothy.hayes@arm.com, andre.przywara@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: Re: [PATCH] KVM: arm64: vgic: Check the interrupt is still ours
 before migrating it
Message-ID: <ai-RC2FlxE5y38mP@v4bel>
References: <aiHnI1mu6SGQrgnz@v4bel>
 <aiJmBfXAxcytfGha@kernel.org>
 <87ecila0w3.wl-maz@kernel.org>
 <aiKMNIUMv9GQiIbD@kernel.org>
 <ailsCnyoS82r_QRz@v4bel>
 <865x3qtmg6.wl-maz@kernel.org>
 <aitta-IcWnRepEva@v4bel>
 <87ldch884j.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldch884j.wl-maz@kernel.org>

On Sun, Jun 14, 2026 at 04:16:44PM +0100, Marc Zyngier wrote:
> On Fri, 12 Jun 2026 03:22:35 +0100,
> Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > 
> > On Wed, Jun 10, 2026 at 05:00:25PM +0100, Marc Zyngier wrote:
> > > It's rather unclear to me what the semantics of this are.
> > > 
> > > If vcpu-a decides to nuke the LPIs of vcpu-b and the LPI had in the
> > > meantime been migrated to vcpu-c, but obviously not observed by vcpu-c
> > > yet as the LPI is still on vcpu-b's AP-list, then I don't see the
> > > point in keeping this state.
> > > 
> > > Am I missing something obvious?
> > 
> > I looked a bit more into Oliver's review, the one suggesting that pending 
> > be cleared only for resident LPIs while the ones being migrated are left 
> > in place.
> > 
> > What the leave preserves is the pending edge of a single LPI whose target 
> > is already vcpu-c but which is still on vcpu-b's ap_list. This edge is
> > always lost when we just clear it, but for a device that fires again a 
> > later INT reaches vcpu-c through the oracle, so it is mostly harmless.
> 
> Not completely harmless. When the guest writes EnableLPIs==0, it
> accepts the lost of any pending bit that could be stored. These won't
> be regenerated, unless the device signals a new event that maps to the
> same LPIs. But again, this is the guest's own decision, and I don't
> see a reason to prevent it from shooting itself in the foot.
> 
> > The
> > exception is a software LPI that never fires again(irq->hw == false): 
> > that edge is then lost with no way to recover it, because 
> > its_sync_lpi_pending_table only re-syncs the LPIs whose target_vcpu matches, 
> > and the disable path does no pending writeback. I am not entirely sure about 
> > this part, though.
> 
> I don't think this is a problem, as the architecture doesn't guarantee
> the state of the pending table after turning EnableLPIs off. There's
> even a note recommending to move the interrupts to another RD before
> doing that.
> 
> > 
> > Since this does not look like the common case, if it does not need to be 
> > covered I will send v2 keeping only the pending clear and the ref hold in 
> > vgic_prune_ap_list(). What do you think?
> 
> So that it is entirely unambiguous, my suggestion is to have this:
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 5a4768d8cd4f3..70a161383e5a6 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -203,6 +203,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
>  	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
>  		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
>  			raw_spin_lock(&irq->irq_lock);
> +			irq->pending_latch = false;
>  			list_del(&irq->ap_list);
>  			irq->vcpu = NULL;
>  			raw_spin_unlock(&irq->irq_lock);
> @@ -792,7 +793,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>  			continue;
>  		}
>  
> -		/* This interrupt looks like it has to be migrated. */
> +		/*
> +		 * This interrupt looks like it has to be migrated,
> +		 * make sure it is kept alive while locks are dropped.
> +		 */
> +		vgic_get_irq_ref(irq);
>  
>  		raw_spin_unlock(&irq->irq_lock);
>  		raw_spin_unlock(&vgic_cpu->ap_list_lock);
> @@ -836,6 +841,8 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>  		raw_spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
>  		raw_spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
>  
> +		deleted_lpis |= vgic_put_irq_norelease(vcpu->kvm, irq);
> +
>  		if (target_vcpu_needs_kick) {
>  			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
>  			kvm_vcpu_kick(target_vcpu);
> 
> Could you please give it a go with whatever reproducer you have?

I confirmed your diff fixes the issue. Could you submit this 
patch? Feel free to add Tested-by: Hyunwoo Kim <imv4bel@gmail.com>


Best regards,
Hyunwoo Kim
