Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EEB2EDD70
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 14:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781620400; cv=none; b=j/hNql3nBhZEBrF2+VbWt7JHMpJCAvm+ghxGb1bFUKzxLUGu0nbZcJj9abj4owN6apiNQT03zOIbFVvAKOsBi8bzZ6Bv3jWcZc+IIkaIfKaXVQzGYE3PQAdVwSw3E+D0ZhrbXSPPZfTzPkXsWGEkASRZ3+AKH23rXeMBoKx6gQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781620400; c=relaxed/simple;
	bh=JDlVAw31do8pzXcBPXaUpLcbDZRGQLlOAShH3nxUpos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmZDl2GZL20H8RjuJfF7wv4sazOPIBUW/gE41czt5kkxXQeLQ2/nJz6kSrRNQpZ+W50r+/lSKSLdc738BaTochjo98cQx4URA45UhYDXNlr6zS0w7EF188e2N/ufGIU2LwWNbW7Hq+knN+/rKb4PkAEnQTqbgJV6wsjTyJTjJo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r86RCg5h; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r86RCg5h"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490bd64ca95so57195e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 07:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781620398; x=1782225198; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G1A9QCNLx15SB0an96dcEu6XnxzvG/ZR/jjxiLCYEWo=;
        b=r86RCg5hpUp/jj8n33E2jpJUfTpW/loiTVDzDafBVxSo1UQZteqkRLwg1iINdIHNHj
         9uZtDPJYzLSaNJ8tIGdXHgNmK/H0iJCyiFnPqXqujXvWWnrpqC05itAIf4Lsayvu75kU
         xSNyJSg0PaTHWA0/u26JHdU7Pc5piU+3p9ii2PydiwJANhgIibf2dWKG1QY7ejCtTIUV
         U1PMWu1YO5krVxSf29+L4IcgG2FYrooLHGx6Wzs/Gw+1fK64WubO50LllTf/fExRldgp
         6JY/KsoO2/f5UjLlOOxPLGpTsKMrhVjBYmzn6sW5H7iu9aHhvI+EiQMNL5eVD9JmeGQb
         qB6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781620398; x=1782225198;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1A9QCNLx15SB0an96dcEu6XnxzvG/ZR/jjxiLCYEWo=;
        b=SMO5qfuxV+Dheam4hJbUI7Fxc9giwSqK+lAhkGEUuDxf9QO8YXASKCpgnBuNQc1yON
         9gditQtnejPeC1LqSVfoJaTLJ0TmKVWemw+2wMaJRwveWJZ4lb3GPntUI/X2dlsJGvBa
         F5NY1cHTNoZsTg0dtSR0DPkwFpg7evgq/UMgzft7LJS2b8t/acFBe8PzR3sKjjIZrMdt
         mZZB0huXYR6zYuZmccijRjMBuZBfrv64clo05NPN2OH1VNCf+JGIB3FSxIYpo4Mbua+X
         dlbJgq134MzSZ4RTiS7O7La9L4ChI8obKchRUKY766Q8k5n7zSzbWUjOjhCY5CRJ6PKF
         LESw==
X-Forwarded-Encrypted: i=1; AFNElJ9U/eMNeIH6mV7JCJkb95HSIJ0UL9zlY60C5fmIYkfIX4Usyu56SToyet64mIIRj7YWnO3bJHE=@lists.linux.dev
X-Gm-Message-State: AOJu0YylVu1S+YJRwl0vr621psyRqMkrEMeAzBtrc58fp9wPvdmaSSGw
	5TI9N1S7M3+RsIlFGLxPfmqfRXlFr2VTcy+jpJ/BVHDmqDdEq7XpGLmZ79Pm2R1dVA==
