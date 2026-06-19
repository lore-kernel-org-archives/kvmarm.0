Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D01E98EF
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852836; cv=pass; b=Ktsl6YNgn6YoIdz+flDjlXsgBNcikRS4LzPes2KOk/SSsGBfZMoGRZXk056Tu6I4DWzsFKVL3ZB2jCCDLVchPFiC00ZwAQQhp6H8oNDvf5OHwsphHCrYtpgywFhDCOBigOX9AjBhh7QzqBIJhlHvUqx4AG2Q+SZIRqtmqygUiso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852836; c=relaxed/simple;
	bh=59SEYykoXR0SXAEp8NMf3RclLUONB1YYm3ZV3b1Ctt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EcVjNJBsSqSmzZTZbSOWqmWIY92JW17vX9ZzOhJNwllSmyS8bDg+m3uc1n0VB53Sk3dLMebSpU4yqjOwArWwccKUDwIRIINkyb6DjSDszAdRl6zx5gvnsiuVGFfQdz8SpHFbGgmHYx+ekyMh/9qG9jTU3NSGGFHc33b0fmjw/ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ENL5c68i; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ENL5c68i"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51765531803so181551cf.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781852834; cv=none;
        d=google.com; s=arc-20260327;
        b=Yk3B5x+uT6zyGMd17V/x6Z4Ad3Qj6StMZZbmLZHCnWlWyPkDqIVFCrVBUsXqD1ofCb
         2tCdhEWN42Hlax1LFqEkanxrz5s3VTOHRv/zFc+3vH2GME/xeTmU6Wr8wDFW9PoUdco9
         kO5HOby+gp+MrAq+F9VLAWOOvy4m2CGO1r/xqDb3xPgr37eh89OMCngxAyNuZPqKFg08
         Y0lCWIceTSWWR7Mnuh07jLdvLMizpJ+LpPyXx6UPJjQxoSlNCu5IJVsW4YXwkPNKmv8o
         /LjXi2eaa+PzjmEns/2qMEOjugxgfFcF+RYA6TQJMp3VHbfWh1W9ZinOR+LaeJ1EpmpT
         qNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LzUKH8rq66N3fIAi1izpkeP64WOVv5qL/rYygNemrhk=;
        fh=4alc+sgLuAgCs4SxWhUJR2nVn9NPji+EZhuwgded42c=;
        b=FMDQ8X4oo/H5gsnPUFsCSCQnAWKGfGPmDwYoPEu/AACeFMKXCSOP01JsidQfV53CJc
         raoY7o2qBH0CI9Z+wyFxIdxustXdguAuZEqXy2Kw7+/fogfmRDzbifOf2xoiDCONhO4+
         4dINmfMjtG33/LRP9appC1Uqr67B/keIHEepwVE89PX1xGIGdQAUYI3J+toUl6iwkIz9
         y1I77zqzcIm0udu/phQLLdk/DueZM8QAOKOIaMJjmW01ipH/OXEE+njhgmpPQ9LdIc9m
         N6bQbNcGgV+sl8n/T63zxvTk7yn4mdqfJANnoy9oMaXlDT66uEIg/ps9G7byF6WBd8ke
         zDHg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852834; x=1782457634; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LzUKH8rq66N3fIAi1izpkeP64WOVv5qL/rYygNemrhk=;
        b=ENL5c68iP/RJvZtII3XcAV0acm3tqIGTuiijlf360QnJ0ffpmSqERUEMpnzZLwLRhP
         KhUqg8BIpBTzK1zGiF4ANH8AIXW5loUNRcyB94/lgln88YcpJaJiNBX89iNVBtYbeafL
         25eT1dIGzMu8fjrPM3ZvoH5uNlwQTKBeFlUhPdBCtRPZDleUcPZx/CN9o39jrivEfXHT
         o1gRwiaQWuQLGVPB8y42FGA7an00QcS0QW05MvJUopBgqIrlak1t5rGCVGoGYQhhpDWm
         u9z2RB1S/ppDm9BddNzDnZYILbUI5uol6QF0V+w9NPrS+Kr8SG1n6iXy+NqnZpDasb36
         uzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852834; x=1782457634;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LzUKH8rq66N3fIAi1izpkeP64WOVv5qL/rYygNemrhk=;
        b=Gr0xT3wakjz14n98MTUtw+XHzKFqoXd8EDIWxhUzK7sTSiIphOX7w0wjAHBmOvmHel
         m4wbUEqmn3EBOF9bSXQXs1CRHoqwrda2DJTrdqpMxYYR2pCF89Xcb7bfpCER1lKE5n5E
         U7bC/2C52nHUAg70g3086+yGLRh/ya2hpbRsJWhRs90JcXbNZFGzY3pr6bsjk/HhYVxG
         ig62wQmzqzzl6VMUXJXQno3AIIn/SY/ArcrifwAblSdJ3muSa+SDnymtWFepGaDCxF27
         k2jZMjCt6JFNDXRrrG0g6m23n+EqBn6Xi4G0vbgGBAB7YmFTgGLQAmOkXeRreWN7Qr1o
         2Fjw==
X-Forwarded-Encrypted: i=1; AFNElJ/EN838E9veGD/+yrce3CTPHpZbG3STfpKowSw4ronWYl2vp3gp3Ux5k1Hi8dm+18DUhjb6Kq4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yybq/T5pUM1RQ1tQJtnCKf3v6plVC3Rgx8Y8azThXxAdw3Ji/cG
	5ZZeVY4Oes9Ynbu/q65Oe/MWF5IsQZ/1Rjn7fYZxAJX4trIQU7Xh0PLXF7vgzM72ZVF91WdlfCG
	oROw7PmFAvh6PE5+l1lLzV7nrNNtmrSNIMMDXCIWW
