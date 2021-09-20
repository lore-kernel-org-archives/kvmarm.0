Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADCCC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 10:08:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5436260F9B
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 10:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5436260F9B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D8C4B0F7;
	Mon, 20 Sep 2021 06:08:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FEfLC4REw4Wx; Mon, 20 Sep 2021 06:08:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD114B0CB;
	Mon, 20 Sep 2021 06:08:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28EEC4B09C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 06:08:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y0AKtCc0mXb0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 06:08:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E83794B08A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 06:08:31 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0532960F25;
 Mon, 20 Sep 2021 10:08:30 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mSGDs-00Bjgb-1s; Mon, 20 Sep 2021 11:08:28 +0100
MIME-Version: 1.0
Date: Mon, 20 Sep 2021 11:08:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH] KVM: arm: add Kbuild FORCE prerequisite for hyp-reloc
In-Reply-To: <20210920100515.1554788-1-arnd@kernel.org>
References: <20210920100515.1554788-1-arnd@kernel.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <1785d70bf2211832c4640763114d3f8d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: arnd@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 dbrazdil@google.com, arnd@arndb.de, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, qperret@google.com,
 keescook@chromium.org, samitolvanen@google.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-09-20 11:05, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Commit e1f86d7b4b2a ("kbuild: warn if FORCE is missing for
> if_changed(_dep,_rule)
> and filechk") added a helpful check for Kbuild, which now notices
> that a problem with the hyp-reloc rule:
> 
> arch/arm64/kvm/hyp/nvhe/Makefile:58: FORCE prerequisite is missing
> 
> Do as suggested and add FORCE here.
> 
> Fixes: 8c49b5d43d4c ("KVM: arm64: Generate hyp relocation data")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile 
> b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 5df6193fc430..8d741f71377f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -54,7 +54,7 @@ $(obj)/kvm_nvhe.tmp.o: $(obj)/hyp.lds $(addprefix
> $(obj)/,$(hyp-obj)) FORCE
>  #    runtime. Because the hypervisor is part of the kernel binary, 
> relocations
>  #    produce a kernel VA. We enumerate relocations targeting hyp at 
> build time
>  #    and convert the kernel VAs at those positions to hyp VAs.
> -$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel
> +$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel FORCE
>  	$(call if_changed,hyprel)
> 
>  # 5) Compile hyp-reloc.S and link it into the existing partially 
> linked object.

I already have queued [1], which does the same thing.

Thanks,

         M.

[1] https://lore.kernel.org/r/20210907052137.1059-1-yuzenghui@huawei.com
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
