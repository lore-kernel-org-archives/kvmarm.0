Return-Path: <SRS0=pHiG=XO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988DAC4CEC4
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 13:07:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1690F21907
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 13:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCHVqSuL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1690F21907
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 925CD4A647;
	Thu, 19 Sep 2019 09:07:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IXWspmPNIP+m; Thu, 19 Sep 2019 09:07:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB83A4A6BB;
	Thu, 19 Sep 2019 09:07:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0575B4A6B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 09:07:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6efdeTLxFu6v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Sep 2019 09:07:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C13854A647
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 09:07:29 -0400 (EDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 726B821D7E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 13:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1568898448;
 bh=xDlkbYtekNq2g+j/zLZRiaXJuHeVfYxFX/p6ICWFSTw=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=BCHVqSuL/6xTcR4UIQNbftn+i7ALTmzjbkxcwXg9kdHIXUeW5wKOJj0jG8SGA29kT
 rlFF6uog75GxK0bdFaRZNI0ABOEfr0Om7lb2CRZPfxIDL3GXQYc0LdqrbSwCsSMul1
 OvFGEKKeZ74rerDPYJ6ZKN6QBZCubXMaIdO0VgrU=
Received: by mail-wr1-f48.google.com with SMTP id l3so3016564wru.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 06:07:28 -0700 (PDT)
X-Gm-Message-State: APjAAAUkb0Q7ke5/VowHOrXCve/EzCEclKBYV6onjaJWuCmmPwnfcoDC
 TLI3eJ4p3lid7ksZMEGr8GHWG82UalD12ksJHmQ=
X-Google-Smtp-Source: APXvYqyNvo9nMD/j9PGGbZY5fbWhu9DS32hN7clZh4PtaLsYsLNB9DQGeR8UyO6Q34SnbEzf8UHVp/ztmfjTiqTh1Ok=
X-Received: by 2002:a5d:66d2:: with SMTP id k18mr7066721wrw.7.1568898446854;
 Thu, 19 Sep 2019 06:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <20190619091219.GB7767@fuggles.cambridge.arm.com>
 <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
 <20190619123939.GF7767@fuggles.cambridge.arm.com>
 <CAJF2gTSiiiewTLwVAXvPLO7rTSUw1rg8VtFLzANdP2S2EEbTjg@mail.gmail.com>
 <20190624104006.lvm32nahemaqklxc@willie-the-truck>
 <CAJF2gTSC1sGgmiTCgzKUTdPyUZ3LG4H7N8YbMyWr-E+eifGuYg@mail.gmail.com>
 <20190912140256.fwbutgmadpjbjnab@willie-the-truck>
 <CAJF2gTT2c45HRfATF+=zs-HNToFAKgq1inKRmJMV3uPYBo4iVg@mail.gmail.com>
 <CAJF2gTTsHCsSpf1ncVb=ZJS2d=r+AdDi2=5z-REVS=uUg9138A@mail.gmail.com>
 <057a0af3-93f7-271c-170e-4b31e6894c3c@linaro.org>
In-Reply-To: <057a0af3-93f7-271c-170e-4b31e6894c3c@linaro.org>
From: Guo Ren <guoren@kernel.org>
Date: Thu, 19 Sep 2019 21:07:15 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRbyfrUqAULPqJTXdxx8YOscPqAEuMsoJ+dTNobNrUV1g@mail.gmail.com>
Message-ID: <CAJF2gTRbyfrUqAULPqJTXdxx8YOscPqAEuMsoJ+dTNobNrUV1g@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: aou@eecs.berkeley.edu,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Palmer Dabbelt <palmer@sifive.com>,
 iommu@lists.linux-foundation.org, Mike Rapoport <rppt@linux.ibm.com>,
 Anup Patel <anup.Patel@wdc.com>, Atish Patra <Atish.Patra@wdc.com>,
 Julien Grall <julien.grall@arm.com>, gary@garyguo.net,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-riscv@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi,

On Mon, Sep 16, 2019 at 8:57 PM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
> On 13/09/2019 09:13, Guo Ren wrote:
> > Another idea is seperate remote TLB invalidate into two instructions:
> >
> >  - sfence.vma.b.asyc
> >  - sfence.vma.b.barrier // wait all async TLB invalidate operations
> > finished for all harts.
>
> It's not clear to me how this helps, but I probably don't have the whole
> picture. If you have a place where it is safe to wait for the barrier to
> complete, why not do the whole invalidate there?
>
> > (I remember who mentioned me separate them into two instructions after
> > session. Anup? Is the idea right ?)
Forget it, I still use irq signal in my formal proposal [1]. I also
couldn't image the whole picture :P


> >     To solve the problem, we could define a async mode in sfence.vma.b to
> >     slove the problem and finished with per_cpu_irq/exception.
>
> The solution I had to this problem is pinning the ASID [1] used by the
> IOMMU, to prevent the CPU from recycling the ASID on rollover. This way
> the CPU doesn't have to wait for IOMMU invalidations to complete, when
> scheduling a task that might not even have anything to do with the IOMMU.
>

> In the Arm SMMU, ASID and IOASID (PASID) are separate identifiers. IOASID
> indexes an entry in the context descriptor table, which contains the ASID.
> So with unpinned shared ASID you don't need to invalidate the ATC on
> rollover, since the IOASID doesn't change, but you do need to modify the
> context descriptor and invalidate cached versions of it.
The terminology confused me a lot. I perfer use PASID for IOMMU and
ASID is for CPU.
Arm's entry of the context descriptor table contains a "IOASID"

IOASID != ASID for CPU_TLB and IOMMU_TLB.

When you say "since the IOASID doesn't change",Is it PASID or my IOASID ? -_*!
PASID in PCI-sig was used to determine transfer address space.
For intel, the entry which is indexed by PASID also contain S1/S2.PGD
and DID(VMID).
For arm, the entry which is indexed by PASID only contain S1.PGD and
IOASID. Compare to Intel Vt-d Scalable mode, arm's design can't
support PCI Virtual Function.

>
> Once you have pinned ASIDs, you could also declare that IOASID = ASID. I
> don't remember finding an argument to strictly forbid it, even though ASID
> and IOASID have different sizes on Arm (respectively 8/16 and 20 bits).
ASID and IOASID are hard to keep the same between CPU system and IOMMU
system. So I introduce S1/S2.PGD.PPN as a bridge between CPUs and
IOMMUs.
See my proposal [1]

1: https://lore.kernel.org/linux-csky/1568896556-28769-1-git-send-email-guoren@kernel.org/T/#u
-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