X-Gm-Gg: Acq92OFmtdxwTm7uWdFCJlGDs6f0j6Y9++ptpcM681hUckroxwekzb5LyiYjJlqhUHk
	fqPwqIoKJccMumT4x032Ha2jlasLrhHJKJ/1h3sXMLJdv6XW/wu7yzq6HRFraLXicddaPr4bNrs
	pW6YSIixd2yHhnUW6MP5f5rFicN5fM0LxyuoqGaiFFH7Qe4TO4ooW1RTlCPqg/Jaj2ePHWJFEFR
	70iRt9oPxhjpkcuQWCEigl2hAnM45rszVULGyFrWxLycEeZAXMuPbghnyVKdQma/LKnd/RV+WUn
	GDtBcHxafxnFstgw8kdHvvihwm6vCHo28iyqKlkrrILYPW8aesivhPO085JRMW6kci7UIbEWGqH
	FsW9RtMkUxXtfF+w80JRJCkbAK8zroopDJD2jf4uIW/r3s+576mlOq4APY1N4TbQb4rYTUjMqR1
	oQ6DkyLwdOkVB3trP6I/jvQJkyKHPN9aURRjoSfLHW5xO7B4+QOfej43E=
X-Received: by 2002:a05:600c:1c1d:b0:490:c2b6:de6a with SMTP id 5b1f17b1804b1-492308958dbmr1481635e9.11.1781620397230;
        Tue, 16 Jun 2026 07:33:17 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a458f2sm64331015e9.3.2026.06.16.07.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 07:33:16 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:33:12 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 2/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls
 to Trustzone
Message-ID: <ajFeqC03MnWPSv0A@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-4-sebastianene@google.com>
 <ajFEu3rjmWxVKgyW@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajFEu3rjmWxVKgyW@google.com>

On Tue, Jun 16, 2026 at 01:42:35PM +0100, Vincent Donnefort wrote:
> On Tue, Jun 16, 2026 at 10:54:10AM +0000, Sebastian Ene wrote:
> > Allow FF-A notification bitmap messages to be forwarded to
> > Trustzone from the host kernel driver enforce checking for
> > SBZ fields.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 28 ++++++++++++++++++++++++++--
> >  1 file changed, 26 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index c723a21006aa..dc7496ec295f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -713,8 +713,6 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_MEM_DONATE:
> >  	case FFA_MEM_RETRIEVE_REQ:
> >         /* Optional notification interfaces added in FF-A 1.1 */
> > -	case FFA_NOTIFICATION_BITMAP_CREATE:
> > -	case FFA_NOTIFICATION_BITMAP_DESTROY:
> >  	case FFA_NOTIFICATION_BIND:
> >  	case FFA_NOTIFICATION_UNBIND:
> >  	case FFA_NOTIFICATION_SET:
> > @@ -909,6 +907,28 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
> >  	hyp_spin_unlock(&host_buffers.lock);
> >  }
> >  
> > +static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
> > +				struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, func_id, ctxt, 0);
> > +	DECLARE_REG(u32, vmid, ctxt, 1);
> > +	struct arm_smccc_1_2_regs *args;
> > +	u32 idx_unused_args = func_id == FFA_NOTIFICATION_BITMAP_CREATE ? 3 : 2;
> 
> nit: should probably better expressed as a int as this is the type in the
> ffa_check_unused_args_sbz proto.
> 
> Perhaps you can even fold that directly into the ffa_check_unused_args_sbz()
> call?
> 

Yes, let me try this.

> > +
> > +	if (ffa_check_unused_args_sbz(ctxt, idx_unused_args)) {
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
> > @@ -967,6 +987,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_PARTITION_INFO_GET:
> >  		do_ffa_part_get(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_NOTIFICATION_BITMAP_CREATE:
> > +	case FFA_NOTIFICATION_BITMAP_DESTROY:
> > +		do_ffa_notif_bitmap(&res, host_ctxt);
> > +		goto out_handled;
> >  	}
> >  
> >  	if (ffa_call_supported(func_id))
> > -- 
> > 2.54.0.1136.gdb2ca164c4-goog
> > 

Thanks,
Sebastian
