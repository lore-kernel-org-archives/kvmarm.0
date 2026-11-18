Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034123;
	b=RljWjwkNZHblFBi1ccwi/wzsUdlo9yb8QNV+x9UUNt0D0iAv9rBlYihVixamen1Y89kU
	 j3c3zXeua9M+q+unNYH+Xo4Ac1Pa/3rbl7cZJhhWidoK5DDEbWxADn2RSi3xDJLygcdHm
	 aFlnfqPDyF2NHwUIa5PDt2APl+cLr6+RBs72wzayyA5t1ug/1lIjaxeBGT3Z4NjzmQAz4
	 EH5lFp5uqCVbwZUv0G9e6O8uQNtgr+i3lM7JmYdcr9KQj5EevnLUJEzIUCi8vpiEr51q2
	 OHO658y/1GdVm6ZS5qDAdudIq7rtZa7AEciQsKihfDMYetQRP+xwygtCv2LDOyjpJcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034123;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=U1/r8Tac5IXDtWrYYG3dpfT9UXio9UGAzrSbVmuM17k=;
	b=YdVUmGl3BKInUqPg8B45OUaRI6PrWIDwRL1BTrF3U4wj3yeh145J8MseWLsblr+Bid5Y
	 EWNko8tSTX7knaTsBhXve9ToR3JtbpT3w4z7e4962mlRcjv+FzqSVyuRKoET3MG8Rvh0/
	 bG4M+WW19FsgW6X4shKYzjjsg6uNaTHPf5wvf8dc7qnxIcr1O6jmCZh8B5hg9JwEyqqGC
	 QMVO6gQ72y7pByd06xmCb5RCsfz+lIn4Lrs5Pza0ZGOXCDaSjPrm3Qkn+f/qq2PhXFX+u
	 9+1LXWvpewbDnPiWOaX9m+UI8TsiyIhEo4bSuksSiD/oPWp3SQtdvhCbqt58GqQJziA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=E5QEj6f3;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614B7606A32F
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 20:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 614B7606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=E5QEj6f3
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-5587351d419so1077096b6e.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 12:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795034122; x=1795638922; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U1/r8Tac5IXDtWrYYG3dpfT9UXio9UGAzrSbVmuM17k=;
        b=E5QEj6f38lc29N8/9CD3iqfYGfwCnyFtdVIr2gZRyGG61qeNW/PUNgAVf8RI3J8VvN
         YvrXzPbgIA7UYf9mfYnpvkPCfa5Xcsv8PxejSB2L+vxftVFgsT1NT/v6lbh1RkJ5Zr3B
         TAYEMozMcDbIwZVHV8pDae7tBEUdVrW+hSVF45A1KRxe0L+5PLbjHkB70cbZAJZ5Pfeu
         u75XDD1PXy0/4AxHKMY5Y5TLKn5qb8rJOkP5Z1ANovrVjSyFsL0Hzgwmr9tCmRlpO/s9
         dxqWB4AliGxuv4e5XY4h14MATGDOnY74TGufXojRlQTTOjZ+qP5FVtrX36/AJB6c2IT+
         gx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795034122; x=1795638922;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1/r8Tac5IXDtWrYYG3dpfT9UXio9UGAzrSbVmuM17k=;
        b=ALoxz9PEjRq8il3+8hYBAz1++5zFhC2F1hgouLHV0C0h53DEREwjGQREmSYl6GsyLz
         2iNKTQBXEcmNMbKnGPGpjag/UZJULrdQwF1hV62PMITDjhX5/8jtyqTP6Ga+GJvwKSVI
         xaLg7lW0ysllNdcDzTpq4wPE7kYX8ycWZdEXC1GiHqO2tw5o4Ki3YMIO1QhJSS9bVLL6
         jR5NPqx4xJS1SbZPLnjQvKQ9Qc6rZWVGEE3Sj/XtsGEJCYBkyow5NUbZQd9bZcL772DT
         MhVvlXY8MfKpDpQduFa2rmakjhM7aAg9l2PMn3Onu8TuGeWE6B3/EqrGIJYdhOc56yZr
         reAA==
X-Forwarded-Encrypted: i=1; AL+hErEEdA8Ir5+EYLx114Cbj3NsshajJEHb3m+MkAl7XPHpkoqIHuz1o4Yvo26McVoMWU6GrfXJDe4=@lists.linux.dev
X-Gm-Message-State: APuU4Z+/FeKM6VZIToLfl1O2+SDldEiDF/mOPhiUaI3A71WLYd3KDTdi
	UOUJBaejj4sPnryemljN2QMlsYc504y2dWqSAHc/5Apnv1L/TuM1iSifY/Htp+ExuDaUsjolFuh
	Y1W8ilFGL58ouL32sa4QgGHxAiw==
X-Received: from jacnj16-n1.prod.google.com ([2002:a05:6639:290:10b0:61c:b6b7:f372])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:5088:b0:567:cbf5:bb95 with SMTP id 5614622812f47-5773db242camr4395212b6e.7.1795034122012;
 Wed, 18 Nov 2026 12:35:22 -0800 (PST)
Date: Wed, 18 Nov 2026 20:35:21 +0000
In-Reply-To: <86a4n61m7s.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117204535.4036191-1-coltonlewis@google.com>
 <20261117204535.4036191-2-coltonlewis@google.com> <avzZUyu9EhxAWtbd@kernel.org>
 <86a4n61m7s.wl-maz@kernel.org>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118203521.740501-1-coltonlewis@google.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Colton Lewis <coltonlewis@google.com>, Leonardo Bras <leo.bras@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Marc Zyngier <maz@kernel.org> writes:

> I really wonder why I bothered describing this, introducing a bug in
> the process. There is no known universe where we can deal with NV1 not
> being RES0, and this helper is purely academic (and therefore wrong).
>
> My personal take on this particular problem is as follows.
>
> -	NEEDS_FEAT(HCR_EL2_NV1, feat_nv2_e2h0_ni), /* Missing from JSON */
> +	NEEDS_FEAT_FLAG(HCR_EL2_NV1, FORCE_RESx), /* Missing from JSON, RES0 as an IMPDEF choice */

Makes sense. KVM never exposes a configuration where HCR_EL2.NV1 can be
non-RES0 anyway (either E2H0=NI_NV1 with VHE, where E2H0 is not
userspace-writable, or E2H0=IMP without FEAT_VHE/FEAT_NV).

I will adopt your simplification in v3 (with Suggested-by) and drop the
helper entirely, which also eliminates the confusing NI feature check
Oliver flagged.

-- Colton
