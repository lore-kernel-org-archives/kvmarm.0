Return-Path: <SRS0=IlRN=GY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AB0C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jan 2021 02:35:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C13532389A
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jan 2021 02:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C13532389A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 088714B17D;
	Wed, 20 Jan 2021 21:35:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id atoD1FinaJSs; Wed, 20 Jan 2021 21:35:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82A74B145;
	Wed, 20 Jan 2021 21:35:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E90554B139
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 21:35:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sY6q0QlSw3Ia for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jan 2021 21:35:31 -0500 (EST)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F2D14B128
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 21:35:31 -0500 (EST)
Received: by mail-io1-f50.google.com with SMTP id u17so1202162iow.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jan 2021 18:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WmC5mZubUEyw1k83qvu7dF62VwKczjnM3jCGiBWcgcw=;
 b=ClhSQtCkIP59ZdPT4wIdsub80t1vC2L1pYAn3EkJgEwyk3/hR3WKtRjZXk1hdskg+M
 1MKOWWE+4r/D4nl+XYdtABUXbWF4NLv4jg9unAmamM0j5dF+ERFzCYEI8we1T2xY3DBg
 WgTmefUazyEYeUMVoY7SIbC0ZDoS6iJM6/2bncrh6SYJene05cAFivGUGT/wyFOK2VXW
 C8HJgMT8lGZZkq3Txx8AH9Q7Eo5oqAaw0GCgowD4G6Fe7U+4cGcznkkFlI5+uYAqI3H+
 9QqB+AfkMao70ZJfcsBZ6BK6ucoJpDk3Nx4wQCGbJHNMIWqYdPzCFYwCQb5HvsMXH4Sh
 i1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WmC5mZubUEyw1k83qvu7dF62VwKczjnM3jCGiBWcgcw=;
 b=W9madjw5mrZfKRKOBkUIJ79vZ3uIeljEVXuY3JnXSJUwqUFdvb/JHIM579zV+VGcru
 yUVFzX5Iw0i6KQQSGuvW1fjHOTjNsEYWIdH6d36OUnvjov7g+0dAt/t/SN2vh9+MLjuz
 ZwvNwILG1F0Y4dbikVe3jmmZ5fcgbS0dvWUnjzbVHY4MC0aFtP2bcPPvOWg1N0gs41Or
 qWIqQSUcIPQkHr9eVEiNWTAUTeCoFiM+xG9kdU7eO427DCFn52EfTEI4pMy+gwUHBiNm
 p4eSAVH3LprUM6ACsRfmErqMuseVOHDtHbtMYudyE+IfZ5x9W7EabMa8fotpSa2KrnxZ
 o/dQ==
X-Gm-Message-State: AOAM5335qKOzKgNn6i8pboV4JlSP1V3oa3C7o9VIub6n9Q/pymYs/87e
 kJ1+i1+QfujgPugDMWpyXu3A7CxFjaHaH7aAQ1Mb
X-Google-Smtp-Source: ABdhPJwpOo1Iq6pjGF5ftpsiq/GSSNoXHgOYtRCWr5fYmJHsv5RD3T2jXHqEBCMdB8u0J4CwwKT0GCNNd1QToKUCIDY=
X-Received: by 2002:a05:6638:a0a:: with SMTP id
 10mr10193196jan.103.1611196530882; 
 Wed, 20 Jan 2021 18:35:30 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org>
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Thu, 21 Jan 2021 10:35:19 +0800
Message-ID: <CAJc+Z1Fg-Xrzmx1MMqmtqg1jhzDjn1h1rBvNDemWjjtZ20iqhA@mail.gmail.com>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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
Content-Type: multipart/mixed; boundary="===============9170938993488471735=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============9170938993488471735==
Content-Type: multipart/alternative; boundary="000000000000e3192605b95fec64"

--000000000000e3192605b95fec64
Content-Type: text/plain; charset="UTF-8"

On Fri, 11 Dec 2020 at 00:00, Marc Zyngier <maz@kernel.org> wrote:
>
> This is a rework of the NV series that I posted 10 months ago[1], as a
> lot of the KVM code has changed since, and the series apply anymore
> (not that anybody really cares as the the HW is, as usual, made of
> unobtainium...).
>
> From the previous version:
>
> - Integration with the new page-table code
> - New exception injection code
> - No more messing with the nVHE code
> - No AArch32!!!!
> - Rebased on v5.10-rc4 + kvmarm/next for 5.11
>
> From a functionality perspective, you can expect a L2 guest to work,
> but don't even think of L3, as we only partially emulate the
> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
> as well as anything that would require a Stage-1 PTW. What we want to
> achieve is that with NV disabled, there is no performance overhead and
> no regression.
>
> The series is roughly divided in 5 parts: exception handling, memory
> virtualization, interrupts and timers for ARMv8.3, followed by the
> ARMv8.4 support. There are of course some dependencies, but you'll
> hopefully get the gist of it.
>
> For the most courageous of you, I've put out a branch[2]. Of course,
> you'll need some userspace. Andre maintains a hacked version of
> kvmtool[3] that takes a --nested option, allowing the guest to be
> started at EL2. You can run the whole stack in the Foundation
> model. Don't be in a hurry ;-).
>
> And to be clear: although Jintack and Christoffer have written tons of
> the stuff originaly, I'm the one responsible for breaking it!
>
> [1] https://lore.kernel.org/r/20200211174938.27809-1-maz@kernel.org
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
kvm-arm64/nv-5.11.-WIP
> [3] git://linux-arm.org/kvmtool.git nv/nv-wip-5.2-rc5