X-Gm-Gg: AfdE7cmFCz+tZ18MceAS0V5locLzMeNpq1h614DSSv7U1RGJxaWXbMEI9vk06lx/rsV
	JzA5cx7ohVTE8pEGhkkZbSwo+2RTtgeU/BDbd15QRyESu/tLBUTX5FwQKh34wDizgE5DkeQF1Lx
	9ZHKqF5LaRf8FAmC66pB8X6qh48yqH8bySzQBL+Cqj54RzoAPDfJUiJHzQOOTOrsSCtSg1tZqb1
	oM7rV53fz90LDPVqm39F9YT+4N1QrbNmF4ocKEfyt6AtjQrcyqthkk4gKGNzqSJsa+ynAciww==
X-Received: by 2002:a05:622a:1489:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-519e4890222mr5681461cf.4.1781852833077; Fri, 19 Jun 2026
 00:07:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com>
In-Reply-To: <20260619070508.802802-1-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 08:06:35 +0100
X-Gm-Features: AVVi8CeXp_p1Rqi9txVHuQ7hE90Ut0nVzENFoD1JZ4teV0I6ZIJ5UtHh1eaJZv4
Message-ID: <CA+EHjTy6CJcg7sM+6Tz6KZe070HVZm-cANPFQ0YkQg6_uLWX-A@mail.gmail.com>
Subject: Re: [PATCH 0/8] KVM: arm64: Rework pKVM vCPU state synchronisation
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Sorry, as the emails were being sent, I realized I forgot the V2 in
the subject. Resending now. Sorry for the noise.

Cheers,
/fuad

On Fri, 19 Jun 2026 at 08:05, Fuad Tabba <tabba@google.com> wrote:
>
> Hi folks,
>
> Changes since v1 [2]:
>   - Dropped the guard()/scoped_guard() conversion patches: standalone churn
>     on code this series does not otherwise rework. (Marc)
>   - Rebased onto kvmarm/next. The VGIC flush primitive now bounds used_lrs
>     using the cached hyp_gicv3_nr_lr instead of reading ICH_VTR_EL2 on every
>     entry. (Marc)
>   - Grouped the PKVM_HOST_STATE_DIRTY flag with the other iflags and
>     clarified its comment. (Marc)
>   - Sync PSTATE alongside PC on every non-protected exit, and sync+dirty
>     before host-side SError injection so the syndrome is not dropped. (sashiko)
>   - Various cleanups and tidying up. (Vincent)
>
> Building on Will's pKVM infrastructure series [1], this series reworks
> how pKVM moves vCPU state between the host and EL2, and stops copying a
> non-protected guest's state on every world switch.
>
> EL2 gains proper primitives for the state it transfers: vCPU lookup
> helpers, and VGIC flush/sync that reduces how much host state EL2
> dereferences. The series also moves some preparatory code (such as sys
> reg access and PSCI helpers) to shared headers and HYP, and implements
> lazy copying of a non-protected guest's register state back to the host
> until the host actually needs it, instead of on every exit.
>
> This is the first of two series moving pKVM vCPU state management to
> EL2. The follow-up completes the job for protected VMs: state
> isolation, PSCI handling at EL2, and the resulting API behaviour.
>
> The series is structured as follows:
>
>   01-04:  Preparatory refactoring (MPIDR, sys reg access, vCPU reset, PSCI
>           helpers) to shared headers and HYP.
>   05:     Host and hypervisor vCPU lookup primitives.
>   06-07:  VGIC: reduce EL2's exposure to host state, add flush/sync primitives.
>   08:     Lazy state sync for non-protected guests.
>
> Based on kvmarm/next.
>
> [1] https://lore.kernel.org/all/20260105154939.11041-1-will@kernel.org/
> [2] https://lore.kernel.org/all/20260612065925.755562-1-tabba@google.com/
>
> Cheers,
> /fuad
>
> Fuad Tabba (5):
>   KVM: arm64: Extract MPIDR computation into a shared header
>   KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
>   KVM: arm64: Factor out reusable vCPU reset helpers
>   KVM: arm64: Move PSCI helper functions to a shared header
>   KVM: arm64: Implement lazy vCPU state sync for non-protected guests
>
> Marc Zyngier (3):
>   KVM: arm64: Add host and hypervisor vCPU lookup primitives
>   KVM: arm64: Minimise EL2's exposure of host VGIC state during world
>     switch
>   KVM: arm64: Add primitives to flush/sync the VGIC state at EL2
>
>  arch/arm64/include/asm/kvm_arm.h     |  12 ++
>  arch/arm64/include/asm/kvm_asm.h     |   1 +
>  arch/arm64/include/asm/kvm_emulate.h |  79 +++++++-
>  arch/arm64/include/asm/kvm_host.h    |   2 +
>  arch/arm64/kvm/arm.c                 |   7 +
>  arch/arm64/kvm/handle_exit.c         |  30 ++++
>  arch/arm64/kvm/hyp/exception.c       |  34 +---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 258 +++++++++++++++++++++++----
>  arch/arm64/kvm/psci.c                |  30 +---
>  arch/arm64/kvm/reset.c               |  60 +------
>  arch/arm64/kvm/sys_regs.c            |  14 +-
>  arch/arm64/kvm/sys_regs.h            |  19 ++
>  include/kvm/arm_psci.h               |  27 +++
>  13 files changed, 410 insertions(+), 163 deletions(-)
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
