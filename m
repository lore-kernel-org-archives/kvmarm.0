Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD70350848
	for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216014; cv=none; b=sGzqb9s8T1664MF36Ugf91ZaNYuQ+oc3TfvFhaKLbngAR19mWRwPw3Sov7ch4Fs6iHUGCm3lH0zeLvFHS8MkdfXxgRLaUHdM68HDZuqKspco6POvCtvajCP1+cARjbaeMy2jpq1r8grqJBq/U64BlvwFKXZfZ9LThPpX9v1snbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216014; c=relaxed/simple;
	bh=D2WCPWAROvWpGOBAO/irESE4qw7Dj1nlyMvIle7uz6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eL1e3CQkm18WCegu8lTNCnZbq+efhRHd2RetcVBGcSpr7pyjnXl913ngdVqNq7i/Y9td7bid0/Jkq97SkhgU51mPGTzqr7T+DFKRa8EKgEXhcFtZOR5KJSYOR9+aFz8+O3A4MO6Wrlm+Qtdv8L8MJM1Wl0Tbt+xtjPkcr2VtrC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=iagiYMJq; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="iagiYMJq"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4c1ed55930so2051921a12.1
        for <kvmarm@lists.linux.dev>; Tue, 26 Aug 2025 06:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1756216010; x=1756820810; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=osdPfu3X+WvVcN3qUZlA7PO/Is6NQe7OboBpnwUj8qo=;
        b=iagiYMJqydl8ASxzusdzDkxbAJgf6D27ard0wjxfm2CCiwRgNkdMrLCSPVzS3Kp09z
         SluFpT4oXq4zDIlWPH3bM6NMkw5clK/zQcfgnFUCRljK+BiF70wX8MzIgCWQQMe3mvR2
         F4Q3eGYfYTeqLI/mIMh8oqIQzx/HgXBVCFWx289qxseIEKp93gsuHOPjAOCW7VDDwMvO
         /Sc/RiHRtBbLYxx/kIZuAlsAVPjGLGYwvT1d0+tiKF3CrfwiA9C0owddF9P8sSMpHYr3
         JDxfi8Nvkwelbjo053HBpEazYwZiOsGzIViDI+FWdqY7QhP/EiZzilsUKff/XbO6XRD9
         jAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756216010; x=1756820810;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osdPfu3X+WvVcN3qUZlA7PO/Is6NQe7OboBpnwUj8qo=;
        b=ulBacqekqCgww3JWdkrfvaESmBpA+IspzbDgk5b3WwQUbBiBc50n2ZhINWZc1Z5JUI
         aRUi/ITn6oUjEMAhz5o0GAqdh176gGnrNkzSC66WdHmuMq8E01hJkc+m8JWvscHXyymx
         kHqDftkoLDEotUupQsBlwkzOdWdfWrYfET2yD3HwKXUAz1N4lm7zN9jp0sYjMzmKmB3T
         bqFgnOHNtjCZqwbWKyZ7Nw6exaJupddjQsCtlpDDiORnMzFMJcQCXSHyo7fCFELHz4vx
         3vww+p+39hQEZ/iRIwIkesKg/xoTWPAmtzHWHeFusZjYtkf8X/q8KCsCfjPjqsfMqSzK
         lwcA==
X-Forwarded-Encrypted: i=1; AJvYcCXMBbETmP/SFxRf9fak434IKm1Ol282Sq8imUC7I7sCIMp6Dm3AKoVGBLEPHRax8Q/oS04jsnI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzqrMQUqj/6TV2D3VywLwkuWYUTtZubpGYOSjcKN1oAO7717B6
	nvBfgMAtVFIukrkVBR2VrZMZB/C0i1Mc6aV2+5cKqifWOyPZTDdLvWPS94HuzKlIYrzg50EwyGR
	s/TpfS/erikIwrsUbsjIwYK9BzKH263EMo6FXeCVlLmJYVLcqS00=
