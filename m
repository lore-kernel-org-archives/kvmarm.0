Return-Path: <SRS0=Rb5J=J7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98C6C433B4
	for <kvmarm@archiver.kernel.org>; Tue,  4 May 2021 08:30:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A918613C0
	for <kvmarm@archiver.kernel.org>; Tue,  4 May 2021 08:30:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A918613C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9779C4B37D;
	Tue,  4 May 2021 04:30:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HE-47N4mLA6M; Tue,  4 May 2021 04:30:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 230124B307;
	Tue,  4 May 2021 04:30:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2DB4B307
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 May 2021 04:30:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WpZLYRK3LDFp for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 May 2021 04:30:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B54E4B082
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 May 2021 04:30:12 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CEF2613BA;
 Tue,  4 May 2021 08:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620117011;
 bh=SA0MPq08S4sIbEu0S/YkhVbAPJQkRS5WeyPcEthMjx8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MFnRDdSddwFqD0o+BFnn3MH3YKem6HT//4u8RH8EXkPAcQT9SkeWZNklQFzo7wOQB
 HXvNwJWmMvA1IcwoMACcnxUpimVDq6op2UIEj0NHPacUaNQpBw4mLOKutdV8VHhdzQ
 tbi/EeK3qbxUA7dPh3UIZZ41LtqvbZG/8B4D6uoz253eQgtYCUPk0Er3JjRnbL04eL
 H4oTHVChbT7vJKYa+ihaC6dHWLnbIyTxgnUu3h/aBLrSSszNynVwXEeUB1DT7sLR5w
 jPgVoOqjKc10n+KxOyuvx83dQRxSLi4+E7XR72yx+Z7H4KUyYX+ZtQgT5vCjlgR+J7
 RPZjLwKCg+RsA==
Date: Tue, 4 May 2021 09:30:05 +0100
From: Will Deacon <will@kernel.org>
To: Vikram Sethi <vsethi@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210504083005.GA12290@willie-the-truck>
References: <1edb2c4e-23f0-5730-245b-fc6d289951e1@nvidia.com>
 <878s4zokll.wl-maz@kernel.org>
 <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org>
 <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
 <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210503084432.75e0126d@x1.home.shazbot.org>
 <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Shanker Donthineni <sdonthineni@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 Jason Sequeira <jsequeira@nvidia.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Mark Kettenis <mark.kettenis@xs4all.nl>
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

On Mon, May 03, 2021 at 10:03:59PM +0000, Vikram Sethi wrote:
> Will/Catalin, perhaps you could explain your thought process on why you chose
> Normal NC for ioremap_wc on the armv8 linux port instead of Device GRE or other
> Device Gxx. 

I think a combination of: compatibility with 32-bit Arm, the need to
support unaligned accesses and the potential for higher performance.

Furthermore, ioremap() already gives you a Device memory type, and we're
tight on MAIR space.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
