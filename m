Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9A6C43219
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:58:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3094461502
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 08:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3094461502
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3AE94B2E9;
	Tue,  5 Oct 2021 04:58:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dmas+wN4uNqa; Tue,  5 Oct 2021 04:58:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87CD74B2D7;
	Tue,  5 Oct 2021 04:58:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A46544B2D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:58:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U8yQOjzHrG7Y for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 04:58:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 953714B2A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 04:58:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633424307;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iSIxKLHKuCQREC6ljaT0YwTeZjnFDwhGrC3/FjpOD9w=;
 b=gWu7/p4hWeIgtTYOV54+2Dw2NcOEm8WWmfYtQr6Zy7EnBwChdYCl7D7Zb+rOmNb8PCNN0U
 eW7ksCEc2fWvxdN2Y56fZIOAcO+Oi605I83VaWBha60P4igEBDNYJyahYNItyT5b8wzjgR
 ipcmqivKySz0EsXr6eA3tcVgls4Xp2Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-JA1zjGZhNEqhIzfvH9tHqw-1; Tue, 05 Oct 2021 04:58:23 -0400
X-MC-Unique: JA1zjGZhNEqhIzfvH9tHqw-1
Received: by mail-ed1-f71.google.com with SMTP id
 y15-20020a50ce0f000000b003dab997cf7dso16458983edi.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 01:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=iSIxKLHKuCQREC6ljaT0YwTeZjnFDwhGrC3/FjpOD9w=;
 b=iqR+BGluGeWhBv4N/PP3ta/MTLTk2Q788ACdDdBppz89x2Q42WWbDb/Yk4HT09fQuK
 DzlaPicGBszMa0RCSYm6CIGTwKV1irAwqkcHbv8lSeyOHwdyLSpL0nqCY69Ni8ZKKp/S
 459fnTJ7A5/auZ7M9vNdMMsUb4FB0AEiaR8lsMkgCQzEMf5whIpv28XV/nB5Lscv/V2P
 aMkAyWPQmA7XWYYfsSqKhbB8Z/pZMhNGSkiZ4PS0WIPiI7mD9LV0xJfpGWAMwaTKg9Vv
 haz1CbD+m1wA1Lb9a0YhrlUlhWyHI94EsULcp51kHu0sT8OBIhsZteI/vIUPdPZ9gJ2F
 xQgw==
X-Gm-Message-State: AOAM530MtTmeuRA2EJ7ZRHUfzndW/r3DM1WRv8UuEvF+o0B3cud+pnT3
 IOqCZELDat7kvPl6S1CsayzyO69tkkRiI1P3wopBYuwK74RVKvY8asHm4ekDY2aeSzJ5Ibb5+Kb
 5t3VbKeHZqbgOSUgvuFwVM/Jh
X-Received: by 2002:a50:cf87:: with SMTP id h7mr25229120edk.152.1633424302395; 
 Tue, 05 Oct 2021 01:58:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy//hFPZIOmIMpXpLIvym9w9znFdvxh5ulIf8v0oW4NCFIbrXhPFgLiygcthyaAsP0cGZ4cuA==
X-Received: by 2002:a50:cf87:: with SMTP id h7mr25229087edk.152.1633424302157; 
 Tue, 05 Oct 2021 01:58:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id z4sm8604398edb.16.2021.10.05.01.58.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Oct 2021 01:58:21 -0700 (PDT)
Message-ID: <4e5e47d8-d69f-d4ea-cfe1-90ad5c52bae1@redhat.com>
Date: Tue, 5 Oct 2021 10:58:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 0/9] selftests: KVM: Test offset-based counter controls
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210916181555.973085-1-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 16/09/21 20:15, Oliver Upton wrote:
> This series implements new tests for the x86 and arm64 counter migration
> changes that I've mailed out. These are sent separately as a dependent
> change since there are cross-arch dependencies here.
> 
> Patch 1 yanks the pvclock headers into the tools/ directory so we can
> make use of them within a KVM selftest guest.
> 
> Patch 2 tests the new capabilities of the KVM_*_CLOCK ioctls, ensuring
> that the kernel accounts for elapsed time when restoring the KVM clock.
> 
> Patches 3-4 add some device attribute helpers and clean up some mistakes
> in the assertions thereof.
> 
> Patch 5 implements a test for the KVM_VCPU_TSC_OFFSET attribute,
> asserting that manipulation of the offset results in correct TSC values
> within the guest.
> 
> Patch 6 adds basic arm64 support to the counter offset test, checking
> that the virtual counter-timer offset works correctly. Patch 7 does the
> same for the physical counter-timer offset.
> 
> Patch 8 adds a benchmark for physical counter offsetting, since most
> implementations available right now will rely on emulation.
> 
> Lastly, patch 9 extends the get-reg-list test to check for
> KVM_REG_ARM_TIMER_OFFSET if userspace opts-in to the kernel capability.
> 
> This series applies cleanly to 5.15-rc1
> 
> Tests were ran against the respective architecture changes on the
> following systems:
> 
>   - Haswell (x86)
>   - Ampere Mt. Jade (non-ECV, nVHE and VHE)
> 
> v7: https://lore.kernel.org/r/20210816001246.3067312-1-oupton@google.com
> 
> v7 -> v8:
>   - Rebased to 5.15-rc1
>   - Dropped helper for checking if reg exists in reg list (no longer
>     necessary)
>   - Test and enable KVM_CAP_ARM_VTIMER_OFFSET
>   - Add get-reg-list changes
> 
> Oliver Upton (9):
>    tools: arch: x86: pull in pvclock headers
>    selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
>    selftests: KVM: Fix kvm device helper ioctl assertions
>    selftests: KVM: Add helpers for vCPU device attributes
>    selftests: KVM: Introduce system counter offset test
>    selftests: KVM: Add support for aarch64 to system_counter_offset_test
>    selftests: KVM: Test physical counter offsetting
>    selftests: KVM: Add counter emulation benchmark
>    selftests: KVM: Test vtimer offset reg in get-reg-list
> 
>   tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++++
>   tools/arch/x86/include/asm/pvclock.h          | 103 ++++++++
>   tools/testing/selftests/kvm/.gitignore        |   3 +
>   tools/testing/selftests/kvm/Makefile          |   4 +
>   .../kvm/aarch64/counter_emulation_benchmark.c | 207 ++++++++++++++++
>   .../selftests/kvm/aarch64/get-reg-list.c      |  42 ++++
>   .../selftests/kvm/include/aarch64/processor.h |  24 ++
>   .../testing/selftests/kvm/include/kvm_util.h  |  11 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  44 +++-
>   .../kvm/system_counter_offset_test.c          | 220 ++++++++++++++++++
>   .../selftests/kvm/x86_64/kvm_clock_test.c     | 204 ++++++++++++++++
>   11 files changed, 907 insertions(+), 3 deletions(-)
>   create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
>   create mode 100644 tools/arch/x86/include/asm/pvclock.h
>   create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
>   create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
>   create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> 

Queued patches 1-5, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
