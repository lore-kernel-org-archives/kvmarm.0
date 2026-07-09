Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBEC3FF8B9
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 10:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783592876; cv=none; b=RUar3VG7zF9bMV8NkRiUqUMmZfhbqwA2ri7JQ9HATs1q6ZAmZjedR+f7OT3b6KsdbHsoEgTrxYMQr33mrL9uLvBAjRRLmR9EgnTVZu4oNqHGsZU0invXJT3OJ/QBocVXIwHNbRQ5/fFQpmrfcCM8hHMyhQfIkeGJeKfquGp9c0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783592876; c=relaxed/simple;
	bh=MxLey4kR4pPKpR8Eqs6jpbSuCMQEbnoM8JXbBb9w8kA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKZ3OBy5jUYgdh/Fl0v1iAYZ9X1e/NP9E/zplGF3dHLUzurrK2UaTmS8ZsZTf88YjOWiLl/K4skxz+RNquwLQZUry8XMtyWaX2OjFtOFm2d4y1rZ4avYmUNt1C5QmCOGP/oTlr/8mVPSxYEk4tsBBv6UghJZAXHTMBsdF6AHxhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wWAC0k3j; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wWAC0k3j"
X-Forwarded-Encrypted: i=1; AHgh+Rrq+sTpEmJDqVwnK+dRo9LTWSQMH+Q9pN1O01CHEceioGoixd3qgnMfVcpwL58AB+Fi5VSQbpc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783592873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MxLey4kR4pPKpR8Eqs6jpbSuCMQEbnoM8JXbBb9w8kA=;
	b=wWAC0k3jzeI2I/Yb/1CJqLQdLDqbaqziD1CwjH6W6Tzq4psL92fG4HL6L121kLC4SkNmSU
	J2B47PGlAyCi1Owzyo9ltNl/tU9Lnr/OvNfn6ZXos/Aup8WhJVWhHIlVliY77zeL+Jy3c/
	cw85XAKC31lmODJ/+knq/aZnrJwYElA=
X-Gm-Message-State: AOJu0YwfbXv5Nau/vSP7L9cOPuASFOJXouETtARl3K0li/GoqV0i5dLh
	wObMlsEQ4WC0GLkbIEpTHvuFdILjE+e2Ha1kVTrbJeBWMKvADuRy1HO3QeDvqIK2K1GBq73Yfys
	bYqObETteSymf/PBG5s+fKXtVLB25KPg5hDLUl554
X-Received: by 2002:a05:622a:248b:b0:517:5ac7:332e with SMTP id
 d75a77b69052e-51c9a7990e9mr6344801cf.6.1783592838569; Thu, 09 Jul 2026
 03:27:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 9 Jul 2026 11:26:41 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com>
X-Gm-Features: AUfX_mwpyfAsKpUMf2tNxcvppePr82pc_iCQFLAefIFcUoHnYHNmsUIYIv4f_m4
Message-ID: <CA+EHjTyAxBx4jhGq-Gme5hPi1ZyDAkL2CP_U22ykkQemD1dUhg@mail.gmail.com>
Subject: Re: [PATCH v11 00/29] KVM: arm64: Implement support for SME
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Jean-Philippe Brucker <jpb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Mark,

[snip]

> base-commit: 4c45e14df2f4e77982ad70d6d8e3fe750edd4c37

I think this SHA is local to your tree. I can't locate it, and neither
could Sashiko [1, 2]. For a series this big and complex, it would be
good to get Sashiko to review it. Could you please fix that?

Thanks,
/fuad

[1] https://sashiko.dev/#/patchset/20260709-kvm-arm64-sme-v11-0-32799f66db9d%40kernel.org
[2] https://sashiko.dev/#/log/baseline/42725/0

> change-id: 20230301-kvm-arm64-sme-06a1246d3636
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
