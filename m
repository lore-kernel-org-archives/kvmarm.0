Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D078AC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 15:41:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D41360FD7
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 15:41:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D41360FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7FE49F6C;
	Thu, 12 Aug 2021 11:41:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HhEOG+Xc+2LP; Thu, 12 Aug 2021 11:41:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE2254A1A5;
	Thu, 12 Aug 2021 11:41:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3FE49FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 11:41:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yrbJKFGy2SrM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 11:41:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA8649F6C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 11:41:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628782887;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wVAySSNkRIQjjk+QH2YkijF+uGWoxw5I4DLvZClTw1U=;
 b=D134bOSUHTTA0PBGBrfxeua3cjVaITA/aBeygqqG9zTT1sBhyUKi2w0KPInxk3bKwqOzda
 u1EV3dEohJvWbbo8vwT6klqVzAk0hvI/pwYaAxSyJm/zBxIB/ODa88m6P0j4NYOD9d2vrb
 uM+rN2JHSIrzqz2iA+75RisxeW/qbCg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-3iGGivdbM3qee5gKY_ZZwA-1; Thu, 12 Aug 2021 11:41:26 -0400
X-MC-Unique: 3iGGivdbM3qee5gKY_ZZwA-1
Received: by mail-ed1-f72.google.com with SMTP id
 b16-20020a0564022790b02903be6352006cso3217897ede.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 08:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=wVAySSNkRIQjjk+QH2YkijF+uGWoxw5I4DLvZClTw1U=;
 b=SBtNHyTQRo75GuoTMwO+AcFOS1P6E2MtvlaUQr53CixpGDjIYpGWs0DEvj3vB0rrCX
 ZIzshK8QoWHB9HWcPanlKr2QqUaJYJfGi0fwJ9a5GBAMOoe6Yasv6qr89N3fS9EHih5d
 c0XFppqW7dVwhRof5eFb/vAF6SykpBGiK/+b3uQk43pQZSmkHuC+Zkhbbwfhy5+wLQHD
 ch9OL0k7U0tUO/56z+vZgT8AzvExS9iQKfK66F3tAADGk+5gRkjcyj2yQo1zyhm8al3f
 JPOGbOWcYj/bF/09uePKYbzjLKSTZ4nqimfmzUDjRVzneWDjujm3QPjl28VuN0oTZNgR
 E16g==
X-Gm-Message-State: AOAM530h6FUaJADu2BxX1Fm6GoWR8OhW7z92JY2PkkDjnAhZq13yA3DQ
 pUgOjzSnpKYhi/FpVIslmINuICZhYYJiP2fZpdbmKkjT56QcaONsVTYzb1q84ilQn1ShaxQ9OCf
 wDx2Yh+iUVvQa3oAA6fI1nFF6
X-Received: by 2002:a50:ef11:: with SMTP id m17mr6095922eds.233.1628782885033; 
 Thu, 12 Aug 2021 08:41:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbkauFimraFjcUcxW/s5naeDzEHblJnwTGW5kN8SFMxVNVXXtWI2AkXQ1TgeG7maJbDTkRTw==
X-Received: by 2002:a50:ef11:: with SMTP id m17mr6095860eds.233.1628782884809; 
 Thu, 12 Aug 2021 08:41:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id s18sm988134ejh.12.2021.08.12.08.41.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 12 Aug 2021 08:41:24 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] KVM: Refactor kvm_arch_vcpu_fault() to return a
 struct page pointer
To: David Hildenbrand <david@redhat.com>,
 Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org
References: <YRQcZqCWwVH8bCGc@google.com>
 <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
 <98adbd3c-ec6f-5689-1686-2a8a7909951a@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d29447d4-a1b4-7f12-7bbc-8dc24cb38b72@redhat.com>
Date: Thu, 12 Aug 2021 17:41:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <98adbd3c-ec6f-5689-1686-2a8a7909951a@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 kvm-ppc@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On 12/08/21 11:04, David Hildenbrand wrote:
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> But at the same time I wonder if we should just get rid of 
> CONFIG_KVM_S390_UCONTROL and consequently kvm_arch_vcpu_fault().
> 
> In practice CONFIG_KVM_S390_UCONTROL, is never enabled in any reasonable 
> kernel build and consequently it's never tested; further, exposing the 
> sie_block to user space allows user space to generate random SIE 
> validity intercepts.
> 
> CONFIG_KVM_S390_UCONTROL feels like something that should just be 
> maintained out of tree by someone who really needs to hack deep into hw 
> virtualization for testing purposes etc.

I have no preference either way.  It should definitely have selftests, 
but in x86 land there are some features that are not covered by QEMU and 
were nevertheless accepted upstream with selftests.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
