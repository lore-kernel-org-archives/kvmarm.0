Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6261F4160
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738857069; cv=none; b=im8Xn3bUKeX1cXcJ9EpoeVupkbmekLDLZLZQiDmpDIoL7nzp3RZFUSn+OXAKa5AE41WQqYXa7nwMcc+Pm74R1QWzCBwhShC0wbzrAhmT4GJiCCF8Nuw3+Ud9RFqidYoBb12Mf2GKsV20UXvRA3ofBFxX2c0XWCBcikp5T7O4FcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738857069; c=relaxed/simple;
	bh=QWoZ7J24SqGNnWzhgAOt78qtKw6volo/ygjmTz+Hx00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kZjyIoUN4nLbEM2m27RKG1P4v+4/grht5gtaR9HvBfwaoC6YLkBjBDAtg7I50HTPqx34JcrO1z+LP8ycyN6MqGXBJj891IpbvkHQzcC1o+H74uDQFdfEMkUCwiQ06DsDQbhxtulctDNgurp1iqhY3r7xgVi3Q7EWxrEdjqW+RuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F51Bp01R; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F51Bp01R"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6df83fd01cbso4952006d6.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Feb 2025 07:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738857063; x=1739461863; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QWoZ7J24SqGNnWzhgAOt78qtKw6volo/ygjmTz+Hx00=;
        b=F51Bp01R06f6h4bTHVxaS/qFUiCz7vvQlwAmlUxKjvE13GvhzXeTDXvawTLXG8lfiv
         2fjivIZnOQH+1lBO848yNh1RZcp8f2y/DXShTWNtwcEpPL7ZcGcf+QXtSq72vE+4B2Lc
         tJSZ0tOh6keor7u0opFRPTUwYadbXnm8pjcAMoJcT0x0gJplUin7AAy5dB5rIJv8I+BX
         IyzIIde5hEmyIbfh/i0YqEU605/zeMnWttMDgHN1vAes8W96qo42nZGWZknlwExkFMkb
         81kwaTG6KCsfxqX9PSp0tbQmU7KRmyZfHX2okmkLNhbZZrw/oD5R4u4i3EUPS0538Hoy
         fkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738857063; x=1739461863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QWoZ7J24SqGNnWzhgAOt78qtKw6volo/ygjmTz+Hx00=;
        b=KLFRSGgvYQxOZlm558enlR+F8AZvyS8Hh9cuPpHmbDoAUAwQomfpOhbw4Bgm8uHGnm
         X1eSlWyhmC96J0QDDBhQ7is9TMNhm5sUO7K05m+pmDaUAKXQvKlOc71l7bmABXkZdrxb
         Z+HMEXNlZQ9FIESufhRcIm6DePT/xG1vl6lKCfWR1T2dZiVKB3GEciyrHMnuhFnYEqYt
         Z82oByFIUC0FbaqI7ln52/b+WY6VgapNeUrwsMCJh86veGhOrt34TMfXz6m8nA3FBbaa
         5Xulcc/rZ6OnQuK0RonRzFetsx5iyc3oTI0BmdUln1F5jJD24zsAOyEWmxCpcNkzFUEe
         Tshw==
X-Gm-Message-State: AOJu0YxSOeRaJxXv/HN84ObdQFAM5aT3QT16KTDhKaBYHrBabmkVYwsS
	xZ34xXQ9LrxmMqWCYUoesS7DvkCku/S21BF9nvfPk/Cs5BvFy/IwievhnGTUbo5f6mNGAjC8bJe
	mSQes5qKTi1NwtNCuGeW0XLkkeUMRmN3X9wsf
X-Gm-Gg: ASbGnctp+zIBLKRny98r5EwcrRDKO/87YGbtUPMQyBRMcj1LFZd1m2y73Hs5ywpd2As
	5Sly8nVee6mw0G/TIW5xHIQH1X8H/ujT5HMVODX5GLwi9I7avp825cQyPGDiHHVRkvEje6vulWR
	1vlKHT0YjBeLwDD1N9r1+WAF1+ECE=
X-Google-Smtp-Source: AGHT+IFvk3+K1/NeNAHDQ1axJFgyu9yz47vrA6lu8lKIFboVQOfS99VlvomibC8PJu8UYjYziL7fvrE5epYqdVs4Qgc=
X-Received: by 2002:a05:6214:20c6:b0:6e1:6e74:7ad3 with SMTP id
 6a1803df08f44-6e42fc02175mr121361066d6.22.1738857063267; Thu, 06 Feb 2025
 07:51:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206152100.1107909-1-maz@kernel.org> <20250206152100.1107909-3-maz@kernel.org>
In-Reply-To: <20250206152100.1107909-3-maz@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 6 Feb 2025 16:50:26 +0100
X-Gm-Features: AWEUYZmPwfuXexC1RdrgqtrawDuVUJMO3ua_5KrkCM8FmA_6qe8hyqKXHCquBps
Message-ID: <CAG_fn=UFvUnFmPcvkX3vdOEtNjPgVzJZa7mgD-XXVhGDGD7aGg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: vgic: Check for unallocated PPI/SPI arrays
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 4:21=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Alexander's fuzzing has exhibited a large variety of races that
> all end-up with taking the address of a PPI or SPI structure while
> the vgic was torn down (because nuking it is only an ioctl() away,
> and syzkaller is amazing at finding holes).
>
> In order to preserve some sanity, always evaluate whether the array
> containing the PPI/SPI is allocated.
>
> Suggested-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
