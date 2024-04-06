Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712AF1B7FD
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 06:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712386088; cv=none; b=tgXX7ANVANgmVrGjnqGkV/FKIuuZL/bZRND7uh/FudZ/F5/vSFKMNPC5ivjNN89QsUONCH7cScowtT7UnEO/Meeppwa4eg9HrlJ2XjhKTwXCa2wpkA2jRD5hmj/M9G5oaTgYOMYB4omTgIqDJ6LN/p7EGKcXo3rkmFhUuLFPRNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712386088; c=relaxed/simple;
	bh=nu4/Vi34vG4UZpRARu5d9nl5hpHsMKzoMSIzt8eV25U=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=MffH9NN7KUW7pZ1oQGoM7R9dUwMLVK/q3rWxs9eu1O3sMuQgmvjmto1zzX/OJn1YfEitBWYTX8doQmNXli4DYH4gofRsy7HJO2d9m7VL9mFmKJMNnpuuYa7hGRjK2bZNhXMd/JTFptb8FxSFNx4Dfw0TXLU2nWMuckv+tdbb6aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmrYDaKS; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmrYDaKS"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-29b7164eef6so2289031a91.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 23:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712386087; x=1712990887; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v6+JiqOGzbpzk2klVJFAulQ2pHe3C62qO52FD0G/JgA=;
        b=jmrYDaKSd4EMOA+UXmkPaFspPBcJaCxfJm9nh0KAsCAgNyG6z+QB4u2XYOOtZA7XlN
         FlSZHVwUu+78qeN7+FEt5iIV/U5PdjjcsMl5ULURWkaAFhtQu0uPOfLAgkbiVJYzEYUI
         br+s5kvF7phLoWG+Zik/FiM+BMqFMHRuIE9CFVRWgCkRHdGwnPGuz7N5xLM+rir5Z1Ly
         1bsec/G8t9IeXDBguRU4WRlCH+cwTnfoNW+bbTSLLuw/Zv5xlurFyJUFhTp9CK0TdtW3
         +UkSifGOQ4qtF0iJgVhokMfhsKJlIFomKZfhpQS2jDVIVtJklMpBeOxAunoQZVNpb4yA
         Q5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712386087; x=1712990887;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v6+JiqOGzbpzk2klVJFAulQ2pHe3C62qO52FD0G/JgA=;
        b=iBCkVM75VfMRSyTWtiVorIVsX8yIU7sAFv5jF3YC9NhFchdDOeciKgow9Wu+4iWgPm
         /SYRQYRKJ7k8pvjvoTdQz/0B7ppKcgcr6l1nG0iGnYZvsFPz2kxM7uUoHXQ86PqjEk6N
         VFjw+CWdoydWMIfProI59Sv0Q6Bzf4esIN6hAkXoemDSTgOsIbJZYHmpqpVx9l+ak8vN
         fRucsnWYQH6CtmxP7MUcvOXmYi14mZ/l4UwGdA4UiQ2V69JPnYRDQcr58PudUkkJ0HpJ
         IQfzVkiX9c3GHZRSrxxMXkDhYyc6GRD1QzL/fBJksYBlCe6SE9H0ClPQluGDTDEZEKaF
         2xAQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7xlCG28V/GHQniZg6GHB9RBudti/I6jjZ1qHImxvF7JpPKWOkw980R3/8cTjgrZtmaxEH2FYamfkiXkR9jiV5SYvHS9F4
X-Gm-Message-State: AOJu0YycI6u2ADyMBjYJRm1IzTojCBirkXumBbYJ9LVSoCHVD6HkpF7b
	wQQLvBPB++zzpnH1Wjv8gbOwc85/DdMboMu73PBzCEhoQMy7jCNa
X-Google-Smtp-Source: AGHT+IEYFWg8+9q/bQMiaUQc7asTNB8G+VtUoqv4E9bLDu0tOzj8XkKrkMiIqAvMosYPL5b0r3KrmA==
X-Received: by 2002:a17:90a:fe8d:b0:2a2:ba9:ba61 with SMTP id co13-20020a17090afe8d00b002a20ba9ba61mr3660048pjb.34.1712386086714;
        Fri, 05 Apr 2024 23:48:06 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y22-20020a63e256000000b005dc8c301b9dsm2582409pgj.2.2024.04.05.23.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 23:48:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 16:47:56 +1000
Message-Id: <D0CU7BLHUQGG.2GG3SFOUSVPCL@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "Nadav Amit" <namit@vmware.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
 "Ricardo Koller" <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>,
 "Gavin Shan" <gshan@redhat.com>, "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>, "Sean Christopherson" <seanjc@google.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests RFC PATCH 11/17] shellcheck: Fix SC2145
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-12-npiggin@gmail.com>
 <20240405-a35419152685e6aca33ccc04@orel>
In-Reply-To: <20240405-a35419152685e6aca33ccc04@orel>

On Sat Apr 6, 2024 at 12:35 AM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:43PM +1000, Nicholas Piggin wrote:
> >   SC2145 (error): Argument mixes string and array. Use * or separate
> >   argument.
> >=20
> > Could be a bug?
>
> I don't think so, since the preceding string ends with a space and there
> aren't any succeeding strings. Anyway, it's good to switch to *

Okay I think you're right.

Thanks,
Nick

>
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  arm/efi/run             | 2 +-
> >  riscv/efi/run           | 2 +-
> >  scripts/mkstandalone.sh | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/arm/efi/run b/arm/efi/run
> > index f07a6e55c..cf6d34b0b 100755
> > --- a/arm/efi/run
> > +++ b/arm/efi/run
> > @@ -87,7 +87,7 @@ uefi_shell_run()
> >  if [ "$EFI_DIRECT" =3D "y" ]; then
> >  	$TEST_DIR/run \
> >  		$KERNEL_NAME \
> > -		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
> > +		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
> >  		-bios "$EFI_UEFI" \
> >  		"${qemu_args[@]}"
> >  else
> > diff --git a/riscv/efi/run b/riscv/efi/run
> > index 982b8b9c4..cce068694 100755
> > --- a/riscv/efi/run
> > +++ b/riscv/efi/run
> > @@ -97,7 +97,7 @@ if [ "$EFI_DIRECT" =3D "y" ]; then
> >  	fi
> >  	$TEST_DIR/run \
> >  		$KERNEL_NAME \
> > -		-append "$(basename $KERNEL_NAME) ${cmd_args[@]}" \
> > +		-append "$(basename $KERNEL_NAME) ${cmd_args[*]}" \
> >  		-machine pflash0=3Dpflash0 \
> >  		-blockdev node-name=3Dpflash0,driver=3Dfile,read-only=3Don,filename=
=3D"$EFI_UEFI" \
> >  		"${qemu_args[@]}"
> > diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> > index 86c7e5498..756647f29 100755
> > --- a/scripts/mkstandalone.sh
> > +++ b/scripts/mkstandalone.sh
> > @@ -76,7 +76,7 @@ generate_test ()
> > =20
> >  	cat scripts/runtime.bash
> > =20
> > -	echo "run ${args[@]}"
> > +	echo "run ${args[*]}"
> >  }
> > =20
> >  function mkstandalone()
> > --=20
> > 2.43.0
> >=20
> >
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

