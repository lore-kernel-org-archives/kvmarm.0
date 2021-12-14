Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9167C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 14:52:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B4034B1F5;
	Tue, 14 Dec 2021 09:52:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uJJe2la346mM; Tue, 14 Dec 2021 09:52:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA104B154;
	Tue, 14 Dec 2021 09:52:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D4284B154
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:52:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7eExQyCuoSWP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 09:52:30 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F6084B11A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:52:30 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0E4AE61547;
 Tue, 14 Dec 2021 14:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3B0C34605;
 Tue, 14 Dec 2021 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639493548;
 bh=yFfkRGn3Zbbf+escEJ2y5n1s3r/WuEZMooEpjeq9CYw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=SsnSf7GM5HtnKJuYn9dOkq5YoMNVd8W+nxOoJ/qz9iFIAa941uF9l5n/Ryc2aUCtr
 klQEkwyZ3TOQmN4iI8EvgK82iJnpzh3WppkGXUGSsurBhGIc7iPgU+Wq0KDRAEplK3
 i7fbDFveAiL1lWaKB8Z/zi84imY6ze9oEQ5nUv5DZNfnkOFHvRN1FcN4Yzb/7NQlq3
 1RGSM5K2VggUKKBmWvSXsScaPbRDxj6klDGMsYZ6HlUVKRxhWkyHtUcffWcH3pFLAg
 pXpiwhG1zinyGz4xgwG6yaTo2wbUU2yEALRQDjhvEnlQNEaWSW3pAYYSpj42tq6zQC
 PkwY9Dkj3HMvw==
Date: Tue, 14 Dec 2021 14:52:23 +0000
From: Will Deacon <will@kernel.org>
To: Andrew Walbran <qwandor@google.com>
Subject: Re: [PATCH v3 10/15] KVM: arm64: Introduce wrappers for host and hyp
 spin lock accessors
Message-ID: <20211214145222.GC14837@willie-the-truck>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-11-qperret@google.com>
 <CA+_y_2HKwtm5839QyEY9D8PaZWky_Zvn3msrw2gcR2Z7UZgObQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+_y_2HKwtm5839QyEY9D8PaZWky_Zvn3msrw2gcR2Z7UZgObQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Dec 14, 2021 at 02:48:30PM +0000, Andrew Walbran wrote:
> On Wed, 1 Dec 2021 at 17:04, 'Quentin Perret' via kernel-team
> <kernel-team@android.com> wrote:
> >
> > From: Will Deacon <will@kernel.org>
> >
> > In preparation for adding additional locked sections for manipulating
> > page-tables at EL2, introduce some simple wrappers around the host and
> > hypervisor locks so that it's a bit easier to read and bit more difficult
> > to take the wrong lock (or even take them in the wrong order).
> Looks good, but how does this help prevent taking locks in the wrong order?

I just found that I would easily forget what exactly was protected by
"pkvm_pgd_lock" and so relating that back to "take host before hyp" was
error-prone. Having helpers with "host" and "hyp" in the name helps me with
that, at least.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
