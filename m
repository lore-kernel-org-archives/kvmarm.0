Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794842844;
	b=vLONh/qEU4skrBHpN1vZk0IORQxi0lD3if9BAx+Egel7BGWKPUlZsRKeqeNsmwwVHopV
	 IGSyUW/2XhjTgiAGf17wWD7AzKzkFI0VWjUXm7edYkLg4lyMj19jP9IBEPN0s3ooJQGWB
	 UHdIZUL7oo1q2RBPaCRnVm9icq0H7t6MDsNwmZLK6Nfuaytl82Z61Z8+fRzevysJk/rRv
	 yd17anyKedyCodL54MPjFXDitikAdAQaRRPEXrsrPgolIgThvm7sBwWD2FcUkqIDneq0w
	 oW3CZbZtkZgHjiREJsiIJcemgTBqXhATUBwXSsrnUAmjtDO0Hohn4kZ3gAmkQMSvqzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794842844;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=eoxTx1ruNCZnKQ2C0kl5zbniFIBX2aek5amYXBxk6HE=;
	b=4USozHLiYEz18QX/6G9yeCBIAqj7iT9fjnDOkyObIBLrQR0eQ6ML9nRlxddtoudUWEoH
	 h52pZMxv1RVLi8riyep1hi6XEm12m1R5UnzCn0z9dIzL6hSjrqROsV/XMOg9EWvPGt6fD
	 7qZEKjT4li+wSQzhb112V4zIyg5p0A4YO712Y5BYXhTKSmQBOBiL+KDgMs5KazJYD0Vj8
	 p2fLQON0ELnogMY5/oRXT4hRpTzKp9tC4xx95fud3dVdAUdp7+Dm3/+BlKGRmUr97QGQo
	 UsLTub/alsIDDy+IxpzaMnjIeIexE6g8/d2XFc18jIg3s+i5IdN190gVK/cUzXnSgPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=JJdSwTe2;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E4C606A329
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 15:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81E4C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=JJdSwTe2
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so10946935e9.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 07:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1794842842; x=1795447642; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eoxTx1ruNCZnKQ2C0kl5zbniFIBX2aek5amYXBxk6HE=;
        b=JJdSwTe25SarMh4GmxwbuVtkkcwIktk+vsnUxcjWlR4X0VAJEGjPhdU/rciwY8rMJk
         zMJnf8lLXj6/xGNmbST5shOzGW4e8lgCcZ3ZQUeBW1mLIGZ5Em/12nI6T7qovEAyxUym
         wh+1XX7dQujx0eTWUJf8Z7od7GC5PmtybFLOVstf8FirOgR15G5/kS6fUh56ZG4zROP6
         +oDCyyxEpDLyqTAmeVXUWjA/b0S+tdCEU78jZj1ktQoHMJYf4O7Bb9dj00+H7lEMBBEU
         KkWJeRRKnW2Cdl9KL3PDH3W0pQeEJ00LjKYSh9eRIB6WRKuHhnRVQ9VHYBDzsXI4Jf4A
         UGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794842842; x=1795447642;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eoxTx1ruNCZnKQ2C0kl5zbniFIBX2aek5amYXBxk6HE=;
        b=b2uWvvX+rOFEu2vUBW3ycp03CvKeIhLIj+uaXv85dmSYO9Tng4p/ZkfLCtIV+mPalM
         090RxNJVKH3oXu44miVeAXeKfZtSFpgeTCVlV1x4BpkXVmmPqbZT5vIeM05V8oObhYFJ
         zeGhZtGY9V2ow3/tEg9gVgPH2pA0/GZigFSknNg0vCFA49kvu6zVToaQhYHv3U3ImvoC
         cbZ23OoHEzHOyf6N/1b0hp4prs7rkGFmuYUPjNyvSjQpBdRu0DdMwEz9Ai5SzEQbDCJ2
         sTQOi5KJd2QcnGG56636o1aLdegRYRoa/3zC32nzuWZGGT/JPMt+d3a1GE2HaweeobHo
         0kVg==
