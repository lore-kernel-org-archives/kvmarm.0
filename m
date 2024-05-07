Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5344A12
	for <kvmarm@lists.linux.dev>; Tue,  7 May 2024 04:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715056014; cv=none; b=m9A6eYyYvUpnARCCKFiSOxxk9FEsvb/gTpZ6FVBjexAcpcC0NRXX850R8K4hCKapgYTYBIt7lj9TnZYrOm9K8aW+RPKuUph2ugFghstHmzPgd+GJBjhaZOEkXmYsK1IWDPcUyxiIExtP95A2B/po1XrFR6G9E8WQNQDMY13aMwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715056014; c=relaxed/simple;
	bh=9mmi+4eXxyPc+AGhQY8hiFi8r/8Xf3FE40SXpT1xnZY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=NlI8Xinc/9n78WdvgGrRIruXZKJi/LMRMQC/7D/Cf+ctdALlgwmfWxtF8wsCUcNgWdjo3/LXIqTJOlF4F0VALqslG6yHbr4evWm32ZqRYJ6t+smTRrkdCuW6OcLN6tegUwLguMDS/yG+TSbOzGm3uvhBdW4UZ+RSBi5SFbl+Ugc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gUyeVmQh; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUyeVmQh"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f4178aec15so2293445b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 06 May 2024 21:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715056012; x=1715660812; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SET443Ur2sy7zusGe/FfwjRKw7kCoank7nOsfIi/Nos=;
        b=gUyeVmQhnUJrWNQ2vPEG0vuDK6WTFL4o3enMYbC2dsBCIEMEJ1U+VOsTlbOir1NBTg
         UkdL9aHssJcEBbC2GM+8M9QMXFhkjfdnyrZNoozk7ovNEseVEuRMOIIPkWPNgzStFp5/
         a3+G30VqULCMcv/8E2+QfVtlekNJUtAJylGLsVPifdG+9stJcqL7KJuM7PTSbTOwagc4
         65flU1ILMdkKq569lygSI7Zs9aDXCxKyPVe0q3NpGGd2Hm+ND0Tvdtlrok0jFaA2dcUo
         pmitZA5AvhzDBDESkDQ2Yo9fSo/rpFqMdrAwAMzkT38K1kkWQ6arSMkqXI6j21Z5r88P
         narw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715056012; x=1715660812;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SET443Ur2sy7zusGe/FfwjRKw7kCoank7nOsfIi/Nos=;
        b=SbMCu7N7fpcMDlF0aC35i/4sg1J083XF6ZglzpEZgxgD6/FAmpJ4vAeI84EZu/24iP
         ICx4RunEo35WZECwiA2M0sPKN9mCs9U9PCMXpT4IJMa1NqwAsMkRDv+DTCONfU9DL7qW
         DsTm4DjZVRKtVM3EnQfaXpJKlLi7SYFj6cZDsoHZIhHN20o4WzVHsERDAWZu/eRCGiRX
         qWvFjkwAfD2vAls59J3DlIVIJxZGz89EELth09nv29ZJDyqP8KW810oOLFCy+y5NDxrL
         tI7jJPZ2WRGwOoEAshx3FOa8NCxngowEnss22F/9RbP8zBU2JwMKiMRb/ZJzLRI9pbGl
         ZBsw==
X-Forwarded-Encrypted: i=1; AJvYcCWF1wJc8jb0HJY3r8SYkdAf02ZdWarbwF7ozEOE2VgQ/uWnNd+Qn8nwMr+cprR4gskba8ULYmzsrtyF+lV3q9RVuETTjHol
X-Gm-Message-State: AOJu0YzoE8rjYupWhpGfIPorPKECz2DVnJPGkoKgm3GzYfNwt6Kl3HsT
	E/wjgNTuALShF/4/PjWTVeblfWST+fjHo+nGAtB5BJSTlcpyRmuL
X-Google-Smtp-Source: AGHT+IEbrw+HqIan0YSI260qGCZvgjZvgTGovltPsStW/HC6SunqrpugXSUtJ2iqVRnywfvyMFvAXQ==
X-Received: by 2002:a05:6a20:d493:b0:1af:363d:64f5 with SMTP id im19-20020a056a20d49300b001af363d64f5mr11869208pzb.39.1715056012326;
        Mon, 06 May 2024 21:26:52 -0700 (PDT)
Received: from localhost (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id ko15-20020a17090307cf00b001e3cfb853a2sm9099752plb.183.2024.05.06.21.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 21:26:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 May 2024 14:26:42 +1000
Message-Id: <D134M2NGQTR1.227OAJT9O1VEM@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "David Hildenbrand" <david@redhat.com>, "Shaoqin Huang"
 <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "David
 Woodhouse" <dwmw@amazon.co.uk>, "Ricardo Koller" <ricarkol@google.com>,
 "rminmin" <renmm6@chinaunicom.cn>, "Gavin Shan" <gshan@redhat.com>, "Nina
 Schoetterl-Glausch" <nsg@linux.ibm.com>, "Sean Christopherson"
 <seanjc@google.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240501112938.931452-1-npiggin@gmail.com>
 <2be99a78-878c-4819-8c42-1b795019af2f@redhat.com>
 <20240502-d231f770256b3ed812eb4246@orel>
 <28975cc5-ef8f-4471-baca-0bb792a62084@redhat.com>
 <D0ZQV7VH839A.3RQVN9RKAGH2N@gmail.com>
 <4b934481-49f9-42e6-87f5-74318f2597db@redhat.com>
In-Reply-To: <4b934481-49f9-42e6-87f5-74318f2597db@redhat.com>

On Fri May 3, 2024 at 3:13 PM AEST, Thomas Huth wrote:
> On 03/05/2024 07.02, Nicholas Piggin wrote:
> > On Thu May 2, 2024 at 7:34 PM AEST, Thomas Huth wrote:
> >> On 02/05/2024 10.56, Andrew Jones wrote:
> >>> On Thu, May 02, 2024 at 10:23:22AM GMT, Thomas Huth wrote:
> >>>> On 01/05/2024 13.29, Nicholas Piggin wrote:
> >>>>> This is based on upstream directly now, not ahead of the powerpc
> >>>>> series.
> >>>>
> >>>> Thanks! ... maybe you could also rebase the powerpc series on this n=
ow? (I
> >>>> haven't forgotten about it, just did not find enough spare time for =
more
> >>>> reviewing yet)
> >>>>
> >>>>> Since v2:
> >>>>> - Rebased to upstream with some patches merged.
> >>>>> - Just a few comment typos and small issues (e.g., quoting
> >>>>>      `make shellcheck` in docs) that people picked up from the
> >>>>>      last round.
> >>>>
> >>>> When I now run "make shellcheck", I'm still getting an error:
> >>>>
> >>>> In config.mak line 16:
> >>>> AR=3Dar
> >>>> ^-- SC2209 (warning): Use var=3D$(command) to assign output (or quot=
e to
> >>>> assign string).
> >>>
> >>> I didn't see this one when testing. I have shellcheck version 0.9.0.
> >>
> >> I'm also using 0.9.0 (from Fedora). Maybe we've got a different defaul=
t config?
> >=20
> > I have 0.10.0 from Debian with no changes to config defaults and no
> > warning.
>
> If I understood it correctly, it warns for AR=3Dar but it does not warn f=
or=20
> AR=3Dpowerpc-linux-gnu-ar ... could you try the first term, too, if you=
=20
> haven't done so yet?

Ah you're right, that does warn here too.

Thanks,
Nick
