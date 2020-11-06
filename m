Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A81C2D0A3
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 12:25:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1DF920735
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 12:25:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtXHeJtg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1DF920735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEE424B831;
	Fri,  6 Nov 2020 07:25:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AOK0Py8D5qcK; Fri,  6 Nov 2020 07:25:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4C4F4B833;
	Fri,  6 Nov 2020 07:25:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 055CD4B81C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 07:25:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5yxQNM5i7t3z for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 07:25:09 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1DCB4B818
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 07:25:08 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4854220728;
 Fri,  6 Nov 2020 12:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604665507;
 bh=V/Ngl+S6qEm3sU0uEaVkuAcYmnBwh6ZSK48gtM1t+SM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=KtXHeJtgR+x5+njnUSXftuBQbkIMrGAotZNXi4Ldu2y2k2D61oENT054zurjalV97
 Xwk+0XMHlRdo2bs6E2LsG3diL6HX6DDgF7Uwt5a1/TMPp5aARhqQS3VC0bUY4UFytz
 vGpkXJY4ciGO2qWrbnqJLwMUYNTVwgKaANhMuAqk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kb0nh-008CCI-4P; Fri, 06 Nov 2020 12:25:05 +0000
MIME-Version: 1.0
Date: Fri, 06 Nov 2020 12:25:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [RFC PATCH 00/26] kvm: arm64: Always-on nVHE hypervisor
In-Reply-To: <20201104183630.27513-1-dbrazdil@google.com>
References: <20201104183630.27513-1-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <60a77f17737ffcfa31c3d1dfacc24384@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 2020-11-04 18:36, David Brazdil wrote:
> As we progress towards being able to keep guest state private to the
> host running nVHE hypervisor, this series allows the hypervisor to
> install itself on newly booted CPUs before the host is allowed to run
> on them.
> 
> To this end, the hypervisor starts trapping host SMCs and intercepting
> host's PSCI CPU_ON/OFF/SUSPEND calls. It replaces the host's entry 
> point
> with its own, initializes the EL2 state of the new CPU and installs
> the nVHE hyp vector before ERETing to the host's entry point.
> 
> Other PSCI SMCs are forwarded to EL3, though only the known set of SMCs
> implemented in the kernel is allowed. Non-PSCI SMCs are also forwarded
> to EL3. Future changes will need to ensure the safety of all SMCs wrt.
> private guests.
> 
> The host is still allowed to reset EL2 back to the stub vector, eg. for
> hibernation or kexec, but will not disable nVHE when there are no VMs.
> 
> Tested on Rock Pi 4b.
> 
> 
> Sending this as an RFC to get feedback on the following decisions:
> 
> 1) The kernel checks new cores' features against the finalized system
> capabilities. To avoid the need to move this code/data to EL2, the
> implementation only allows to boot cores that were online at the time 
> of
> KVM initialization.
> 
> 2) Trapping and forwarding SMCs cannot be switched off. This could 
> cause
> issues eg. if EL3 always returned to EL1. A kernel command line flag 
> may
> be needed to turn the feature off on such platforms.

I'd rather have it the other way around (buy-in rather than turn off).
On top of the potential issue with stupid EL3s, there is the issue that
PSCI is optional, and that protected VMs won't be able to work without
it. Another related thing is that EL3 itself is optional.

Note that this flag shouldn't be specific to PSCI proxying. It should 
also
control Stage-2 wrapping, and the whole pKVM.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
