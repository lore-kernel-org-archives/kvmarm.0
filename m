Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200FBC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 08:43:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BDD260F35
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 08:43:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8BDD260F35
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C4B4B0E6;
	Mon, 11 Oct 2021 04:43:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K0rVPFt1tDI9; Mon, 11 Oct 2021 04:43:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 207974B090;
	Mon, 11 Oct 2021 04:43:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAE814B08A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 04:43:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SICF3sPQ8EI2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 04:43:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4E874A19F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 04:43:43 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A87B760EE3;
 Mon, 11 Oct 2021 08:43:42 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mZquK-00Fxvk-E6; Mon, 11 Oct 2021 09:43:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: eric.auger@redhat.com, kvm@vger.kernel.org, drjones@redhat.com,
 alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 00/11] KVM: arm64: vgic: Missing checks for REDIST/CPU
 and ITS regions above the VM IPA size
Date: Mon, 11 Oct 2021 09:43:33 +0100
Message-Id: <163394180347.585098.13155475812069497023.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
References: <20211005011921.437353-1-ricarkol@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, kvm@vger.kernel.org,
 drjones@redhat.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 ricarkol@google.com, pshier@google.com, jingzhangos@google.com,
 rananta@google.com, reijiw@google.com, shuah@kernel.org,
 suzuki.poulose@arm.com, james.morse@arm.com, pbonzini@redhat.com,
 oupton@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

On Mon, 4 Oct 2021 18:19:10 -0700, Ricardo Koller wrote:
> KVM doesn't check for redist, CPU interface, and ITS regions that extend
> partially above the guest addressable IPA range (phys_size).  This can happen
> when using the V[2|3]_ADDR_TYPE_CPU, ADDR_TYPE_REDIST[_REGION], or
> ITS_ADDR_TYPE attributes to set a new region that extends partially above
> phys_size (with the base below phys_size).  The issue is that vcpus can
> potentially run into a situation where some redistributors are addressable and
> others are not, or just the first half of the ITS is addressable.
> 
> [...]

Applied to next, thanks!

[01/11] kvm: arm64: vgic: Introduce vgic_check_iorange
        commit: f25c5e4dafd859b941a4654cbab9eb83ff994bcd
[02/11] KVM: arm64: vgic-v3: Check redist region is not above the VM IPA size
        commit: 4612d98f58c73ad63928200fd332f75c8e524dae
[03/11] KVM: arm64: vgic-v2: Check cpu interface region is not above the VM IPA size
        commit: c56a87da0a7fa14180082249ac954c7ebc9e74e1
[04/11] KVM: arm64: vgic-v3: Check ITS region is not above the VM IPA size
        commit: 2ec02f6c64f043a249850c835ca7975c3a155d8b
[05/11] KVM: arm64: vgic: Drop vgic_check_ioaddr()
        commit: 96e903896969679104c7fef2c776ed1b5b09584f
[06/11] KVM: arm64: selftests: Make vgic_init gic version agnostic
        commit: 3f4db37e203b0562d9ebae575af13ea159fbd077
[07/11] KVM: arm64: selftests: Make vgic_init/vm_gic_create version agnostic
        commit: 46fb941bc04d3541776c09c2bf641e7f34e62a01
[08/11] KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
        commit: c44df5f9ff31daaa72b3a673422d5cca03a1fd02
[09/11] KVM: arm64: selftests: Add tests for GIC redist/cpuif partially above IPA range
        commit: 2dcd9aa1c3a5d3c90047d67efd08f0518f915449
[10/11] KVM: arm64: selftests: Add test for legacy GICv3 REDIST base partially above IPA range
        commit: 1883458638979531fc4fcbc26d15fec3e51e1734
[11/11] KVM: arm64: selftests: Add init ITS device test
        commit: 3e197f17b23ba7c1a3c7cb1d27f7494444aa42e3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
