Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5998F231C8D
	for <kvmarm@lists.linux.dev>; Sat, 26 Jul 2025 10:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753524554; cv=none; b=rjcEL4ajxRuTRajJ0+6G7Pcn6Ru0dez/L0ubcsHQ6wLLAXBum3NGMm0rQDLYRLEbjG9IsZB8/3NzhNLTTodqBCrLhU2Qdg29G5Ozb0Dcs+Ezt0LV5mSTjBnqvj3qZUi9IlVf1+54owxwWKzYlGe1o9jRnLjSBfje5/lNG3PX1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753524554; c=relaxed/simple;
	bh=DyCbdcECU2WAKLBi58ndrvS3xi7zOjpla3Uq997d50I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pihu7dSCH2NnFAseB4XO30Nje37BuUju3c8slOqOWBJD4U3/LPRZ+54H7AF8CCIaufnJpayShG00QL25FBvxVHBbWUja3ZxN+2CdgGlKoV6ydZdUZ5QTnCihbLBRG5tkxQz9UywSsXZaE1ejyISKY0N1awQfhWdZ+l9ztoKzQbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=NItZubdQ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="NItZubdQ"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-236470b2dceso25353675ad.0
        for <kvmarm@lists.linux.dev>; Sat, 26 Jul 2025 03:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1753524550; x=1754129350; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uI61kTu3Z9HBCe9N6Mig2mBJLeRxGnBOwpeOs/JzM68=;
        b=NItZubdQvcvCLt8PRjiVMyDHOPzE6prqkDzwedajuAd6LqSm5qNfwCdb+wkHc/oA2K
         QYVgN0swgRUb67ibq4c6Y5JZrIIc+sZZ1yiASa4mJWVKT4BNf7Pi27M6NpSkXg6LQig4
         OuAB759HceifQTqtPCdBOUSV/9XW36N4C1tq8Q6vq3j37eT7LqCrpefT9L1sE822K2Y9
         dx/krAAQbMF9ZBvR6WUmG9A/xyc5NJbq3yfmmmRPgrhF31Vfx/hxumKrcZeq9PVD9gtw
         Q0CqGqlLP2KL4+vRj9zU/+iNZraueSIydtOOv3bI+qWa88XqmqXq0LXozY1GqpfuoaJI
         9YUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753524550; x=1754129350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uI61kTu3Z9HBCe9N6Mig2mBJLeRxGnBOwpeOs/JzM68=;
        b=FnleiAxWd4ECHGIdPlT8ok5V/cF4Y19osEIWR0ilu/JNGX9oXn9k4puYlxy1a6Eu4h
         hPsiw0//NHN4qQFuoerUwlpVlbwLNU7z6AejUzDH72Gbnp9KcQHsmiALnTt8nbqkWt07
         oUUwr3raEBONpxR229WfZZQ4r7sqUNQAOs2Gn1cUZg0HUDCnQ2FplfQJ3aUHpFw5BSa6
         R+hJnERLuLN8o2dpyyBgsc1xFHCapEKzZFlY1ZbI5aHpYxJCF3LaM1zdFfzjfKWa77aC
         JBQsQkwoi5amSzR5IXG87HP/3gbgwYgOoOtZZZq2T+a0TEsZkcxfxBV2XrbTPdFbcsqn
         ZrKA==
X-Forwarded-Encrypted: i=1; AJvYcCV3P+yWPPofkk1cb6uJawEosd9LDerDxEE0lf4J2wOobjF0lSE5c/lwcUE+c6MNYXroyROAx7E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx16CliDiPPRC/qxq/w1u6zlonh+CBWJw58FJ8Oc2ObZDg869xq
	zf5j9PgmK16NrUIdEmQXyx1NwY/RmQMh0PorBTVPwahpHHrJJsCGNUyJhAbyvq97qIeqDR5GVXC
	5tlVwjCMvKGT2O+NTGfcncmQFrvrdfO3Kb8+EnFDAuBmVSierw66qRDB049FFPduM+nY=
X-Gm-Gg: ASbGncsGXmTQUQsCJoC2ak4w+3V0cWF2aHxB82rvFUY3KMZkcetNKmd45kAuj1q6gqV
	OYu/kZOZcYH9TAu8LAsNOXEK9pa2Y4+SixN1/phM/zw/D8XU73ELXvDKUi2wqETxXYLFuUcJxzG
	wNMt69y0sGr6hAKymcDioM+9HIzyg+hKvP9C+eDCKStETHZHNl8THL2Wg37FUKO+F0XypWWKjC+
	8MPMseanGtcqtxHfgBDYJOsijRiullzT0X/uo+3CPiyBO2NPPJdswPrOPrsxR9M3ax7iTjW+nEP
	NXxh/Pt+5fkCG4+6Juko6z2NEP06x1OiqAVIiOpmFQEl7F11ZFJb0qphZ0CBkBhbrxr7MvzQoFS
	InczdZDp+7IzUOaHfQgmACig1ZF/dzL36llbSPORM6wbOZBoFdxMx6iJXVLWi
