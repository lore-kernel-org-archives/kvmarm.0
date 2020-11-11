Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC885C5517A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 12:46:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E7B65206F1
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 12:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9nWEq3/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7B65206F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5254A4B7D7;
	Wed, 11 Nov 2020 07:46:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b65Fd7y2v0FN; Wed, 11 Nov 2020 07:46:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A57184B929;
	Wed, 11 Nov 2020 07:46:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4829E4B7D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 07:46:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qr86RXqt+f74 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 07:46:34 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 459C84B7CF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 07:46:34 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D2AA520709;
 Wed, 11 Nov 2020 12:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605098793;
 bh=fgvFar5VH6U4VmS5tTBAQ11UfAbcAq37UA/xmP7e4uI=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=r9nWEq3/jfTwQEjDuIXAGQ3H5G3m3fz1i1Uank6++ovoprns/8F8c+AJfmJKnfkV7
 U9NlWyNw0S5q4V2xcpf3b2+tlqT2T4LDiaqsi1VnqngsXR8NZmG4TrZwTzJ7CAHd82
 DHwKVfdZtvolrjK4/t4Wre1aIEKeFreUOxIC7ckM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcpWA-009lDZ-KI; Wed, 11 Nov 2020 12:46:30 +0000
MIME-Version: 1.0
Date: Wed, 11 Nov 2020 12:46:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 06/24] kvm: arm64: Support per_cpu_ptr in nVHE hyp code
In-Reply-To: <20201111123222.ooevu6nryu3ncphv@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-7-dbrazdil@google.com>
 <f28c9a67759cb04157e888b3a71b2ce2@kernel.org>
 <20201111123222.ooevu6nryu3ncphv@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <52b47a4284aaff2e198385ef9acbe01f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

On 2020-11-11 12:32, David Brazdil wrote:
>> > +
>> > +	cpu_base_array = kern_hyp_va(&kvm_arm_hyp_percpu_base[0]);
>> 
>> There is no guarantee that this will not generate a PC relative
>> addressing, resulting in kern_hyp_va() being applied twice.
>> 
>> Consider using hyp_symbol_addr() instead, which always does the right
>> by forcing a PC relative addressing and not subsequently mangling
>> the address.
>> 
>> > +	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
>> > +	return this_cpu_base - (unsigned long)&__per_cpu_start;
>> 
>> And this is the opposite case: if the compiler generates an absolute
>> address, you're toast. Yes, this is just as unlikely, but hey...
>> Same remedy should apply.
> 
> Good point, and I'll probably keep forgetting about this in the future. 
> Now
> that all .hyp.text is only executed under hyp page tables, should we 
> start
> thinking about fixing up the relocations?

Why not, if you can deal with the hypervisor text being mapped at a 
random
location, and make sure that the kernel doesn't process the relocations
for you. This would certainly save us a lot of runtime offsetting (which
I'm adding to in a separate series).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
