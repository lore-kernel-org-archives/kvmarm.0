Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9FBC04A95
	for <kvmarm@archiver.kernel.org>; Fri, 23 Sep 2022 20:14:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4ABD40BC0;
	Fri, 23 Sep 2022 16:14:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gLvdwOO8l7F3; Fri, 23 Sep 2022 16:14:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43EA940D01;
	Fri, 23 Sep 2022 16:14:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B25E64B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 02:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3HMgow9rZZZh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2022 02:04:45 -0400 (EDT)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com
 [209.85.222.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF8A640C1B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 02:04:44 -0400 (EDT)
Received: by mail-qk1-f177.google.com with SMTP id u28so7675856qku.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 23:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=nW/L2bGo3HHlpq/ChRR87X2Wq/deDH6Y36Ib8vLv/Eg=;
 b=QoIag8ILYpY23I9E6I3cyVOhjObSgFjnZl1P9J/+hSeFH1Ss4iJAkB6Jt5Ve69H768
 L55c1hdu+S7eoLmXnAyKi81dV2+vMiUVRR3WWFmnfvdUzip0i/BMusJSzO9C23ui11xV
 yCfRBl1waJaU1B4V74Ho6jbOPWX5riUwnJty0yzDIIeAFq2ufEPfvkTl/5A/B8xh1mnV
 EABQ9HFS6CfBA3IxQita14kIh4CGkR9xjz7VOq6nkKhK9gctj7M5c6VPbvVZIBDiALlr
 7yXdXnmonK73dvoOvpsP9/dOLMySRkNqPpN5Zs73DFr7JCBwtOvZprNxGw+0po68wLdp
 uLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=nW/L2bGo3HHlpq/ChRR87X2Wq/deDH6Y36Ib8vLv/Eg=;
 b=vI9uBg2bu16uT/PHeOXjVBcDocwP2kFSlhIx0ZPxp9mjtnWujsd+Mkkn0F2QvmR3Yn
 OdtvmWh4/Nym0rOLue7iHjQMLkRQhNG16rCLqjgWwt6Oa1RrGC1qH2UK0a59DAAq/sSM
 BBIvZgiCTbVWMgFb6BtRc9jAcCNHn2d1w1QuoNNZOMCOC9jnGTBOD+56RfcNNRsCc+QW
 /22kfT+HL7r1GVMoPKJY+E+KngF4VkAGiKEjYfDE8pRE4/2u0weUyjA8UMnsmIbeXSa6
 8FhvsA0XoFOV2rseuegmG5DdFZLWq76+8MrqDrqLIi8tHuxI8wt0mhZqg1MU3ZAh6FNy
 L25Q==
X-Gm-Message-State: ACrzQf3PVdWr4W4bkSLn82gP6TCt+wu53fScYyZIYB3c+HenpGJ985k2
 yXKB/Y2yIi17WyUxR7lIWlMpdXNZJdvIoxf6Yf/ToA==
X-Google-Smtp-Source: AMsMyM6xIIjd9BhxaD7nimtOx/vvcX/WR5v9XTgyFMqDcuF83YqKqFitoKzxAYXbnYvmGNjl/admYb+3qMUc1cOFaYI=
X-Received: by 2002:a05:620a:4145:b0:6ce:8c42:7087 with SMTP id
 k5-20020a05620a414500b006ce8c427087mr4764596qko.334.1663913084191; Thu, 22
 Sep 2022 23:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220920082005.2459826-1-denik@chromium.org>
 <20220922053145.944786-1-denik@chromium.org>
 <87h70zk83g.wl-maz@kernel.org>
 <CADDJ8CW0QgHtp1rwk=ZqrcuWZ4_L8KQh26VaEfcBQS0Tx9+ZYg@mail.gmail.com>
In-Reply-To: <CADDJ8CW0QgHtp1rwk=ZqrcuWZ4_L8KQh26VaEfcBQS0Tx9+ZYg@mail.gmail.com>
From: Manoj Gupta <manojgupta@google.com>
Date: Thu, 22 Sep 2022 23:04:33 -0700
Message-ID: <CAH=Qcsi3aQ51AsAE0WmAH9VmpqjOaQQt=ru5Nav4+d8F3fMPwQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: nvhe: Fix build with profile optimization
To: Denis Nikitin <denik@chromium.org>
X-Mailman-Approved-At: Fri, 23 Sep 2022 16:13:58 -0400
Cc: Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: multipart/mixed; boundary="===============8958452815975543531=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8958452815975543531==
Content-Type: multipart/alternative; boundary="0000000000005257f405e951f424"

--0000000000005257f405e951f424
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 22, 2022 at 10:01 PM Denis Nikitin <denik@chromium.org> wrote:

> Hi Mark,
>
> On Thu, Sep 22, 2022 at 3:38 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > I was really hoping that you'd just drop the flags from the CFLAGS
> > instead of removing the generated section. Something like:
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile
> b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index b5c5119c7396..e5b2d43925b4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -88,7 +88,7 @@ quiet_cmd_hypcopy = HYPCOPY $@
> >
> >  # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
> >  # This is equivalent to the 'notrace', '__noscs', and '__nocfi'
> annotations.
> > -KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
> $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
> > +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
> $(CC_FLAGS_CFI) -fprofile-sample-use, $(KBUILD_CFLAGS))
> >
> >  # KVM nVHE code is run at a different exception code with a different
> map, so
> >  # compiler instrumentation that inserts callbacks or checks into the
> code may
>
> Sorry, I moved on with a different approach and didn't explain the
> rationale.
>
> Like you mentioned before, the flag `-fprofile-sample-use` does not appear
> in the kernel. And it looks confusing when the flag is disabled or
> filtered out
> here. This was the first reason.
>
> The root cause of the build failure wasn't the compiler profile guided
> optimization but the extra metadata in SHT_REL section which llvm injected
> into kvm_nvhe.tmp.o for further link optimization.
> If we remove the .llvm.call-graph-profile section we fix the build and
> avoid
> potential problems with relocations optimized by the linker. The profile
> guided optimization will still be applied by the compiler.
>
> Let me know what you think about it.
>
> >
> > However, I even failed to reproduce your problem using LLVM 14 as
> > packaged by Debian (if that matters, I'm using an arm64 build
> > machine). I build the kernel with:
> >
> > $ make LLVM=1 KCFLAGS=-fprofile-sample-use -j8 vmlinux
> >
> > and the offending object only contains the following sections:
> >
>

