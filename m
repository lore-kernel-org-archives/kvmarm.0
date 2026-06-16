Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8046337D107
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 14:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781620126; cv=none; b=Y7UeBnHKiatm2AaMh0jlWI4bGkArbWDF8+TvjhR+x4K8KLXVBuNPYJMwK5mQqh5kkCRzF3PQ5fB1pmkYBnNHHNEEker7demzAm4zC3G+G8mG3YTX26LVy2XdKHwoah2o5cK2PCbe6wnAAokHp9lCdMkQi9vBlwK9aNAijzfoOq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781620126; c=relaxed/simple;
	bh=Ug2gH+wlgXaSRgfs2QwyaKVchPTCW6jXjXm6osLsaWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hocE8WuzlHZCMbv0FZzy52uR/uGgjEbuzcKQkklknHSe+/8wGA+SQDsswgu9Y4DIIgDF+B6QHJiHvxt1Pg3TIEYYmVwjpAotmX/0RZDIZr9/Hx7RQ7pQLK4eMPZfjN9CNX0t/MaojKpht/378aHx3QMXFocLpgu/4bmFUin76mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zd7lFlGd; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zd7lFlGd"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490bd64ca95so56695e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 07:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781620124; x=1782224924; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WN0VoyJSdGBAv/IhP+imIDKlWMbgWzg/nEEnuq2GZ8I=;
        b=Zd7lFlGdomdS0y38EuGoFoWDwKJ2Jeftnlz/iG+AWXyI75Rx/TVfGR+D8VFTe28ecm
         ZdwLd0iRPEiR6sptCqN7Liw41ZQ7PB9VVqtpbjMxNl/9rooRQT2CLgCd33MBuc9IicMi
         jDE+I6CiMkH6+grEqszJ95hFsUhDLgoFtrRlEyGTI00CaM1cDEULQ0QJ8gHmTy+o4dyz
         o0cUbnmRT7NpKABrBF4gTcqHZ6MJMO12lsboQ9p+dQZTayxIXLIPGzvnRIsWNBhvTF0F
         zt2JIOwGbWW8VME+qJ1hCM7uAUHVxbnAM7vlf9+HPZRcwIf9KRi4fdXHdvFBmPpus4H+
         pUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781620124; x=1782224924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WN0VoyJSdGBAv/IhP+imIDKlWMbgWzg/nEEnuq2GZ8I=;
        b=HHqsufhusWE66S4k5OL5vshczpXOkPgN3wx1DiQ9whq3/P7raXkwyzNwd0PqLNLZ3u
         jrv+MxPO2Wvglq4bOySdAv2WVoJyup6GNmDyzl5w/C1v646lopajRI0AuhzifPEs5tDU
         vQXw4xevSsCgd+E0XvbNbCc2J6Zb9tiU2dKokHb5n+0fWfQ50Ft79Bj1bXjuIzhSni0/
         D67G1QhkrbR42/LoWnrYhJEfzVHrntFaCe1h+0ovQRxK/MExvpubHnosVWU5WmBSc1Co
         SAeadVlRNYY4IwoJ4iUrOi98b06dvIs1SWOAyy01X6Ywx/7Y33RpIUGhb6XmcO2PtcU4
         Ltrw==
X-Forwarded-Encrypted: i=1; AFNElJ8cbaYHzklFu3IGBRHmfxKQADiYeJZ+ZzRAS0Zh6YxErEatIdEX0ZnSfRiki7FT/g5t7PIjG3A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzKIBHRoKNXdQB6+4Ek3WRiLhAPI87LhpykjUHgQIIVc/7ZYf0
	nNoH54/AmcCLFBHaaH5EJq3dveG8LXcjLAkjTDSJlbJWOKBXVFve1z6+LTNn7iL1BA==
