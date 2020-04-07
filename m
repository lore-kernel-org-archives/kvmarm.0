Return-Path: <SRS0=lOre=5X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE709C2BB1D
	for <kvmarm@archiver.kernel.org>; Tue,  7 Apr 2020 11:32:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CA8D2063A
	for <kvmarm@archiver.kernel.org>; Tue,  7 Apr 2020 11:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iQ6c8ZHW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CA8D2063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE3794B0E9;
	Tue,  7 Apr 2020 07:32:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HlFqeAsarUVo; Tue,  7 Apr 2020 07:32:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C88CF4B0FB;
	Tue,  7 Apr 2020 07:32:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6D24B0F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Apr 2020 07:32:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i3NN4mpu5nOr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Apr 2020 07:32:39 -0400 (EDT)
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com
 [209.85.166.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A60674B0E9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Apr 2020 07:32:39 -0400 (EDT)
Received: by mail-il1-f196.google.com with SMTP id t11so2840643ils.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Apr 2020 04:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Ig2mq+AH5o0UP+b5KHhG9X0qqULQtiCnJDgxb4T5GVk=;
 b=iQ6c8ZHWKobiDdIZ3BcuUVM0Xewv31lvkznxohyjVKNlwXhELtKc0lVBLTq+EkrGvX
 0PneZH0rNVtsHE9O/beClqQx0aSDvFy8T8+/Lnb3xQy3P4YtyOtfaEBCCzMB29yCUH76
 3VJflY4XMe13gSIYOlwt8gmsbZFAGgOn+p9Cif2RL5HPVbG4K1nQ6Aohgh1olbcWOR3g
 eGnvSdmsEJ6d8cM8oHht5zQCtknJJuAeH9E/2rS9d5wHwb0dOT06x1Ka526c839KAtWA
 OTu6qp8WBlp+lmgK1vJL5L2BasL/gtpRzVEF1kPHqYPmPIn+aiMnLU7Kb5w2UWQ7Holj
 /p3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Ig2mq+AH5o0UP+b5KHhG9X0qqULQtiCnJDgxb4T5GVk=;
 b=WYV04JuNDWrRuUr6KRpyB7wIUxY8n1yb/5eqvsXy8BTTJUdpr842g6NxvuFSmuufQN
 u71YQRuZtH2lH4V1H/A5dcdzfYCnfo03nBBntPuoeSWll7M4ZA01ogwK06Zs5+QnXcaL
 g1GRt15qI1XKRP5mc+QZjgHm4g7+1JbCju4QXz2/Iuc9B3ixYsCukOfW2KzpP/y814UX
 ft6T4KFP6hFsQ1U0T/4EJqeTCkDLnRAUnWfrvFjAUWW8ldb6tCgQe6JuNTR8ThyFvA0F
 U/E5w3zphSSOi4McJSio4uNUy+SR7QWs0I37c09NngUKIC81UH3ekAR5PP3WGpU1UOd+
 rpuA==
X-Gm-Message-State: AGi0PuY2+92Pm5mgRkV9+1pPz/b62G4BHYHDFlvXrqem6AxHLmEvB2cG
 QMLj02rbgHfz+8S3tOgPhQdjeM1UnIN10YAECDImAQ==
X-Google-Smtp-Source: APiQypLPwRgW4x4+sMjDp/TWI4NTo7d5tYyS36ZSVaDFbxEF/D5s3AnWWgYm2v2l2t9PPVUgnprj5uycuII70QtXf4Q=
X-Received: by 2002:a92:3a8c:: with SMTP id i12mr1977302ilf.69.1586259159061; 
 Tue, 07 Apr 2020 04:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200323113227.3169-1-beata.michalska@linaro.org>
 <20200323113227.3169-3-beata.michalska@linaro.org>
 <20200403084435.zvfewiivn7orsnll@kamzik.brq.redhat.com>
 <CAFEAcA8fMzWhvt0R9MhXuLYb4Wo+Yz484HNC9YAE59yxz5xD0w@mail.gmail.com>
In-Reply-To: <CAFEAcA8fMzWhvt0R9MhXuLYb4Wo+Yz484HNC9YAE59yxz5xD0w@mail.gmail.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Tue, 7 Apr 2020 12:32:28 +0100
Message-ID: <CADSWDzsmpeXVKjDT7jKnx2XN18EWNOPsYJuxEUytofq8VZePww@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] target/arm: kvm: Handle potential issue with dabt
 injection
