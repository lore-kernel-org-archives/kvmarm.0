Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5C1C433B4
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 06:28:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADD3261165
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 06:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADD3261165
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ACEB4BA22;
	Thu,  8 Apr 2021 02:28:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gDZPCTrLxlOp; Thu,  8 Apr 2021 02:28:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB674BA56;
	Thu,  8 Apr 2021 02:28:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D55AA4BA4D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 02:28:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RVxJgy--hRMZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 02:28:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C4D84BA22
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 02:28:03 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A635060FF0;
 Thu,  8 Apr 2021 06:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617863282;
 bh=3CBGbTus3iyR2kStFocLAP1r4ANkWnNDiwwXO2RQGeg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MZPw56dGGoMb4dr8Sk+waAmCBW4XnztSdMy2AmqsReqPn7qirRduRdE+gaFWDV327
 DXlU2nF6tbnW972PCgHgbmp9alr1jdTIZ00s4O7n06eOtls0z5W5o6tlJjyZh5j7Z2
 814rcMgrxxRsrz1GtyL5hPwsUimhylJ0vct9CeIaq9OBEUyn4zdkP3eMLFrSgH5IxP
 4B9+0SMBFFX7lbg/GOWrQ4eMNOAHfsjm91i6uF5/NyZTFfAPFpeXq7r4v6A1Pz/E1k
 wAXqRekhgYwjfF/i/bAxi2JEiNtsCTULy1e8sNFZaOBWAp9qmlcQhng2zLNOzwbio5
 cCiSXbIkCEy6g==
Date: Thu, 8 Apr 2021 09:27:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
Message-ID: <YG6iaZJI/RiUwXzv@kernel.org>
References: <20210407172607.8812-1-rppt@kernel.org>
 <2f68ea11-7c56-1c55-f0be-3aad7188c00a@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2f68ea11-7c56-1c55-f0be-3aad7188c00a@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Thu, Apr 08, 2021 at 10:49:02AM +0530, Anshuman Khandual wrote:
> Adding James here.
> 
> + James Morse <james.morse@arm.com>
> 
> On 4/7/21 10:56 PM, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > Hi,
> > 
> > These patches aim to remove CONFIG_HOLES_IN_ZONE and essentially hardwire
> > pfn_valid_within() to 1. 
> 
> That would be really great for arm64 platform as it will save CPU cycles on
> many generic MM paths, given that our pfn_valid() has been expensive.
> 
> > 
> > The idea is to mark NOMAP pages as reserved in the memory map and restore
> 
> Though I am not really sure, would that possibly be problematic for UEFI/EFI
> use cases as it might have just treated them as normal struct pages till now.

I don't think there should be a problem because now the struct pages for
UEFI/ACPI never got to be used by the core mm. They were (rightfully)
skipped by memblock_free_all() from one side and pfn_valid() and
pfn_valid_within() return false for them in various pfn walkers from the
other side.
 
> > the intended semantics of pfn_valid() to designate availability of struct
> > page for a pfn.
> 
> Right, that would be better as the current semantics is not ideal.
> 
> > 
> > With this the core mm will be able to cope with the fact that it cannot use
> > NOMAP pages and the holes created by NOMAP ranges within MAX_ORDER blocks
> > will be treated correctly even without the need for pfn_valid_within.
> > 
> > The patches are only boot tested on qemu-system-aarch64 so I'd really
> > appreciate memory stress tests on real hardware.
> 
> Did some preliminary memory stress tests on a guest with portions of memory
> marked as MEMBLOCK_NOMAP and did not find any obvious problem. But this might
> require some testing on real UEFI environment with firmware using MEMBLOCK_NOMAP
> memory to make sure that changing these struct pages to PageReserved() is safe.

I surely have no access for such machines :)
 
> > If this actually works we'll be one step closer to drop custom pfn_valid()
> > on arm64 altogether.
> 
> Right, planning to rework and respin the RFC originally sent last month.
> 
> https://patchwork.kernel.org/project/linux-mm/patch/1615174073-10520-1-git-send-email-anshuman.khandual@arm.com/

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
