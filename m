Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB02C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 12:05:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A160610A3
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 12:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7A160610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0283F40413;
	Mon, 20 Sep 2021 08:05:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J9ZjO69wGpg8; Mon, 20 Sep 2021 08:05:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECC624048A;
	Mon, 20 Sep 2021 08:05:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C03C4048A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 08:05:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hogNe0kPUMe2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 08:05:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B80740413
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 08:05:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632139541;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=q8wAH/IsmVnI2ydhQ1BFoaOBGT1C6T31sGkkhWrMszg=;
 b=E5O5IYb3E/Ra/xlxED0QOc8QrPeCDxCsIi9ztHhZjYBOh6ejFUGPudbBXxiS/wHIdenNep
 qIFlUvG5zJwA+fqK3RXonYrssqDunAdP9q4HaYuW0GkV6Qxp86eISEvTcccX4DFIPFEpFG
 Kuo6tHq2RiDnvU1gHyMflYXobeoveWY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-lbxdPoMGMK2uesc1KIROfg-1; Mon, 20 Sep 2021 08:05:40 -0400
X-MC-Unique: lbxdPoMGMK2uesc1KIROfg-1
Received: by mail-wr1-f71.google.com with SMTP id
 m18-20020adfe952000000b0015b0aa32fd6so5877174wrn.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 05:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=q8wAH/IsmVnI2ydhQ1BFoaOBGT1C6T31sGkkhWrMszg=;
 b=VSnOi/V0Rz4yPaHugViMPjyWMLlUJsDzzkmbFvtgOnPx2w5IDrvCI9S/by4PFFHil9
 gjOWaXtnjByj4FWfeb1dHrXgSn48uzqjA0W5MrUfj3qpV6Jde/nfnmIFQGtgInmEjzaY
 EQoS9t0fqBUBXxqqhZHsuehzI5iWzWYZe6wZzLvEca/lp+/JPD+PQmqFNhtwpc1sJaHe
 kpkxdgErztM6WGebHOGVPEoubUaCSHTBu7NmywQqBsrY9UYCi9MQK8vBgmoqn8Bw8Ikg
 j6iZevZvHnDkbQHvLQPLCr5YtTa4s6aLlrFwaLyAd97/TZObO6+x+83Sk9y+1wE13Qbc
 IsEg==
X-Gm-Message-State: AOAM531uuHF9Q11tBlYIMLrlAE9BGimVab1UGtbvDQqN7C037TfbFT7C
 jTOQt87Lf8D0/bitn1W+sRcmAAHGRpcEcNkiy3TQLN6i1KmCWFBbNtu0rGuWHjflUjtXsVWp8kL
 NKK+yTcPNM8EEbL5/UrntmvEc
X-Received: by 2002:a5d:4608:: with SMTP id t8mr28038957wrq.136.1632139538951; 
 Mon, 20 Sep 2021 05:05:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz64XIPtY2fM12srCDcTMCwDqENNrjhBUdJzYmop3FKDPBAPZx+uh9ah7Isb2beeBqNbwRMJw==
X-Received: by 2002:a5d:4608:: with SMTP id t8mr28038880wrq.136.1632139538580; 
 Mon, 20 Sep 2021 05:05:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id l15sm19128605wme.42.2021.09.20.05.05.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 20 Sep 2021 05:05:37 -0700 (PDT)
To: Peter Zijlstra <peterz@infradead.org>,
 Sean Christopherson <seanjc@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828201336.GD4353@worktop.programming.kicks-ass.net>
 <YUO5J/jTMa2KGbsq@google.com>
 <YURDqVZ1UXKCiKPV@hirez.programming.kicks-ass.net>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/13] perf: KVM: Fix, optimize, and clean up callbacks
Message-ID: <662e93f9-e858-689d-d203-742731ecad2c@redhat.com>
Date: Mon, 20 Sep 2021 14:05:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YURDqVZ1UXKCiKPV@hirez.programming.kicks-ass.net>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Like Xu <like.xu.linux@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>, Will Deacon <will@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Greentime Hu <green.hu@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 17/09/21 09:28, Peter Zijlstra wrote:
>> In theory, I like the idea of burying intel_pt inside x86 (and even in
>> Intel+VMX code for the most part), but the actual implementation is a
>> bit gross.  Because of the whole "KVM can be a module" thing,
> 
> ARGH!! we should really fix that. I've heard other archs have made much
> better choices here.

I think that's only ARM, and even then it is only because of limitations 
of the hardware which mostly apply only if VHE is not in use.

If anything, it's ARM that should support module build in VHE mode 
(Linux would still need to know whether it will be running at EL1 or 
EL2, but KVM's functionality is as self-contained as on x86 in the VHE 
case).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
