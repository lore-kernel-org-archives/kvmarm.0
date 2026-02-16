Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDE81D95A3
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771248733; cv=pass; b=D0NOE5nM0jUdE3J2OzYqL5DO/57Hfip+du6IN0pBd8hp2Zc9B47RC5qSWh2jJ+VnIFqIiei4zBdztwcPpHFMf1Uy0yTRHk/EFWWZvR7uDMz5tUDug2ycqtaH7ojEkTnkKWNv4BF0bQMuYKHN3WlEny3LttNBaFXNZYURdCUHHh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771248733; c=relaxed/simple;
	bh=LmGbuBMM9mMPZgC9VCrTZN3o5Iw2RZSVYw2EZg7byTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aV8kdNLjO7D+yC7GsjGywhEttiS4KjL7nI+ZdNWFr1qmDUM4+zbcYNxeAUZpjRRhfY9/dDbsYUdfQ9je99jbQCN84zLKOnqoS/JMaqdcU9TvIUbHHshE+Pu4l+AL70OFe6+nUhtRxXqtckQrtQhJBlQ/Dd8jEjPLyKffTcHRFko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ti7LECkz; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ti7LECkz"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64ad79df972so2769929d50.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 05:32:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771248732; cv=none;
        d=google.com; s=arc-20240605;
        b=KpQBxzmxCQ6cFxnsaZiGUyEbVN1VI4EgxWqATLkxE3cOWZbJNDylLB/V/IQrJR8Isz
         ahWquxMZVVnCxBJoCoCzZ5lP5KI1WwzE/kDxRJjWo+Ce5TYvtTMXedg5DQahmhOTrI0o
         n84fCHuwcyDd48DPeGz91kQ4SNX/vG+e8BgG3Yo3qjKyV76K0q8Ik0P2Dw57jBd96XCU
         62N6FAgy9tVwQjSIBO0IDx4tUEo+84yiNbXpy4i8GjYsck49baifot/RDzfzWS6ZoilZ
         5Bt77LdSFDIVdF6+IQSG2VTL/meJD5UA0V3R5WooSSeNSiuABl0nTeDUUgicoxl1l27y
         ZmHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LmGbuBMM9mMPZgC9VCrTZN3o5Iw2RZSVYw2EZg7byTw=;
        fh=x34Ay3VqKUrJOScb+aBeuNhD2CVsjCO9pJEzsX9Avxw=;
        b=hRP8mo3r2j7G8mu6pNyBcK28Im2kqo70Rep2aTdkoCsSe0gIdTv6zKUXOEd5Broi72
         lu9axOcTwv/Uppk3zUX030HFKgIXLRKArJN+eYX11DtB6LEE2CZfxRyxOKyBOaD67YEd
         0Z3iAXes1rcZrFYum3b+1jJS3mVL06BFJiKBYqWOymjkYPjISpyCQziwHVTTwYyt56ve
         osTx7UBnmvpkMVdxUAZjh/8FvPJ1siEFE2uHPnu1Dw6BLrnFPZmY7PMsgDEc8E5pbz1B
         ho+3lDNc93vxwAXGZp+IcDDDfXcg3XolX4o/tL1TSwENIYnlXJNgPqFC/BaXHuem0NzO
         PK4w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771248732; x=1771853532; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LmGbuBMM9mMPZgC9VCrTZN3o5Iw2RZSVYw2EZg7byTw=;
        b=Ti7LECkzBuSEuvs7avh4nU672tq2G+Y29+QdNiXY21swcRUEJoLG0adTKbLfVjhFAi
         YBBIiI61+x5gzYBRZlOLUYq2Zh9pqDxQKBE2AuKX0rnHTkcC7p124ZTahSq36cgcdF1q
         uHxBzJ55DukKQrSlKHejlZBtC8HK1IJRRwMYWyruSuHc3bCFz3QRwBwR3RjL++uKQGjR
         AYQkyp8pSMeMcJij6Hv3kyXK/sQTbQgsZUdRfUeh1rEaiJk4CCAgg/vTkL2ILKizoTRA
         11pcCgstalI3SvSq4kFA9qpD1GdJv567rySmanN7jIZ+Gh/+nKUxsAo1ExCo3jYdwzhX
         UGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771248732; x=1771853532;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmGbuBMM9mMPZgC9VCrTZN3o5Iw2RZSVYw2EZg7byTw=;
        b=Dd6X9TJbaINRGPnn8eMRUed5zMfcd/MIJiHWrTxJn0awctOxuyhaMYM4OcfZ0/CHcZ
         h22xlXYyzcgXrT0gUcXjz89FfhR5TiyHQGV5YrMwyIYZLnXpMA75/ewjt/FOMm8T3eSf
         6U39HvhlLAfzr6q/PN3qK+sQ8YVCeeLhdene2DSymPO5sIxb0jkujsBKGVgizkqU37x8
         gRrBfmusCDh60av4Jz15iklQW+Jk14ruwy4y6KTt/rT9xh2n61TjcoWNBW+IG6XNk01o
         pxYB6VvPCW47JWFFOLLg7p7hc9OZhtPX6pViLjs+HlInVdEhLOWOxK5m3LKYze54idWh
         PKjQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2WVpPohuteFdN8DwLnL4dCxuzq63HCHaaBoFYxnUWMYylUKBiwswjsIJO0z7VAXZVEdl5cRU=@lists.linux.dev
