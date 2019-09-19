Return-Path: <SRS0=pHiG=XO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FE6C4CECE
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 15:18:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C372218AF
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 15:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yqn2hP5/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C372218AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 717824A6CE;
	Thu, 19 Sep 2019 11:18:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lv5XilD19Egk; Thu, 19 Sep 2019 11:18:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 416554A6A6;
	Thu, 19 Sep 2019 11:18:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE5EA4A69F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 11:18:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G0W8Sn-wYOxq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Sep 2019 11:18:48 -0400 (EDT)
Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com
 [209.85.208.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A75654A688
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 11:18:48 -0400 (EDT)
Received: by mail-ed1-f65.google.com with SMTP id v8so3579445eds.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Sep 2019 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=eJ0UWMRY33TSZcE2wFwrgcT5zmWwOXQ+xlDh/x5Rbok=;
 b=Yqn2hP5/7LoUE96rW6LgXvDeRFDoEgSIYLWO331yu/t8KvfcDLYs0svMMqhPl0nEKU
 3028G05kj86vZEYdH0BT8B4Snvw/8TzsFj/6z3cDmgcLrYqAf9CTKaxFxWz6TetvRVWD
 JaOhJxFoN6Lysw3uc3I7TCd+bGbTAYEQdtrh530GBo5Aqg2kjpsReLMDlMYPva23+thK
 3paKUHNXhfjBIBDEcc9d7OpRoL4M9YEswI1G3XEqU9hMkBTILBRZAfv3lk1GyAApc7kF
 uBVf89FvXfuH3jiXShL1/vpa79fW+aGEKUGlC597SIRD1tjHojMUhcUCeA7TA1Um/ffs
 UzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=eJ0UWMRY33TSZcE2wFwrgcT5zmWwOXQ+xlDh/x5Rbok=;
 b=jWf19Ec5UGiQXUhnKztu2pvbDDohrYz/kqX5nGtYctwKmcAQT2t376pvFvFjKWnXO2
 M5fXgOMf8z0pF4Ea4jLFARUz+hrjWON2qJQFi7Y6HCKcNup/75QsfP5hNP1UUShB+I09
 dOJ+WdiM/EJmunXFRe4TKXE30pRZxrQU94MusDxtrrGpLFTkJGzz6acVGs8sZNiJYrXR
 rOqYHrxYu0wmsBOFgrZkZwFbRv7ruloYmOHCNM3EO3DaOhXPSZSP3DujGsFv38QwnmQq
 k7m9FpTC2Egr7SUhFuZtX49cAom/WBqPrJkTiU2ZwUqqE9gXEWNiwD82okmCj2LSqSQH
 /mBg==
X-Gm-Message-State: APjAAAUKzezHB48cIDM8ImNYuADXXNIPSNxFEBhjWsZk+pdcNjzIgNFe
 XmAosDQwcubcbLZ0Ce0RLNyyRQ==
X-Google-Smtp-Source: APXvYqyjE5Z/ExpKjAFeUwQaYOlsDCBhURZQ6GgY1ZAERUi1xVf6/dGQvcGXJsfycKEfjO1ON7WJpA==
X-Received: by 2002:a17:906:6a92:: with SMTP id
 p18mr14982887ejr.253.1568906327557; 
 Thu, 19 Sep 2019 08:18:47 -0700 (PDT)
Received: from lophozonia ([85.195.192.192])
 by smtp.gmail.com with ESMTPSA id x4sm763681eds.87.2019.09.19.08.18.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 19 Sep 2019 08:18:46 -0700 (PDT)
Date: Thu, 19 Sep 2019 17:18:44 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Message-ID: <20190919151844.GG1013538@lophozonia>
References: <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
 <20190619123939.GF7767@fuggles.cambridge.arm.com>
 <CAJF2gTSiiiewTLwVAXvPLO7rTSUw1rg8VtFLzANdP2S2EEbTjg@mail.gmail.com>
 <20190624104006.lvm32nahemaqklxc@willie-the-truck>
 <CAJF2gTSC1sGgmiTCgzKUTdPyUZ3LG4H7N8YbMyWr-E+eifGuYg@mail.gmail.com>
 <20190912140256.fwbutgmadpjbjnab@willie-the-truck>
 <CAJF2gTT2c45HRfATF+=zs-HNToFAKgq1inKRmJMV3uPYBo4iVg@mail.gmail.com>
 <CAJF2gTTsHCsSpf1ncVb=ZJS2d=r+AdDi2=5z-REVS=uUg9138A@mail.gmail.com>
 <057a0af3-93f7-271c-170e-4b31e6894c3c@linaro.org>
 <CAJF2gTRbyfrUqAULPqJTXdxx8YOscPqAEuMsoJ+dTNobNrUV1g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJF2gTRbyfrUqAULPqJTXdxx8YOscPqAEuMsoJ+dTNobNrUV1g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
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

On Thu, Sep 19, 2019 at 09:07:15PM +0800, Guo Ren wrote:
> > The solution I had to this problem is pinning the ASID [1] used by the
> > IOMMU, to prevent the CPU from recycling the ASID on rollover. This way
> > the CPU doesn't have to wait for IOMMU invalidations to complete, when
> > scheduling a task that might not even have anything to do with the IOMMU.
> >
> 
> > In the Arm SMMU, ASID and IOASID (PASID) are separate identifiers. IOASID
> > indexes an entry in the context descriptor table, which contains the ASID.
> > So with unpinned shared ASID you don't need to invalidate the ATC on
> > rollover, since the IOASID doesn't change, but you do need to modify the
> > context descriptor and invalidate cached versions of it.
> The terminology confused me a lot. I perfer use PASID for IOMMU and
> ASID is for CPU.
> Arm's entry of the context descriptor table contains a "IOASID"

The terminology I've been using so far is different:
* IOASID is PASID
* The entry in the context descriptor table contains an ASID, which
  is either "shared" with CPUs or "private" to the SMMU (the SMMU spec
  says "shared" or "non-shared").
* So the CPU and SMMU TLBs use ASIDs, and the PCI ATC uses IOASID

> IOASID != ASID for CPU_TLB and IOMMU_TLB.
> 
> When you say "since the IOASID doesn't change",Is it PASID or my IOASID ? -_*!

I was talking about PASID. Maybe we can drop "IOASID" and talk only
about ASID and PASID :)

