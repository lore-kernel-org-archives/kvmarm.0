Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2CD7B3D5
	for <kvmarm@lists.linux.dev>; Sat, 17 Feb 2024 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708180089; cv=none; b=UbRI6wcLD5Kqx3+7NnmCfag7g7LEcTfkGOMSgIxxjerUKJgZl9939LbpIvaZKEMUF4zO1XMnsnmAN/uMdQdZqV5e/9OBbZQBmufO41QI7lluxvbTQou6Vns+cFjFG+7PXAKIZMYNd2HH5Gyl6cpQyiTMpRF9jmYqKaZ7gL4uXQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708180089; c=relaxed/simple;
	bh=/eUefz1FkIPQ1G768Xwe5fQSk8ibXAAs1dbntOk1WHo=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=iKTLtpgHPlO8Nt5zTnV40umoZvmPEN3nUGBrbf1qE6czexqR0GAqGs9PV9SFhDB3LUX4I1RrQKbBsdcce/YpygB+lY/0ulFA7oszwwEiF+8j50L4JH5IOO59Elb3qmdI5w3newL7o3UTFzLInZ0Q5wuIyziHYthSsZUyh+bQfhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OdhqC0Jm; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OdhqC0Jm"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e09a890341so1709279b3a.3
        for <kvmarm@lists.linux.dev>; Sat, 17 Feb 2024 06:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708180087; x=1708784887; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+gk6WZ54fJiu1kZj993McRBYTJsNzCZTM/wPmv5yGs=;
        b=OdhqC0JmYjacusAZWs9UYrpxvgBJjS9V4E3bzASwiCYQs/a7kgiXTNsOy4zdlTP5MW
         sTpjXLPfXU6J5oM2C+MqqpJ9LOwRAoDSOTIkJTohQqfXi1MY/NAoa545DXGsDF/EGvqe
         5TsGJJ51UcM+29OoTjIwnBiT2qlfieW7dE58sr1gTylXvkM9DUTwmBJdNuT9uhNVQtaf
         2QNHViyzUuKunoTQW2WLvOp5eS3rGN1m5bCBjkCbPFcfU+oVZqVPsT7j9H+IY4p9IztV
         BOandAlprXcRVlEAGSMyxGa6nUbkCHe3qJYdHxkF1mbMN/WLgJIDM1JvBtmvuRppMBsm
         0ofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708180087; x=1708784887;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g+gk6WZ54fJiu1kZj993McRBYTJsNzCZTM/wPmv5yGs=;
        b=EpQCTJ2caHh0AdrP1H6/3xOuAHQSYXbhNZCJiFnU9M5iCRr5XQiwMWOzaqJdYWPf8p
         PUN07qJG3Xrf1Uc/zAzKwBbwWNCMb0Fl/O4UGyJo2xie0SbX6B8f0l0PQ7OkTNgy0DRF
         uxd9mcSC4DauNNth9hYKuZj7YVXVTODpbPwpNkAtGIql6q+vjqmvf0DzND4mFA+fFS5E
         o/rHENiXeNRgHutSYK5RzVTKkQOj78oQbGaWPlYhZiDXhNAesjkYEKT1QkUq1uuWMG/5
         yFK2EyRXQWqmAu31SWsjRLFhR6N3aM56AOeTnftbNv3iEO5p/WW9GEm6NXL/Wywtaufu
         8jFw==
X-Gm-Message-State: AOJu0YxZmbCKcHGSajaTQO1/owK0dLE+pVWejV21UaeOKXz9D66cDEIQ
	EWskEFUD5l0C1YeHQBe4FLyI7emBLNQ6L8ilIC9fU+wJMtwjSXIk
X-Google-Smtp-Source: AGHT+IFwe6pUDc/1M4pyvFmiJ+KMjxnvE6MnQ+K1nbKYGGj9eImdGKdJQNDRn3TdcgP6ofO6CwJq4g==
X-Received: by 2002:a05:6a20:6f88:b0:19e:a5c9:144e with SMTP id gv8-20020a056a206f8800b0019ea5c9144emr8219405pzb.59.1708180086675;
        Sat, 17 Feb 2024 06:28:06 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id t11-20020a62d14b000000b006e27558af8esm1441995pfl.76.2024.02.17.06.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 06:28:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Feb 2024 00:28:01 +1000
Message-Id: <CZ7FAVZ6J6DF.22SLKG0NAG6HL@wheely>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Alexandru Elisei" <alexandru.elisei@arm.com>,
 "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>
Cc: <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>

On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
> getchar() can currently only be called once on arm since the implementati=
on
> is a little bit too  na=C3=AFve: After the first character has arrived, t=
he
> data register never gets set to zero again. To properly check whether a
> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> or the "RX data ready" bit on the ns16550a UART instead.
>
> With this proper check in place, we can finally also get rid of the
> ugly assert(count < 16) statement here.
>

Thanks, this seems to work well. But arm64 still behaves strangely
with QEMU migration. It seems some odd corruption around __getchar,
but this turns out not to have anything to do with the MMIO read,
but it's just because the test case generally is spinning there
when a migration happens.

I modified __getchar() to the following, which removes the MMIO
entirely and just waits a number of times called before returning
a getchar, chosen to be enough time for QEMU migration to complete
on my system...

int __getchar(void)
{
        static int i;
        static volatile int locked;
        int ret =3D -1;

        assert(!locked);
        locked =3D 1;
        assert(locked);
        cpu_relax();
        assert(locked);

        i++;
        if (i >=3D 3000000) {
                i =3D 0;
                ret =3D 1;
        }

        assert(locked);
        locked =3D 0;
        assert(!locked);

        return ret;
}

I get asserts on the line right after cpu_relax() on arm64 after a
few migrations on migration selftest.

Without the cpu_relax() it takes longer to hit an assert and it's
usually the first one. I expect this is related to TCG translation
blocks and where it exits back to be migrated. Something is very
strange, I suspect it's QEMU migration bug.

Thanks,
Nick