X-Gm-Message-State: APuU4Z96dohR+e5xSNKLSAdQcraXnFUuwRzzODLeioRJmd+FZ/nNYvDE
	i8v3np/ao4tzNpNh2Xl3BdjXK9u055FzqWYkdIg04aDug/PKSRxQ1bNImrChyAjQshaDTAI/CSi
	HcUp4+YzAfg==
X-Gm-Gg: AYBFou0ktW5e5QIo/Vr8VrlAb8/Ede6WVVc5dqcOW6/nbHz08BjNhKP6v0jpOWXtp94
	pfp6IQqgp8X15tAhJd/9f6QrARoelMvIxi6EqJiZJrELEyrtprfqMmUAI3PYanKy6oF7J7Aqmyr
	iRZWR3jt8WfSg7z/GHqDE3lhV7MSRYuIrOiDFlpRQ13Zubi5PP8tufb6ZXFRvxEVAOlKU/+Icgw
	tYSq6QnQvJBs77cO4ago8m4pWE1jA3MDjQQ8crlg1YZcHVzcRRzWKDqiSSJnSmldRbArKFV/pb5
	MUhDVm+GEQOVTfmcipNfK0GPmMxFBSXpJldMnmr3PqsaHOkJTEUlikDEkfjzyz5/kkOGffgr4Xs
	4mvXtAvFd+j0LSFyNy9xqu6SJvR8NC3nIS3qBkq9GUFRPGBUeAuDyS8RJr7IcPN2XJRPW9RbIBi
	gO91w8Tc6mG8e9Y/9fO/HcVnk1CtbwYieNvvlmLSubC4G0T4Nl3YDnNCdCVux2JdYfE0N1xYNyl
	FZv4YNAZuDz+Ka1YFoXIHPlFgC0y+z7djNzxdHwnF5gd8OZgxO4Wisis2QY4AlJnB7Ob/gZItLp
	ifGOwJOHTTey+NUkTYsEJKv0Hj/8NJrCz9qni2Tf
X-Received: by 2002:a05:600c:3152:b0:4a2:677:ad8e with SMTP id 5b1f17b1804b1-4bb55aac0bfmr242496785e9.34.1794842841763;
        Mon, 16 Nov 2026 07:27:21 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm600185375e9.1.2026.11.16.07.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 07:27:21 -0800 (PST)
Date: Mon, 16 Nov 2026 18:27:17 +0300
From: Dan Carpenter <dan@pereq.eu>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: nv: Fix NULL dereference in
 kvm_inject_nested()
Message-ID: <avsg1V-mvqL3sFkP@stanley.mountain>
References: <avsH0lxpLIF2Ug64@stanley.mountain>
 <sashiko-outbox-217134@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-217134@kernel.org>

On Mon, Nov 16, 2026 at 02:06:38PM +0000, sashiko-bot@kernel.org wrote:
> > @@ -2915,7 +2917,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
> >  	 */
> >  	__kvm_adjust_pc(vcpu);
> >  
> > -	kvm_arch_vcpu_load(vcpu, smp_processor_id());
> > +	if (loaded)
> > +		kvm_arch_vcpu_load(vcpu, smp_processor_id());
> >  	vcpu_clear_flag(vcpu, IN_NESTED_EXCEPTION);
> >  
> >  	preempt_enable();
> 
> [Severity: High]
> Can kvm_pmu_nested_transition() at the end of kvm_inject_nested() still
> run when the vCPU is not loaded?
> 
> Right below preempt_enable(), kvm_inject_nested() unconditionally calls
> kvm_pmu_nested_transition():
> 
> arch/arm64/kvm/emulate-nested.c:kvm_inject_nested() {
>     ...
> 	preempt_enable();
> 
> 	if (kvm_vcpu_has_pmu(vcpu))
> 		kvm_pmu_nested_transition(vcpu);
> }

Sigh...  Sashiko is right again.  I will resend.

I need to figure out a better way to test patches so this doesn't
happen again...

regards,
dan carpenter

