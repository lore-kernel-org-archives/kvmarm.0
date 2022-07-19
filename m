Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9D8C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 17:35:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F2B4D114;
	Tue, 19 Jul 2022 13:35:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RWB0iIGIAk0d; Tue, 19 Jul 2022 13:35:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78FC04D1D1;
	Tue, 19 Jul 2022 13:35:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CFF94D06B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 13:35:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yA3Rd2yacgB5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 13:35:46 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF04A4CFE8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 13:35:45 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 44462B81C8A;
 Tue, 19 Jul 2022 17:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98BAC341C6;
 Tue, 19 Jul 2022 17:35:40 +0000 (UTC)
Date: Tue, 19 Jul 2022 18:35:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 7/7] arm64/sve: Don't zero non-FPSIMD register state
 on syscall by default
Message-ID: <YtbraaDE0eJhRHkx@arm.com>
References: <20220620124158.482039-1-broonie@kernel.org>
 <20220620124158.482039-8-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220620124158.482039-8-broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Jun 20, 2022 at 01:41:58PM +0100, Mark Brown wrote:
> The documented syscall ABI specifies that the SVE state not shared with
> FPSIMD is undefined after a syscall. Currently we implement this by
> always flushing this register state to zero, ensuring consistent
> behaviour but introducing some overhead in the case where we can return
> directly to userspace without otherwise needing to update the register
> state. Take advantage of the flexibility offered by the documented ABI
> and instead leave the SVE registers untouched in the case where can
> return directly to userspace.

Do you have some rough numbers to quantify the gain? I suspect the
vector length doesn't matter much.

Where does the zeroing happen now? IIRC it's only done on a subsequent
trap to SVE and that's a lot more expensive (unless the code has changed
since last time I looked).

So if it's the actual subsequent trap that adds the overhead, maybe
zeroing the regs while leaving TIF_SVE on won't be that bad.

> Since this is a user visible change a new sysctl abi.sve_syscall_clear_regs
> is provided which will restore the current behaviour of flushing the
> unshared register state unconditionally when enabled. This can be
> enabled for testing or to work around problems with applications that
> have been relying on the current flushing behaviour.
> 
> The sysctl is disabled by default since it is anticipated that the risk
> of disruption to userspace is low. As well as being within the
> documented ABI this new behaviour mirrors the standard function call ABI
> for SVE in the AAPCS which should mean that compiler generated code is
> unlikely to rely on the current behaviour, the main risk is from hand
> coded assembly which directly invokes syscalls. The new behaviour is
> also what is currently implemented by qemu user mode emulation.

IIRC both Will and Mark R commented in the past that they'd like the
current de-facto ABI to become the official one. I'll let them comment.

> @@ -183,7 +217,7 @@ static inline void fp_user_discard(void)
>  	if (!system_supports_sve())
>  		return;
>  
> -	if (test_thread_flag(TIF_SVE)) {
> +	if (sve_syscall_regs_clear && test_thread_flag(TIF_SVE)) {
>  		unsigned int sve_vq_minus_one;
>  
>  		sve_vq_minus_one = sve_vq_from_vl(task_get_sve_vl(current)) - 1;

If we leave TIF_SVE on, does it mean that we incur an overhead on
context switching? E.g. something like hackbench with lots of syscalls
communicating between threads would unnecessarily context switch the SVE
state. Maybe there's something handling this but IIUC fpsimd_save()
seems to only check TIF_SVE.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