X-Gm-Gg: Acq92OFdsF9WJWaXp7XcG0841OZ6MTE/jDD6/EWogpFLVecJ/Jfr8WxYhhRrZiBA9mP
	ku+GQ92/waRRKTVY9tJTUFCZIYN++PBUxCwidBI63nGDxcGZreUaYYt+1Lp20UgTcXcr/iMbyCn
	/gXSElSUsmNxFtEV9F0HaDunR+YL2EQrw9rzCjOLvpBgTMyw/ejtoy5y2cz6uo/2UPKCuWzCeOO
	Mm/WSg5vTie3KYG5A2FIlVbg6mFC/0o0ivIQVGERg8Ai59F3teTuYzuamvb3Ds+6AIpRMG9bwWW
	y08Dk4qhzg7BJPlcTpw1ygonP6VRNhh2Fh8zT6SLR5uBOs00UA6wkMWMoIf9mRFCtp5th6d6x+i
	pPtY3q7pqxxpso/Tr2rgettyZ9cfu/0jB+ICtCPmuWyX2jVqUDLGngWXpZHzu37M2LCNDpOppot
	CHLyPFoOPYYWMAwnLuaR0Tpe7ctNXSRVIu8LB893R2YPP1WCLwY8kclmgnTCPiK9xnI12kXw==
X-Received: by 2002:a05:600c:68d9:b0:48f:d634:b18d with SMTP id 5b1f17b1804b1-4922ffc8997mr1004755e9.8.1781620123211;
        Tue, 16 Jun 2026 07:28:43 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4619a041986sm20994761f8f.23.2026.06.16.07.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 07:28:42 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:28:38 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 1/7] KVM: arm64: Support
 FFA_NOTIFICATION_BITMAP_CREATE in host handler
Message-ID: <ajFdlmLQ8q4J-gMH@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-3-sebastianene@google.com>
 <ajFEOK3bVu5QRoCv@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajFEOK3bVu5QRoCv@google.com>

On Tue, Jun 16, 2026 at 01:40:24PM +0100, Vincent Donnefort wrote:
> On Tue, Jun 16, 2026 at 10:54:09AM +0000, Sebastian Ene wrote:
> > Allow FF-A notification bitmap creation messages to be forwarded to
> > Trustzone from the host and introduce a helper to check for SBZ
> > register fields.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 36 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 35 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 1af722771178..b1e5f9ee86ef 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
> >  static bool has_version_negotiated;
> >  static hyp_spinlock_t version_lock;
> >  
> > +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> > +{
> > +	int reg;
> > +
> > +	for (reg = first_reg; reg < 17; reg++) {
> > +		if (cpu_reg(ctxt, reg))
> > +			return true;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> 
> Hum, there's something a bit weird, as this function was introduced already in
> the previous patch. (and both have the same number)
> 

Something is messed up here, I will have to spin a new version. Thanks
for letting me know.

> 
> >  static void ffa_to_smccc_error(struct arm_smccc_1_2_regs *res, u64 ffa_errno)
> >  {
> >  	*res = (struct arm_smccc_1_2_regs) {
> > @@ -676,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_MEM_DONATE:
> >  	case FFA_MEM_RETRIEVE_REQ:
> >         /* Optional notification interfaces added in FF-A 1.1 */
> > -	case FFA_NOTIFICATION_BITMAP_CREATE:
> >  	case FFA_NOTIFICATION_BITMAP_DESTROY:
> >  	case FFA_NOTIFICATION_BIND:
> >  	case FFA_NOTIFICATION_UNBIND:
> > @@ -862,6 +873,26 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
> >  	hyp_spin_unlock(&host_buffers.lock);
> >  }
> >  
> > +static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
> > +				struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, vmid, ctxt, 1);
> > +	struct arm_smccc_1_2_regs *args;
> > +
> > +	if (ffa_check_unused_args_sbz(ctxt, 3)) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	if (vmid != HOST_FFA_ID) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	args = (void *)&ctxt->regs.regs[0];
> > +	hyp_smccc_1_2_smc(args, res);
> > +}
> > +
> >  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  {
> >  	struct arm_smccc_1_2_regs res;
> > @@ -920,6 +951,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_PARTITION_INFO_GET:
> >  		do_ffa_part_get(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_NOTIFICATION_BITMAP_CREATE:
> > +		do_ffa_notif_bitmap(&res, host_ctxt);
> > +		goto out_handled;
> >  	}
> >  
> >  	if (ffa_call_supported(func_id))
> > -- 
> > 2.54.0.1099.g489fc7bff1-goog
> > 

Sebastian