Hi Marc,

I have tried to enable the NV support in Qemu, and now I can successfully
boot a L2 guest
in Qemu KVM mode.

This patch series looks good from the Qemu side except for two minor
requirements:
(1) Qemu will check whether a feature was supported by the KVM cap when the
user tries
     to enable it in the command line, so a new capability was prefered for
the NV(KVM_CAP_ARM_NV?).
(2) According to the Documentation/virt/kvm/api.rst
<https://github.com/torvalds/linux/blob/master/Documentation/virt/kvm/api.rst#482-kvm_arm_vcpu_init>,
userspace can call KVM_ARM_VCPU_INIT
     multiple times for a given vcpu, but the kvm_vcpu_init_nested() do
have some issue when
     called multiple times(please refer to the detailed comments in patch
63)

Regards,
Haibo

--000000000000e3192605b95fec64
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Fri, 11 Dec 2020 at 00:00, Marc Zyngier &lt;<a href=3D"=
mailto:maz@kernel.org">maz@kernel.org</a>&gt; wrote:<br>&gt;<br>&gt; This i=
s a rework of the NV series that I posted 10 months ago[1], as a<br>&gt; lo=
t of the KVM code has changed since, and the series apply anymore<br>&gt; (=
not that anybody really cares as the the HW is, as usual, made of<br>&gt; u=
nobtainium...).<br>&gt;<br>&gt; From the previous version:<br>&gt;<br>&gt; =
- Integration with the new page-table code<br>&gt; - New exception injectio=
n code<br>&gt; - No more messing with the nVHE code<br>&gt; - No AArch32!!!=
!<br>&gt; - Rebased on v5.10-rc4 + kvmarm/next for 5.11<br>&gt;<br>&gt; Fro=
m a functionality perspective, you can expect a L2 guest to work,<br>&gt; b=
ut don&#39;t even think of L3, as we only partially emulate the<br>&gt; ARM=
v8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,<br>&gt;=
 as well as anything that would require a Stage-1 PTW. What we want to<br>&=
gt; achieve is that with NV disabled, there is no performance overhead and<=
br>&gt; no regression.<br>&gt;<br>&gt; The series is roughly divided in 5 p=
arts: exception handling, memory<br>&gt; virtualization, interrupts and tim=
ers for ARMv8.3, followed by the<br>&gt; ARMv8.4 support. There are of cour=
se some dependencies, but you&#39;ll<br>&gt; hopefully get the gist of it.<=
br>&gt;<br>&gt; For the most courageous of you, I&#39;ve put out a branch[2=
]. Of course,<br>&gt; you&#39;ll need some userspace. Andre maintains a hac=
ked version of<br>&gt; kvmtool[3] that takes a --nested option, allowing th=
e guest to be<br>&gt; started at EL2. You can run the whole stack in the Fo=
undation<br>&gt; model. Don&#39;t be in a hurry ;-).<br>&gt;<br>&gt; And to=
 be clear: although Jintack and Christoffer have written tons of<br>&gt; th=
e stuff originaly, I&#39;m the one responsible for breaking it!<br>&gt;<br>=
&gt; [1] <a href=3D"https://lore.kernel.org/r/20200211174938.27809-1-maz@ke=
rnel.org">https://lore.kernel.org/r/20200211174938.27809-1-maz@kernel.org</=
a><br>&gt; [2] git://<a href=3D"http://git.kernel.org/pub/scm/linux/kernel/=
git/maz/arm-platforms.git">git.kernel.org/pub/scm/linux/kernel/git/maz/arm-=
platforms.git</a> kvm-arm64/nv-5.11.-WIP<br>&gt; [3] git://<a href=3D"http:=
//linux-arm.org/kvmtool.git">linux-arm.org/kvmtool.git</a> nv/nv-wip-5.2-rc=
5<br><br>Hi Marc,<br><br>I have tried to enable the NV support in Qemu, and=
 now I can successfully boot a L2 guest<div>in Qemu KVM mode.<br><br>This p=
atch series looks good from the Qemu side except for two minor requirements=
:<br>(1) Qemu will check whether a feature was supported by the KVM cap whe=
n the user tries<br>=C2=A0 =C2=A0 =C2=A0to enable it in the command line, s=
o a new capability was prefered for the NV(KVM_CAP_ARM_NV?).<br>(2) Accordi=
ng to the <a href=3D"https://github.com/torvalds/linux/blob/master/Document=
ation/virt/kvm/api.rst#482-kvm_arm_vcpu_init">Documentation/virt/kvm/api.rs=
t</a>, userspace can call=C2=A0KVM_ARM_VCPU_INIT<br><div>=C2=A0 =C2=A0 =C2=
=A0multiple times for a given vcpu, but the=C2=A0kvm_vcpu_init_nested() do =
have some issue when</div><div>=C2=A0 =C2=A0 =C2=A0called multiple times(pl=
ease refer to the detailed comments in patch 63)</div><div><br></div><div>R=
egards,</div><div>Haibo</div></div></div>

--000000000000e3192605b95fec64--

--===============9170938993488471735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============9170938993488471735==--
