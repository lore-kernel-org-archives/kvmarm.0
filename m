Return-Path: <SRS0=ghsx=JD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1A4C433ED
	for <kvmarm@archiver.kernel.org>; Tue,  6 Apr 2021 13:55:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66B8C61380
	for <kvmarm@archiver.kernel.org>; Tue,  6 Apr 2021 13:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66B8C61380
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0767D4B911;
	Tue,  6 Apr 2021 09:55:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y1gNyen1NgzT; Tue,  6 Apr 2021 09:55:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA8024B924;
	Tue,  6 Apr 2021 09:55:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C714F4B911
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Apr 2021 09:55:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dkNgt5HrVUpM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Apr 2021 09:55:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C17094B909
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Apr 2021 09:55:15 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E031C61380;
 Tue,  6 Apr 2021 13:55:13 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lTmAh-005s9O-RB; Tue, 06 Apr 2021 14:55:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: drjones@redhat.com, kvm@vger.kernel.org, alexandru.elisei@arm.com,
 eric.auger.pro@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v6 0/9] KVM/ARM: Some vgic fixes and init sequence KVM
 selftests
Date: Tue,  6 Apr 2021 14:55:06 +0100
Message-Id: <161771729837.1263367.15038328824523187404.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210405163941.510258-1-eric.auger@redhat.com>
References: <20210405163941.510258-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org,
 alexandru.elisei@arm.com, eric.auger.pro@gmail.com,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 eric.auger@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com,
 pbonzini@redhat.com, shuah@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, shuah@kernel.org
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

On Mon, 5 Apr 2021 18:39:32 +0200, Eric Auger wrote:
> While writting vgic v3 init sequence KVM selftests I noticed some
> relatively minor issues. This was also the opportunity to try to
> fix the issue laterly reported by Zenghui, related to the RDIST_TYPER
> last bit emulation. The final patch is a first batch of VGIC init
> sequence selftests. Of course they can be augmented with a lot more
> register access tests, but let's try to move forward incrementally ...
> 
> [...]

Applied to kvm-arm64/vgic-5.13, thanks!

[1/9] KVM: arm64: vgic-v3: Fix some error codes when setting RDIST base
      commit: d9b201e99c616001b4a51627820377b293479384
[2/9] KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read
      commit: 53b16dd6ba5cf64ed147ac3523ec34651d553cb0
[3/9] KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
      commit: 8542a8f95a67ff6b76d6868ec0af58c464bdf041
[4/9] KVM: arm/arm64: vgic: Reset base address on kvm_vgic_dist_destroy()
      commit: 3a5211612764fa3948e5db5254734168e9e763de
[5/9] docs: kvm: devices/arm-vgic-v3: enhance KVM_DEV_ARM_VGIC_CTRL_INIT doc
      commit: 298c41b8fa1e02c5a35e2263d138583220ab6094
[6/9] KVM: arm64: Simplify argument passing to vgic_uaccess_[read|write]
      commit: da3853097679022e14a2d125983f11a67fd2f96a
[7/9] kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()
      commit: e5a35635464bc5304674b84ea42615a3fd0bd949
[8/9] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for userspace
      commit: 28e9d4bce3be9b8fec6c854f87923db99c8fb874
[9/9] KVM: selftests: aarch64/vgic-v3 init sequence tests
      commit: dc0e058eef42f61effe9fd4f0fa4b0c793cc1f14

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
