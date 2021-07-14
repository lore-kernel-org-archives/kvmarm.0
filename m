Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB675C07E9A
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 10:39:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 208AC6128B
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 10:39:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 208AC6128B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 925884A49C;
	Wed, 14 Jul 2021 06:39:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WtqBX3YEB65w; Wed, 14 Jul 2021 06:39:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C0544A7FD;
	Wed, 14 Jul 2021 06:39:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00A014A195
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 06:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5K8srJyBiA3K for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 06:39:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C773849F83
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 06:39:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E1C7D6E;
 Wed, 14 Jul 2021 03:39:33 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 865253F774;
 Wed, 14 Jul 2021 03:39:32 -0700 (PDT)
Subject: Re: [PATCH 3/5] KVM: arm64: Rename __vcpu_sys_reg -> vcpu_sys_reg
To: Marc Zyngier <maz@kernel.org>
References: <20210714095601.184854-1-alexandru.elisei@arm.com>
 <20210714095601.184854-4-alexandru.elisei@arm.com>
 <87k0lt6vnr.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1ec785be-799f-12ea-e9f7-5e4d06b02145@arm.com>
Date: Wed, 14 Jul 2021 11:40:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87k0lt6vnr.wl-maz@kernel.org>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On 7/14/21 11:23 AM, Marc Zyngier wrote:
> Hi Alex,
>
> On Wed, 14 Jul 2021 10:55:59 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> There are two macros to access a specific system register from a known
>> kvm_cpu_context: __ctxt_sys_reg(), which returns a pointer to the register,
>> and ctxt_sys_reg(), which deferences the pointer returned by
>> __ctxt_sys_reg().
>>
>> __vcpu_sys_reg() serves a similar purpose, with the difference being that
>> it takes a struct kvm_vcpu as a parameter. __vcpu_sys_reg(), although it
>> looks like __ctxt_sys_reg(), it dereferences the pointer to the register,
>> like ctxt_sys_reg() does, and indeed it is defined as an abstraction over
>> ctxt_sys_reg().
>>
>> Let's remove this naming inconsistency by renaming __vcpu_sys_reg() to
>> vcpu_sys_reg(), to make it clear it behaves like ctxt_sys_reg(), and not
>> like __ctxt_sys_reg().
> I can't say I'm keen on this change.
>
> The leading underscores really are there to outline that *this is
> dangerous*, as you really need to know which context you are in.
> Dropping the leading '__' may give the false impression that this is
> safe, and not actually a primitive that requires careful thinking
> before use.
>
> ctxt_sys_reg() is, on the other hand, clearly something that acts
> solely on memory because it takes a context structure, and not a
> vcpu. At least that's what the 'ctxt' prefix is supposed to convey
> (not very successfully, apparently).

Oh, so that's the real reason for the leading underscores, I assumed that the
comment was warning enough. Since the 3 macros were right next to each other, and
__vcpu_sys_reg() is a wrapper over ctxt_sys_reg(), I thought they're there to
differentiate between returning a reference and returning a value. I'll drop this
patch and the one after it.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
