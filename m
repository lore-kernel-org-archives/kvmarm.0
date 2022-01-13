Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1C7C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 02:50:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 710D249E5F;
	Wed, 12 Jan 2022 21:50:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bgQjodAHrHIj; Wed, 12 Jan 2022 21:50:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3827A49F59;
	Wed, 12 Jan 2022 21:50:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 627E549F2A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 21:50:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xUcDlZpm3IjQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 21:50:05 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D13949F0E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 21:50:05 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id
 l10-20020a17090a384a00b001b22190e075so16386041pjf.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 18:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ImhU/fmG/HToy1dr2YDqNHAIq2uq2Uny1Xfg58LVMDU=;
 b=Gigq102AAzuRtLukWWkUBX0D17ljeF9+2fsUkpCmhbJgmQkUkSKzzvCSbUiCBcHKeb
 y7TNSBhEeZ+YZ/ncbylr2ahjiafDpXtM+9VTFqpAsdirorLmP3+taH2Rkd/2sJ4bBlZM
 5NF65ElgZmuZrLnANwZouDTaEPq5WXtUxlwfj8nzgB6/12khDixcXKBmHVAK0lrNgb8v
 OI4XKGyy9TitatLLBjPfSxWwVozS2RX5bZsg+kkrVTOjmG2Qvd/u0UpZxgp879l6KxUs
 /wA1jJkCfBvCNla1Dfby1G+cFQsSS+qTCCrgb6VWeio4d31tEvOyeWV3vI/VJNV9z26R
 W+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ImhU/fmG/HToy1dr2YDqNHAIq2uq2Uny1Xfg58LVMDU=;
 b=amqxJ0nZcVKlnTT2MpWP+uxjgFDI+DhVV1PkrmyVliyvUh6h2z77CPP6CenaTbbkAP
 SJQSiuxU5tsRl4fOuwMcwDo8765qcATJZGJ4x/Z87WcB+XE/Hnp/6WMs5PDzAkLk+/xH
 YYl4UVGxOcvwI5/5m5QfHgVeMSFzqadHgq8Q/GTFDHEPBqo52uPIwZFO6g0ZOoDbF6iv
 Gu2jGgIFRnlBGtlZsqM8GoMNiiyl8GbGXWu7bzKhYFOcZSIFFqsdK7CA5kD3yQS/UhJQ
 7o/LK9w00X8ZkVvTM6FLRJQg1WY6iaFHHEn0i+JSovg9CksoePnhoEOj0oeF11r7jYXI
 aA0Q==
X-Gm-Message-State: AOAM530uUe2Y16N4YKffrq06OzsYw4/26P87LfZgMD/2AmgxxuQfE2wy
 zL7T3fX53GfxH+MvvlwCuoGloQ==
X-Google-Smtp-Source: ABdhPJwOm8yJobDTRYmQRBuNHnS2U4QbUjj11RF+wet+br6fkzc7s74WO9DpP5GSP2MDEwKJtbONgQ==
X-Received: by 2002:a17:90b:4381:: with SMTP id
 in1mr2933797pjb.40.1642042204018; 
 Wed, 12 Jan 2022 18:50:04 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id f125sm892919pfa.28.2022.01.12.18.50.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 Jan 2022 18:50:03 -0800 (PST)
Date: Wed, 12 Jan 2022 18:49:59 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Jing Zhang <jingzhangos@google.com>
Subject: Re: [RFC PATCH 0/3] ARM64: Guest performance improvement during dirty
Message-ID: <Yd+TV4Bkhzpnpx8N@google.com>
References: <20220110210441.2074798-1-jingzhangos@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220110210441.2074798-1-jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Jing,

