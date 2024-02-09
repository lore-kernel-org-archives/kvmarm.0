Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656C9651B0
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 08:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707467968; cv=none; b=HTygCpqJBYhXgSycLrfUu536WIwiSTzHhshoflOKrf3V4RxryuUrxW9qA+SU5+IgQNdV2VQTqieVMrUAHgolDWAtvb/hbhZ9rzJ28QdpyArl1re34sxqj4USF6yw734qXFctqF3plGdvZMB94pJAuHSrjJ961jeiFA9+REAFFTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707467968; c=relaxed/simple;
	bh=hGkgKfkAVC5yMoa0mFFQ4FyeVU2txIHV+Ep++T98ySY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=hWd9EOCFG5RWmPweQAjoJ9MvqJBfQhD5k5QP0Fowbl65PHi60S2Cv9/dqWZFr0E8Cbyqz4HKG7mvjH9Zcz5cqYRHWtG6GaLh07q2x+rgKuoH0v/OF57wn+eY3e7RZOdQpXBVNszxGwHHNe0gcVrikXgRUXkk0o3UAveN5N5dVyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dU3kMHLx; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dU3kMHLx"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3bfede356dfso341686b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 00:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707467965; x=1708072765; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyKQn9uFT2a/J5rDvpN0cP8mjeStBcBZBirfXqZnRa0=;
        b=dU3kMHLxSqxdCcdHj44OFSJLAEqnD4MbwLVfwAIIGnca7IcgqgqnRN7KexfvAd7AA3
         YewablK6QNmmA1+CLHAy1df5uknz4E1KtRW+xMhE92MVge5LdhgxvI0QWqy3/yO2ZbOX
         vafq7yQiMXp55ojXZKad8b4aZ5TRaxjttsUxYIVEosQEyLaaNwhn1iI9KAkzB+JB0Xuk
         xUnD0vlmXlMFQM+zSl6mZQSBkbjgQ2iRaR1KuMMdeD4ui7D3/UNo129zSUcYidaB/qAz
         glSazlUxdj9pXdcPueNqEWPKErmlmxLGteVGTwTHbLkwuTl4sQEAs7kTPWdVTxGjIIGw
         ML1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707467965; x=1708072765;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nyKQn9uFT2a/J5rDvpN0cP8mjeStBcBZBirfXqZnRa0=;
        b=UxsOPdghj4vpaFnY0N+4l0UG3+ICA5D8m6NYieNzuv+PzWwyFbzQXwcwVv90ryhpVK
         F2A8uck4hSSFFWD267/K5CpuXloDd12BBSjJg/QHd/jm5Huk2Wu+vto9XCEzDBXqw/xZ
         STHGB06S9Ps+qwybOSLUxuny+JED/ER8OBSp8N9Uf3SGYLI19Iv2dG5LDOWS/T1F2MuO
         tJsphOHJbI8dQPGkXn6VHIFZIL5zWLbBbSJRKjB/oVpWJi4AAiggQlPfU6hTTDOuTtdn
         wkkwRsB3FXvUxHk+U2IWeV4rWLmflCXVvgZQac1fUnFXm4taN5oovBuSewPElu4tb6oq
         mWng==
X-Forwarded-Encrypted: i=1; AJvYcCXJf8SKuRX0fSMA5QfxhszikecnWQtVTBLqRcwdoEoeZhtJqOY7hLFUV5/BeZpVNQXbJRiz1aZM3qxnVRg2wc1c61lyVLp3
X-Gm-Message-State: AOJu0YyJR/dhj35Yy8bS7FD1ocie5yrGy3XbOnX1lZ+yrOBiyHdsLo8K
	StjXbM8PUDZcziwLmK573SLmePxN52nDKrOa2spDJUD8q50u6OIZ
X-Google-Smtp-Source: AGHT+IGCD7fGlpE/kOjkFgbPUXzNVL+89RLw5kmiWdG3Q5ZSYTmewWMqAE+Sy77LLy05iz4j3BcBew==
X-Received: by 2002:a05:6808:5d1:b0:3bf:f3d2:df11 with SMTP id d17-20020a05680805d100b003bff3d2df11mr951728oij.33.1707467965199;
        Fri, 09 Feb 2024 00:39:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUBbBYWPx9ICb3NUFgr2PZmgRNPwfiBtNOzx3mqOeSzznXalqLN2RcMQJ99wKy4+RJz7BLpOxBMjyiU+zDFIP/sckpJK32WMRJUivhTUecrE+4+BXmlotghzLmqs+UeZdEwi3mWsP3RIiaL+zSp3ATw/m6LVZIbcEOySMT5Wlq7lu0yjCf4u9bEsiDelGVecH+34/BBbqVP5iUCvtPj/2z3MA5GY7lA0K/ndNh/LxnW9330y9gvwxHvtmU+KAMHOOpjHPhb6mVfBPmNgEjUAkUh2jNNnWIQzuHAR9hLY4ZHtVHYLo/tYVJ8jzb96xEt1fTjAwcJM6Xgu4rbinNzuV5AwAgsj8j2qnz05RizpXraGHPfeIGMYli1YViSiK/cw9ezOT15X2vhHPdLMgIrlIy/EsPL3YTPbZZA5QiM17bJRnpSUhD4PBDWeq21Bv+VZEdoPdbi6ZKpa6FsthxwDyNGUCv88EYoz21JCkC0j2f/bJPREMoMfJtyQ2czE1AUS+/msmAQNLFIzYpttIB8/dDLqVqi
