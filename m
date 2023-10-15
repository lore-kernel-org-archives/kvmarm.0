Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B4A63B6
	for <kvmarm@lists.linux.dev>; Sun, 15 Oct 2023 12:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RFZXZjQ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697372611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MJ81Q5/B7q8cI3s0s8gDvVOoyclQrSAhpuPqTSeggew=;
	b=RFZXZjQ9MiClujBAoQElXjTHy8yTXt++Gz+ZQFK69ZJBQhOxNwIoZeKC87YPBzqwtC9Th6
	21yjySN+0l7M+m/8u2wfVTSAj/T6rBVcA6K4yRGOLDLwj7fIGuKrax8Jr1ROc1mgLb6/WI
	PBUy4wVaOxAIUdkvZ+ehQfVW82/gAaM=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-Q3ujOL-OMBOH6Nb1DFLOug-1; Sun, 15 Oct 2023 08:23:19 -0400
X-MC-Unique: Q3ujOL-OMBOH6Nb1DFLOug-1
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-4a4156b0b5cso1143797e0c.0
        for <kvmarm@lists.linux.dev>; Sun, 15 Oct 2023 05:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697372597; x=1697977397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJ81Q5/B7q8cI3s0s8gDvVOoyclQrSAhpuPqTSeggew=;
        b=SD6z6ATsL+F1H8qevSj4PyYu6p6jAwqAX4oBC6+Vg7/6xDwXGBzRqYDmA1zAKhNaon
         nu+i7zwI2B74xTPBZXkSJ2BrWJ/WSD3n4GuAVfZmuxhWl0so1EtDG+4ylUielpW1k0dk
         7rsm7/yUl26eGKfYo0A1AYHBIZoQuvCNsEZ0+h/oTMBLDRC+sli4x47BCvoa73z5HWNn
         4yoQ++KJbnLJnHsqy43LxK8MsOOL9XtW7rI+ZIah21a97yFS548+CDXCtq4M4pNp2r7s
         VGXfUgi7CSiN4YnmHAsXwO7Yfy0YXahTGUbzYbvop40JrgeVAgWIfeJ+7CFmJcIdsVIn
         FaRQ==
X-Gm-Message-State: AOJu0YxQeFs2IGnJY9Y/PtpFG1Ne+GMtE9D8bfVn9AGSBDx4yoTq5WDp
	3lnVjDGkVPXo/dJyv4UIjRK+2aF7uDYnskhllsUu4wDb+FvINntngcxMCA5GMSJAn7pZBfk1hFa
	R/CLOjfrg8F2V3fdNdY2ZLy0hOgfIFJyZ
X-Received: by 2002:a67:e1c4:0:b0:457:bdbf:8a34 with SMTP id p4-20020a67e1c4000000b00457bdbf8a34mr5510900vsl.29.1697372597588;
        Sun, 15 Oct 2023 05:23:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLssNye3K6hgQQYMw1WXAnaq+73MFpiDByXlBI9bAJiL9b103Flr6+4ZBOkqE2VWibhn55BXabT71I1Q4Czc4=
X-Received: by 2002:a67:e1c4:0:b0:457:bdbf:8a34 with SMTP id
 p4-20020a67e1c4000000b00457bdbf8a34mr5510883vsl.29.1697372596972; Sun, 15 Oct
 2023 05:23:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231013213053.3947696-1-maz@kernel.org>
In-Reply-To: <20231013213053.3947696-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sun, 15 Oct 2023 14:23:05 +0200
Message-ID: <CABgObfYQoepvvB6j7k2gei0DdV+noO-qSfEzqFcmrKLM_URG_Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.6, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, James Morse <james.morse@arm.com>, 
	Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 13, 2023 at 11:31=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
>  Paolo,
>
> Here's a set of additional fixes for 6.6. The most important part is
> the fix for a breakage of the Permission Indirection feature, which is
> a regression. The other (less important) part is a fix for the physical
> timer offset.
>
> Please pull,
>
>         M.
>
> The following changes since commit 373beef00f7d781a000b12c31fb17a5a9c2596=
9c:
>
>   KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID (2023-09-12 13:0=
7:37 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.6-2
>
> for you to fetch changes up to 9404673293b065cbb16b8915530147cac7e80b4d:
>
>   KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2 (2023-10=
-12 16:55:21 +0100)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.6, take #2
>
> - Fix the handling of the phycal timer offset when FEAT_ECV
>   and CNTPOFF_EL2 are implemented.
>
> - Restore the functionnality of Permission Indirection that
>   was broken by the Fine Grained Trapping rework
>
> - Cleanup some PMU event sharing code
>
> ----------------------------------------------------------------
> Anshuman Khandual (1):
>       KVM: arm64: pmu: Drop redundant check for non-NULL kvm_pmu_events
>
> Joey Gouly (2):
>       KVM: arm64: Add nPIR{E0}_EL1 to HFG traps
>       KVM: arm64: POR{E0}_EL1 do not need trap handlers
>
> Marc Zyngier (1):
>       KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2
>
>  arch/arm64/include/asm/kvm_arm.h |  4 ++--
>  arch/arm64/kvm/arch_timer.c      | 13 +++---------
>  arch/arm64/kvm/emulate-nested.c  |  2 ++
>  arch/arm64/kvm/hyp/vhe/switch.c  | 44 ++++++++++++++++++++++++++++++++++=
++++++
>  arch/arm64/kvm/pmu.c             |  4 ++--
>  arch/arm64/kvm/sys_regs.c        |  4 ++--
>  include/kvm/arm_arch_timer.h     |  7 +++++++
>  7 files changed, 62 insertions(+), 16 deletions(-)
>

