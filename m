Return-Path: <SRS0=YpAl=XP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1C7C4CEC9
	for <kvmarm@archiver.kernel.org>; Fri, 20 Sep 2019 07:18:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 924942086A
	for <kvmarm@archiver.kernel.org>; Fri, 20 Sep 2019 07:18:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PxlvuUd0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 924942086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0842C4A6D2;
	Fri, 20 Sep 2019 03:18:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7GTf0XWDVmjn; Fri, 20 Sep 2019 03:18:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0316B4A6DD;
	Fri, 20 Sep 2019 03:18:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A719E4A6DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Sep 2019 03:18:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PKiNonS1qZRU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Sep 2019 03:18:25 -0400 (EDT)
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com
 [209.85.208.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CCD14A5E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Sep 2019 03:18:25 -0400 (EDT)
Received: by mail-ed1-f68.google.com with SMTP id r9so5375998edl.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Sep 2019 00:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=BUHblpDIooIrZQuKvaVSkR4gzneP4UJ1DcsQqZl+esY=;
 b=PxlvuUd0/XaEgntK4rFzZoabSaLZYdKu65/CtEXGWfgiVeEBvKri54p1YtHbV54Vso
 sabWrBBBMhYzdp7d9KnVvJ/FiP9nwjBPydyvYFnlc7zKZcYqw5CKdFoVfJbkKzEkyW8J
 CbOHOI8iEMOPf8+cqLKWOimzXm8Ft2DbTDipqB28PvufFkFwN/HwQpvHtkb5hPqIHcos
 at6f3Y25OcKlt53k4/1F7Xocn9shMsVcmKDZVF/Qf1zQR0/4p7zv4zjgJkoeiz/cOxq8
 Bsk9EtGiHn+FXXRvu8plA2+/ymlFBMGxhfBebvI67y9BIVOMgwSqDpoC7Orus1cUkvNB
 UyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=BUHblpDIooIrZQuKvaVSkR4gzneP4UJ1DcsQqZl+esY=;
 b=O721ZVvNElzEVGMu8/3D2jTt90B4cL+zQlR/dYN1ZL8UM2xuAjbxLI1RvtP10LE0aH
 1hhtGnmLc4+vBInTUp8NSgWiW0c+3Ci7xK8SpS8i9c6HVcI2XOeDROccuxUBzV1QdC44
 A7ow0EzMIsNverWs2QsCstVGai3YlRGvwU/TbTA6EOS7KES6xIT/LxXbZ0coVh8gnf53
 sMeyaDSWN2gwA4764P70uvUZVTl/1IxB6g8AiQjShSMVgjuNPOp/zZoGVHdScFdtQXXO
 o87vnFMsGDa/Ag73C0cWAPjNyPmCmzm9qz/krPP1eHs6RMLBGasY/pDUvdiMVA2kPASV
 Sasg==
X-Gm-Message-State: APjAAAUbbg1Vg2nNGEoaq7MegNtgJR5oFyTceAjA116yZuDT1gXu+kKH
 hXrq4y5ZSSDjO+OanlrU4eTX8w==
X-Google-Smtp-Source: APXvYqzlWVFt2wqR2XV+/SkmRXHJ3VguPiEFC4D4xWO75dtqYKoxP+71EoOFdi2jld8XfBiJJ9aMHA==
X-Received: by 2002:a05:6402:17eb:: with SMTP id
 t11mr19808894edy.97.1568963904689; 
 Fri, 20 Sep 2019 00:18:24 -0700 (PDT)
Received: from lophozonia ([85.195.192.192])
 by smtp.gmail.com with ESMTPSA id e13sm55819eje.52.2019.09.20.00.18.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 20 Sep 2019 00:18:24 -0700 (PDT)
Date: Fri, 20 Sep 2019 09:18:21 +0200
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Message-ID: <20190920071821.GA1229556@lophozonia>
References: <CAJF2gTSiiiewTLwVAXvPLO7rTSUw1rg8VtFLzANdP2S2EEbTjg@mail.gmail.com>
 <20190624104006.lvm32nahemaqklxc@willie-the-truck>
 <CAJF2gTSC1sGgmiTCgzKUTdPyUZ3LG4H7N8YbMyWr-E+eifGuYg@mail.gmail.com>
 <20190912140256.fwbutgmadpjbjnab@willie-the-truck>
 <CAJF2gTT2c45HRfATF+=zs-HNToFAKgq1inKRmJMV3uPYBo4iVg@mail.gmail.com>
 <CAJF2gTTsHCsSpf1ncVb=ZJS2d=r+AdDi2=5z-REVS=uUg9138A@mail.gmail.com>
 <057a0af3-93f7-271c-170e-4b31e6894c3c@linaro.org>
 <CAJF2gTRbyfrUqAULPqJTXdxx8YOscPqAEuMsoJ+dTNobNrUV1g@mail.gmail.com>
 <20190919151844.GG1013538@lophozonia>
 <CAJF2gTQtk7VhBgUan6WOZgc3UaQzHL8SxMi=yiHG-8eC207BbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJF2gTQtk7VhBgUan6WOZgc3UaQzHL8SxMi=yiHG-8eC207BbQ@mail.gmail.com>
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

On Fri, Sep 20, 2019 at 08:07:38AM +0800, Guo Ren wrote:
> On Thu, Sep 19, 2019 at 11:18 PM Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> 
> >
> > The SMMU does support PCI Virtual Function - an hypervisor can assign a
> > VF to a guest, and let that guest partition the VF into smaller contexts
> > by using PASID.  What it can't support is assigning partitions of a PCI
> > function (VF or PF) to multiple Virtual Machines, since there is a
> > single S2 PGD per function (in the Stream Table Entry), rather than one
> > S2 PGD per PASID context.
> >
> In my concept, the two sentences "The SMMU does support PCI Virtual
> Functio" v.s. "What it can't support is assigning partitions of a PCI
> function (VF or PF) to multiple Virtual Machines" are conflict and I
> don't want to play naming game :)

That's fine. But to prevent the spread of misinformation: Arm SMMU
supports PCI Virtual Functions.

Thanks,
Jean
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
