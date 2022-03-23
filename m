Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D105C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 22:22:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6362949EFD;
	Wed, 23 Mar 2022 18:22:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZYG6vA4L5Owa; Wed, 23 Mar 2022 18:22:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A01249F24;
	Wed, 23 Mar 2022 18:22:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5322D49F22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:22:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FwLefz7pg7fs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 18:22:49 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2577349EFD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:22:49 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id s72so2328929pgc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=yuhCT1XYYGgw1dNBRxPY3XRz8+9xX+vJlVURnfEK72s=;
 b=a6UMluZevPKT+3Dg9RSgS2V8HA5VIKtIYAYHNtZAilzCYPLEkP61tf7mwIeq9BnxHV
 X0SgovhpKa/+gqiVJN6lWUp1uqPIgn+vMHpzy4VXM3c5yJiRCCC7UOKbGbnjbjkhLAE7
 RHoBAkQ9xUgD9dL1xMdBPTjxKpnSLtsHOUrHXa/tPYiz85ecbU2IYJE4lBhgWY8zKwGF
 vqpuZjlGklfvuQhQrNXTf+r2eBpbhmqcZmGyDOFQNN46b1i50uXvRmRLSPk2NVi2GwpT
 8vFYEZYuHVzaBo1/gI+EK2Y8aj0KQFDtW7xPe3JsxzKdlPYgnKKD2PAnzmnuMs1FyqJE
 PHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=yuhCT1XYYGgw1dNBRxPY3XRz8+9xX+vJlVURnfEK72s=;
 b=UTLVzLXrknjXH88MeqjplAwuJghuHtMu83+cfpACY/G1j3SRO/IlA8AxNKnNrAstKN
 5E7BKUAo1J9pGkyFcQF8NGBrp7Dfv8dV5AldBGCzxYPEh1UppJ3VtOiiGpqZ+09q3ace
 mgsRxmYGXSiCPmuTyHF4c3iAAYear5lwRUbTU4cPS+FcVTdiOJvdCVp+2fMZXWB83hDA
 jz6vdQTOtkU1XcWj9kjTwfQyE7bE2qlNELIgfSX6DwHs/o98YL9VugN+8ECSrxamjbqE
 gCbzXDn2Z/eLVMBCknOH9JRgiFLa+gzrGn+2PUlgOFC/w1LkQW+q5o9VWhJUlFDG6wpx
 FKCg==
X-Gm-Message-State: AOAM530TxxxMghhzQ0l7Q97eK7h7mluGz2eediFKE4nWAVM/ijNbPTRG
 rfd7alpuILewFt2+AHoiQyHrog==
X-Google-Smtp-Source: ABdhPJzfVU2lcXkwbXmRJ0QbmK41CUoL1lq9MqK1Ux1D5KLG5O0S8v51famIcyUnsJNrUX/Wy/YeJQ==
X-Received: by 2002:a63:7f0e:0:b0:381:54ca:6fd0 with SMTP id
 a14-20020a637f0e000000b0038154ca6fd0mr1631352pgd.524.1648074167926; 
 Wed, 23 Mar 2022 15:22:47 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 fy9-20020a17090b020900b001c690bc05c4sm675504pjb.0.2022.03.23.15.22.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 15:22:47 -0700 (PDT)
Date: Wed, 23 Mar 2022 15:22:43 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <Yjuds73S1sO1UpJI@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com> <Yjt/bJidLEPsiPfQ@google.com>
 <YjuGqunshjhCoIs5@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YjuGqunshjhCoIs5@google.com>
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

On Wed, Mar 23, 2022 at 08:44:26PM +0000, Oliver Upton wrote:
> On Wed, Mar 23, 2022 at 01:13:32PM -0700, Ricardo Koller wrote:
> > On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> > > Hi Reiji,
> > > 
> > > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > > Add hidden or reserved ID registers, and remaining ID registers,
> > > > which don't require special handling, to id_reg_desc_table.
> > > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > > or reserved registers. Since now id_reg_desc_init() is called even
> > > > for hidden/reserved registers, change it to not do anything for them.
> > > > 
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > 
> > > I think there is a very important detail of the series that probably
> > > should be highlighted. We are only allowing AArch64 feature registers to
> > > be configurable, right? AArch32 feature registers remain visible with
> > > their default values passed through to the guest. If you've already
> > > stated this as a precondition elsewhere then my apologies for the noise.
> > 
> > Aren't AArch64 ID regs architecturally mapped to their AArch32
> > counterparts?  They should show the same values.  I'm not sure if it's a
> > problem (and if KVM is faithful to that rule),
> 
> I believe it's a bit more subtle than that. The AArch32 feature registers
> are architecturally mapped to certain encodings accessible from AArch64.
> For example, ID_PFR0_EL1 is actually a 64 bit register where bits [31:0]
> map to the ID_PFR0 AArch32 register. ID_PFR0_EL1 is only accessible from
> AArch64 with the MRS instruction, and ID_PFR0 is only accessible from
> AArch32 with the MRC instruction. KVM just so happens to handle both of
> these reads from the same sys_reg_desc.
> 
> AFAIK, there does not exist a direct bit mapping between the
> ID_*_EL1 <-> ID_AA64*_EL1 registers. But hey, could be wrong :)

I think you are right. ID_PFR0_EL1[31:0] doesn't even have the same
field as ID_AA64PFR0_EL1[31:0]. The only exception would be RAS which is
at [31:28] on both, but it doesn't say anywhere that ID_PFR0_EL1.RAS
maps architecturally to ID_AA64PFR0_EL1.RAS. So, I think we can assume
it doesn't (?).

Thanks,
Ricardo

> 
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
