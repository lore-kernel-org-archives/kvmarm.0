Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A6BC432BE
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 10:12:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FC00601FD
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 10:12:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3FC00601FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF01F49F83;
	Wed, 11 Aug 2021 06:12:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CY96NM1pvqvL; Wed, 11 Aug 2021 06:12:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CBB49F5D;
	Wed, 11 Aug 2021 06:12:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0648649F5D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 06:12:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id byT2eWLTRMtu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 06:12:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EE17407ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 06:12:31 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C4E0604AC;
 Wed, 11 Aug 2021 10:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628676750;
 bh=k5j7pTJV1G1/uJTXFNYwXDPkN3zQameqJbn3FuQ+zfA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=TOy5TVoWXDc9sN+JOLfAdHzSnl8kfTevmJIH9ykKKMFBnvnUccg/KhZ1g3/rBa+Sm
 tmujjPQovKdYIZcSEZ45m1SjqWX8l7fu7wZgc5GiyQjvQe+CSQSBhdjrTaxyc/g600
 uI7iz6P47c39LvkTj7w83jbEa/eJ2Kp75peghBgSilGZ8ro4EkfQpqswsgH4sN5vKW
 ug65vqnjPwwXNGhCg0cPlIKE6uKFrtyJgN5eShR57+iQW++NpL5ZCfYahPQb0VZWmZ
 vcYFyK6c6zkQ81NZ24yys7HSZcIZO40nqlQsW16z8+W8IZGz11ijstAUaAdwyN89GB
 iHIDebm/1RodQ==
Date: Wed, 11 Aug 2021 11:12:25 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] arm64/mm: Define ID_AA64MMFR0_TGRAN_2_SHIFT
Message-ID: <20210811101225.GC4426@willie-the-truck>
References: <1628569782-30213-1-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1628569782-30213-1-git-send-email-anshuman.khandual@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>
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

On Tue, Aug 10, 2021 at 09:59:42AM +0530, Anshuman Khandual wrote:
> Streamline the Stage-2 TGRAN value extraction from ID_AA64MMFR0 register by
> adding a page size agnostic ID_AA64MMFR0_TGRAN_2_SHIFT. This is similar to
> the existing Stage-1 TGRAN shift i.e ID_AA64MMFR0_TGRAN_SHIFT.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This applies on v5.14-rc5.
> 
>  arch/arm64/include/asm/sysreg.h |  3 +++
>  arch/arm64/kvm/reset.c          | 17 ++---------------
>  2 files changed, 5 insertions(+), 15 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
