Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2532B9AA
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 10:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712400978; cv=none; b=W5KRsNhWw7XOYvhwXtrUqcHqkxbHdTJlAz4aKXZp3cQwKQj4O+zccdoDLYD0GeuT/CaPa1ZjpEGDVqO4JNSWz5o1nSHsf6ZlU0fujBpXxv/9p2+vupmEFwjbZ4yIz+bZg7M1YwzcwY8+2Elwpygzl3Rz+O3sI2sBQHELUHC2k7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712400978; c=relaxed/simple;
	bh=VpwYk1EA3VzZS87YMAY8p5OYl14QEtm4EMPTEX3rymE=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=HmZE4Kcm5sIGhoNipOkjJbiHnq7ond6mLXthiA+FikcfEfMYJADvIyRI9ehbQ39wSdcEE6R9JzqE6opC1MNl4tLFO1zIxOmMEfVKfNEMU7iRn8YfLqGq5jS+JZhmZjaH72lXoXlLFL3E1bmsC+8WdwMCF/d3W98fUSWx5wsaSlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l7aGBiN3; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l7aGBiN3"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ecfeefe94cso1038740b3a.0
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 03:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712400977; x=1713005777; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N64pB3xlNshNVIJeimy1wWBqnaCTY8r/9llzYbR3mWw=;
        b=l7aGBiN3Desv9is4CyI7BJ5JDO0ucES1GSyj7Z1mK+eaUXRv5G5qx7XjzMepog3zTM
         9Kz4Jb5UH78QfaKiF89VXSfJCPIocpCv196EZDtSJ4Y5YcgVW+9J20rDVbSR5OoJGmx2
         6JDAqEW7VE+y8BSt8fSDtmnEoOtjTidwGzpJUWBwxDqoAO18J8Hn35Pc5zBz6F9VI0Es
         sGqVu1ZU6fldu/Zf0YWWCgXdc2HqTGIyFek2w399nwiYVHRr8Vz8TjwbpP9uf/WAjgnc
         xFqvzzOiP5nUW8TPaacgsPi8QX+pA5m1l8Ua3GMO/an5+ZB3ai0frtP5dcX9/FkZ9yT5
         okqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712400977; x=1713005777;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N64pB3xlNshNVIJeimy1wWBqnaCTY8r/9llzYbR3mWw=;
        b=OXhdqaZf1IxRWSHKCLMAeXVq2jkyDRWCKmzWCN0umzwR17soKqsGs0Lad4D+UJ+fuE
         4Jj73OzVFBgGcskPxKlSSODlI6kdllMdI+3mwDYUUBeGRwYbLEkvNFYNWKWPavdQ4OAZ
         H9J2x2TYcaFPc4UXgzFKIJS4c0sfQmWkm4ryGOHe5cgbWjYHSUAzpL0Gvq6mFRF+q/Vp
         CyT3gO6P1w2g+km1RBfberqJ5omPqW0lXmjmWVbesyDuFeQB8jQu65gvOThNf2O0Y7ds
         /KkZFD7ynz0T7tp+YslnqrzDzvYO2Woc+P5pwyyB6cd9WHEwqF1LN7nQTjgoHlu4dLub
         z9cw==
X-Forwarded-Encrypted: i=1; AJvYcCUfGQ8klroeD8Zv54kaUb8RD1Qiw4PijAfSidx7zTWozdP/wIRQoUHS704GDwcViLufl/QnaMSoI6kpDp28L+WesRvrZdM8
X-Gm-Message-State: AOJu0Yww7Fv16RkFHSm9aWi/WK/N06iLjSEFUCfpEdvc3+9iyYoeSbyj
	DuyCARY0cZu2KeDxh+hY5KZn4uf1DoYFPuAZ+Q6bltqnpMeLDw3D
