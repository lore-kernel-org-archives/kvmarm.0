Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651FF270EDF
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774454562; cv=none; b=gPiP4ln5yESbrXdH3dnfqWDxUnD1I3x1cZTwUINIuYqLwUN1sFyPUX0O+7NEoPVvaBdGpo7KOfLahO/dx/ChX4lhsEleDQ4m13DhtmMEolLrlf//NJb8WQqeLZYE57ICUznjNmq+v978sXEuHwydUKiljyBZGOwweYew0lq5S3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774454562; c=relaxed/simple;
	bh=YSWQf+GijsIHiMgv8SsmJ8hEaUf1GWy1zdLcHzm1lw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8qpAHZn7SQrKFWxLzCsF1UTsH7G2xxiFHzWWoSBjTT+O5logyqQrHC2Qc7n6xmZikVsd7bLB+fdcUE3Ll8yJLpcSsMbgm3G6KMxcGvNshV9HnDD3KkAthnwRXMZo7dQAvT8WzxikEou6vqPEujr+3QFTtGVaVdqPJb2dhH1hdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qe6attFp; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qe6attFp"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6628cc1bd69so10361a12.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774454560; x=1775059360; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WOREcibyjzFVZRo0vDoLHxQ7fmZD72bSMhFFQGI9zwo=;
        b=qe6attFpcxyMNoAofBR/n7AgKNdk5qHPmLDIgGyXVGthDbXcnsb+i3bgQugsuLvu8K
         yGW+zNmq0eyDeVN2+DfPxONemSKSblW0YXqj9lQo4jLLl3J5t6QGshaNx2iAx0anuMMQ
         cO5GB05oDSykzy5wbBehvyVC5So39YzPlxM8q6RaJvA83q4SzuU6CBq4wM579zoEut/Q
         Xvi8dW5dW5Spjf8ir5a8cDbS28ZOdijULq+4C0pVJRk66y1pZPGwSn9l9+kIySXq7OS5
         3LcSXOpvfiwP51V8Iqn7GLwW0ugod4ELla7gS6BLDHuKatW2iThjarcTqU+6wFSAcT9b
         T0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774454560; x=1775059360;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WOREcibyjzFVZRo0vDoLHxQ7fmZD72bSMhFFQGI9zwo=;
        b=B++B0MQ34YEnYDP0mCKa0eQ5yE52NaP0WX9+oVYHJW518oRAY7R1+Mi/DsEo4QD45d
         qMwJmykNu9+uLuIPTCSjp7ZW7OQUfd6wiX+GkaChVhtKiOsmEB2PzVAOoIb6Vktur3BZ
         gK7tEuiG8DOvkyCy3w1+fwu0CDG6CVIhnpqFQHndujQhjiWzxfNyLrYhMjHeM7Bpilf2
         ylnUZeLvRvOZz/oOFGsFHStNi4Uoq3/JzuIMLcCPCL4pyfulbIQtRySSVJ/qsWoFAIdw
         rViWklIMmOkk4zeZAVhBi/dUqvbB79D6v2gcG+0ROA6m9JxfxAFrO6uoaMM6gIYZKcM6
         LYmw==
X-Gm-Message-State: AOJu0YxYyfVnU8D+eD0cWxBj5Cpj1ew4fYgedI0kwjslj6NINAC549Yd
	kczL7KfLMcapzdj9yjqpCdqVfqnHySHSM4bAiT/5BdXRrT9VsSO5PeaCdZLvUv/pLw==
