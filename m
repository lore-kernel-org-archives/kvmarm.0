Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFACC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 21:55:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E6CD4087B;
	Thu, 10 Feb 2022 16:55:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gg8B6hEo+nya; Thu, 10 Feb 2022 16:55:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5899340B9F;
	Thu, 10 Feb 2022 16:55:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85DAC4291D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:48:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jsbz476pYIM5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 14:48:40 -0500 (EST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com
 [209.85.208.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE1314141A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:48:40 -0500 (EST)
Received: by mail-lj1-f181.google.com with SMTP id k18so9482464lji.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 11:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=mp6/zsAuzd6lQaBPLCwcBd2CC2OBncN9PY8Mg62kvT0=;
 b=pwBCi1NjwIEa1M4QRfRcZP6qJhbNCa37epiBEiqNO1eOZSSMj2Ni2Zf2DViQ7slU6R
 Gh91ZuoUvSsRnKLyIRGT8hCU1qr4nO0UlogiZYl9ouFSFCgu/tutAbra1kz1q69Tz7AC
 gHH8S1Rv+jo5cI7Yx3ENQnb1GvsYIGXVoaxmCAsOKlTQBMYioxlnU2xRBVlneAI8/7mM
 3nWg6zJFNErIr70PvEsAOxk+UGpv6iCR+YfI+/49Pqlud3R0SdhBlwA98qcW9w+CK4Uh
 O46at5ccWRzyTB92gztTKDyxPz8//dnIKX2YpN43w6cz4ujr2BXXsbze89UVh5HHJ51e
 Fpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mp6/zsAuzd6lQaBPLCwcBd2CC2OBncN9PY8Mg62kvT0=;
 b=yLAwcJycRpnRZ5zdUVR8YxKzni/Kk8VzerZsUF1SDRHWQLFzcxsRWcTU4oG8fnfPHf
 RXe6gFdlm5zXnt2sJgSrfPoTtC1lZOM67cQk4MQBuYbqySbiQIUucLjcHefeTR2KgK6K
 x0427RuFyQvXbhfTkoZqptODxQXPwrYHQVX8OMPrSVrd5cpssboqSAXkchWtviaBWpWm
 JKW1TqRtwAkgqYBbCZRW+Q8bR7B8Ox1DNdkZE8BhXQSleDrDmGOia7AIqERYWk6TPoyz
 NWYxMP5+VSxoyJWInaGbMY0tVa8OkZ0VdlH8iEVzpTSkgkNlw8aNKX4rSyVkLBZpjDLq
 vRog==
X-Gm-Message-State: AOAM532W4jw01EaaLDKRVEwC7ruSZ5mfki2xag35iySo69RtA5E+Ldiv
 YEGg53vtnps/CeRGmeVyH0hRVdlCL8Y94PxH6fw=
X-Google-Smtp-Source: ABdhPJwVhhT91vjuEGyGF679QPPxcZTU0sy8pBOv1n6AzbZRSeIMO0+dfxulP248CdtHbx03SnvyZthnuzdyWqOJMuU=
X-Received: by 2002:a2e:9149:: with SMTP id q9mr3751383ljg.36.1644522519388;
 Thu, 10 Feb 2022 11:48:39 -0800 (PST)
MIME-Version: 1.0
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com> <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
In-Reply-To: <YgVpJDIfUVzVvFdx@google.com>
From: Zixuan Wang <zxwang42@gmail.com>
Date: Thu, 10 Feb 2022 11:48:03 -0800
Message-ID: <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Thu, 10 Feb 2022 16:55:40 -0500
Cc: thuth@redhat.com, kvm list <kvm@vger.kernel.org>,
 kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
 Varad Gautam <varad.gautam@suse.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Feb 10, 2022, Zixuan Wang wrote:
> > On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> > <alexandru.elisei@arm.com> wrote:
> > >
> > > Hi,
> > >
> > > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > > few other options:
> > > >
> > > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > > seems like it would be sufficient.
> > > >
> > > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > > option, but I changed it because I thought --target was more generic and
> > > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > > a test runner, so I think the impact on users should be minimal.
> > > >
> > > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > > compiler, usurping that for something similar but slightly different is odd.
> > >
> > > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > > suggestions for other names?
> >
> > How about --config-efi for configure, and CONFIG_EFI for source code?
> > I thought about this name when I was developing the initial patch, and
> > Varad also proposed similar names in his initial patch series [1]:
> > --efi and CONFIG_EFI.
>
> I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
> configure option and is familiar for kernel developers.  But for the actually
> option, why require more typing?  I really don't see any benefit of --config-efi
> over --efi.

I agree, --efi looks better than --target-efi or --config-efi.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
