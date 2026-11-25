Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611483;
	b=hayBwbfLTtuCoOeGEo6tlEg+l+IcejmVTRo5tYIlCxEEYwbUFTqvjSFagpmq+UiH9KSx
	 dRiIpbQAOwl2DJjB9S/Zrh0PUxHE4EVKFBAGGfyHBJIIc4CWyWDJsRKkXP9yWMY8ABCcQ
	 XfPq5NAcj51r3JdXNqAXqHbROBa6LUNGNgiW9YNhLD7KxwcjdjULlgXg7RGbMahwTChZq
	 jDCnqLAsXr+i+wkWOYIMudBA8arFHCa53bOg1kU5NevZ08Z7JMppQ/xxnlCh31Ru9IgUz
	 eqRnuLZMOuNzRK7h2xUoz/imqoIYXBx6kOS3WHVP5PmHyouYTO14Q0vPpfvlz12irsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611483;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=FOKGiPhLWzMZA6RUtm5hBEIHlhphW7VCRIG+uLWfOxs=;
	b=I1mYXo1GQhyuF5bpF1UDk/s/fr1qwoKZGJnuwK45zh11B3zaYG/BEaUrv0PM1yHKhfQd
	 fSVd7mTH+UqWdVinnn3jFWYYOW6H+7XcVPK37SdObzPvZpMjeQO6sR9mUOtE7vWukLWdA
	 A68LltmUlgNFRAa8iRP+khuLD3HPitIl+uo+Hp8Xts6rpnJkLGRiXJtrEj4dOCOql2U3d
	 0Acg25qTnQx3nZScVSN3THXpQi+dbWQBAwjCIEE6GlfjJYTIT2gDKtvV/4aqS/9sZFBD+
	 deiUTauav+HYdFIV52BLK3PkQywKbkFIzRnZT1nbIX7IW6HnW7bu6+BMmFz4j1G3EFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=HsXeaPU8;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7FF606A326
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 12:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD7FF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=HsXeaPU8
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so48862515e9.2
        for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 04:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795611481; x=1796216281; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FOKGiPhLWzMZA6RUtm5hBEIHlhphW7VCRIG+uLWfOxs=;
        b=HsXeaPU8Z0lAOtEkoozbrMhS+WDvdN7odg4AKVsLv7ioOIvbVbOD9qAeY+DiHkdTUA
         jYHYH/VnIXMCR1uozN0DzNG5do4GDG8TZoFY+CqdGBMEqVwtJqJ1u3qE37rxAhGzUwR/
         1MZWyUp20wDAai4J5ByWbmdSf4iDS4k6A6V0RtQQwuhaVXSKOw1SVe4a2T1/2boJulOD
         9tMUPqG4PZ2/jBoWZoGT11QuujrFCy57bjX/yvYKEJq9m4pgvK1xvgv5jR33Vp5JYyVf
         fmSGLor1ecBy42Rky4i5mEAzxV2hNBwjOBySaRh/moUjUGS32QYqI1h6xPzQ6NL7rAZK
         lI8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795611481; x=1796216281;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FOKGiPhLWzMZA6RUtm5hBEIHlhphW7VCRIG+uLWfOxs=;
        b=ue50vrH7tmH3ywf9Te3m1biiJpjIlPakVBvdcufFeSUEwIJTentFekk4c30DUw1LpP
         QDN63stwL4Khlk0VkdOj9a4uLOU2sBtuuJCuKsZ3qNjOy3kQR7iRuvnNctbiN9vlMMkf
         6NUUDQO8PdvdX6TXmFq9Luk/KGtZLQOQ7eSrB63fpjAjKf4tHZ06z0cPBuU2i/uJUZTS
         MvBrOfRB4eZX9A93rswxrDYCvC+S3i3MrKlwgq8OS/ohgHyEs29fSpaGsz3+ewt5R1E2
         lkcg09Wap3gwUdToW4zM9+k3lsEQ5dzdB67PDu15vuwSFwvxKo4znVd0IWldWoG9sBmn
         LQBw==
X-Gm-Message-State: APuU4Z9QzWsV86zUp9urV10g8i9dFFzCnTwVO9xu4prNmhXRe31L1cfQ
	xhIAtZNkd51yLvQWDEj64cL5CQ9B0wLxuarevbLG2nUsSoipBJqJLWmzPciziDAtOLo=
X-Gm-Gg: AZFdTZcCDx2tOvG9Mo2b1xIPq4XqqVR2JCVP8n8MB1H77LitOVea6rC8qSjv7zLw4SP
	Mi8lFaLdFFl87U82tIRzwBKcFtFRQnL+JfiQZv0umJTfOvhEU40sDg0Dpdm/+IUCJKXIt0cANvE
	8FvBwLPMok+gChZPjlhjnwEQBZvHTytxf48cowrsbnlvEhBVO2MLUYOvSLiNsvZsD8lWxf2b9PX
	P7GKovVss1M0MqTIZHrq5iTStu5MuiV+qo6kBk5Vn3st6trUhqtpIZYiteNfrIp3RGL3T0NvD4A
	/1Fouuyd0PBLgu5rVMJQYbiHOCW2ZXC5ah51ROX/P3gQUNIHnzmat3ksREMtvPdE6Sp9zN4bT5y
	kYVtWjWMO7GHf//i3z0ilsCCYRDFWPTx+NKljXid/L6lD7/KT0tlW7VQE77sd5zKRqABGUNxP4J
	rXe0Fpc39QDLsDeGbciysmWLxqDojXKya/32Kjgvw2OZ+BT0IgJEUKaBThpGjsc2pzg8sz2fMQF
	BJ1k307jvEpJ5y45eYzApJkcPmgRrov5xW+tvcxoGMZsUUAWZY601IvueiGOaB2foGGBOVZJaNf
	g0XHAWxCfBum96EP0Dc=
X-Received: by 2002:a05:600c:6290:b0:4a3:59c9:a743 with SMTP id 5b1f17b1804b1-4bb8882a21amr347767215e9.27.1795611480907;
        Wed, 25 Nov 2026 04:58:00 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm711211175e9.13.2026.11.25.04.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:58:00 -0800 (PST)
Date: Wed, 25 Nov 2026 15:57:57 +0300
From: Dan Carpenter <dan@pereq.eu>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Drop a pending MMIO access when injecting an
 unmasked SError
Message-ID: <awbbVSeRRxHjvFYx@stanley.mountain>
References: <20261125-serror-drop-mmio-v1-1-48076f59608c@pereq.eu>
 <sashiko-outbox-233383@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-233383@kernel.org>

On Wed, Nov 25, 2026 at 12:40:53PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [High] KVM: arm64: nv: sleep in atomic in kvm_pmu_nested_transition()
>   during KVM_RUN [1]
> --

Already discussed.  I'll send the patch for this later.

regards,
dan carpenter

