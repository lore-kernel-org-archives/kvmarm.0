Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BF07F46E
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 06:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707202222; cv=none; b=D6kyXOWrxoaPCb49zu6Q3Yz/m7xP4b24u5O1HypXJhGcGCSd09uKuPm0vz1lTc8lh2XZICrCZlCCI9M4o5G5ZkYi8aNlLNwzuD+zaWqnO7bRCxMsAjdH8unPP3J9KI16rAbdx2oY7FuoH0mSVXPU4jIVZVrT4fBRWOXtvqOb8mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707202222; c=relaxed/simple;
	bh=KCKCrYRcZeKXBExCNMpkRr8jNZJTXLkHMUQynMuWJOU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=bQCCTI/An/zdN38Zb0G3HNcoEHf/PnBal1iXUp8UM3m25knPyeE+NtsWdMGe3vpsSzfC/JcBZNOoO+iNMYfA1Ueg8UmIgT6Fk+L82quxXDxYB3rah1EpIhn7Bf5KHj8CNi982Kb+/FC5KF2J0AhMKmGaiBJu9fuIFf14xSUnYc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kS4UcrWR; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kS4UcrWR"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e055baec89so212972b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 22:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707202220; x=1707807020; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/kdFePQ6nG6QtYf63LeF1ar0dDM9VOG+LaoM7J5+2Vc=;
        b=kS4UcrWRlIULIWLo/g7wKDzRl/BhePmPFcIzmY8t7IhHd6ZAFsABrxU9bAV/hAOcRK
         UcqkpYJxegCF8+bqRqDR0z+fUIaDOlmLTsposOEt9uZlSGaQd3rT/t2MfC+4HlEFgG0D
         8+Oz+SA0We9WkZP7ydjoXFFMUShTae/Jlfu0d+Tw0+cb0yHjexzWgv7bZ/SQzGYp7/Yv
         kEXMP/KL4Gz8ilW/z/lyA6U/veRl9S9jE9/es47j2a8v/22JO60EHczPNHn33LDQwVyl
         PXFZNPaepRZfhgTDp8HfKg6BbdYPOw96UUmXMpqv9kbeVdpBQOuALVduF/t+jCo1B2L8
         nTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707202220; x=1707807020;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/kdFePQ6nG6QtYf63LeF1ar0dDM9VOG+LaoM7J5+2Vc=;
        b=c0mB4Pux+FtQAoxMfJlLaeoi2GrgQG1Cjq2YyO1tq2VPBepb0sGso9ZYoauaDTHwOx
         N3SmOXqKegkrahKo7CpMHftzeZ9UHqbqeLHQL8nNVU45jUGWo+kEJlV0dGUma1XNPiIh
         VKYJVcTAf1BP4cK34xsqKjxTpxcHNL3LYJXRl3U8Foax2sRJ4b22Su6M3+gBqMgur/Uz
         IP4FzgiZ5jmjFQRuAQzUw5yi+N4xllwyx+CRb46BBi7zQTOpAzkAHzT+inT+JUDNZtyM
         1uoU8Vuos3t5MvlkM+qKPivhVauby3z4PNTP3DoXJeRB9VkfOvr7S0oeNRTHm2efbtuz
         C+Lg==
X-Gm-Message-State: AOJu0YyiiVXgy60GIdICPLaZgCWz2o4aWFlwoE4WedTNqDKnyaLqg9R9
	+NmxOQLiyz0Ds3OLtmTcKHXuahjmJdpPTdiOWR90pSD65VYaxse5
