Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BFE3019D9
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767710455; cv=none; b=VIbYSkLd/e3ywEpj4E+JcZ4SqLC6CZMLWRAxrS62ppuaSDTacv5gaiSG0TEhN/08wmwYba8vkXw1/vLOPf0UCcsgIJWAvLnSy3AyqYLrL/L2Vp8+YFqRaz1PjyMCAvf8BRZyGbTf3WmYSxonVNDZLL1z2b95xe/xDNzYwjp76Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767710455; c=relaxed/simple;
	bh=8F0aF74Y4+WS8/EMlJ1AENNqNR/jUk0wYfGBYH3ykZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+9XksgyCWBpOBZRRl2CYxFvohBBKqSrQ/tmQZSmNd3goo03igTgfxLiKD2t7VCCVhPDf9lkHptgDWk+6j+8oHIE1CuyPl2T5vXbqu2mwWVYoKyRxlyfegQDFzX+wtpz/Y45G5vXDMNhP2PYo47NjViTt3ASVvzTh9b8wMj8ALg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ebcqn7BA; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ebcqn7BA"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-59b685d2b79so597001e87.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 06:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767710452; x=1768315252; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lg9Rt1HeKklkA4y0U78VeQ93uQ/qnZsmQ3EenAnRpxE=;
        b=ebcqn7BAA+EbANMqLI6D3oO2s3MGVZBhtV1Yd0A1gvCjcoT7fPO6NXnQoPtAQsp6JL
         8YCFs4OmqWrvtaKnpoQz7zeFP6DNyMdzzccIviuVqBGDx7ZFzNahcVPr7qh0EPZZUNi/
         E0/XhGE2HVJuSHd2UShmjZg+1dUMXd00v2Y/VbfHYg6PmKkBrhH7z1UQfMPvydzmFuW+
         wOPw4J5juG/+daBxmqiNE3jDaZRc7XFsn5hvDzDuxMjAdSD5kxsfj/KPtIyfgkp2hNvz
         rjXTfZRf1U9uAboexm8bwdzKh3AIPfXrBj2yiIUiqqhkdKZoU14qBTLz9nCqbQVnurux
         x6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767710452; x=1768315252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lg9Rt1HeKklkA4y0U78VeQ93uQ/qnZsmQ3EenAnRpxE=;
        b=chS42xUUcP79XAjUIGfZIcLGhq4CIbFsVJcXFsZUlonlFG3H5o50FaBofgrR4kLWwa
         3Uk1NWBxRHl/cJ1kiiGHzN5PF5W4g4JAUWWJ/dPYM+2zpAbtss1quNcZASjeOXHpzsYL
         /gxS2idbQzagvMpeEofz6XKEY+iuDbIYx2yHe57xHEEzpiXjSwZo6WI/Xu2hagQ+SeoR
         z1j3w0OJ+fgxnT0arke4V/mVgWtMSHWFpqpHX63GI4gjevjOceA0UP+lS/8T1hxfGv6v
         dpoooZxx+eOfadJY90kk1ZY7a7FZmjKwN8P4FyBpkN9Mixo/igu8ekyIBEqffz3EWHsD
         mghQ==
X-Gm-Message-State: AOJu0YyjYoCltGKfN+vbHndMgPemjiK/hf23H3mzp9+/H1jfBbk4P08M
	AHtSUmiow5VGfFt+/oNooh4UQJbju+bMtHpL37K4Ucn17Tq+wMsvRGQatmvz3/v7h4FcqwLFHQ1
	xKcrjrg==
X-Gm-Gg: AY/fxX58ElzxZQEun8/F/uM0cntAjhDhiyH43/ogQJfSiGgZpMphng+q9/HsZ2351VD
	pVNcepRG7W5FYSRXB7xImATrH2M+Hdb3hjuX9ZGcEbxPzjeyf+8UDhl3PnspxTaJcuZAyq8TDP4
	+d7zwjxtq3QcvoJuc16BWz+Ud5/l/jKTGkSQdNVBJGjAUBHhNBk/CrK6JJGZhj2osdf6RZf1jbk
	4iGMd0SHAUowvBwoqlzzl9qQIIO9k9gp77hBZxNllEcCksSz1OoW2HBMSjDgZNR7Uqflle/Erok
	VwczB5PH+YkE38A/RIkuO7IMM+YXzm+pD2NbXr4sli7K9e4dajye/syZSIoJ9jOGcaacwX+a46y
	mnAlOMKuAUfXucBzXa2pqFY8mobP0vdRaOWiBNECZbR3J65nuR86NApROJbA0eZ3482g09M2JaH
	iSB+OGwCPr+ohqHq/DcaGrGIl/2SApF/d/OwHdgQbEmO0yzQK4
X-Google-Smtp-Source: AGHT+IGQmMYGyg67e59L/Ani6cot2XLoJXjG2yxRGQlWaxQkbv8b63wrBDjE/OQoVm5vCXoynokutw==
X-Received: by 2002:a05:651c:12c2:b0:37b:97ae:6728 with SMTP id 38308e7fff4ca-382eaac9c78mr9558871fa.34.1767710451570;
        Tue, 06 Jan 2026 06:40:51 -0800 (PST)
Received: from google.com (228.231.88.34.bc.googleusercontent.com. [34.88.231.228])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-382eb3a0046sm5577981fa.8.2026.01.06.06.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:40:50 -0800 (PST)
Date: Tue, 6 Jan 2026 14:40:47 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 06/30] KVM: arm64: Remove pointless
 is_protected_kvm_enabled() checks from hyp
Message-ID: <cokixmkyotfs6ts2rqn4xa7iseno6hk34eon76raujupedgsff@hmkoakf5kr44>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-7-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-7-will@kernel.org>

On Monday 05 Jan 2026 at 15:49:14 (+0000), Will Deacon wrote:
> When pKVM is not enabled, the host shouldn't issue pKVM-specific
> hypercalls and so there's no point checking for this in the EL2
> hypercall handling code.
> 
> Remove the redundant is_protected_kvm_enabled() checks.

That made me wonder if we should further divide the HVC space to have a
'pKVM only' range in addition to the privileged/unprivileged split, so
we could WARN in the core HVC handler in the pretty unlikely event that
we take a pKVM-only call in {n,h}VHE.

But yes there is no point in littering the code with is_protected_kvm_enabled()
checks all over, so:

    Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
