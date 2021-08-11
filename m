Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3BFC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 13:05:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5D12600CD
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 13:05:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B5D12600CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26ED240874;
	Wed, 11 Aug 2021 09:05:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B9XwedxU3+SK; Wed, 11 Aug 2021 09:05:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C46D40878;
	Wed, 11 Aug 2021 09:05:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73E1540878
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 09:05:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zgg-0Co5l841 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 09:05:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A363C40874
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 09:05:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628687134;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ejky1L45fjpIqglpN+AycHkOBEyLVHC4mSrGMJh6Vhk=;
 b=R6jKYdjEjs3FUXNbrLa7BVwvfC0aKyH5ntWKOYxgjEy2XtHfngeIrGXk00jEWOkQgoA2XM
 sp53/RbdLPmcEWK2HHejBKDqZrPZGPjPbsxkrUIsCM0HLDZ/Zx1Lt23OUzHyosdO17VnyO
 y1wGTslXwTcbU77i5oTQDEL26kFRgjY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-cpatxCwZORKyRUjI6rW8_A-1; Wed, 11 Aug 2021 09:05:33 -0400
X-MC-Unique: cpatxCwZORKyRUjI6rW8_A-1
Received: by mail-ej1-f71.google.com with SMTP id
 h17-20020a1709070b11b02905b5ced62193so664442ejl.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 06:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=ejky1L45fjpIqglpN+AycHkOBEyLVHC4mSrGMJh6Vhk=;
 b=FQugXtUXDEjv/aJjN2qAZe/gyX5A7/wfsxHFtEN6LaJ57UiwWGrGWTfzDKAaoWSozC
 Ode8o6+rGtCKDYdZVU5ljLfP1mMeELmDXUE2kB6EPHQSX+EKRDPvUzm+Y1Z3vWgI0cH/
 Iv9bkB70h34ZHN59I9glyWJ+1k14qCB8ekEu6hpc1ca5zKRzndHsIJifumokvN66Ga7D
 ONQ58eh+TIDpHb9eynoQZtmNfeA03qfvq0yOOMkKTcqgU6ChjhJP/tLEuC5A1BxAC3+o
 HMdZPViLjC1Vs1p74qse95ddG92kA1olDxVPnBVy0K1zVD3UtK66fL2i+1JrH+IXNLTB
 Bo2Q==
X-Gm-Message-State: AOAM533pHnLpM0gcpTnapXIedZlOH6RX80KWUgRfvoJ1b8GfCCvHnQC/
 VJwI9XgoTHgD0TR3RJuXc2MnDtE9bdnD3wQfmgDCEqd8zqL8XZodUcDg1BUheSJ+EyojDFpXMuF
 o3up7eS9NFX5o55EopPP2vpac
X-Received: by 2002:a17:907:3d93:: with SMTP id
 he19mr3569805ejc.179.1628687132018; 
 Wed, 11 Aug 2021 06:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv0o2qcd2qyszkVd6eUDUWXqakuUjyDYC+wCYZeaGx1y3ijN1A/umGBfrGXBRNz7hWK5walg==
X-Received: by 2002:a17:907:3d93:: with SMTP id
 he19mr3569774ejc.179.1628687131737; 
 Wed, 11 Aug 2021 06:05:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id y1sm2657015ejf.2.2021.08.11.06.05.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 11 Aug 2021 06:05:31 -0700 (PDT)
Subject: Re: [PATCH v6 00/21] KVM: Add idempotent controls for migrating
 system counter state
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210804085819.846610-1-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <927240ff-a4f4-fcc6-ae1b-92cefeda9e59@redhat.com>
Date: Wed, 11 Aug 2021 15:05:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On 04/08/21 10:57, Oliver Upton wrote:
> KVM's current means of saving/restoring system counters is plagued with
> temporal issues. At least on ARM64 and x86, we migrate the guest's
> system counter by-value through the respective guest system register
> values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
> brittle as the state is not idempotent: the host system counter is still
> oscillating between the attempted save and restore. Furthermore, VMMs
> may wish to transparently live migrate guest VMs, meaning that they
> include the elapsed time due to live migration blackout in the guest
> system counter view. The VMM thread could be preempted for any number of
> reasons (scheduler, L0 hypervisor under nested) between the time that
> it calculates the desired guest counter value and when KVM actually sets
> this counter state.
> 
> Despite the value-based interface that we present to userspace, KVM
> actually has idempotent guest controls by way of system counter offsets.
> We can avoid all of the issues associated with a value-based interface
> by abstracting these offset controls in new ioctls. This series
> introduces new vCPU device attributes to provide userspace access to the
> vCPU's system counter offset.
> 
> Patch 1 addresses a possible race in KVM_GET_CLOCK where
> use_master_clock is read outside of the pvclock_gtod_sync_lock.
> 
> Patch 2 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> essential for a VMM to perform precise migration of the guest's system
> counters.
> 
> Patches 3-4 are some preparatory changes for exposing the TSC offset to
> userspace. Patch 5 provides a vCPU attribute to provide userspace access
> to the TSC offset.
> 
> Patches 6-7 implement a test for the new additions to
> KVM_{GET,SET}_CLOCK.
> 
> Patch 8 fixes some assertions in the kvm device attribute helpers.
> 
> Patches 9-10 implement at test for the tsc offset attribute introduced in
> patch 5.

The x86 parts look good, except that patch 3 is a bit redundant with my 
idea of altogether getting rid of the pvclock_gtod_sync_lock.  That said 
I agree that patches 1 and 2 (and extracting kvm_vm_ioctl_get_clock and 
kvm_vm_ioctl_set_clock) should be done before whatever locking changes 
have to be done.

Time is ticking for 5.15 due to my vacation, I'll see if I have some 
time to look at it further next week.

I agree that arm64 can be done separately from x86.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
