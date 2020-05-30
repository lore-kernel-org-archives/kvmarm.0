Return-Path: <SRS0=AbtX=7M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6D0C433DF
	for <kvmarm@archiver.kernel.org>; Sat, 30 May 2020 16:31:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95C022081A
	for <kvmarm@archiver.kernel.org>; Sat, 30 May 2020 16:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3jV1cd/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95C022081A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8424B31A;
	Sat, 30 May 2020 12:31:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I01XQuQX07kd; Sat, 30 May 2020 12:31:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2D4D4B371;
	Sat, 30 May 2020 12:31:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58A724B370
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 May 2020 12:31:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lIdiIPTGjjsT for <kvmarm@lists.cs.columbia.edu>;
 Sat, 30 May 2020 12:31:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 232504B31C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 May 2020 12:31:39 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C55DD207F9;
 Sat, 30 May 2020 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590856297;
 bh=JfAXX86jsFaQs68I//x89vYrH6wJwLVZOjVj42YlNnQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=H3jV1cd/WX6RtRn97g2b7AdNitzkpiJv2wMpkibU2NjBic0MddIGijSa/TM2c8hCl
 sAzSe/r3kR1TfdQ7O9hH9p0NEBirfE9ej7aRtsqQ+ZQgjW8VEIwB56uY2jdp9qPtLv
 Yx012vWn1cr+EWTen+4jLGJfToIf5L0mQIXYz7Hc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jf4OW-00GYve-3E; Sat, 30 May 2020 17:31:36 +0100
MIME-Version: 1.0
Date: Sat, 30 May 2020 17:31:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH RFC] KVM: arm64: Sidestep stage2_unmap_vm() on vcpu reset
 when S2FWB is supported
In-Reply-To: <a1a1961a-2eae-b26c-e607-ab5c0c929f37@arm.com>
References: <20200415072835.1164-1-yuzenghui@huawei.com>
 <e99bc07d-0dd4-055c-808f-fd9cde88d2fc@arm.com>
 <a1a1961a-2eae-b26c-e607-ab5c0c929f37@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <13db879dff56d091f98f7c5416ab1535@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

Hi Alex,

On 2020-05-30 11:46, Alexandru Elisei wrote:
> Hi,

[...]

>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>> index 48d0ec44ad77..e6378162cdef 100644
>>> --- a/virt/kvm/arm/arm.c
>>> +++ b/virt/kvm/arm/arm.c
>>> @@ -983,8 +983,11 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct 
>>> kvm_vcpu *vcpu,
>>>  	/*
>>>  	 * Ensure a rebooted VM will fault in RAM pages and detect if the
>>>  	 * guest MMU is turned off and flush the caches as needed.
>>> +	 *
>>> +	 * S2FWB enforces all memory accesses to RAM being cacheable, we
>>> +	 * ensure that the cache is always coherent.
>>>  	 */
>>> -	if (vcpu->arch.has_run_once)
>>> +	if (vcpu->arch.has_run_once && 
>>> !cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>> I think userspace does not invalidate the icache when loading a new 
>> kernel image,
>> and if the guest patched instructions, they could potentially still be 
>> in the
>> icache. Should the icache be invalidated if FWB is present?
> 
> I noticed that this was included in the current pull request and I
> remembered that
> I wasn't sure about this part. Did some more digging and it turns out 
> that FWB
> implies no cache maintenance needed for *data to instruction*
> coherence. From ARM
> DDI 0487F.b, page D5-2635:
> 
> "When ARMv8.4-S2FWB is implemented, the architecture requires that
> CLIDR_EL1.{LOUU, LOIUS} are zero so that no levels of data cache need 
> to be
> cleaned in order to manage coherency with instruction fetches".
> 
> However, there's no mention that I found for instruction to data 
> coherence,
> meaning that the icache would still need to be invalidated on each vcpu 
> in order
> to prevent fetching of patched instructions from the icache. Am I
> missing something?

I think you are right, and this definitely matches the way we deal with
the icache on the fault path. For some bizarre reason, I always assume
that FWB implies DIC, which isn't true at all.

I'm planning to address it as follows. Please let me know what you 
think.

Thanks,

         M.

 From f7860d1d284f41afea176cc17e5c9d895ae665e9 Mon Sep 17 00:00:00 2001
 From: Marc Zyngier <maz@kernel.org>
Date: Sat, 30 May 2020 17:22:19 +0100
Subject: [PATCH] KVM: arm64: Flush the instruction cache if not 
unmapping the
  VM on reboot

On a system with FWB, we don't need to unmap Stage-2 on reboot,
as even if userspace takes this opportunity to repaint the whole
of memory, FWB ensures that the data side stays consistent even
if the guest uses non-cacheable mappings.

However, the I-side is not necessarily coherent with the D-side
if CTR_EL0.DIC is 0. In this case, invalidate the i-cache to
preserve coherency.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Fixes: 892713e97ca1 ("KVM: arm64: Sidestep stage2_unmap_vm() on vcpu 
reset when S2FWB is supported")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
  arch/arm64/kvm/arm.c | 14 ++++++++++----
  1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b0b569f2cdd0..d6988401c22a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -989,11 +989,17 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct 
kvm_vcpu *vcpu,
  	 * Ensure a rebooted VM will fault in RAM pages and detect if the
  	 * guest MMU is turned off and flush the caches as needed.
  	 *
-	 * S2FWB enforces all memory accesses to RAM being cacheable, we
-	 * ensure that the cache is always coherent.
+	 * S2FWB enforces all memory accesses to RAM being cacheable,
+	 * ensuring that the data side is always coherent. We still
+	 * need to invalidate the I-cache though, as FWB does *not*
+	 * imply CTR_EL0.DIC.
  	 */
-	if (vcpu->arch.has_run_once && 
!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
-		stage2_unmap_vm(vcpu->kvm);
+	if (vcpu->arch.has_run_once) {
+		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+			stage2_unmap_vm(vcpu->kvm);
+		else
+			__flush_icache_all();
+	}

  	vcpu_reset_hcr(vcpu);

-- 
2.26.2


-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
