Received: from mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF51144B690
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 12:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547614; cv=none; b=bEjuldIMJYEh0kwetA13yxEW0u9HsfHiiFoPFhPhH/gizGgf7kfx6dRqvRWRBdGPwszEDCqx3gZ+AT98h7JNtGPFJueR6KIhI/dVKdAz1vSXY+L6UajRigI33zMVDCqVP14F3JS6Z5+EGDMhWtf73etJzTtBv62YhO401S8SRIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547614; c=relaxed/simple;
	bh=8QpueOoSu8dlWDzU2ovo4g2tq4XyDape3DzAzPS1hLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WSOehvvo1045qvOkI9UjuUXpdvWGVFKVYY6BB5Ku5y2fZghtjmg/tP6IHZQJjat8cTiTYm+HoJ160v9aE8ucgOtgCEqL/vzndaN7P3ihhtz3J+/DQb6ZE7rakDts2v0pYJXl/OuL/XCct2YwcroWwDxG5IjHLkHqURukDTIXK8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A1I2APRP; arc=none smtp.client-ip=91.218.175.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A1I2APRP"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8QpueOoSu8dlWDzU2ovo4g2tq4XyDape3DzAzPS1hLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791547605; v=1; x=1792152405;
 b=A1I2APRPbUwzYbkokg4/FnN9pHlC1G6PsFDFd/eaEer6+l5TB0luJj3gzBD6PO0RY4cds/LY
 kwuF/1PBJLQ4rQKFXvvshZ9wOm4a8UXXl4jyh0QQyC218ptlUZ1oae3K3QfoQ6QfjQuNy8uoujg
 qEsIXhe2DlJZHWC3IfS1P4rM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a6b491e864cbd28e;
	Fri, 09 Oct 2026 12:06:45 +0000
X-Mizu-Trace-ID: a6b491e864cbd28e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so6870e87.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 05:06:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByJoSYtCQJZLsRToAEf37uy90KGO/sce/KDkmyvOshx0kJvQN/WRIiC3Tdrmaxrdr+4eWEFeq4=@lists.linux.dev
X-Gm-Message-State: AFq9FYIc1EohzCgnRDxdQhTtWNbsbydjGVU92IJO66rWMZR/jzhUeIp2
	6ndBpNfLNsHeou3zNHj/8xHAJDCAUN81Vv/XVdROxI8RN3OVsuNaAe+mawkQ1CDpBrPL7+ih1aR
	9OY5M0LPndyyCLoHGH//DCziURn9R2SXJ8wjFWHJU
X-Received: by 2002:a05:6512:3dab:b0:5bc:b23c:f7e5 with SMTP id
 2adb3069b0e04-5bcdf91d57emr82402e87.9.1791547601556; Fri, 09 Oct 2026
 05:06:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009084529.462577-1-vdonnefort@google.com> <20261009084529.462577-3-vdonnefort@google.com>
In-Reply-To: <20261009084529.462577-3-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 9 Oct 2026 13:06:05 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxzBBDpg3B9Lw47tMWMK+VCjpeEQDgYNKvLUnmUYVJVcA@mail.gmail.com>
X-Gm-Features: AclHuK-OrizQjQ93TY0UAA_o6daR8H0aSQt1YkpepTx45oni65FNHe6Eup6oIrU
Message-ID: <CA+EHjTxzBBDpg3B9Lw47tMWMK+VCjpeEQDgYNKvLUnmUYVJVcA@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] KVM: arm64: Add guest_hvc hyp event
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 09 Oct 2026 09:45:28 +0100, Vincent Donnefort
<vdonnefort@google.com> wrote:

> Add a guest_hvc hypervisor trace event to log protected VM HVC call IDs,
> return values, and whether the call was handled by the hypervisor.

nit: only the first return value is logged.

[...]
> diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h

[...]
> +HYP_EVENT(guest_hvc,
> +        HE_PROTO(u32 id, u64 val, u8 handled),
> +        HE_STRUCT(
> +                he_field(u8, handled)
> +                he_field(u32, id)
> +                he_field(u64, val)
> +        ),

remote_event_format_show() doesn't align the field offsets, so the
format file puts id at 3 and val at 7 instead of 4 and 8. hyp_enter's
vcpu is already off the same way, so should this be a separate fix in
trace_remote.c, with ALIGN(offset, field->align)?

[...]
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c

[...]
> @@ -1183,5 +1185,8 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
>
>          if (handled)
>                  smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
> +
> +        trace_guest_hvc(fn, val[0], handled);
> +
>          return handled;

When handled is false, val[0] is the SMCCC_RET_INVALID_PARAMETER
initialiser, which the guest never gets. For example, a MEM_SHARE
forwarded to the host logs "id=0xc6000003 val=0xfffffffffffffffd
handled=0". Could this log 0 in that case?

Cheers,
/fuad
