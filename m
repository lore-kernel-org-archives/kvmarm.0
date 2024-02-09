Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4B656B68
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 05:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707454928; cv=none; b=DOJWDOchlyexSerpO5cry+1UE8U7n9lGM/WGGKnmXiJTH9EA4xBq/ApfZoJp3oGnsXcjksIburxkn/N/kINYAVSVPeepwrVD2nr7iVy2ghMHCWYlkCtagRzcxmUhHrCejNetN66BQ+gUI9eGZTbCuxyNH0DW00I/Q8eqQ0iMzg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707454928; c=relaxed/simple;
	bh=QHzDgfDMbhuy63JYBLnHTpA2kSqsUXdONURKUAyBw/Y=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=gUhmXYvB9Lv2u1fj2GPT5Cz3iEa+Z9IC4W1Zo8hgo5Yv/0HHLD5etck2U1hJ2oZc8P+5Mq3hG4zLlChn487r2CUfXr5NsBjwDXssxf684Ay97n3L3NgDW6dqgqINdgCW3RbPmLhA4ieXeubhMutLZS7ZzaWny22c7ndkszUm0Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8QTrYP6; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8QTrYP6"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2970b501f40so102590a91.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 21:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707454927; x=1708059727; darn=lists.linux.dev;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wqz7Y/TcTN7smUZ/N4fhNV46jTItRF0U++Hxc5pAtk=;
        b=a8QTrYP60bZuV9CZUvlT6AVk6DQ7xgXVvEbIF1tbm+fnDEy31vB1k//Wb5Cdz0Y7Fu
         Y/xoR9gmF449ce+IElelZaQv3X6Jxk27LUzxRWOaVwwlrJxJABHslvsNZrUn9wEF4C1l
         fcR22yMMr0g4XyBQCQYAXFk851Re8DDcuCo8BrJqjH5HP9mRMeU+W+/RH/T/4DZg8wEc
         F68JyuUY4VFWRPKhB70+XQ5dC7bRkYHHoI0luPT+SPHAaEFijwh+FFo9cYJuGAs1Mn8G
         i6lbC+Ct3MoCJ6lFKLgj3cJE3C2VhKPMrLtkXH8oEWTS0GrDO4nSLRYSs7Lk9m9rbyak
         DrGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707454927; x=1708059727;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0wqz7Y/TcTN7smUZ/N4fhNV46jTItRF0U++Hxc5pAtk=;
        b=ME+U1zHlpeoQL5hMt0y6q5anOwqmyfEx0u2M1kVIDU2KiUjuBeHT2kHREcCJ4bLSiG
         ZB8eLLiUxTx+EPTcEJUNhHtXL7vmp0F0d7zbENzegc7Od2lF0daaR/O35OohelTteAHC
         VPHUJudrruHQCHzmlzNDxk2LipU3jjaJm0ejJ/QVPbwW1XTKcqSTKQX33FNQ4i2920oK
         pYl/6ab82XlrOV9VaCCvEB+z703FHKuCnac3wGBxYYjbTvdhI/bf40sk9KpZ/D9flYrv
         KyWYFLmNl6q8sJVZl0qjjtwWvy3rC5LcVPlga6nRs+Fl68I+jKQYvGXSLjXQI1lLlZrv
         0rtg==
X-Gm-Message-State: AOJu0YyOmrHSH81i8rE7zRSrCpqEiXqO7ZXy5hykiUdYPh9A95DCW3S9
	sOSfetdbXHKqDmSkHFFW0YP5TFejONl9uM8WcHbCC/c8aDcdYPhY
