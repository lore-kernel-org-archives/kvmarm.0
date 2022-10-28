Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF4A2ECAAA1
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 20:35:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 376984B830;
	Fri, 28 Oct 2022 16:35:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ssm9NnCT2f-7; Fri, 28 Oct 2022 16:35:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED8CD4B7FE;
	Fri, 28 Oct 2022 16:35:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD614B7FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 16:35:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MVxIpNn7G9Ag for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 16:35:52 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14EFD4B7FB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 16:35:52 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 97CF0B82BE2;
 Fri, 28 Oct 2022 20:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F01FC433D6;
 Fri, 28 Oct 2022 20:35:46 +0000 (UTC)
Date: Fri, 28 Oct 2022 21:35:42 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH V2] arm64/mm: Fix __enable_mmu() for new TGRAN range values
Message-ID: <Y1w9Hqh4YZFUIp2z@arm.com>
References: <1615355590-21102-1-git-send-email-anshuman.khandual@arm.com>
 <20220826120020.GB520@mutt>
 <84e674ab-3eee-3f2b-28c1-a08ff99d6d3b@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <84e674ab-3eee-3f2b-28c1-a08ff99d6d3b@huawei.com>
Cc: linux-efi@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
 arnd@arndb.de, Anshuman Khandual <anshuman.khandual@arm.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
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

On Fri, Oct 28, 2022 at 10:18:41AM +0800, Zenghui Yu wrote:
> On 2022/8/26 20:00, Anders Roxell wrote:
> > On 2021-03-10 11:23, Anshuman Khandual wrote:
> > > From: James Morse <james.morse@arm.com>
> > > 
> > > As per ARM ARM DDI 0487G.a, when FEAT_LPA2 is implemented, ID_AA64MMFR0_EL1
> > > might contain a range of values to describe supported translation granules
> > > (4K and 16K pages sizes in particular) instead of just enabled or disabled
> > > values. This changes __enable_mmu() function to handle complete acceptable
> > > range of values (depending on whether the field is signed or unsigned) now
> > > represented with ID_AA64MMFR0_TGRAN_SUPPORTED_[MIN..MAX] pair. While here,
> > > also fix similar situations in EFI stub and KVM as well.
> > > 
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: James Morse <james.morse@arm.com>
> > > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: kvmarm@lists.cs.columbia.edu
> > > Cc: linux-efi@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Acked-by: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: James Morse <james.morse@arm.com>
> > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > 
> > When building an arm64 defconfig kernel from stable/linux-5.10.y and
> > booting that in QEMU (version: 1:7.0+dfsg-2~bpo11+2) with '-cpu max' the
> > kernel doesn't boot. I don't get any output.  The kernel boots fine if I
> > change to '-cpu cortex-a72'.
> > 
> > If I cherry-pick this patch to stable/linux-5.10.y I'm able too boot the
> > kernel with '-cpu max'.
> 
> You can workaround the kernel boot failure by specifying
> '-cpu max,lpa2=off' [*] in the QEMU command line.
> 
> > However, I'm not comfortable to backport this patch to older kernels
> > since there are a lot of conflicts.
> > Can someone help out to do the packport?
> 
> Upstream commit 26f55386f964 ("arm64/mm: Fix __enable_mmu() for new
> TGRAN range values") can still be applied cleanly on top of
> linux-5.10.y. I can send it to <stable@vger.kernel.org> if maintainers
> are okay with the stable-5.10 backport.

If you have a backport, please send it (and cc the original
author/reviewers just to double-check that the backport is correct).

Thanks.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
