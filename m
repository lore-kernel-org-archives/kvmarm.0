Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948230;
	b=FdbyjDrg9PDZL20loPFRW3KXQOhzrnWDcz4wjxt+s/PkcJ1z9mFmjB0arUfOgnoDnKIA
	 /gObhz/2iWHpbD4kStshFQk8n5DISxYvqx92ngEKWLAVELS+Mb4xIiAFUkBExZuDdptWP
	 ky0Z8IItJ1OtI3K0N0uoViiCJJuYA3YQawrKIpP1ahxPXPOm4TOc6thBuMtLUxuf8cGyD
	 vfgoHY2ExQ/PUotMkU8+Ac5/3QgHHRYvhBR8yzE3cAQSizah3K8LocUiEszcbsMsRrqth
	 a45b7nM3pAmwE1KT6sFGs7uFNGXIQNNfCUQVzmUhc3zZx4xk9MVkEXLCK2mGi3CDFiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948230;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=7+VP2e4/Jx1gpeLV32IskoHLYhFefIx3VrQoyhcc2vQ=;
	b=Fj5TixLEM8o65gq7pkfl257G0NyrWgcpu8c/mpUlUVo4HFBbH+sXOX/3XOONi7eZoAb6
	 Hxu/Hbk4y59IBxM+ttXMuTubF+GfnNXnDCLh2UdQpLnxe3zN/eX+yW1Pu1LNB0jkWpNN5
	 EvzZ+YKuEZDS5YAEo1CjO89au3wNCZNOMKt3HKpVYwNlTUKD3ObZjBnPZDaeXaR8llPUR
	 7TWj2YZAoswql4EkQeKf6PSe0MRixwUCr6jzFYmETp7h8K2lZYrutE9aMqaqHmNHiWRkd
	 ofHYLblhn9Qd4IUVnjXUsgsmBZ1jLUj9HTjEb9NIC283sA28rnqM8LiiSf52HZJNw8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WXWwvJHI;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3AE606A332
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 20:43:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A3AE606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WXWwvJHI
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b37620eb73so207301b6e.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 12:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794948229; x=1795553029; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7+VP2e4/Jx1gpeLV32IskoHLYhFefIx3VrQoyhcc2vQ=;
        b=WXWwvJHIeVIHp52WIRBldyz9pVEY5Lt22LMbzHXYYQDA6hNqnNEBnRgm3n7XiTgVcd
         IOoLXRtdL3iSofDjD/VggvwyEOb755Kf0hDVL5dxFf1CIccUjN3zNI8ZPYDmh9OKQtV9
         4OxEgWAcybtUbSIxDMTqiZHZbufaG5X+XrmNCN2vvSZGo4PU6P8bu55z8ONA6HFqflVa
         CBeFyLkNfCoFVLio1+webVCvae/lN+3ZxCuZqhwk5O+ltXftlZ7kqQokolRFuZGU6uC7
         wIuu94wY0AnLB4q5DJswJyVWP+GRpwCDtxGe5yfeQecmRpimDTQRHd3r0mzWGd1sZxIg
         g/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794948229; x=1795553029;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7+VP2e4/Jx1gpeLV32IskoHLYhFefIx3VrQoyhcc2vQ=;
        b=J++HxcB1XrV1Clo2J2WPr/TPSO2c8ShItv08WixBKLlcAaNXzmFGeyqiJfnJGM/+b+
         DklpIt7WSDrs3hZbTCQtYdBreo0ANmCbKQkwPv8MpeQ636bkZ4KTbPDGaBHaf6+di5gT
         KgTEtAbdViGyddOcSbxtew0gHz7F31nDYuuCdclyScRaesZ81NQRGOhtAcsa9AcyT7oT
         UnRr1xRhq5dIbMA9KTm0LZ3ASl7XkTnGS81gCYkoyvqMYqDABr2HKROFM7VRjUya9rCu
         iKBjOERla7hlbFsJo38skfCJPUX49ebkr25/dIL+ae5YjH3t9zMsS5hz5Zm0X4MT1M3o
         nTyg==
X-Forwarded-Encrypted: i=1; AL+hErFg0zkUoiTjSaUhd6iLlBsdqYdzTTfKJyk8Ww4e8F+9ydb8NOVX58pqtWnT2xr5tfG4KhADYw8=@lists.linux.dev
X-Gm-Message-State: APuU4Z9mLVvcaRuqVRfo9/6r51df5Kq9NaYhmY/JvnNjaw6v20rLk+u6
	v8qEroDl1X4etAUF+aR4EtoOyYzSrKNtN+RrLxeLDwjF9e5d323rzYF2ECtuBQ9aPnsRJPTFRA4
	GFUFc2p8ddxDwUEFaIV+VJ8Kplw==
X-Received: from jabha52.prod.google.com ([2002:a05:6638:6bb4:b0:620:1989:fc1c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2384:b0:572:72d4:9ac9 with SMTP id 5614622812f47-577424093eamr890686b6e.27.1794948229188;
 Tue, 17 Nov 2026 12:43:49 -0800 (PST)
Date: Tue, 17 Nov 2026 20:42:44 +0000
In-Reply-To: <86fqwz1udi.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261116200418.3535619-1-coltonlewis@google.com>
 <20261116200418.3535619-3-coltonlewis@google.com> <86fqwz1udi.wl-maz@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261117204348.4020440-1-coltonlewis@google.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0
 when E2H0 is NI_NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Colton Lewis <coltonlewis@google.com>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Marc Zyngier <maz@kernel.org> writes:

> I think this is the only reliable test you can implement.

Thanks, I dropped the guest-side HCR_EL2 check and kept only the
KVM_SET_ONE_REG/KVM_GET_ONE_REG test in v2.

-- Colton
