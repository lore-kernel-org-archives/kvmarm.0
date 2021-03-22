Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868C5C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 11:27:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F13C56198E
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 11:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F13C56198E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF814B422;
	Mon, 22 Mar 2021 07:27:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ulEoJTwqPK8I; Mon, 22 Mar 2021 07:27:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 752A04B1DC;
	Mon, 22 Mar 2021 07:27:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A17B4B411
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 07:27:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UsrjaJyISsl5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 07:27:48 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 685B54B0E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 07:27:48 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C85F6191F;
 Mon, 22 Mar 2021 11:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616412467;
 bh=2rQCKuAt/izeJLTYF4MTljlVoBabkTjdYFUOiQ846kg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hCdtEo/cGqar4OAPPbwzZ28D6YUm9xkGkk1tyTKkmhP5BD0PvzRwzSgkiCBHJAHi3
 0Oi+rd9f0hcStg2vT2O9d7ZbUfYzXiJdeqZcXb9Ep/TxIScPofF1zjqC16ZAlJeIxt
 QsT72YQmboZA/spmbvmXpElGMuaRW9TfpgpoP5EL2NSZNf8MFAJYAM98BddOjwfg2f
 C1oL7A2WJbicW71oOLiWXHvVnxBpNesdUlv2Gek+l4o+2ydE6+/ijgQs+EiILfSYm+
 lPzMM8JFbFyGUpV+oX40F9xnPg1R8+0vIof9WNSw2uQxt47WjJFWBpJdWbMGLtz9xw
 1NDgNzSETgyYg==
Date: Mon, 22 Mar 2021 11:27:41 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v6 29/38] KVM: arm64: Use page-table to track page
 ownership
Message-ID: <20210322112741.GC10318@willie-the-truck>
References: <20210319100146.1149909-1-qperret@google.com>
 <20210319100146.1149909-30-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210319100146.1149909-30-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 19, 2021 at 10:01:37AM +0000, Quentin Perret wrote:
> As the host stage 2 will be identity mapped, all the .hyp memory regions
> and/or memory pages donated to protected guestis will have to marked
> invalid in the host stage 2 page-table. At the same time, the hypervisor
> will need a way to track the ownership of each physical page to ensure
> memory sharing or donation between entities (host, guests, hypervisor) is
> legal.
> 
> In order to enable this tracking at EL2, let's use the host stage 2
> page-table itself. The idea is to use the top bits of invalid mappings
> to store the unique identifier of the page owner. The page-table owner
> (the host) gets identifier 0 such that, at boot time, it owns the entire
> IPA space as the pgd starts zeroed.
> 
> Provide kvm_pgtable_stage2_set_owner() which allows to modify the
> ownership of pages in the host stage 2. It re-uses most of the map()
> logic, but ends up creating invalid mappings instead. This impacts
> how we do refcount as we now need to count invalid mappings when they
> are used for ownership tracking.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  20 +++++
>  arch/arm64/kvm/hyp/pgtable.c         | 126 ++++++++++++++++++++++-----
>  2 files changed, 122 insertions(+), 24 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
