Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C39C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 19:36:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C944F49F32;
	Thu, 10 Feb 2022 14:36:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LH-nJqTd+WbT; Thu, 10 Feb 2022 14:36:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D53E649F2F;
	Thu, 10 Feb 2022 14:36:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BB1840FAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:36:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BdzINSRdXe66 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 14:36:10 -0500 (EST)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4845D40B9F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 14:36:10 -0500 (EST)
Received: by mail-pf1-f169.google.com with SMTP id y8so9349822pfa.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 11:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=X7ZCZU4H6FYuHw4L6H7qXi/BQnFS6lpLYRYNDIvWC0o=;
 b=HSmpVyxHHaDvzyRJNriQY8dA/ZYX59m6nbELEtzqkyKGO7p8K4V/p59R8t4a/eu0iS
 IQvO9f9bykaWsK5KXnF02a5wDG0KHrImRZwGO2M57ONNxGC++5yN4TfcWAYsUlrCyKRc
 DsTTWpgnETF7/gRQRB3ZsiKLE/NFaQJsLDaPto+nIKMVNUrbqhE5yFLxhRgtiLj/J4Ne
 VCBcwpOXD5SZ/VljpCOQso6JBLN1xjNF4I7YWxyrvbEk9+4tX6Kdplj0Q3h3iMr0UqXU
 gepfrDJhMvwVeLlBbxo1qm/lQonuQuBj/ia8odou5IaRQ8L1QNJUMdjxvvXV+irtE/NZ
 7ThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=X7ZCZU4H6FYuHw4L6H7qXi/BQnFS6lpLYRYNDIvWC0o=;
 b=u9IEXqIK2wWWrvWDYF3LA4okUjkcU5Hvw1ydXRhIyFqiWBJhSY8TMFDnTXi1DuENOU
 NH4cI+wmE//OzwazkQVrhEOqQc/idkl3/FK0rIckliXlyC/C4ZUSjyaAe2vpLpIh08qS
 Kqm9/CZyfm20Ppfe+PjD8mDQiVv/Zl03WoIziZYkbyH2I0oRB8Fb3PNIWM/bdIDfy4Nw
 M6tqCnZZfjASoNO9JfRYvAXauzSlepxjob2SvYfzG+UesI9h8sUF3+FLHHvR9EPbW7XZ
 BSA2N0SNefYBbZknwrJVLOPfPXH3SoILeUaqrYQ4axK/2nU/tpE719dUvpuVX/q3Zoi7
 bf9w==
X-Gm-Message-State: AOAM53190ssZ/URM4OHmR2Ex5o59aZRPLfCMUajDV4HHHwehjqwWEo0e
 yYHIcALytNg5pA8kcrNv0cbyGg==
X-Google-Smtp-Source: ABdhPJypBD7o9xuKglxcOPBFu3Ac2Z1GqUqRqrqpmpcmJjFId+/6MlGcfQVm5oPAgAGOBzPrHm9rlA==
X-Received: by 2002:a62:fb19:: with SMTP id x25mr8321417pfm.58.1644521769144; 
 Thu, 10 Feb 2022 11:36:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id n22sm25080018pfu.77.2022.02.10.11.36.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Feb 2022 11:36:08 -0800 (PST)
Date: Thu, 10 Feb 2022 19:36:04 +0000
From: Sean Christopherson <seanjc@google.com>
To: Zixuan Wang <zxwang42@gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgVpJDIfUVzVvFdx@google.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
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

On Thu, Feb 10, 2022, Zixuan Wang wrote:
> On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> >
> > Hi,
> >
> > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > few other options:
> > >
> > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > seems like it would be sufficient.
> > >
> > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > option, but I changed it because I thought --target was more generic and
> > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > a test runner, so I think the impact on users should be minimal.
> > >
> > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > compiler, usurping that for something similar but slightly different is odd.
> >
> > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > suggestions for other names?
> 
> How about --config-efi for configure, and CONFIG_EFI for source code?
> I thought about this name when I was developing the initial patch, and
> Varad also proposed similar names in his initial patch series [1]:
> --efi and CONFIG_EFI.

I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
configure option and is familiar for kernel developers.  But for the actually
option, why require more typing?  I really don't see any benefit of --config-efi
over --efi.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