X-Google-Smtp-Source: AGHT+IGWJqgik5r0KRyy0gH8XXTSGkGWZZuaYd9E3vCv3twemfyRlBVnnzOttpR49pl8bTCWvS/pNA==
X-Received: by 2002:a05:6a21:6d9f:b0:1a7:55a3:ab with SMTP id wl31-20020a056a216d9f00b001a755a300abmr72379pzb.22.1712400976621;
        Sat, 06 Apr 2024 03:56:16 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id d26-20020aa7869a000000b006eab6f3d8a9sm2959675pfo.207.2024.04.06.03.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Apr 2024 03:56:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 20:56:04 +1000
Message-Id: <D0CZHAYST4M9.193BR8RVK0KJK@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
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
Subject: Re: [kvm-unit-tests RFC PATCH 17/17] shellcheck: Suppress various
 messages
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-18-npiggin@gmail.com>
 <20240405-7c0ad5d3ce76e1ad9ad2f5a9@orel>
In-Reply-To: <20240405-7c0ad5d3ce76e1ad9ad2f5a9@orel>

On Sat Apr 6, 2024 at 12:55 AM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:49PM +1000, Nicholas Piggin wrote:
> > Various info and warnings are suppressed here, where circumstances
> > (commented) warrant.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  run_tests.sh            | 3 +++
> >  scripts/arch-run.bash   | 9 +++++++++
> >  scripts/mkstandalone.sh | 2 ++
> >  scripts/runtime.bash    | 2 ++
> >  4 files changed, 16 insertions(+)
> >=20
> > diff --git a/run_tests.sh b/run_tests.sh
> > index 938bb8edf..152323ffc 100755
> > --- a/run_tests.sh
> > +++ b/run_tests.sh
> > @@ -45,6 +45,9 @@ fi
> >  only_tests=3D""
> >  list_tests=3D""
> >  args=3D$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,ver=
bose,list,probe-maxsmp -- "$@")
> > +# Shellcheck likes to test commands directly rather than with $? but s=
ometimes they
> > +# are too long to put in the same test.
> > +# shellcheck disable=3DSC2181
> >  [ $? -ne 0 ] && exit 2;
> >  set -- $args;
> >  while [ $# -gt 0 ]; do
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index ed440b4aa..fe8785cfd 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -44,6 +44,8 @@ run_qemu ()
> >  	if [ "$errors" ]; then
> >  		sig=3D$(grep 'terminating on signal' <<<"$errors")
> >  		if [ "$sig" ]; then
> > +			# This is too complex for ${var/search/replace}
> > +			# shellcheck disable=3DSC2001
> >  			sig=3D$(sed 's/.*terminating on signal \([0-9][0-9]*\).*/\1/' <<<"$=
sig")
> >  		fi
> >  	fi
> > @@ -174,9 +176,12 @@ run_migration ()
> > =20
> >  	# Holding both ends of the input fifo open prevents opens from
> >  	# blocking and readers getting EOF when a writer closes it.
> > +	# These fds appear to be unused to shellcheck so quieten the warning.
> >  	mkfifo ${src_infifo}
> >  	mkfifo ${dst_infifo}
> > +	# shellcheck disable=3DSC2034
> >  	exec {src_infifo_fd}<>${src_infifo}
> > +	# shellcheck disable=3DSC2034
> >  	exec {dst_infifo_fd}<>${dst_infifo}
> > =20
> >  	"${migcmdline[@]}" \
> > @@ -184,6 +189,8 @@ run_migration ()
> >  		-mon chardev=3Dmon,mode=3Dcontrol \
> >  		< ${src_infifo} > ${src_outfifo} &
> >  	live_pid=3D$!
> > +	# SC complains about useless cat but I prefer it over redirect here.
>
> Let's spell out 'shellcheck' when referring to it rather than call it
> 'SC'. And instead of "but I prefer..." let's write

Okay I got reminded why I did this, because starting # shellcheck blah
makes shellcheck try to parse it and fails. We could use # * shellcheck
for comments?

Thanks,
Nick
