Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FB9C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 16:03:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACD8E64F4C
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 16:03:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACD8E64F4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B27D4B614;
	Wed, 10 Mar 2021 11:03:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gnrRW13P+aO0; Wed, 10 Mar 2021 11:03:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8434B4B9;
	Wed, 10 Mar 2021 11:03:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F2E14B3DC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 11:03:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tPYCA+ieTVH2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 11:03:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E00B4B391
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 11:03:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615392228;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=T6LZWP2vn4gZYNN60dpd9pTIeb1KCd0er7xtszZkk6U=;
 b=bhKXKhxw+ZSn/71Tksjz1NmcU1+mwOomex78JYC/oYUjKLGc3teEQ8M2d+jR61pb6M2IGb
 OoWJjeBzLF/a5NOAqjYcvbSH26haJKbdVJR9rJVHIUIB+LHW09EOoahiJZU6YRlQFmhM5C
 VVnJ/7symILjjKRlE4F0qBcEISc1YSQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-8oJB-BTrPNWDwIiad3zaSA-1; Wed, 10 Mar 2021 11:03:47 -0500
X-MC-Unique: 8oJB-BTrPNWDwIiad3zaSA-1
Received: by mail-ej1-f71.google.com with SMTP id di5so7426569ejc.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 08:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=T6LZWP2vn4gZYNN60dpd9pTIeb1KCd0er7xtszZkk6U=;
 b=s1155McZ5CdEjCBoVQAr0oAacVE6DDpjltX3I5HIUAmtaa5QGlQ440x3OQ/+jFgVLB
 Sw6Z9k6kskzHLOY0dy6OAGPh/AKEnDqdixXEnkgp8mChMxWJBu/f7B4kiTi91Ju2BOim
 UKyx/LQEb+IKHIl37qVUGWuGcSt/OB0h+TZ5nFI8ylp5sDCVXt0ExUa0HrsUQon5k8CN
 ZydB0HMubhwHCtM+Xxq9QS528iG0L9s2D9ig3np0+ZhmgPsW0VnakrjUleRY2dWCO3ba
 oxqXEFQkqpooSPiWLqXGFRDPR9twqNOA2n+BML24fzv/hWTbpOQr83NMXbI0G4yt5ugU
 LlwQ==
X-Gm-Message-State: AOAM532METzsmdyQbknW/0wkFmKQ8mBb6w/MZadq34toJQ53XRSJBUrK
 WUBQzE6VmaLMKL9a7+GKgAnhozGOiyjv9jnwc4Ohwo9FXqdLah+bG+bCa5j0JH/5S8BPl26e5zG
 MjdAsl4SqyWJd2++44MmNXBsf
X-Received: by 2002:a17:906:c0c8:: with SMTP id
 bn8mr4365626ejb.445.1615392225941; 
 Wed, 10 Mar 2021 08:03:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1V5iKaTO/Dprgp6gE22d8iEwpMy8ZGDfQA++8bp2mD+TtXAT0OFzpxwvgV6mj5ydH3tp6rw==
X-Received: by 2002:a17:906:c0c8:: with SMTP id
 bn8mr4365501ejb.445.1615392224882; 
 Wed, 10 Mar 2021 08:03:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id k9sm8884545edn.68.2021.03.10.08.03.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Mar 2021 08:03:44 -0800 (PST)
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
To: Marc Zyngier <maz@kernel.org>, Jing Zhang <jingzhangos@google.com>
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <875z1zxb11.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a475d935-e404-93dd-4c6d-a5f8038d8f4d@redhat.com>
Date: Wed, 10 Mar 2021 17:03:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <875z1zxb11.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 Linux S390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVM PPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, Linux MIPS <linux-mips@vger.kernel.org>,
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

On 10/03/21 16:51, Marc Zyngier wrote:
>> +	kvm_for_each_vcpu(j, vcpu, kvm) {
>> +		pdata = data + VM_STAT_COUNT;
>> +		for (i = 0; i < VCPU_STAT_COUNT; i++, pdata++)
>> +			*pdata += *((u64 *)&vcpu->stat + i);
> Do you really need the in-kernel copy? Why not directly organise the
> data structures in a way that would allow a bulk copy using
> copy_to_user()?

The result is built by summing per-vCPU counters, so that the counter 
updates are fast and do not require a lock.  So consistency basically 
cannot be guaranteed.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