On Mon, Jan 10, 2022 at 09:04:38PM +0000, Jing Zhang wrote:
> This patch is to reduce the performance degradation of guest workload during
> dirty logging on ARM64. A fast path is added to handle permission relaxation
> during dirty logging. The MMU lock is replaced with rwlock, by which all
> permision relaxations on leaf pte can be performed under the read lock. This
> greatly reduces the MMU lock contention during dirty logging. With this
> solution, the source guest workload performance degradation can be improved
> by more than 60%.
> 
> Problem:
>   * A Google internal live migration test shows that the source guest workload
>   performance has >99% degradation for about 105 seconds, >50% degradation
>   for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
>   This shows that most of the time, the guest workload degradtion is above
>   99%, which obviously needs some improvement compared to the test result
>   on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
>   * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB
>   * VM spec: #vCPU: 48, #Mem/vCPU: 4GB
> 
> Analysis:
>   * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
>     the number of contentions of MMU lock and the "dirty memory time" on
>     various VM spec.
>     By using test command
>     ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
>     Below are the results:
>     +-------+------------------------+-----------------------+
>     | #vCPU | dirty memory time (ms) | number of contentions |
>     +-------+------------------------+-----------------------+
>     | 1     | 926                    | 0                     |
>     +-------+------------------------+-----------------------+
>     | 2     | 1189                   | 4732558               |
>     +-------+------------------------+-----------------------+
>     | 4     | 2503                   | 11527185              |
>     +-------+------------------------+-----------------------+
>     | 8     | 5069                   | 24881677              |
>     +-------+------------------------+-----------------------+
>     | 16    | 10340                  | 50347956              |
>     +-------+------------------------+-----------------------+
>     | 32    | 20351                  | 100605720             |
>     +-------+------------------------+-----------------------+
>     | 64    | 40994                  | 201442478             |
>     +-------+------------------------+-----------------------+
> 
>   * From the test results above, the "dirty memory time" and the number of
>     MMU lock contention scale with the number of vCPUs. That means all the
>     dirty memory operations from all vCPU threads have been serialized by
>     the MMU lock. Further analysis also shows that the permission relaxation
>     during dirty logging is where vCPU threads get serialized.
> 
> Solution:
>   * On ARM64, there is no mechanism as PML (Page Modification Logging) and
>     the dirty-bit solution for dirty logging is much complicated compared to
>     the write-protection solution. The straight way to reduce the guest
>     performance degradation is to enhance the concurrency for the permission
>     fault path during dirty logging.
>   * In this patch, we only put leaf PTE permission relaxation for dirty
>     logging under read lock, all others would go under write lock.
>     Below are the results based on the solution:
>     +-------+------------------------+
>     | #vCPU | dirty memory time (ms) |
>     +-------+------------------------+
>     | 1     | 803                    |
>     +-------+------------------------+
>     | 2     | 843                    |
>     +-------+------------------------+
>     | 4     | 942                    |
>     +-------+------------------------+
>     | 8     | 1458                   |
>     +-------+------------------------+
>     | 16    | 2853                   |
>     +-------+------------------------+
>     | 32    | 5886                   |
>     +-------+------------------------+
>     | 64    | 12190                  |
>     +-------+------------------------+

Just curious, do yo know why is time still doubling (roughly) with the
number of cpus? maybe you performed another experiment or have some
guess(es).

Thanks,
Ricardo

>     All "dirty memory time" have been reduced by more than 60% when the
>     number of vCPU grows.
>     
> ---
> 
> Jing Zhang (3):
>   KVM: arm64: Use read/write spin lock for MMU protection
>   KVM: arm64: Add fast path to handle permission relaxation during dirty
>     logging
>   KVM: selftests: Add vgic initialization for dirty log perf test for
>     ARM
> 
>  arch/arm64/include/asm/kvm_host.h             |  2 +
>  arch/arm64/kvm/mmu.c                          | 86 +++++++++++++++----
>  .../selftests/kvm/dirty_log_perf_test.c       | 10 +++
>  3 files changed, 80 insertions(+), 18 deletions(-)
> 
> 
> base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
> -- 
> 2.34.1.575.g55b058a8bb-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
