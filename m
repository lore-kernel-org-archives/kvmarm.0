Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E8C3D1713
	for <kvmarm@lists.linux.dev>; Fri, 10 Apr 2026 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775839477; cv=pass; b=e1GrYaL6Z9iVFEVxORhTE7id12YllPw71yF+xtUvOpC7EbW8W3oz5Vd0Kc5UYdhQ0w9EKqLbKV2awsT2cBpifPd6PBvn21oe4kPsRYst7+R0MwSbIGerUKU+5lgfXiqb0h30AaKlv8bohYCLqWRna4FmV36qb01N1AYy7SB/Hi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775839477; c=relaxed/simple;
	bh=gnf5NPxuSAFSVzPdp7lnXic9XSxNa7id9N4QGb7x2ew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SkgitdV9jJg36JP1AO/PJsAdgfqXE53DZIy748ju5iNL+uSpa6oIF9ViAh4JjOvHUmkT7d4Tpsd9NUHjxWakcfA3wmkDjzWfHX7J4e02d7/O5XF8kfeWY7QLduF42HeTpr/OPeBT02TJPu3xN9HOydldZYnuA/RAag4oU1GQ9m4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DRYPi2b3; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DRYPi2b3"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a1307438ddso2298708e87.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Apr 2026 09:44:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775839474; cv=none;
        d=google.com; s=arc-20240605;
        b=ICu/KmaukO+1TBBRt7xRxckKSlIk/2RBVmFfmbSaSSUQtriqgbBoTgLoSdj6q9Bvik
         UvkhwHkIkFGmy+QvLFWol/r2ojjFc9N3KsVuiEoPQxradXCK+UtjqwpaOifNSCLPCsN+
         tunWNQyPnkB8IRoiN9P1iI5bIsRCWCK01YfpC1K5U7xYZkLspMAz32tNu5A4DgQv2kiK
         OxZfpCQ2QbZZvR0SlmKrodlicP5ZpRSSC+xnXCY6HARpNm8PfdF22VJIDvuPiL5sDbNX
         dCK79Rcmtiui9OGeBxpA2nmm+cMHCZZqJhf42Rcenz1VcmgACyJiYcFi2/58mhjnKXUj
         YWxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WcTLAwAR7HgTYbmWEjTt5Ig3K5spnM3eEDD+cYxVPDA=;
        fh=xz68SuL5x10pPulTjZJsrfT19kvPqohRGSydAJz3d8I=;
        b=llERbWSSGgxmLMZX/fT1/AJFmvUzBbi7FQhth1GYCnvpGpsRd78xynMT0gJL4q0d1B
         AIr9khpXJkyT8ZSoHK+l3fOt1L3dJa2BT0hX7XLPM/9c83V7oyQgKv+BfhCkKWC57SY3
         crrv1OqGaqdUHMOmXOZfnfLmpttNyEloDYReyP8y5ddDJO1Vtk+luRDOAOmlhqhm7ttE
         WDqNo6tsohmDYS+fyKiwtdK6k2OAJNgrUbV/RNGfp/195bcPJGEMncO+zB+YR2o2JV9X
         VynSSATy4o5ftwZTLq+ut95zNyVn+MVV1VPUSz2ot/fvWtbkRy8FkCG/yrZhY3Og3sOY
         df6w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775839474; x=1776444274; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WcTLAwAR7HgTYbmWEjTt5Ig3K5spnM3eEDD+cYxVPDA=;
        b=DRYPi2b3QeqELua6HWIJ7Bd/Lje2DNpVbesEgL7wNFZo8Ug1remGRIio9x4JVgvSws
         QIvMsyvjQ4YTDzXnd0N6T2ktTwZWpypzk8qJ9/NDf3KnJdlnx4ZkRx6G3GRahcQ/juzl
         kvFaTIQ+uc/eCjV0pm9xWkDsISwFhA+YkCR4fIdoZ85C29XbEjcMRJoRgSnx5Q/A7mTu
         I8iW8pLsX93jH+6WwQ5pWsPnOyBpJDJEGWO50cg5zh7Y16MjalHOmGw62sYIBKI4mBpL
         wbwTEiuIdoLSLJfNaIx8dJZCSW70axh1wadV9uRoRaS0DlmwzhGA4F2rur/hyavTW8jS
         OCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775839474; x=1776444274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WcTLAwAR7HgTYbmWEjTt5Ig3K5spnM3eEDD+cYxVPDA=;
        b=r/xGWf7HopxmmVp6UewrVor6WjM/NNw2kojwyZunZshGpQLBg9bEYnlIKNSQfzTcku
         ZW00Q/dYWm2qxhowYgiiGcjeIfFMRsFTxucO4VcsCROmdS3LcvqB8MLwPNVqFbIlNuJ5
         gBtjE2RiHX+1AvFTSljLSXFa6igIlrl0trz0AB8vn4YR2dNkpAUsGso21CA7hHCRuvFW
         CTJjSlrqhCjA2MpXd3mSiSbMtOibG5B7G9u5m6zlUnwrBzUmd+NULnUs1KeXNQkZjHFh
         oq2NO6vw1V7Idw2CgVrseyCoxfYKgWPSqeJNvGkeswpHbnE+AXPG5i84yT26KblEzjrH
         9iDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlmyAW5ZkvXFhYn7w5TRw0/ztEMplVCUpV87gjMoBWUVakPkY3YRE/DHjrt3NnhSPAZLa+DII=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXR2wzqwdGizGsEtSZIxFIw/KF6Bm/IG4xK2VlNephOiCrNdGe
	ubKUoYoLarVV7l3H7aM6ZJmnUqq5tUZVhPY76Xbry89qY/rhCsj8H3JB895l8LTwhJZAuHy8fZl
	nGBFD6h8E1r/TweJC0qX+8knZ3kvSO2vnCXwq32DK
