Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439641F3D2B
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734441797; cv=none; b=EOWWvabOglIXz4w77O+dM3bZvFsfxEGenwxmMHoXYVGR4Av7hPyucLSYlOt7JLZ7JQYbCsCuIIKj4gqbjNgOsMeQaL2tjVdcKHhBbUF+YLty6BMKqCiumr3X8659s5fDqoX0K+KqD4j3VEfLDKtX0aCNETuT7pFcYwqxhHZrCjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734441797; c=relaxed/simple;
	bh=zluAZksj0L8x1p9l+OOtyBpDtW4al/9Yh0L5sEpVqUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HShLesh/51KzaJ2JO25Y1Ag9FSgD/+D3U1WkRuQWG7pZer0Hv4/S5eL5aG4GbbivgwrVSKLgtCzTSChNo0xWekfWDYLIFh5DwZNJur8iIsbc8nH1nMTFvHT4JbYdoR3nwdIz3ukS9c+235tBjzFTDYV7XpiD1Dd59ywJYGhATbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fRfe3Urs; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fRfe3Urs"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso51445e9.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 05:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734441794; x=1735046594; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zluAZksj0L8x1p9l+OOtyBpDtW4al/9Yh0L5sEpVqUs=;
        b=fRfe3UrsXWORYbLbfIPkulYStlPR9V66VYHp8tTpHwULD7Fp0HD1WgiHOzeKPH7p01
         Fe+JxYONJBZxJQpaGfTtSRrOPlq+ZkuiTzbXwyRfY0cFpHaI8902rNDRyrB5lEzv8HWl
         N4tCsKUwY96k7dfgQlH6F1Ga6pLb131//O5CWps4LFpj5xo8/PhazorpZGLP9DFQmDla
         d4gGRTWZz/Lbzgn1DFviplCU2l3iMqa00woEooGg1ngBGP/PANebWdwKLM2nL46ovE3O
         NQElyuia02gDubVbgUswuelTGxig5tQfr3s++N1bYwfyCSYoMVjl4r8sFnU/Jgzm+EBt
         1AdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734441794; x=1735046594;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zluAZksj0L8x1p9l+OOtyBpDtW4al/9Yh0L5sEpVqUs=;
        b=p4UgIiNfZXoRoNCGar+h6KFyCKYyJ5Hl/rYZTxGE5zMsJ1cLssvUVPyqwBjT7jQjhr
         o901o3bpUvkaNxZoL61iGott2DuGyWsBiWsG9zEnQdz91N5ColuiB2AJrddzZYunoiQb
         0+graOgkd+KAYCX0pIFQNOOsbL/SXVBFJjtP81v/aAi81Cs2PR2FWqdpYvT9maTFhZ7s
         LWmYj0bBXk3AaHPSBrHzXsDP8uF7E/YOTz3HFCytYFDHaJW/NLN1yXuiNq+R5xyu8fJu
         ALqwmBxSBox3kq/w69HE16In/1NBCl0aNbAKjGmTTILsoeF5gF1XLj+5VoJJXUuuaqzj
         9X5A==
X-Forwarded-Encrypted: i=1; AJvYcCU0W3xn4pC0S7xpYcWe9wUO3OLyjs5x5xT0Ut9rSi2Wr1BxOGbq9bWofg9XGJfcNhmxcMPdIXA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyzQsb8V2lzfegtOL/ATfzT1rcmUhblLRPz1xgNRtYXueIZihW
	6qO9Mu9OapC/EZjYjgOZZC4xi8pyYCTjB8ECf1nHsOFr4etRnJmFO6xNlTjZtyXB3oO9SPtPXGq
	4jeBG2X7kKOR84/+KoRuxvZXXZu890mmjRYQw
X-Gm-Gg: ASbGncvHY//faTFtqPR2LfRJEGal4EaYn+5MI78mVgKB1Pm4iCabQmtj9PyuUJer8zM
	a75h9sfsL+wXm5b7KlipeXoWkGIUalDQKl1ZzYie0wNj2PMs8IutZzJuDuFrl/PhXHtU=
X-Google-Smtp-Source: AGHT+IG5ALWJj0ksNk9sQYWDvuIBxfw/FZ03jE5oquPujoQVSflCn5++EfO42GLq+XkZqgVWsqivlsN1K0ssWL87W0s=
X-Received: by 2002:a7b:cb19:0:b0:42b:a961:e51 with SMTP id
 5b1f17b1804b1-43648ca90ddmr1215695e9.0.1734441794300; Tue, 17 Dec 2024
 05:23:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-12-qperret@google.com>
 <CA+EHjTxRt=XoCZbRLE1UjMg4bzgoLYD9Lh0nzmjvPZ2Q4xQOkg@mail.gmail.com> <Z2F5KboZewSDClKg@google.com>
In-Reply-To: <Z2F5KboZewSDClKg@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 13:22:37 +0000
Message-ID: <CA+EHjTzmEonAUNNHM8X__6XHLko0fksjT0_ZVHhKRVsZp0zQCg@mail.gmail.com>
Subject: Re: [PATCH v3 11/18] KVM: arm64: Introduce __pkvm_host_unshare_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Dec 2024 at 13:14, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 17 Dec 2024 at 08:53:34 (+0000), Fuad Tabba wrote:
> > nit: This parameter in this patch, and others, is sometimes hyp_vm, at
> > others just vm. It would be nicer if it was always the same.
>
> Argh, where specifically do you see inconsistencies? All changes to
> mem_protect.c should use 'vm' consistently in this series now.
>
> The code in hyp-main.c does use 'hyp_vm' consistently however, but
> perhaps that is what you meant? I did that to follow the pattern of the
> existing code that uses 'hyp_vcpu' in that file.

You're right, my bad. I was looking at the code in the patch, not in
the files. Sorry for the noise.
/fuad

> Thanks!
> Quentin
