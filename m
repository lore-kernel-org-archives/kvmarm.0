Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E59C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 27 Mar 2022 22:57:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B0D49EF2;
	Sun, 27 Mar 2022 18:57:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LR6cUQVJH1mJ; Sun, 27 Mar 2022 18:57:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C7564B1B7;
	Sun, 27 Mar 2022 18:57:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 223C749EF2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Mar 2022 18:57:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6vnyE-yXD6gQ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Mar 2022 18:57:08 -0400 (EDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B27F649EF0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Mar 2022 18:57:08 -0400 (EDT)
Received: by mail-io1-f50.google.com with SMTP id p21so1133460ioj.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Mar 2022 15:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=CjWd0tIkzvNawm0BRbire5c+xv5CyJVt3CvwKbjZGYU=;
 b=HU76r327df81wux7lLJZxlV3xKwgkiZjrfmZN0JJlNrgn286Yoa3KZ3e+NFurt2IgZ
 n0v7rnpAql29TEOlz4ors0rA686wMsjljCfDmr2eg13AAHxepLJbv2rHOW7lwfO8dVqh
 v13zcVXNXuLHhcIOcJZUJNCoqTpfPKD+uRKD1VEOT8N+plRJkMFTUo1/Lak5SOkDR31A
 eKAjnziVgArmkcd4r2Z3iTyGhshRtWtKDXMkYlOME/wloMIutNcV6ZnUX/WmXrdp04tV
 2Uh4pSP1wPgF/AqyyqdxgblfNNGCtY57PicJzBObHDvMKzNQQ3qFEVoU0CY2sYcJScbK
 DEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=CjWd0tIkzvNawm0BRbire5c+xv5CyJVt3CvwKbjZGYU=;
 b=maVhurx681Cvcqy6oCNNjbmRtF9ArbG7b9bbha4GG3xm35K51YAoBPx6DpYVLRZXfq
 4R0scAbkpUEWGLdXc4j5e8LE5duClr2oVadlU7aIXN/TPgFZzRuyEztOR/PqxG1TTIx5
 uStlXknCJpfYWyV6xFd1k2wPN3rJU7OOdEIuqSS8SBs8oxHJav7bVE3NSyinCa1FtusO
 /8JVYqb+vbFttdbKHHqXkDPKwz7qGt4iQS41ZYjf3IbjeLhq3dLhsu0Kc4VlGzxOU94j
 r8XjvKnbLCKaLDNY/eskCjuQC8OvPFr9VdEstGR8Vp0f63FgB+9dvx3vxVPsKyuNVEkk
 2Hcw==
X-Gm-Message-State: AOAM530ZjhaTVgdxbeLVBDd8C4uXLEDrk4wh5lh+NhPo+cjcqyRyHeft
 LD5UqkP/APTNLmxRHVd4wflhyQ==
X-Google-Smtp-Source: ABdhPJzjbeGKj2yG5O0QaikywUktGbrV4+4ADpjpuGoc+EZm/o+U4LtS5BnIg2inPsj+f6pnLX9jsA==
X-Received: by 2002:a05:6602:22da:b0:645:ec83:6393 with SMTP id
 e26-20020a05660222da00b00645ec836393mr4926399ioe.165.1648421827735; 
 Sun, 27 Mar 2022 15:57:07 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 d15-20020a92360f000000b002c81e1fdae1sm6168555ila.85.2022.03.27.15.57.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 27 Mar 2022 15:57:06 -0700 (PDT)
Date: Sun, 27 Mar 2022 22:57:03 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <YkDrv2JdZhVFnGMk@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com>
 <YjtzZI8Lw2uzjm90@google.com>
 <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
 <YjywaFuHp8DL7Q9T@google.com>
 <CAAeT=FwkSUb59Uc35CJgerJdBM5ZCUExNnz2Zs2oHFLn0Jjbsg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FwkSUb59Uc35CJgerJdBM5ZCUExNnz2Zs2oHFLn0Jjbsg@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Fri, Mar 25, 2022 at 07:35:39PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> > > > > + */
> > > > > +#define KVM_ARM_ID_REG_MAX_NUM   64
> > > > > +#define IDREG_IDX(id)            ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > > > +
> > > > >   struct kvm_arch {
> > > > >           struct kvm_s2_mmu mmu;
> > > > > @@ -137,6 +144,9 @@ struct kvm_arch {
> > > > >           /* Memory Tagging Extension enabled for the guest */
> > > > >           bool mte_enabled;
> > > > >           bool ran_once;
> > > > > +
> > > > > + /* ID registers for the guest. */
> > > > > + u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > > >
> > > > This is a decently large array. Should we embed it in kvm_arch or
> > > > allocate at init?
> > >
> > >
> > > What is the reason why you think you might want to allocate it at init ?
> >
> > Well, its a 512 byte array of mostly cold data. We're probably
> > convinced that the guest is going to access these registers at most once
> > per vCPU at boot.
> >
> > For the vCPU context at least, we only allocate space for registers we
> > actually care about (enum vcpu_sysreg). My impression of the feature
> > register ranges is that there are a lot of registers which are RAZ, so I
> > don't believe we need to make room for uninteresting values.
> >
> > Additionally, struct kvm is visible to EL2 if running nVHE. I
> > don't believe hyp will ever need to look at these register values.
> 
> As saving/restoring breakpoint/watchpoint registers for guests
> might need a special handling when AA64DFR0_EL1.BRPs get changed,
> next version of the series will use the data in the array at
> EL2 nVHE.  They are cold data, and almost half of the entries
> will be RAZ at the moment though:)

Shouldn't we always be doing a full context switch based on what
registers are present in hardware? We probably don't want to leave host
watchpoints/breakpoints visible to the guest.

Additionally, if we are narrowing the guest's view of the debug
hardware, are we going to need to start trapping debug register
accesses? Unexposed breakpoint registers are supposed to UNDEF if we
obey the Arm ARM to the letter. Even if we decide to not care about
unexposed regs, I believe certain combinations of ID_AA64DF0_EL1.{BRPs,
CTX_CMPs} might require that we emulate.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
