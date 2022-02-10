Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034E5C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 21:55:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61D2A40431;
	Thu, 10 Feb 2022 16:55:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0HeJjCNdduPG; Thu, 10 Feb 2022 16:55:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36C4640AFA;
	Thu, 10 Feb 2022 16:55:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D735749F2F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:31:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7vOAkj0FFbYq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 14:31:33 -0500 (EST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEFE749EF3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:31:32 -0500 (EST)
Received: by mail-lf1-f46.google.com with SMTP id f41so5175978lfv.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 11:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YV7m43lW01+30L4cJfH2Iw5JSUBAH1SM73s9lnsoK9w=;
 b=gbWeYOhQiRnb8jPf5HKGRvZVFiNwiCG5pDavy5zRNbcS57wGnNDd0yC/ZCOnk3dBo8
 ekHOdjb6l33u41dM3bM/NlssICsWUEXWG8LoBqtJscR5zsQqxdbc33JyRj8/cy4nO8Bc
 xBM8OFMuTrirsHKn1QhHi5jOoi51nBnQsk++Q1qqSnBEOISJEPgw1/Of9eM9pUEJiapc
 jDp5kXnLRTysjPsIM5BJotH4tbsQSBcK4XVHWfEnXkFMNExPvzz/xR6Su2MSSv/L0Dkb
 a9PnCFTEBccE8QxIa3ymNWv9Eutv0lyJlqlUhUmnH08aauiERZHsOMg6eelMRHlQghWi
 zqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YV7m43lW01+30L4cJfH2Iw5JSUBAH1SM73s9lnsoK9w=;
 b=WTBZ+eh2JVIUes4lXEgylS2JcuKxXuL3OjzFHbWgYZ4FCXKsf+BGzHbW1wPNuWbyPW
 EzhbNPg3PTiuwArLzKk9BNVkPkrvUyYqN3DQuAyTnjAMhgjRqhZkDoS0TQemDimQ5mWR
 ujwYK9ZuU4BeQIt1KG1I/8nbHZhRLt8sOc1TyVA4Wbk2MUlc4rj5Zqp7BZXsnRkofLug
 Li0tY2fXyuU8W9ApSpigHdkpFfEJy+FhTGPFMPq7qHEv46XwwNo0zCNlIEvfd/BykBsF
 3/4Vqe4FnCE1bc8iIyHwItJxOtnqh0LAur0GOu6f+H2pj8RGMtVrNMAto6MFiL8XaYgL
 vthQ==
X-Gm-Message-State: AOAM532E9P6fptVFqU87h1sLSQZf0Zl18W+h7BEM4g328HVs7Mhw8fmP
 3ojzkWblqmLWEcDctYoec6ELSZfn+2oThWnpiLMIP2pR
X-Google-Smtp-Source: ABdhPJyx6CUZeqEnp1CPbqshcBbV3uSIOGIIpzCGWxHlngrSN7TAikAv4oHo3jE88DLmxSgPvJjep6TxvDJT2UJ8E48=
X-Received: by 2002:ac2:44ad:: with SMTP id c13mr6247450lfm.339.1644521491545; 
 Thu, 10 Feb 2022 11:31:31 -0800 (PST)
MIME-Version: 1.0
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com> <YgVPPCTJG7UFRkhQ@monolith.localdoman>
In-Reply-To: <YgVPPCTJG7UFRkhQ@monolith.localdoman>
From: Zixuan Wang <zxwang42@gmail.com>
Date: Thu, 10 Feb 2022 11:30:55 -0800
Message-ID: <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
To: Alexandru Elisei <alexandru.elisei@arm.com>
X-Mailman-Approved-At: Thu, 10 Feb 2022 16:55:40 -0500
Cc: thuth@redhat.com, kvm list <kvm@vger.kernel.org>,
 Zixuan Wang <zixuanwang@google.com>, kvmarm@lists.cs.columbia.edu,
 Paolo Bonzini <pbonzini@redhat.com>, Varad Gautam <varad.gautam@suse.com>
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

On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > configuring the tests. If the rename is not acceptable, I can think of a
> > > few other options:
> >
> > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > seems like it would be sufficient.
> >
> > > 1. Rename --target to --vmm. That was actually the original name for the
> > > option, but I changed it because I thought --target was more generic and
> > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > to run as an EFI payload. I realize now that separating the VMM from
> > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > a test runner, so I think the impact on users should be minimal.
> >
> > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > compiler, usurping that for something similar but slightly different is odd.
>
> Wouldn't that mean that --target-efi is equally confusing? Do you have
> suggestions for other names?

How about --config-efi for configure, and CONFIG_EFI for source code?
I thought about this name when I was developing the initial patch, and
Varad also proposed similar names in his initial patch series [1]:
--efi and CONFIG_EFI.

[1] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
