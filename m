Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F24C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:26:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D558860FF0
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D558860FF0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gnu.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53C0D4B082;
	Fri, 18 Jun 2021 04:26:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zz3EVC2-N9Q9; Fri, 18 Jun 2021 04:26:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6314A522;
	Fri, 18 Jun 2021 04:26:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65B5B4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:03:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3J4PI9r5DE84 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 04:03:01 -0400 (EDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com
 [209.85.218.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32EF549E93
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:03:01 -0400 (EDT)
Received: by mail-ej1-f48.google.com with SMTP id nb6so14354549ejc.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 01:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:to:cc:references:from:subject:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=3xbPqY0irxJhl12JwAlZ97VPkIKSYJSliaTHl1kU42s=;
 b=X6Ghoa6vhet8MEaZEltddHovRPROJW0xifz5IyKxQPy9ewQVLhAot7OqQfkwAC0G6J
 0ZqFW6LEPTg+F9ps12wbJJrHIBFV2uQHAhJTVID9EgmaG0Z0/XdPcnvw3//o4AYNnk+y
 8rl39MwfIx/1WZGzS0j8F/68Y+nSBbJgAManVOMUWzv2+ODm2nh8KUxWAvw77rSOh+6I
 3ZZzdX7f/ZCkiM4ar/16oLAN3sYAY8jOpZqqU9XtNhAuAsIt9L7OqYgwVfOnXg7DBr0r
 tt/YK/AcxAj4stDfnsDqIVFL/W8uJ8FwYPxXkJOQ1QOdq9h/FnEmSkTqABoVw3LesFsk
 7GWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=3xbPqY0irxJhl12JwAlZ97VPkIKSYJSliaTHl1kU42s=;
 b=VqzoFBP7ldaL0S6IU4IF5tfn4oeSs0gt60NYBtbg4UXaT/5Gd2Z8siAKJ4WrHbmQgr
 LF+/wP0bYibuWSYS2w9Mi2RAbvgtkNcEsSdlVHx0tSUkN10MCtMAgXnqXaBwudKnwkLp
 hH6VXCX0kE3hWNDt3wxbprCvlxHO5uF/sx9+tb9E36WOWsEvZ5Rct2vllqes2ayx3+yD
 f7sBKX0QvhiYPd9JZYGodVnY6p3MQG9PNeWGWvCpKRDiojB2quhxzdyjiTZt4XSITnrG
 gFDWqXZawbxJwOIPYQ6Lq3KqdQtSgC1/lrLtewlOGO1aIZSdVOS1J1mFO0SoT24abLo7
 M0nQ==
X-Gm-Message-State: AOAM533oQ9F5VknWfZlQWwRp5IH1jB59PivG88VVXCHlEZQax+4Jln/C
 iNPo5EcT8kdiaB4beVd0kBY=
X-Google-Smtp-Source: ABdhPJxEFgsEbgHJkMRzhhTkPUPj8+EQf+r+/JMQ0JQA3N6KTgyL2iffbuEMHZFd87UEgYmHVCAo+Q==
X-Received: by 2002:a17:906:3b99:: with SMTP id
 u25mr9792782ejf.539.1624003380108; 
 Fri, 18 Jun 2021 01:03:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id l22sm13925edr.15.2021.06.18.01.02.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 18 Jun 2021 01:02:59 -0700 (PDT)
To: Greg KH <gregkh@linuxfoundation.org>, Jing Zhang <jingzhangos@google.com>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-3-jingzhangos@google.com>
 <YMxEqvKyGnZinMOS@kroah.com>
From: Paolo Bonzini <bonzini@gnu.org>
Subject: Re: [PATCH v11 2/7] KVM: stats: Add fd-based API to read binary stats
 data
Message-ID: <f2616b8e-0cf8-570f-4bd3-7ef5cbcb37b0@gnu.org>
Date: Fri, 18 Jun 2021 10:02:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMxEqvKyGnZinMOS@kroah.com>
Content-Language: en-US
X-Mailman-Approved-At: Fri, 18 Jun 2021 04:26:32 -0400
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
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

On 18/06/21 09:00, Greg KH wrote:
>> +struct kvm_stats_header {
>> +	__u32 name_size;
>> +	__u32 count;
>> +	__u32 desc_offset;
>> +	__u32 data_offset;
>> +	char id[];
>> +};
> 
> You mentioned before that the size of this really is the size of the
> structure + KVM_STATS_ID_MAXLEN, right?  Or is it - KVM_STATS_ID_MAXLEN?
> 
> If so, why not put that value explicitly in:
> 	char id[THE_REST_OF_THE_HEADER_SPACE];
> 
> As this is not a variable header size at all, and you can not change it
> going forward, so the variable length array here feels disingenuous.

It can change; the header goes up to desc_offset.  Let's rename 
desc_offset to header_size.

>> +struct kvm_stats_desc {
>> +	__u32 flags;
>> +	__s16 exponent;
>> +	__u16 size;
>> +	__u32 offset;
>> +	__u32 unused;
>> +	char name[];
>> +};
> 
> What is the max length of name?

It's name_size in the header.

> Why aren't these structures defined here in kerneldoc so that we can
> understand them better?  Putting them in a .rst file guarantees they
> will get out of sync, and you can always directly import the kerneldoc
> into the .rst file.

This is a problem in general with Documentation/virt/kvm/api.rst.  The 
file is organized to match the kerneldoc structs to the ioctl that they 
are used for, and sometimes a ioctl includes different structs for each 
architecture.

It is probably possible to do it using :identifiers: and/or :doc:, but 
it would require running scripts/kernel-doc on the uAPI headers dozens 
of times.  That is quite expensive at 0.3s each run, but that's what you 
get with Perl (gcc -fsyntax-only is 20 times faster).

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