To: Peter Maydell <peter.maydell@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============7080173194101324153=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============7080173194101324153==
Content-Type: multipart/alternative; boundary="000000000000b2abce05a2b1bd16"

--000000000000b2abce05a2b1bd16
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 Apr 2020 at 12:24, Peter Maydell <peter.maydell@linaro.org> wrote:
>
> On Fri, 3 Apr 2020 at 09:44, Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Mon, Mar 23, 2020 at 11:32:27AM +0000, Beata Michalska wrote:
> > > Injecting external data abort through KVM might trigger
> > > an issue on kernels that do not get updated to include the KVM fix.
> > > For those and aarch32 guests, the injected abort gets misconfigured
> > > to be an implementation defined exception. This leads to the guest
> > > repeatedly re-running the faulting instruction.
> > >
> > > Add support for handling that case.
> > > [
> > >   Fixed-by: 018f22f95e8a
> > >       ('KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests')
> > >   Fixed-by: 21aecdbd7f3a
> > >       ('KVM: arm: Make inject_abt32() inject an external abort
instead')
> > > ]
> > >
>
> > I'll leave the decision to take this KVM bug workaround patch at all to
Peter,
> > and I didn't actually review whether or not
kvm_arm_verify_ext_dabt_pending
> > is doing what it claims it's doing, so I'm reluctant to give an r-b on
> > this patch. But, as far as the code goes, besides the comments above, it
> > looks fine to me.
>
> I think that having the workaround for the broken kernels is
> reasonable (in fact it might have been my suggestion).
>

I will update the current version to cover the review feedback
and resend the patches soon.

Thanks a lot!

BR
Beata
> thanks
> -- PMM

--000000000000b2abce05a2b1bd16
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br>
<br>
On Tue, 7 Apr 2020 at 12:24, Peter Maydell &lt;<a href=3D"mailto:peter.mayd=
ell@linaro.org" target=3D"_blank">peter.maydell@linaro.org</a>&gt; wrote:<b=
r>
&gt;<br>
&gt; On Fri, 3 Apr 2020 at 09:44, Andrew Jones &lt;<a href=3D"mailto:drjone=
s@redhat.com" target=3D"_blank">drjones@redhat.com</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt; On Mon, Mar 23, 2020 at 11:32:27AM +0000, Beata Michalska wrote:<=
br>
&gt; &gt; &gt; Injecting external data abort through KVM might trigger<br>
&gt; &gt; &gt; an issue on kernels that do not get updated to include the K=
VM fix.<br>
&gt; &gt; &gt; For those and aarch32 guests, the injected abort gets miscon=
figured<br>
&gt; &gt; &gt; to be an implementation defined exception. This leads to the=
 guest<br>
&gt; &gt; &gt; repeatedly re-running the faulting instruction.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Add support for handling that case.<br>
&gt; &gt; &gt; [<br>
&gt; &gt; &gt;=C2=A0 =C2=A0Fixed-by: 018f22f95e8a<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0(&#39;KVM: arm: Fix DFSR setting f=
or non-LPAE aarch32 guests&#39;)<br>
&gt; &gt; &gt;=C2=A0 =C2=A0Fixed-by: 21aecdbd7f3a<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0(&#39;KVM: arm: Make inject_abt32(=
) inject an external abort instead&#39;)<br>
&gt; &gt; &gt; ]<br>
&gt; &gt; &gt;<br>
&gt;<br>
&gt; &gt; I&#39;ll leave the decision to take this KVM bug workaround patch=
 at all to Peter,<br>
&gt; &gt; and I didn&#39;t actually review whether or not kvm_arm_verify_ex=
t_dabt_pending<br>
&gt; &gt; is doing what it claims it&#39;s doing, so I&#39;m reluctant to g=
ive an r-b on<br>
&gt; &gt; this patch. But, as far as the code goes, besides the comments ab=
ove, it<br>
&gt; &gt; looks fine to me.<br>
&gt;<br>
&gt; I think that having the workaround for the broken kernels is<br>
&gt; reasonable (in fact it might have been my suggestion).<br>
&gt;<br>
<br></div><div>
I will update the current version to cover the review feedback<br>
and resend the patches soon.<br>
<br>
Thanks a lot!<br>
<br>
BR<br>
Beata<br>
&gt; thanks<br>
&gt; -- PMM<br>
</div>

--000000000000b2abce05a2b1bd16--

--===============7080173194101324153==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============7080173194101324153==--
