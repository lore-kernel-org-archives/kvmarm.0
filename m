From: Mike Bazov <mike@perception-point.io>
Subject: Re: Compiling KVM/ARM as a separate kernel module.
Date: Tue, 10 Apr 2018 16:19:47 +0300
Message-ID: <CAE3G1Z_xu+AzfGA9tA0KohsRhkbFdOtmKDMSGEmQVP9PPFXU2A@mail.gmail.com>
References: <CAE3G1Z_HJqkWeGEESTVg+5yarWND7KR-QLOL1sRu_ey-xGZdKw@mail.gmail.com>
 <3503fcbb-5e80-0421-ec46-8f765c195243@arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0559595746522526348=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A57A4A007
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 09:11:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3A+x9CkUqTzV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Apr 2018 09:11:05 -0400 (EDT)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 631B149DC8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 09:11:05 -0400 (EDT)
Received: by mail-lf0-f54.google.com with SMTP id g203-v6so11614148lfg.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 06:19:50 -0700 (PDT)
In-Reply-To: <3503fcbb-5e80-0421-ec46-8f765c195243@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============0559595746522526348==
Content-Type: multipart/alternative; boundary="94eb2c1a645c76a3ac05697e60e2"

--94eb2c1a645c76a3ac05697e60e2
Content-Type: text/plain; charset="UTF-8"

Greetings,

I'm developing a product based on KVM/ARM, in which i need to modify the
code that is responsible for entering
into guest mode(i.e. EL1?) and i don't really want to recompile the kernel
and flash it again as part of my development. I need to run
on baremetal(on the board itself) when testing my code.

Any plans for supporting this in the near future? or any other suggestions
on a less painful development process?

Thanks,
Mike.

On Tue, Apr 10, 2018 at 12:48 PM, James Morse <james.morse@arm.com> wrote:

> Hi Mike,
>
> On 10/04/18 09:23, Mike Bazov wrote:
> > I'm trying to compile the KVM/ARM as a separate kernel module, just like
> > the x86 modules. When i compile the x86 modules, i get the "kvm.ko" and
> > "kvm-intel.ko" as an output. Is there any way of compiling the KVM/ARM as
> > modules as well?
>
> Not today. KVM has to map its code to run in a different CPU mode, the
> code that
> does this assumes its physically contiguous and part of the kernel text.
>
>
> > There is also no option for specifying "M" (modular) in the menuconfig
> when
> > choosing the virtualization and KVM option, like in x86.
>
> No, because its not supported. On arm/arm64 KVM is either built as part of
> the
> kernel, or not.
>
> Why do you need KVM as a loadable module?
>
>
> Thanks,
>
> James
>
>

--94eb2c1a645c76a3ac05697e60e2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Greetings,<div><br></div><div>I&#39;m developing a product=
 based on KVM/ARM, in which i need to modify the code that is responsible f=
or entering</div><div>into guest mode(i.e. EL1?) and i don&#39;t really wan=
t to recompile the kernel and flash it again as part of my development. I n=
eed to run</div><div>on baremetal(on the board itself) when testing my code=
.</div><div><br></div><div>Any plans for supporting this in the near future=
? or any other suggestions on a less painful development process?</div><div=
><br></div><div>Thanks,</div><div>Mike.</div></div><div class=3D"gmail_extr=
a"><br><div class=3D"gmail_quote">On Tue, Apr 10, 2018 at 12:48 PM, James M=
orse <span dir=3D"ltr">&lt;<a href=3D"mailto:james.morse@arm.com" target=3D=
"_blank">james.morse@arm.com</a>&gt;</span> wrote:<br><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">Hi Mike,<br>
<span class=3D""><br>
On 10/04/18 09:23, Mike Bazov wrote:<br>
&gt; I&#39;m trying to compile the KVM/ARM as a separate kernel module, jus=
t like<br>
&gt; the x86 modules. When i compile the x86 modules, i get the &quot;kvm.k=
o&quot; and<br>
&gt; &quot;kvm-intel.ko&quot; as an output. Is there any way of compiling t=
he KVM/ARM as<br>
&gt; modules as well?<br>
<br>
</span>Not today. KVM has to map its code to run in a different CPU mode, t=
he code that<br>
does this assumes its physically contiguous and part of the kernel text.<br=
>
<span class=3D""><br>
<br>
&gt; There is also no option for specifying &quot;M&quot; (modular) in the =
menuconfig when<br>
&gt; choosing the virtualization and KVM option, like in x86.<br>
<br>
</span>No, because its not supported. On arm/arm64 KVM is either built as p=
art of the<br>
kernel, or not.<br>
<br>
Why do you need KVM as a loadable module?<br>
<br>
<br>
Thanks,<br>
<br>
James<br>
<br>
</blockquote></div><br></div>

--94eb2c1a645c76a3ac05697e60e2--

--===============0559595746522526348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============0559595746522526348==--
