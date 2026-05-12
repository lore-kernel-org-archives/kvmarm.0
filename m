Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EFB384CC0
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 21:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778620525; cv=none; b=d1+a1OPVeDAdsPiRii3yTrAfmq7lYqaapebewRK/sDzS6Op9EYGolT7bgD63RBcj2tBSNLJyq+3jAMJp11vH4eZD5w6Ra4ZMXTx9VXDat84kHQJTq+hzrntPzGWesfnUlt/a1skWZMNG8D2nh0kKBLMKJAcSElbxrvfdZbGm2JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778620525; c=relaxed/simple;
	bh=+JKCMld8UNzRIbAQbh8pc2a5fr0ofGgHNla20BPsQjU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SqiirrUqirE4MAUr6nJGi47V/ZuLTyNOoT07TZiB+JDpPhwYQQJxIVtjr3ZNI1Jqo65MER/89wHbg+NXAFlHCz18gmuWihqLa4+i8igW36GE8k/dg5oKvKApfn/4ErCYAMxjnd+UdtcKXts9YeH5tBteZ8lFfRZpT3aBDLsET3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oeds+W+X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oeds+W+X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BCaf028xC5s+DMoM0w5jJSQ23tua+iloa6oIupqhPqU=;
	b=Oeds+W+XSaK+XeTHdvTafbXour1I6BlvwvrWtJmpOKhCcg7PCRfT+5nMmyPEi0d5EVH0Ko
	ApvMNcm2Yn7mAH25aW9nanh3jhKUhIZgHqeZXWszuid+vusAh0sWWmtGUmSHtqz8VwzhkV
	+SVEwmFnnCrRX8c3zxGiRQ0KaUMovXA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-uVW1bkPzPEyJXNikxXhS3A-1; Tue, 12 May 2026 17:15:19 -0400
X-MC-Unique: uVW1bkPzPEyJXNikxXhS3A-1
X-Mimecast-MFC-AGG-ID: uVW1bkPzPEyJXNikxXhS3A_1778620517
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48e79219704so20005465e9.1
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 14:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620517; x=1779225317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BCaf028xC5s+DMoM0w5jJSQ23tua+iloa6oIupqhPqU=;
        b=mpGYKC0eaR99I8PL8BDmgdHT+FVc0lvCcCxZ973dU1xrVYs9UgAjcYcfhntlp/v3pM
         bvMXZ8vlcw8POIiUKpsy0b91QlGfQY64ibu5fTdMBOkB8aUx/yNzMjhepyOcvCk1BgX6
         QBESTGiQ0TiriBEey1Xj7TvFT68P880X932VMRg75hvlzjEyniIRoz+VnfNAx3/mCdNy
         /N8lRJaFxvnw6l8uyeNRV3qvHo3j8U+AiO/ElaZvrFMJEAiMhVdx5JIngfO48QnKb6JQ
         Tb1IH0XrRGi073isNFI/qwOqQAXw8LQ3BwhGKs9sGLGOsGWHUnm3aJaAnBaxuQcOM+q3
         AZmw==
X-Forwarded-Encrypted: i=1; AFNElJ9cwjICy3GLgx8UtX+X+XSLoBajvUemCGhYHHxyZVXT3mUUZZRgYo8oWJTdzY9ERClcD7dlkrU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRM0r5/3ty9EO48wVyyfyAwv3IR1U2ERixlXq7eQyGEr6rS0ON
	6OvEQxAbkmqG9BF2kcHaarSyzq0wsxTDPz4Kf0fGpWRLJiMNWyfBhhSmgVGX6Yr9gp8+jQpXiai
	ZZitcLJvLarCRqDOsrYTa/gIq6Ciu7+sCGwj/ECLrkcvp6UnCN9riIc0ssg5VB3DRTCSM9Iq/yV
	4V+HG6PYMOSaQJmQewGxTU7iIRAervMTsQ
X-Gm-Gg: Acq92OE0gHNH5pCPUZYY57Y4iCETPAWu2Jaxxcf/IiOwoxEGtLvay5USNnueSrkLN3v
	pS70GFh/rh47GbTA9aupWRitya1f0Kg4uGkuM36+zOS5Uwy+XhQWI3nb2Q4apqRjLmnTsboXZNy
	rxMHvgsGe+ixbz919QyBWjer5sJ/g+rNah93FpbU14yIS7ccqlkeoBXLNTh+eExoAU1ia8M8ApG
	wFzIGpcL2qIgXBBkNklpyJvnw2BESrBe3z8DjoYQU0UMMRON7UtPpWRu1NM0u6pzpW6zAm0os7N
	bwexHA4D
X-Received: by 2002:a05:600c:19c9:b0:489:1a63:509c with SMTP id 5b1f17b1804b1-48fc999e736mr7208045e9.0.1778620517209;
        Tue, 12 May 2026 14:15:17 -0700 (PDT)
X-Received: by 2002:a05:600c:19c9:b0:489:1a63:509c with SMTP id
 5b1f17b1804b1-48fc999e736mr7207685e9.0.1778620516761; Tue, 12 May 2026
 14:15:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260507154221.2905554-1-maz@kernel.org>
