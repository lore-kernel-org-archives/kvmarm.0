Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795551737;
	b=m2QcwYJ5D0NrEQaVkgNeDhN/toEwnp05oP5Xoe7/3N9f/pdrCZKXS9es6qTop4jSv/QO
	 q+y3xCHFwbsghP01zmX7wQeMK0DLKTmHp0PwXpsvGfKCDlSHPgl3hDyN8XaLrq5E+nIGS
	 QbLUHF/B/ninczMXj0u9IPtHqpa4wCdoISkVTUv3ZBw/00N9ZVgWYJIRnjqWj1FMZnyrS
	 0Fg1Bye0kAHAjpvCPyRWfz0o5bYU91QhOCI+7dD8ify5uAFLG6UuF5oZ7GDIooO8fwcKp
	 R+d3PwxzWsJrweyO49gVeEKbkFoZqoA2as9hACVYB/6GhcghmW+UfvHH/FTjbylzTJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795551737;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=F1guWKqhMIdnhcOOY/GSOXPqYFIOugPZ2YwxBRVxVK0=;
	b=ojemDxrroVsmkb/N1p+YCjypy7PJy8JNXeh6o26m1Rah4gfivWauztAN+iJe6qGhyVjA
	 WtquGrvZLyzpdya2wCx1/QmW/i2zxlrp5R21OUsH7vsDlN035R70PDeIjM3JaRdsNLGpq
	 z2avz/V7K40tyr7975aOD6V+QibDIpUq47khoGahBOn6rFJxJwRz5VD5c8PiQ4ZGnRv8T
	 oOR8dBHp5Wv26I/O5Mc4ZU1p8cHp03gZGNi7xXrjY/JFiOg8ClVyL8m1mJtaEDgPw6XWR
	 /gPJdPRz0LbncdqIsOqorPlGY/K4qJqrDydVZhqycU0zXRPbvmotepNQFkrwLmsz1Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OLsS0ak+;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF53606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 20:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDF53606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OLsS0ak+
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-540537f959fso5331613b6e.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 12:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795551736; x=1796156536; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F1guWKqhMIdnhcOOY/GSOXPqYFIOugPZ2YwxBRVxVK0=;
        b=OLsS0ak+K+1WkSqH2K58P4fhJhzLX5jM3IWwzX2W9M4AgDJZ2x1UnbWmHUZHqvZ33B
         DUPMwosk5g1i3+AaNqeIni9kezc/J8y53DhArX76WSlaRAbuI5ziZdy4NCB+kIx/KPhk
         cU0XSiyiwcl+yEABb2G/5Vy+PtsZ3w+g1kmy3kn66MEiRMtTuPeSqO6iuwgJp+1Hk6rk
         6nB0BCfuXzmGwVDYBcKeYfZuPqtO8mWwFf/cSsV+D49UNhNB7ksCnbMR+LYTkfeC6Vl7
         W7s8ET4XkRHuxm6XB5jOQmYHCW0hu5o4xsDiay0O9IppjUWw9UdCNEifI+TBAiuzZspp
         96Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795551736; x=1796156536;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F1guWKqhMIdnhcOOY/GSOXPqYFIOugPZ2YwxBRVxVK0=;
        b=bTH9xZY4Hovc1d2axpdvTvrlzZejjiJLYFRfUNiucUQ0eBIpLb/+mxAbiw/J44W6H5
         7QuS6c97ozwgsgR/NR3E+wAbfj3CWFo5JRn830VwuIjzL728+Ek3zagnJJmeCxspn7Yf
         H8PGHGn6gS0SleJTDAlyviDZMZKFeUNa3k4st2W6oxdy5Mu5WlysEX2/ad/7qMTCKkEj
         PBp7e3ioKjjjWXdqi0+PV7zl+h1TJge98G7dq2YccLxX8uZDGBt1Ehvx2a8f7p/B6syB
         W15bxaidfEuWe4SGubgrA9+nA5Ns9Oc2dTIjTWcDm9Q/GZra+8OHZ2kEZDxAzYcomzI+
         UDHw==
X-Forwarded-Encrypted: i=1; AL+hErE5X8b3YXkpZEKBumVCkUL7OcWUDXaJyxa+KO4a3HCK6HDYKmwsTddtzlS8quNIVLMZFxVXnbk=@lists.linux.dev
X-Gm-Message-State: APuU4Z/1nCezYfRe/L/cHxYezQ5qhMTXwgqGpydxma1wwZrfVqpsBLlX
	TxxroeNo46z3h2xGJ6HelXwgIhJRM/ywQOnTfnwOH8//3krJaIu+kYUnrqFyM85St+wtDsFWiLK
	ZMXm6BAUiuPpwoPDwK++e+ltf6g==
X-Received: from ilmw6.prod.google.com ([2002:a92:d606:0:b0:53d:20f2:6884])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:e8c:b0:4f3:e98f:fa27 with SMTP id 5614622812f47-57a09c1107cmr18109738b6e.16.1795551735576;
 Tue, 24 Nov 2026 12:22:15 -0800 (PST)
Date: Tue, 24 Nov 2026 20:22:15 +0000
In-Reply-To: <867bi2z87n.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261123232647.3733149-1-coltonlewis@google.com>
 <20261123232647.3733149-2-coltonlewis@google.com> <867bi2z87n.wl-maz@kernel.org>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261124202215.3731849-1-coltonlewis@google.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: nv: Discard undersized TTL hints in compute_tlb_inval_range()
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Dan Carpenter <dan@pereq.eu>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Nov 2026 13:10:04 +0000, Marc Zyngier <maz@kernel.org> wrote:
> What's the advantage doing all this dance over the patch proposed at
> [1]?
>
> 	M.
>
> [1] https://lore.kernel.org/all/20261123182312.4842-1-maz@kernel.org/

[1] only catches TTL hints smaller than host PAGE_SIZE. It does not
catch a hint that is >= PAGE_SIZE but smaller than the mapped block,
such as a 4kB L3 hint on a 2MB block on a 4kB host.

I can rebase on top of [1] so it goes to stable on its own. Following
the same pattern, compute_tlb_inval_range() can check
mmu->guest_s2_mappings at addr for an entry larger than max_size and
clear it to 0 to use the maximum-extent fallback, dropping the extra
page-table walk and KVM_NV_GUEST_MAP_SZ check. Would that work for v3?
