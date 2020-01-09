Return-Path: <SRS0=UWlR=26=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9B6C282DD
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 15:29:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2998B20673
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jan 2020 15:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5FmlW6o"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2998B20673
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A19AE4B1F2;
	Thu,  9 Jan 2020 10:29:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SCm-lpElX5Ut; Thu,  9 Jan 2020 10:29:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCEE84B1EF;
	Thu,  9 Jan 2020 10:29:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6990B4B1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 04:07:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id unaMSqoFtevN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jan 2020 04:07:33 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E45F4B1CA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jan 2020 04:07:33 -0500 (EST)
Received: from rapoport-lnx (nesher1.haifa.il.ibm.com [195.110.40.7])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1E1E920673;
 Thu,  9 Jan 2020 09:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1578560852;
 bh=80VO7IRaadflRsWGeFaWpP4uMh6gHTYCmJeL67RjZyc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=q5FmlW6oNXmmHi8t5SgWv6hqbdIOcUc7kC9MBmRyqClnLeB0DbMUArm6zNITYQbZM
 X3khTwxh8dUFqbTImNB9UVzgMvIDlRJW427ftIDOSroG+TSjzJJ7++lD9C0seZcwE+
 32RfwPZhjFiLV95ZOf0ynTo5+MVxORQ//gS9cugs=
Date: Thu, 9 Jan 2020 11:07:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 0/1] arm/arm64: add support for folded p4d page tables
Message-ID: <20200109090719.GA14426@rapoport-lnx>
References: <20191230082734.28954-1-rppt@kernel.org>
 <19fc0640-2b7e-a06f-a4c8-2736d54dd565@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19fc0640-2b7e-a06f-a4c8-2736d54dd565@arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Mailman-Approved-At: Thu, 09 Jan 2020 10:29:41 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Thu, Jan 09, 2020 at 08:38:54AM +0530, Anshuman Khandual wrote:
> 
> 
> On 12/30/2019 01:57 PM, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > Hi,
> 
> Hello Mike,
> 
> > 
> > This is a part of clean up of the page table manipulation code that aims to
> > remove asm-generic/5level-fixup.h and asm-generic/pgtable-nop4d-hack.h
> > 
> > There is a single patch for both arm and arm64 because doing the conversion
> > separately would mean breaking the shared mmu bits in virt/kvm/arm.
> > 
> > The patch is build tested and boot tested on qemu-system-{arm,aarch64}.
> 
> There are lots of code changes here for a single patch but as you have
> mentioned shared KVM bits would have prevented splitting arm and arm64
> changes into separate patches. Just curious, are you planning to respin
> this patch sooner after fixing the reported build problems caused by
> missing p4d_offset_kimg() and p4d_sect() definitions ?

Well, I was waiting to see if there was some feedback except kbuild robot
response :)

I'm planning to send v2 soon, probably next week.
 
> - Anshuman

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
