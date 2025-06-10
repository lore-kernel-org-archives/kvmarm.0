Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599681386C9
	for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 15:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749570539; cv=none; b=WTYOlUrWG1DpQ+sIHYZfncCNDjpOboXLE0FNENMUzc2KUnLwziGZjJNOJquszvZHiRr2KD4jJqOZx3cFquFJrT+YQAbfJlm68+GpIt7ZFjQB2HSS2BIWYhsKUg8sI8KrkZyJhBytosoumeZlObt6JYrNQE6/RFkCF4QluM7N6Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749570539; c=relaxed/simple;
	bh=Hz//LFo8t9c/PCWUgBzJFKXWDpEvmiywNeajS1B4WAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hH7aKXu/yYv0DUOR00qp/H2QopDVBlMdp5aCjQlLxf+Nr3Z5ud2lTyEaqqiDfzBeIqIQMU0lrbq1ZvbalDocbH9j/b7rLJoOhEx2We7kgw87wTXPtdFBlOu70WvHiFDlduF7C5kczXIGJuHqDZwyrDR9Ys6fSnvaXD/LP9M/3YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AkttoMwV; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AkttoMwV"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a525eee2e3so4252001f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 08:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749570536; x=1750175336; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ky2PNbqrD+9D6VM37eni3Xt9ljO7lJYVSeVmqVOIB2E=;
        b=AkttoMwVExBdAcaNzGa76OzPEOvbP3mFRZUp9KWoUDajbocj88BHIN9u2YEHoYlNlw
         EkarFAt2CJiI9o3OQJuR1CIVF+8pNmxZjZ7B/s4ZKfLSfzYP+U53VWgBypgvv2emjuPL
         Wlfa6MTIh3P44em2Us3psd42X5V50U6357EF+ZLmXkIxvjUAzoWxv3wlAsBgWOLokVey
         AAwtncihoC4lBBrxmj1w5qkSO/mJvBuS4kM/tjwjqdDnUnaaVVfy3b2VWrvzoLp/9I2o
         1FitmRLDi+sNZmg0RG8z7gU5JVFv4ZzQVSKSLekrdAMp0qkkftWOStjBz9nWB2dhDGOZ
         dYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749570536; x=1750175336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ky2PNbqrD+9D6VM37eni3Xt9ljO7lJYVSeVmqVOIB2E=;
        b=Dk9lzBaryboe9oiHTN+tvnbeUkrCrofPj1UzoYlqKwvS0Apei1j51K9VdH/VqLXdhE
         K/uS3ttr6F3AiT/Wxoo1wv9hJ6GcQFho7BvjyMZUjKmTBAccjnfhZtIiY0fZ3Ak09Tac
         7tRLQRWsEte72cGcDxtBzuFJeVW+wWXnIWfBCVpDmLTPmUnBoHiEJSZKlO2X86gJjztD
         Y1Ma1EaxvY6eUtcycDHyL6k6VmPvjCatPGn8+LP249Kg3ljFJO6DaOnzQa9XTaS2PAQc
         M868WfCmC/4XY7ehosuUYKuZDWpqTP5wmuvdUyNGXQl2TlLtTZPiyZ1QOxyQh5F6mzVH
         R90A==
X-Forwarded-Encrypted: i=1; AJvYcCWNQljdYbjwgscRio9BUujF1AlS1V7xZWp/+dNFUrSLcg+JGxWDcjbN8d3+A5I88oUmUzfFyjI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRy5v2tw41YKskBkc+vsjGc+oIlwyh4IrKhGREufMPL+rxKUk8
	3l69xU90UA5U4uY6N9AzYLsOoNwvBPQYINX2R5aPu+JElO/Nc3FSBhNWjHo7yA96Gg==
X-Gm-Gg: ASbGncuHObisAvHxDrHf4Ibny+fGyjMxSQAJpKjRoe4Ud1P71PDZ9+ICYJW0IiSpst2
	UlyFuafaX46qCFg4TFXSjURt3qjQeqCo/sAeiZ7B6STVWBTnvC+trUxUa4cnFVoc6vhnBx2U4s2
	L3H4EKRoRYEUO2uzhIi4IUGbYtzaORuOCsJFLcbqCQZAoYAaPynVmPJpMiBaZOCdiW3s9aEqz16
	HPow9GBkkpmcZOMgRXXklqcQS90J7xl7z0ZJD7T09dcOT/qiiX3bAd97MWNZLwNvz3wgbhNWetD
	CnqB42YSUsfuTujTP7sykpnw5JfsCs8VoQJWlsABlnWSY6J6AmaT/TthhlfeilDoPxt7RdxOPNH
	CEbBJuJ+nxmj6zHskVbFGEQ4kYXiykg==
X-Google-Smtp-Source: AGHT+IGMAEWY0uqwpIwPc7AQMrD49vRT8Zf8Ox11v7143hyb0bFhP3wlqkf5ZIizyj4fRGyoAGb6Mw==
X-Received: by 2002:a5d:5f55:0:b0:3a5:2465:c0c8 with SMTP id ffacd0b85a97d-3a53178421fmr13397903f8f.7.1749570535460;
        Tue, 10 Jun 2025 08:48:55 -0700 (PDT)
Received: from google.com (210.162.187.35.bc.googleusercontent.com. [35.187.162.210])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a53229dc33sm12478035f8f.20.2025.06.10.08.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 08:48:55 -0700 (PDT)
Date: Tue, 10 Jun 2025 16:48:51 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: nvhe: Fix build failure with gcc
Message-ID: <aEhT4zYOkY-cUXRD@google.com>
References: <20250610151132.1758206-1-aneesh.kumar@kernel.org>
 <87jz5jfw9w.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jz5jfw9w.wl-maz@kernel.org>

On Tue, Jun 10, 2025 at 04:31:39PM +0100, Marc Zyngier wrote:
> On Tue, 10 Jun 2025 16:11:32 +0100,
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
> > 
> > Address a build failure encountered with aarch64-linux-gnu-gcc version
> > 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04)
> > 
> > /usr/bin/aarch64-linux-gnu-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__clock_mult_uint128':
> > /linux/work/arch/arm64/kvm/hyp/nvhe/clock.c:27:(.hyp.text+0x120d8): undefined reference to `__kvm_nvhe___lshrti3'
> > /linux/work/arch/arm64/kvm/hyp/nvhe/clock.c:27:(.hyp.text+0x120d8): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `__kvm_nvhe___lshrti3'
> 
> $ ls -l arch/arm64/kvm/hyp/nvhe/clock.c
> ls: cannot access 'arch/arm64/kvm/hyp/nvhe/clock.c': No such file or directory

Hum, this file is for the pKVM tracing support and is not upstream yet:

https://lore.kernel.org/all/20250516134031.661124-18-vdonnefort@google.com/

> 
> > 
> > Similar to commit 9bfe7553fadb ("arm64: Implement __lshrti3 library function"),
> > this change use the added helper.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: Joey Gouly <joey.gouly@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Zenghui Yu <yuzenghui@huawei.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > 
> > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> 
> What was recently introduced that triggers this? I'd like to
> understand what mandates it, and avoid it of at all possible.
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
> 
