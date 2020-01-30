Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092B1C33C9E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 05:44:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83F552067C
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 05:44:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6R00qTG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83F552067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFF1B4ACBE;
	Thu, 30 Jan 2020 00:44:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BVQ-tHMnMAo4; Thu, 30 Jan 2020 00:44:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 087804A968;
	Thu, 30 Jan 2020 00:44:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69C584A957
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 00:44:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kDDY+E33yhkE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 00:44:14 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F684A597
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 00:44:14 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580363054;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=b8PEF8AVAWODPDupJea+4sWEJHHfwQkjaA/7qcZmag4=;
 b=Y6R00qTGMkNZUDTi9Bjzix9BllX0aNbcel38FTI/KrI0Gy8ohOqOO1Bo+f8ANxQ1udmsI+
 9gc93iPBE/sR02iBoU12Jc/3Qc6eX62uUl1dMn9j+vUyG+JNRIzIuJRkCkDUz+nQ7AQlt3
 2i8of8hMPtwPYKMTBmpP5X7h+dsdlcs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-cNLFDy1sPk2KWSlrKQevcg-1; Thu, 30 Jan 2020 00:44:12 -0500
Received: by mail-wm1-f70.google.com with SMTP id a10so654672wme.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jan 2020 21:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=b8PEF8AVAWODPDupJea+4sWEJHHfwQkjaA/7qcZmag4=;
 b=m2PEdx6O1egNIGE/pPTKf52kRMdAuIv6OOoGDoysj8NiTAbKeOevogR7isY+Tkw4sj
 n+2mU8iM/yObMFlMxzx6qDR1vw1Oldg7l2nxu+V6iINEcA+Fqx0ORIomddV3fdPjAENn
 WhQLV0EPfRBjPGRR1wJr6AmYjWh1fLzo488sc3W82/aPVUs1JH9ZzTFulS3Cg436b38a
 4/WIJIisTKwz8sTJpFM/bWDEy65akXGI8dkVCwJpNqf7SQNF1AQy9MHydyc2tT8z9SqC
 5kHVBOu3oCTjZMAmt7j89t5CS/W+37d0o0Edg7NmyxsxfEq9C8DZ2m6RFHuns/C4NRrL
 7Trw==
X-Gm-Message-State: APjAAAWd2dnzx/bckArELGcLEz7c3TXkFc4Aa141ZqUXBzsQlAfW9/pn
 uW5toZaG0P1LjpT7sUcRAcRXLwlxrZddZZ0MeuPFyAChdDJE35kWNRQnPLyK4msMWPzXkPddq6O
 lmyh3sCSWvA6aLcCcpT7dKHT0
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr3175381wmi.21.1580363051283; 
 Wed, 29 Jan 2020 21:44:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxvrtUyXEqgq8iYKVpAB/LAj4fC31bOc+VOTWRDvsFWxjJ6sWsl8qJGadVTcya+7iE6vbimVA==
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr3175335wmi.21.1580363050959; 
 Wed, 29 Jan 2020 21:44:10 -0800 (PST)
Received: from [10.1.251.141] ([80.188.125.198])
 by smtp.gmail.com with ESMTPSA id 4sm4795049wmg.22.2020.01.29.21.44.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Jan 2020 21:44:10 -0800 (PST)
Subject: Re: [PATCH 5/5] KVM: x86: Set kvm_x86_ops only after
 ->hardware_setup() completes
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200130001023.24339-1-sean.j.christopherson@intel.com>
 <20200130001023.24339-6-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <44e0c550-7dcc-bfed-07c4-907e61d476a1@redhat.com>
Date: Thu, 30 Jan 2020 06:44:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200130001023.24339-6-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: cNLFDy1sPk2KWSlrKQevcg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On 30/01/20 01:10, Sean Christopherson wrote:
> Set kvm_x86_ops with the vendor's ops only after ->hardware_setup()
> completes to "prevent" using kvm_x86_ops before they are ready, i.e. to
> generate a null pointer fault instead of silently consuming unconfigured
> state.

What about even copying kvm_x86_ops by value, so that they can be
accessed with "kvm_x86_ops.callback()" and save one memory access?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
