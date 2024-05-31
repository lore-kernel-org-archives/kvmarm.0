Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98128060E
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 06:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717137657; cv=none; b=G/Cb3NCQYbMKt/KH1r6lGL8HaA1kkRsvUa+0yuK4KG4WvMVQByMr35SmmU+Eh5pwfxtjYYfK/ZZkNwyJw8nW1QgXesySmM2pdF9abs662ovfeBZ+/mRuzhVC2LARHwhqJdadpP/4dXRq2bXecfsDA4UTqpElWcO4W334Kd/z5gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717137657; c=relaxed/simple;
	bh=5uQLCG0W2ZIBO0Q2r0bVx6IHkbXRIx08ZhE6hbnKwb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMYrb2kQd/eCBg1Vb7M4tmWaf3JWiABeBDZeGCUKrGzis8mCLPJGs4oUsn54UMzmanJFHpOV4j/YgcwGtkt/ZqN4A7nn1kDrx/OzCHKVHIt+z4vzOYUPKX7yijHqYiAzQ5IaUPbj2KHhTVpnrBBnzHflW0LRMcodsP6/n7dr8MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vjQEwU1r; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vjQEwU1r"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-80acf1bca86so421241241.3
        for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 23:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717137654; x=1717742454; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uQLCG0W2ZIBO0Q2r0bVx6IHkbXRIx08ZhE6hbnKwb0=;
        b=vjQEwU1r0gxWJzS6O2Pa/BOUXeDFakTZgnt4rFMEatPNMdj3SY8CGg2BDYlCuhXcNs
         ufVY4AKI4S0ausVsHY9oLEn4/4uz2MijzDhDz3de0TN1Pa01MEQWTDHqKQmEO112+r4Z
         13lXW9UoUEk7HVI1bOV+2jQ72kgy6HAR0SQhMaYPnvFBZJP/6cxS2GoC7c8b0fxJXfRZ
         NYP4SXm7XL+v08jjxYTmpd3Fy9BxnT+efXqwjqed4S1grTxGyuxuFwuWOEI2NB/McMOQ
         llapCyWKpqwsKx+rdAw+JdZgEK+RBCYqczDz18iTos3zIT8yq1O8Kg/RjpuM0an10Pw9
         n7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717137654; x=1717742454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5uQLCG0W2ZIBO0Q2r0bVx6IHkbXRIx08ZhE6hbnKwb0=;
        b=G0HjODdYigRbhPLhRprv5VYDw+nwpfJE4ND0UJW4ttoCH09zr23FF7uzSB2B6gWcIk
         s3C8JvjKdovguxltZ30nLH/X8srQzhb/cFzw0GLex/c/WODjAp91AZ1JpZ7ZtSDuW4oy
         IJOfQkcH8qgooxTp71lpBbsOGO7UM+Jdrttyl2MxjXsM3ZlWgWMIoG5W4dhp3Kb3QTpf
         Qd9EFj/+/YUv84LIIHwKPzFiUhOWY56lBOeqxGBBQwKKqF016BwBrGjh6FTSghFwOXSp
         sZ44wxdSspJ+xzB7epSWTRMJ1FwwWYoGsnZaqjNDnZbZ+KaTB9PiFQwBxaoxmi/P+cWx
         /iBw==
X-Gm-Message-State: AOJu0YyEVpNKmse1a7iLnSMV5yKQMqqcOwOwk5bEIGdMvNsPBJsBF9TP
	u23p1tOqu57nQrHEz34P1nu8XvJmwwiJyX9d3/UhDBmaT3RiIc+NokzBVuyugG0EorkOAVSia9J
	u08MOlISlChnL7s3xEWVty6OdRJn3PHjgBob8
X-Google-Smtp-Source: AGHT+IGFE//Gt8iJAeN/IhQtX4I5PYkSd6XBWVjUZFr6PC7XskUhD3vsfXxjatZ0833jW19IOC86tTVyaeDqmUTLs6Y=
X-Received: by 2002:a05:6102:5d9:b0:48a:3332:594a with SMTP id
 ada2fe7eead31-48bc22d98ffmr983220137.27.1717137654568; Thu, 30 May 2024
 23:40:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com> <20240528125914.277057-12-tabba@google.com>
 <ZljD8pu5Z5ujHny2@linux.dev>
In-Reply-To: <ZljD8pu5Z5ujHny2@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 31 May 2024 07:40:17 +0100
Message-ID: <CA+EHjTxMXxpWKpgNJmbQQe++zEFtpJ0c7FQCLdrQzPaEYAzUbw@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] KVM: arm64: Drop sve_cond_update_zcr_vq_*
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, 
	broonie@kernel.org, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Thu, May 30, 2024 at 7:22=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi,
>
> On Tue, May 28, 2024 at 01:59:14PM +0100, Fuad Tabba wrote:
> > The conditional update likely doesn't help performance, but makes
> > the code a bit more difficult to read. Remove these macros and
> > just write directly to ZCR.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > This patch is meant as an RFC, and undoes the previous patch.
> > Please feel free to accept/drop whichever patches you think make
> > sense.
>
> The motivation behind this helper is to avoid unnecessary synchronizing
> behavior, since as you note the architecture does not require
> explicit synchronization for the value to become visible to subsequent
> instructions.
>
> Now, that doesn't _necessarily_ imply full blown context synchronization,
> but it isn't too far fetched to think a conservative implementation does
> exactly that upon ZCR write.

Thanks for the explanation and for the reviews!
/fuad

> --
> Thanks,
> Oliver
