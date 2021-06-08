Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19874C47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 12:03:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84C7D61351
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 12:03:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84C7D61351
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E14B04029C;
	Tue,  8 Jun 2021 08:03:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D6VX85bJ3CUZ; Tue,  8 Jun 2021 08:03:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C16C7405A6;
	Tue,  8 Jun 2021 08:03:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 980B640573
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 08:03:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v6tXplvnzZUl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 08:03:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AF6B4029C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 08:03:38 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D1606128D;
 Tue,  8 Jun 2021 12:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1623153816;
 bh=TfjLAVqrZKwY0IV8e659Z+X17Esbdt1qHTkNeo85xFE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=pYN7LoM6VXDlHC86InF+wbIpNoZ+dZXNObun7GakAu7R5a8W3BG81LOuOz8d/sH5x
 s83SjjcEl8PrKI2oNFvWIwg5FZjzdX3GTbDLgYC4q32pAWe88ejEtjUy0vXOz3aAzw
 27rFTeOXsNh7AgJJRytR6hHQYOsUmLe3zFwnm3uARUPXc/tpnJlaYELoIxgw39VsfJ
 Tp/szkmmqVyGAIrI4YfvYvhLEqIc0Th4GI5UQO3+KPSPpBV6MfVJGwdgSGdTjigvFF
 3EUIMnpInNWXZWh3CuJhaFq2T4+xoNvZhBCfazSNXJsqTaQffSrvws8eTmIwNQCpYw
 +kGoVyl8/Hl1w==
Date: Tue, 8 Jun 2021 13:03:31 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/4] KVM: arm64: Parse reserved-memory node for pkvm
 guest firmware region
Message-ID: <20210608120330.GC10174@willie-the-truck>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-4-will@kernel.org>
 <20210604142141.GC69333@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210604142141.GC69333@C02TD0UTHF1T.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

Hi Mark,

On Fri, Jun 04, 2021 at 03:21:41PM +0100, Mark Rutland wrote:
> On Thu, Jun 03, 2021 at 07:33:46PM +0100, Will Deacon wrote:
> > Add support for a "linux,pkvm-guest-firmware-memory" reserved memory
> > region, which can be used to identify a firmware image for protected
> > VMs.
> 
> The idea that the guest's FW comes from the host's FW strikes me as
> unusual; what's the rationale for this coming from the host FW? IIUC
> other confidential compute VM environments allow you to load up whatever
> virtual FW you want, but this is measured such that the virtual FW used
> can be attested.

The rationale is that, as far as possible, we're trying to keep the EL2
code simple and agnostic of the guest and the SoC. We therefore assign
validation of the guest payload to this firmware image which is executed
when first entering the guest and made inaccessible to the host kernel
as part of the deprivilege operation during boot. The VMM could still
provide its own virtual firmware, which would then be measured by the
firmware here and chainloaded. We just deprivilege that logic from EL2
to EL1.

For pKVM on Android, it is the Android Bootloader which loads both the
host kernel and the guest firmware (which is actually just u-boot).
Before entering the host, it verifies and measures the guest firmware,
appending secrets to the reserved memory region which are later used by
the firmware to generate per-VM identities. These certificates are then
used by the guest to establish a communication channel with Android's
"Keymint" [1] HAL on the host and get access to hardware-backed key
resources. That way we have a certificate chain which ties directly into
Android Verified Boot [2] and extends to the guest payload without KVM
having to be aware of any of it.

Since this is all pretty specific to Android, delegating it to the
firmware allows others to use their own mechanisms without bloating the
privileged code at EL2 or enforcing a specific flow.

A straightforward extension in future would be to make this firmware
optional when spawning a protected VM, but since we have no need for
that in Android (where we require the firmware), we elected to keep
things minimal at first.

Cheers,

Will

[1] https://source.android.com/security/keystore
[2] https://source.android.com/security/verifiedboot
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