X-Gm-Gg: ASbGncsmCAggZmG03KAnm/rmlrvAf0NAJfKayBZOyWoXL00K6ndbkHsmJAUQBcdFgSx
	aXQ1xTgBEE6rVST/zUyQfb92stO9AomK6B3+FgAySDjXmHAw/7YzEy5ua4p4ujF07OmmBgtj4hk
	SMf2BuHHORaB/YnjGzqcR0uAMon9HZssBmk78XKcjx9EMGnsFfTX6RKzQlb19SFJ603AcMEdkn/
	MLLgxMcgAgRGiQ/oGEoU7tKVgkHK1ax0+U3uAgCjK/ay1MMEVMWiRhxMoa61EIPBDUZoIegyZ6S
	fuAVRadzjfyU58WiDYuUjTgyBTEczGt6RHliOXSqOqjceGufYsT25QPqml8Uc7BEX+WB5bNOvfH
	JZEMXa9kAvoV/1R3y5jk68U0v/63sZS2PfY+OtaKxCe0sM+c2IX6A49OR8A==
X-Google-Smtp-Source: AGHT+IEapx+qUYn+gnSfpFGolofqtYLrq6ffT2yt159qZt5g4CsSb6AqyhXzJhjpuNXlfxvFnyc/wA==
X-Received: by 2002:a17:902:c94d:b0:245:f002:d67c with SMTP id d9443c01a7336-2462eeb6325mr197352005ad.30.1756216009581;
        Tue, 26 Aug 2025 06:46:49 -0700 (PDT)
