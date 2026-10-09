Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA0D4562BC
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791548834; cv=none; b=j1WJWnL285b7BVt72JB8OJmmJao+h98UN+n1hMVhbsilQab1q2UX5Uil3Q8I4aw/yjObFgfky06Atoa3JquBGxs7mQmdA1/cYCHYz4sK6VAPaRLyJYZ694COE3DmxHsgz4HkMAZ4y51gvEEUzIb4O+l0ueuY46MbzaE/bOnIadA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791548834; c=relaxed/simple;
	bh=Rskl52PEXfW5/H7E17ehKiqW0raadIub/K24X2b7wVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMwJrDNs5vfhOYTjAa/dw/P0jx9nvn931KelKYSElkiAT49ieEHbHQpaikdEqTyA+KVJutSg/QNd46zYMgl1XjpL7TgRTUBSzbqMWz5j8SJ9+S3EMtn9Q6OEdH3YZmrd+RCTDw++wnvYiL/gpRT0DSFY7BxJgs3AlUgaPK4qO5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xs302W9O; arc=none smtp.client-ip=91.218.175.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xs302W9O"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Rskl52PEXfW5/H7E17ehKiqW0raadIub/K24X2b7wVU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791548820; v=1; x=1792153620;
 b=Xs302W9O2Js4RiQ++lC5emDVLJlG56yx8i8FmxPL0cuwe1tNAJMkg22ilmb0U9dKm//dKeB6
 6N4RzGNxz0dbaGi0qUWZVzZZ1hcUR36LeIegpOwvfpZdtqC62hf5qLy/W5aOPOiWsN8g6HsYte+
 5Z0nFAozomdEHF06OOsGbAgU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id dacdaafc06a941ca;
	Fri, 09 Oct 2026 12:27:00 +0000
X-Mizu-Trace-ID: dacdaafc06a941ca
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so7701e87.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 05:26:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwrc2RMYjh38Y11EU6dHHOUl3wGujACAYSb/NRM/+Zfhswg0PIRFZeo26ss+rH9TvJIBjZJxEs=@lists.linux.dev
X-Gm-Message-State: AFq9FYL2ihVa0Z6GrUTHyZj5rxRa2DiGxYs6Sq+ZhxADp1kmI8URpq57
	XSL47reiQoPoIIU4qbUp/Bc2XaPmCOb5Ir4IDNX1NQoPFCJABnh/uEBFgWGeKn1V+Ty2yZ9JPnv
	8mTQU+E/xHdR0AzQ/cT0fuRwkV2FoTI+3Qzevwdx1
X-Received: by 2002:a05:6512:398f:b0:5b8:cc2e:2fe6 with SMTP id
 2adb3069b0e04-5bcddf1700amr120088e87.5.1791548818944; Fri, 09 Oct 2026
 05:26:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009084529.462577-1-vdonnefort@google.com> <20261009084529.462577-4-vdonnefort@google.com>
In-Reply-To: <20261009084529.462577-4-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 9 Oct 2026 13:26:22 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzdEXHxkMtSU3SybNxy+Fece339bsvyc6L6K_iySdRDfA@mail.gmail.com>
X-Gm-Features: AclHuK8F4wU0wA42DfBPoQ91t2zOyKK2_7w72v27AX-GTkXE-6ZPtTr4m1wRKuE
Message-ID: <CA+EHjTzdEXHxkMtSU3SybNxy+Fece339bsvyc6L6K_iySdRDfA@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add host_hvc hyp event
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 09 Oct 2026 09:45:29 +0100, Vincent Donnefort
<vdonnefort@google.com> wrote:

[...]
> diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h

[...]
> +HYP_EVENT(host_hvc,
> +        HE_PROTO(u8 id, u64 ret),
> +        HE_STRUCT(
> +                he_field(u8, id)
> +                he_field(u64, ret)
> +        ),
> +        HE_ASSIGN(
> +                __entry->id = id;
> +                __entry->ret = ret;
> +        ),
> +        HE_PRINTK("id=%u ret=0x%llx", __entry->id, __entry->ret)
> +);

id is the index into host_hcall[], so its value depends on that
table's order. Could this log the SMCCC function ID instead, as
guest_hvc does? The alignment issue from patch 2 applies here too: the
format file puts ret at offset 3 instead of 8.

[...]
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[...]
> @@ -996,6 +996,8 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>          cpu_reg(host_ctxt, 0) = SMCCC_RET_SUCCESS;
>          hfn(host_ctxt);
>
> +        trace_host_hvc(id, cpu_reg(host_ctxt, 1));
> +
>          return;
>  inval:
>          cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;

Only some of the handlers write a return value to x1. For the others,
x1 still holds the first argument, e.g. the mmu pointer for
__kvm_tlb_flush_vmid, so host_hvc's ret field shows that instead.
Could the field be called x1 rather than ret?

Cheers,
/fuad
