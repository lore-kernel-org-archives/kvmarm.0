Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF28D1DDED
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 19:50:51 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-76c27782e30so4143739f.3
        for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 12:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685044251; x=1687636251;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ObkkrpGCZ6jiKurOn4Vm2QFLFy19smc7EknbNsel8tg=;
        b=CGJBCMvbcTH+HOLpI+lEwBcSZfxxUUQpBlZMNGkhR+Zhf9S7X12/5YSUWSb1V85kQ9
         xNxtLQe2oi8tg1wwdT2U14DOPcpCgTkTAx6hTNiJgEJOJW1c2YWqXdM6QIRZqgD+q8UL
         ihy0RXE66bzN6bTFFYOM73l4naR9SZ1rIST+PPgtNsGOqRxEG7bisXjpbdbx985ymSUe
         Ph8WkYdiLNt7Lvx5QqYXen1FUYhycmtjCmMWMxRpwMSJxLIdhRozT4s08C2SXeSvmQaL
         tweZ0hPcGiDX/YXBltocC7A+WB0aI4MqiAlAgJaVczkZvWTE5mWFcwvxCGbpXcRAJesn
         fdXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685044251; x=1687636251;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ObkkrpGCZ6jiKurOn4Vm2QFLFy19smc7EknbNsel8tg=;
        b=l8H6I3tT6SlcpH/aoUhkf0YmoGKVJdNlTNwteVOaUa/49/ZRTRppAvIF7A/ZlaLc6C
         LMDimOw23suS6NQxUriaUtqZkuhfRUgxbRkc4h0yfIWlnAgy8zXFamQ3CP3BS/zrjfzU
         CAkQWZHnKoeOYTwtVMj8XT9QS/HuZFpHRDy9gbKdCTLIXw1GFSvVMkji1pJorhGDoO/x
         JmgStPyJsxH8SlWKbhKxW40uP87ffztAnZyKNJBQowHM8O7UO5C3vfEgNXe7TFworI/U
         CnbPoMmFFdnhRa/pG7UUpDWpaRNkfPvUZEcwNudo50mJ9nxqTho7xqtlIzXL2e1lkoxl
         P1/g==
X-Gm-Message-State: AC+VfDzRzFKUNOzJeKpCI+zzjkweblMOWvQ2FPK0CeeeT8sLp4BfI3Bd
	1sRzYKtKc+jEqFFEfKm8CycHD1KKEk4WAQnS+w==
X-Google-Smtp-Source: ACHHUZ6Z9KtoHJcC7GMhgxz3P8RqY3VCZI0iGscR2klaQUEZZ+6Qywdmzo991lbX54ZFbRF0UxjhEzYCVxqPJ/+YQA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:29c7:0:b0:41b:b95:89db with SMTP
 id p190-20020a0229c7000000b0041b0b9589dbmr5348368jap.5.1685044250766; Thu, 25
 May 2023 12:50:50 -0700 (PDT)
Date: Thu, 25 May 2023 19:50:49 +0000
In-Reply-To: <20230509142235.3284028-8-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnta5xsb36u.fsf@coltonlewis-kvm.c.googlers.com>
Subject: RE: [PATCH v2 07/11] arm64: mops: handle MOPS exceptions
From: Colton Lewis <coltonlewis@google.com>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, 
	Luis Machado <luis.machado@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

> +	if (esr & ESR_ELx_MOPS_ISS_MEM_INST) {
> +		/* SET* instruction */
> +		if (option_a ^ wrong_option) {
> +			/* Format is from Option A; forward set */
> +			pt_regs_write_reg(regs, dstreg, dst + size);
> +			pt_regs_write_reg(regs, sizereg, -size);
> +		}
> +	} else {
> +		/* CPY* instruction */
> +		if (!(option_a ^ wrong_option)) {
> +			/* Format is from Option B */
> +			if (regs->pstate & PSR_N_BIT) {
> +				/* Backward copy */
> +				pt_regs_write_reg(regs, dstreg, dst - size);
> +				pt_regs_write_reg(regs, srcreg, src - size);
> +			}
> +		} else {
> +			/* Format is from Option A */
> +			if (size & BIT(63)) {
> +				/* Forward copy */
> +				pt_regs_write_reg(regs, dstreg, dst + size);
> +				pt_regs_write_reg(regs, srcreg, src + size);
> +				pt_regs_write_reg(regs, sizereg, -size);
> +			}
> +		}
> +	}

I can see an argument for styling things closely to the ARM manual as
you have done here, but Linux style recommends against deep nesting. In
this case it is unneeded. I believe this can be written as a single
if-else chain and that makes it easier to distinguish the three options.

if ((esr & ESR_ELx_MOPS_ISS_MEM_INST) && (option_a ^ wrong_option)) {
	/* Format is from Option A; forward set */
	pt_regs_write_reg(regs, dstreg, dst + size);
	pt_regs_write_reg(regs, sizereg, -size);
} else if ((option_a ^ wrong_option) && (size & BIT(63)) {
	/* Forward copy */
	pt_regs_write_reg(regs, dstreg, dst + size);
	pt_regs_write_reg(regs, srcreg, src + size);
	pt_regs_write_reg(regs, sizereg, -size);
} else if (regs-pstate & PSR_N_BIT) {
	/* Backward copy */
	pt_regs_write_reg(regs, dstreg, dst - size);
	pt_regs_write_reg(regs, srcreg, src - size);
}
