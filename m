Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7067353A69
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786552591; cv=none; b=FtNS1GfqTJWnUsS9UXFj58Z7TLHipuns5Mgr8503fnJR1GodEnVJ2Xkrscn3Sp1ou65Q5Lvr0jxTDb85uv2DQcwDu2EhZrGBHWNbXHNOC/kjc6LMlbwUT6tdZ++x8ksTIOLxTniKmcr+QWfqnBs20hwDsSIf2qtEWEP6wVVhDUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786552591; c=relaxed/simple;
	bh=KhAZhbhhBUhb1B9BeUG+w0byNG+wvU65xNilO2isf2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AOHnFw4d9cTxoUqlD4h6+c5W+JvYMHSSqn7bJK+4GYcaL2acoh7Qxr6pKswITZVgbLX16u8UtzgtrWG6CeLPBrv7AMMivgrJ9DEJWi+trttyPNed2H0Ql/nle8gKD+stkh7LKIVf6mM8e3FKMmEWgsVQ2lUpnIg7QfjOFqoFxGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rJ5QSiaS; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rJ5QSiaS"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84870e7f498so1505840b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 09:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786552587; x=1787157387; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lulY/imNSY4kViCEFvXo2yMu2/ktyqgptsFx/K/KoVU=;
        b=rJ5QSiaSzsqZtaVaXGrpOsGbRh2TFRxUjEIpNXNvJzN68AOWYUvFzqzo2SXW+tRvsc
         lFFpJzfVBPVGMHuGX6EugLcevKP3D8XAFIZFpQrthEYwVbY/WhZ8mxB9PV45EfvTd4co
         0I14nnn8Z8LFZKkNQol5qCKER4SxewSGgIVfyaGcXjkS42499C0vgf4E8giC/o1OMC71
         xcyZ5wAFqCF6jYXlNLv+CiBHQjDC2IkfGZg0p2kduzf4fA+/pQal2l6M5I6h4hOoEAS7
         sKxp5X+jl6pWgMS0fOObw/PGbWmP0YK6iJtLtuvj9X8oeqMo+toZeEXEmKwfb7B9zQU4
         dK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786552587; x=1787157387;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lulY/imNSY4kViCEFvXo2yMu2/ktyqgptsFx/K/KoVU=;
        b=j4yrDEMirWrh2Lq0a11XiOBLYML35vtTijnQv62WVgITU8SSIbZyPhZuDLQGWccpFz
         UrHOdDCVNRPlLHCxuw9Kye1pwIvFgOlX3njZM+z8sI3Uy+JcwnpNCXc+QIQxIIEQ51fY
         zMf1HEZmJHo5xVbRN2aINt/IKecXneuwj9yy55lp1b0wfyB2jQjjOGUWh9Wem/0D0V67
         cOCRHwkqJChbEn6Reron3Bgr2dUJ36d1K3sbXWjtA8MYKNR43oCe3I/hp7VGvXKl7tx0
         QpWqrLKuPgoUKpjuWHzOfF285u0VehlTZ1XWWBU4t0i0nARxTY6uFiPGHeqipFC9yj5S
         n85g==
X-Forwarded-Encrypted: i=1; AHgh+RpVDdwlli52Q3vnEuYf5iZ/EYJXZIO31sqrbQs8CkUWQV8HLVOl+qmSTGisAHVls/Hdvu9ncKo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzrs3EusA/90iB+r4uzNp4dyFkL3WCdZkG4wPYMO29ZoLhEWuFd
	6AStKHRJ5Ko17N3HGDKwtuCywCfRA1QMJqE3MewJpETR4ZfBDLqPZ26sfhbUjt96Z5iQm0Pml7S
	7hKUsGw==
X-Received: from pgkz26.prod.google.com ([2002:a63:a5a:0:b0:cbe:df3b:e024])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:b98:b0:3c3:a9e1:a819
 with SMTP id adf61e73a8af0-3cc3f73ea48mr8503628637.24.1786552587302; Wed, 12
 Aug 2026 09:36:27 -0700 (PDT)
Date: Wed, 12 Aug 2026 09:36:26 -0700
In-Reply-To: <cdb8b0bd-a15a-440b-9d7c-b532aeee6eb9@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260812153631.3376090-1-seiden@linux.ibm.com> <cdb8b0bd-a15a-440b-9d7c-b532aeee6eb9@linux.ibm.com>
Message-ID: <anyhChQlOs37se4B@google.com>
Subject: Re: [PATCH v6 00/33] KVM: s390: Introduce arm64 KVM
From: Sean Christopherson <seanjc@google.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@kernel.org>, Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 12, 2026, Christian Borntraeger wrote:
> Am 12.08.26 um 17:35 schrieb Steffen Eiden:
> 
> > C) KVM/s390 reorganization (patches 12-22):
> >     Prepare s390 for a second KVM module. Move existing s390 KVM code into
> >     dedicated s390 and gmap subdirectories to make room for a second KVM
> >     implementation. Refactor gmap to better integrate with the second KVM
> >     implementation. GMAP hides a few features only required when managing s390
> >     guests: Storage keys, CMMA, and prefix handling. Those are guarded behind an
> >     #if KVM_S390_MANAGES_S390_GUEST. Only features which implementation would
> >     break kvm-arm64 code are guarded. I leave the non-breaking stuff (like
> >     shadow-gmaps or ucontrol) for the LTO.
> 
> I will likely take 12-21 for the next merge window so that we can minimize this
> patch set.  sashiko and claude are happy. Mostly mechanical moves. I will review
> those first and might do small fixups myself if necessary.

Speaking of trimming down the patch set...

Steffen, can you post patch 1, "vfio: Use file-based reference counting for KVM",
separately?  I'd love to get that merged sooner than later.
