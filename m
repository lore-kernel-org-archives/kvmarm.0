Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2B730ACE5
	for <kvmarm@lists.linux.dev>; Wed, 18 Feb 2026 21:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771449499; cv=pass; b=Hstbyq4Eijjiy/Vu5acI8KlqI5tquCY9SqH+uijWuB2yihngN0qr49kZvmj4Y3CJdfWkz6AJfkEAylh3NS9WtV3Hf+LzgpC0EMQlHzRDaiDtmH649/0MTTD+HZAMH0PteV3JMfwuOCq79+X1PfJAP//kU2LgY7ciOGxVI9xwWqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771449499; c=relaxed/simple;
	bh=5cLwRqYxV6p9+NMROAjhUeJBi41cRmDUq1ZyY3bDzD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pE11ES5QjBzJ1ANQCBh3hwQq4ZGr7a+/DlE31baq/NRWfOcUy1otLokduqOy6K95lxmAFpB2D8MOwW5rRZJYnS/M3hjGJUeQNCMpEt55+cGnQMnyjmYU8br9JhVCg2n4WbNo0DyvAkCrryegFehtjwtQCZ3GDsXWQxy5bAuTD/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EdpRijnz; arc=pass smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EdpRijnz"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-948a2d37896so188001241.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Feb 2026 13:18:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771449498; cv=none;
        d=google.com; s=arc-20240605;
        b=lBqE/HgSDHlcyUHjsg5pTLRSoBQs4vceDlUaDIr3DrPxBfXTCc+LLteiCGhpBrNZBS
         SBvtxFEbh5nARAW0jEb5YIu9fpHKMYRc8N2lrBJiFBLr/ym1x5oB7qcpMyDRnMYlWTkW
         Up8RFsERAVutYfJQswHxQAfDX1hfYPvX8p66t10dPRXVsnMMmPfU4/qkMwFBOwmbqx9r
         FG2hesZ7Rcwt1Yy+daV7g/tp6KA3xDuAp98Nx1ixH+cNHy2ukfzAMaTiu8EBPLQTw2fV
         McZlw+mLd8ikPBGJcPOhKOI9RukKYQLgxgrL90QLlK8zDOjYlYVckfj3RlanH4bOcITS
         L76w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bRlThRjj5FGBFKrZjR9u+oYoIGMr3781os1xSOsBbRo=;
        fh=cp1iWzNVS03QGTV3h7FguQMoiFwebq8glIGwzXgZt6k=;
        b=SgNn7xYa8wbcUJMJUMzFiMfm3Fyu8ljx2fdw4M1BcBSkmLGgADm/AiRmoEtsgbbujz
         Gx1DbIiJ0Tt+yuHJpyr/fr305Mb9ES+ZZzoyYgdbvSiiVxKmnLNDplra3OiSISeMPEUj
         WKrU94K9PP+FkMngxPNtok+IzGpUGJEyApL/gqsjCLf02aAedRcnSH1m1oi4I7ykeZGl
         ioAth0llAssnMl8buPa6Hf3Dr1Lyt7R6EQ7L1BG1oPalrgtv/62yfY3vi1+OxIQMp2qi
         0Gt1QG+aR4Txw2h+0eG0jgiLo1iXeOsDg05cs9jcgGqbqirZ9e549V7DX60sqd/sUYPR
         xYow==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771449498; x=1772054298; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRlThRjj5FGBFKrZjR9u+oYoIGMr3781os1xSOsBbRo=;
        b=EdpRijnzktl+VZyTk6xkgZiZw5Ayy7Kl1y1ASk95OkCDGVPdlCBBNwfSGFi62Fclhc
         IG8NEqzO/y6SE+kRoyBOB5iWzn/wldUgqdoVQy74MKe3QQLUx05x3PXgYsPFku6F2a5g
         zndTd+9JptAXgMvrfIxbInmnsboolzvromG/VGpBk0QF3od7kRbamjjWRypBssqAf1m1
         PWrduYRNWJeEbzGpbIngalLCYag7lQPTp81Z73SUs1kJHdzbutLjGEJ0GKEfi0zHaOGk
         hTAPbZDSyxLZHES/kCf/EzlsIr+p7Lgt6a6wE8SVQIQ9Ot2puiFSvQlrUqT6zBgReXyM
         qZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771449498; x=1772054298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bRlThRjj5FGBFKrZjR9u+oYoIGMr3781os1xSOsBbRo=;
        b=GSlZUZC4juW9oJ6pcKMO4uICNQQfQ8YmiGzwz5VOAnaL2xKtBmdNMmWzYdDRmoMwRk
         36OI9d2S3ztUEclME0RKv9r1KMV53kfqbBfoSvD3uQeyyb1NjC4IDKHdOoaSRmU7b5Sp
         DgeCLRU3agrrLzARB/9U7C58HTYtkunGKTpqgIBDYl6zlEWC5p6kAGtYDvfp6n4xI9Mt
         inE+gRKcXj5KtkQrWW509OxRGVWrdKKtb+cDPRblBhWNzXCmzu7zJco0O7A/YRTm9YqK
         l+d5Zz9yOkG9tQN33nIFdwT2hPhcTfq8KDmZAuOMdJkBwOQyhZGknMJaEkAVj4NgQMoW
         AsHw==