In-Reply-To: <20260507154221.2905554-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 12 May 2026 23:15:04 +0200
X-Gm-Features: AVHnY4KtwnsJxjKodfXT2l49vyk4PWU8NRQcHeq925qaoxrCk6J9wCnG0t9SADY
Message-ID: <CABgObfY+qCh3_j+ykf_5aU_FwWAKjnauby_AjXndkTAROKpFeQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.1, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Fuad Tabba <tabba@google.com>, James Morse <james.morse@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Mostafa Saleh <smostafa@google.com>, Oliver Upton <oupton@kernel.org>, 
	Sebastian Ott <sebott@redhat.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Sudeep Holla <sudeep.holla@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Will Deacon <will@kernel.org>, 
	Yuan Yao <yaoyuan@linux.alibaba.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PFfSGngmVBKiCQbPz60METtewMkCbo6z6urBsqydRrM_1778620517
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 7, 2026 at 5:42=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's the second set of KVM/arm64 fixes for 7.1. Nothing too horrible
> this time, aside from an ARM erratum workaround that has little impact
> on KVM, but relies on some firmware dealing with the problem. Bleh.
>
> The rest is a small collection of bug fixes, mostly affecting the MMU
> (permission fault handling with guest_memfd, 52bit VA with NV), and a
> small set of AI-enhanced fixes from Fuad. I guess I'll have to get
> used to that.
>
> And last but not least, Steffen joins the merry band of KVM/arm64
> reviewers in preparation of s390 and arm64 being joined at the hip...
>
> Please pull,

Done, thanks.

Paolo

>
>         M.
>
> The following changes since commit 7fd2df204f342fc17d1a0bfcd474b24232fb0f=
32:
>
>   Linux 7.1-rc2 (2026-05-03 14:21:25 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-=
fixes-7.1-2
>
> for you to fetch changes up to effc0a39b8e0f30670fe24f51e44329d4324e566:
>
>   KVM: arm64: Pre-check vcpu memcache for host->guest donate (2026-05-07 =
14:12:42 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.1, take #2
>
> - Add the pKVM side of the workaround for ARM's erratum 4193714, provided
>   that the EL3 firmware does its part of the job. KVM will refuse to
>   initialise otherwise.
>
> - Correctly handle 52bit VAs for guest EL2 stage-1 translations when
>   running under NV with E2H=3D=3D0.
>
> - Correctly deal with permission faults in guest_memfd memslots.
>
> - Fix the steal-time selftest after the infrastructure was reworked.
>
> - Make sure the host cannot pass a non-sensical clock update to the
>   EL2 tracing infrastructure.
>
> - Appoint Steffen Eiden as a reviewer in anticipation of the KVM/s390
>   ability to run arm64 guests, which will inevitably lead to arm64
>   code being directly used on s390.
>
> - Make sure that EL2 is configured with both exception entry and exit
>   being Context Synchronization Events.
>
> - Handle the current vcpu being NULL on EL2 panic.
>
> - Fix the selftest_vcpu memcache being empty at the point of donation or
>   sharing.
>
> - Check that the memcache has enough capacity before engaging on the
>   share/donate path.
>
> - Fix __deactivate_fgt() to use its parameter rather than a variable
>   in the macro context.
>
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>       KVM: arm64: Handle permission faults with guest_memfd
>
> Fuad Tabba (6):
>       KVM: arm64: Make EL2 exception entry and exit context-synchronizati=
on events
>       KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
>       KVM: arm64: Fix __deactivate_fgt macro parameter typo
>       KVM: arm64: Seed pkvm_ownership_selftest vcpu memcache
>       KVM: arm64: Pre-check vcpu memcache for host->guest share
>       KVM: arm64: Pre-check vcpu memcache for host->guest donate
>
> James Morse (1):
>       KVM: arm64: Work around C1-Pro erratum 4193714 for protected guests
>
> Mostafa Saleh (1):
>       KVM: arm64: Remove potential UB on nvhe tracing clock update
>
> Sebastian Ott (1):
>       KVM: selftests: arm64: Fix steal_time test after UAPI refactoring
>
> Steffen Eiden (1):
>       MAINTAINERS: Add Steffen as reviewer for KVM/arm64
>
> Wei-Lin Chang (1):
>       KVM: arm64: nv: Consider the DS bit when translating TCR_EL2
>
>  MAINTAINERS                              |  1 +
>  arch/arm64/include/asm/kvm_nested.h      |  1 +
>  arch/arm64/include/asm/sysreg.h          |  2 +-
>  arch/arm64/kvm/arm.c                     | 21 ++++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h  |  2 +-
>  arch/arm64/kvm/hyp/nvhe/clock.c          |  3 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 47 ++++++++++++++++++++++++++=
+++++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c           | 16 ++++++++++-
>  arch/arm64/kvm/hyp/vhe/switch.c          |  3 +-
>  arch/arm64/kvm/mmu.c                     | 29 ++++++++++++++------
>  include/linux/arm-smccc.h                |  6 ++++
>  tools/testing/selftests/kvm/steal_time.c |  2 ++
>  12 files changed, 120 insertions(+), 13 deletions(-)
>

