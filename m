Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CDFC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 13:22:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E550061058
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 13:22:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E550061058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9645740256;
	Wed, 18 Aug 2021 09:22:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pwSueLCu1C8T; Wed, 18 Aug 2021 09:22:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5783949F5F;
	Wed, 18 Aug 2021 09:22:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C0AA406E0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 09:22:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wP5SLT9h8hDc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 09:22:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12C0240256
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 09:22:04 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 974B560232;
 Wed, 18 Aug 2021 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1629292923;
 bh=sPj+IO31w+5a8e1Hoa/GlytzFKIw6PQM72kgo1I8pd4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=jo1gxH3HkFdM8PKOw/vCByec43EbCwMJpYviJkjPOL+xuM8TgJRQdLCBoGOAhhPC3
 l1I23oJKKFzo7ou8pq0FJZuH4Ke4AWT8vIb+EEK6KwRxGJn1r5KuKljdvgnB7mKlre
 ixHdL0qoVpvk2tNty3cWxB59hW+ZSsPdhPWaXfn5/dL5jbTms3jA2NgpR00XrA1CmS
 byEsAzcSeN//PGf28zcvt/fSNCfWbL82UQQweuXEI7zydF7m84eJwvjGZXMD5OGFG2
 T6RGp82aoiUSsl3SXgtJHrIlF0iMYf/tNUdN2RenhG5R3NgfB6IBrAaDYVXhvdz7ov
 2Il+IiAHRNhqg==
Date: Wed, 18 Aug 2021 14:21:57 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 09/15] KVM: arm64: Add feature register flag definitions
Message-ID: <20210818132156.GF14107@willie-the-truck>
References: <20210817081134.2918285-1-tabba@google.com>
 <20210817081134.2918285-10-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210817081134.2918285-10-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Tue, Aug 17, 2021 at 09:11:28AM +0100, Fuad Tabba wrote:
> Add feature register flag definitions to clarify which features
> might be supported.
> 
> Consolidate the various ID_AA64PFR0_ELx flags for all ELs.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  4 ++--
>  arch/arm64/include/asm/sysreg.h     | 12 ++++++++----
>  arch/arm64/kernel/cpufeature.c      |  8 ++++----
>  3 files changed, 14 insertions(+), 10 deletions(-)

Thanks, looks better now:

Acked-by: Will Deacon <will@kernel.org>

Will

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