X-Gm-Gg: ATEYQzzUwIX1L3G223GaerwtOCIb0M/EZBilrGzhBLBONAnYFVMI+73Yln27xGAwnVB
	P6/G8xP/j6dyf/CzifClX4Pp9/A88AgYuVxdeb9ib4cLySDKZV9kNGorn5NZ9MSV7apQjAavsoj
	m/EyQJ1EaJrBKxGJH/pDdjqupJlV7y1+FZJvesUi1DXha/HhUggysKuisaIjj06pCzTMx8Nnphd
	zlr0woh7YlY/Iad9WQFGEl2o02kAIHPv/Q68mDuRVPrmS09Tt3nY7hkxNezV5Tw1yTrbs4HGOVl
	PwD7lgC/5MXKYYlvwy44Ke7VL5fvfeCOu7VTTkHrPfBcArimxv2i9T4cnmUFTwmPgMGQNwK3UIV
	e5vAmiaqF3DJpGCQBH/ZYgAXJR090O2DOI6OCsWMix5R40TDJoSwRBhcJ6FLysgqokrP17yf4NT
	ajBBFPw6D5f+7OlqeUNMJYg+QKZ8Ixsvr1q9eggkOu0FMOWpPLllYmjTsoNqfQe8S1Fws=
X-Received: by 2002:aa7:d1c5:0:b0:665:d39:4afc with SMTP id 4fb4d7f45d1cf-66a8274c788mr44728a12.6.1774454559069;
        Wed, 25 Mar 2026 09:02:39 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9b20265cc0sm4031066b.15.2026.03.25.09.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 09:02:38 -0700 (PDT)
Date: Wed, 25 Mar 2026 16:02:34 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oupton@kernel.org, suzuki.poulose@arm.com, tabba@google.com,
	vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acQHGivPRWuVCkxJ@google.com>
References: <20260325113138.4171430-1-sebastianene@google.com>
 <acPi5V0DgGcgHNGO@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acPi5V0DgGcgHNGO@J2N7QTR9R3>

On Wed, Mar 25, 2026 at 01:28:05PM +0000, Mark Rutland wrote:
> On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> > The ARM Service Calling Convention (SMCCC) specifies that the function
> > identifier and parameters should be passed in registers, leaving the
> > 16-bit immediate field of the SMC instruction un-handled.
> 
> That's not quite right; the SMCCC spec says callers must use immediate
> 0.

I'll update the commit message. it is the pKVM that doesn't handle it
(the imm16).

> 
> See https://developer.arm.com/documentation/den0028/h/ section 2.10
> ("SME and HVC immediate value"), which says:
> 
> | • For all compliant calls, an SMC or HVC immediate value of zero must be
> |   used.
> | • Nonzero immediate values in SMC instructions are reserved.
> | • Nonzero immediate values in HVC instructions are designated for use by
> |   hypervisor vendors.
> 
> > Currently, our pKVM handler ignores the immediate value, which could lead
> > to non-compliant software relying on implementation-defined behavior.
> > Enforce the host kernel running under pKVM to use an immediate value
> > of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> > error code back to the caller.
> 
> From my PoV, it'd be fine to turn a non-zero immediate into an UNDEF:
> 
> * For HVC, we can say any non-zero immediate represents a request to KVM to
>   inject an UNDEF.
> 
> * For SMC, the dbehaviour is not defined.
> 
> I am also ok with returning a value in x0, BUT that's stronger than SMCCC
> actually requires.
>
> Mark.

Thanks,
Sebastian

> 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> > v1 -> v2:
> > 
> >  - Dropped injecting an UNDEF and return an error instead
> >    (SMCCC_RET_NOT_SUPPORTED)
> >  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
> >  - Updated the title of the commit message from:
> >    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
> >     smc with imm16 != 0"
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index e7790097db93..4ffe30fd8707 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
> >  		handle_host_hcall(host_ctxt);
> >  		break;
> >  	case ESR_ELx_EC_SMC64:
> > +		if (ESR_ELx_xVC_IMM_MASK & esr) {
> > +			cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> > +			kvm_skip_host_instr();
> > +			break;
> > +		}
> > +
> >  		handle_host_smc(host_ctxt);
> >  		break;
> >  	case ESR_ELx_EC_IABT_LOW:
> > -- 
> > 2.53.0.1018.g2bb0e51243-goog
> > 
