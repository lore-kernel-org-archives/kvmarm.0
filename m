Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067A6C49EA3
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:27:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 872C860FF0
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 08:27:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 872C860FF0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35C874B08A;
	Fri, 18 Jun 2021 04:27:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UIwQQBxpSk4X; Fri, 18 Jun 2021 04:27:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 349994A522;
	Fri, 18 Jun 2021 04:27:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1804140821
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:27:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TNvPBuTU9F8L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 04:27:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4991C407F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 04:27:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624004825;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3cJFa3rkdFzYGb5rzW5d+HyixyhjbZALeUmzplacLDE=;
 b=WDUDMG+yIFy+RLOkgd3s42sCcbDRp33y9//JHRxyT5g8w0zD9A9nGKR6oWRLpUeO70Gc0m
 GqcWr6mpTPPUibiM8YW6nEtkI4qD29pX+AHt8bgKNQcL8v8bEoSbHzdtA8RSUUG4xM/xoD
 9AcB9o7Q1x5fNhHCiW5+NPIBM8YFxWY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-6efjEDwHNeCcrs_NSJpoRA-1; Fri, 18 Jun 2021 04:27:03 -0400
X-MC-Unique: 6efjEDwHNeCcrs_NSJpoRA-1
Received: by mail-ej1-f70.google.com with SMTP id
 jy19-20020a1709077633b02903eb7acdb38cso3596367ejc.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 01:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=3cJFa3rkdFzYGb5rzW5d+HyixyhjbZALeUmzplacLDE=;
 b=rbnsAyv+8h05Pr5Ei0dtZC+raX+qutoREWoHPGQk/Ki7NRndgP604kuNsNP9gi/yuU
 o4E4q6p7x89apicA/+TEznfnqNNnjw+Qp00hdeN7Rnx8+pVl2ZMA+PJhtbD1yGHj6HQE
 GaSHwSRw+rhBEq4Ej5HmOWa7JPIan4yfIRF8pTeK8V2e4cT05CxkWPXVn7XEZuyZEPH6
 +ZF4ImgRhnVN7B4jw3cZ99TaPTVaG9HFaU6EDXRTfbN5tMOM7a5jT8V0N+ySsFv4Cihg
 AeaAA2bVtdoBko7WE4t8Xj2x3zXVulK+flsI26dDrW54jRTV/edxwn3P5qrTyRMiW7G/
 VnUg==
X-Gm-Message-State: AOAM533gcg77UIEvE7CFA76Uowrx2r0d/jaKSW0MmbJvlvTrCBPYCkxV
 az6wOInCsxyTNed7m0A+5D3nBQcbyKC+u2jTrAxujz30Av38xpjItq0xNmbIyG7Hy16k1GMdws6
 ORbQZkR6yXrOmWfy65Ft3kdW9
X-Received: by 2002:a05:6402:2710:: with SMTP id
 y16mr3390932edd.101.1624004822546; 
 Fri, 18 Jun 2021 01:27:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGq2oipoZItfIeXLaX4qbZsbrZASIiqcoDPCV2d+cJqFo6XvKWJmN2hFBt1VaAXBJaJ52UYQ==
X-Received: by 2002:a05:6402:2710:: with SMTP id
 y16mr3390904edd.101.1624004822357; 
 Fri, 18 Jun 2021 01:27:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id m7sm709185ejo.95.2021.06.18.01.27.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 18 Jun 2021 01:27:01 -0700 (PDT)
To: Greg KH <gregkh@linuxfoundation.org>, Jing Zhang <jingzhangos@google.com>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-6-jingzhangos@google.com>
 <YMxE8pUrbQkwlpbD@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v11 5/7] KVM: stats: Add documentation for binary
 statistics interface
Message-ID: <0036c55a-72d6-7b5c-a6fd-3a285476e522@redhat.com>
Date: Fri, 18 Jun 2021 10:26:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMxE8pUrbQkwlpbD@kroah.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 18/06/21 09:02, Greg KH wrote:
>> +	struct kvm_stats_desc {
>> +		__u32 flags;
>> +		__s16 exponent;
>> +		__u16 size;
>> +		__u32 offset;
>> +		__u32 unused;
>> +		char name[];
>> +	};
> As I mention in another patch, this should be sucked in directly from
> the .h file in kerneldoc format, so that everything stays in sync.  I
> bet almost this whole file can be put into the .h file, look at how drm
> and v4l2 does this in a way that you only have to write the above one
> time, not try to keep it in sync in two different places.

V4L's userspace-api/media/v4l is absurdly good and I'd say it's by far 
the best documentation of any Linux subsystem, but it's all handwritten 
just like in KVM.  In fact, grepping for kernel-doc directives in 
Documentation/ gives no hits for the V4L uAPI documentation.

DRM has great kernel documentation, but quality-wise the KVM userland 
documentation is on a completely different level compared to DRM; just 
compare https://www.kernel.org/doc/html/latest/virt/kvm/api.html to 
https://www.kernel.org/doc/html/latest/gpu/drm-uapi.html.  The latter is 
not about how to use the DRM interfaces from userspace, it's about how 
to implement the userspace interfaces.  It is full of kernel struct 
definitions that should have no place in a uAPI manual, and does not 
include documentation for almost anything in include/uapi/drm/drm.h

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
