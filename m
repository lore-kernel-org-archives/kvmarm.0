Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DECC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:48:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D5FF4B89D;
	Wed, 16 Nov 2022 12:48:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uetoqzz3vzfo; Wed, 16 Nov 2022 12:48:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B2084B8A0;
	Wed, 16 Nov 2022 12:48:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 393404B897
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:48:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i+7gsw54vzNf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:48:47 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25AD04B872
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:48:47 -0500 (EST)
Date: Wed, 16 Nov 2022 17:48:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668620926;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=XmW9WCvz+s/qLEawf6fSBFXtTILAUrT47yXR3/eJuXA=;
 b=gHOya6+ikm8w73hzuv3v8gYs1nwKsVXAiDPYeHh25rYtsls8WnfmYPtLeNtJZoyISRHBLT
 ovYBecRu4QtPVPemAsppXx0Z0S/INA9VcgBZ5hzHUeeWV5EHNPl0dwzYNtsJmLU7qTKEeo
 S+Uoppf66b4Pw0ULuegq2accZeXeKQk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 03/12] KVM: arm64: Block unsafe FF-A calls from the host
Message-ID: <Y3Uiemx6YQxoZWhh@google.com>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-4-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221116170335.2341003-4-qperret@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kernel-team@android.com, Andrew Walbran <qwandor@google.com>,
 Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
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

Sorry, hit send a bit too early. Reviewing the patch itself:

On Wed, Nov 16, 2022 at 05:03:26PM +0000, Quentin Perret wrote:

[...]

> +static bool ffa_call_unsupported(u64 func_id)
> +{
> +	switch (func_id) {
> +	/* Unsupported memory management calls */
> +	case FFA_FN64_MEM_RETRIEVE_REQ:
> +	case FFA_MEM_RETRIEVE_RESP:
> +	case FFA_MEM_RELINQUISH:
> +	case FFA_MEM_OP_PAUSE:
> +	case FFA_MEM_OP_RESUME:
> +	case FFA_MEM_FRAG_RX:
> +	case FFA_FN64_MEM_DONATE:
> +	/* Indirect message passing via RX/TX buffers */
> +	case FFA_MSG_SEND:
> +	case FFA_MSG_POLL:
> +	case FFA_MSG_WAIT:
> +	/* 32-bit variants of 64-bit calls */
> +	case FFA_MSG_SEND_DIRECT_REQ:
> +	case FFA_MSG_SEND_DIRECT_RESP:
> +	case FFA_RXTX_MAP:
> +	case FFA_MEM_DONATE:
> +	case FFA_MEM_RETRIEVE_REQ:
> +		return true;
> +	}
> +
> +	return false;
> +}

Wouldn't an allowlist behave better in this case? While unlikely, you
wouldn't want EL3 implementing some FFA_BACKDOOR_PVM SMC that falls
outside of the denylist and is passed through.

> +bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(u64, func_id, host_ctxt, 0);
> +	struct arm_smccc_res res;
> +
> +	if (!is_ffa_call(func_id))
> +		return false;
> +
> +	switch (func_id) {
> +	/* Memory management */
> +	case FFA_FN64_RXTX_MAP:
> +	case FFA_RXTX_UNMAP:
> +	case FFA_MEM_SHARE:
> +	case FFA_FN64_MEM_SHARE:
> +	case FFA_MEM_LEND:
> +	case FFA_FN64_MEM_LEND:
> +	case FFA_MEM_RECLAIM:
> +	case FFA_MEM_FRAG_TX:
> +		break;
> +	}

What is the purpose of this switch?

> +
> +	if (!ffa_call_unsupported(func_id))
> +		return false; /* Pass through */

Another (tiny) benefit of implementing an allowlist is that it avoids
the use of double-negative logic like this.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
