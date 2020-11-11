Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFE3C5517A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 14:32:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FA162067D
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 14:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpHIQIOZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FA162067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 558164BA35;
	Wed, 11 Nov 2020 09:32:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ihx7jzx+0GjA; Wed, 11 Nov 2020 09:32:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F5C34B828;
	Wed, 11 Nov 2020 09:32:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5BAC4B7DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 09:32:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q6VhhTvfY1qN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 09:32:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D9DB4B62E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 09:32:54 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 98FC22072C;
 Wed, 11 Nov 2020 14:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605105172;
 bh=S5VKmn1vXVRwiTiDOW+I2kCvLAlgxe7X4/fLYqQufKo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=UpHIQIOZ6FG8Vh8fhkww3nn5PePI9nSFyhNjvJowt94WNK2yeiwqOiLNSneW6A2uR
 8fI6k25UBn3FAcm9sRxC9ASTk39qf40j66W84AYOQF12hAJOmvGX8Yxo66ymoBmyIA
 2t6I7MRzrTS66uKqDr9JNpdH11q9kMQgWVFAo2G0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcrB4-009mxR-Hf; Wed, 11 Nov 2020 14:32:50 +0000
MIME-Version: 1.0
Date: Wed, 11 Nov 2020 14:32:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 00/24] Opt-in always-on nVHE hypervisor
In-Reply-To: <20201109113233.9012-1-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <60c7254e3e667486298c11ddccca4f13@kernel.org>
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

Hi David,

On 2020-11-09 11:32, David Brazdil wrote:
> As we progress towards being able to keep guest state private to the
> host running nVHE hypervisor, this series allows the hypervisor to
> install itself on newly booted CPUs before the host is allowed to run
> on them.
> 
> All functionality described below is opt-in, guarded by an early param
> 'kvm-arm.protected'. Future patches specific to the new "protected" 
> mode
> should be hidden behind the same param.
> 
> The hypervisor starts trapping host SMCs and intercepting host's PSCI
> CPU_ON/OFF/SUSPEND calls. It replaces the host's entry point with its
> own, initializes the EL2 state of the new CPU and installs the nVHE hyp
> vector before ERETing to the host's entry point.
> 
> The kernel checks new cores' features against the finalized system
> capabilities. To avoid the need to move this code/data to EL2, the
> implementation only allows to boot cores that were online at the time 
> of
> KVM initialization and therefore had been checked already.
> 
> Other PSCI SMCs are forwarded to EL3, though only the known set of SMCs
> implemented in the kernel is allowed. Non-PSCI SMCs are also forwarded
> to EL3. Future changes will need to ensure the safety of all SMCs wrt.
> private guests.
> 
> The host is still allowed to reset EL2 back to the stub vector, eg. for
> hibernation or kexec, but will not disable nVHE when there are no VMs.
> 
> Tested on Rock Pi 4b, based on 5.10-rc3.

I think I've gone through most of the patches. When you respin this
series, you may want to do so on top of my host EL2 entry rework [1],
which change a few things you currently rely on.

If anything in there doesn't work for you, please let me know.

Thanks,

         M.

[1] https://lore.kernel.org/kvm/20201109175923.445945-1-maz@kernel.org/
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
