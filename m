Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D390C20DD2
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728573839; cv=none; b=ssk5DB4WXobdxtXadBFfW3qxJpPlolpZUGB+YdT3JLrZt9xMY8DbKGLxjRpJfnu6chluUHgRH/3IDuaYJ9lo3Bky0fy9rZbxcbleRK+eYfMkqop5TMoZaXZn4gdos8cCIZSx+SWI8YdTCQnF/9YVsDF9uYHOb63UWY8hRB8AA+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728573839; c=relaxed/simple;
	bh=P8ixnDOeisvSETy0b4blVq+DcPJOGCQ7G8UzdQUATjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mMIa3FwPxsF04d3xtguxqd+hfxyS7X2dBV7VFlgtCV9lnV6sv/YBUjAJanQp8IHff2sNkzP7xRhqkaJ0Mo0xyiE3qd+jj0FZLUax48KCJQRDE64texN3/l8TXUu9qPN0jj/pTUNSDhM2cijHJWNe7oZ/z7e150YkUXCGMUnNx8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3KEPu5+4; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3KEPu5+4"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d3ecad390so1268064f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 08:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728573836; x=1729178636; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLZSqMwLpjl5AxpHBBnYo8ME2eAPTDkTk5fdaT/zvdU=;
        b=3KEPu5+4TDnhrFBnYkFZgZ2SDA6kyPeiWz/m9V2z0clbDjl5KviZx/0Nb73xB7ziTW
         PYnv2fdAMTL76euzKWuuUrVdJ2L7xOt9svWqz2C1JtVr2bJy1oFdYIPsQUlINYScXMOU
         9tUKZaX2tgmXWED69oe4oiro+zhEb5VfA28/7hxUnYo4efTkQDFj+6Z9GrQPO1VJcsRK
         TYAlw8xEC0PwnHYSz8X2DnaQXXflPJ9aU+9acOVmrJNeOcg+qqLg8H+irFpLFd87/ph0
         zyGwKpWSi6Rj2xDAycPKDk8+rJwMzr/zX8ut48SFCG6/wN2+I8A7hnFfh3d7OT/HbOVb
         dKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728573836; x=1729178636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLZSqMwLpjl5AxpHBBnYo8ME2eAPTDkTk5fdaT/zvdU=;
        b=krTtfInah9+8noc1/6PHWElf62t61697GCByGJGPwOIA6ZEXq46CCvZKhAEgSh4BCd
         bnpgPmvZ+G4RI1E+9uXggdiJ5PkEHtVoAS1Y1oPVxpc5qBZnezlvYBnD5ebYkoVmfp7K
         54a4MNtjvn74OyrbsVfh6L7Oe+vPqcrgc4woVHC/pjHl90CXbdi337qrVWGrwce4fTpO
         JJDYtX6pZDK1jrC3+f/TfBQAAR2AbGHc/mHYvbZXPjSBtsufRYQKwO9lI000ZuLJtkQ8
         +l2qV244FUR7AOkHEZ3ym6AKEGdYor1NcoVRr74JwyfZ0AKoVA0h5hg289BSpmpjCx1s
         OshQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBBQ4JSC7w7CJCtw5Te7u3jn3sxKXi5hMh4ZUGNdiRumhhYHliu6wNSwQP1Vm2+qWH17m9eR4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnTn+7qbJSv5/rq35D7txabxI+wiAjU25TsbuOpom7/IrLNo/o
	e6K9daKsypjDckShLxbJLxtQQkkgKtDaea5S+RQ4nLDYdOWbXRoXWW39dn4p7x3eRiIDTP/EzTF
	eE/EozMp7C29cVbjZ2j4HSmgQFyQZQxByk9yO
