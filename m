Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F269FC3DA79
	for <kvmarm@archiver.kernel.org>; Thu, 29 Dec 2022 20:52:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E7E14B651;
	Thu, 29 Dec 2022 15:52:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sIYC053T-Agf; Thu, 29 Dec 2022 15:52:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A76C4B6F3;
	Thu, 29 Dec 2022 15:52:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5574B651
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 15:52:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wC+xl83lm3V9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Dec 2022 15:52:29 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6694B241
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 15:52:29 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1672347148;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DeG05ASAQvY/FceYSGJdKCGQ3OFwx25lz4jlpRPWbnU=;
 b=CyydvGwzPP3fLVYWpVliXmXQqCrkO5vFWqD2G/eF6WnvrzLE9bE4odPOFEByCJPXx1zK7N
 3CW4NLlm4xL0AqHnTqMhsk9cWBJ6Uuhsic1loBCpqEVeOVsFEOTwngBg+tn14ERoLM33Ac
 yUygSuFg7+aLVxGsIqRVpizKmEoGM14=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-2m9htd0_MBWumv-oVV0wdQ-1; Thu, 29 Dec 2022 15:52:27 -0500
X-MC-Unique: 2m9htd0_MBWumv-oVV0wdQ-1
Received: by mail-ej1-f70.google.com with SMTP id
 xj11-20020a170906db0b00b0077b6ecb23fcso13042674ejb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Dec 2022 12:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=DeG05ASAQvY/FceYSGJdKCGQ3OFwx25lz4jlpRPWbnU=;
 b=r4zg2nu+PaccwKF9zBfhH8Dk59EYF5NL7OULSLx2lkxg3ptBMofI5jxOoDQflZkInv
 FLQ+OSHCzbLHksU9v4kseJxKAeHMjLBwFgkAjNPT8+5dIGDjhS4750Afrb3/NC+TQY3b
 j5EGxxojNFsOx2heb9GSWNjX4tycVSM4f2IYOgLItLrHYg6urazvnb8om8KvR69sA+eX
 8vKXcC8lVVFqh6GAggw8WLUFb9XK9uYjnEdCBTpRoBQ7anNBQqJ6ffpa5ZUW3gzH7jFa
 SXT9JIPLzXhwqnUVMcRI1eCt6HZcR2iheh145hF1mYrq7H2su8g0ZAhOIV2ZRkjoMLQR
 9fSQ==
X-Gm-Message-State: AFqh2krUKsABxERv7EsnDTqwFEWtG3B6nGL4kGcXha72MM68u8D6YdXq
 mtTi0phkZfX8NQdGxJZJVghV0ugNokVTgmVWiPNKaXHSSqEwVkrxJ7NGQGwZcdl6AHKz8a68PlV
 8h4ROVj5Ovl3YQuyDaKNB8UUt
X-Received: by 2002:a17:907:6f09:b0:7c1:37:6d5e with SMTP id
 sy9-20020a1709076f0900b007c100376d5emr4872275ejc.2.1672347146330; 
 Thu, 29 Dec 2022 12:52:26 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuAZx8SHyajJmJ++QT23AGJAvs5IxosEfN11APvih7Pbj5KPIpkonmPHiwyMLfqMEbO8Dqn3Q==
X-Received: by 2002:a17:907:6f09:b0:7c1:37:6d5e with SMTP id
 sy9-20020a1709076f0900b007c100376d5emr4872244ejc.2.1672347146101; 
 Thu, 29 Dec 2022 12:52:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::529? ([2001:b07:6468:f312::529])
 by smtp.googlemail.com with ESMTPSA id
 23-20020a170906301700b0084c90164a56sm1096571ejz.29.2022.12.29.12.52.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 29 Dec 2022 12:52:25 -0800 (PST)
Message-ID: <4d73d1b9-2c28-ab6a-2963-579bcc7a9e67@redhat.com>
Date: Thu, 29 Dec 2022 21:52:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 00/50] KVM: Rework kvm_init() and hardware enabling
To: Marc Zyngier <maz@kernel.org>
References: <20221227130249.1650197-1-pbonzini@redhat.com>
 <9acea262dec3511e9cf63081506f0bd7@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9acea262dec3511e9cf63081506f0bd7@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>,
 Yuan Yao <yuan.yao@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Michael Ellerman <mpe@ellerman.id.au>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>
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

T24gMTIvMjgvMjIgMTI6MjIsIE1hcmMgWnluZ2llciB3cm90ZToKPiAKPj4gUXVldWVkLCB0aGFu
a3MuwqAgSSB3aWxsIGxlYXZlIHRoaXMgaW4ga3ZtL3F1ZXVlIGFmdGVyIHRlc3RpbmcgZXZlcnl0
aGluZwo+PiBlbHNlIGFuZCBtb3ZpbmcgaXQgdG8ga3ZtL25leHQ7IHRoaXMgd2F5LCB3ZSBjYW4g
d2FpdCBmb3IgdGVzdCByZXN1bHRzCj4+IG9uIG90aGVyIGFyY2hpdGVjdHVyZXMuCj4gCj4gQ2Fu
IHlvdSBwbGVhc2UgbWFrZSB0aGlzIGEgdG9waWMgYnJhbmNoLCBhbmQgaWYgcG9zc2libGUgYmFz
ZWQKPiBvbiBhIHJlbGVhc2VkIC1yYz8gSXQgd291bGQgbWFrZSBpdCBhIGxvdCBlYXNpZXIgZm9y
IGV2ZXJ5b25lLgoKVGhpcyBpcyBub3cgcmVmcy9oZWFkcy9rdm0taHctZW5hYmxlLXJlZmFjdG9y
IGluIApodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vdmlydC9rdm0va3ZtLmdpdC4KClRo
ZSBjb21taXRzIGZvciB0aGlzIHNlcmllcyBzdGFydCBhdCBoYXNoIGZjNDcxZTgzMTAxNi4KClBh
b2xvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