> PASID in PCI-sig was used to determine transfer address space.
> For intel, the entry which is indexed by PASID also contain S1/S2.PGD
> and DID(VMID).
> For arm, the entry which is indexed by PASID only contain S1.PGD and
> IOASID. Compare to Intel Vt-d Scalable mode, arm's design can't
> support PCI Virtual Function.

The SMMU does support PCI Virtual Function - an hypervisor can assign a
VF to a guest, and let that guest partition the VF into smaller contexts
by using PASID.  What it can't support is assigning partitions of a PCI
function (VF or PF) to multiple Virtual Machines, since there is a
single S2 PGD per function (in the Stream Table Entry), rather than one
S2 PGD per PASID context.

Thanks,
Jean

> > Once you have pinned ASIDs, you could also declare that IOASID = ASID. I
> > don't remember finding an argument to strictly forbid it, even though ASID
> > and IOASID have different sizes on Arm (respectively 8/16 and 20 bits).
> ASID and IOASID are hard to keep the same between CPU system and IOMMU
> system. So I introduce S1/S2.PGD.PPN as a bridge between CPUs and
> IOMMUs.
> See my proposal [1]
> 
> 1: https://lore.kernel.org/linux-csky/1568896556-28769-1-git-send-email-guoren@kernel.org/T/#u
> -- 
> Best Regards
>  Guo Ren
> 
> ML: https://lore.kernel.org/linux-csky/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
