Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2E7C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 16:20:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97266411BA;
	Fri, 11 Feb 2022 11:20:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qepyZfvxvpo5; Fri, 11 Feb 2022 11:20:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D05A49F0C;
	Fri, 11 Feb 2022 11:20:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 090FD49EE2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 11:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zBrVMkMzTqwU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Feb 2022 11:20:00 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 700D0411BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 11:20:00 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id v4so8546715pjh.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 08:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=nYPHl8dMIoFQJMeCg2hKGumzp/ft6Ah/5yUNeWO6Yuk=;
 b=Y+98Mn0k9Y4v5fP2XlMkV7VUllvqZMH6r75Ele8HG0lwKDSLpw93pyGD2jvCKXEhx4
 r/c0TNEvuYZiPQr5+hcFENrz+zuykRqvW8/Bn3kkVN2oX/v3g+WL/O+BFaZqiPUONxpU
 WNHMbQ+cewH98XHiTnddVg8QD8XAiE39WXdq96oNUOALzHWshbGxt1G4pIxsdZtvkmzZ
 gvp8vpmJRvu7sF2XJYvYhDxOqIPYOxxiW8+OVR8tbbZaQfnEttD6jjwvrS1dVyd1lDy4
 PK1fq62BQdSPMUJVgAX74mq8HoUGexfHrT3JhHVodyyiQun4yb3e3KheDvDFOchT7Pgr
 pQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nYPHl8dMIoFQJMeCg2hKGumzp/ft6Ah/5yUNeWO6Yuk=;
 b=gKNgbG+a0UjqlQsrJZHv52XwlcT4aO5+GCgKN2NOI9SxRF9Xd5tZAJNW/TvxquXb0E
 5AIyd2iNyxUi8oKCeSoIpwhGErwKMi6oValpv78TmDqM892Lcw213O+sMWpy8rThjgLx
 cQVjHmolZrerF3g6Y1gxUsanyEYm+oVUprC0tc+llkGm/iEPiVHFqRY38aOpBUbiriDH
 LPKcDhH6G8Y0MoLYnRPGJVUnQpbW2hCcSkxb7ldjz2+bWXa5eIYSEXv8372mQ3TQc4j7
 VsiuxnRgxtkV7TeGkxY6wS+m+cw4w8qz7SERRjFJw9N3D00108cQRLiZSLGVqXT+o3aW
 nVCQ==
X-Gm-Message-State: AOAM533mIk02bxnB5ddXB4Fe9x6abrF7Cu8uoh5CpSdZR8gPffvZkRBU
 N+scISvcRA+NrK0no38rcZd5SQ==
X-Google-Smtp-Source: ABdhPJxKLUlNFffoMbGq0cVYW6M/KUZ85oWXF/q9TTbCO0SlemFdL/UaiyRqxIcvu8L3rGQKk0XMZw==
X-Received: by 2002:a17:902:9346:: with SMTP id
 g6mr2363751plp.156.1644596399289; 
 Fri, 11 Feb 2022 08:19:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id 3sm5448066pjk.29.2022.02.11.08.19.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 11 Feb 2022 08:19:58 -0800 (PST)
Date: Fri, 11 Feb 2022 16:19:55 +0000
From: Sean Christopherson <seanjc@google.com>
To: Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgaMqwbWts3vQ6fD@google.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
 <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
 <f326daff-8384-4666-fc5e-6b7b509f6fe8@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f326daff-8384-4666-fc5e-6b7b509f6fe8@redhat.com>
Cc: Zixuan Wang <zxwang42@gmail.com>, kvm list <kvm@vger.kernel.org>,
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

On Fri, Feb 11, 2022, Thomas Huth wrote:
> On 10/02/2022 20.48, Zixuan Wang wrote:
> > On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Thu, Feb 10, 2022, Zixuan Wang wrote:
> > > > On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> > > > <alexandru.elisei@arm.com> wrote:
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > > > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > > > > few other options:
> > > > > > 
> > > > > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > > > > seems like it would be sufficient.
> > > > > > 
> > > > > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > > > > option, but I changed it because I thought --target was more generic and
> > > > > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > > > > a test runner, so I think the impact on users should be minimal.
> > > > > > 
> > > > > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > > > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > > > > compiler, usurping that for something similar but slightly different is odd.
> > > > > 
> > > > > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > > > > suggestions for other names?
> > > > 
> > > > How about --config-efi for configure, and CONFIG_EFI for source code?
> > > > I thought about this name when I was developing the initial patch, and
> > > > Varad also proposed similar names in his initial patch series [1]:
> > > > --efi and CONFIG_EFI.
> > > 
> > > I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
> > > configure option and is familiar for kernel developers.  But for the actually
> > > option, why require more typing?  I really don't see any benefit of --config-efi
> > > over --efi.
> > 
> > I agree, --efi looks better than --target-efi or --config-efi.
> 
> <bikeshedding>
> Or maybe --enable-efi ... since configure scripts normally take
> "--enable-..." or "--disable-..." parameters for stuff like this?
> </bikeshedding>

I don't hate it :-)  It'll also future-proof things if we ever make UEFI the
default for x86.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