Received: from zenbook (1-162-83-231.dynamic-ip.hinet.net. [1.162.83.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466887198dsm96470935ad.110.2025.08.26.06.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 06:46:49 -0700 (PDT)
Date: Tue, 26 Aug 2025 21:49:27 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: nv: Allow shadow stage 2 read fault
Message-ID: <djypsyratk63ovzv3flzb2tmunqtcoryzserwhsaaq5nuogsrx@u3uuwynnafbj>
References: <20250822031853.2007437-1-r09922117@csie.ntu.edu.tw>
 <87a53rk83s.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a53rk83s.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi Marc,

On Fri, Aug 22, 2025 at 10:40:07AM +0100, Marc Zyngier wrote:
> Hey Wei-Lin,
> 
> On Fri, 22 Aug 2025 04:18:53 +0100,
> Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> > 
> > We don't expect to ever encounter a stage-2 read permission fault,
> > because read permission is always granted when mapping stage-2. However,
> > this isn't certainly the case when NV is involved. The key is the shadow
> > mapping built for L2 must have the same or stricter permissions than
> > those that L1 built for L2, hence opening the possibility of mappings
> > without read permission.
> > 
> > Let's continue handling the read fault if we're handling a shadow
> > stage-2 fault, instead of erroring out.
> > 
> > The following illustrates an example, vertical lines stand for either
> > L0, L1, or L2 running, with left: L0, middle: L1, and right: L2.
> > Horizontal arrows stand for traps and erets between them.
> > 
> > '''
> > L0                               L1                               L2
> >                                                L2                 |
> >                                                writes to an L2 PA |
> > |<----------------------------------------------------------------|
> > |
> > | L0
> > | finds no mapping in
> > | L1's s2pt for L2
> > |
> > | L0
> > | injects data abort
> > |------------------------------->|
> >                                  | L1
> >                                  | for whatever reason
> >                                  | treats this abort specially,
> >                                  | only gives it W permission
> >                                  |
> >        eret traps to L0          |
> > |<-------------------------------|
> > |
> > |      eret back to L2
> > |---------------------------------------------------------------->|
> >                                                                   |
> >                                                    L2             |
> >                                                    writes to same |
> >                                                    L2 PA (replay) |
> > |<----------------------------------------------------------------|
> > |
> > | L0
> > | finds mapping in s2pt that
> > | L1 built for L2, create
> > | shadow mapping for L2,
> > | but only gives it W to match
> > | what L1 had given
> > |
> > |
> > |      eret back to L2
> > |---------------------------------------------------------------->|
> >                                                                   |
> >                                                    L2             |
> >                                                    writes to same |
> >                                                    L2 PA (replay) |
> >                                                    success        |
> > |<----------------------------------------------------------------|
> > |
> > |
> > |------------------------------->| L1
> >                                  | for some reason, relaxes
> >                                  | L2's permission from W
> >                                  | to RW, AND, doesn't flush
> >                                  | TLB
> >                                  |
> >        eret traps to L0          |
> > |<-------------------------------|
> > |
> > |      eret back to L2
> > |---------------------------------------------------------------->|
> >                                                                   |
> >                                                     L2            |
> >                                                     read to L2 PA |
> > |<----------------------------------------------------------------|
> > | stage-2 read fault
> > |
> > '''
> > 
> > Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> 
> Excellent detective work! Bonus points for the ASCII art -- I'm not
> sure how practical it will be to keep it in the final commit, but this
> definitely helps understanding the issue.

Thanks, I tried to make it clear for those that aren't familiar with NV,
including myself :P

> 
> > ---
> > 
> > I am able to trigger this error with a modified L1 KVM, but I do realize
> > this requires L1 to be very strange (or even just wrong) so I understand
> > if we don't want to handle this kind of edge case. On the other hand,
> > could there also be other ways to trigger this that I have not thought
> > of?
> > 
> > Another thing is that this change lets L1 get away with not flushing the
> > TLB, but TLBs are ephemeral so it's fine in this aspect, however I'm not
> > sure if there are other considerations.
> 
> Well, it depends whose TLBs we're talking about. The CPU TLBs are
> definitely ephemeral. But the KVM-managed TLBs (aka the shadow S2) is
> pretty static, and I am a bit worried to relax this.
> 
> What would happen on actual HW? L1 would take a S2 fault, because the
> TLBs are out of sync with the S2 PTs. And yes, maybe the TLB pressure
> woulds make it so that it works *sometimes*, but there wouldn't be any
> guarantee of forward progress as long as EL2 doesn't issue a TLBI.
> 
> I reckon we should implement that particular behaviour whenever
> possible, and handle permission faults early, possibly ahead of the
> guest S2 walk (the way we handle VNCR_EL2 faults is IMO a good model).

The parts above make complete sense.

> 
> This would imply taking the guest's S2 permission at face value, and
> only drop W permission when the memslot is RO -- you'd then need to
> keep track of the original W bit somewhere. And that's where things
> become much harder, because KVM can decide to remap arbitrary ranges
> of IPA space as RO, which implies we should track the W bit at all
> times, most likely as one of the SW bits in the PTE.

But sorry, I struggle to understand this paragraph after reading it many
times, probably my experience with the code isn't enough for me to make
the connection. Why are we talking about the W bit suddenly?
If you don't mind, can you reword what's discussed here?
I only very vaguely get that there will be 2 W bits, one from what L1 set,
and one from the L0 memslot, if I didn't completely miss the point..

> 
> We'll need exactly that if we ever want to implement the
> Hardware-managed Dirty Bit, but I have the feeling we need an actual
> design for this, and not a quick hack. Your approach is therefore the
> correct one for the time being.
> 
> > 
> > ---
> >  arch/arm64/kvm/mmu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 1c78864767c5c..41017ca579b19 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1508,8 +1508,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> >  	VM_BUG_ON(write_fault && exec_fault);
> >  
> > -	if (fault_is_perm && !write_fault && !exec_fault) {
> > -		kvm_err("Unexpected L2 read permission error\n");
> > +	if (fault_is_perm && !write_fault && !exec_fault && !nested) {
> > +		kvm_err("Unexpected S2 read permission error\n");
> >  		return -EFAULT;
> >  	}
> >  
> 
> Honestly, I'd rather kill this check altogether rather than adding
> another condition to it -- I suggested it to Fuad a while ago. This is
> the first time we ever see it firing, and I don't think it is bringing
> much.

No problem and agreed. Let me prepare another version.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
