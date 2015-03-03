From: Arkajit Ghosh <ghoshtech1988@gmail.com>
Subject: Re: General Query Related to the KVM Page Migration
Date: Tue, 3 Mar 2015 09:35:32 +0530
Message-ID: <CALUr51qxtiT26eOk9EmMh9A=WV0UcGwAmSU9BRVoVPjAu3dk6w@mail.gmail.com>
References: <CALUr51ocKFMLwnXyekx9p_zjTTXcQ4OAY8hxXRUt5OgtMDqPnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2168254503152437195=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D12FA477E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 22:59:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QjwLAoov3OAQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 22:59:34 -0500 (EST)
Received: from mail-oi0-f48.google.com (mail-oi0-f48.google.com
 [209.85.218.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53F0C477DA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 22:59:34 -0500 (EST)
Received: by mail-oi0-f48.google.com with SMTP id a3so30976970oib.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 20:05:32 -0800 (PST)
In-Reply-To: <CALUr51ocKFMLwnXyekx9p_zjTTXcQ4OAY8hxXRUt5OgtMDqPnQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvm-commits@vger.kernel.org, Arkajit Ghosh <arkatech1988@gmail.com>, kvm-ia64@vger.kernel.org, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============2168254503152437195==
Content-Type: multipart/alternative; boundary=089e015370ba371fcb05105a7240

--089e015370ba371fcb05105a7240
Content-Type: text/plain; charset=UTF-8

Hi,
>
> Can any one please guide me how I can copy the system memory Page tables
> to dirty pages during the VM migration from one host to another host (Both
> host are in same subnet) in NUMA architecture node (Basically looking for
> some standard API). I am developing an application and this is one of the
> main requirement to do.
>
> I am dropping this mail to you because I came across from this site: *http://www.linux-kvm.org/page/Migration
> <http://www.linux-kvm.org/page/Migration>* , it is said that whole dirty
> pages or system memory transfer is possible during VM migration in KVM. As
> states below
>
> .........................................................................
>
> 2. Transfer Memory
>
>    - Guest continues to run
>    - Bandwidth limitation (controlled by the user)
>    - *First transfer the whole memory *
>    - * Iteratively transfer all dirty pages (pages that were written to
>    by the guest). *
>
>
>  ...........................................................................
>
> Please guide me. Thanks a lot in advance.
>
> Thanks & Regards
> Arkajit
>
> <8744869043>
>
>
>
>

--089e015370ba371fcb05105a7240
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div>Hi,<br><br></=
div>Can any one please guide me how I can copy the system memory Page table=
s to dirty pages during the VM migration from one host to another host (Bot=
h host are in same subnet) in NUMA architecture node (Basically looking for=
 some standard API). I am developing an application and this is one of the =
main requirement to do.<br><br></div>I am dropping this mail to you because=
 I came across from this site: <b><a href=3D"http://www.linux-kvm.org/page/=
Migration" target=3D"_blank">http://www.linux-kvm.org/page/Migration</a></b=
> , it is said that whole dirty pages or system memory transfer is possible=
 during VM migration in KVM. As states below<br><br>.......................=
..................................................<br><p>2. Transfer Memory
</p>
<ul><li> Guest continues to run
</li><li> Bandwidth limitation (controlled by the user)
</li><li> <b>First transfer the whole memory
</b></li><li><b> Iteratively transfer all dirty pages (pages that were writ=
ten to by the guest).
</b></li></ul>=C2=A0.......................................................=
....................<div><div><div><div><div><div dir=3D"ltr"><div><div sty=
le=3D"font-size:small"><br></div><div style=3D"font-size:small">Please guid=
e me. Thanks a lot in advance.<br></div><div style=3D"font-size:small"><br>=
</div><div style=3D"font-size:small">Thanks &amp; Regards</div><div style=
=3D"font-size:small">Arkajit</div><div style=3D"font-size:small"><br><a hre=
f=3D"tel:8744869043" value=3D"+918744869043" target=3D"_blank"></a></div><b=
r><br><br></div></div></div></div>
</div></div></div></div>
</blockquote></div><br></div></div>

--089e015370ba371fcb05105a7240--

--===============2168254503152437195==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2168254503152437195==--
