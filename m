Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730C6C48BE8
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 11:38:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1F2261351
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 11:38:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1F2261351
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82ED540D0A;
	Fri, 18 Jun 2021 07:38:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 85-4RDPcp5xN; Fri, 18 Jun 2021 07:38:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6B949F8F;
	Fri, 18 Jun 2021 07:38:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17EB340D0A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 07:38:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lJVNlBeg2cXp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 07:38:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F28240870
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 07:38:37 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 205E961260;
 Fri, 18 Jun 2021 11:38:36 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1luCpV-008QYN-2u; Fri, 18 Jun 2021 12:38:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 Yanan Wang <wangyanan55@huawei.com>, Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v7 0/4] KVM: arm64: Improve efficiency of stage2 page table
Date: Fri, 18 Jun 2021 12:38:27 +0100
Message-Id: <162401627606.3015641.17627283030372951514.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210617105824.31752-1-wangyanan55@huawei.com>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, alexandru.elisei@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 wangyanan55@huawei.com, qperret@google.com, julien.thierry.kdev@gmail.com,
 zhukeqian1@huawei.com, yuzenghui@huawei.com, suzuki.poulose@arm.com,
 gshan@redhat.com, catalin.marinas@arm.com, james.morse@arm.com,
 wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

On Thu, 17 Jun 2021 18:58:20 +0800, Yanan Wang wrote:
> This series makes some efficiency improvement of guest stage-2 page
> table code, and there are some test results to quantify the benefit.
> 
> Description for this series:
> We currently uniformly permorm CMOs of D-cache and I-cache in function
> user_mem_abort before calling the fault handlers. If we get concurrent
> guest faults(e.g. translation faults, permission faults) or some really
> unnecessary guest faults caused by BBM, CMOs for the first vcpu are
> necessary while the others later are not.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Introduce two cache maintenance callbacks
      commit: 6204004de3160900435bdb4b9a2fb8749a9277d2
[2/4] KVM: arm64: Introduce mm_ops member for structure stage2_attr_data
      commit: a4d5ca5c7cd8fe85056b8cb838fbcb7e5a05f356
[3/4] KVM: arm64: Tweak parameters of guest cache maintenance functions
      commit: 378e6a9c78a02b4b609846aa0afccf34d3038977
[4/4] KVM: arm64: Move guest CMOs to the fault handlers
      commit: 25aa28691bb960a76f0cffd8862144a29487f6ff

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
