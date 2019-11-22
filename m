Return-Path: <SRS0=LttP=ZO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D394DC432C0
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 17:51:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 548C720674
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 17:51:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YM1X+h3q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 548C720674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6A394AEB3;
	Fri, 22 Nov 2019 12:51:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k5WmIPt7+X-2; Fri, 22 Nov 2019 12:51:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EA104AEC6;
	Fri, 22 Nov 2019 12:51:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2714AEBE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 12:51:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qc2W1BRZLhS7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Nov 2019 12:51:20 -0500 (EST)
Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com
 [209.85.208.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DA614AEB3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 12:51:20 -0500 (EST)
Received: by mail-lj1-f195.google.com with SMTP id e9so8297695ljp.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 09:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/QGH/PLUF1RM4uxVt1zhQol9+dO5HqXbaQYAorq2ikE=;
 b=YM1X+h3qJWxB3a6nKrHaejQ85LRGnakC0l+FsMhoBz8voOhUsUxSRSCD/TpxW48z6m
 N2d9eXRENu5MhBF9WDm00JwnlJvk4iVRsO2aQhbuvOZMIN3LvoCVC4obf31hjNfEi4NH
 gq/EW7N0YGJ/e8lT2Na1DJq64CT5CffhKwUho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/QGH/PLUF1RM4uxVt1zhQol9+dO5HqXbaQYAorq2ikE=;
 b=Jycfe6ZnGekr5rDONo9MiCfEM81tkE/VCHDGaRIgXLJLRms2/mX7JbpyPVutFIeTP/
 hlp0mpZaoflSP30VXKcpSSFfOuWsx4xmWBS2OREsPEvhCPsYaLtk6LdSXGzcBCwLdGME
 NOZ/dzr8AUKYOgUFuKkpmUuLzFiFZMMft1VDvoYIm+junNkJrmStwrSzT4AtK+6SxXuU
 UnXRgGdPCC/9jDTCHhVHV4R4HAv7iHArXP1ttUzT4PSiocK0ivQAjLUP/bhGXkQyzpQz
 D8jhCFbGhlb1HOhFoCsM5nogNtPxVHaywoNrShd1JGUHTbXGwDaBRfQyizWsXXsf4PvW
 r9DA==
X-Gm-Message-State: APjAAAXjCNxLm/55P8Kbkgy4gUAKaUTte5ruVsFvqsFZfAKOs/sBjB4h
 mBKCy+xv9uNdDhmHsZsFC/UqAYUynQk=
X-Google-Smtp-Source: APXvYqysHzm0+yQ9oauYnNj+N18anE0Qd3c1/jg0qd2ha+lIRbNsat+WYkMc5zqkxaFGD7g1e9p3Zw==
X-Received: by 2002:a2e:998a:: with SMTP id w10mr13103224lji.66.1574445078666; 
 Fri, 22 Nov 2019 09:51:18 -0800 (PST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com.
 [209.85.208.173])
 by smtp.gmail.com with ESMTPSA id c19sm3277455ljj.61.2019.11.22.09.51.17
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 22 Nov 2019 09:51:18 -0800 (PST)
Received: by mail-lj1-f173.google.com with SMTP id e9so8297620ljp.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 09:51:17 -0800 (PST)
X-Received: by 2002:a2e:3805:: with SMTP id f5mr12692793lja.220.1574445077414; 
 Fri, 22 Nov 2019 09:51:17 -0800 (PST)
MIME-Version: 1.0
References: <CABVzXA=DGxc4eE0RQX=tGu3QAYQ0RmEL7Y=WZYWBr355zEp_vA@mail.gmail.com>
 <a07bd7883278838c26a955a1b4c43441@www.loen.fr>
In-Reply-To: <a07bd7883278838c26a955a1b4c43441@www.loen.fr>
From: Daniel Verkamp <dverkamp@chromium.org>
Date: Fri, 22 Nov 2019 09:50:50 -0800
X-Gmail-Original-Message-ID: <CABVzXAkeuHJOHcV1djsUOanbtNYbhsQ_vXe2ErKcpre0TRiCvA@mail.gmail.com>
Message-ID: <CABVzXAkeuHJOHcV1djsUOanbtNYbhsQ_vXe2ErKcpre0TRiCvA@mail.gmail.com>
Subject: Re: KVM_COMPAT support on aarch64
To: Marc Zyngier <maz@kernel.org>
Cc: Dylan Reid <dgreid@chromium.org>, kvmarm@lists.cs.columbia.edu
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

On Fri, Nov 22, 2019 at 7:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Daniel,
>
> [please use my kernel.org address, as I'm not employed by ARM anymore]
>
> On 2019-11-21 20:16, Daniel Verkamp wrote:
> > Hi Marc,
> >
> > I noticed that in recent kernels (4.19 in our case), KVM no longer
> > works for 32-bit processes running on arm64 machines. We
> > (Crostini/crosvm, Linux VM support on Chromebooks) use this
> > KVM_COMPAT
> > on all arm64-based Chromebooks that support VMs, since our entire
> > userspace (including crosvm) is 32-bit.
> >
> > I found this commit (KVM: arm64: Prevent KVM_COMPAT from being
> > selected):
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=37b65db85f9b2fc98267eee4a18d7506492e6e8c
> >
> > Is there any particular reason the compat ioctl is disabled (e.g.
> > actual bugs/breakage), or would it be possible to re-enable
> > KVM_COMPAT
> > for ARM64?
>
> Well, it never worked the first place! :( The whole API is entirely
> different,
> and you should feel extremely lucky that it ever seemed to work!

I hadn't looked at this before, but it seems like the Rust bindings
for KVM we are using are actually generated from the aarch64 C headers
(e.g. struct kvm_regs contains sp_el1, etc. rather than svc_regs):
https://chromium.googlesource.com/chromiumos/platform/crosvm/+/37bd738b783053c2e94b4c215c32496bae5081ed/kvm_sys/src/aarch64/bindings.rs
So we are really passing the native 64-bit structs to the 32-bit
compat ioctl, which is probably bogus.

I can see how this is unlikely to work in a normal C program compiled
against the 32-bit ARM uapi headers.

> > In my brief testing with a 4.19-stable-based kernel on a new arm64
> > board, everything seems to work fine with the commit above reverted.
>
> The key word here is *seems*. It may happen that the userspace ABI
> somehow align for some of the basic stuff, but it will fail for
> anything moderately serious (I really doubt QEMU would be able to
> run at all).
>
> I suppose to tried this with crosvm? 32 or 64bit guest?

Yes, I am able to run the full Crostini environment using 32-bit
crosvm on an aarch64 Chromebook kernel based on 4.19.84 stable.  The
guest kernel and userspace is 64 bit in this case (we don't support
32-bit guest).

I also just tried a 32-bit build of kvmtool (lkvm), since we have a
convenient ebuild to cross-compile it in the Chrome OS SDK, but I
wasn't able to get it to boot (it fails at a call to KVM_GET_ONE_REG).
I didn't attempt to debug it, but I'm assuming it's due to the ABI
mismatch you mentioned.

It sounds like disabling the compat ioctl is probably the right thing
to do in this case; I'll have to see if we can build crosvm as a
64-bit executable instead in the future (not sure how easily this will
be given the way the Chromium OS build system works).

Thanks,
-- Daniel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
