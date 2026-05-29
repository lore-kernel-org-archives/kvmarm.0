Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30BB38F92A
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780075914; cv=none; b=W7iAxtI/wUFZ3v75yijqDU+Sop9SSQYSD1Lriob90Hb+6s7CsgiSgWHn7zIweMOt2dq6InEZ35FMk608xgBucFnCMqEf0RzfASX4ZU6KQpTKgMOe60+K4BOLKixvczNwaHoq+hv/lbf7LVJwZPhOtpqXXHtBKw3xluTYWtBGp68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780075914; c=relaxed/simple;
	bh=Z7cy/0MKQJENPuwSBSOm4VNTpLV6AOAfKhRbl+j3Wi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=joQwIUHm7xUKXF6545/MBviEswg4uk7pNxOa+UlHrQAg0L+24B98AQ+rwwixEDR0rWzsTitTsBV4moUwUb8AaMAqwj5OvVe9EG1TQ8NMx6FhZTwBv5efGDBBom8HfldNd2fwta1C76a4iP/8Y7r6ynbHxtZF4fIvINEN1gk4Oy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c1vvRooN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c1vvRooN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780075912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wDPjSZ0W1ixFetVDM7vbYVUk5f0pY0gAdryhOcsw67I=;
	b=c1vvRooNumX6slPSyH7QVXIQMDFd5NpeZLDzPhg+gYiv/7BjJiqp3wj8uy/+bMZ2J0p/Fi
	DoCfS/oSLT/vimY0q7K2xQoAeVqVOMYf6oEMKjHl94jLtDI2VuoACLWb2RBtrtFpvqODHt
	vBugBd1RiHO++ZXHw+V00QlsnRGIKWQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-ocE4gKVQMnKko9KgHngl2g-1; Fri, 29 May 2026 13:31:50 -0400
X-MC-Unique: ocE4gKVQMnKko9KgHngl2g-1
X-Mimecast-MFC-AGG-ID: ocE4gKVQMnKko9KgHngl2g_1780075909
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4904ee02e72so61849515e9.1
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 10:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780075909; x=1780680709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wDPjSZ0W1ixFetVDM7vbYVUk5f0pY0gAdryhOcsw67I=;
        b=GAHc0y4iU8B5QkbXW24RfLvzSCx/Hbp743lEDHt12o2MF7SJz+Aut3iRB95/gAPKFk
         Kxh3hwoeuPZ5xQi3+nw9IilQGbGioz+c+RTPpWUlj93WXQHZL18tNAIK4jkUOSTXgRbv
         MxKAUoDjC5tX89KXU63iPR/LBNiuZMPebl8ukdqB1MePEA7DRN4LIfQ6KaNkihDPWFrG
         bjy7Ma2HO8PoJb3dOx1LhMhVQAfvWyFBbTY4umVs8aZ+3k8DwATdh0otfPr7vJzV4eQK
         cwmlddanRlADdtN+6wJ76jzfdrpawF5rUdc+2OmjMOk9FS8UAlUwSj5wdjSDJERdS+RU
         SSJw==
X-Forwarded-Encrypted: i=1; AFNElJ/jzpVzxScol5XIdZ/INEjK5NSUuEW10euRqrkqjU9XOToNwKAwEg5IGjIGO+rCEyTt47jWlWo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVmxFYc62hazeH/nGo7m+I/mWUml6mYiZUl2awUHAPQhfqwGIc
	MnWXtCv29Kd+OxsS+icw++IPPREFjUO+x1RnOv/l7tTnB6H28/UXuMJLk5C3c9SEoUJQZ6KB79w
	5pC3Bu8hZQvoUYND1FtIZQhm10YdR3Sgvrf4CxOcitSKXzC+ZnuJHxmRVl3D01KBeRjf1UqLMbe
	QtWQHKYS8+WyUOihgP+NI6PBsByAinnaHI5v0iVFQ7
