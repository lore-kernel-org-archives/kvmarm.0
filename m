Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D657CC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 10:52:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 354FC4B178;
	Fri, 17 Jun 2022 06:52:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TVQvSpuJRkN8; Fri, 17 Jun 2022 06:52:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E702F4B292;
	Fri, 17 Jun 2022 06:52:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0D64B28B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 06:52:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SX21Uf1PFqnC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 06:52:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF00D4A104
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 06:52:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655463131;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=B2dYfE2TVctf4jjJM8cZ0OkZ6hMQc8+l8IcfTjtxUPQ=;
 b=f/MMheUDXqCPkvwew6kzJKeOO8zMqlHVKAz0AX93i1UBKFNgcQJ52UqikcAok2HQyoBApd
 PPC2WfRA2YIzzL1DvRQ7D39yZqL88AZ66ybd9fTb6Uj3YsXZJNKwUOHhdoQJljjhVwthfc
 PbnYa8qDNh3yhDk2EjtRykGhGtrW8AU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-snFoxQL1Nh6tQLCTloNZyQ-1; Fri, 17 Jun 2022 06:52:10 -0400
X-MC-Unique: snFoxQL1Nh6tQLCTloNZyQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 h17-20020a056402281100b0043555086cdcso2521384ede.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 03:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=B2dYfE2TVctf4jjJM8cZ0OkZ6hMQc8+l8IcfTjtxUPQ=;
 b=44hegHNT1Jz5tbG/NJmsrzu+hC2mvHAzCvxTNVNlcdQG/iauwnlwoYuopsgVGyKD6T
 2zADXv6uT2Y5cgaZf/qgHPf2oO7n/kv1W0Uj8OK+52hfcZiCbrHcjFaS90TvmuBfa0aP
 3hQY2vMAMus/553XPlHSUgsM1hlW8ZcAbQ2bB9XQOziBoaJp5FZ4Kr/7uJba1ZI5eges
 yjV91J+WQ7JDfSc9seX1d5ts6IKKrdFGzeC25MmWcxqJSOJ9pdTDIxL5A8QO2EQTOP/Z
 6skU2a1ClTKbl8GW1j0RxvYcGz3Nih8azCCUZW9Sv3oPMScywJL4HGrLrrbQDD/C+JKX
 61UQ==
X-Gm-Message-State: AJIora9gIcrCfGtaCYFUayKfnllB1Aeitk/tXIu4txwabb/oLEKYCOTS
 BuriC7HjAwQvlVaaci8taR5SaMr5Sfjkl5cUH3QfBQS9bdQe0SKmshwDNS2RaNBUm8eNpkNl8/z
 DFfy91mxnq82tV7NtCUoY8zR/
X-Received: by 2002:a05:6402:28a2:b0:42d:e116:de8f with SMTP id
 eg34-20020a05640228a200b0042de116de8fmr11549734edb.305.1655463128834; 
 Fri, 17 Jun 2022 03:52:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tABs7MpnT1zfuP8SigoGGiLGDtBqdW08doDcPWPdw3vep8dF85qhKXbK71GQ6b2hvG5OvDBQ==
X-Received: by 2002:a05:6402:28a2:b0:42d:e116:de8f with SMTP id
 eg34-20020a05640228a200b0042de116de8fmr11549708edb.305.1655463128587; 
 Fri, 17 Jun 2022 03:52:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 w15-20020a1709064a0f00b00703671ebe65sm1971175eju.198.2022.06.17.03.52.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 17 Jun 2022 03:52:06 -0700 (PDT)
Message-ID: <4b7f7a70-963f-0505-f849-37c516ffaa73@redhat.com>
Date: Fri, 17 Jun 2022 12:52:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [Question] remote_tlb_flush statistic is missed from
 kvm_flush_remote_tlbs() ?
To: Andrew Jones <drjones@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <25c7cc69-64ef-d42b-dc0b-968d7415b111@redhat.com>
 <87wndf383z.wl-maz@kernel.org> <20220617103316.4rejrhxtew7meawb@gator>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220617103316.4rejrhxtew7meawb@gator>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On 6/17/22 12:33, Andrew Jones wrote:
> I don't see the change for commit 38f703663d4c as of an upstream pull
> right now
> 
> $ git show 47700948a4ab:arch/arm64/kvm/mmu.c | grep -A4 'void kvm_flush_remote_tlbs'
> void kvm_flush_remote_tlbs(struct kvm *kvm)
> {
> 	++kvm->stat.generic.remote_tlb_flush_requests;
> 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> }
> 
> and I do see it got dropped with merge commit e99314a340d2.
> 
> $ git diff 419025b3b419 0d0a19395baa -- arch/arm64/kvm/mmu.c | grep -A5 'void kvm_flush_remote_tlbs'
>   void kvm_flush_remote_tlbs(struct kvm *kvm)
>   {
> +	++kvm->stat.generic.remote_tlb_flush_requests;
>   	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> -	++kvm->stat.generic.remote_tlb_flush;
>   }

Hi,

on ARM it makes little sense to split remote_tlb_flush_requests and 
remote_tlb_flush.  On x86 the latter means "a vmexit was forced in order 
to flush the TLB", and in fact this common code:

         if (!kvm_arch_flush_remote_tlb(kvm)
             || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
                 ++kvm->stat.generic.remote_tlb_flush;

should probably be written

         if (!kvm_arch_flush_remote_tlb(kvm))
		return;

	if (kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
		++kvm->stat.generic.remote_tlb_flush;

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
