Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB28470EB3
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789403596; cv=none; b=u/o5tbgneO5DfTEMcCA6zNCIeQsC0ZFShoST1eGVfUte3vavM3kZVbgIPJOO15bJ84oxQVZem38EH1JGxFCX9EDHKweJyWMzQ20fi5e2wng+1rmo1D77YD4tAPsO7Vsln23fYu0ZB6sz/kLZFyjEK0zPGg0ZCoiESeps3qiP3Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789403596; c=relaxed/simple;
	bh=W5+NjNc2Yvil7nhmREpSKhaOG865kOQghRODVtnSokk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VMg54xaGN0JnTSOylgQPJ6fOtVlnx0CKnhcQXFwUPXbvOMdOvVSTGQiiNWnakgJcYA6QtCnCThmiVOYZ1ixznJQGm+cCDBLQsxi9Su4YXYELJDXIxlWOMCPUHE2E4An5O1oHFUtGRyMt4L6DMl9epQ1We8/b7H0GBASe42u35sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wMXI11zT; arc=none smtp.client-ip=91.218.175.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wMXI11zT"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=W5+NjNc2Yvil7nhmREpSKhaOG865kOQghRODVtnSokk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789403591; v=1; x=1790008391;
 b=wMXI11zT4x2VM4z3tQofLQShRUeF1WHie9x0FESViaBPlnHS0TIcOwS4cJxeZXhdzeBYJZvE
 St/qmgeJ4F4O0PZL452V08D6jdoUDy/sD+zx8TQDSO19OBLM/sS7ykQfp0ZRyBgJ8u/i6R10Mfx
 RyeeobL8Yc1BUrDwiTL/Jjn4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1a0084cb65422116;
	Mon, 14 Sep 2026 16:33:11 +0000
X-Mizu-Trace-ID: 1a0084cb65422116
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so9649e87.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 09:33:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx+P2knqjm1OiNIqRyoqA2C/nEOH1nnOB7oq94LuW7v5mx1xioCsSMRibSXpf4vprOz3BfEuaI=@lists.linux.dev
X-Gm-Message-State: AFuF++n3mZNQVbZde6egtO0DOyAx8t9VC4d1AWYiadE8ijkEvalQ3cT9
	q2Xr2Nb6FTpc36cEEDf7rU7TvQnviDx+enoQlIuK8Nu6fhVJ2Z7WXW3LXD1gzNznygqX6yca4+a
	6bafCMP5IX2Tr2/m0AC+6/EpjhvZUOah4QCu+4CAG
X-Received: by 2002:a05:6512:b2a:b0:5b1:4fd9:ac with SMTP id
 2adb3069b0e04-5b8af7a5112mr81906e87.3.1789403588069; Mon, 14 Sep 2026
 09:33:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260830-host-direct-messages-v7-0-45f6e6db72c2@google.com> <20260830-host-direct-messages-v7-2-45f6e6db72c2@google.com>
In-Reply-To: <20260830-host-direct-messages-v7-2-45f6e6db72c2@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 17:32:31 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwCrh3SXggD4p9BD0A4tUe0Xc9bPREw94uAwrEizgygeA@mail.gmail.com>
X-Gm-Features: AcwNN1U-PrGVaJ7CGsoLsa0purDu4_JoU58bTFRJLLpJ0ZCVxT7qQm_pkVz-m_s
Message-ID: <CA+EHjTwCrh3SXggD4p9BD0A4tUe0Xc9bPREw94uAwrEizgygeA@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
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

Hi Per, Seb,

On Mon, 31 Aug 2026 at 00:08, Per Larsen via B4 Relay
<devnull+perlarsen.google.com@kernel.org> wrote:
[...]
> Allow direct messages to be forwarded from the host. The host should
> not be sending framework messages so they are filtered out.

The patch also rejects a sender ID that isn't HOST_FFA_ID, which the
message doesn't mention. Could you add a line for it?

[...]

> + if (upper_32_bits(endp) ||
> +    FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != HOST_FFA_ID) {

Rejecting a non-zero high half of x1 makes sense to me, since EL2
checks bits 31:16 and then forwards the whole register to EL3, and
handle_host_smc() already does the same for x0. x3 to x17 reach EL3 as
the host wrote them though. Was the intent to stop at the registers
this function reads?

[...]

> + struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];

This relies on struct arm_smccc_1_2_regs fitting in the 31 entries of
regs[], which holds today at 18. Could it take a BUILD_BUG_ON, like
do_ffa_mem_xfer() has for its fids?

Cheers,
/fuad
