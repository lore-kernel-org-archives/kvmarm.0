Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3558AC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 16:33:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80B5922583
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 16:33:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80B5922583
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 076BF4B524;
	Mon, 25 Jan 2021 11:33:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ECLHBviulyW6; Mon, 25 Jan 2021 11:33:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F12C24B532;
	Mon, 25 Jan 2021 11:33:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B02E4B526
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 11:33:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QaUlT4H8cexc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 11:33:31 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 685AD4B524
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 11:33:31 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5065F22510;
 Mon, 25 Jan 2021 16:33:30 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l44nw-009ujO-DD; Mon, 25 Jan 2021 16:33:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
 Yanan Wang <wangyanan55@huawei.com>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Some optimization for stage-2 translation
Date: Mon, 25 Jan 2021 16:33:25 +0000
Message-Id: <161159237705.2330282.4465806083809381814.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114121350.123684-1-wangyanan55@huawei.com>
References: <20210114121350.123684-1-wangyanan55@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, wangyanan55@huawei.com,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 zhukeqian1@huawei.com, james.morse@arm.com, yuzenghui@huawei.com,
 suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com, yezengruan@huawei.com,
 gshan@redhat.com, wanghaibin.wang@huawei.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Thu, 14 Jan 2021 20:13:47 +0800, Yanan Wang wrote:
> This patch series(v3) make some optimization for stage-2 translation.
> 
> About patch-1:
> Procedures of hyp stage-1 map and guest stage-2 map are quite different,
> but they are now tied closely by function kvm_set_valid_leaf_pte().
> So adjust the relative code for ease of code maintenance in the future.
> 
> [...]

Applied to kvm-arm64/concurrent-translation-fault, thanks!

[1/3] KVM: arm64: Adjust partial code of hyp stage-1 map and guest stage-2 map
      commit: 8ed80051c8c31d1587722fdb3af16677eba9d693
[2/3] KVM: arm64: Filter out the case of only changing permissions from stage-2 map path
      commit: 694d071f8d85d504055540a27f0dbe9dbf44584e
[3/3] KVM: arm64: Mark the page dirty only if the fault is handled successfully
      commit: 509552e65ae8287178a5cdea2d734dcd2d6380ab

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
