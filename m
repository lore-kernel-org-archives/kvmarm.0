Return-Path: <SRS0=ypkC=LK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D922C48BE5
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 17:12:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0FADB610A1
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 17:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FADB610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77D25402A9;
	Wed, 16 Jun 2021 13:12:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nf7ZJNBnVIzC; Wed, 16 Jun 2021 13:12:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8573B40821;
	Wed, 16 Jun 2021 13:12:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AFE1402A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 13:12:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WValQvUKIhei for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jun 2021 13:12:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74DFD40191
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 13:12:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623863546;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9dwXJG+e2J+zj861tULnfcQYsx7+UyssMsGTwpLEmFo=;
 b=eAmNTILr0py4QkjbC9BaAexwsKldRogCeQ0C3EYag0jdheEHJOyo27NIxTMIEhHasHaeIx
 u39JBEKLU15QbR2kiUAWYRKGiwrKF8bXzYobE/8c0lyVeOs3pOJZ9nvvzReSdOUZpRDRUT
 XvaIj1Y7BkCCkdcbdUY3zbJUyd1kMxU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-0SpTREK_NEmmvCKjbidmpg-1; Wed, 16 Jun 2021 13:12:22 -0400
X-MC-Unique: 0SpTREK_NEmmvCKjbidmpg-1
Received: by mail-ed1-f72.google.com with SMTP id
 z16-20020aa7d4100000b029038feb83da57so61443edq.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 10:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=9dwXJG+e2J+zj861tULnfcQYsx7+UyssMsGTwpLEmFo=;
 b=kTxWlqzUZMy+Yr6wJQ5j/EWstsM27hzztNBhzDWlf3KIIeg2fKtWyhpXRa1l3fi4Ef
 N3RmCLOmTakoJJu1C+ybgy0bGc/F4iuHdJjxC/Tb2DJuB7bl1ghCr3APEEX/gdjpb3J8
 XN+5zWx2CTc7enmaXNWVB29os18BPgG8E0zUdN5Igz6dnIjGd3VYWIogZgtbWXjyJasi
 K/9vlq8KxYPZmxSVUYIBn1TCoFiidz4N320Oited/1CA2UwopQkXMTm/4m1aSZ29nrPq
 rBP7uClNsPiu47rYEVUatHSa+tOQY2OhZPIqrLAqBNzQ64PxhALFobxhZ3Je8X08JQvH
 b1FQ==
X-Gm-Message-State: AOAM530p02IuiGYs21mBczVUhl70VsAv+rkqeG2eLOVkxL3r1zmwR6RH
 0cHRMIubzhxYYQRrs/i03XXHo2jQlSyCAJjn5SoKc0kodFzqIGSD3TJ5GYV1pCq/X0XA9CO51QD
 eLAcLVDD3Es/wpR64u14FJdqg
X-Received: by 2002:a17:906:63d2:: with SMTP id
 u18mr605565ejk.186.1623863541307; 
 Wed, 16 Jun 2021 10:12:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTKt1qnrMXcwrhxVgt67u44Y8CuaXLcDbu0P6sbQSAbP+DQ5wAsoiwPjVbuTt+umuJCe/+bA==
X-Received: by 2002:a17:906:63d2:: with SMTP id
 u18mr604976ejk.186.1623863534799; 
 Wed, 16 Jun 2021 10:12:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id n2sm2261519edi.32.2021.06.16.10.12.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Jun 2021 10:12:13 -0700 (PDT)
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
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
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>, Fuad Tabba <tabba@google.com>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <20210614212155.1670777-3-jingzhangos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 2/5] KVM: stats: Add fd-based API to read binary stats
 data
Message-ID: <60b0d569-e484-f424-722b-eb7ba415e19b@redhat.com>
Date: Wed, 16 Jun 2021 19:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210614212155.1670777-3-jingzhangos@google.com>
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

On 14/06/21 23:21, Jing Zhang wrote:
> +	/* Copy kvm stats values */
> +	copylen = header->header.data_offset + size_stats - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = stats + pos - header->header.data_offset;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}

Hi Jing,

this code is causing usercopy warnings because the statistics are not 
part of the vcpu slab's usercopy region.  You need to move struct 
kvm_vcpu_stat next to struct kvm_vcpu_arch, and adjust the call to 
kmem_cache_create_usercopy in kvm_init.

Can you post a new version of the series, and while you are at it 
explain the rationale for binary stats in the commit message for this 
patch?  This should include:

- the problem statement (e.g. frequency of the accesses)

- what are the benefits compared to debugfs

- why the schema is included in the file descriptor as well

You can probably find a lot or all of the information in my emails from 
the last couple days, but you might also have other breadcrumbs from 
Google's internal implementation of binary stats.

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
