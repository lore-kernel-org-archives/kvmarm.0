Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7AEC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jun 2022 17:27:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 549994B2BC;
	Tue, 21 Jun 2022 13:27:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J-T-vdJ6y29S; Tue, 21 Jun 2022 13:27:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31F384B2C2;
	Tue, 21 Jun 2022 13:27:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AD694B2DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:27:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fKMc40vJyJc6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jun 2022 13:27:51 -0400 (EDT)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1113B4B2BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:27:50 -0400 (EDT)
Received: by mail-pg1-f181.google.com with SMTP id h192so13738154pgc.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 10:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KosiNj3YNLlbRK+vwldOUZcVPdw3Sy1cjQrcoE0ds2g=;
 b=o3FQhCiPU79gM9QSey1nVtIDqruLiydkTG9l+XcF04HDSGQFzIW5YUOvNuq/Mk8Ofz
 vISENPhAsPE86DtG32UwDFoBBA+kPGRDnBUNVp/rJmB48pzsyvqO/+R0r0XXixeR1ZWW
 98V4gI15W8jDZVSZxqi+XieFmk1N81GqONqQcGBLamJj7UmGE1Uzw+1hJZU3lw/G9EE+
 PDrjfyrA93NJoQqVDFaZrUf9YdMWf30s+uxZ+oZr6z2omBFCarn/dEOuXbEYFSab1yO/
 uTlnFz9DkGJhyo2Btkxd/MykAz4crPCqDUTkNzg0+RAi5F8GAJvhXF6cec7fDMUkffNE
 51bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KosiNj3YNLlbRK+vwldOUZcVPdw3Sy1cjQrcoE0ds2g=;
 b=HA2rBerHGtkAeyd5ci4KhAOf8yxNxdzmmu99AEVR9tGPeHV3aldDoAtSTWHR1U9T7M
 YJMXX2qA3gL6rvZ/V/7JljDwGpVeRE05UszXaZi4wKUqGXk2hsTQN5NXUqcBWPgdzgDB
 zyO8OuRkO2gTc7fjyIKrti2BLqurvZMDgTN9t6SFj7dEd96fQGlr3wK8fCpNQYP6Pcjv
 tZYDUNFavBnav/z7mpX+azB+yU5IadkxVktympDpuTXKaI0WG5HtIH6pCCzifZ+9vFQ4
 lC0fhSx6uLXM4gXsO/+V/STFcA5PDkqvGxKJEFEGVQjpfefx0DC2rCWWJucy/YcOlpXA
 Se6g==
X-Gm-Message-State: AJIora9CfwxJEpMl1J7JH3rhHpar16hiHtD8UT6nadh+qKmiSI8xSGql
 40kO9auExr10AyMElHQzePMu9A==
X-Google-Smtp-Source: AGRyM1sn5aCSMgS5NUyy3XSMR5k1j/lGDPRdso1aw12M5LEPZ/CN//TgTZSfDqmXHmvaNJ3NWGf+lg==
X-Received: by 2002:a05:6a00:885:b0:510:950f:f787 with SMTP id
 q5-20020a056a00088500b00510950ff787mr30877821pfj.83.1655832469779; 
 Tue, 21 Jun 2022 10:27:49 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 x6-20020a1709029a4600b0015e8d4eb1d1sm11008703plv.27.2022.06.21.10.27.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Jun 2022 10:27:49 -0700 (PDT)
Date: Tue, 21 Jun 2022 17:27:45 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 10/22] KVM: x86/mmu: Pass memory caches to allocate
 SPs separately
Message-ID: <YrH/kd5g08rvZkTt@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-11-dmatlack@google.com>
 <YqyXYJsoZGgp7l62@google.com>
 <CALzav=fVzX+GXCdKRwRGofAgKatX206_kBKagT7R-eYO9RnYkA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=fVzX+GXCdKRwRGofAgKatX206_kBKagT7R-eYO9RnYkA@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, Jun 21, 2022, David Matlack wrote:
> On Fri, Jun 17, 2022 at 8:02 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, May 16, 2022, David Matlack wrote:
> > > Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
> > > will allocate the various pieces of memory for shadow pages as a
> > > parameter, rather than deriving them from the vcpu pointer. This will be
> > > useful in a future commit where shadow pages are allocated during VM
> > > ioctls for eager page splitting, and thus will use a different set of
> > > caches.
> > >
> > > Preemptively pull the caches out all the way to
> > > kvm_mmu_get_shadow_page() since eager page splitting will not be calling
> >
> > Uber nit, "eager hugepage splitting" to provide a mental cue/reminder for why
> > those pages are direct.
> 
> I think it may be too late to move away from the term "eager page
> splitting" (it is already in commit messages and the module param is
> called "eager_page_split"). Using a slightly different name here might
> produce more confusion, or at least cause readers to do a double-take.

True.  I'm totally fine omitting "huge".

> But naming aside, I don't follow what you mean here. i.e. What does
> the fact that page splitting uses direct shadow pages have to do with
> this patch?

I have no idea.  I suspect I was looking at a different patch when replying to
this one.  I distinctly remember pausing for a few seconds to recall the direct
aspect, but looking back at this patch I don't see what I could have possibly be
wondering about.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
