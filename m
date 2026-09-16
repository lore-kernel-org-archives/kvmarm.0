Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D6361965
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 19:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789585622; cv=none; b=sHN8xpbGg/ncHMCfyO2/fVmt6dAfo2N4DdbgVAXIcd81N05FuxV861ZDTaEkyt/XkFkkRQ4Po9+MrQgofoHQBEA+tSjT+brvFrN79AacJdcrCs4bXYXa1YlJt71GLQKNkhxT8RxZYl115xCKWxbj+R7Z4c45meBNcPmGKkw066g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789585622; c=relaxed/simple;
	bh=clIAd+ElCPuqeSOiRCrGYr2080Rs0+u4Ja4zpAJS57o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dg6sfijgpJkvdUTVHPqHmfbx5anqyk0/BQxuTfZeQfsVJ2GgEFjmnmMJKmXVxstO4uWiGYwf+KeaeMHzTpckdfM1kamXYWaRbaW7+iLxgF+p6B86l5eEhEMCn4bPJRDfhYBb490CQ6pT639nsUdmd/4dxeKOv8nLFSPRuMG66dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mSpdKaM6; arc=none smtp.client-ip=91.218.175.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mSpdKaM6"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=clIAd+ElCPuqeSOiRCrGYr2080Rs0+u4Ja4zpAJS57o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789585604; v=1; x=1790190404;
 b=mSpdKaM6l/DK8WBKKybXFLMOJSNj12S0FO2rPXyAM4B1gleODzbgNvFXNo46YjGGdF5o8QU7
 wqC9fzIs2oyJaz9Uh7TGwzee7lwEE0de4SmugZ0nTsZr2u/fYp/awToJ1EJScSMKXXyROJdCAFH
 xEPcjiulE5VxgwKYpMfaT4Pc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2ddb626cea38722f;
	Wed, 16 Sep 2026 19:06:34 +0000
X-Mizu-Trace-ID: 2ddb626cea38722f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so839e87.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 12:06:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz43diDfEujjTK9ZhFpHz3gqjybdaA2kB4TuOBlpAkYeFkjTTWvQ2Q++Oc/D7Dj2jaLFwGa2EU=@lists.linux.dev
X-Gm-Message-State: AFuF++mHuHwK1p96tOYtZKFR95iV6QqWpOCB5HNjR3Q+UD3eZgRyiJus
	MnSM8KBsckiBHpTkoXrwcLs6xzD1sl+2zFUTIgivq3QFJ3Ija3dFf8irbpNkRpLWjj4SP5CK7hx
	EzUGGT6HO9G6ya0L67YIQGKee6nylkeInL/+Cmnn9
X-Received: by 2002:a05:6512:3d10:b0:5b8:b380:3c89 with SMTP id
 2adb3069b0e04-5b8ba99b7ffmr23508e87.0.1789585593571; Wed, 16 Sep 2026
 12:06:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-15-fuad.tabba@linux.dev>
 <86bj9x5fhj.wl-maz@kernel.org>
In-Reply-To: <86bj9x5fhj.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 16 Sep 2026 20:05:57 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy8R3yxFHmTti9mBgjQGJKnH44v9WvDQ2k9cWFECaYoQg@mail.gmail.com>
X-Gm-Features: AcwNN1X5PZX5WDCSedlv_R_n84PSTr-QRRvORTCqs34THsNi7n9PRABFR4_9-2c
Message-ID: <CA+EHjTy8R3yxFHmTti9mBgjQGJKnH44v9WvDQ2k9cWFECaYoQg@mail.gmail.com>
Subject: Re: [PATCH v3 14/18] KVM: arm64: Add per-EC entry/exit state
 marshalling for protected guests
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, vdonnefort@google.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 16 Sept 2026 at 17:27, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[...]
> > +static void handle_pvm_entry_sys64(struct pkvm_hyp_vcpu *hyp_vcpu)
[...]
> > +        /* If the host emulated a read access, update the register */
> > +        if (pc_update &&
> > +            !pvm_sys64_is_write(hyp_vcpu->vcpu.arch.fault.esr_el2)) {
> > +                /* r0 as transfer register between the guest and the host. */
> > +                u64 rt_val = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
>
> Why isn't this
>
>                 rt_val = READ_ONCE(vcpu_gp_regs(host_vcpu)->regs[0]);
>
> and similarly everywhere else?

Old code momentum. I'll use the accessors throughout in v4.

[...]
> > +static void handle_pvm_exit_sys64(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +        struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > +        u32 esr_el2 = hyp_vcpu->vcpu.arch.fault.esr_el2;
> > +
> > +        /* The mode is required for the host to emulate some sysregs */
> > +        host_vcpu->arch.ctxt.regs.pstate =
> > +                pvm_host_pstate(hyp_vcpu->vcpu.arch.ctxt.regs.pstate);
> > +
> > +        /* r0 as transfer register between the guest and the host. */
> > +        if (pvm_sys64_is_write(esr_el2)) {
> > +                int rt = kvm_vcpu_sys_get_rt(&hyp_vcpu->vcpu);
> > +                u64 rt_val = vcpu_get_reg(&hyp_vcpu->vcpu, rt);
> > +
> > +                host_vcpu->arch.ctxt.regs.regs[0] = rt_val;
>
> and this should be
>
>                 vcpu_set_reg(host_vcpu, 0, rt_val);
>
> assuming you don't need a WRITE_ONCE() to match the READ_ONCE() in the
> other direction.

No WRITE_ONCE() needed, EL2 is the only writer on the way out. I'll
switch to vcpu_set_reg().

[...]
> > +static void handle_pvm_exit_iabt(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +        hyp_vcpu->host_vcpu->arch.fault.hpfar_el2 =
> > +                hyp_vcpu->vcpu.arch.fault.hpfar_el2;
>
> Please keep assignments on a single line (everywhere).

Will do.

Cheers,
/fuad