X-Google-Smtp-Source: AGHT+IGvKjwL4W6wJxS1qhH+LUiqHU6y2PSnrtaNe+q1U78MQ6ejPupj7SdHUe8tv5SU8x3TR8Jtww==
X-Received: by 2002:a62:ce0c:0:b0:6e0:44fd:687c with SMTP id y12-20020a62ce0c000000b006e044fd687cmr2639380pfg.6.1707202219680;
        Mon, 05 Feb 2024 22:50:19 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUvLpbZd5PGRt9Lm8N+YxGtxYwm7xHfKI7AfNe4JnD0ZcHDGb4AiM6NCATC6xn8QdWQ7NnNJLWk+kkBwOTxc56IZtQtmY8DKXtgHY1+qeUgs9uAsMQyiZ+X/vqtR2tV2xXah+hz1+oZB6q494nfuF8de38wjFHr0LvBPN4cE0PqFb1isJBeXY0+ZINCzwerxHiffe4gmQ8/5cXyG5x0zefEY564nhd/WYeamEjd6j7LO9LnyY03yySaesDTzrqzJXlg60ITFn3aaZgs55To53DiDkTS87aw5kJdm0gWt3+p7XWYJD2wcv23dZSRQdF4hMVBXOgXhMYh7qauuz7L43+RUiNHxAlCqso7yFLpK22NcpIl6M8oANLjVq6E6a7DDjUzPYHWrB325Ei3onpNjXC2063fiP4bW98HdFOdDRi1wOQiCpBBIgP6As8rsl2aebzRWNh5Rd6Azs95pkeONk7DWagx9+geb8Rp43+j7HU=
Received: from localhost ([1.146.47.2])
        by smtp.gmail.com with ESMTPSA id x23-20020aa784d7000000b006e04f2a438bsm1025925pfn.105.2024.02.05.22.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 22:50:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 Feb 2024 16:50:08 +1000
Message-Id: <CYXSOBQAP9FF.3GPR99T207WJY@wheely>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
 <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v2 4/9] migration: use a more robust way
 to wait for background job
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-5-npiggin@gmail.com> <87y1bzx8ji.fsf@linux.ibm.com>
In-Reply-To: <87y1bzx8ji.fsf@linux.ibm.com>

On Tue Feb 6, 2024 at 12:58 AM AEST, Marc Hartmayer wrote:
> On Fri, Feb 02, 2024 at 04:57 PM +1000, Nicholas Piggin <npiggin@gmail.co=
m> wrote:
> > Starting a pipeline of jobs in the background does not seem to have
> > a simple way to reliably find the pid of a particular process in the
> > pipeline (because not all processes are started when the shell
> > continues to execute).
> >
> > The way PID of QEMU is derived can result in a failure waiting on a
> > PID that is not running. This is easier to hit with subsequent
> > multiple-migration support. Changing this to use $! by swapping the
> > pipeline for a fifo is more robust.
> >
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
>
> [=E2=80=A6snip=E2=80=A6]
>
> > =20
> > +	# Wait until the destination has created the incoming and qmp sockets
> > +	while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
> > +	while ! [ -S ${qmp2} ] ; do sleep 0.1 ; done
>
> There should be timeout implemented, otherwise we might end in an
> endless loop in case of a bug. Or is the global timeout good enough to
> handle this situation?

I was going to say it's not worthwhile since we can't recover, but
actually printing where the timeout happens if nothing else would
be pretty helpful to gather and diagnose problems especially ones
we can't reproduce locally. So, yeah good idea.

We have a bunch of potential hangs where we don't do anything already
though. Sadly it doesn't look like $BASH_LINENO can give anything
useful of the interrupted context from a SIGHUP trap. We might be able
to do something like -

    timeout_handler() {
        echo "Timeout $timeout_msg"
	exit
    }

    trap timeout_handler HUP

    timeout_msg=3D"waiting for destination migration socket to be created"
    while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
    timeout_msg=3D"waiting for destination QMP socket to be created"
    while ! [ -S ${qmp2} ] ; do sleep 0.1 ; done
    timeout_msg=3D

Unless you have any better ideas. Not sure if there's some useful
bash debugging options that can be used. Other option is adding timeout
checks in loops and blocking commands... not sure if that's simpler and
less error prone though.

Anyway we have a bunch of potential hangs and timeouts that aren't
handled already though, so I might leave this out for a later pass at
it unless we come up with a really nice easy way to go.

Thanks,
Nick

>
> > +
> >  	qmp ${qmp1} '"migrate", "arguments": { "uri": "unix:'${migsock}'" }' =
> ${qmpout1}
> > =20
> >  	# Wait for the migration to complete
> > --=20
> > 2.42.0
> >
> >

