Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859C98614D
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718354343; cv=none; b=LavoaO7uAdJEuRtXylaSTz8KMLfmSv3t8bwp6Vhms+oVm7okoDYgpgHuQfsNlqT0eEdtCGe7lesNS48ENltvWkH4nmcQnCu8xIKzTWbtmP92MXoF2FmstlOa7J3Odu6K16qTyO3EnAEsXN4ZgVf8GBCORg+qvwXomr+f0Ev3V+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718354343; c=relaxed/simple;
	bh=RVJ3HNfS/LTVgt0bhHVJerIJHiZbdVxp4/zR+A9dP3w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=LRQ3zaL5bpF8ANDTqgKGHFrJ1qTDWpE/uEGBTplqqoFbLySDmh2M1tAUBgv2EhqF58XGxTyb51D3yu+Ax8wtUpzYIZZmZ1cH3iEksZ6624+KTlJZOd5KKdJ4h43NtXBz3Xb0yD1NJ7ONkUUhgmQGL4ZCc6LP9EN03ZZpRoV3WXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T9JT58FQ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9JT58FQ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f8ec7e054dso1292932b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 01:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718354342; x=1718959142; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGy8Qk7vHjHfh3JaIY/2KaWeJmy159LbqRE46FH8bXg=;
        b=T9JT58FQk4bSjf/ho0fC8tzGpiXhY5+t7IMh2HpLs7lpRsL4IKnkk9BysmB+Gqwx2s
         OONROINFW8meJJb1qDwEQD4aVA4gREzXqAfZnU+33fpba9+TU760hQduPqc5UN+VdMH6
         l+lqNt9jPWBuKmjhpN6YJyABLFG/gbpm5msv8VO5zdAxKcg9zkNRVSIvwh1zrTCQxqwG
         LpbBmfcAJ+LwjG0eaPaS6krx+FCQqX1MYa60jIQVp76G/seMjU8yqqjvNxEUCA5iMg5f
         b3arVZ+HmCXsey8T8vq6AkpR3obkJeoZQVJCBzBFERw1OvOThjPdp1+AK49Wph/Hy+GV
         f20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718354342; x=1718959142;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NGy8Qk7vHjHfh3JaIY/2KaWeJmy159LbqRE46FH8bXg=;
        b=i5F6GBIoXQdx/Y/drddCYcpqNn8I/VXzf7dfm9ObFI5psa/v3NIDbKl8o3wmIPIpec
         B4oIVPpLAoZq7OeyGJudHCbFjYplAaIlRKiDkJtvjmgdxAWUVQDxG9X5UDWF/TkwH7gA
         9WErj05MH8fmIkVHwHOMuLgCXly5R/+f1V+RBxjRS/KQJa+ovpZR72UWCyHBB7dTTkV6
         d7CCr4m/ALZ/gf/IymNpMIKN9xIU7TNbsjCCzIezI2spcij1SneL30CxZL0bboOP4J5G
         LgdD6P2sG5dlR7JtBMmMJswnui6VP+vLIkla5JMVWCJljTExNL5ZdRVnpvpp4Rd4w2e9
         D41Q==
X-Forwarded-Encrypted: i=1; AJvYcCXce7SlL7+zSTv894ScekBjsduUQQ7pE7wT0CeE9pKTss6gN5vIAoMHEllkhTZaS2V/wTHrLVs7RZkDjTdeutZxzT9DOrlc
X-Gm-Message-State: AOJu0YwqYCc+srLIQeWHhcgcgRuHrylwsrCKANtz9p+GuevZOu2Vh7dH
	ckB8nAFYjyf6/4mjCsoljgW4J8OsAF1nYyevAtVqxWGv5zv8KgpL
X-Google-Smtp-Source: AGHT+IE6pXW+ie68+vtXwkMfCghwPmHr4/AQacJLhgnTEyIreahfjP48hPsxIsT9zufhQ8cyfHE9eg==
X-Received: by 2002:a05:6a21:81a9:b0:1b5:69cd:87c with SMTP id adf61e73a8af0-1bae7e88366mr2104777637.27.1718354341640;
        Fri, 14 Jun 2024 01:39:01 -0700 (PDT)
Received: from localhost (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a769beb8sm5500935a91.41.2024.06.14.01.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 01:39:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Jun 2024 18:38:54 +1000
Message-Id: <D1ZLRVNGPWTV.5H76A3E8DJCV@gmail.com>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
 <linux-s390@vger.kernel.org>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <kvm-riscv@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o
 targets
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
X-Mailer: aerc 0.17.0
References: <20240612044234.212156-1-npiggin@gmail.com>
 <20240612082847.GG19790@gate.crashing.org>
 <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
 <20240614010856.GK19790@gate.crashing.org>
In-Reply-To: <20240614010856.GK19790@gate.crashing.org>

On Fri Jun 14, 2024 at 11:08 AM AEST, Segher Boessenkool wrote:
> On Fri, Jun 14, 2024 at 10:43:39AM +1000, Nicholas Piggin wrote:
> > On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
> > > On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> > > > arm, powerpc, riscv, build .aux.o targets with implicit pattern rul=
es
> > > > in dependency chains that cause them to be made as intermediate fil=
es,
> > > > which get removed when make finishes. This results in unnecessary
> > > > partial rebuilds. If make is run again, this time the .aux.o target=
s
> > > > are not intermediate, possibly due to being made via different
> > > > dependencies.
> > > >=20
> > > > Adding .aux.o files to .PRECIOUS prevents them being removed and so=
lves
> > > > the rebuild problem.
> > > >=20
> > > > s390x does not have the problem because .SECONDARY prevents dependa=
ncies
> > > > from being built as intermediate. However the same change is made f=
or
> > > > s390x, for consistency.
> > >
> > > This is exactly what .SECONDARY is for, as its documentation says,
> > > even.  Wouldn't it be better to just add a .SECONDARY to the other
> > > targets as well?
> >=20
> > Yeah we were debating that and agreed .PRECIOUS may not be the
> > cleanest fix but since we already use that it's okay for a
> > minimal fix.
>
> But why add it to s390x then?  It is not a fix there at all!

Eh, not a big deal. I mentioned that in the changelog it doesn't seem to
pracicaly fix something. And I rather the makefiles converge as much as
possible rather than diverge more.

.SECONDARY was added independently and not to fix this problem in
s390x. And s390x has .SECONDARY slightly wrong AFAIKS. It mentions
.SECONDARY: twice in a way that looks like it was meant to depend on
specific targets, it actually gives it no dependencies and the
resulting semantics are that all intermediate files in the build are
treated as secondary. So somethig there should be cleaned up. If the
.SECONDARY was changed to only depend on the .gobj and .hdr.obj then
suddenly that would break .aux.o if I don't make the change.

So I'm meaning to work out what to do with all that, i.e., whether to
add blanket .SECONDARY for all and trim or remove the .PRECIOUS files,
or remove s390x's secondary, or make it more specific, or something
else. But it takes a while for me to do makefile work.

Thanks,
Nick
