Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DA6445AE3
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789407735; cv=none; b=MBlsCvzuqkRoUhqpUDSTG6+sixapEvq0ADdQPo7Fht3shgqq1TIgwZX3RoN07QURPPZgdiK2QemWvDZvfoyGNLjMLB+bxmlEgIbsdbfaw3fuYnD7ChjN9QXMaTddZ3Dk2jsbPdnf9QpczXK7MRbynbTITd/WDvDAUqy/WKA0UGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789407735; c=relaxed/simple;
	bh=H3NkHegXyGUlyjvPCAtBxAqpQZBuP5a+mlCVvVxrsTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=evt6qLbolsUYKyiGsorBx0JOPC+2r/SVBZQZnCdHeE7XLk3xZQ3JktD/mCxQgnHXNvWBXIyjvzLL6nasvz9TAdO/q2CX+pWN78/3X5iAwYu9/6Y8tXA4dQ0ZXAEDv1v8k7s50ABV60CYnH24dvBIHy5OOmHT5ysVwpHFSScD7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kq433Bu3; arc=none smtp.client-ip=91.218.175.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kq433Bu3"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=H3NkHegXyGUlyjvPCAtBxAqpQZBuP5a+mlCVvVxrsTg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789407730; v=1; x=1790012530;
 b=kq433Bu3qMP2USix9OqvuXCO0IU5R4QOfdT+vpuQBrSd12zYQk19LZmBxYFdp3L1YIBz8MBb
 vkuugvl563yb+tQtAakWerjdaVO1aGjZJTzN59aM88CMsp8Y484yyaoxDXppbKv9TN4lnCOXZtx
 rUYQW8rSRpjxexzx0UQEU1NA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id eb9c47586028273e;
	Mon, 14 Sep 2026 17:42:10 +0000
X-Mizu-Trace-ID: eb9c47586028273e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so10500e87.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 10:42:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxEhO1XcvGGWE2NWllMZ6UWuCHJnv+YXMuNAQuQwxkEspqFN+m7nR0ajgz7oOwulVXQIBkMYdw=@lists.linux.dev
X-Gm-Message-State: AFuF++mBrIXJnMpWIMx7cUL5wWb84SfQn3VDAs7oTVSF8MWP2y16ds/P
	xP6FPmTNTkmnwhbdFFid7y7p7ry3p7GjgqAcdNW91Ma85NS511EqPvLhHDrXiKdMKoJdDB9UWoY
	jSRbRwC4uOWdgJiGAQhbFDyocNYcTkgiZgoz3HkVc
X-Received: by 2002:ac2:5b83:0:b0:5b1:571f:715f with SMTP id
 2adb3069b0e04-5b8b2d5efccmr7429e87.3.1789407727631; Mon, 14 Sep 2026 10:42:07
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260830-host-direct-messages-v7-0-45f6e6db72c2@google.com> <20260830-host-direct-messages-v7-3-45f6e6db72c2@google.com>
In-Reply-To: <20260830-host-direct-messages-v7-3-45f6e6db72c2@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 18:41:31 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzqCTc_8Y3jmR2R4c=SfBCpJ0pDy+4MCO-UHLbaxNW8rQ@mail.gmail.com>
X-Gm-Features: AcwNN1WgO8h5j0RDDssCnFHMWznF85XnD9prWGY6qwmWeeRWnJoBTvrMxsiCagc
Message-ID: <CA+EHjTzqCTc_8Y3jmR2R4c=SfBCpJ0pDy+4MCO-UHLbaxNW8rQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Sebastien Ene <sebastianene@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Per,

On Mon, 31 Aug 2026 at 00:08, Per Larsen via B4 Relay
<devnull+perlarsen.google.com@kernel.org> wrote:
...
> -static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> +static void do_ffa_direct_msg(const u64 func_id,
> +                             struct arm_smccc_1_2_regs *res,
>                               struct kvm_cpu_context *ctxt)
>  {
>         DECLARE_REG(u64, endp, ctxt, 1);
> @@ -894,8 +896,12 @@ static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
>                 return;
>         }
>
> -       /* filter out framework messages and validate SBZ/MBZ bits */
> -       if (flags) {
> +       /*
> +        * filter out framework messages and validate SBZ/MBZ flag bits.
> +        * FFA_MSG_SEND_DIRECT_REQ2 implies flag-less partition message.
> +        */
> +       if ((func_id == FFA_MSG_SEND_DIRECT_REQ ||
> +            func_id == FFA_FN64_MSG_SEND_DIRECT_REQ) && flags) {
>                 ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
>                 return;

flags holds x2, which on the REQ2 path is the UUID's low half, so the
name reads as if REQ2 flags had been checked and found zero. Could it
be w2 instead?

Cheers,
/fuad


>         }
> @@ -961,15 +967,20 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>         case FFA_PARTITION_INFO_GET:
>                 do_ffa_part_get(&res, host_ctxt);
>                 goto out_handled;
> +       case FFA_MSG_SEND_DIRECT_REQ2:
> +               if (!ffa_call_supported(func_id))
> +                       goto out_not_supported;
> +               fallthrough;
>         case FFA_MSG_SEND_DIRECT_REQ:
>         case FFA_FN64_MSG_SEND_DIRECT_REQ:
> -               do_ffa_direct_msg(&res, host_ctxt);
> +               do_ffa_direct_msg(func_id, &res, host_ctxt);
>                 goto out_handled;
>         }
>
>         if (ffa_call_supported(func_id))
>                 return false; /* Pass through */
>
> +out_not_supported:
>         ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
>  out_handled:
>         ffa_set_retval(host_ctxt, &res);
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>