X-Gm-Gg: AeBDiet4i5rKi1pesqxxnOTaNf7QaYS9Ick2H+oy9cM2WtZf8atYCwlHSEOL/GxFweE
	OKQIARwVZwqrXED+NKcjIamwM14+AaLF6Br2lsatD4a/hzeuoaL0huhDHIOOwe+fdJsLZKL+9z/
	A6LuOUkOHFGxq9gKnHf9MF39WW4Zr2oz0vrcCiFllLqvFHzlX49m3vgF3DknD9DKMc7W2loCUUW
	5xtOxQKrml8J/AbVkxiMvl28SxADwY6OUd16yImPQHFWfbYmvrIiGcD9+/i1SmKOvvvceQd6r69
	ySFjSwq2pdTDI7QPD7vHfAeTOwVikYVBLA+dS8aadewXyfiONbQ=
X-Received: by 2002:a05:6512:39c6:b0:5a3:cc81:efdb with SMTP id
 2adb3069b0e04-5a3efb8ba02mr1104456e87.21.1775839473752; Fri, 10 Apr 2026
 09:44:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316224349.2360482-1-jingzhangos@google.com>
 <20260324114312.GA438107@e124191.cambridge.arm.com> <CAAdAUtjeYJ5sOQVB-t7U=KJ9JuCCmO9b2dwJsas7mkzNLu8WqA@mail.gmail.com>
 <20260408150345.GA2316230@e124191.cambridge.arm.com>
In-Reply-To: <20260408150345.GA2316230@e124191.cambridge.arm.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 10 Apr 2026 09:44:21 -0700
X-Gm-Features: AQROBzBLjpcQ1gxXXkYLmcBPLslK-9SLQukU2c2RIA94WmMI7RqyYdesMiWxLck
Message-ID: <CAAdAUtgNEuuSJ7vwxC7DgL1VcstW+JVZx1HuqMWDxF=EGX+0BQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] arm64: Add Stage-2 MMU and Nested
 Guest Framework
To: Joey Gouly <joey.gouly@arm.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 8, 2026 at 8:03=E2=80=AFAM Joey Gouly <joey.gouly@arm.com> wrot=
e:
>
> On Tue, Apr 07, 2026 at 11:16:15AM -0700, Jing Zhang wrote:
> > On Tue, Mar 24, 2026 at 4:43=E2=80=AFAM Joey Gouly <joey.gouly@arm.com>=
 wrote:
> > >
> > > On Mon, Mar 16, 2026 at 03:43:46PM -0700, Jing Zhang wrote:
> > > > This patch series introduces a lightweight infrastructure for manag=
ing ARM64
> > > > Stage-2 translation tables and executing nested guests. These compo=
nents are
> > > > essential for testing advanced virtualization features such as nest=
ed
> > > > virtualization (NV) and GICv4 direct interrupt injection.
> > > >
> > > > The series provides a generic Stage-2 MMU library supporting multip=
le
> > > > translation granules (4K, 16K, 64K) and dynamic page table manageme=
nt.
> > > > Building on this, it adds a guest execution framework that handles =
guest
> > > > lifecycle management, context switching and guest exit routing. A n=
ew test
> > > > case for Stage-2 MMU demand paging to verify fault handling.
> > > >
> > > > Please note that this is a very preliminary implementation intended=
 as a
> > > > startup baseline for future work in virtualization testing. Users s=
hould be
> > > > aware that because this is an early-stage baseline, some portions o=
f the code
> > > > may just happen to work in its current state. There might be critic=
al
> > > > architectural elements or edge-case handling missing that will need=
 to be
