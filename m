Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8DA1D174A
	for <kvmarm@lists.linux.dev>; Fri,  6 Sep 2024 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725636970; cv=none; b=F/m8SRiGOK4VhQs+FgU0pQoUSk8/jGFtt+x/iaUEo7zJC2aNpEBfUfLfmx6TOVeOGUhwuyo9Ct1LnpHQ9+oVmOLa7NindNRPqHsJOeO6DydKkijqZizarDF5x1p43eChhGrZOpVrb6r3PQwXqL6YMC1hMXfNpOG+mlYC8ZyCbDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725636970; c=relaxed/simple;
	bh=rj5X4jWsGQFekeqYk8dIy4ujKY1KtAbu6mrY3UaJpHo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kY/WI36ap93HMYteHz+rkpGBF6ngBJyx4GfTHwZOuAO2jpnkPNrvIafcEeyEgVBKV/fxUO5Do80910JDEkrjtrNiNKb5/bb2FUMsKWxKREBQTz4AYb3zkcua9EC2K6EQW2urGkurErx9ey2oz4dTG963+kdQzW+HufjY/dqpeFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ccw/koue; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ccw/koue"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42bba6a003bso52905e9.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Sep 2024 08:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725636966; x=1726241766; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rj5X4jWsGQFekeqYk8dIy4ujKY1KtAbu6mrY3UaJpHo=;
        b=Ccw/koueUOty62GfmBt+nXBERjovmq+2UlL8Dbw8YG5WoudJpLnjbWDB95ba0nZCNs
         K6aRiyoRvUfT+tT0RsGR27R0OLgrG0TbQnC+CzlmOaAEOwouh0Z1BD027n3heuzKfyaI
         ptH+6CZboiaqnnb/Y8VyquQ/V/53nMGHJNnuuZNjfVKt7XEgbG6XKyZbVUIcz/ErQt5r
         Su9cgVertU2DCrRzzUgwRBYQeXC4FN/XfKQ8jJ8BCp++T4C1T/7klKNBRafgUnbNYrIq
         nOkHqZRqed5a68Twr+lA+3IDZEYQP5Sgn8yFuSTg2n58hfpd5/8/bGMmyK9RY5hnm9DV
         cG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725636966; x=1726241766;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rj5X4jWsGQFekeqYk8dIy4ujKY1KtAbu6mrY3UaJpHo=;
        b=kYYBovhIVZhLp7jbzcXB903dne3m1eypltfN4a7Nze+aSt/kv4XD0dbZu5eSquXIry
         qkEdtZIOHYs2Pw/izz/nR4CW8WwNyu7S/aEFiS8HI6PvesZ/LBMZ64p5PfYxoVxzs0fN
         +2oNP4IRvvTTk8vUlPslBBAxUkpI6bMhYCqOBNVbuof81Kh3yGulxdB701BYqRpmq5N8
         xabqMXjTfMTIq19lgCdvPd8pODcNpAAvcz5iKbXxvsfUo2JvinMB3Pkzid++x0QW6pEb
         +RXWumymF12sW937GZeSqa0UEh7phuCFiaMNoNacw3ndflt0GxHaKp9sPjgkotrshG2d
         5IdA==
X-Forwarded-Encrypted: i=1; AJvYcCXz3bLKDBVJCX1L0mlyXGMZgIBcyTg/6iJ57ZJ1UQR+CK4bHeIcGWCWIeHaCj7bwh+GRawwf/w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw99kwFlRpEBfAKn+66ymsaUPS3IZif8XijAuyopaxBFLF7ZT6
	kaHLlytlO4Raa6XlY8LvJW6YNI+/s5qzvsrtDapaYfdlN7tsd4SrK7L3pURkOX1IaOGY1WtOZrw
	bNtgi3fmzsG3K+7We5/Rs7uR9sYeCL+5PMxeb
X-Google-Smtp-Source: AGHT+IE8hkyzS5q4Ko5VZqZkxV9Egjt+wIc+exqGjXRMHN4pkjGweyR6LB4uLnV4p3/PgpVKz2OZ4tmqw3FeIBgUGH4=
X-Received: by 2002:a05:600c:1f0b:b0:426:6edd:61a7 with SMTP id
 5b1f17b1804b1-42ca0d73c41mr914555e9.7.1725636966172; Fri, 06 Sep 2024
 08:36:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org> <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
 <ZowGFl/1AEuevh96@e133380.arm.com> <a3f2f13e-be22-4a09-a8a6-5faef818defe@sirena.org.uk>
In-Reply-To: <a3f2f13e-be22-4a09-a8a6-5faef818defe@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Sep 2024 16:35:29 +0100
Message-ID: <CA+EHjTyCvG2KL=LPhbAf+Wo66QoC_EMk1xn+R9X-yKunHQ-JhA@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for SVE state
To: Mark Brown <broonie@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

> > Can't pKVM just hide the non symmetrically supported VLs using ZCR_EL2,
> > just as regular KVM does for the guest?
>
> > (I may be making bad assumptions about pKVM's relationship with the host
> > kernel.)
>
> That's one for the pKVM people.

Yes, but that's not really the issue here, unless I'm missing
something else. The issue is that pKVM needs to store the host's SVE
state too, to be able to restore it. So hiding non-symmetrically
supported VLs for the guests shouldn't be relevant.

Cheers,
/fuad
