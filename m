Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9000FECAAD5
	for <kvmarm@archiver.kernel.org>; Fri, 26 Aug 2022 10:50:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D814E24E;
	Fri, 26 Aug 2022 06:50:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rGkFzksp-bV2; Fri, 26 Aug 2022 06:50:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D46D14E2BC;
	Fri, 26 Aug 2022 06:50:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 135F64E24E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 06:50:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4jobsW+luNm1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Aug 2022 06:50:29 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4DAE4E294
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 06:50:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661511029;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pLii0dfj1y7lFu87Lg22T36M6OnU1zUptup5Hy8q+CA=;
 b=OO2eonGXI9WqD0QmWdZnmaxtBbAOekzMpYI+f2KtcvxrIDcXWsOoK27oQWiCmnWAoRHATe
 FOjQM5g5kGBXFCRv7aP+wrFE0FfLVsVfdnpefR2C8q2RYyZaqpiV6wB+waagVuEv7Ux8RJ
 Zb71dA6MZmzsniqX861DzKSsu4NZlNM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-301-43ZUM5hLOEa3wyTsXDLvnA-1; Fri, 26 Aug 2022 06:50:28 -0400
X-MC-Unique: 43ZUM5hLOEa3wyTsXDLvnA-1
Received: by mail-ed1-f69.google.com with SMTP id
 i6-20020a05640242c600b00447c00a776aso898280edc.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Aug 2022 03:50:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=pLii0dfj1y7lFu87Lg22T36M6OnU1zUptup5Hy8q+CA=;
 b=1ULFcqhDOtRZwfbhor+taIn0gcrzQ+LBB72NRds20yavPZwqqyI86hqKczgLsfFtEB
 kNZfNzwOgujR2llnawYxV9k4hkV5s0aZ6qHMrhAVswY8zKz0r0C5PBEgrzAaxp/iAEXv
 eO3uVx8Ob/H4Rxr8TnO8bz6E6hBUPPBLft1fGaioW0A8Nu9Gpmgfn4kSpnK+lSIGuYUe
 cD6rduu8GMAHIw0BC5DfMM+RwroMHqLZtZLI26BzqPU8PZqsDzMrnzljYwewZEwecP4X
 DYdLMpj0ZyWLWumIujFc9Jk7kdt8K4M5NAgEjtfx0Rj3uuQ9uHYC1FnJ259F6ONax+rR
 AQqw==
X-Gm-Message-State: ACgBeo0yWJaRNFyeKakRUUMh7okGF8GaBFlRms/X2+ASin8kayfCIubO
 Z+RtULIMqei/Eh28XgjFNRmkSaKy96hgCpLcT7umYm1PVor7lbxv3RHyN/bGupfPaDYKU2p99ae
 R7UCHnwwwWH4IqGM+6bHN9fq3
X-Received: by 2002:a17:907:84a:b0:733:735:2b1a with SMTP id
 ww10-20020a170907084a00b0073307352b1amr5021060ejb.290.1661511026949; 
 Fri, 26 Aug 2022 03:50:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7I33tIVReqn9qteZcQFjZQwkCSQgOePSldWnAYXVK6po7eIEvLdgg+W/uNc+AQTkft1CgJvQ==
X-Received: by 2002:a17:907:84a:b0:733:735:2b1a with SMTP id
 ww10-20020a170907084a00b0073307352b1amr5021032ejb.290.1661511026688; 
 Fri, 26 Aug 2022 03:50:26 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 1-20020a170906218100b0072af4af2f46sm750652eju.74.2022.08.26.03.50.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 26 Aug 2022 03:50:26 -0700 (PDT)
Message-ID: <9e7cb09c-82c5-9492-bccd-5511f5bede26@redhat.com>
Date: Fri, 26 Aug 2022 12:50:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
To: Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com> <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
 <171d0159-4698-354b-8b2f-49d920d03b1b@redhat.com>
 <YwTc++Lz6lh3aR4F@xz-m1.local> <87bksawz0w.wl-maz@kernel.org>
 <YwVEoM1pj2MPCELp@xz-m1.local> <878rnewpaw.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
In-Reply-To: <878rnewpaw.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: shuah@kernel.org, shan.gavin@gmail.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, bgardon@google.com, will@kernel.org,
 linux-kselftest@vger.kernel.org, catalin.marinas@arm.com, dmatlack@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 8/24/22 00:47, Marc Zyngier wrote:
>> I definitely don't think I 100% understand all the ordering things since
>> they're complicated.. but my understanding is that the reset procedure
>> didn't need memory barrier (unlike pushing, where we have explicit wmb),
>> because we assumed the userapp is not hostile so logically it should only
>> modify the flags which is a 32bit field, assuming atomicity guaranteed.
> Atomicity doesn't guarantee ordering, unfortunately. Take the
> following example: CPU0 is changing a bunch of flags for GFNs A, B, C,
> D that exist in the ring in that order, and CPU1 performs an ioctl to
> reset the page state.
> 
> CPU0:
>      write_flag(A, KVM_DIRTY_GFN_F_RESET)
>      write_flag(B, KVM_DIRTY_GFN_F_RESET)
>      write_flag(C, KVM_DIRTY_GFN_F_RESET)
>      write_flag(D, KVM_DIRTY_GFN_F_RESET)
>      [...]
> 
> CPU1:
>     ioctl(KVM_RESET_DIRTY_RINGS)
> 
> Since CPU0 writes do not have any ordering, CPU1 can observe the
> writes in a sequence that have nothing to do with program order, and
> could for example observe that GFN A and D have been reset, but not B
> and C. This in turn breaks the logic in the reset code (B, C, and D
> don't get reset), despite userspace having followed the spec to the
> letter. If each was a store-release (which is the case on x86), it
> wouldn't be a problem, but nothing calls it in the documentation.
> 
> Maybe that's not a big deal if it is expected that each CPU will issue
> a KVM_RESET_DIRTY_RINGS itself, ensuring that it observe its own
> writes. But expecting this to work across CPUs without any barrier is
> wishful thinking.

Agreed, but that's a problem for userspace to solve.  If userspace wants 
to reset the fields in different CPUs, it has to synchronize with its 
own invoking of the ioctl.

That is, CPU0 must ensure that a ioctl(KVM_RESET_DIRTY_RINGS) is done 
after (in the memory-ordering sense) its last write_flag(D, 
KVM_DIRTY_GFN_F_RESET).  If there's no such ordering, there's no 
guarantee that the write_flag will have any effect.

The main reason why I preferred a global KVM_RESET_DIRTY_RINGS ioctl was 
because it takes kvm->slots_lock so the execution would be serialized 
anyway.  Turning slots_lock into an rwsem would be even worse because it 
also takes kvm->mmu_lock (since slots_lock is a mutex, at least two 
concurrent invocations won't clash with each other on the mmu_lock).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