X-Gm-Gg: Acq92OHFmB0MnfkUY+D6QCsRYJ3lZ3FZeorP5zHRnY2Hf65OfqOUEAHCe7mIUFJ6flQ
	rNsxgk9CY3ZsipxyASMgfksRZSke1pTC9A4RocPDWRCGiEjf9dXsNMqUjbvQe+5Xyw1gLkykjSR
	kz8cS99GJ7VUsS8GdNVcnrda9QMAzU0+IMDxLgMWUwTa/4ZUcMIRzTIxHf7hZw642PMGvpcYA+r
	q37o8PnSrnb7lUGTc+O0nV5I6pUzWeb3OXyDbQLox0WKdhSAFQrKgEEZzErDMQYk86FiFkJhUDL
	3DdxXJZQDRdoRW5jJg==
X-Received: by 2002:a05:600c:1989:b0:490:51b9:2309 with SMTP id 5b1f17b1804b1-490a297e1e1mr8600805e9.29.1780075909405;
        Fri, 29 May 2026 10:31:49 -0700 (PDT)
X-Received: by 2002:a05:600c:1989:b0:490:51b9:2309 with SMTP id
 5b1f17b1804b1-490a297e1e1mr8600305e9.29.1780075908958; Fri, 29 May 2026
 10:31:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260529105405.1839362-1-maz@kernel.org>
In-Reply-To: <20260529105405.1839362-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 29 May 2026 19:31:35 +0200
X-Gm-Features: AVHnY4KaJCOFob7wQLVfZdIu2G30xvMt9_hks8OfF0JM1D0ZM-lUBdSqwLPd7jg
Message-ID: <CABgObfbnG1gPBiZbq9o_W9LRqiYY2XCdLjJne-Ldz0cKbpwqww@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.1, take #4
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Qiang Ma <maqianga@uniontech.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mE8rhjvI5CljT2VAEXcb__svvHs0r1qPahW8w5XYR7w_1780075909
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2026 at 12:54=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> This is hopefully the last round of fixes for 7.1 on the KVM/arm64
> front.
>
> We have yet another batch of fixes for the newly introduced tracing
> code (memory leaks), a fix for a config symbol misspelled in the
> source code (therefore being permanently disabled), a fix for an
> embarrassing bug in the PMU emulation (write any value as long as it
> is zero), and an SVE sanitisation bug in nested virt resulting in a
> guest being able to access more than it really should.
>
> I've purposely refrained from adding another lot of fixes for more
> benign issues since His Majesty has announced he'd be picky about
> that. Fear not, they'll be in the 7.2 pull request.

I'm afraid I'll already have enough reasons to be shouted at this
week. :)  Pulled, thanks.

Paolo

> Please pull,
>
>         M.
>
> The following changes since commit 1702da76e017ae0fbe1a92b07bc332972c293e=
89:
>
>   KVM: arm64: Fix nVHE/pKVM hyp tracing error on invalid desc (2026-05-20=
 08:08:37 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.1-4
>
> for you to fetch changes up to 83726330748981372bde86ed5411d7b306612991:
>
>   KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor (2026-=
05-29 10:04:00 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.1, take #4
>
> - Restore CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC to its former glory by
>   making sure the config symbol is correctly spelled out in the code
>
> - Don't reset the AArch32 view of the PMU counters to zero when the
>   guest is writing to them
>
> - Fix an assorted collection of memory leaks in the newly added tracing
>   code
>
> - Fix the capping of ZCR_EL2 which could be used in an unsanitised way
>   by an L2 guest
>
> ----------------------------------------------------------------
> Mark Brown (1):
>       KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor
>
> Qiang Ma (1):
>       KVM: arm64: PMU: Preserve AArch32 counter low bits
>
> Vincent Donnefort (4):
>       KVM: arm64: Fix CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC
>       KVM: arm64: Fix meta-page unsharing in pKVM hyp tracing
>       KVM: arm64: Fix rollback in hyp_trace_buffer_share_hyp()
>       KVM: arm64: Fix memory leak in hyp_trace_unload()
>
>  arch/arm64/include/asm/kvm_host.h       |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 16 ++++++++++------
>  arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
>  arch/arm64/kvm/hyp_trace.c              |  9 ++++++---
>  arch/arm64/kvm/nested.c                 |  5 +++++
>  arch/arm64/kvm/pmu-emul.c               |  4 ++--
>  arch/arm64/kvm/sys_regs.c               | 11 +++--------
>  7 files changed, 28 insertions(+), 21 deletions(-)
>

