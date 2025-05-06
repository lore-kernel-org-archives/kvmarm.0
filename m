Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F389125D54E
	for <kvmarm@lists.linux.dev>; Tue,  6 May 2025 09:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746523786; cv=none; b=K6MEnoHpnjH47V0qOb4DvfkidiT51w/zxdAT5nztvA9hzwLUB8Y4J6PDBdULWp2uskj5+/UbIDoQgSFWVvjeX++AKLFcVUzWNML0iFGKblQZHe9VUuNhi6usOVTHdQcECn3BTeObpc5AML/YRwR1ZOhZd/HX6i+TDeCk4Xdr0X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746523786; c=relaxed/simple;
	bh=3lRSYAJoDIfqK+krqzkFLo5faoNN//lYCOs7kChMPf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=GJpRtRwwTQX1vEkbXCax4yVEXKC4/ZQs2KYTLB0kz/rS53W79zXOGvLBg/2urCVDMdfm11WICDGp6fce71PGdTY6KzPieswQDyBZUmfnNA2AyxG/+JUjOtRPuNM0YPRzdJ9EUMeaMvw99M4Ozxvcg6+4p0nbTwW+8FSezb7vbZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=3deaRbpl; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="3deaRbpl"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-70900a80907so17830577b3.0
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 02:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1746523784; x=1747128584; darn=lists.linux.dev;
        h=content-transfer-encoding:lines:status:content-disposition
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=bhNqSOC5wF7s/DqPJd5V4+i1iqYVvZl6mD6sr2HXhSY=;
        b=3deaRbplGdViJbCu04ia/sl9V8IRaOK+qIJLv99vYfF+av+aARofsemTl7v2rMF7u8
         Q3iu1NIGt2hOMJz/Pno2GR0Y6rCcFPdjj89seI4dXTVy7f7GCLEmdXUKckpbouRvVeOM
         pB/H8udQHH+snRcP4M2tcMe5kmnAEmA6qbW+V0AP7eDzH+S3JQUYy+OLEAh10C/BMoV8
         BrMkutPE5HF7z8kIwnOiYbji9yuUvyFKyiEtzlBJ+030If1hG4X9lVrRn2KuoYdf4eAz
         wNpWDdJbmsp7dOwMJLcpKe6aBTlyPNvceeRsDEmUSKz8KG2upE5FY8ZlU7Ktrc49sRLd
         HRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746523784; x=1747128584;
        h=content-transfer-encoding:lines:status:content-disposition
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bhNqSOC5wF7s/DqPJd5V4+i1iqYVvZl6mD6sr2HXhSY=;
        b=Jc0XuCpqPmEgH+kj7jbP0WoRNU8XLurNPPnALAQnr/d9w5mU3H+BhnFwH+W/taMb+Y
         wrQ+/Co1DPNzbS7mM8ryL6WF/a24BKtS2jHN1iI9r5mEWsgVEUlnC+zuEL9ubgviCYAC
         JZwJCD8FQudG4KuCfwRA1gs8TdJB2kLZyi1Ga1sD4Yc9sCUs+/l6MW19kID0+HYKj0RL
         CdOfCbioOpnkzYQvqQaUUDkIzh360cLiJVTMbIcE662f7APyMncOMwKloJWsyF5SQxq7
         B8MUF6mbOzw1neL3jMwsvfqJFfj28QKjS/EqJMqmWWBrs3S3ZlnsJgeWkk1kORsbkZ96
         PaBA==
X-Forwarded-Encrypted: i=1; AJvYcCXn9Jz3HfMXv9+wXdAe4uOcc6LNZA56V8+RzTjP4iMrsSvkvOPgn/ZxclPoJOwfvknfM9QWyLs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2erK7v7qPX0tYPKj0VUAcs48WoC3CuuOp07BnJ/82QVT7bJgm
	qGCQkizY8+dLjKT0F7VYjBE2xN6LfWSJExxmyp/p25upKnAA56muqzpnxTyjNiQ=
X-Gm-Gg: ASbGncv+yDQ3rtFfbPliXPh9WxN/GcN8Itwk69Afn2y4CwAiq0/qP4anUoQStYyH4h/
	NlHHQuDCjKMiexO974AAt1nUmcreMCHsx3WQFoEhSkEfnircH1JDwCmHnF9mEaPYfBVl4SbYP7O
	h+b2vr1WtJ7gGqdEBFRlYM3reuLwyotW0FhZHMfKPoR+V46n0BJoOnTz4t4fxZyVmeySNP/Ta5v
	25V1750q95/JFSKtMMUJRRxkAdh6w3DvFwtHqDzfPiEX0mwPdVK2InmuWywLBv7WzPK7rnlWO1A
	zkYdk/PFNEbeyYnEAUXge1/NW9pYQfe2s5/yOzmUWw==
X-Google-Smtp-Source: AGHT+IEiCZCpczG2uSgoLqesdF0FcNte2ltiX3d2EMvQ1sinI9JkU0e+3u0ocUrtlOW8Mx/0KHeawQ==
X-Received: by 2002:a05:690c:6407:b0:700:a93e:3302 with SMTP id 00721157ae682-70919d40189mr34612227b3.37.1746523783798;
        Tue, 06 May 2025 02:29:43 -0700 (PDT)
