Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FFD29E101
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767709941; cv=none; b=ZYAGf9au5LGt9YGow7spywbHKmmU9KKqkKrfyN5Uwg6+aoU6hTH2YAMG2+ts80ZAzmUkzi6je3SQDrtiUvsQMvag1lAAVfWVMZfJG98/BwYFNuYjJTt0kyu3AgOiVrNEH/9OOlBdI/UqzkV7iDd6aTUqVDhZWZKCbMj3unAKGEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767709941; c=relaxed/simple;
	bh=hhDxtEMCF99Iy036TyYgHBb3c8cA1WOjZ8ZQ+/LmbVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHZ+AbbX4OW0rWlc5W3+8KvyD0u4TW+VnCXEKvGfey8HzFYU/MWKinB+89Gr4hU39+GVoQbaeqtKDaVomUUvcDSnIgMKm352t73O0KU48HEWUvICZm4U4ejE1TZRhnxX0V/HgCPrjTx0r0iQUmeZnbQZkdBkp3X5H7kLyhh0zw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xhEy1AJg; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xhEy1AJg"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37bbb36c990so28863141fa.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 06:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767709938; x=1768314738; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hhDxtEMCF99Iy036TyYgHBb3c8cA1WOjZ8ZQ+/LmbVw=;
        b=xhEy1AJgEaBgBra8sOfaCsOW+Bm6Ux65Lwgi2Vfs9rusjUiY7C+waJYIui6duXKR1L
         wtPaY+MpGyFoU8vgsNpIWKx0KHA0yVG7Q5puTuF7ELoekkbLvaFy27tlnmX+4tVIBJvn
         TWkl0cNNlxeFERSA9XoQxg2Wwq/KowaiVft2EZmXr67AlM18v5Zl7ficVlOzHAJ5cKkZ
         fTmaYToMoi3SweBMwQaTvFulAdRWzvl6eqVinWpvHqzuhaaHnolUEvLBIxdpj1zl78+A
         B75sFGjf5F7Qcevn8naXdBQcQT8cAvs0C5icRB4qz7aaGHh66oA2xfAc0NDQLRVi3hO1
         Dn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767709938; x=1768314738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hhDxtEMCF99Iy036TyYgHBb3c8cA1WOjZ8ZQ+/LmbVw=;
        b=W+Zrx0NJIKht3n6RiumZK9XHCYQy712kp/0Sk0KRONGYXEgoRuZqne6iDo8kVTueQr
         mMMO5gRD3pHswTpz8EbTV4Htwd/HGoCkROLUQsvdJ73/WAtFt2peHMThN5ZgbAHKQzww
         QCIXo3+kyxqOjN4Oe154cDk+EcmtRgee9kW3HilPepmFrlB0kXwMgQAaGnN8pZJeztk4
         LKgOXqZehiaYh9HoyIvOV9A9WOjhznOgDcO0Qqi+APuVLv20kWYUvXnP7nSOrfveGAmB
         FPR3nYbvhE/sKh77SHJJhku/cn94j9V6kjovhqh+UeEsDPgZYz9agnJPgpDV9uMxrEJZ
         rYsA==
X-Gm-Message-State: AOJu0YyFrrcRjqtE04KRi9e8KR0SUtan1szb71rT8HrRKb/g9iwoJKG0
	Jm1axtniHSDNTgzmV0S69wVgKi4OcoTaePIVtDbCo+5oejA8VynSQ8FPznUC7fFvlQ==
X-Gm-Gg: AY/fxX4z1Ol2AdI72WE/Y+F/Iyfq+CQDog/oPfO4gdcqISvGxPZJx4AQLQ2dJFRiu2u
	IHbedGdFt/E9QTHQxsim1wiBvj0SLK6AGMWTBg+3Q0mzsLhl2kSbEZOlGLGVm6ap7H2INfv0/28
	YrnRn5upXCklirbHS2b82md3ZYDx359706VuxYDO/V2ZJb/w0qlpPHbujqleoKHCq1Z6FHS1Be/
	0JRKB97FjibkrRl19CfltgbOL7yZS6u76IgyMQFAcD0+D39wpUu5D0yAFmWz2jaXNmUNmti0qwi
	o3JW5flmzSTb3ntyc5ecPg0ob+trz7LAkCi3DZxiJI1yQSlfsGt/Ldgjk0huSFPUcdhlE1pqAi9
	cgpAHP8nyvbYV6WKxOTQCH4Ewnf2BsAoxmKDl18DYhnU9ZwaSSqRPJVH4PtnlWSozleKA/9oXhG
	UUueXz0IYOByUEqrtjaT7lt9wfROKOAnjoej8Q+GqUiSPJEIvU
X-Google-Smtp-Source: AGHT+IF9zm6QFdTZmWZWktW5iQ+vqNveJ/W6BDUFaPSdFRGdLXQLnJOaUT86qC22O5ZLKg1ItVuekQ==
X-Received: by 2002:a05:651c:41c1:b0:37e:508f:81d4 with SMTP id 38308e7fff4ca-382eaf717b8mr6454811fa.10.1767709937339;
        Tue, 06 Jan 2026 06:32:17 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-382fd34bc69sm3571fa.19.2026.01.06.06.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:32:16 -0800 (PST)
Date: Tue, 6 Jan 2026 14:32:12 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 02/30] KVM: arm64: Remove redundant 'pgt' pointer checks
 from MMU notifiers
Message-ID: <7g66xbfmfqf67qcowjuu725h3l33ecxhkffmlzxsjtbusk5eor@khlpkp7jdfzr>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-3-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-3-will@kernel.org>

Hey Will,

On Monday 05 Jan 2026 at 15:49:10 (+0000), Will Deacon wrote:
> The MMU notifiers are registered by kvm_init_mmu_notifier() only after
> kvm_arch_init_vm() has returned successfully. Since the latter function
> initialises the 'kvm->arch.mmu.pgt' pointer (and allocates the VM handle
> when pKVM is enabled), the initialisation checks in the MMU notifiers
> are not required.

It took me a while to remember, but I think these checks are needed for
the free path rather than init. In particular, the doc for
mmu_notifier_ops::release() (from which we free the pgt) says that it
"can run concurrently with other mmu notifier" (see mmu_notifier.h), which
is fun.

Had you considered that path? If so, probably worth expanding in the
commit description why this is safe?

Cheers,
Quentin