X-Google-Smtp-Source: AGHT+IE3uEJT1ooS9R2cTFDwYl+KsfVVeCZEwpAFYvUKvbTiV1yR9Rue7MKswAd/1p4ekTLLAWKNiALTr6wOrWfNIkM=
X-Received: by 2002:a05:6000:10ce:b0:37c:f997:5b94 with SMTP id
 ffacd0b85a97d-37d481749ebmr3135615f8f.12.1728573835943; Thu, 10 Oct 2024
 08:23:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241009085751.35976-1-tianjia.zhang@linux.alibaba.com>
 <86set55yca.wl-maz@kernel.org> <b3c21234-73a0-43dd-8365-9039c62b7aa7@linux.alibaba.com>
In-Reply-To: <b3c21234-73a0-43dd-8365-9039c62b7aa7@linux.alibaba.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 10 Oct 2024 08:23:41 -0700
Message-ID: <CAKwvOdnkTOjV_j6zGAkghgU0L_tLkb=8Nh3Qzvdb1N-tV61wag@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nVHE: gen-hyprel: Silent build warnings
To: "tianjia.zhang" <tianjia.zhang@linux.alibaba.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, =?UTF-8?Q?Pierre=2DCl=C3=A9ment_Tosi?= <ptosi@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 1:13=E2=80=AFAM tianjia.zhang
<tianjia.zhang@linux.alibaba.com> wrote:
>
>
>
> On 10/9/24 7:07 PM, Marc Zyngier wrote:
> > On Wed, 09 Oct 2024 09:57:51 +0100,
> > Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:
> >>
> >> This patch silent the some mismatch format build warnings
> >> with clang, like:
> >>
> >>    arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:233:2: warning: format specifi=
es
> >>    type 'unsigned long' but the argument has type 'Elf64_Off'
> >>    (aka 'unsigned long long') [-Wformat]
> >>      233 |         assert_ne(off, 0UL, "%lu");
> >>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
> >>          |                              %llu
> >>    arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:193:34: note: expanded from ma=
cro 'assert_ne'
> >>      193 | #define assert_ne(lhs, rhs, fmt)        assert_op(lhs, rhs,=
 fmt, !=3D)
> >>          |                                         ^~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
> >>    arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:188:19: note: expanded from ma=
cro 'assert_op'
> >>      187 |                                 " failed (lhs=3D" fmt ", rh=
s=3D" fmt        \
> >>          |                                                 ~~~
> >>      188 |                                 ", line=3D%d)", _lhs, _rhs,=
 __LINE__);    \
> >>          |                                               ^~~~
> >>    arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:167:17: note: expanded from ma=
cro 'fatal_error'
> >>      166 |                 fprintf(stderr, "error: %s: " fmt "\n",    =
             \
> >>          |                                               ~~~
> >>      167 |                         elf.path, ## __VA_ARGS__);         =
             \
> >>          |                                      ^~~~~~~~~~~
> >>
> >> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> >
> > I don't see these warnings. What version of LLVM are you using?
> >
>
> I compiled the kernel on Apple Silicon M3 Pro in macOS 15.0.1, Maybe this=
 is
> a special scenario that is rarely used.

Right, so I had an initial patch set for building the kernel from a
MacOS host.  I sent a v1, but didn't chase sending a v2 at the time
because there didn't appear to be any interest.

https://www.phoronix.com/news/Linux-Compile-On-macOS

Since then, I saw a v2 or even a v3 fly by (I was cc'ed).

One issue I recall building from MacOS was that MacOS does not have an
<elf.h> (their object file format is not ELF, but Mach-O).  I had to
install some dependency through homebrew for that header.

Just a guess but:
Perhaps it defines Elf64_Off as a `unsigned long` incorrectly, and
should be defining it as an `unsigned long long`.  I'd check if that's
the case and if so, Tianjia, you may want to report that issue on the
thread where folks are reposting the MacOS host support.

>
> Details of clang:
>
>      # clang --version
>      Homebrew clang version 19.1.1
>      Target: arm64-apple-darwin24.0.0
>      Thread model: posix
>      InstalledDir: /opt/homebrew/Cellar/llvm/19.1.1/bin
>
> Cheers,
> Tianjia
>


--=20
Thanks,
~Nick Desaulniers
