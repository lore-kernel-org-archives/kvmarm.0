Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F927F7C8
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 05:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707196851; cv=none; b=oHJgTRZZOHhfKyYeKhQWSeSyiRkfqM48303WgyA02er8duGmpy/6upXI06YOhUPmEgg7SVDsFr989aFXcv8Q0zGK9lrJCCgifzkc0DVoa0KOLurhtmEZfag1c3VgCYsXLVln3rQsoZ65fyrhJwMIitOb0f7vCiwb8CX9uQQth1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707196851; c=relaxed/simple;
	bh=XEJ+jhnAPDqSuFwkdmvR0HvhYL9MbSjjh8X3b4RrQ5g=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=Ucf028k6Oo+6/51eNaE5k55FfTB6PIr5SsXVRoQ5a5kAD2vMiIE5IeOH23NEXIfrnkfgbKUVfI1oHRPCdnhuNxeRny9Av2eldWDX/Pckj+vr/ohmgtZZ5MRb3Da9Uu4EX2FdS1b6FlMrwVh0qMDq78DpplU8pabn+OT0vNSxZ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I4bVbWMw; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4bVbWMw"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5cdbc4334edso4130712a12.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 21:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707196849; x=1707801649; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ujXxMm41r1DTz6hXgtYYr184Pjn4FDAt68mgLajJUg=;
        b=I4bVbWMwFFe8Zq3CnCpGh/e+EkehnnddWR9P44gQOHYxygW7tGntZeTkPoWhLeAIYE
         etd300qGQjHjmco8NdXD+TNi78SNdaK1KQ7rAIV3g2l1YzbdOlN7hRhTS1KiMuAcKnl9
         rWBRLzM/2Uh48Y6k5mpNY854NULl3CzELrvM14fJslaqwu74K9vVjHhQkMZoOh/vShi9
         uD7QZ1zsB4ze4+CRsR/mPEt1pWgzTi483XGw1wLfKQPAqvspOLDAN8F6G8y9ry/EQZ/F
         d5JN9OpspO9S8Cv5gCkIHROsu5I0brEf5ppykzFA5dhfMnhE0755hXIQJM5hDkmAc293
         6JbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707196849; x=1707801649;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6ujXxMm41r1DTz6hXgtYYr184Pjn4FDAt68mgLajJUg=;
        b=JdrerBpqcgTH1nVS6hKF1zKMH+LTePSKeuHgyeRsVS0REDsB1XMOn68PfNFOE18rGR
         VifDlQyJKR69kXEzHql78KeeGjVKFv/LA7bvxxUdZ0WpZqph6qrOaIKTp6tyHJ2yZ2P0
         U4yCeahGoaZrKMwO+aaQwZ2wos/a51SkUHsemkSVA+3XvUPhvfXkOi8arBkR5EGeFlmf
         Z9xl7HdtlvEADSDVZ0soKlkkEe5PqGL/eRqAcUYaK4cewJU1gSEFMn+ILVk0pBShIQYS
         uyPVhnCEqSc+DOeUTy1cS/ANO6Qhkg71YsawbA1kme+M38xfT2kb92zZB2oW1h6Udfda
         HviA==
X-Gm-Message-State: AOJu0YyJrWx7/HaEOHvfS74vvIwVi5+1RsupN2+zKDpnoB4bYCe6UOE4
	2lGaDam8XAic68aRhbWRbN2IY6RjSWiAxKl90J3wY75mOMqviQhk
X-Google-Smtp-Source: AGHT+IGrC/r/fSLayc+2sKm4zT5ROnGWF0/akqOJQQ+ytoitx9LbhdLVzv/iUQiDN62FNk18zrb+oQ==
X-Received: by 2002:a05:6a20:1585:b0:19a:28c3:ee0d with SMTP id h5-20020a056a20158500b0019a28c3ee0dmr633416pzj.15.1707196848684;
        Mon, 05 Feb 2024 21:20:48 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW18Usptg28HpXEBSe0coTZzST3WInoh7AzPcUDYZLKObsxXjGFfums519DdYypqLO/LRwtH87zuGBMa19V2aHodBMpHpIGAflAANNaysJmXcVvIOc9DTx/UVKQA/aoQ7Oe7tzqmEOuYyc14Zy37imoWAwt1LjfELNiQdFJHp0tnL/K7LbaIoxRZfTaNhHrA6yHV0o6bdyuNATTtTrhPGAoPm/nVh3TZ4MtaTZ2fDfQZO6qXuQ4n4Slo8zmtYh0F768tEb/iOmRyx9xEA40WasdNWE5hA08Wh5903uBFSBhSfcvh7muf1SRGe1EQr1jxbQD+I46Zh4b/Nzl/0j4inFDJUkZhYu5xZA4fRrSRciBWf56R43Aabd4gAQIUi7OkZgkrdVOa1Bhw8ILdcXk8ecS0GcwfJujRvqS+Be6BIBPIWdYfWWjyhqw9RbpOx8ArZx1jIqA/W6PpGe2upPJPkJPY1T+qch6S8t1qq2vMRSwBAkiKM8=
Received: from localhost ([1.146.47.2])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902c3c600b001d965cf6a9bsm830428plj.252.2024.02.05.21.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 21:20:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 Feb 2024 15:20:15 +1000
Message-Id: <CYXQRHUSFZ71.LI2K63O2WRJG@wheely>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v2 3/9] arch-run: Clean up initrd cleanup
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.15.2
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-4-npiggin@gmail.com>
 <cc1b4733-9a6f-4bb6-b8e6-1a6a8807b317@redhat.com>
In-Reply-To: <cc1b4733-9a6f-4bb6-b8e6-1a6a8807b317@redhat.com>

On Mon Feb 5, 2024 at 10:04 PM AEST, Thomas Huth wrote:
> On 02/02/2024 07.57, Nicholas Piggin wrote:
> > Rather than put a big script into the trap handler, have it call
> > a function.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   scripts/arch-run.bash | 12 +++++++++++-
> >   1 file changed, 11 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index f22ead6f..cc7da7c5 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -271,10 +271,20 @@ search_qemu_binary ()
> >   	export PATH=3D$save_path
> >   }
> >  =20
> > +initrd_cleanup ()
> > +{
> > +	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
> > +		export KVM_UNIT_TESTS_ENV=3D"$KVM_UNIT_TESTS_ENV_OLD"
> > +	else
> > +		unset KVM_UNIT_TESTS_ENV
> > +		unset KVM_UNIT_TESTS_ENV_OLD
> > +	fi
> > +}
> > +
> >   initrd_create ()
> >   {
> >   	if [ "$ENVIRON_DEFAULT" =3D "yes" ]; then
> > -		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OL=
D" ] && export KVM_UNIT_TESTS_ENV=3D"$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_=
UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
> > +		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; initrd_cleanup'
> >
>
> Why don't you move the 'rm -f $KVM_UNIT_TESTS_ENV' into the initrd_cleanu=
p()=20
> function, too? ... that would IMHO make more sense for a function that is=
=20
> called *_cleanup() ?

Yeah good point, will respin.

Thanks,
Nick