X-Gm-Message-State: AOJu0YySvbHZZGBibLjcyQ/x9zUoQ+mrrriVxGGc9wJ58jt1HpM9L0Ak
	T7hxUqLe/b0RkPRl+ZvbrPycA1nSrxwTY9UnkUHO8/HepCG7gq6n/dqBJZQBYepNplbtNznAy/t
	8iYpLRYrs6p7Qxxu5hnObxTQolOG+dlK62BqJrKLbTg==
X-Gm-Gg: AZuq6aI2+Jy/kxOsaOl2nxeglqu8qhQltwN4cKaxbX2nPxdayiOXyCiR/27fy3QY2W3
	ZekNSE54NKUwXxNQqCs4nOM9Hl9+pbAV7d1mZuHHg7Jplc7BRFChfhR4pa53AEJRpMFq/S+mwE2
	vXuO3mW4ovuB71MzG7k+JCm5ED4lWYZaPLh+QE/U6WP8g4rq9uFKzjPmUlOtsZtWf4jWcEmrDOa
	rhBJBFB7hkn9m8b+v7yzux53QNG0VMWkLhTZt/fRqzL+Oy0cNpWo7TmE0JwDqXsbduPcU4hbnUi
	OvdZadwm/QRS2sMz7U845m2grQT34SKoj1rOxd/fB04KukIAcoYp48azACrhZT1nJdw=
X-Received: by 2002:a05:690e:118e:b0:649:6a9b:9902 with SMTP id
 956f58d0204a3-64c21b5b3c2mr5216445d50.65.1771248731837; Mon, 16 Feb 2026
 05:32:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260211153032.19327-1-sebott@redhat.com>
In-Reply-To: <20260211153032.19327-1-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 16 Feb 2026 13:31:59 +0000
X-Gm-Features: AZwV_Qik7Hb9tvNVxNdB7PyGF3aH47GzKSPZsyoH50sfvOzAKc1pDMKbuGM6PI0
Message-ID: <CAFEAcA--EaA9sGFXRdit0uV-H18u2zpuCAXa-ZczEN66TTWoFg@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Feb 2026 at 15:30, Sebastian Ott <sebott@redhat.com> wrote:
>
> This series adds a vcpu knob to request a specific PSCI version
> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>
> The use case for this is to support migration between host kernels
> that differ in their default (a.k.a. most recent) PSCI version.
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> Alternatively we could limit support to versions >=0.2 .

Patch 1 already upstream; for patch 2 the review discussion
has been on the thread for the v4 version of patch.

thanks
-- PMM
