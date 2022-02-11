Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBA0C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Feb 2022 07:47:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 939C549F5A;
	Fri, 11 Feb 2022 02:47:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rJl+iSxipZr7; Fri, 11 Feb 2022 02:47:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A12E49F0B;
	Fri, 11 Feb 2022 02:47:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8142940D34
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 02:47:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JKwAWFyyu1ni for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Feb 2022 02:47:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C0E040C52
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Feb 2022 02:47:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1644565660;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QaXOsf3u+r2ufwTZMOtosmcIvxlt4ig9a/CYgvHucqc=;
 b=NFFJ0xCOW9IRL9oC5n8fLak4aeBcpPv8DvsrPr58+QhHhbEimwxu4xjRwhzmbKEj0voaG5
 Leee7/HjiIFjrSsvtgNtkqDODiJJUTjPQecGLSEy0NhlM7GcHLnx6RicEePLcCLOKwVMN0
 x46Upec2aHfbL/8qCFLiFNXgRtLDXYQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-Rgi189QsMUeLJFVeVVNomw-1; Fri, 11 Feb 2022 02:47:39 -0500
X-MC-Unique: Rgi189QsMUeLJFVeVVNomw-1
Received: by mail-wm1-f72.google.com with SMTP id
 bg16-20020a05600c3c9000b0034bea12c043so5514839wmb.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 23:47:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QaXOsf3u+r2ufwTZMOtosmcIvxlt4ig9a/CYgvHucqc=;
 b=mh6Mxce5/W9Zm1hzRlL3EYwxz3amA3tKOalei3qTNXAFoDpf9EwhRKPkMhhMcELqAw
 /AElimZpqcRAzJD2IBeDvYugI6BOE8fAVjJ7hL6pUI3XPgOFFIyeYvvZl5IkzPbhbkCQ
 n18t4nT9mmvN4yw+hNd+96eg/e3S8dqSFGpp7kE5K6vKsd8zg0zgaW0GQoaVWYumTTgh
 xbsq23C14ejx749i/F4b3Kkd1KBRG9SaBDv0MsQ3oA6TE07OOn+RlFXyfh2qHEFvLLVz
 40munz0XX6acf0akKDU41nMoyiDSozjCc1iCPf9t3y/lnjlovWtQpx8prSggQqq5N3zv
 L6aQ==
X-Gm-Message-State: AOAM532DhBRFpKYipp2CweHyfJ8c6uJA+mjYCYjwmOFWU53GczXiSaxj
 xWtIrtX0HrOxHpVIS52/svdoy95wGQ1P+rzXkMTC5kCjr8DlUFtBlTsASzP7xP4a1h/In0Oyn0f
 k239hoUBhTj3c27zS8QEyKqxg
X-Received: by 2002:adf:e34c:: with SMTP id n12mr301662wrj.263.1644565657881; 
 Thu, 10 Feb 2022 23:47:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwb0I1hItxkBN1IQnQVTbVivOEeEbaNAyMkZ7Or/dR+FOtWTucNQTNvIMOywMDQxiN+C07W8A==
X-Received: by 2002:adf:e34c:: with SMTP id n12mr301651wrj.263.1644565657711; 
 Thu, 10 Feb 2022 23:47:37 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id y14sm22953663wrd.91.2022.02.10.23.47.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Feb 2022 23:47:37 -0800 (PST)
Date: Fri, 11 Feb 2022 08:47:35 +0100
From: Andrew Jones <drjones@redhat.com>
To: Zixuan Wang <zxwang42@gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <20220211074735.erqk2uh6m6ci4zh5@gator>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
 <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Thu, Feb 10, 2022 at 11:48:03AM -0800, Zixuan Wang wrote:
> On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Feb 10, 2022, Zixuan Wang wrote:
> > > On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> > > <alexandru.elisei@arm.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > > > few other options:
> > > > >
> > > > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > > > seems like it would be sufficient.
> > > > >
> > > > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > > > option, but I changed it because I thought --target was more generic and
> > > > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > > > a test runner, so I think the impact on users should be minimal.
> > > > >
> > > > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > > > compiler, usurping that for something similar but slightly different is odd.
> > > >
> > > > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > > > suggestions for other names?
> > >
> > > How about --config-efi for configure, and CONFIG_EFI for source code?
> > > I thought about this name when I was developing the initial patch, and
> > > Varad also proposed similar names in his initial patch series [1]:
> > > --efi and CONFIG_EFI.
> >
> > I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
> > configure option and is familiar for kernel developers.  But for the actually
> > option, why require more typing?  I really don't see any benefit of --config-efi
> > over --efi.
> 
> I agree, --efi looks better than --target-efi or --config-efi.
>

Works for me.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
