Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD11C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 28 Dec 2022 11:58:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0994D4B854;
	Wed, 28 Dec 2022 06:58:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oSneev+gx+at; Wed, 28 Dec 2022 06:58:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD414B86C;
	Wed, 28 Dec 2022 06:58:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23CA44B86A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Dec 2022 06:58:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DEupULiYDmBy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Dec 2022 06:58:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F1074B869
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Dec 2022 06:58:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1672228721;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KYdiyUW7v3jDVb1QwzZWNab9jTsMpMxmysun3BoXT8E=;
 b=BUmrbtzLHXKgoS2cqq0PXGvKWAC5e997bHYtEwEZOPPY6zk7DsT/+SPsXE6A6fPtiiXYhA
 uyHReXcNu9XqL42bARoWjCMgaenQqa8jNDHYzG9cijSu0VK/eSeq7ZmFHbXk8Cha1R6yly
 zEs0Zs6zSvzH6xkrIgVz+EL76A54CIw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-94-MunXUo80NU6viOqGn3we5w-1; Wed, 28 Dec 2022 06:58:39 -0500
X-MC-Unique: MunXUo80NU6viOqGn3we5w-1
Received: by mail-ej1-f71.google.com with SMTP id
 gn28-20020a1709070d1c00b007c177fee5faso10815541ejc.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Dec 2022 03:58:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=KYdiyUW7v3jDVb1QwzZWNab9jTsMpMxmysun3BoXT8E=;
 b=Tt27GSfUYvgssg8wx9yMMAJOuOdlo5QZMvK2Te5g9lWhe11nSnAcRN6kNZcFdrzJXr
 7r5d1YQ1znpL/EFqu6xTNClo1u/JuFraWp2wT+X0rYxXy/oueprZZxmW4NV0ZvVGLjkc
 iA41u9nbxsrVHHcMyiH9THru4x7YL0GtL4Oa1E08anC7kPpInqzo+phOhgvbWgMBQuOL
 wmr6oVWluDhPOoN44wKCrmQAR8yvsd8aR36hBZAwGR9OFhgvuIEmwb+DhiYudc+8RKzm
 Ik9aRRpcKh4kei3NCl5Ja0tqqb5F+gYhxAlHHBc8YiqvPsDZ2e4gFkjor/tGnEEoB529
 tQGQ==
X-Gm-Message-State: AFqh2kqRpV5bKkyATee8BA6RVtjPIpk5uf/fOUiWd2FhThaW8Je9n8nd
 dlktkgZanK2VhwbhguAm5a5ZCCMlUYGYhLAEvFaKjXZWDFYx0fDcapoqo9+Zp/0sX2FrlEbtzoV
 D6d21JijeyvOIOpV3h9b5bZlS
X-Received: by 2002:aa7:de15:0:b0:483:30d7:f9ac with SMTP id
 h21-20020aa7de15000000b0048330d7f9acmr12028249edv.19.1672228718684; 
 Wed, 28 Dec 2022 03:58:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtrIO5srJBbY8oizuyf5Q39Hr1tveD2PqIx/4KuqYlJNhV9zI7izo96N6ps5dxKil3bsWjXNA==
X-Received: by 2002:aa7:de15:0:b0:483:30d7:f9ac with SMTP id
 h21-20020aa7de15000000b0048330d7f9acmr12028204edv.19.1672228718422; 
 Wed, 28 Dec 2022 03:58:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.googlemail.com with ESMTPSA id
 h25-20020aa7de19000000b00463b9d47e1fsm7031261edv.71.2022.12.28.03.58.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 28 Dec 2022 03:58:37 -0800 (PST)
Message-ID: <55a31d67-b9d0-1a62-1c60-f86b48a34a8b@redhat.com>
Date: Wed, 28 Dec 2022 12:58:33 +0100
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
IGV2ZXJ5b25lLgoKWWVzLCBJIHdpbGwgKGl0IHdpbGwgYmUgYmFzZWQgb24gNi4yLXJjMSArIHB1
bGwgcmVxdWVzdCBmb3IgcmMyIHRoYXQgSSdtIApwcmVwYXJpbmcgKyB4ODYgY2hhbmdlcyB0aGF0
IHRoaXMgY29uZmxpY3RzIHdpdGgpLgoKUGFvbG8KCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
