Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC26C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 07:52:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C37D2619B1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 07:52:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C37D2619B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FE5B4B3E1;
	Wed, 31 Mar 2021 03:52:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b6qG-7hkQYzz; Wed, 31 Mar 2021 03:52:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B7074B3DF;
	Wed, 31 Mar 2021 03:52:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FD734B3DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 03:52:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GnXreI1wVLkq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 03:52:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7217C4B3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 03:52:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617177160;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pQ5Qm7wzrETleGdIZygb6hZggBdQLM72Jyc7tGd4rCA=;
 b=WeAfK3/0BPmYKVJzOBZc1MirCbQgkSZlqG/MGGdMuuWg/jjyZeDZ2h1gbkvYkbatFoceHb
 YgrP2GAkhCgJEoF0jsDjPcUQWyGGlCFAfc14rW+g50jPS3ysy/IO2Ok+eBkRLZHV7W9diA
 WQniSByBaj9c2sMaeSZWlczHqtF//A4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-HgbG0u_XNKmWuiL0oszxGw-1; Wed, 31 Mar 2021 03:52:36 -0400
X-MC-Unique: HgbG0u_XNKmWuiL0oszxGw-1
Received: by mail-wr1-f70.google.com with SMTP id m23so563150wrh.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 00:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=pQ5Qm7wzrETleGdIZygb6hZggBdQLM72Jyc7tGd4rCA=;
 b=XhgAkeKRA2YzI0QX8pbcvzEedbZZGD3lmrXPQMDuBO2ZFpPYPlbcnSrYGNCVNlfQet
 GBIE46ypVloGES1T2JvFXY8NIj9jUlktkLsPuBSZawPIPD4S+eD1dvYbJtoaG9+tSLSQ
 so2Bx00fbns2Ps+tlQhY+AqOd6deFcL+NDEPWUXrJLKyqlBwZYfhzwegz1FzlhmWY4n8
 8nliAUqBgkPulDklw6FlUPJz+Susua87vlj00rf0eGuRJGyBIWYS+Ud+4A+XJxZe5UEi
 NB4O+JGhHrSSaJk7dRXoY/xYvT/lKTOfha3dy8yVqq/ZNFqFttVsACwjKT4XokfLl3fy
 y26g==
X-Gm-Message-State: AOAM531bkayYqnVVpWdmTOniY96M9yV3LMokczNKLPC2/YJreuGWISRK
 Q9/r7MKnoqHTG74kT7Bi+G/cz7z3buq9vjaQ3Oz6S2ai6RDhd3d8Jizwr4gP5l/1DtFZTfAL5MS
 5uDpAlq8Z28LjwwPCquXX6nhr
X-Received: by 2002:a1c:dfc1:: with SMTP id w184mr1947762wmg.21.1617177155372; 
 Wed, 31 Mar 2021 00:52:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrEJ16pEEpfSd4UOjbnqA+7pbiSAPPFNpTAPEwcpv0H2fU5p4zyKOS02szcKvl3Y4jdrVOKQ==
X-Received: by 2002:a1c:dfc1:: with SMTP id w184mr1947732wmg.21.1617177155168; 
 Wed, 31 Mar 2021 00:52:35 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
 by smtp.gmail.com with ESMTPSA id b17sm2793386wrt.17.2021.03.31.00.52.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 00:52:33 -0700 (PDT)
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-11-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/18] KVM: Move x86's MMU notifier memslot walkers to
 generic code
Message-ID: <ba3f7a9c-0b59-cbeb-5d46-4236cde2c51f@redhat.com>
Date: Wed, 31 Mar 2021 09:52:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326021957.1424875-11-seanjc@google.com>
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

On 26/03/21 03:19, Sean Christopherson wrote:
> +#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
> +	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
> +#else
>   	struct kvm *kvm = mmu_notifier_to_kvm(mn);
>   	int idx;
>  	trace_kvm_set_spte_hva(address);
>  
> 	idx = srcu_read_lock(&kvm->srcu);
> 
> 	KVM_MMU_LOCK(kvm);
> 
> 	kvm->mmu_notifier_seq++;
> 
> 	if (kvm_set_spte_hva(kvm, address, pte))
> 		kvm_flush_remote_tlbs(kvm);
> 
>   	KVM_MMU_UNLOCK(kvm);
>   	srcu_read_unlock(&kvm->srcu, idx);
> +#endif

The kvm->mmu_notifier_seq is missing in the new API side.  I guess you 
can add an argument to __kvm_handle_hva_range and handle it also in 
patch 15 ("KVM: Take mmu_lock when handling MMU notifier iff the hva 
hits a memslot").

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
