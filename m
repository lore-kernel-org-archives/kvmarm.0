Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DAC38D3F9
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 08:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167639; cv=none; b=V6p6aju7EvBWcOcMhnnvu3hFKunmBfl/9f2zv7C95MmeMrTB3vzuQCtm8ZsGFSkjOEwY+7Iksg97CaYQ9GtBASOJcdkca0zdtM0f6cbhAp8C0G5zqV9WEPh9/KbvdrSiyRXI20bK92EIbJ04eNbM/Ht/rwcorzlhcacUHKoBxzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167639; c=relaxed/simple;
	bh=6GRgpmQ11YqUvsN8GpHounNBRSMDuddaI7rINzjCMvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RyQRY8dJTvb86WBwGFmKNl5VBQaPFbTCYK2dfF7weC9g1iNKpSdWnkBpx1YB5W6ISftenQGAZY9bJ/hZS7130/wd3ZwIv+A7jOHNjxi3GUfcKs/9/BIPe9KD6ZEWG6RXWMCx6cyybNvKSfvupfD4doWq0IclEzKYjZgB1/Bhh/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=niCxdw67; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="niCxdw67"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b23c828aso40975e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 01:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781167636; x=1781772436; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tGU8nVvV78ihw3NmTIZ6FVq1Rp8AH5EC4+xF0UY8JZg=;
        b=niCxdw67GV6hRRPQ2ApELsq0fl7EoBjDgcPRJcYt4o8QQqJu/WqVFF5e0JKx3p7ZcQ
         fu2tmCD0PpAVcsq2KS3LHJQTBKCxB65Fh01yX38RJwFVb9WJVF7m4l5ZQhACW6Dj6BjX
         E84rHbSONbCjdWOFSuQkSvKtJZd1GTBVVZRZAoIcqpUausuLvwQhvpdGHVBmYFH8G5IG
         ZHWqhc3wnkIZuyyLQ9t6UcHGrdPF/yLKx1n++b9WV1cUpQFdug1vC2Ls3jvrKMifXgGR
         2Xrxr3QRJT/Y+j9uAcy41BgpxGbkJGqYW3vPWp9TzFSy6hXLsihxg7dsRjvMtRiWEwtw
         ZbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781167636; x=1781772436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tGU8nVvV78ihw3NmTIZ6FVq1Rp8AH5EC4+xF0UY8JZg=;
        b=b7/MRrUtBlRkgOPqEHCej+LxhrPywD3KYKJhp8edH+BBRehxpkNKkoa+p2aV/qiBj1
         MjONnrX90C1/GFRghiDxBiR0gXiEcT7sQRJsjKkdfZXsDEvH2RDt8UI0Xc76NRVnwbpr
         DhxDJ6XUimr7fu83UZ8FTRgKPj8/AhEfuug9b/p1MOM7QeZjPdYbwqlS/NHk76c5Kx6z
         Bzxxpc/OO4z5vd1QoT/GHfDEjuYiMzrGmlQPZJ+lcO4s5fb0VjHQgRlEhF8RY49rmDRD
         vsqXJ+xoWA3so5Sv3JEdvck1mlgrFQQy3XEEAxx8jHTTA/FZ8ugIwRaORd0YekznSTOH
         Tp3g==
X-Forwarded-Encrypted: i=1; AFNElJ9PwQXzj0MzqN8H9OzGIdPazbz+fp52YzN3PBg1CyaXztxL88SMpnRPBZylknmhLoAaPpwhM1w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtggOuDjmA3vV4peMYwyemGd+JFp4WzimhAxs2757idi6fqM23
	/xbyi7XcYuAmKTXDMXQwuJJ3jhJLV0f1nRKBOnOEAfc1J4l/0y9V9jlPELmDOIUHMg==
