Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080C8C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 16:03:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6965061269
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 16:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6965061269
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2C7E4079A;
	Thu, 30 Sep 2021 12:03:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I7gl1ZNkHuaz; Thu, 30 Sep 2021 12:03:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D25884A1B0;
	Thu, 30 Sep 2021 12:03:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EDFE49FB7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 12:03:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8aYpkiayAtEf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 12:02:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3C794079A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 12:02:59 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D6FAB6136A;
 Thu, 30 Sep 2021 16:02:57 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mVyWN-00E1nE-Sz; Thu, 30 Sep 2021 17:02:55 +0100
MIME-Version: 1.0
Date: Thu, 30 Sep 2021 17:02:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 03/12] KVM: arm64: Move early handlers to per-EC
 handlers
In-Reply-To: <20210930133444.GC23809@willie-the-truck>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-4-tabba@google.com>
 <20210930133444.GC23809@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <2b007cfc37203c84237d4a523cb0cadb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, tabba@google.com,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, mark.rutland@arm.com, christoffer.dall@arm.com,
 pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

On 2021-09-30 14:35, Will Deacon wrote:
> On Wed, Sep 22, 2021 at 01:46:55PM +0100, Fuad Tabba wrote:
>> From: Marc Zyngier <maz@kernel.org>

>> +static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 
>> *exit_code)
>> +{
>> +	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
>> +	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
>> +		return true;
> 
> I think you're now calling this for the 64-bit CP15 access path, which 
> I
> don't think is correct. Maybe have separate handlers for 32-bit v4 
> 64-bit
> accesses?

Good point. The saving grace is that there is no 32bit-capable CPU that
requires GICv3 trapping, nor any 64bit cp15 register in the GICv3
architecture apart form the SGI registers, which are always handled at 
EL1.
So this code is largely academic!

Not providing a handler is the way to go for CP15-64.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
