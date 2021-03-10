Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D0BC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 14:55:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CEF9564F0B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 14:55:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEF9564F0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C0F74B58D;
	Wed, 10 Mar 2021 09:55:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dMfSOiiANk+U; Wed, 10 Mar 2021 09:55:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0160E4B576;
	Wed, 10 Mar 2021 09:55:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D55064B571
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:55:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8LQDNRHR1cUa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 09:55:06 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E949E4B570
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:55:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615388106;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=LPQFDLvKrDj5V75j3OST6UCIU/ZY4HfSALPlvqp1Wfg=;
 b=UrMC50TDYFGQfhhPO62CuifVKV2BbyDMUZlOI0L/a8/axkhPrAPEWkhL7u9CL6q6Xuy87P
 LAQXcy+bQTxt7Ex6BwgCMOIPdm31Sb5PEBZEwAN8iptCt7EWCMIxWkkfMc7J39Zs9Z1oxg
 az7faHsRBIu2DsBPWYrQbsdeSrk30hc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-ytAJDn1MMsSZrPhrmZZL7w-1; Wed, 10 Mar 2021 09:55:04 -0500
X-MC-Unique: ytAJDn1MMsSZrPhrmZZL7w-1
Received: by mail-wm1-f69.google.com with SMTP id n25so2773005wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 06:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=LPQFDLvKrDj5V75j3OST6UCIU/ZY4HfSALPlvqp1Wfg=;
 b=CwxF+QLi/RCQnMM4ueNQCYaKgSwpjqWyA4iaYq4xX+K9op8KXl15DwlQUfSMPZ5Uce
 zGv3Ms/BprWtUuBzNYrwEblFJl57xZJsu+0dCYFQCvOeZuzLQ10ITojkQSwd9cQFzq6B
 APxyhUm3Al9pdawoFAsDhSZ6ODHTlZ2A0DrwvVzsCnebj2TOH+vVNM5vmSj+dOSYOw9q
 J5oinrqcNAMRM8tMg15TQSvQAgmAB9ClWogjKwdLS178Nn1Lhn6aF6C5eYWdbOdjSsCt
 bbWC43V66roZhC5YJYkrb4Ea96V75JqwYro5autXJAywUc94RKgrBGp4iUGe1/AL7yB5
 taPQ==
X-Gm-Message-State: AOAM530XQbKl/YtLijwStipJslbhoSs4USJF9BPbcSmsIUvCB74knsHN
 vpcBVE+OikSl82FJDx3zIBDK2lhVdICcAsYNS0NqS2BAaQcfRZBvgGriqpDaXKrbJCkRtsSdcBv
 KOjfxJQAg/E1aqKgUljEbVewv
X-Received: by 2002:adf:b642:: with SMTP id i2mr3865648wre.8.1615388103127;
 Wed, 10 Mar 2021 06:55:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwp8IPvog+z5u0xHa71sLbhjUTN4LuYnyJQMDL+lgzE2lfZRrpnQ7PMYA0UId6FUANQ1ovE/g==
X-Received: by 2002:adf:b642:: with SMTP id i2mr3865612wre.8.1615388102915;
 Wed, 10 Mar 2021 06:55:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id s8sm30974435wrn.97.2021.03.10.06.55.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Mar 2021 06:55:02 -0800 (PST)
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 Linux MIPS <linux-mips@vger.kernel.org>, KVM PPC <kvm-ppc@vger.kernel.org>,
 Linux S390 <linux-s390@vger.kernel.org>,
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
Date: Wed, 10 Mar 2021 15:55:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310003024.2026253-4-jingzhangos@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 10/03/21 01:30, Jing Zhang wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 383df23514b9..87dd62516c8b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3464,6 +3464,51 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   		r = kvm_arch_vcpu_ioctl_set_fpu(vcpu, fpu);
>   		break;
>   	}
> +	case KVM_STATS_GET_INFO: {
> +		struct kvm_stats_info stats_info;
> +
> +		r = -EFAULT;
> +		stats_info.num_stats = VCPU_STAT_COUNT;
> +		if (copy_to_user(argp, &stats_info, sizeof(stats_info)))
> +			goto out;
> +		r = 0;
> +		break;
> +	}
> +	case KVM_STATS_GET_NAMES: {
> +		struct kvm_stats_names stats_names;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&stats_names, argp, sizeof(stats_names)))
> +			goto out;
> +		r = -EINVAL;
> +		if (stats_names.size < VCPU_STAT_COUNT * KVM_STATS_NAME_LEN)
> +			goto out;
> +
> +		r = -EFAULT;
> +		if (copy_to_user(argp + sizeof(stats_names),
> +				kvm_vcpu_stat_strings,
> +				VCPU_STAT_COUNT * KVM_STATS_NAME_LEN))

The only reason to separate the strings in patch 1 is to pass them here. 
  But this is a poor API because it imposes a limit on the length of the 
statistics, and makes that length part of the binary interface.

I would prefer a completely different interface, where you have a file 
descriptor that can be created and associated to a vCPU or VM (or even 
to /dev/kvm).  Having a file descriptor is important because the fd can 
be passed to a less-privileged process that takes care of gathering the 
metrics

The result of reading the file descriptor could be either ASCII or 
binary.  IMO the real cost lies in opening and reading a multitude of 
files rather than in the ASCII<->binary conversion.

The format could be one of the following:

* binary:

4 bytes flags (always zero)
4 bytes number of statistics
4 bytes offset of the first stat description
4 bytes offset of the first stat value
stat descriptions:
   - 4 bytes for the type (for now always zero: uint64_t)
   - 4 bytes for the flags (for now always zero)
   - length of name
   - name
statistics in 64-bit format

* text:

stat1_name uint64 123
stat2_name uint64 456
...

What do you think?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