X-Gm-Gg: Acq92OG7YmyFyzNwumnvgyGJjTxITwYTqv44PoWH2SKOvZVnYhgk7SkSdKd57RK70m7
	/73Jk4DiRvQPJYNHDIArVZgolQo+LrHYfwOSlggZIaD3AqjuQ8EAiPB/YhDDSVpFQhXKb/KTg9B
	unqitYixEAMAUGkdHEmmR2Tbbv7N1FumkUQPo6KBV8TBXYwlOBW7cKYQgG8YxUZBIetkodvRCMY
	/U9XfYjw+FcfcY1u+kKqWkxCnExHrj1FdOPTopwx+UuM1vGq2gIokgfUSs7Jv+dJxh5Ai+R3uLw
	CmemCgN6LNW/ft8BT3gn1a4KuZFt+bWxT4BfHNnLVkBEBb75KjHqZ0OD3VcUB3jSpPau8VJofzs
	7u1ja94GUBwSbgPMswf1KxUDSo13+tby7YTMMFs2htX4baHOZnFAkunKoNiuIIgJYKLbeTFU4BY
	zU+mhupNP81miGYp2TK7ctwhK6vagy1E/kyZwk6EfX8w38F52FQ+eCUlWoKpwr5G1GJN4foVoJl
	0TdqumF
X-Received: by 2002:a05:600c:1d08:b0:490:b0f1:3422 with SMTP id 5b1f17b1804b1-490e47a5322mr838045e9.10.1781167635397;
        Thu, 11 Jun 2026 01:47:15 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46028a6dcbdsm66597719f8f.7.2026.06.11.01.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 01:47:14 -0700 (PDT)
Date: Thu, 11 Jun 2026 08:47:10 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 2/7] KVM: arm64: Support
 FFA_NOTIFICATION_BITMAP_DESTROY in host handler
Message-ID: <aip2DjVsuFIsxLpo@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <20260608165549.1479409-3-sebastianene@google.com>
 <aikmBBHEUfolXrHC@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aikmBBHEUfolXrHC@google.com>

On Wed, Jun 10, 2026 at 09:53:24AM +0100, Vincent Donnefort wrote:
> On Mon, Jun 08, 2026 at 04:55:44PM +0000, Sebastian Ene wrote:
> > Allow FF-A notification bitmap destruction messages to be forwarded to
> > Trustzone from the host.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
> >  1 file changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index c20d45191085..91e89d889c44 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -688,7 +688,6 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_MEM_DONATE:
> >  	case FFA_MEM_RETRIEVE_REQ:
> >         /* Optional notification interfaces added in FF-A 1.1 */
> > -	case FFA_NOTIFICATION_BITMAP_DESTROY:
> >  	case FFA_NOTIFICATION_BIND:
> >  	case FFA_NOTIFICATION_UNBIND:
> >  	case FFA_NOTIFICATION_SET:
> > @@ -893,6 +892,26 @@ static void do_ffa_notif_bitmap_create(struct arm_smccc_1_2_regs *res,
> >  	arm_smccc_1_2_smc(args, res);
> >  }
> >  
> > +static void do_ffa_notif_bitmap_destroy(struct arm_smccc_1_2_regs *res,
> > +					struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, vmid, ctxt, 1);
> > +	struct arm_smccc_1_2_regs *args;
> > +
> > +	if (ffa_check_unused_args_sbz(ctxt, 2)) {
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
> > +	arm_smccc_1_2_smc(args, res);
> > +}

Hello Vincent,

> 
> Sounds exactly like do_ffa_notif_bitmap_create. Could we use a single one
> "do_ffa_notif_bitmap" ? 
> 

Yes, I guess we can have only one method since the only difference
between them is in the number of unused args.

> > +
> >  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  {
> >  	struct arm_smccc_1_2_regs res;
> > @@ -954,6 +973,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_NOTIFICATION_BITMAP_CREATE:
> >  		do_ffa_notif_bitmap_create(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_NOTIFICATION_BITMAP_DESTROY:
> > +		do_ffa_notif_bitmap_destroy(&res, host_ctxt);
> > +		goto out_handled;
> >  	}
> >  
> >  	if (ffa_call_supported(func_id))
> > -- 
> > 2.54.0.1064.gd145956f57-goog
> > 

Thanks,
Sebastian
