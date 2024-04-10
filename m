Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D877E2
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 04:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723420; cv=none; b=fLC1nIaGIl6gQ822czpA4KFQgBBQKKuQYsu15osWtDEHuo11KRNDGz3f4jgdQk7pp+iLK29afM0TuVoe/CvLCBWx5jYYqVYhTecXH+FJFpkyGZ0O5x+IAt38HpN9lIA2ddPlADfIupQGHRuRAGpWAYS1VO+6Qwt3TqX7WOTSvZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723420; c=relaxed/simple;
	bh=0Z7assce/3I12gYPPiGPO4kSljCAX8pzDC5GmLlI8Qw=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=eAkmxE6TrmYvL0yCZN8qOVaYO6idWJ349Sg/Bq3XosQ/8HypFHmTQ7c9obZTyyk0jD8czvjMl+Ts40fvq/xf8tUpZGobsACsL6WicRs/FNan7TnLe+PslBja4QQY8lzoMQD+MiGXKxJpMDncvSN3oXclIw9q+Zhf0WFTJCejPG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PF/yO9sl; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PF/yO9sl"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e411e339b8so22588445ad.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 21:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712723418; x=1713328218; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Csxyj22wIzJdfuKfBsOG2KZ1/xHCIZLSCJ4TL2dEF78=;
        b=PF/yO9slus1ygJ5H5Lcn+WRo9VEgUsPMKULFp931i/326JWyW/mtv+37jZYbL1bytO
         tdhbLvjkJT4aHuZOObiji2NI+VMu+kqhW3rRfqKCkuZr+3C5kuqUyJdi7cptYsid6pAx
         SiWjCKh4CX8ZrZlolSvcKTY8sur9BLZqyIUn5k3lbmQH+T4wb7Si4bb2ICRDqD3JqMEu
         GNJ+X2MKBh3j+oCMOpLcUe/Me69Q5dE5W46nYd1vvwg7CByHgrdX0Ivb/GMDMAWhvJyC
         9/l2QJ67QilILYzoaLgxwr0XyLTCPKt+YSsm3w++pdXTA8YbFKIz57vQv7DKcRZ/1Zaj
         6wJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712723418; x=1713328218;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Csxyj22wIzJdfuKfBsOG2KZ1/xHCIZLSCJ4TL2dEF78=;
        b=OKbHYnIo8j+JoxPhzpJpCIPP6YCpNgXLUjjaCCLDH8NCOXkCW0hOQtGcYOaFfhPhWb
         CLqn/CiGaIRHfCoGKqF4GzZs9yqWXxfY/KplX/iXPpuFOlA8mHSoCNTAhUtYBEO/xVDk
         rLG3ot3nqZdAqO33f8pPloSH/pAtuALmgW3Vf3SiVL+nLjz1Vr9bq0eFO2LX1/yzRpXH
         w5WjYlNkZIqAIG0ranLOQ8QZCtRHekhd5lZ8AvEZcWZpYZeYslHGsKcCO0S7f6wcb/wy
         eEEl5m4JnTNKG9N5IEG6agn9VriPgDl/AzyhdpZEIxn6K9/q/bHAFKwOi0YaU+QkMKqE
         hOGg==
X-Forwarded-Encrypted: i=1; AJvYcCW+36R1bVSv9PxWIWb3ebenGSZ36al8HbqehoQ40Coz/enuKSbcr2KRi83LKveNAj6uyU+ipLEEP9aBXKXdeB/hLw7T6Jy1
X-Gm-Message-State: AOJu0YyJ+EbAXmHXvd80vr1IY4saFegaX9qtmjYOPjWbT63Dr8x1MpZy
	P4qh9iCD5Z5ht7nLTCez3a7S/xbhloekSwvdwe/RAwfZEI6XK9rV
X-Google-Smtp-Source: AGHT+IGdR4rPr8TUXSWQaLrOeaK8mYg5Q5R6NaSSX/xdgpewKjFBLWqlZ6z5OnIo3xmO1MqeuZvX9A==
X-Received: by 2002:a17:902:6503:b0:1e2:d4da:6c72 with SMTP id b3-20020a170902650300b001e2d4da6c72mr1669964plk.0.1712723418347;
        Tue, 09 Apr 2024 21:30:18 -0700 (PDT)
Received: from localhost ([1.146.50.27])
        by smtp.gmail.com with ESMTPSA id l10-20020a170903244a00b001e29833ada6sm9760884pls.140.2024.04.09.21.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 21:30:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Apr 2024 14:29:40 +1000
Message-Id: <D0G5RMOPNMCI.3HVFHWC8KQWBC@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "David Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller"
 <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan"
 <gshan@redhat.com>, "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean
 Christopherson" <seanjc@google.com>, <kvm@vger.kernel.org>,
 <kvmarm@lists.linux.dev>, <kvm-riscv@lists.infradead.org>,
 <linux-s390@vger.kernel.org>
Subject: Re: [RFC kvm-unit-tests PATCH v2 08/14] shellcheck: Fix SC2013
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240406123833.406488-1-npiggin@gmail.com>
 <20240406123833.406488-9-npiggin@gmail.com>
 <20240408-840ece34e7b407365a18227d@orel>
In-Reply-To: <20240408-840ece34e7b407365a18227d@orel>

On Mon Apr 8, 2024 at 5:34 PM AEST, Andrew Jones wrote:
> On Sat, Apr 06, 2024 at 10:38:17PM +1000, Nicholas Piggin wrote:
> >   SC2013 (info): To read lines rather than words, pipe/redirect to a
> >   'while read' loop.
> >=20
> > Not a bug.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  scripts/arch-run.bash | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index cd75405c8..45ec8f57d 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -487,7 +487,7 @@ env_file ()
> > =20
> >  	[ ! -f "$KVM_UNIT_TESTS_ENV_OLD" ] && return
> > =20
> > -	for line in $(grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=3D' "$K=
VM_UNIT_TESTS_ENV_OLD"); do
> > +	grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=3D' "$KVM_UNIT_TESTS_=
ENV_OLD" | while IFS=3D read -r line ; do
> >  		var=3D${line%%=3D*}
> >  		if ! grep -q "^$var=3D" $KVM_UNIT_TESTS_ENV; then
> >  			eval export "$line"
> > --=20
> > 2.43.0
> >
>
> I already gave an r-b on this one. Here it is again,
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Yeah I realised just after sending. Thank you.

Thanks,
Nick