X-Forwarded-Encrypted: i=1; AJvYcCUw6feb5J5VZeui3ywupUYm+467fKIZu6LhOjX2llyB/S6wYPEzrIaO11vLQ/L6shnF+1pxHI4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwULzytJn6bf1NYQ3GSkmKIIUcsb8TyeW3PpsWHsktlODSO6i6i
	btTMa8/pYcnV2dYeHFiT5Ehu0kJYiBErhqyi/hhOuOud18wTy5GEPSqn+7Nsa2Ks/F4u15P62oV
	n9eaLbv0qUi9oG0G9EyTomWa9/LPpukDEaNc6ph0D
X-Gm-Gg: AZuq6aJOpk1WZ5OUccW6DWCIE0YXm+mFKDjF/en5ydMyWPWogtiucUvJPmZTRnhs8g+
	6mS8X8lVw7dJTmTb9vePr+R/SoNioqNcjdE4Z+ewCPl/3p70fU/7/JI6NzvTleTeJB3XrK8ExHc
	DBMiX0I9Wu/WOTyUiLmbEaMjwjfz0CMvbyIGh8RD9wWUC9fZFvaXJ8+1PFng6m6DyvHKG4Y8UaN
	m/abzqgvOmPL65i1YMEDlkK0bkqHfhCzXIN+WeVC3rKep/Ev1IorMUTPjktnnx0MuhFcpKUVoxy
	+bWBPZU=
X-Received: by 2002:a05:6102:32cd:b0:5db:efcb:72 with SMTP id
 ada2fe7eead31-5fe2ad39b83mr6208741137.6.1771449497123; Wed, 18 Feb 2026
 13:18:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
 <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
 <aRZ9SQ_G2lsmXtur@google.com> <CALzav=fN4FpZsfzwbdLeNSj4nx4OpRkwHvKiZNVgP8S-zsUvJA@mail.gmail.com>
 <aZYpv6O15YMlGkzT@google.com>
In-Reply-To: <aZYpv6O15YMlGkzT@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 18 Feb 2026 13:17:48 -0800
X-Gm-Features: AaiRm50oQAsne8PMukHk2_Ehws0mlHrvXf3-klwm2DNfi8keZfRuu7miCV2uiLE
Message-ID: <CALzav=cc9y2sp66QRwv=DCpb1j8fNjLWbsiqDVK9UE4e2kthzQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2026 at 1:06=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Dec 03, 2025, David Matlack wrote:
> > On Thu, Nov 13, 2025 at 4:52=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > My slowness is largely because I'm not sure how to land/approach this=
.  I'm 100%
> > > in favor of the renames, it's the timing and coordination I'm unsure =
of.
> > >
> > > In hindsight, it probably would have best to squeeze it into 6.18, so=
 at least
> > > the most recent LTS wouldn't generate conflicts all over the place.  =
The next
> > > best option would probably be to spin a new version, bribe Paolo to a=
pply it at
> > > the end of the next merge window, and tag the whole thing for stable@=
 (maybe
> > > limited to 6.18+?) to minimize downstream pain.
> >
> > With LPC coming up I won't have cycles to post a new version before
> > the 6.19 merge window closes.
> >
> > I'm tempted to say let's just wait for the next LTS release and merge
> > it in then. This is low priorit, so I'm fine with waiting.
>
> I ran this by Paolo in last week's PUCK, and he's in favor of the renames=
 (or at
> least, is a-ok with us doing it).  If you can prep a new version in the n=
ext week
> or so, we can get it applied for 7.1 shortly after the merge window close=
s.

Will do. I'll try to have it out by next week. Thanks!
