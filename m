Return-Path: <SRS0=c+b0=4J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD05C35646
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 17:43:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DEFD824650
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 17:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CwEu5SNq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEFD824650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3134AECE;
	Fri, 21 Feb 2020 12:43:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KdF4gK1SP0d1; Fri, 21 Feb 2020 12:43:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28E9C4AECF;
	Fri, 21 Feb 2020 12:43:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B4854AECA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 12:43:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SY8JSDapGu3i for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Feb 2020 12:43:40 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8F04AEA3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 12:43:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1582307020;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DRklp/EGbzKFbnLcWYfCTJYwspK96XjQokoDYirC2jo=;
 b=CwEu5SNqPbnkKVYFS1f81c12pLL0xamgYlmINLUdYLySmeTvlbmyI5TffrgHlVYMlz86Ag
 VCE9AE813HFBsv2MJwvjjPBVf9huudGTtteQe12aNVhkl98tXK6RsRMmJN064X0AA6a5Lr
 2a5YU0XoiWgLa0XlDHjaJ7RXQSDu5Ww=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-TwHHgCXwMUeDxns0z9TpmQ-1; Fri, 21 Feb 2020 12:43:38 -0500
X-MC-Unique: TwHHgCXwMUeDxns0z9TpmQ-1
Received: by mail-wr1-f71.google.com with SMTP id n23so1319725wra.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 09:43:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=DRklp/EGbzKFbnLcWYfCTJYwspK96XjQokoDYirC2jo=;
 b=D8SCeIwybPlMGZSafgCa2w+No/TyoMycjNy1f5BKJbZH0x13N6oUV1fXd4NiyP6GJL
 7xbNdRfYXOxxIpUFLogGZcf5MU44++NeM17Kan21Of8xdQz51EPGgg86IZd4JIp2WByE
 lP8eItk1JEgLrdmzqG//4foEE4TGw99Q0WIMytUbVboMzxIaRxNG2pGpFbCQ3hgT2nTm
 eEuJobEIWcE7Qe+EnYbxCw0JiwhMxJOvVbfIJWZPLV4JvJtiL9hbqYezqqa+Pv1izDCi
 hMTYqUewEEQWOY4sBfJJ9LD0ee1F9OnRf86omjvoHClLKCQMD7mqbQ7ii5tHK0vi0Qm5
 rycQ==
X-Gm-Message-State: APjAAAXTFUQU7i+3QJBOirQqBK5JlIZMYK0E0Azql80IlaY/5cA+USoy
 jQTqf3oWL5/wYamDy5rqPeOs/QNvNy05fBJGTz18KUNO2/4DCarsiZMAdlf0JYsyfmKTAZ02avy
 WZO+3cIBji9uolEibMv0psvIW
X-Received: by 2002:a5d:4289:: with SMTP id k9mr51197005wrq.280.1582307017033; 
 Fri, 21 Feb 2020 09:43:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2hj716qxeeRUnhWk7oLWJU5fIlTs2+zZOl+uuyj1LRQkzfullhSLke4OG8g9MBweopRblWg==
X-Received: by 2002:a5d:4289:: with SMTP id k9mr51196974wrq.280.1582307016828; 
 Fri, 21 Feb 2020 09:43:36 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
 by smtp.gmail.com with ESMTPSA id l131sm4908318wmf.31.2020.02.21.09.43.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 21 Feb 2020 09:43:36 -0800 (PST)
Subject: Re: [PATCH v6 14/22] KVM: Clean up local variable usage in
 __kvm_set_memory_region()
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
 <20200218210736.16432-15-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1467b8cd-3631-b5da-b285-dbdf31b75af7@redhat.com>
Date: Fri, 21 Feb 2020 18:43:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218210736.16432-15-sean.j.christopherson@intel.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 18/02/20 22:07, Sean Christopherson wrote:
> -sorted by update_memslots(), and the old
>  	 * memslot needs to be referenced after calling update_memslots(), e.g.
> -	 * to free its resources and for arch specific behavior.
> +	 * to free its resources and for arch specific behavior.  Kill @tmp
> +	 * after making a copy to deter potentially dangerous usage.
>  	 */
> -	old = *slot;
> +	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> +	old = *tmp;
> +	tmp = NULL;
> +

Also: old = *id_to_memslot(...).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