Just some comments based on my ChromeOS build experience.

fprofile-sample-use needs the profile file name argument to read the pgo
data from
i.e. -fprofile-sample-use=/path/to/gcov.profile.

Since the path to filename can change, it makes filtering out more
difficult.
It is certainly possible to find and filter the exact argument by some
string search of KCFLAGS.
But passing  -fno-profile-sample-use is easier and less error prone which I
believe the previous patch version tried to do.


> arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o:     file format
> elf64-littleaarch64
> >
> > Sections:
> > Idx Name          Size      VMA               LMA               File
> off  Algn
> >   0 .hyp.idmap.text 00000ae4  0000000000000000  0000000000000000
> 00000800  2**11
> >                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
> >   1 .hyp.text     0000e988  0000000000000000  0000000000000000
> 00001800  2**11
> >                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
> >   2 .hyp.data..ro_after_init 00000820  0000000000000000
> 0000000000000000  00010188  2**3
> >                   CONTENTS, ALLOC, LOAD, DATA
> >   3 .hyp.rodata   00002e70  0000000000000000  0000000000000000
> 000109a8  2**3
> >                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
> >   4 .hyp.data..percpu 00001ee0  0000000000000000  0000000000000000
> 00013820  2**4
> >                   CONTENTS, ALLOC, LOAD, DATA
> >   5 .hyp.bss      00001158  0000000000000000  0000000000000000
> 00015700  2**3
> >                   ALLOC
> >   6 .comment      0000001f  0000000000000000  0000000000000000
> 00017830  2**0
> >                   CONTENTS, READONLY
> >   7 .llvm_addrsig 000000b8  0000000000000000  0000000000000000
> 0001784f  2**0
> >                   CONTENTS, READONLY, EXCLUDE
> >   8 .altinstructions 00001284  0000000000000000  0000000000000000
> 00015700  2**0
> >                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
> >   9 __jump_table  00000960  0000000000000000  0000000000000000
> 00016988  2**3
> >                   CONTENTS, ALLOC, LOAD, RELOC, DATA
> >  10 __bug_table   0000051c  0000000000000000  0000000000000000
> 000172e8  2**2
> >                   CONTENTS, ALLOC, LOAD, RELOC, DATA
> >  11 __kvm_ex_table 00000028  0000000000000000  0000000000000000
> 00017808  2**3
> >                   CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
> >  12 .note.GNU-stack 00000000  0000000000000000  0000000000000000
> 00027370  2**0
> >                   CONTENTS, READONLY
> >
> > So what am I missing to trigger this issue? Does it rely on something
> > like PGO, which is not upstream yet? A bit of handholding would be
> > much appreciated.
>
> Right, it relies on the PGO profile.
> On ChromeOS we collect the sample PGO profile from Arm devices with
> enabled CoreSight/ETM. You can find more details on ETM at
> https://www.kernel.org/doc/Documentation/trace/coresight/coresight.rst.
>
>
> https://github.com/Linaro/OpenCSD/blob/master/decoder/tests/auto-fdo/autofdo.md
> contains information about the pipeline of collecting, processing, and
> applying
> the profile.
>
>
Generally the difficult part is in collecting a good matching profile for
the workload.
So I think this patch is better than previous since it still keeps the
compiler optimization for the hot code paths
in the file but removes the problematic section.

