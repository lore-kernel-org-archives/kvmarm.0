Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB24C48BC2
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 16:46:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B26A96113E
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 16:46:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B26A96113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FD774019D;
	Mon, 21 Jun 2021 12:46:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yldZPR4Tl+a5; Mon, 21 Jun 2021 12:46:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB07B40623;
	Mon, 21 Jun 2021 12:46:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1423405EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 12:46:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AcZ+lkUiepHL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 12:46:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED4A44019D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 12:46:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624294010;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=L4VUJXelLg7ZDO7Fl2bwXBKFHPY2LaqxWaruX+3FsXM=;
 b=f2uaw0H11sSKRzF71e+2BnzTpOuZ3vpFQDGYuIHatLjr9ZpjLbrIeiEnMw54CJAivEpBLt
 7j99jhflwXwpdbfgVagAW9n/kb6IWhHcaCLktzsiVLoYZ5EWPvRy/ysNNtyx8KJhIMlMD2
 zvLvBCSJ80AfmvsXLyBqeInBP7Syy4M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-DMIrobYvPxalMHUOjStThA-1; Mon, 21 Jun 2021 12:46:49 -0400
X-MC-Unique: DMIrobYvPxalMHUOjStThA-1
Received: by mail-wm1-f71.google.com with SMTP id
 u17-20020a05600c19d1b02901af4c4deac5so213401wmq.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 09:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=L4VUJXelLg7ZDO7Fl2bwXBKFHPY2LaqxWaruX+3FsXM=;
 b=pR4PK/58ymLfbalrBmGeiAm6F748MXcviQl4i87EbnauD5Lj5TfDsPtUmTlG89/zHq
 w88EKdbSaXJy/sETbA1iwluAulj+KbqZ5TtGCquxbL2jeeTfREpigaM9onJlzrX0qW7K
 kkIalrnlER+TJkiil9++nxPughScRItIXJ3Vg7O08R2JRnA4tg8ylAHF73y8uzgVVecL
 OQ4Ohu6FleB9ip4DSzTL+eoIJlfYd1/vbIH4u+jnvxB5zyTaQsdNYGnaTH/sIYIG4uMl
 fiyXsA9dwt/3i0xaodD66e3Wj2dIrhDreLytxhiMu805/gQaGJ9IAjzvvhFeV/xDxfES
 nBOQ==
X-Gm-Message-State: AOAM532mdFxQyvno8LAMUKl5sBsFik5naHNiPkOoLHkgDW6eLQQHOQU0
 0trWBDtH5RtPhYd8WybrTou2DnCuH+WFKnDMIcBP6z4nW134Wxo2Ma5US3S1E0w7e3uyPTxdT3U
 ExtmVA6pMKpHOmU63pIco0qlS
X-Received: by 2002:a1c:9a4b:: with SMTP id c72mr28275175wme.103.1624294008280; 
 Mon, 21 Jun 2021 09:46:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFHH5+7/D7vjINDjeXsFlLSfp/qFoecAKuxzghrdq/ZeJStCXx4u1i/d7WztJFV77gL5prbw==
X-Received: by 2002:a1c:9a4b:: with SMTP id c72mr28275119wme.103.1624294008036; 
 Mon, 21 Jun 2021 09:46:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id a24sm16809099wmj.30.2021.06.21.09.46.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 21 Jun 2021 09:46:47 -0700 (PDT)
Subject: Re: [PATCH v12 4/7] KVM: stats: Support binary stats retrieval for a
 VCPU
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
 Krish Sadhukhan <krish.sadhukhan@oracle.com>, Fuad Tabba <tabba@google.com>,
 Greg KH <gregkh@linuxfoundation.org>
References: <20210618222709.1858088-1-jingzhangos@google.com>
 <20210618222709.1858088-5-jingzhangos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d8bb52e6-3d1c-7008-388f-699f1a872e80@redhat.com>
Date: Mon, 21 Jun 2021 18:46:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210618222709.1858088-5-jingzhangos@google.com>
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

On 19/06/21 00:27, Jing Zhang wrote:
> +	struct kvm_vcpu_stat stat;
>   	struct kvm_dirty_ring dirty_ring;
> +	char stats_id[KVM_STATS_NAME_SIZE];

I think stats_id needs to be part of the usercopy region too.

You can also use

offsetofend(struct kvm_vcpu, stats_id) - offsetof(struct kvm_vcpu, arch)

to compute the size.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