X-Google-Smtp-Source: AGHT+IEKRg+nU8BWUu6QYFnkof43Ezzita86bZjmYmWTU2CUj7lvOVVnWbVZiYrOWORfbM//Bd/KAg==
X-Received: by 2002:a17:90a:bf02:b0:296:fe8d:248b with SMTP id c2-20020a17090abf0200b00296fe8d248bmr460936pjs.4.1707454926617;
        Thu, 08 Feb 2024 21:02:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX1gF5gyLodB9BkGeJgen+1IIQ898R25d9CxVUmwkcouUztyRgoFsqK6P/mdgxB8x2pFV63YnmUNoLXFz2tkj7tHB7BvZmMZtYCvmDYODZMgL6nAqi89JPL5OaMfN5wM7G+P/WEybND0q6L4npV2znOQTSXmjEfIM3vzWJGupZpCgApmK4Zp8537Kqb71pvvVCTG4IRXg/Ead8zsQkmaEGQf9EjyTNySMaIRyfi1UrqBNkWWzvE9Mhh27Hmr9u1j4fsYKdHqpt4KVsAm1byPRjBNTsC8PB9+4mz3BIeaSJVBX7hsxQcI5cAI85egsiwkEykDe++XJtbcn2LYw+BzjhlXrdMumIdXRIoqGb97NvoBlhgTavF03Nb47HVUU08eovz6ZBIHWxmMFKsWAYJXTsTuAivdoz+c7ew7L3p2ykLTjmmfwbQzEcokGzQvK9bHlV2pddrFIOsFhaMzkqe//FxH4GakiPArNdISfUQb6O4BNCeNdQ=
Received: from localhost ([1.146.65.44])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090301c500b001d7610fdb7csm608163plh.226.2024.02.08.21.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Feb 2024 21:02:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Feb 2024 15:01:56 +1000
Message-Id: <CZ0A93T119VP.1LQ0MR1O0PYJE@wheely>
Subject: Re: [kvm-unit-tests PATCH v2 2/9] arch-run: Clean up temporary
 files properly
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>
X-Mailer: aerc 0.15.2
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-3-npiggin@gmail.com>
 <c9039fc4-9809-43d9-8a99-88da1446d67f@redhat.com>
In-Reply-To: <c9039fc4-9809-43d9-8a99-88da1446d67f@redhat.com>

On Wed Feb 7, 2024 at 5:58 PM AEST, Thomas Huth wrote:
> On 02/02/2024 07.57, Nicholas Piggin wrote:
> > Migration files weren't being removed when tests were interrupted.
> > This improves the situation.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   scripts/arch-run.bash | 12 +++++++-----
> >   1 file changed, 7 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index d0864360..f22ead6f 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -134,12 +134,14 @@ run_migration ()
> >   	qmp1=3D$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
> >   	qmp2=3D$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
> >   	fifo=3D$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
> > +
> > +	# race here between file creation and trap
> > +	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
> > +	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXI=
T
> > +
> >   	qmpout1=3D/dev/null
> >   	qmpout2=3D/dev/null
> >  =20
> > -	trap 'kill 0; exit 2' INT TERM
> > -	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXI=
T
> > -
> >   	eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp1},server=3Don,wait=
=3Doff \
> >   		-mon chardev=3Dmon1,mode=3Dcontrol | tee ${migout1} &
> >   	live_pid=3D`jobs -l %+ | grep "eval" | awk '{print$2}'`
> > @@ -211,8 +213,8 @@ run_panic ()
> >  =20
> >   	qmp=3D$(mktemp -u -t panic-qmp.XXXXXXXXXX)
> >  =20
> > -	trap 'kill 0; exit 2' INT TERM
> > -	trap 'rm -f ${qmp}' RETURN EXIT
> > +	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
> > +	trap "rm -f ${qmp}" RETURN EXIT
> >  =20
> >   	# start VM stopped so we don't miss any events
> >   	eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp},server=3Don,wait=
=3Doff \
>
> So the point is that the "EXIT" trap wasn't executed without the "trap -=
=20
> TERM" in the other trap? ... ok, then your patch certainly makes sense.

Iff you don't remove the TERM handler then the kill will recursively
invoke it until some crash. This did solve some cases of dangling temp
files for me, although now I test with a simple script:

  #!/bin/bash

  trap 'echo "INT" ; kill 0 ; exit 2' INT
  trap 'trap - TERM ; echo "TERM" ; kill 0 ; exit 2' TERM
  trap 'echo "RETURN"' RETURN
  trap 'echo "EXIT"' EXIT

  sleep 10
  echo "done"

If you ^C it then it still doesn't get to the EXIT or RETURN handlers.
It looks like 'kill -INT $$' might be the way to do it instad of kill 0.

Not sure if that means my observation was incorrect, or if the real
script is behaving differently. In any case, I will dig into it and
try to explain more precisely in the changelog what it is fixing. And
possibly do another patch for the 'kill -INT $$' if that is needed.

Thanks,
Nick