Received: from localhost ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id y65-20020a62ce44000000b006e0945e03easm299516pfg.143.2024.02.09.00.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 00:39:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Feb 2024 18:39:15 +1000
Message-Id: <CZ0EVI7IZ9YY.3EF4ZKA9IXM5I@wheely>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>
Subject: Re: [kvm-unit-tests PATCH v3 4/8] migration: Support multiple
 migrations
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240209070141.421569-1-npiggin@gmail.com>
 <20240209070141.421569-5-npiggin@gmail.com>
 <74f469c3-76ee-4589-b3ec-17a8b7428950@redhat.com>
In-Reply-To: <74f469c3-76ee-4589-b3ec-17a8b7428950@redhat.com>

On Fri Feb 9, 2024 at 6:19 PM AEST, Thomas Huth wrote:
> On 09/02/2024 08.01, Nicholas Piggin wrote:
> > Support multiple migrations by flipping dest file/socket variables to
> > source after the migration is complete, ready to start again. A new
> > destination is created if the test outputs the migrate line again.
> > Test cases may now switch to calling migrate() one or more times.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> ...
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 3689d7c2..a914ba17 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -129,12 +129,16 @@ run_migration ()
> >   		return 77
> >   	fi
> >  =20
> > +	migcmdline=3D$@
> > +
> >   	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
> > -	trap 'rm -f ${migout1} ${migout_fifo1} ${migsock} ${qmp1} ${qmp2} ${f=
ifo}' RETURN EXIT
> > +	trap 'rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${m=
igsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
> >  =20
> >   	migsock=3D$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
> >   	migout1=3D$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
> >   	migout_fifo1=3D$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
> > +	migout2=3D$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
> > +	migout_fifo2=3D$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
> >   	qmp1=3D$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
> >   	qmp2=3D$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
> >   	fifo=3D$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
> > @@ -142,18 +146,61 @@ run_migration ()
> >   	qmpout2=3D/dev/null
> >  =20
> >   	mkfifo ${migout_fifo1}
> > -	eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp1},server=3Don,wait=
=3Doff \
> > +	mkfifo ${migout_fifo2}
> > +
> > +	eval "$migcmdline" \
> > +		-chardev socket,id=3Dmon1,path=3D${qmp1},server=3Don,wait=3Doff \
> >   		-mon chardev=3Dmon1,mode=3Dcontrol > ${migout_fifo1} &
> >   	live_pid=3D$!
> >   	cat ${migout_fifo1} | tee ${migout1} &
> >  =20
> > -	# We have to use cat to open the named FIFO, because named FIFO's, un=
like
> > -	# pipes, will block on open() until the other end is also opened, and=
 that
> > -	# totally breaks QEMU...
> > +	# The test must prompt the user to migrate, so wait for the "migrate"
> > +	# keyword
> > +	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
> > +		if ! ps -p ${live_pid} > /dev/null ; then
> > +			echo "ERROR: Test exit before migration point." >&2
> > +			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
> > +			return 3
> > +		fi
> > +		sleep 0.1
> > +	done
> > +
> > +	# This starts the first source QEMU in advance of the test reaching t=
he
> > +	# migration point, since we expect at least one migration. Subsequent
> > +	# sources are started as the test hits migrate keywords.
> > +	do_migration || return $?
> > +
> > +	while ps -p ${live_pid} > /dev/null ; do
> > +		# Wait for EXIT or further migrations
> > +		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
> > +			sleep 0.1
> > +		else
> > +			do_migration || return $?
> > +		fi
> > +	done
> > +
> > +	wait ${live_pid}
> > +	ret=3D$?
> > +
> > +	while (( $(jobs -r | wc -l) > 0 )); do
> > +		sleep 0.1
> > +	done
> > +
> > +	return $ret
> > +}
> > +
> > +do_migration ()
> > +{
> > +	# We have to use cat to open the named FIFO, because named FIFO's,
> > +	# unlike pipes, will block on open() until the other end is also
> > +	# opened, and that totally breaks QEMU...
> >   	mkfifo ${fifo}
> > -	eval "$@" -chardev socket,id=3Dmon2,path=3D${qmp2},server=3Don,wait=
=3Doff \
> > -		-mon chardev=3Dmon2,mode=3Dcontrol -incoming unix:${migsock} < <(cat=
 ${fifo}) &
> > +	eval "$migcmdline" \
> > +		-chardev socket,id=3Dmon2,path=3D${qmp2},server=3Don,wait=3Doff \
> > +		-mon chardev=3Dmon2,mode=3Dcontrol -incoming unix:${migsock} \
> > +		< <(cat ${fifo}) > ${migout_fifo2} &
> >   	incoming_pid=3D$!
> > +	cat ${migout_fifo2} | tee ${migout2} &
> >  =20
> >   	# The test must prompt the user to migrate, so wait for the "migrate=
" keyword
> >   	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
>
> So the old check for the "migrate" keyword is also still around?

It's just the comment is staleish, it only checks "Now migrate...".

> Why do we=20
> need to wait on two spots for the "Now mirgrate..." string now?

So that the it ensures we do one migration, subsequent ones are
optional.

I was thinking we could just remove that, and possibly even
remove the MIGRATION=3Dyes/no paths and always just use the same
code here. But that's for another time.

Actually there is some weirdness here. There are *three* spots
where it waits for migration. The first one in run_migration
can be removed, because it can call do_migration right away
to start up the destination qemu process ahead of the first
migration message as-per comment. I'll respin with that change.

Thanks,
Nick
