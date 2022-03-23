Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EB0C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 22:25:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1293249EFD;
	Wed, 23 Mar 2022 18:25:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LNHtYB5KygtX; Wed, 23 Mar 2022 18:25:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A71D849F2C;
	Wed, 23 Mar 2022 18:25:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43E6B49F1F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:25:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d18KDrGy-TFp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 18:25:40 -0400 (EDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1603F49EFD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:25:39 -0400 (EDT)
Received: by mail-io1-f51.google.com with SMTP id d62so3433769iog.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Iw4wMyP5Sf7W5X1SZGLIFvrZ1vroraSXt5QoxGjdF1M=;
 b=FHQvXDNOL/p4c7tAShXmGLu/popVPfW38AKAwxh2ANgtNcIWhJWfHCPZYfyhM/AAk/
 +j/n8a7BB6UW7PmitudVKaPQJvhDziWaAK0FhG6LmrQ4J8w4khhOAS2d1L9F34Sg8Yvx
 YnXF/2SGLHH07V7QbBmUvY6h1RCMa3NZxgeCKFr4J/C+P+7NYug8FXhn1irgLBdQUO2a
 s6XZ54F2Ks+HAzaMbVV/x+vRkNPsEUrgTQW4QE994IEE8Vh8dmhPLCPgL5BUjGl6/3lO
 LVDogmh0MHe0CYiCysBKnsGgQc5hXtrgUCJJepWyv36g6zTjTjlEzZetrl7KipXF/GbW
 ogHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Iw4wMyP5Sf7W5X1SZGLIFvrZ1vroraSXt5QoxGjdF1M=;
 b=rg+s+iY+3JoyHXfXUZQhsM4ccw/3Aol07sl5GKr2Huxbf2fgXPmfeUA/crDtIfasiV
 2enudGIKEMP3k2JxUzzE6XswvmVrw5/Nwb8qk2KNHzM9nnjzE+KRNeKuDgwcbHmRyWrz
 Wpo0MBqlDOAkOraTxkXXtPdNu5yEl41tyjR27DPERmDN7enXKN/C/DL0JiUgCz72bO6R
 vIooroXKZ4Rm+chUk5sc6/mb2ZVQpvrWx4JbFiXEig2F/qYZlFztsCHU7TEAths9xQ+t
 p9SdVoS80GEIHjNMQfhkFFIMPuzDQmX7va2jc15tHW+Ek/UKgVQyn7dhSIdZT5JN4qUt
 UZ6Q==
X-Gm-Message-State: AOAM530rE6EaRM0bMnXpeI5QzhW65lBxnuPiWSriLHXpazDFoxzPC9YN
 qEGrtjwt9V2Eun4EHyZpFPmVbg==
X-Google-Smtp-Source: ABdhPJxFIaPDyYYMcQ0NO8UayiA1llXj46Qabe9a/Yfed4n4kjHRHD6mY3KZ7CChW/I8o13Kyd7LSQ==
X-Received: by 2002:a5d:83c8:0:b0:604:c09b:259c with SMTP id
 u8-20020a5d83c8000000b00604c09b259cmr1182670ior.106.1648074339082; 
 Wed, 23 Mar 2022 15:25:39 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 t7-20020a5e9907000000b00649d6bd1ec5sm575577ioj.31.2022.03.23.15.25.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 15:25:38 -0700 (PDT)
Date: Wed, 23 Mar 2022 22:25:35 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <YjueX2DOxjoc/d4j@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com> <Yjt/bJidLEPsiPfQ@google.com>
 <YjuGqunshjhCoIs5@google.com> <Yjuds73S1sO1UpJI@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yjuds73S1sO1UpJI@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Mar 23, 2022 at 03:22:43PM -0700, Ricardo Koller wrote:
> On Wed, Mar 23, 2022 at 08:44:26PM +0000, Oliver Upton wrote:
> > On Wed, Mar 23, 2022 at 01:13:32PM -0700, Ricardo Koller wrote:
> > > On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> > > > Hi Reiji,
> > > > 
> > > > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > > > Add hidden or reserved ID registers, and remaining ID registers,
> > > > > which don't require special handling, to id_reg_desc_table.
> > > > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > > > or reserved registers. Since now id_reg_desc_init() is called even
> > > > > for hidden/reserved registers, change it to not do anything for them.
> > > > > 
> > > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > 
> > > > I think there is a very important detail of the series that probably
> > > > should be highlighted. We are only allowing AArch64 feature registers to
> > > > be configurable, right? AArch32 feature registers remain visible with
> > > > their default values passed through to the guest. If you've already
> > > > stated this as a precondition elsewhere then my apologies for the noise.
> > > 
> > > Aren't AArch64 ID regs architecturally mapped to their AArch32
> > > counterparts?  They should show the same values.  I'm not sure if it's a
> > > problem (and if KVM is faithful to that rule),
> > 
> > I believe it's a bit more subtle than that. The AArch32 feature registers
> > are architecturally mapped to certain encodings accessible from AArch64.
> > For example, ID_PFR0_EL1 is actually a 64 bit register where bits [31:0]
> > map to the ID_PFR0 AArch32 register. ID_PFR0_EL1 is only accessible from
> > AArch64 with the MRS instruction, and ID_PFR0 is only accessible from
> > AArch32 with the MRC instruction. KVM just so happens to handle both of
> > these reads from the same sys_reg_desc.
> > 
> > AFAIK, there does not exist a direct bit mapping between the
> > ID_*_EL1 <-> ID_AA64*_EL1 registers. But hey, could be wrong :)
> 
> I think you are right. ID_PFR0_EL1[31:0] doesn't even have the same
> field as ID_AA64PFR0_EL1[31:0]. The only exception would be RAS which is
> at [31:28] on both, but it doesn't say anywhere that ID_PFR0_EL1.RAS
> maps architecturally to ID_AA64PFR0_EL1.RAS. So, I think we can assume
> it doesn't (?).

Right, the feature registers are generally related (you will find fields
of similar meaning), but figuring out that tangle and making it work is
going to be a massive waste of time IMO. If we can say that our new
feature configuration is AArch64-only, all potential bugs relating to
AArch32 collapse :-)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
