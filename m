Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F461F4E2B
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 13:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734440966; cv=none; b=kiFY6rdwCDdcXaxPkni4nGfpi6UzB7Vjtale+GDPzMsbdrCWC6V2ykrwMzdM9or4FSi9ACGeSdaCT/R5jooO8a9ePjTd6iHY7bWmuvRGU89E2blHcXj5mIpo+9maj0Xz1pdhWS1CmG4lq1pqby9tR3le86NWaVbsn7+Br90n/9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734440966; c=relaxed/simple;
	bh=8ri6RbzWNaTPDTw7kmq71IKYTlN2CuqaBg+QxuJxeOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IX8oHjigRW/D+nIViGhvCuwoDO620bAcc5RCStc5DWUZcmyiZNH59qoSDUXs8gmTLVkHd9klI2AKz6MZGY7maLXArXNoM9Y0SqJUpBElZ8lfdrW2bSkLc/HlNA4Bm4Gx9tqsYuTtIAN+1Izu6G4VrtspTSThl+CHQrKRORaJ5Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EVZE1Kr5; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EVZE1Kr5"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d27243ba8bso392036a12.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 05:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734440963; x=1735045763; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gTusGh58VW6+2NSFZii2lA8KCNl1o8/ZwWDL6LUst5g=;
        b=EVZE1Kr5aidNNGgs7s2ZKgtOOBrfjbk6oRETlR1OLeBNn4NOxem42AkMOX4qzuuf8T
         BUzPtrpAsx/f0vWgEcaY3m7u3tEKLopqpXgkQsVr5Jsf8nYFdNjcd0GB+ojXvmNbRvOn
         aUSzDm7kEPE3UbiImrh2QOOGVY+9lrYTL1eAK2kwUBzGCDvO8raZgh+Kpmsnm7s56eV1
         tKrl/EOogBxq9OkAiKSj9fpba7fxil72QCj9C0vLwo4gcT+P54vsfyD/H1NyvQKMaIdi
         9vtLM+c9zjXJtBh6lYe802M9zAiY4niYsaJ+NphV1BLSDDvTdRcGw2m3gaMqXc/pkDFS
         K/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734440963; x=1735045763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTusGh58VW6+2NSFZii2lA8KCNl1o8/ZwWDL6LUst5g=;
        b=sON/FPD5liBJw+xjdeexqTbE1iKjyvc/Ns9c4MnicRCOL1Zd0lsDwbQ4w6PKFz2+Qv
         e8evXWJASpG7Pv+JHgQs2m1ZT3Zi0s3aKX2/y3z7aE/TB2AaUx6sOcC9pnpdNVak9P5X
         ttrB9ESjlJ1YZoCvaHo0OeytyBF+lltelcWgwFmit5r3ZAIeIOqzITHmo8mU0GWp0bIO
         LhiM39jwTH/DnFsDJa72ce3nI/DoY8HKFZI2aqSkCPjB3PNqRwh3/b7l7OfTobajuwca
         uPdsmVJabCzxAnDYgcXoHIhLq1w+nm2cE8W0PWmBRytT/M5z7Iq5RPn40D2mr985Z4NC
         3x8g==
X-Forwarded-Encrypted: i=1; AJvYcCUck90lZJ/JcXX5/WI0+2Fh4K/+YK9w7mg9TikrY8/OWnZ1ZNouqFZvrpgz3ic72BQpN37aOJk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxo74cRBQ2q2gMvpqHlzOY1c4RL6iQSvKABF2GHR3UheCytTNkg
	Mq4VZjCu4+SNWAQtmsKycmJeGUtXFhOY7KzU8zflF0cBm08WO3RG2bUdXyjoYw==
X-Gm-Gg: ASbGncvwyUjlO2fMNlp4i/fIcC7YGJCtaFeA2lanG6TUDRxJ0SN0BfJk2WJVu8yu/DR
	dkKtyC30kTYuj+SIR6xTCiGHzAfJuhrGWTJ32BBQIPJZgLDfRK7pSAkY5kS3o/htz7NK+eMEZk0
	JwKmhmLIb0z5opFhKOpE22v7CuqyEfsAkaMF1P3QCQuPeaJrnbpoeMjSONaoCOPE+8+LBeBTA/R
	TSGZxCrTjU22cuiTdtxHe264eqkh5/0bREv149pNO+TZ0IineQ5gMHAUZa3bVs8SyJjFith8WB0
	fWGYmj033ETnvnk=
X-Google-Smtp-Source: AGHT+IEnhJMVLLV7Owj/1nOGB+GoFuLCOhRtzgitfH4oBA0YabMmvVMaad90R/9EuoBl8AAIk2rV7Q==
X-Received: by 2002:a05:6402:3890:b0:5d0:cfad:f6c with SMTP id 4fb4d7f45d1cf-5d63c3ad5c6mr13033930a12.21.1734440962482;
        Tue, 17 Dec 2024 05:09:22 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d652f271a6sm4443462a12.60.2024.12.17.05.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 05:09:22 -0800 (PST)
Date: Tue, 17 Dec 2024 13:09:19 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/18] KVM: arm64: Move host page ownership tracking
 to the hyp vmemmap
Message-ID: <Z2F3_8rN3NBFZXRX@google.com>
References: <20241216175803.2716565-1-qperret@google.com>
 <20241216175803.2716565-5-qperret@google.com>
 <86y10er2qb.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y10er2qb.wl-maz@kernel.org>

On Tuesday 17 Dec 2024 at 11:03:08 (+0000), Marc Zyngier wrote:
> On Mon, 16 Dec 2024 17:57:49 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > We currently store part of the page-tracking state in PTE software bits
> > for the host, guests and the hypervisor. This is sub-optimal when e.g.
> > sharing pages as this forces to break block mappings purely to support
> > this software tracking. This causes an unnecessarily fragmented stage-2
> > page-table for the host in particular when it shares pages with Secure,
> > which can lead to measurable regressions. Moreover, having this state
> > stored in the page-table forces us to do multiple costly walks on the
> > page transition path, hence causing overhead.
> > 
> > In order to work around these problems, move the host-side page-tracking
> > logic from SW bits in its stage-2 PTEs to the hypervisor's vmemmap.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h |   6 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 100 ++++++++++++++++-------
> >  arch/arm64/kvm/hyp/nvhe/setup.c          |   7 +-
> >  3 files changed, 77 insertions(+), 36 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > index 45b8d1840aa4..8bd9a539f260 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > @@ -8,7 +8,7 @@
> >  #include <linux/types.h>
> >  
> >  /*
> > - * SW bits 0-1 are reserved to track the memory ownership state of each page:
> > + * Bits 0-1 are reserved to track the memory ownership state of each page:
> >   *   00: The page is owned exclusively by the page-table owner.
> >   *   01: The page is owned by the page-table owner, but is shared
> >   *       with another entity.
> > @@ -43,7 +43,9 @@ static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
> >  struct hyp_page {
> >  	u16 refcount;
> >  	u8 order;
> > -	u8 reserved;
> > +
> > +	/* Host (non-meta) state. Guarded by the host stage-2 lock. */
> > +	enum pkvm_page_state host_state : 8;
> 
> An enum as a bitfield? Crazy! :)

Hehe, it works so why not :)

> You probably want an assert somewhere that ensures that hyp_page is a
> 32bit quantity, just to make sure (and avoid hard to track bugs).

Sounds like a good idea, I'll stick a BUILD_BUG_ON() somewhere.
