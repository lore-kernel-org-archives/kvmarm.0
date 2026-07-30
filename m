Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A66367292
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 09:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403814; cv=none; b=pV7E8bte2TWFRbq5Vk/qMgLTjCdVfsn2cn1BXFuPDlfqG1lzmg9r+c++AOCSFv1RPEA9cKegQclmC5Se/ZXkpX99a4URk4TGSQj277CaKFxXPwyxfJqRKNeAeNodbKUjWx1SWCaYF1ccur8QXj93aqFUdXYNjtp2kmZRQNDMpe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403814; c=relaxed/simple;
	bh=mcAzGTUg9o29/9QVW7bSlpv2QdSdbvGGWa3JMTgBxIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0tDahxzoEwkGkKfKqaZYQgZqoUrjLovE/JSuahRSCXK/ADU9USDE+4mjYl+oSXeFBXf6apsvknscE+y6UVz0EJ374+g4BMWqnAevLGnILhEyT7BV1L3W1I2XACLGB7cdw9Z8zmwo7gkQFQvl9WrVtYvSOjBUxS6BSEnA7ZATv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uZstx5SF; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uZstx5SF"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69fec8b4638so10298a12.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 02:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785403811; x=1786008611; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h8Ig4gIXtYgwzGQ5I1LRNr2VPU7co1Asg23QpE3nNo4=;
        b=uZstx5SFCRLLgmzLWsSYTkNsTKeEPMbYXZpASzKPuiSlyW34f5wwar48n1hSy2g/FM
         YfWACFt79XWAbIlO5ey6OS7yfg/c8Ts36gdZhY24hr0aTSQvXemdfzQYNNfyYtY9gdwF
         33xm2T0+5XY3n33zxmFnuJgtL6BZCAfL9PJ2UGuPzRKv0O2djvbJqBjY6nM/Erw4/141
         Ai1CzarC6myGJVbnuKSnsGJfMo6//PjI1fMJdP/4W6XQeedfdFn1pVv2HJPoXWEw1dal
         Ux14yREgcynaWJ8E/7Fz5dUE03ihEYM+j14/d7bP5C/fLKfVeylzMxtNb83k4FsbeW7y
         7Fjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785403811; x=1786008611;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h8Ig4gIXtYgwzGQ5I1LRNr2VPU7co1Asg23QpE3nNo4=;
        b=DvXF0X7/JCiH8S11ux3/Hz5Ux7+O3g2PloE6R/qCOofKQpBi5upKeZyrjKXGjFt6ak
         rE/P73LdjY6l7Q2O+oQkt1ppRd0XaD8tKRl2txArz9j3ldJS9CEz5pJMhZmKYgQRJNCN
         DCDAYsjV6gdFVPMAmO9SUTI4ga0e55xOp6cg1DnX+IME6pw0LjizSGEwfPVVBVmvyQg0
         VQ7uclruJQvx5ePNY1hDzIDq58W+495dnZCAnw+xxyv4vNRpiQ7aGqAiqUvw3v+lA1C2
         0xAsIRYnqRaMWP9/wumhyDSwJhJlbIhxlf6xjAJR3WDC0WQxf9lnuuoPQZlBkqxX0i9W
         +9xA==
X-Forwarded-Encrypted: i=1; AHgh+Rrc92BgcFkLz+/2CkQAXifI6oBaZbObpeSKp+9pCEuUAa9Crdidy9Fmu7O69PVZs7U6ASjo6aQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3987LolUmyAPBjFNMUGlenT7zygNmi0PNtKnqOug+yJMlvlJE
	q6Nrzqf32qZt+QMHH50JTcDnR8w2VGpYRylbglJDRfPhLHf29GdlXmOucwAmkKUcjw==
X-Gm-Gg: AR+sD104eSnskJ7ERw2uoFzX1YBk+t/dlaDSL9fNhjFpk1eyqt47xZX3x4/G/kQRhRz
	Svf8cz74d6JBUVX21ClnaFWidP833gopkPWaylFrLYHuGLmGifpdR6AS2heRGbh1idDZ4Am+mQk
	j6biP5sGrVRxc6sac0Jol5jPxPmULDC7RXZLvwtftX6jpoEfGApGdgZuc6/e/8/vtYUULfcM+3Z
	JZQXaz77lJlYoXI8rCvBzmAFGpJvrpAhAtrYII7MQ0ZfhxOni5bw6kpeJXaiVG/8+qqZrurrrYT
	zai2HkJoGWHD+LwrH5DdgVseWL2I3x2h3viumQPrECq255RoGBIdHePldwEO8os6qTDkgQxlu1m
	SymITllF8rpHSiAQt6aceA9PVWThjVWMBSeX0y8tbGtNy46KJ+PDQ6CJJ4IgAJ33pdPImj7QtMj
	4EDe5woY83KM5CmnRO6K1eyPS5i9VFIXEsF1UIofftiOy1VmnlT6HaifnlwPIRq7bRN/eTEgely
	NFy/4wB9WFgphCXaTKBmEUzOcoymQ==
X-Received: by 2002:a05:6402:1c06:b0:6a0:6677:37f9 with SMTP id 4fb4d7f45d1cf-6a07bcc1ec8mr29106a12.1.1785403809991;
        Thu, 30 Jul 2026 02:30:09 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a07d38318esm414754a12.19.2026.07.30.02.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:30:09 -0700 (PDT)
Date: Thu, 30 Jul 2026 09:30:05 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Linu Cherian <linu.cherian@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [RFC PATCH v2 0/2] KVM: arm64: Add support for BBM level 3
Message-ID: <amsZnfDSfWYpM9C0@google.com>
References: <20260723182140.4025575-1-smostafa@google.com>
 <amrDfR-6q3xAAkTq@a079125.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amrDfR-6q3xAAkTq@a079125.arm.com>

Hi Linu,

On Thu, Jul 30, 2026 at 08:52:37AM +0530, Linu Cherian wrote:
> Hi,
> 
> On Thu, Jul 23, 2026 at 06:21:38PM +0000, Mostafa Saleh wrote:
> > This patch series adds support for BBM level 3 to KVM pgtable, it
> > depends on [1]
> > 
> > Changes from v1:
> > https://lore.kernel.org/all/20260717130901.2239134-1-smostafa@google.com/
> > - Limit BBML3 to systems with FWB and DIC and remove race check.
> > 
> > Motivation
> > ==========
> > I have been looking into this for the context of:
> > - Page table sharing between the host CPU stage-2 and the SMMUv3 for
> >   protected KVM.
> > - Use the pagtable code to populate SMMUv3 stage-2 shadowed
> >   page table [2]
> > 
> > However, BBM level 3 is still useful for CPU only operations as it
> > avoids intermediately breaking translation.
> > 
> > Design
> > ======
> > Some of the conditions that BBM level 3 will be useful in (RWHZWS):
> > 1) A change to a PTE memory type, shareability, cacheability or OA
> 
> Could you please clarify how BBM level 3 is helping this particular scenario ?
> This is supposed to be a case where break before make is required.

Right, I initially misinterpreted the rule.
However, AFAIK, KVM does not rely on those, I added a comment based
on Oliver feedback in the last version.

I will update the cover letter. But looking again, may be we also need
an extra check to enforce that in the run time and fallback to SW BBM
as I'd be concerned about some of the KVM call chains as
user_mem_abort().

Thanks,
Mostafa

> 
> Thanks,
> Linu Cherian.
>  
