Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687EDC43334
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 09:43:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22F224BA95;
	Mon, 11 Jul 2022 05:43:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0mQLrsftD4i9; Mon, 11 Jul 2022 05:43:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ADBC4BB74;
	Mon, 11 Jul 2022 05:42:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0126F4B425
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 21:50:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oxMFb0qb5lih for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 21:50:45 -0400 (EDT)
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com
 [209.85.160.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 307744B31D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 21:50:45 -0400 (EDT)
Received: by mail-oa1-f49.google.com with SMTP id
 586e51a60fabf-10c0e6dd55eso757679fac.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jul 2022 18:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pLrIXHFzpO5mZB8k2eavL3K7Dil3m2ScwawxeudvKdw=;
 b=BA1+GtDn8BwoXKSiIJaAD8AxgAuh/yNsdUESp/xavAzeSzep8kBNyIXhlQjYWFU/kk
 Aa/kT5h3KFv3GevQSWM76VuCPtPY6Li2JG/JfRsVib2onz5c7FlYDR+U/rrmLZ2RV8Ub
 nHYkbw9Hh82/PJAbcOcprRkfu9LbKBvvzWXPScuKem2O89XFZTV5E8uURizJBNQrbIay
 ZrHmhplPMi56Mz+ah0Sbdx27qSbXJSw8GNZKCUfOrs52bSxCuGp2VOF8uK+yOsIkTIPJ
 NYoZqrBr/ZIOQH6bt2fBRtwwdUlMgZIzluOee2jiHgFvi3h5j5FiTGNHtZeDlr1diV2u
 ycNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pLrIXHFzpO5mZB8k2eavL3K7Dil3m2ScwawxeudvKdw=;
 b=NFXEg5dsoS0XaCpNBgvAx5+Gr5Ury2fwqWhZxFPMScvL0DmqwKni0LJXTFkCOiIoUb
 tIsr2w/uhL/smJUJcoWzIwFamaSNuHBiNm2leRqPSubMcC314NMnR4ZFbnwHR5ftJhjC
 oaNZi/feFGuz5I2JU/l4EcD9R3DYdSRs05cxIw6pY0A7A3lO8gq5A64B7XpW4KZj/pDv
 T6qaZZQaCIPkeHIVJlsNpZmojmi7blQWyaCIjqMrhbTd3gwqI91y4kCw4rm7WV9vwZNM
 ACv1Gf+UB5U1V+/s8cAXxPgfkXqcjumCUIiD/ku8eGJRPknyPy30+zKp3p7SOVG7ZYQy
 UTvA==
X-Gm-Message-State: AJIora8Nl6gTydGYfgw29GkqTON5ZtxRwUl3M+NxWsY/m6Uw+aA8sjSW
 wulqiFB/BIZ19EcxmSL3CFjGFK3jA+OMRLIhE/8=
X-Google-Smtp-Source: AGRyM1tYF65Gndj3Xt/nFn7scwLMXSSDwQXWYXGRmtNZ8FD1W9TMa8mjOc+m344btTB153SXSoeUU/i59ai41G6UZqk=
X-Received: by 2002:a05:6870:c68a:b0:10b:95e3:3dd3 with SMTP id
 cv10-20020a056870c68a00b0010b95e33dd3mr1659272oab.248.1657331444203; Fri, 08
 Jul 2022 18:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220708212106.325260-1-pcc@google.com>
In-Reply-To: <20220708212106.325260-1-pcc@google.com>
From: Itaru Kitayama <itaru.kitayama@gmail.com>
Date: Sat, 9 Jul 2022 10:50:33 +0900
Message-ID: <CANW9uysjpAH726c18aR7A2MxRpR49D_cfXBvsQP0Yj_1yP8bhQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
To: Peter Collingbourne <pcc@google.com>
X-Mailman-Approved-At: Mon, 11 Jul 2022 05:42:55 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7391916226010638025=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============7391916226010638025==
Content-Type: multipart/alternative; boundary="00000000000001c28805e3558c7d"

--00000000000001c28805e3558c7d
Content-Type: text/plain; charset="UTF-8"

Peter
Gmail always marks your mail as spam, any ideas?

Itaru.

On Sat, Jul 9, 2022 at 6:24 Peter Collingbourne <pcc@google.com> wrote:

> Hi,
>
> This patch series contains a proposed extension to pKVM that allows MTE
> to be exposed to the protected guests. It is based on the base pKVM
> series previously sent to the list [1] and later rebased to 5.19-rc3
> and uploaded to [2].
>
> This series takes precautions against host compromise of the guests
> via direct access to their tag storage, by preventing the host from
> accessing the tag storage via stage 2 page tables. The device tree
> must describe the physical memory address of the tag storage, if any,
> and the memory nodes must declare that the tag storage location is
> described. Otherwise, the MTE feature is disabled in protected guests.
>
> Now that we can easily do so, we also prevent the host from accessing
> any unmapped reserved-memory regions without a driver, as the host
> has no business accessing that memory.
>
> A proposed extension to the devicetree specification is available at
> [3], a patched version of QEMU that produces the required device tree
> nodes is available at [4] and a patched version of the crosvm hypervisor
> that enables MTE is available at [5].
>
> v2:
> - refcount the PTEs owned by NOBODY
>
> [1] https://lore.kernel.org/all/20220519134204.5379-1-will@kernel.org/
> [2] https://android-kvm.googlesource.com/linux/ for-upstream/pkvm-base-v2
> [3] https://github.com/pcc/devicetree-specification mte-alloc
> [4] https://github.com/pcc/qemu mte-shared-alloc
> [5]
> https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/3719324
>
> Peter Collingbourne (3):
>   KVM: arm64: add a hypercall for disowning pages
>   KVM: arm64: disown unused reserved-memory regions
>   KVM: arm64: allow MTE in protected VMs if the tag storage is known
>
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/include/asm/kvm_host.h             |  6 ++
>  arch/arm64/include/asm/kvm_pkvm.h             |  4 +-
>  arch/arm64/kernel/image-vars.h                |  3 +
>  arch/arm64/kvm/arm.c                          | 83 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +-
>  arch/arm64/kvm/mmu.c                          |  4 +-
>  11 files changed, 123 insertions(+), 8 deletions(-)
>
> --
> 2.37.0.144.g8ac04bfd2-goog
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

--00000000000001c28805e3558c7d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Peter=C2=A0</div><div dir=3D"auto">Gmail always marks you=
r mail as spam, any ideas?</div><div dir=3D"auto"><br></div><div dir=3D"aut=
o">Itaru.</div><div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=
=3D"gmail_attr">On Sat, Jul 9, 2022 at 6:24 Peter Collingbourne &lt;<a href=
=3D"mailto:pcc@google.com">pcc@google.com</a>&gt; wrote:<br></div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc so=
lid;padding-left:1ex">Hi,<br>
<br>
This patch series contains a proposed extension to pKVM that allows MTE<br>
to be exposed to the protected guests. It is based on the base pKVM<br>
series previously sent to the list [1] and later rebased to 5.19-rc3<br>
and uploaded to [2].<br>
<br>
This series takes precautions against host compromise of the guests<br>
via direct access to their tag storage, by preventing the host from<br>
accessing the tag storage via stage 2 page tables. The device tree<br>
must describe the physical memory address of the tag storage, if any,<br>
and the memory nodes must declare that the tag storage location is<br>
described. Otherwise, the MTE feature is disabled in protected guests.<br>
<br>
Now that we can easily do so, we also prevent the host from accessing<br>
any unmapped reserved-memory regions without a driver, as the host<br>
has no business accessing that memory.<br>
<br>
A proposed extension to the devicetree specification is available at<br>
[3], a patched version of QEMU that produces the required device tree<br>
nodes is available at [4] and a patched version of the crosvm hypervisor<br=
>
that enables MTE is available at [5].<br>
<br>
v2:<br>
- refcount the PTEs owned by NOBODY<br>
<br>
[1] <a href=3D"https://lore.kernel.org/all/20220519134204.5379-1-will@kerne=
l.org/" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/all/20=
220519134204.5379-1-will@kernel.org/</a><br>
[2] <a href=3D"https://android-kvm.googlesource.com/linux/" rel=3D"noreferr=
er" target=3D"_blank">https://android-kvm.googlesource.com/linux/</a> for-u=
pstream/pkvm-base-v2<br>
[3] <a href=3D"https://github.com/pcc/devicetree-specification" rel=3D"nore=
ferrer" target=3D"_blank">https://github.com/pcc/devicetree-specification</=
a> mte-alloc<br>
[4] <a href=3D"https://github.com/pcc/qemu" rel=3D"noreferrer" target=3D"_b=
lank">https://github.com/pcc/qemu</a> mte-shared-alloc<br>
[5] <a href=3D"https://chromium-review.googlesource.com/c/chromiumos/platfo=
rm/crosvm/+/3719324" rel=3D"noreferrer" target=3D"_blank">https://chromium-=
review.googlesource.com/c/chromiumos/platform/crosvm/+/3719324</a><br>
<br>
Peter Collingbourne (3):<br>
=C2=A0 KVM: arm64: add a hypercall for disowning pages<br>
=C2=A0 KVM: arm64: disown unused reserved-memory regions<br>
=C2=A0 KVM: arm64: allow MTE in protected VMs if the tag storage is known<b=
r>
<br>
=C2=A0arch/arm64/include/asm/kvm_asm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0arch/arm64/include/asm/kvm_host.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 6 ++<br>
=C2=A0arch/arm64/include/asm/kvm_pkvm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 4 +-<br>
=C2=A0arch/arm64/kernel/image-vars.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 3 +<br>
=C2=A0arch/arm64/kvm/arm.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 83 ++++++++++++++++++-<br>
=C2=A0arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |=C2=A0 1 +<br>
=C2=A0arch/arm64/kvm/hyp/include/nvhe/pkvm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 1 +<br>
=C2=A0arch/arm64/kvm/hyp/nvhe/hyp-main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 |=C2=A0 9 ++<br>
=C2=A0arch/arm64/kvm/hyp/nvhe/mem_protect.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 11 +++<br>
=C2=A0arch/arm64/kvm/hyp/nvhe/pkvm.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 8 +-<br>
=C2=A0arch/arm64/kvm/mmu.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 4 +-<br>
=C2=A011 files changed, 123 insertions(+), 8 deletions(-)<br>
<br>
-- <br>
2.37.0.144.g8ac04bfd2-goog<br>
<br>
<br>
_______________________________________________<br>
linux-arm-kernel mailing list<br>
<a href=3D"mailto:linux-arm-kernel@lists.infradead.org" target=3D"_blank">l=
inux-arm-kernel@lists.infradead.org</a><br>
<a href=3D"http://lists.infradead.org/mailman/listinfo/linux-arm-kernel" re=
l=3D"noreferrer" target=3D"_blank">http://lists.infradead.org/mailman/listi=
nfo/linux-arm-kernel</a><br>
</blockquote></div></div>

--00000000000001c28805e3558c7d--

--===============7391916226010638025==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7391916226010638025==--
