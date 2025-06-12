Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2F724A07A
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749740665; cv=none; b=RH0YHM22Nq99HUz4fEWzM17YXa25x1nTV9OmlCseNvwCjdSOORhLyWe/ezI+DmiwgnFKbUotkS3VnRc8ZowCXXy0ld4ave3Ixr8ltH0xO6y5RWTd3w2eOnyj3x+ywD2B+IKbzuwXx5asdlsis0L75nyrbXyJ6wS0L/C9P13CY50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749740665; c=relaxed/simple;
	bh=6ox6qol7qTgR/EJWov483eQuOYpxLV5X1nNbmR8zEuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XyJQn9e1KcuEvzbaFTBuLkL1dJE5wcFQYo/43rskTpHZp5FxUSBrDZi16jwwQvjd+hSLeZ+S/nxXFuyTr8cp1WMpbcYWHXGzprC+Swp2UPQAt9HQ7KXdvfi0quAS4KuvUcBnLDFwflHthIAMnWMvmX0+TO+jsMT9aflKSAbEAOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RqhIMR8A; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RqhIMR8A"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-70e77831d68so10119597b3.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 08:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749740662; x=1750345462; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mwRohgyatrsnok8RQFXYdLlHld9AUTUpziIQUj48/Fk=;
        b=RqhIMR8ABmjG5tiG7Rf2JSPDv1V1yJ37QOU51ug1AwyZsyQVlqLlKXtHnf+WK0x+ad
         gcPZbu+8WzUN2z8wizuolIkJ1SEyPW62mzXQZZCnOroZiK/DbBDyx5yyK9t4kv9wDI/C
         X6oOIa8wml5BSy5YFr2+Ty3QTKYA1Lh3PwIzbrHNeWV942R0tw6YlWgJ5VUQvnL7C+sx
         SEJZrvo0k5RnPJAvnuuaJeLkPp8RDTxmnVaFVutphfUZW36WgA+5S3BNG9wFDLqQrSZS
         phM8PRuSm28rFTv2ETCcUM6Wp8WNvwvbNV2AbMZ/ghbireoq16qSHED8SsUkeOVW8W7u
         Mo7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749740662; x=1750345462;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mwRohgyatrsnok8RQFXYdLlHld9AUTUpziIQUj48/Fk=;
        b=XULKS5uKrouseKqRrEpIMB88W/TPHrZdbjt9ZYHB2fuPyV31fG/TSTIptsQZYd7+aA
         hBBZ0b/x0eHliTYRwgNep1XGZGhapZBr85xZqQQuqsBiUmkfavuq+DxDG0pbI6EsYsEy
         i2kNhlcROWmE+W3EmP+A8uYfTg3GPpvyjLN5cGhoiHBVrqXMRX0AtgNdZO8Mi0sQ+MNQ
         EIg6E+iYDKwXCmRy/OWU8gK/BNfgbD9GNktWFp5wiCHfcRKqusOIYgWBFtfHlu4mvJl7
         +DZdWoFszHkniSv0MIOAVhbgASbXKgzBKZ44k/FT+TgMQDok7EqzPpjqh2LSTeXZOf7H
         klZw==
X-Forwarded-Encrypted: i=1; AJvYcCU9uXg5Q1rooff8RbTa3Nly/OUsiZoT9cfYNb2xnMm8naHRuYcJCkY8eErUgnozR1GXlhWZltU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTBg8F+tpa2p/1qSPikZ3XVZOEDoT/CEuNCtLXy8xHavve7iQW
	0/E26zEA2wgQXp8r+UaE5ojd3F6P8Oso6SfmbnbXyObL8hhL6/9UgGV/jLjV4L6IYKtksRaQvwr
	TOi3EmwQ1SwgL4vZDX4s0Z99eFncJIQoR21zA/bhDkg==
X-Gm-Gg: ASbGncshdGZ3XyhLRiSBa6cFpg54AhNDQ2eBVqathhXJGCk6H375MN2rCSznCzfG1d5
	t2jDEqHIrYRDvymhDsFPqn2ESkokk5O0kCNM4oNgWduWSJPLMx0Khh//hGICmDQX27dgKzQNuV3
	ikFTSNKXVMKPWT5eEP4+fQvKE0zKgPn46aorOobZ9gI19r
X-Google-Smtp-Source: AGHT+IGkwf3AJrycbkaLsXCktxf09YCtxZ4zQIpiVu3XRTDHJMzFJzu0b0P9/VzPi89aVoUmCtZ/VVXUpqdEnylPPMc=
X-Received: by 2002:a05:690c:498d:b0:710:f46d:cee0 with SMTP id
 00721157ae682-7114edcb04fmr56567777b3.33.1749740662363; Thu, 12 Jun 2025
 08:04:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250515153907.151174-1-cohuck@redhat.com> <20250515153907.151174-3-cohuck@redhat.com>
In-Reply-To: <20250515153907.151174-3-cohuck@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Jun 2025 16:04:09 +0100
X-Gm-Features: AX0GCFtWVVUEsGciOpuhQYdpTNAk5ugyqKk3hjsV_bBetoONUXe_HXNhehSuotE
Message-ID: <CAFEAcA8y_wwZPoqkyPrNscRNTEwiOQm5Or9C=aiSNMGcZmq8CQ@mail.gmail.com>
Subject: Re: [PATCH v7 02/14] arm/cpu: Store aa64isar0/aa64zfr0 into the
 idregs arrays
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 May 2025 at 16:39, Cornelia Huck <cohuck@redhat.com> wrote:
>
> From: Eric Auger <eric.auger@redhat.com>
>
> Also add kvm accessors for storing host features into idregs.
>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>


>      if (!cpu->has_neon && !cpu->has_vfp) {
> -        uint64_t t;
> +        unit64_t t;

This doesn't compile :-)

-- PMM
