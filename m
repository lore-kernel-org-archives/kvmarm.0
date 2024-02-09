Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580AC8493
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707467263; cv=none; b=EgRW6SNhfDK7KmZcddw9H5UHIFtgW21Wfkiuaq6n3nBR/rbYQEQS8nFj9bzLPibRha4szUxOPIZCSH+NcCk7hRu5Wiw8FCHptW4A2eH4Zyqqvz+0p7mWYFzNphl78C/Nzi76/Jgc5SFicGzbN/hflm0Se+fnwwXD26pJhOxIFyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707467263; c=relaxed/simple;
	bh=U8VJUtIod9p6s1XXmJezD1WyOaQkRBA6MsyQhUHRmn8=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=PG21BrvAO2VDx+nrx4c+DLkgejAehS+0ncrI4nX9+qMOgo8sdBHdvLWnlaLvGTim1TYqyqYAk1CkAtAgMnqy+TZiWQX0Vi5wyhv77DyEW6Z9t47QwDOLVLFOr7+/kG8rdJCoSh8aTGBaLin/tyheKhjKEIIQ37lukM8JZYs5fps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RMTe9dgT; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RMTe9dgT"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d7881b1843so6174825ad.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 00:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707467262; x=1708072062; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTTD1zUl6XbIoz3C+fDNL2dHgdo/Av/V6kztlCMET94=;
        b=RMTe9dgT3etUDWy5qgN3osa26dNufcnlLebI93xy9x5pxIXiazyAPPlHZRnhB9pJKM
         oL/+xaQQlrqsaIPhEkm61AuaS1L/ZACDCsDSFaIht2maf0DV0tkG71Af3KwOfNmPEafl
         91wvNOe+CQSa96IuP3ok4xbYJrsXXCic7+jiCOHk8Glhb4/ebPQ/qwc5yP0JjNO2mfGA
         i6O0RAsPtXqFGymqNNC4ZVsDtfp69MNAd9pJb1neaLZTV0BCGKd9lYUSOVK05Pajn5Xb
         WjxRb4INXsZXgYLGTn4Oxc9QFEkOrADreLfv1TnaUmIZ9ngGp6uHV4faso4k1fiPS5PA
         sv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707467262; x=1708072062;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MTTD1zUl6XbIoz3C+fDNL2dHgdo/Av/V6kztlCMET94=;
        b=fUEPvl3mByyOBOEqttLfR7MXHS1Isxj7fMJbyvA20v6LKcJpcpm1+dEGS7pNRvQbi6
         GxECmMejx5VCn6aM+V846Dy+SXmhCaLmO7D1Gx9aF1hk26Zz4LerYpkxk8T/qfqkd3te
         78xdsJjRDrRORHJe/S68S+5sX09Z5EUSjZxoMkm2yWCWIy3lz+1n/yLH+JnReLfW52C0
         5PCYCOVLo7ivmnSIjG235oZ6mnmJs3bG5ilied/mfCcN/jW7FxUw6R7OMhx9TIptC/nr
         Nn8wDGyLnid5Rg8BzbCu84kgxBg/XXeLgrbbOJbaEgxSPpzgNmM7R23IRPQA6ovQk1Rr
         g1Ew==
X-Gm-Message-State: AOJu0YyZWod1UspQ8rdMus7LWYCsDONl5SMHvGdRSciP77pI4IlPGneD
	jCwNEOd1Ilwv8qSkyENhtGxxJwO7oXWA3KR+YTjks5aVna0EZPluayTUBK1B
X-Google-Smtp-Source: AGHT+IG5BMthemltiiFcIr8v360fN9gt+99vayEmFyCcvEZHyJpxukdjW15W7pZ34jdmNysLP/78mg==
X-Received: by 2002:a17:902:f7cf:b0:1d9:93d2:5208 with SMTP id h15-20020a170902f7cf00b001d993d25208mr848603plw.49.1707467261671;
        Fri, 09 Feb 2024 00:27:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVf8VYvdZg1I9yYmtndJcECe7KBKpqawuTH71hxKTK10aCEzRGDcfp3x9IY0+mu45sKSfxMDCWOrm7OBeiIWjO8ccl1e/i7CzEyWzzRtpFkUwhl4kXYpMLRDcTNGBczKQG1R0+mRRS68AMbYgcHbyhRuTBvr46GlbLZovYZHTxRZ4DhLqtitlTUzfcxSR49t8OWGM6YDUh7XCxZtpsCc8VuoPfHjT0+rs5SVlVBwZuN/OeAhQ2MJlI8oE3bR8/55mwTUjleK8apXPQoAXDXhaolhb1P/oXRjLrAox/02p5e+POLA5rq5izQCWv+jBsnz1rtpokU0wN5cZrjiavgUUkNyTdxtwiIW9iLXityb25p3YcPAWe0bZs7KLkEXgYsfHjQEIPE8YL1yScD1T7MriDMFFouTvMeFpKkov+d+jNbRPZbS7+iqWptbJsiS9Vgo5BmatDLUAxRGIsXaP0bdS/okn8LIK4SvNr+T7OptWixdDpsjq5g7JPIJgD0FM1y2QCyqTq7IlNB02O1dFmmO8apGGvY
Received: from localhost ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001d91b617718sm1014472plk.98.2024.02.09.00.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 00:27:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Feb 2024 18:27:32 +1000
Message-Id: <CZ0EMJ56C8WS.1RRW73R6KWDEQ@wheely>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>
Subject: Re: [kvm-unit-tests PATCH v3 2/8] arch-run: Clean up initrd cleanup
X-Mailer: aerc 0.15.2
References: <20240209070141.421569-1-npiggin@gmail.com>
 <20240209070141.421569-3-npiggin@gmail.com>
 <9fb2f113-db36-41a6-a6f2-0499f28ace0a@redhat.com>
In-Reply-To: <9fb2f113-db36-41a6-a6f2-0499f28ace0a@redhat.com>

On Fri Feb 9, 2024 at 5:32 PM AEST, Thomas Huth wrote:
> On 09/02/2024 08.01, Nicholas Piggin wrote:
> > Rather than put a big script into the trap handler, have it call
> > a function.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   scripts/arch-run.bash | 13 ++++++++++++-
> >   1 file changed, 12 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 11d47a85..1e903e83 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -269,10 +269,21 @@ search_qemu_binary ()
> >   	export PATH=3D$save_path
> >   }
> >  =20
> > +initrd_cleanup ()
> > +{
> > +	rm -f $KVM_UNIT_TESTS_ENV
> > +	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
> > +		export KVM_UNIT_TESTS_ENV=3D"$KVM_UNIT_TESTS_ENV_OLD"
> > +	else
> > +		unset KVM_UNIT_TESTS_ENV
> > +		unset KVM_UNIT_TESTS_ENV_OLD
> > +	fi
> > +}
>
> Looking at the original code below, shouldn't this rather unset=20
> KVM_UNIT_TESTS_ENV_OLD after the "fi" statement?

Yes good catch.

Thanks,
Nick
