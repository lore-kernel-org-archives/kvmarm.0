Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF5733CA
	for <kvmarm@lists.linux.dev>; Sat, 17 Feb 2024 07:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708154405; cv=none; b=jwsMTn/ExZE8+7oTFkfUhzij7YGoAMLav1Wn/NVpjdglsM9FgG9SvcwEm5BGVROw89SEDl+yNzsvLjjTF625SnYkNxNiunoNfFOYAWPGpPHbiZkqaLHA0lqDvR5VuUbDHOBhfdO98Uix7GjqyQBlSPE+ytswTMdwfJDAj+UwXRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708154405; c=relaxed/simple;
	bh=0r/mcDX9INprGCcwU6dSv7nrT7Y62HTCBakDChmI/xs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=oTGblXX3spPFds3eEJm/Dw5krR4YCC2TKUgQZcH5Tr2TGozJI/V0g02QO2HSiIn1qruDuA13zTBVk27MQoLeah7cBL7emZLiCmkw5A0nNn6nozXD+ivHJGf7KUGUazuRlNJgcSeO5hdRjDwBnKnpPpwhUjb2kgO0QSiaUd1m4dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NXRNgPNO; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NXRNgPNO"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5d8b887bb0cso2293187a12.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 23:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708154403; x=1708759203; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfIxsLt7/ArIHKSH0XLbtdtiRdY5BKjg0yAd6fCtPMY=;
        b=NXRNgPNOHLfe7yg0YQXv3GsiVaLNQezejcGOA2/lA5EDsLd9skEHMxg8mRo0pRU4ct
         C062eOwFjcjBUAFASU0BiSO8LOGGUo2qyMMJ+zD7D1ZP0tL0mUcO5WfdLqJHjebxaZ1I
         6LTPCXqmTMuQZ37aNLI7lZcWDb9Tbr+guNKZljSEm0WFQmT83k/PXBzG5XF6fkCHrYIx
         eoZeX//RJpEKvcKwjrM2P1bjQ4eSh0YRKvSfawYhynxhkjzAZjVCc27VBdkVQvDlJOVs
         6XxRS1RCor2yhXzkWXHjeOJ2GFL7P8Ts+Ftd4eFXGQQT+ss8N79ua1wcTGM+PvjZQV1t
         83qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708154403; x=1708759203;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WfIxsLt7/ArIHKSH0XLbtdtiRdY5BKjg0yAd6fCtPMY=;
        b=NevH3RT/9W8+3wRRRHRp++GoavQEqSOQEW5JTWXhODoopAyZOavzEIrTgiMIudpQXp
         AdSgaTh09UOBEf78mjwbyyz70e6M8M5oASM+4wpQp7PQdsmF0U5AMjxEmzYHpyOyIRl7
         F7mpT5l8yGqxvZsQx/uFj7AmjG707cScmpidKknJ9aouCJph9O9VYPDLeYAZYOdzH988
         ShKCQjPh+S8t+gLDcP0xJB4mIRxUl5D4MsQKOgCF2SqpljMNCeUZoyWj9soCfUYrR622
         otqPbOxbCszdjrq518iMphNj6ytK2MOUpskY1VfE7HWnwu2xN2t35rdE3BZMO9HKnx/Q
         jN0g==
X-Forwarded-Encrypted: i=1; AJvYcCUTaFxPsvXaEq8GeHZ3bMfQItcy5ql/WPEVlpDp3CQGik61Nk4QEF6BhFgTM61AC+pJsRrXFYmH7Q/WG7xjjchH7qfw8RtT
X-Gm-Message-State: AOJu0YyIXf9ZViYT9AoAKajdLUwKZpOVABcKOYTeavl1uXsqFOmnrwyE
	cC1o2mutGMQ1wWwjow7kToMUhqpMTAxvUHbEq0+vzIhivURixtdZ
X-Google-Smtp-Source: AGHT+IHeuo0k9fAN0txniwLyphYby2uu9UX6Hw/WFiRGnP8mxfVbUdCFutgfkGyqtdVbG1X9PA0DNg==
X-Received: by 2002:a17:902:dad1:b0:1db:4df0:a31f with SMTP id q17-20020a170902dad100b001db4df0a31fmr8038401plx.6.1708154403370;
        Fri, 16 Feb 2024 23:20:03 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id w3-20020a170903310300b001db4f25b168sm868865plc.255.2024.02.16.23.19.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 23:20:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Feb 2024 17:19:54 +1000
Message-Id: <CZ7673PUQ853.DB10GSBEZ65Z@wheely>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>
Subject: Re: [kvm-unit-tests PATCH v4 8/8] migration: add a migration
 selftest
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240209091134.600228-1-npiggin@gmail.com>
 <20240209091134.600228-9-npiggin@gmail.com>
 <abbcbb47-1ae7-4793-a918-dede8dcaf07f@redhat.com>
In-Reply-To: <abbcbb47-1ae7-4793-a918-dede8dcaf07f@redhat.com>

On Fri Feb 16, 2024 at 9:15 PM AEST, Thomas Huth wrote:
> On 09/02/2024 10.11, Nicholas Piggin wrote:
> > Add a selftest for migration support in  guest library and test harness
> > code. It performs migrations in a tight loop to irritate races and bugs
> > in the test harness code.
> >=20
> > Include the test in arm, s390, powerpc.
> >=20
> > Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   arm/Makefile.common          |  1 +
> >   arm/selftest-migration.c     |  1 +
> >   arm/unittests.cfg            |  6 ++++++
>
>   Hi Nicholas,
>
> I just gave the patches a try, but the arm test seems to fail for me: Onl=
y=20
> the first getchar() seems to wait for a character, all the subsequent one=
s=20
> don't wait anymore and just continue immediately ... is this working for=
=20
> you? Or do I need another patch on top?

Hey sorry missed this comment....

It does seem to work for me, I've mostly tested pseries but I did test
others too (that's how I saw the arm getchar limit).

How are you observing it not waiting for migration? I put some sleeps in
the migration script before echo'ing to the console input and it seems
to be doing the right thing. Admittedly the test contains no way to
programaticaly verify the machine was migrated the expected number of
times, it would be nice to try to match that up somehow.

Thanks,
Nick