Thanks,
Manoj



> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
>
> Thanks,
> Denis
>

--0000000000005257f405e951f424
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, Sep 22, 2022 at 10:01 PM Deni=
s Nikitin &lt;<a href=3D"mailto:denik@chromium.org">denik@chromium.org</a>&=
gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi Ma=
rk,<br>
<br>
On Thu, Sep 22, 2022 at 3:38 AM Marc Zyngier &lt;<a href=3D"mailto:maz@kern=
el.org" target=3D"_blank">maz@kernel.org</a>&gt; wrote:<br>
&gt;<br>
&gt; I was really hoping that you&#39;d just drop the flags from the CFLAGS=
<br>
&gt; instead of removing the generated section. Something like:<br>
&gt;<br>
&gt; diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvh=
e/Makefile<br>
&gt; index b5c5119c7396..e5b2d43925b4 100644<br>
&gt; --- a/arch/arm64/kvm/hyp/nvhe/Makefile<br>
&gt; +++ b/arch/arm64/kvm/hyp/nvhe/Makefile<br>
&gt; @@ -88,7 +88,7 @@ quiet_cmd_hypcopy =3D HYPCOPY $@<br>
&gt;<br>
&gt;=C2=A0 # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.<br>
&gt;=C2=A0 # This is equivalent to the &#39;notrace&#39;, &#39;__noscs&#39;=
, and &#39;__nocfi&#39; annotations.<br>
&gt; -KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(=
CC_FLAGS_CFI), $(KBUILD_CFLAGS))<br>
&gt; +KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(=
CC_FLAGS_CFI) -fprofile-sample-use, $(KBUILD_CFLAGS))<br>
&gt;<br>
&gt;=C2=A0 # KVM nVHE code is run at a different exception code with a diff=
erent map, so<br>
&gt;=C2=A0 # compiler instrumentation that inserts callbacks or checks into=
 the code may<br>
<br>
Sorry, I moved on with a different approach and didn&#39;t explain the rati=
onale.<br>
<br>
Like you mentioned before, the flag `-fprofile-sample-use` does not appear<=
br>
in the kernel. And it looks confusing when the flag is disabled or filtered=
 out<br>
here. This was the first reason.<br>
<br>
The root cause of the build failure wasn&#39;t the compiler profile guided<=
br>
optimization but the extra metadata in SHT_REL section which llvm injected<=
br>
into kvm_nvhe.tmp.o for further link optimization.<br>
If we remove the .llvm.call-graph-profile section we fix the build and avoi=
d<br>
potential problems with relocations optimized by the linker. The profile<br=
>
guided optimization will still be applied by the compiler.<br>
<br>
Let me know what you think about it.<br>
<br>
&gt;<br>
&gt; However, I even failed to reproduce your problem using LLVM 14 as<br>
&gt; packaged by Debian (if that matters, I&#39;m using an arm64 build<br>
&gt; machine). I build the kernel with:<br>
&gt;<br>
&gt; $ make LLVM=3D1 KCFLAGS=3D-fprofile-sample-use -j8 vmlinux<br>
&gt;<br>
&gt; and the offending object only contains the following sections:<br>
&gt;<br></blockquote><div><br></div><div>Just some comments based on my Chr=
omeOS build experience.</div><div><br></div><div>fprofile-sample-use needs =
the profile file name argument to read the pgo data from<br></div><div>i.e.=
 -fprofile-sample-use=3D/path/to/gcov.profile.=C2=A0</div><div><br></div><d=
iv>Since the path to filename can change, it makes=C2=A0filtering out more =
difficult.=C2=A0</div><div>It is certainly possible to find and filter the =
exact argument by some string search of KCFLAGS.</div><div>But passing=C2=
=A0 -fno-profile-sample-use is easier and less error prone which I believe =
the previous patch version tried to do.</div><div><br></div><div><br></div>=
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left:1px solid rgb(204,204,204);padding-left:1ex">
&gt; arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o:=C2=A0 =C2=A0 =C2=A0file format=
 elf64-littleaarch64<br>
