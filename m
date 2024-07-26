Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F242261D
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 04:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721967310; cv=none; b=tUpceh2xRnQ/WHfeUkTp3/43c+N23hnq5X1nsDA/e7ydEigNRFq5hmTDkmUBrrGnis+JDL/fzE0ih7tpJRLPyMcLK/KzMjc+FwtSPPMCpWRunsitkD9zyh/TPI60VcrtSMYNlY+XSWI/n5bG4PPjBAObAElBG3v0Wr+lKO2Xj0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721967310; c=relaxed/simple;
	bh=gIKFqyMJQYAqXJDAdieEmwb8TBBzQrThuJSv7pNtuRM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=pjSgywLhGShV8YS0sy0kmnsy85qgeT4wkI7e1XJy1wYhiFnni4sUY5Ro7Wv7EVCgyK06+jS0CwTKld4qekdT1MPHfc1K1PzgkSpkG99UZNhkJ7rOXPCZ/ZhpumE3TOHznDmJ8cnqFAeYshIZxTqUCGSccPC7HOJC4FSXJEe1mwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aDlv0UCd; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aDlv0UCd"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2cb63ceff6dso426847a91.1
        for <kvmarm@lists.linux.dev>; Thu, 25 Jul 2024 21:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721967309; x=1722572109; darn=lists.linux.dev;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3jDQgJjkOPkFdNASGIQMdZJ31Vgc4apYAqzb/U5CKI=;
        b=aDlv0UCdoQFDZ52zOMw6VteCVPclthXU+QhxZXRLOrtyxJXhGO3CZOQInQPi9Rkoh5
         i8Cmw7STErTvZisTsx32B8KIZGTQYRrxOJUzpbpzbUJmCQLX32TheeEBQRXGDRkUiMVD
         G8XbJ6NfHY83d7nhD29PkYYvX0iQrjEuUaOp1pq1ySwQQCDkc+bIXLJCaP9+b2i6iDoL
         CipVUoVYulMHJcEvIl4+ockcWbSnlbBsSduOeJ1ewy+USZjxJAieEsaaexfN0v+/J8nW
         /Wysa7/E8bwPAEKf6ZYOg/IPd0AS3XX5miOcFVtehbw/WcAP29Hveun3iLmkAlwiss9Y
         ypHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721967309; x=1722572109;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f3jDQgJjkOPkFdNASGIQMdZJ31Vgc4apYAqzb/U5CKI=;
        b=qVK0E/+h/+LtSEF/8pmqQYgah1r8ldNwJaM65AnQy1urzg+CMPkPOz8hRAqERjogwl
         iWUAVL4NmGKMJmAfyaoOcsJUPnf5gTf5JpD+3g+2rUfQca97NqTi/n6reAQHZXgi9QT3
         tLL6t//F96wSFSuFYHBAPQVmsrp1cbhBNEHjqjHtmEcVVbrmb5EgOxdvm9scWO9wagkj
         8gKHAAPvrYg1o1kX0/2i/i44km2kAisDwE4VcSertSuAU3bvn9GEr7vNs6rN1YqqfP+F
         +1g/OdflJqA9/Oyi07lFUPBN6ix9bAnPexxyH3TZkmiGFUJDP9mbznD9dQEXrlMzF1wr
         g+0A==
X-Forwarded-Encrypted: i=1; AJvYcCXnTMPzlylR0rvEzt9qkhofyVgrs7+3TldcuF46AdTYPYYPQd/vEss0MTRHml139BtWDV+eRhUi5BH/QLdekGrMvtRJvX0o
X-Gm-Message-State: AOJu0YwNay4/C7IAReSxJx6CMBJWGH5wWEF/58SITVmOwysGk3Ic1YnJ
	dWFCNipJxWEGfj2J13uKG+nERurFYRRZsPe7F8xd5vqxodDJy3K3
