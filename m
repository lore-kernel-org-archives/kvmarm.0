Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0018C433B4
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:34:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30F7661107
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:34:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30F7661107
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A68FB4B2A7;
	Fri,  2 Apr 2021 05:34:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tRWBJJHpY0TJ; Fri,  2 Apr 2021 05:34:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96DAF4B297;
	Fri,  2 Apr 2021 05:34:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9974B297
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 05:34:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rQczgDKTrngX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 05:34:44 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 721E14B296
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 05:34:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617356084;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zJGFIBZSsezFGTTBbG13IPXImkEHWvDslizpfbPB0uQ=;
 b=dyaYVvQKRelvsXllsHU2XlTeLGA4H5tQXN4vxY8lcx96C6CO3vGkhDDoJpGFozIPWz0Pda
 SG/TPjbugS62UeNNa3wFH9D++P+hSckV0fxjVSX5dkc6mvnDM6H8q9B5oFmf+JyARKYUg4
 iSbCZFAdlNb5rCh9c/aQbNjtT7+tVr0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-DHJhv0MhMaGJ9q4_2K5K7g-1; Fri, 02 Apr 2021 05:34:42 -0400
X-MC-Unique: DHJhv0MhMaGJ9q4_2K5K7g-1
Received: by mail-wr1-f70.google.com with SMTP id h5so4105500wrr.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 02:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=zJGFIBZSsezFGTTBbG13IPXImkEHWvDslizpfbPB0uQ=;
 b=hjgNmVAx2V2cMb+/2wrrgfPRKtFctyzoEXMsqEE8/w8XaIPQZpCsGLzyYTtUKr20TT
 dTHPHcDz2alY2yct0/jAt1EhzZcIeup+31nfUgnYATuvJ1VuJUjklYI33PaL9MMeueYm
 vsTgS65HosSkNTEtiy87drAr2LuNAPOnNzBDflI8uZKs6Dm7qYUNRx8mFoNOf7McusX5
 8y149S7BaiqxfkiVgVtkbEPwXi6/ODYYfxvMmgV6OPXSdnbcqUZpXDMuaEQ4zUAh3d46
 VHnfHgZ+ZtQ88z/v/ixcCLlIImlB3I4FBtRymcqub08fEWxjvDbpiZ9VWlseEl7QlV2V
 EvzQ==
X-Gm-Message-State: AOAM531WHGKttnrFlfJuxGJyKU3OCVqIKU3Y3DjtJ7VN+X8FCRRiG86S
 z+bnb2XNVkWZ33jowuZ0D42J4GmIicPzX9jG88buX+ZHeh2Yt9tMrM8GGpsP3W7YUWLnWTwr9Wx
 0WAnMHco4rU9fHAHX3uSpVhIn
X-Received: by 2002:a5d:4281:: with SMTP id k1mr14190093wrq.374.1617356081565; 
 Fri, 02 Apr 2021 02:34:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzslPTY0mG/gpsRSyUhJzlJel4lWe4u0X5pwOZzh65b3L/oleiPfC3FCPnam+2uy1nVt0y3nQ==
X-Received: by 2002:a5d:4281:: with SMTP id k1mr14190061wrq.374.1617356081285; 
 Fri, 02 Apr 2021 02:34:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id p18sm13774521wrs.68.2021.04.02.02.34.39
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Apr 2021 02:34:40 -0700 (PDT)
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-10-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <417bd6b5-b7d0-ed22-adae-02150cdbfebe@redhat.com>
Date: Fri, 2 Apr 2021 11:34:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-10-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On 02/04/21 02:56, Sean Christopherson wrote:
> Avoid taking mmu_lock for unrelated .invalidate_range_{start,end}()
> notifications.  Because mmu_notifier_count must be modified while holding
> mmu_lock for write, and must always be paired across start->end to stay
> balanced, lock elision must happen in both or none.  To meet that
> requirement, add a rwsem to prevent memslot updates across range_start()
> and range_end().
> 
> Use a rwsem instead of a rwlock since most notifiers _allow_ blocking,
> and the lock will be endl across the entire start() ... end() sequence.
> If anything in the sequence sleeps, including the caller or a different
> notifier, holding the spinlock would be disastrous.
> 
> For notifiers that _disallow_ blocking, e.g. OOM reaping, simply go down
> the slow path of unconditionally acquiring mmu_lock.  The sane
> alternative would be to try to acquire the lock and force the notifier
> to retry on failure.  But since OOM is currently the _only_ scenario
> where blocking is disallowed attempting to optimize a guest that has been
> marked for death is pointless.
> 
> Unconditionally define and use mmu_notifier_slots_lock in the memslots
> code, purely to avoid more #ifdefs.  The overhead of acquiring the lock
> is negligible when the lock is uncontested, which will always be the case
> when the MMU notifiers are not used.
> 
> Note, technically flag-only memslot updates could be allowed in parallel,
> but stalling a memslot update for a relatively short amount of time is
> not a scalability issue, and this is all more than complex enough.

Proposal for the locking documentation:

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index b21a34c34a21..3e4ad7de36cb 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -16,6 +16,13 @@ The acquisition orders for mutexes are as follows:
  - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
    them together is quite rare.
  
+- The kvm->mmu_notifier_slots_lock rwsem ensures that pairs of
+  invalidate_range_start() and invalidate_range_end() callbacks
+  use the same memslots array.  kvm->slots_lock is taken outside the
+  write-side critical section of kvm->mmu_notifier_slots_lock, so
+  MMU notifiers must not take kvm->slots_lock.  No other write-side
+  critical sections should be added.
+
  On x86, vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock.
  
  Everything else is a leaf: no other lock is taken inside the critical

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
