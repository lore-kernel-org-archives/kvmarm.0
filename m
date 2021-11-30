Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC62C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 11:39:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A53F4B152;
	Tue, 30 Nov 2021 06:39:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CmvKGaHkoGaD; Tue, 30 Nov 2021 06:39:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A0754B150;
	Tue, 30 Nov 2021 06:39:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82BEA4B150
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 06:39:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2X1k1-Cb8aUt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Nov 2021 06:39:25 -0500 (EST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42F6E4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 06:39:25 -0500 (EST)
Received: by mail-ed1-f48.google.com with SMTP id e3so85496246edu.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 03:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:from:to:cc:references:in-reply-to
 :content-transfer-encoding;
 bh=yGHiGFZ+rE1fvnI8baTnrP2jm+L8strqrdJ5iul7hp0=;
 b=c6P0wlF3uxLM9zmSs2xQkvwdYDteITQrAo0DrsrznSF9sEOH28QP1fFa6xhItTgTpS
 KkU6+3vbY7zvYbaGplUg6NAOHI1i7wZaB3YsPHKiJwSv7fAraYSJOmBsIPcxDa1GRc0A
 PiiJWBQEcwSH6cUNsH7cKZjAdxgXOazBahtafC3Gs9rh9Srzhdp4SMH53zgHkiQE4Got
 FG3pFo/MwoBD/bEwOxiDmocGqSzd1aaMmn3Q9da/d+qNqxzu9ZAjjXwyK04+bd+g1kuu
 faXB8tkRVfsTXc+ZCCEjhbpUn7X9sEvfPMvPv6y6fB24K84rc8fMZl0EoSsfLlnsoaMi
 6+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:from:to:cc:references:in-reply-to
 :content-transfer-encoding;
 bh=yGHiGFZ+rE1fvnI8baTnrP2jm+L8strqrdJ5iul7hp0=;
 b=y7fNi0SGjancuMTqHc6wcV2o9adn5CcQMJQCp3KYEBXWfqqyFdg1O1O9k5YLcUy+Vk
 q2ST0R+uygtyLJPZ8TX4pKQluH4nQjrf2kukJ10cF0X21/DQGImc0WB1L/YnwFGcoY6Y
 7q6nG+mzcygF1k/KrHzqRLbnNUhG+wQ+FnGPJ5NP3/8wG+hnderg82EivDq6hbv/7zLr
 ChLmsLPfqaGaomG/42sItYAroRKYksSrSeydGtR1xfV2dAw2y3kq4D5/9ErOL4R0gUHP
 iFXt5jkZ+jE352Ogvpc7bTBk8aEo95Z33rCrWYcxeZOnzO4enq6FzwJdN1cLe9LhzoHl
 GvwQ==
X-Gm-Message-State: AOAM531/VKDrLN6CVPHd4QEESzYCmYE7LaXYbalsAJHwRfU5Bu7CLD7L
 3dQiHhX9S6CHLKtUtg2MAvM=
X-Google-Smtp-Source: ABdhPJzBmlKlxbZEZjGdZkld9KClqoQPE65iifbnAftOVfFURI+3gCywK4yL4F/szmL3PzOccPRpRg==
X-Received: by 2002:a17:906:6a1a:: with SMTP id
 qw26mr67292465ejc.489.1638272364301; 
 Tue, 30 Nov 2021 03:39:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id m22sm11049796eda.97.2021.11.30.03.39.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 30 Nov 2021 03:39:23 -0800 (PST)
Message-ID: <3490c50e-50d2-f906-3383-b87e14b14fab@redhat.com>
Date: Tue, 30 Nov 2021 12:39:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 10/43] KVM: arm64: Move vGIC v4 handling for WFI out
 arch callback hook
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
To: Marc Zyngier <maz@kernel.org>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-11-seanjc@google.com>
 <9236e715-c471-e1c8-6117-6f37b908a6bd@redhat.com>
 <875ytjbxpq.wl-maz@kernel.org>
 <be1cf8c7-ed87-b8eb-1bca-0a6c7505d7f8@redhat.com>
In-Reply-To: <be1cf8c7-ed87-b8eb-1bca-0a6c7505d7f8@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTAvMjYvMjEgMTg6MTIsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gT24gMjYvMTAvMjEgMTc6
NDEsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IFRoaXMgbmVlZHMgYSB3b3JkIG9uIHdoeSBrdm1f
cHNjaV92Y3B1X3N1c3BlbmQgZG9lcyBub3QgbmVlZCB0aGUKPj4+IGhvb2tzLsKgIE9yIGl0IG5l
ZWRzIHRvIGJlIGNoYW5nZWQgdG8gYWxzbyB1c2Uga3ZtX3ZjcHVfd2ZpIGluIHRoZSBQU0NJCj4+
PiBjb2RlLCBJIGRvbid0IGtub3cuCj4+Pgo+Pj4gTWFyYywgY2FuIHlvdSByZXZpZXcgYW5kL29y
IGFkdmlzZT8KPj4gSSB3YXMgbG9va2luZyBhdCB0aGF0IG92ZXIgdGhlIHdlZWtlbmQsIGFuZCB0
aGF0J3MgYSBwcmUtZXhpc3RpbmcKPj4gYnVnLiBJIHdvdWxkIGhhdmUgYWRkcmVzc2VkIGl0IGlu
ZGVwZW5kZW50bHksIGJ1dCBpdCBsb29rcyBsaWtlIHlvdQo+PiBhbHJlYWR5IGhhdmUgcXVldWVk
IHRoZSBwYXRjaC4KPiAKPiBJIGhhdmUgInF1ZXVlZCIgaXQsIGJ1dCB0aGF0J3MganVzdCBteSBx
dWV1ZSAtIGl0J3Mgbm90IG9uIGtlcm5lbC5vcmcgCj4gYW5kIGl0J3Mgbm90IGdvaW5nIHRvIGJl
IGluIDUuMTYsIGF0IGxlYXN0IG5vdCBpbiB0aGUgZmlyc3QgYmF0Y2guCj4gCj4gVGhlcmUncyBw
bGVudHkgb2YgdGltZSBmb3IgbWUgdG8gcmViYXNlIG9uIHRvcCBvZiBhIGZpeCwgaWYgeW91IHdh
bnQgdG8gCj4gc2VuZCB0aGUgZml4IHRocm91Z2ggeW91ciBrdm0tYXJtIHB1bGwgcmVxdWVzdC7C
oCBKdXN0IENjIG1lIHNvIHRoYXQgSSAKPiB1bmRlcnN0YW5kIHdoYXQncyBnb2luZyBvbi4KClNp
bmNlIGEgbW9udGggaGFzIHBhc3NlZCBhbmQgSSBkaWRuJ3Qgc2VlIGFueXRoaW5nIHJlbGF0ZWQg
aW4gdGhlIApLVk0tQVJNIHB1bGwgcmVxdWVzdHMsIEkgYW0gZ29pbmcgdG8gcXVldWUgdGhpcyBw
YXRjaC4gIEFueSBjb25mbGljdHMgCmNhbiBiZSByZXNvbHZlZCB0aHJvdWdoIGEga3ZtYXJtLT5r
dm0gbWVyZ2Ugb2YgZWl0aGVyIGEgdG9waWMgYnJhbmNoIG9yIAphIHRhZyB0aGF0IGlzIGRlc3Rp
bmVkIHRvIDUuMTYuCgpQYW9sbwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