X-Google-Smtp-Source: AGHT+IFmN17I4J5GSEbfLIh57WYix6Z4DqY06Of+f+JtOC/7oBUIVl0iyJ5AherVGcrUqk8gycWzzw==
X-Received: by 2002:a17:90b:3e8b:b0:2c8:538d:95b7 with SMTP id 98e67ed59e1d1-2cf238ccb87mr5415523a91.32.1721967308684;
        Thu, 25 Jul 2024 21:15:08 -0700 (PDT)
Received: from localhost ([1.146.16.227])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28c9cef7sm2365286a91.29.2024.07.25.21.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 21:15:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jul 2024 14:15:00 +1000
Message-Id: <D2Z6GP2VFOJ8.2KU7OB25CUXTC@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o
 targets
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nicholas Piggin" <npiggin@gmail.com>, "Segher Boessenkool"
 <segher@kernel.crashing.org>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
 <linux-s390@vger.kernel.org>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <kvm-riscv@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.18.0
References: <20240612044234.212156-1-npiggin@gmail.com>
 <20240612082847.GG19790@gate.crashing.org>
 <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
 <20240614010856.GK19790@gate.crashing.org>
 <D1ZLRVNGPWTV.5H76A3E8DJCV@gmail.com>
In-Reply-To: <D1ZLRVNGPWTV.5H76A3E8DJCV@gmail.com>

On Fri Jun 14, 2024 at 6:38 PM AEST, Nicholas Piggin wrote:
> On Fri Jun 14, 2024 at 11:08 AM AEST, Segher Boessenkool wrote:
> > On Fri, Jun 14, 2024 at 10:43:39AM +1000, Nicholas Piggin wrote:
> > > On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
> > > > On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> > > > > arm, powerpc, riscv, build .aux.o targets with implicit pattern r=
ules
> > > > > in dependency chains that cause them to be made as intermediate f=
iles,
> > > > > which get removed when make finishes. This results in unnecessary
> > > > > partial rebuilds. If make is run again, this time the .aux.o targ=
ets
> > > > > are not intermediate, possibly due to being made via different
> > > > > dependencies.
> > > > >=20
> > > > > Adding .aux.o files to .PRECIOUS prevents them being removed and =
solves
> > > > > the rebuild problem.
> > > > >=20
> > > > > s390x does not have the problem because .SECONDARY prevents depen=
dancies
> > > > > from being built as intermediate. However the same change is made=
 for
> > > > > s390x, for consistency.
> > > >
> > > > This is exactly what .SECONDARY is for, as its documentation says,
> > > > even.  Wouldn't it be better to just add a .SECONDARY to the other
> > > > targets as well?
> > >=20
> > > Yeah we were debating that and agreed .PRECIOUS may not be the
> > > cleanest fix but since we already use that it's okay for a
> > > minimal fix.
> >
> > But why add it to s390x then?  It is not a fix there at all!
>
> Eh, not a big deal. I mentioned that in the changelog it doesn't seem to
> pracicaly fix something. And I rather the makefiles converge as much as
> possible rather than diverge more.
>
> .SECONDARY was added independently and not to fix this problem in
> s390x. And s390x has .SECONDARY slightly wrong AFAIKS. It mentions
> .SECONDARY: twice in a way that looks like it was meant to depend on
> specific targets, it actually gives it no dependencies and the
> resulting semantics are that all intermediate files in the build are
> treated as secondary. So somethig there should be cleaned up. If the
> .SECONDARY was changed to only depend on the .gobj and .hdr.obj then
> suddenly that would break .aux.o if I don't make the change.
>
> So I'm meaning to work out what to do with all that, i.e., whether to
> add blanket .SECONDARY for all and trim or remove the .PRECIOUS files,
> or remove s390x's secondary, or make it more specific, or something
> else. But it takes a while for me to do makefile work.

Hi Thomas,

Ping on this patch?

Thanks,
Nick
