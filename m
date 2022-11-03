Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40274C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 15:27:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3EAC4B633;
	Thu,  3 Nov 2022 11:27:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rb4w7OvCIfCF; Thu,  3 Nov 2022 11:27:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5092B4B630;
	Thu,  3 Nov 2022 11:27:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FDEA4B24C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:27:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZkTioE+jnmtF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 11:27:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 795FB4B090
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:27:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667489273;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xCSLioTknXwq+ek9x4fiuIn1LdVr/LliQOq4IIs2CLE=;
 b=UlUeIPFghiiYsdAzdI7QI8/Es18nEexMjJc8+7ol0CpkKuFPaj2Js5ERkKmDlrN/j1uD9+
 rVW7cDqusq3FABPutxi70/v6hNPNT4fxABLh0BKyzhhyhlP0Ct1Su+AFqMQA8HcmaIrZzC
 IPwN0Oq5I3Q6xS6svsiMUtUvV90ZQN4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-102-ZZZvk8egNnmDFDtszQ9Xhg-1; Thu, 03 Nov 2022 11:27:52 -0400
X-MC-Unique: ZZZvk8egNnmDFDtszQ9Xhg-1
Received: by mail-ej1-f71.google.com with SMTP id
 qk31-20020a1709077f9f00b00791a3e02c80so1490757ejc.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 08:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=xCSLioTknXwq+ek9x4fiuIn1LdVr/LliQOq4IIs2CLE=;
 b=IGQhgB7GkLlJG1gKkd18cKdadRaOxznn08L5/jKnZtJnA3Et2iAOvzbmsob3INzrET
 pdXae12TS/xQkiUD4SvI5H6QT17uibWvQg56AJSoANygjinjorJHt7IVyBxLMFPyuaqJ
 EsCOkNqX+U1yvW76Z+CUE5Idsr2fAq3dkMJOSEkjmvM215j7EJIoQZjNAiyezx0j55sT
 luyWMf0Jd+zXixTwMyx39YsAUslwgwIgBLcqhqLWNFRHh1zDrZ4Zm1VW5CYYS7hkIQzZ
 GspsZMKtgcRfZowNztZPHOywjv0dwtHBuA/0k9Tt6brHdSWvsMC88oZrmfM5ThQJts5S
 6OBw==
X-Gm-Message-State: ACrzQf1VkdCIs5tuOZYClWV0lgE+6HAJMoLtdyTabFvTmtjvKcmMHVy6
 7T1P1nyBmKafE6Bb5p2Kl50zEjfUNMy1E+XU595YOd5/TeNK9sk4MO48PBUDhDOUVl4jbyQ9QJb
 XQTd7Tt0HrNc7kRBL/gPpJXaK
X-Received: by 2002:a17:907:2dab:b0:78d:fc4b:7e31 with SMTP id
 gt43-20020a1709072dab00b0078dfc4b7e31mr28147748ejc.531.1667489270826; 
 Thu, 03 Nov 2022 08:27:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7u9a9PiI+1WXKEKW1T9dxImTSTFhIKArq6MPRri6hHxMVLdP9Ji+9iwit/AYCn6duMyFkDdg==
X-Received: by 2002:a17:907:2dab:b0:78d:fc4b:7e31 with SMTP id
 gt43-20020a1709072dab00b0078dfc4b7e31mr28147732ejc.531.1667489270591; 
 Thu, 03 Nov 2022 08:27:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c?
 ([2001:b07:6468:f312:1c09:f536:3de6:228c])
 by smtp.googlemail.com with ESMTPSA id
 15-20020a508e4f000000b00463bc1ddc76sm657729edx.28.2022.11.03.08.27.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 08:27:49 -0700 (PDT)
Message-ID: <82df23f2-b049-8bee-8bb8-608645b918d8@redhat.com>
Date: Thu, 3 Nov 2022 16:27:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <b37267a9-c0b4-9841-71af-d8eab9baeb60@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b37267a9-c0b4-9841-71af-d8eab9baeb60@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTEvMy8yMiAxMzowOCwgQ2hyaXN0aWFuIEJvcm50cmFlZ2VyIHdyb3RlOgo+PiBUaGVyZSBh
cmUgYnVnIGZpeGVzIHRocm91Z2hvdXQgdGhpcyBzZXJpZXMuwqAgVGhleSBhcmUgbW9yZSBzY2F0
dGVyZWQgdGhhbgo+PiBJIHdvdWxkIHVzdWFsbHkgcHJlZmVyLCBidXQgZ2V0dGluZyB0aGUgc2Vx
dWVuY2luZyBjb3JyZWN0IHdhcyBhIGdpZ2FudGljCj4+IHBhaW4gZm9yIG1hbnkgb2YgdGhlIHg4
NiBmaXhlcyBkdWUgdG8gbmVlZGluZyB0byBmaXggY29tbW9uIGNvZGUgaW4gb3JkZXIKPj4gZm9y
IHRoZSB4ODYgZml4IHRvIGhhdmUgYW55IG1lYW5pbmcuwqAgQW5kIHdoaWxlIHRoZSBidWdzIGFy
ZSBvZnRlbiBmYXRhbCwKPj4gdGhleSBhcmVuJ3QgYWxsIHRoYXQgaW50ZXJlc3RpbmcgZm9yIG1v
c3QgdXNlcnMgYXMgdGhleSBlaXRoZXIgcmVxdWlyZSBhCj4+IG1hbGljaW91cyBhZG1pbiBvciBi
cm9rZW4gaGFyZHdhcmUsIGkuZS4gYXJlbid0IGxpa2VseSB0byBiZSBlbmNvdW50ZXJlZAo+PiBi
eSB0aGUgdmFzdCBtYWpvcml0eSBvZiBLVk0gdXNlcnMuwqAgU28gdW5sZXNzIHNvbWVvbmUgX3Jl
YWxseV8gd2FudHMgYQo+PiBwYXJ0aWN1bGFyIGZpeCBpc29sYXRlZCBmb3IgYmFja3BvcnRpbmcs
IEknbSBub3QgcGxhbm5pbmcgb24gc2h1ZmZsaW5nCj4+IHBhdGNoZXMuCj4+Cj4+IFRlc3RlZCBv
biB4ODYuwqAgTGlnaHRseSB0ZXN0ZWQgb24gYXJtNjQuwqAgQ29tcGlsZSB0ZXN0ZWQgb25seSBv
biBhbGwgCj4+IG90aGVyIGFyY2hpdGVjdHVyZXMuCj4gCj4gU29tZSBzbmlmZiB0ZXN0cyBzZWVt
IHRvIHdvcmsgb2sgb24gczM5MC4KClRoYW5rcy4gIFRoZXJlIGFyZSBqdXN0IGEgY291cGxlIG5p
dHMsIGFuZCBNSVBTL1BQQy9SSVNDLVYgaGF2ZSB2ZXJ5IApzbWFsbCBjaGFuZ2VzLiAgRmVlbCBm
cmVlIHRvIHNlbmQgbWUgYSBwdWxsIHJlcXVlc3Qgb25jZSBNYXJjIGFja3MuCgpQYW9sbwoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