> > > > addressed as the framework matures.
> > > >
> > >
> > > Hi,
> > >
> > > I'm interested in this, I had a much more barebones (aka no stage2) g=
uest
> > > framework thing that I sent out [1], but it seems more useful to try =
get this
> > > series merged.
> > >
> > > I will try get my tests working with this new framework, one thing mi=
ssing for
> > > me is support for executing at EL0.
> > >
> > > Thanks,
> > > Joey
> > >
> > > [1] https://lore.kernel.org/kvmarm/20260306142656.2775185-1-joey.goul=
y@arm.com/#t
> > >
> >
> > Hi Joey,
>
> Hi Jing,
>
> I had a bit of a play with the code and ended up with a few questions/tho=
ughts
> about the guest/EL1/EL0 model.
>
> Two major things EL1 needs are allocating memory and eventually page tabl=
es.
>
> For EL1 isolation, I can see a few possible approaches (maybe there's oth=
ers?):
> 1. EL1 reuses the usual kvm-unit-tests infrastructure (allocators, helper=
s, etc.).
> 2. EL1 is treated more like a real guest/VM, and has to provide its own
>    allocators and other basic support.
> 3. The host (EL2) provides all memory up front and can create EL1 page ta=
bles,
>    like kselftest.
> 4. A small hyp-service interface is provided for things like page donatio=
n,
>    printing, etc.
>
> Option 1 feels like the best pragmatically, the tests will look like a no=
rmal C
> file, just that parts of it are run at different ELs. However sharing
> functionality could be complex. For example, I tried calling printf() fro=
m EL1
> and then also from the EL2 abort handler, and hit a deadlock because both=
 paths
> ended up taking the same spinlock.
>
> Option 2 feels the least hacky, but maybe has the most complexity since E=
L1
> needs its own alloactors and general support functionality. It's also not
> obvious how to map in the EL1 code. Perhaps there would need to be a sepa=
rate
> test_foo_el1.c file that was built and bundled into test_foo.c
>
> Option 3 looks to be the most simple, is quite flexible, but less dynamic=
.
>
> Option 4 might be quite simple to have a small hyp interface, a bit like =
option
> 3 but more dynamic.
>
> > Will you add support for executing at EL0?
>
> I tried to enter EL0 using `start_usr()` from the EL1 guest. I tried to
> allocate a stack using alloc_page(). However this leads to some issues du=
e to
> the following code:
>
>     phys_addr_t __virt_to_phys(unsigned long addr)
>     {
>             if (mmu_enabled()) {
>                     pgd_t *pgtable =3D current_thread_info()->pgtable;
>                     return virt_to_pte_phys(pgtable, (void *)addr);
>             }
>             return addr;
>     }
>
> In this series, EL1 is not set up as a "thread" (see new_thread() [1]), s=
o
> current_thread_info()->pgtable ends up being NULL.  That is what led me t=
o
> think about the options above.
>
> Thanks,
> Joey
>
> [1] https://lore.kernel.org/kvmarm/20260306142656.2775185-5-joey.gouly@ar=
m.com/
>

Hi Joey,

Thanks for looking into this. Your ideas for EL0 support and the guest
execution model look solid. I=E2=80=99ll leave the infrastructure and EL0
improvements to you for now, as I am currently working on adding GICv4
support and vLPI tests.

Thanks,
Jing

> >
> > Thanks,
> > Jing
> >
> > > > ---
> > > >
> > > > Jing Zhang (3):
> > > >   lib: arm64: Add stage2 page table management library
> > > >   lib: arm64: Add bare-metal guest execution framework
> > > >   arm64: Add Stage-2 MMU demand paging test
> > > >
> > > >  arm/Makefile.arm64         |   4 +
> > > >  arm/stage2-mmu-test.c      | 100 +++++++++
> > > >  lib/arm64/asm/guest.h      | 156 ++++++++++++++
> > > >  lib/arm64/asm/stage2_mmu.h |  74 +++++++
> > > >  lib/arm64/guest.c          | 197 ++++++++++++++++++
> > > >  lib/arm64/guest_arch.S     | 263 ++++++++++++++++++++++++
> > > >  lib/arm64/stage2_mmu.c     | 402 +++++++++++++++++++++++++++++++++=
++++
> > > >  7 files changed, 1196 insertions(+)
> > > >  create mode 100644 arm/stage2-mmu-test.c
> > > >  create mode 100644 lib/arm64/asm/guest.h
> > > >  create mode 100644 lib/arm64/asm/stage2_mmu.h
> > > >  create mode 100644 lib/arm64/guest.c
> > > >  create mode 100644 lib/arm64/guest_arch.S
> > > >  create mode 100644 lib/arm64/stage2_mmu.c
> > > >
> > > >
> > > > base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
> > > > --
> > > > 2.53.0.851.ga537e3e6e9-goog
> > > >
