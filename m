Return-Path: <SRS0=R6td=AK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7257DC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 17:00:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D26AD255A1
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jun 2020 17:00:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D26AD255A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=misterjones.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 252524B31E;
	Mon, 29 Jun 2020 13:00:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u+52UDRChnmI; Mon, 29 Jun 2020 13:00:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21C4D4B323;
	Mon, 29 Jun 2020 13:00:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0703D4B30B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 13:00:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yzLrHdqdiKfQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2020 13:00:27 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A12894B2F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2020 13:00:27 -0400 (EDT)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@misterjones.org>)
 id 1jpx8n-007NSg-On; Mon, 29 Jun 2020 18:00:21 +0100
MIME-Version: 1.0
Date: Mon, 29 Jun 2020 18:00:21 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/2] kvm/arm64: Rename HSR to ESR
In-Reply-To: <20200629103208.GA59769@C02TD0UTHF1T.local>
References: <20200629091841.88198-1-gshan@redhat.com>
 <20200629091841.88198-2-gshan@redhat.com>
 <20200629103208.GA59769@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <9080c56e3f54d7661a57c5e2a771363f@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, gshan@redhat.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, will@kernel.org
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

On 2020-06-29 11:32, Mark Rutland wrote:
> On Mon, Jun 29, 2020 at 07:18:40PM +1000, Gavin Shan wrote:
>> kvm/arm32 isn't supported since commit 541ad0150ca4 ("arm: Remove
>> 32bit KVM host support"). So HSR isn't meaningful since then. This
>> renames HSR to ESR accordingly. This shouldn't cause any functional
>> changes:
>> 
>>    * Rename kvm_vcpu_get_hsr() to kvm_vcpu_get_esr() to make the
>>      function names self-explanatory.
>>    * Rename variables from @hsr to @esr to make them self-explanatory.
>> 
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
> 
> At a high-level, I agree that we should move to the `esr` naming to
> match the architecture and minimize surprise. However, I think there 
> are
> some ABI changes here, which *are* funcitonal changes, and those need 
> to
> be avoided.
> 
> [...]
> 
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h 
>> b/arch/arm64/include/uapi/asm/kvm.h
>> index ba85bb23f060..d54345573a88 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -140,7 +140,7 @@ struct kvm_guest_debug_arch {
>>  };
>> 
>>  struct kvm_debug_exit_arch {
>> -	__u32 hsr;
>> +	__u32 esr;
>>  	__u64 far;	/* used for watchpoints */
>>  };
> 
> This is userspace ABI, and changing this *will* break userspace. This
> *is* a functional change.
> 
> NAK to this specifically. At best these should be a comment here that
> this is naming is legacym but must stay for ABI reasons.
> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
>> index 4c71270cc097..ee4f691b16ff 100644
>> --- a/arch/arm64/kvm/trace_arm.h
>> +++ b/arch/arm64/kvm/trace_arm.h
>> @@ -42,7 +42,7 @@ TRACE_EVENT(kvm_exit,
>>  		__entry->vcpu_pc		= vcpu_pc;
>>  	),
>> 
>> -	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
>> +	TP_printk("%s: ESR_EC: 0x%04x (%s), PC: 0x%08lx",
>>  		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
>>  		  __entry->esr_ec,
>>  		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),
> 
> Likewise, isn't all the tracepoint format stuff ABI? I'm not 
> comfortable
> that we can change this.

Tracepoints are ABI, and they cannot change. As it is, this patch
isn't acceptable (the worse offender being the uapi change though).

         M.
-- 
Who you jivin' with that Cosmik Debris?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
