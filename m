Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0AA2ED17C
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 09:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760089628; cv=none; b=D+9D+mddFVPpv5wJmzM7SeaMqBehWGnbI8dtUkmmKhE6TyB2Y7EuFjYPnhvjkLG0pH7UoA8PwN+ynrxpX2V0w8SzF3u47p3Bnl8Ieu1sujOx3nRyxFYEIPOIy0VrGaJ44oHZMXn/szd0QriO2dTosN4JaM+J/m/72iaW/fC6Mlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760089628; c=relaxed/simple;
	bh=YG3XVE8BDE+7g6BrUmvd0/0exOeskGKtZukXeiKO1PU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1qpe765pRI7kE86w/wOFKBkThH6wrZdD5WpwOXWvzl1jlQGs1fPXfFArhn4EXtHPhVvWT/pYNPRivoLRrb7+PTpdMBZHJFdBwi3T913UZscRpdvc1YAvSQ4O/QsIIFusc/MWuFZttksBq41Qz1s2mzRzyQCOO43YTYbttiF/To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G2iNZEjL; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G2iNZEjL"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b4068ff9c19so322904266b.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 02:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760089625; x=1760694425; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vqq4E+QcPm5gIESa9RU+pQ2jp4yfb8xgjlkjRCHokwM=;
        b=G2iNZEjLN72m1OQ16DM0M3aHG7vziclWakSPwvwt8JkOFS7P6orso8JdbbtJ+4dhAR
         MVRlu6X8k2fBUXDLS1KfknUiBdj6CospVX9HfxqTP28JhcFIDJjgMW/pbYG/jEQPhd99
         W1uqKIL7DTgRbBWGbkCG1znw79NL5eGMX+cAY2VloQVyAug/psjA1I8gg13ijbddlBcG
         hW2CE5Zewo4pLmANvP+o00t/jy70BojnTKntZ0xK9f6fr96mDg4Kq7Czi46YHF8i/Ecr
         Ep0SCfTXuxX0Os7JWceLgt9sgzN2V+fGw6D9vzRBifutcyhsRMHlj0p+TxJxw6aAw2/N
         zldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760089625; x=1760694425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vqq4E+QcPm5gIESa9RU+pQ2jp4yfb8xgjlkjRCHokwM=;
        b=STc9wSH2DRsOXGM00IIr07f9ie8poCnsp2BtPGvcgVsMFZ24YYU+g0GxIvU+F3mSr6
         Zh20dAg2WzoSACMaoToEkS41ExvfZljfLBrHk8Ywz7fXmYxk9v0EiQo2vXcs5td4zS8N
         biQ25S+36CIPCwftPao9n3jW2Dr6OCQYE0SKnX2wt5HFCduXd9gpWdeEtkE0HRfTmsbB
         H0vmpKZERbCoGLpXIEIeO88DXv+/9XKdfL6rUr8QCbvvtFtUaVHA9oa4777Ya3hguBdf
         fpkv839s4JclmhbUNg9WD0r1Fi+iPB+C/ap+0y8+AAdaXw6nHzqXqfjfVEFu4/48075i
         mSSg==
X-Forwarded-Encrypted: i=1; AJvYcCXyKJxqr02RcSu9gcNOZIuyDrZa2mCtcu/Qoj0D2jt7y/Dfbv9UzD3aXS2GQXYCWjnEMO65Oho=@lists.linux.dev
X-Gm-Message-State: AOJu0YwehfzZf8zx7Njgk2tX4kRDS7PbBHoyiHaxvSpkLDfl2+GqWZKR
	/5Jrnu7aFsdPzIKcobykb6jnYMh+7fSFBRFUzMdDOilrOjuz7ZT6alDXQIQoJJCfKgNwodm4nQq
	EcXnyF2/TODTgJQ==
X-Google-Smtp-Source: AGHT+IF3kyGZ45/SIomeQ10Oy0HpD4ltmqNTCbJ2I7tWbnIvSDEZQxkMPFlCPp/SVExbwW1i/qxQKgZbK/NQ5w==
X-Received: from ejab15.prod.google.com ([2002:a17:906:38f:b0:b3b:af15:535b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6e92:b0:b3b:82ee:def9 with SMTP id a640c23a62f3a-b50ac4c5bccmr1154491966b.53.1760089625454;
 Fri, 10 Oct 2025 02:47:05 -0700 (PDT)
Date: Fri, 10 Oct 2025 09:47:04 +0000
In-Reply-To: <20250930163635.4035866-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com> <20250930163635.4035866-2-vipinsh@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDEJP752Q32A.1YMQI5QN4IP0A@google.com>
Subject: Re: [PATCH v3 1/9] KVM: selftest: Create KVM selftest runner
From: Brendan Jackman <jackmanb@google.com>
To: Vipin Sharma <vipinsh@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, 
	<kvm-riscv@lists.infradead.org>
Cc: <seanjc@google.com>, <pbonzini@redhat.com>, <borntraeger@linux.ibm.com>, 
	<frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <anup@brainfault.org>, 
	<atish.patra@linux.dev>, <zhaotianrui@loongson.cn>, <maobibo@loongson.cn>, 
	<chenhuacai@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>, 
	<ajones@ventanamicro.com>, 
	kvm-riscv <kvm-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Tue Sep 30, 2025 at 4:36 PM UTC, Vipin Sharma wrote:
> +    def run(self):
> +        if not self.exists:
> +            self.stderr = "File doesn't exists."
> +            return

Nit - typo here  s/exists/exist/