&gt;<br>
&gt; Sections:<br>
&gt; Idx Name=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Size=C2=A0 =C2=A0 =C2=A0 VM=
A=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LMA=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0File off=C2=A0 Algn<br>
&gt;=C2=A0 =C2=A00 .hyp.idmap.text 00000ae4=C2=A0 0000000000000000=C2=A0 00=
00000000000000=C2=A0 00000800=C2=A0 2**11<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, RELOC, READONLY, CODE<br>
&gt;=C2=A0 =C2=A01 .hyp.text=C2=A0 =C2=A0 =C2=A00000e988=C2=A0 000000000000=
0000=C2=A0 0000000000000000=C2=A0 00001800=C2=A0 2**11<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, RELOC, READONLY, CODE<br>
&gt;=C2=A0 =C2=A02 .hyp.data..ro_after_init 00000820=C2=A0 0000000000000000=
=C2=A0 0000000000000000=C2=A0 00010188=C2=A0 2**3<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, DATA<br>
&gt;=C2=A0 =C2=A03 .hyp.rodata=C2=A0 =C2=A000002e70=C2=A0 0000000000000000=
=C2=A0 0000000000000000=C2=A0 000109a8=C2=A0 2**3<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, RELOC, READONLY, DATA<br>
&gt;=C2=A0 =C2=A04 .hyp.data..percpu 00001ee0=C2=A0 0000000000000000=C2=A0 =
0000000000000000=C2=A0 00013820=C2=A0 2**4<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, DATA<br>
&gt;=C2=A0 =C2=A05 .hyp.bss=C2=A0 =C2=A0 =C2=A0 00001158=C2=A0 000000000000=
0000=C2=A0 0000000000000000=C2=A0 00015700=C2=A0 2**3<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0AL=
LOC<br>
&gt;=C2=A0 =C2=A06 .comment=C2=A0 =C2=A0 =C2=A0 0000001f=C2=A0 000000000000=
0000=C2=A0 0000000000000000=C2=A0 00017830=C2=A0 2**0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, READONLY<br>
&gt;=C2=A0 =C2=A07 .llvm_addrsig 000000b8=C2=A0 0000000000000000=C2=A0 0000=
000000000000=C2=A0 0001784f=C2=A0 2**0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, READONLY, EXCLUDE<br>
&gt;=C2=A0 =C2=A08 .altinstructions 00001284=C2=A0 0000000000000000=C2=A0 0=
000000000000000=C2=A0 00015700=C2=A0 2**0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, RELOC, READONLY, DATA<br>
&gt;=C2=A0 =C2=A09 __jump_table=C2=A0 00000960=C2=A0 0000000000000000=C2=A0=
 0000000000000000=C2=A0 00016988=C2=A0 2**3<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, RELOC, DATA<br>
&gt;=C2=A0 10 __bug_table=C2=A0 =C2=A00000051c=C2=A0 0000000000000000=C2=A0=
 0000000000000000=C2=A0 000172e8=C2=A0 2**2<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, RELOC, DATA<br>
&gt;=C2=A0 11 __kvm_ex_table 00000028=C2=A0 0000000000000000=C2=A0 00000000=
00000000=C2=A0 00017808=C2=A0 2**3<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, ALLOC, LOAD, RELOC, READONLY, DATA<br>
&gt;=C2=A0 12 .note.GNU-stack 00000000=C2=A0 0000000000000000=C2=A0 0000000=
000000000=C2=A0 00027370=C2=A0 2**0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CO=
NTENTS, READONLY<br>
&gt;<br>
&gt; So what am I missing to trigger this issue? Does it rely on something<=
br>
&gt; like PGO, which is not upstream yet? A bit of handholding would be<br>
&gt; much appreciated.<br>
<br>
Right, it relies on the PGO profile.<br>
On ChromeOS we collect the sample PGO profile from Arm devices with<br>
enabled CoreSight/ETM. You can find more details on ETM at<br>
<a href=3D"https://www.kernel.org/doc/Documentation/trace/coresight/coresig=
ht.rst" rel=3D"noreferrer" target=3D"_blank">https://www.kernel.org/doc/Doc=
umentation/trace/coresight/coresight.rst</a>.<br>
<br>
<a href=3D"https://github.com/Linaro/OpenCSD/blob/master/decoder/tests/auto=
-fdo/autofdo.md" rel=3D"noreferrer" target=3D"_blank">https://github.com/Li=
naro/OpenCSD/blob/master/decoder/tests/auto-fdo/autofdo.md</a><br>
contains information about the pipeline of collecting, processing, and appl=
ying<br>
the profile.<br>
<br></blockquote><div><div><br></div><div>Generally the difficult part is i=
n collecting a good matching profile for the workload.</div><div>So I think=
 this patch is better than previous since it still keeps the compiler optim=
ization for the hot code paths<br></div><div>in the file but removes the pr=
oblematic section.</div><br class=3D"gmail-Apple-interchange-newline"></div=
><div>Thanks,</div><div>Manoj</div><div>=C2=A0</div><div>=C2=A0</div><block=
quote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1=
px solid rgb(204,204,204);padding-left:1ex">
&gt;<br>
&gt; Thanks,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0M.<br>
&gt;<br>
&gt; --<br>
&gt; Without deviation from the norm, progress is not possible.<br>
<br>
Thanks,<br>
Denis<br>
</blockquote></div></div>

--0000000000005257f405e951f424--

--===============8958452815975543531==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8958452815975543531==--