X-Google-Smtp-Source: AGHT+IH3pK9wFHIfPY4w94CT1QeavRR9MgGPuexzcHYcWfICRIAfzdUgzIf/r47ot+BKH0XypAs2XQ==
X-Received: by 2002:a17:902:e887:b0:22e:4d50:4f58 with SMTP id d9443c01a7336-23fb315a903mr72899485ad.31.1753524550460;
        Sat, 26 Jul 2025 03:09:10 -0700 (PDT)
Received: from zenbook (1-162-100-110.dynamic-ip.hinet.net. [1.162.100.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe4fd06csm14156495ad.85.2025.07.26.03.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jul 2025 03:09:10 -0700 (PDT)
Date: Sat, 26 Jul 2025 18:11:43 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v2 5/6] arm64: add FEAT_E2H0 support (TBC)
Message-ID: <qm2d74s7sqxgzupnc73uuwgginuzjoqlrfzycripfpzgpvu4p7@nth2cmrodr53>
References: <20250725144100.2944226-1-andre.przywara@arm.com>
 <20250725144100.2944226-6-andre.przywara@arm.com>
 <86cy9o8bwn.wl-maz@kernel.org>
 <zbgu6irpeytcpymaxpg55tvijeppfpdpwcju275g3h6bx4u5qn@35vb5ymt55hx>
 <87jz3vtils.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz3vtils.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Sat, Jul 26, 2025 at 10:19:11AM +0100, Marc Zyngier wrote:
> On Sat, 26 Jul 2025 10:01:25 +0100,
> Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> > 
> > Hi all,
> > 
> > On Fri, Jul 25, 2025 at 05:37:12PM +0100, Marc Zyngier wrote:
> > > Hi Andre,
> > > 
> > > Thanks for picking this. A few nits below.
> > > 
> > > On Fri, 25 Jul 2025 15:40:59 +0100,
> > > Andre Przywara <andre.przywara@arm.com> wrote:
> > > > 
> > > > From: Marc Zyngier <maz@kernel.org>
> > > > 
> > > > To reduce code complexity, KVM only supports nested virtualisation in
> > > > VHE mode. So to allow recursive nested virtualisation, and be able to
> > > > expose FEAT_NV2 to a guest, we must prevent a guest from turning off
> > > > HCR_EL2.E2H, which is covered by not advertising the FEAT_E2H0 architecture
> > > > feature.
> > > > 
> > > > To allow people to run a guest in non-VHE mode, KVM introduced the
> > > > KVM_ARM_VCPU_HAS_EL2_E2H0 feature flag, which will allow control over
> > > > HCR_EL2.E2H, but at the cost of turning off FEAT_NV2.
> > > 
> > > All of that has been captured at length in the kernel code, and I
> > > think this is "too much information" for userspace. I'd rather we
> > > stick to a pure description of what the various options mean to the
> > > user.
> > > 
> > > > Add a kvmtool command line option "--e2h0" to set that feature bit when
> > > > creating a guest, to gain non-VHE, but lose recursive nested virt.
> > > 
> > > How about:
> > > 
> > > "The --nested option allows a guest to boot at EL2 without FEAT_E2H0
> > >  (i.e. mandating VHE support). While this is great for "modern"
> > >  operating systems and hypervisors, a few legacy guests are stuck in a
> > >  distant past.
> > > 
> > >  To support those, the --e2h0 option exposes FEAT_E2H0 to the guest,
> > >  at the expense of a number of other features, such as FEAT_NV2. This
> > 
> > Just a very small thing:
> > 
> > Will only mentioning FEAT_NV2 here lead people to think that FEAT_NV is
> > still available with --e2h0?
> > Maybe s/FEAT_NV2/FEAT_NV/ makes it clearer?
> 
> Maybe. On the other hand, we never advertise the old FEAT_NV as such,
> irrespective of the state of E2H. This is indicated by
> ID_AA64MMFR4_EL1.NV_frac==0b0001 when NV is advertised. So I'm not
> sure this changes anything, really.

Right, thanks for the input. Even if the user doesn't know what's up the L1
hypervisor will when it checks ID_AA64MMFR4_EL1 :)

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> 
> -- 
> Jazz isn't dead. It just smells funny.
