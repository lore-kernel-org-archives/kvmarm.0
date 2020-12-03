Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E391EC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 19:03:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57759217BA
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 19:03:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57759217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 869954B14A;
	Thu,  3 Dec 2020 14:03:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dk8WuWjS-SfQ; Thu,  3 Dec 2020 14:03:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA2E4B1B1;
	Thu,  3 Dec 2020 14:03:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 056854B1B1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 14:03:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ts-CbcEUVmuB for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 14:03:35 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D56D24B14A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 14:03:35 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 90D5E208A9;
 Thu,  3 Dec 2020 19:03:34 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kktt5-00FlRA-Bp; Thu, 03 Dec 2020 19:03:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, Keqian Zhu <zhukeqian1@huawei.com>,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 0/2] KVM: arm64: Some fixes and code adjustments for
 pvtime ST
Date: Thu,  3 Dec 2020 19:03:28 +0000
Message-Id: <160702219014.403179.5103308104909161941.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20200817110728.12196-1-zhukeqian1@huawei.com>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 zhukeqian1@huawei.com, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 drjones@redhat.com, james.morse@arm.com, steven.price@arm.com,
 suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>
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

On Mon, 17 Aug 2020 19:07:26 +0800, Keqian Zhu wrote:
> During picking up pvtime LPT support for arm64, I do some trivial fixes for
> pvtime ST.
> 
> change log:
> 
> v2:
>  - Add Andrew's and Steven's R-b.
>  - Correct commit message of the first patch.
>  - Drop the second patch.
> 
> [...]

Applied to kvm-arm64/misc-5.11, thanks!

[1/2] KVM: arm64: Some fixes of PV-time interface document
      commit: 94558543213ae8c83be5d01b83c1fe7530e8a1a0
[2/2] KVM: arm64: Use kvm_write_guest_lock when init stolen time
      commit: 652d0b701d136ede6bc8a977b3abbe2d420226b9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
