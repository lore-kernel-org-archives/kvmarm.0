Return-Path: <SRS0=r53t=FP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1689C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Dec 2020 15:02:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CE57239E5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Dec 2020 15:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CE57239E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77B584B271;
	Fri, 11 Dec 2020 10:02:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B95ky4WGMkoH; Fri, 11 Dec 2020 10:02:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 233844B28C;
	Fri, 11 Dec 2020 10:02:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 715104B271
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 10:01:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZXDLt265OC7U for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Dec 2020 10:01:57 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CB414B181
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 10:01:57 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E9569229C4;
 Fri, 11 Dec 2020 15:01:55 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1knjve-000TxV-6W; Fri, 11 Dec 2020 15:01:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: shawnguo@kernel.org, linux@rasmusvillemoes.dk, leoyang.li@nxp.com,
 mark.rutland@arm.com, zhiqiang.hou@nxp.com,
 Biwen Li <biwen.li@oss.nxp.com>, robh+dt@kernel.org, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Shenming Lu <lushenming@huawei.com>, James Morse <james.morse@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Optimize the wait for the completion
 of the VPT analysis
Date: Fri, 11 Dec 2020 15:01:39 +0000
Message-Id: <160769813659.482133.2716418035359567004.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201128141857.983-1-lushenming@huawei.com>
References: <20201128141857.983-1-lushenming@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: shawnguo@kernel.org, linux@rasmusvillemoes.dk,
 leoyang.li@nxp.com, mark.rutland@arm.com, zhiqiang.hou@nxp.com,
 biwen.li@oss.nxp.com, robh+dt@kernel.org, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, will@kernel.org, kvm@vger.kernel.org,
 eric.auger@redhat.com, christoffer.dall@arm.com,
 linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com,
 lushenming@huawei.com, james.morse@arm.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, julien.thierry.kdev@gmail.com,
 xiaobo.xie@nxp.com, Zhiqiang.Hou@nxp.com, devicetree@vger.kernel.org,
 biwen.li@nxp.com, jiafei.pan@nxp.com, yuzenghui@huawei.com,
 wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: devicetree@vger.kernel.org, Biwen Li <biwen.li@nxp.com>,
 Hou Zhiqiang <Zhiqiang.Hou@nxp.com>, xiaobo.xie@nxp.com, jiafei.pan@nxp.com
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

On Sat, 28 Nov 2020 22:18:55 +0800, Shenming Lu wrote:
> Right after a vPE is made resident, the code starts polling the
> GICR_VPENDBASER.Dirty bit until it becomes 0, where the delay_us
> is set to 10. But in our measurement, it takes only hundreds of
> nanoseconds, or 1~2 microseconds, to finish parsing the VPT in most
> cases. What's more, we found that the MMIO delay on GICv4.1 system
> (HiSilicon) is about 10 times higher than that on GICv4.0 system in
> kvm-unit-tests (the specific data is as follows).
> 
> [...]

Applied to irq/irqchip-next, thanks!

[1/2] irqchip/gic-v4.1: Reduce the delay time of the poll on the GICR_VPENDBASER.Dirty bit
      commit: 0b39498230ae53e6af981141be99f4c7d5144de6

Patch 2 will be routed via the KVM/arm64 tree.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