Received: from donna.immunant.com ([12.9.190.3])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-708c3f3d939sm26255167b3.45.2025.05.06.02.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 02:29:43 -0700 (PDT)
From: Per Larsen <perl@immunant.com>
To: maz@kernel.org
Cc: armellel@google.com,
	arve@android.com,
	catalin.marinas@arm.com,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	perl@immunant.com,
	qperret@google.com,
	sebastianene@google.com,
	sudeep.holla@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	Per Larsen <perlarsen@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Restrict FF-A host version renegotiation
Date: Tue,  6 May 2025 02:29:41 -0700
Message-ID: <aBnNXyJn818ZEKOS@google.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <86r017h00e.wl-maz@kernel.org>
References: <CA+AY4XcaJa1_U3qXQUBj4wZJYc9hKmRX8FTNeDvV2auEnC_WrA@mail.gmail.com> <86r017h00e.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-References: <86r017h00e.wl-maz@kernel.org>
X-Mutt-Fcc: ~/sent
Content-Transfer-Encoding: 8bit

From: Per Larsen <perlarsen@google.com>

On Fri, May 02, 2025 at 09:47:45AM +0100, Marc Zyngier wrote:
> On Fri, 02 May 2025 04:52:39 +0100,
> Per Larsen <perl@immunant.com> wrote:
> > 
> > FF-A implementations with the same major version must interoperate with
> > earlier minor versions per DEN0077A 1.2 REL0 13.2.1 but FF-A version 1.1
> > broke the ABI on several structures and 1.2 relies on SMCCC 1.2 is not
> > backwards compatible with SMCCC 1.2 (see DEN0028 1.6 G BET0 Appendix F).
> > 
> > If we return the negotiated hypervisor version when the host requests a
> > lesser minor version, the host will rely on the FF-A interoperability
> > rules. Since the hypervisor does not currently have the necessary
> > compatibility paths (e.g. to handle breaking changes to the SMC calling
> > convention), return NOT_SUPPORTED.
> > 
> > Signed-off-by: Per Larsen <perlarsen@google.com>
> > Signed-off-by: Per Larsen <perl@immunant.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 3369dd0c4009..10e88207b78e 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -712,7 +712,24 @@ static void do_ffa_version(struct arm_smccc_res *res,
> > 
> >   hyp_spin_lock(&version_lock);
> >   if (has_version_negotiated) {
> > - res->a0 = hyp_ffa_version;
> > + /*
> > + * FF-A implementations with the same major version must
> > + * interoperate with earlier minor versions per DEN0077A 1.2
> > + * REL0 13.2.1 but FF-A version 1.1 broke the ABI on several
> > + * structures and 1.2 relies on SMCCC 1.2 is not backwards
> > + * compatible with SMCCC 1.2 (see DEN0028 1.6 G BET0 Appendix F).
> 
> I can't parse this sentence. Missing words?
> 

Yes, I will fix this in v2.

> > + *
> > + * If we return the negotiated hypervisor version when the host
> > + * requests a lesser minor version, the host will rely on the
> > + * aforementioned FF-A interoperability rules. Since the
> > + * hypervisor does not currently have the necessary compatibility
> > + * paths (e.g. to paper over the above-mentioned calling
> > + * convention changes), return NOT_SUPPORTED.
> > + */
> > + if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version))
> > + res->a0 = FFA_RET_NOT_SUPPORTED;
> > + else
> > + res->a0 = hyp_ffa_version;
> >   goto unlock;
> >   }
> > 
> 
> Something has gone seriously wrong with your email, and the patches
> are badly mangled and unusable. They are also sent as individual
> patches and not as a thread, which is a sign that you didn't send them
> using git. Please fix this for your next posting.
> 

Yes, my apologies. I will use git send-email to post v2.

> More to the meat of the patches: why should the hypervisor paper over
> anything if the spec is broken? Why can't the host just as well decide
> for itself what to do?
> 

Asssuming we drop this patch from the series and apply the rest, the
hypervisor and host can negotiate FF-A 1.2. If the host then calls
FFA_VERSION a second time to request FF-A 1.1, the hypervisor would
return version 1.2 (without this patch). Per the spec, that means the
host is can use the compatibility rules (DEN0077A Sec 13.2.1) to go
ahead and use FF-A 1.1 (every function in 1.A must work in a compatible
way in 1.B if B>A). 

However, the hypervisor negotiated version stays at 1.2 so it will use
SMCCC 1.2 for 64-bit interfaces. The host has no way of knowing this and
might as well assume that the hypervisor was implemented to fall back to
SMCCC 1.1 in this particular case. 

I don't even know that the host will ever try to renegotiate as it is
explicitly not allowed by the FF-A spec. There is no way for the
hypervisor to say, "stay at the negotiated version" so we must return
NOT_SUPPORTED. 

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
Thanks,
Per

