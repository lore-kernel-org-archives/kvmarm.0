Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673B62E3F3
	for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 11:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708343908; cv=none; b=qPux1SAF+F/rpirJXDf1eC4BB7rgKa/Wp8jayAu40IAiNEB+QaQF+HamhL7DgNx+DLZqWRmalpmGQOYDr+/iLxEM1YAJUNl7dIK+IUKL4TeNvQidcuvNaWxhKwUPK0QH2BnvclpLcbKTXByZTyajSFQwtbeUNQ+848XbldeJcRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708343908; c=relaxed/simple;
	bh=nJstLW9esmyElWFns2CzFB95hhSHbzyVH5WsxNSFQ2U=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=d1jXExACn2gI9Nf6sVyv/VVVeqPG283ZQpMNqPg6PaXRKmox9snZiAZo+WsHpP8H0fXfYAGUyy1NPL56aVJz+1Q+k2SJaOeEqNjoteFn4uEzGyzsuU7lNGcRi2JMDjU1HF7fysHqtGpFVlozhhOipOweilIsArkO6NX9bo0qmpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjbSS4Wy; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjbSS4Wy"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1db5212e2f6so30109725ad.1
        for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 03:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708343906; x=1708948706; darn=lists.linux.dev;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qtKD19qauwfMDNEwLgCb7I5KxV73UoCs2lBAo1NZd7g=;
        b=jjbSS4Wy31j4/Ntyka4H4aAgx7PXaGMifS6mQoFbaTJrrT84wTDtRjHzPXk+umCGcv
         Je3jZmo5Qi81MxVDcK5U+qiNNnZ5WlaqkGBEoxpTlxd+zlCgx/Kz5RMoKRk3YYOIL/5E
         SbiCKLWZr+28+ud0eG/qqHcE5+NiGYncM42u2TfK7FHb6R7Bzbk73tZPerytLMIJX7PO
         bCUvrEsrArwPkriPPV6tSUkzwtXLQh/6mvwWm90W3JlWtgfgNYdW7aTCBmHtPbqaPBfU
         1EGN+cZW4ObaoOu7lISy5Tt6BGBevuhRngnDZlKoB9LXgCUSqWxnGyCihCZP0IoLPNhU
         RmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708343906; x=1708948706;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qtKD19qauwfMDNEwLgCb7I5KxV73UoCs2lBAo1NZd7g=;
        b=Woi2aDnhuu97KO1eSS1+okYwuHzi2HNjtANKQ4P+oCN7D0rESE+U4DokzFJZtGvq1J
         hT9w1lbqS/cRLrAPG3jRQVvRy2b2Wf40IS2x9b+VTMT1bBb0Oil1LhAoNMmFEfpuQWct
         YR+2F+NVzeHcm0f68DY3jtVnRkRg/Y/qXr7k55SpH2Q9/MSVJ9wFpib2epi1DBikz2um
         eIoRhFDFGiuOZu0CEDtjDZe8LjRgUf2ptKSCoB8y1i+2nTpwqO/ZdiyeQ9/q+rxfbHt9
         rD7RzZaNq3F2grMyvbmEP8X3TD2mNNiH6RXVER6u2dZsw3kbgwIqSoDVUPnReVVvhxdq
         JLZA==
X-Gm-Message-State: AOJu0Yy3cIf7q/wKBSnyYYYP9tGBhHCEMIensynPuA/QWCiQHtFrQvgh
	5QCoReOD6mo9Km+TiEyE/xyZxFY+tALVbLATPAsYxMPepbRJlu/P
X-Google-Smtp-Source: AGHT+IE9b6RC9oHbAhWZTL2lD+mu5223dNrNzrbJxmVB0cgYIkGUcQQPDPnjzMu1ezsyMOuXvHSLQg==
X-Received: by 2002:a17:902:e84a:b0:1db:e41f:bab with SMTP id t10-20020a170902e84a00b001dbe41f0babmr5023569plg.32.1708343905564;
        Mon, 19 Feb 2024 03:58:25 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709028c8c00b001d949393c50sm4178505plo.187.2024.02.19.03.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 03:58:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Feb 2024 21:58:20 +1000
Message-Id: <CZ91DDIGOAMM.3RLL24M34FXGK@wheely>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Alexandru Elisei" <alexandru.elisei@arm.com>,
 "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>
Cc: <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
 <CZ7AJ4JK5805.2N5QS85IP42QZ@wheely>
 <4986756f-6230-421b-9601-054c6c2969e8@redhat.com>
In-Reply-To: <4986756f-6230-421b-9601-054c6c2969e8@redhat.com>

On Mon Feb 19, 2024 at 4:59 PM AEST, Thomas Huth wrote:
> On 17/02/2024 11.43, Nicholas Piggin wrote:
> > On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
> >> getchar() can currently only be called once on arm since the implement=
ation
> >> is a little bit too  na=C3=AFve: After the first character has arrived=
, the
> >> data register never gets set to zero again. To properly check whether =
a
> >> byte is available, we need to check the "RX fifo empty" on the pl011 U=
ART
> >> or the "RX data ready" bit on the ns16550a UART instead.
> >>
> >> With this proper check in place, we can finally also get rid of the
> >> ugly assert(count < 16) statement here.
> >>
> >> Signed-off-by: Thomas Huth <thuth@redhat.com>
> >=20
> > Nice, thanks for fixing this up.
> >=20
> > I see what you mean about multi-migration not waiting. It seems
> > to be an arm issue, ppc works properly.
>
> Yes, it's an arm issue. s390x also works fine.
>
> > This patch changed things
> > so it works a bit better (or at least differently) now, but
> > still has some bugs. Maybe buggy uart migration?
>
> I'm also seeing hangs when running the arm migration-test multiple times,=
=20
> but also without my UART patch here - so I assume the problem is not real=
ly=20
> related to the UART?

Yeah, I ended up figuring it out. A 11 year old TCG migration memory
corruption bug!

https://lists.gnu.org/archive/html/qemu-devel/2024-02/msg03486.html

All the weirdness was just symptoms of that. The hang that arm usually
got was target machine trying to lock the uart spinlock that is already
locked (because the unlock store got lost in migration).

powerpc and s390x were just luckier in avoiding the race, maybe the way
their translation blocks around getchar code were constructed made the
problem not show up easily or at all. I did end up causing problems
for them by rearranging the code (test case is linked in that msg).

Thanks,
Nick
