Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3C3C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 02:00:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D2E54B230;
	Wed,  1 Dec 2021 21:00:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0qW++1VsW+Mn; Wed,  1 Dec 2021 21:00:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7404B1F3;
	Wed,  1 Dec 2021 21:00:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C07BE4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 21:00:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 007KfwfnKRYz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 21:00:09 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1AB0D4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 21:00:09 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id
 fv9-20020a17090b0e8900b001a6a5ab1392so3349973pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 18:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=ieez22Xn2l5HWg/32xD5LElmnAc6m+5OIzBSW88ykGA=;
 b=G0z4qsx02gTJpOX+id+WDt87iiCC68/pLc8/RHTHy93ZaRCC/cpz/VtsZ5QLq6NhsC
 pztYoE3cxmb1ab05i+mKIC8ML+IoYX2JvCedMYG/dA5g4rEg3w2gyuXKxfic5SWkfGb+
 LTzmn0ERm4vLCwinV2Q7f64T7CvStCYLOXGIoBC/JED1+H3JdUB9Rafl3aySZq2PFK+D
 j8FA4sR8WNSfp7GYg67MnxS2CunppQgmHJnEXulsOfQJjagvmDJOLOMmlhUfNCfaq2x+
 Msm/OAxbLxPfZ954U2c9p631E4TYd+VGgfnvhf+iALAZ45wlstnB6aDZPFFAYACiiRYn
 9c3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=ieez22Xn2l5HWg/32xD5LElmnAc6m+5OIzBSW88ykGA=;
 b=kqrDEgbenzcyD4NgXygLiBBYnWl17P5X+KFGkzBqyJCm7hzWax2bo8CPBAaURySxL4
 Ci61PdL+ejQ8fKp7pmAq52ICSNIl052gC5iCdqNd5ylEsZ6sxIaK59+mJgP02PxdC4or
 /2bJNm+iENLFo4TihlSOBqZiFmFH6I9hnt6ZEQWlmU8vJ7xAAUwYdfBg8Ltze56m0tsF
 md278BWPuaOB3oySMRcdknrZkQf/Mw62JE86+xzM5KY/ExQoTy9xy7ztde+RCNsiaUz+
 6ltNX0Dmr9AF0+gh1CEyoQpg5qEEzs/rskj9QwR82dydqdSyyDoG2uLZa85Sdl366U6d
 KBBQ==
X-Gm-Message-State: AOAM5331J1Ii9su/2ydPl315vQaEetTjQmYaCPyOxJ/M31vt2C5t0lSw
 nzlQv+OJWFUv18MVzlAM0QA/1Q==
X-Google-Smtp-Source: ABdhPJxNBM72YGsKSZuE+5oJQdw89IebyEem9LDSzk1Pcg1GjafGCYFG2d6Z2Cymjn7sJ6Jwu52nlQ==
X-Received: by 2002:a17:90b:3848:: with SMTP id
 nl8mr2408510pjb.221.1638410408016; 
 Wed, 01 Dec 2021 18:00:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id lr6sm550689pjb.0.2021.12.01.18.00.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Dec 2021 18:00:07 -0800 (PST)
Date: Thu, 2 Dec 2021 02:00:03 +0000
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Message-ID: <Yagoo7R8P5xVilsj@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-12-seanjc@google.com>
 <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
 <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
 <YaUNBfJh35WXMV0M@google.com>
 <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
 <YaUiEquKYi5eqWC0@google.com>
 <880a5727-69d1-72a1-b129-b053781625ad@redhat.com>
 <458c0819a578ba854f00089bc312c8faa177a81a.camel@redhat.com>
 <32eabe7d270e5a466ba2d9345b4270b8fe27700c.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <32eabe7d270e5a466ba2d9345b4270b8fe27700c.camel@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Wei Huang <wei.huang2@amd.com>,
 kvm-ppc@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Anup Patel <anup.patel@wdc.com>,
 linux-mips@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gVGh1LCBEZWMgMDIsIDIwMjEsIE1heGltIExldml0c2t5IHdyb3RlOgo+IE9uIFR1ZSwgMjAy
MS0xMS0zMCBhdCAwMDo1MyArMDIwMCwgTWF4aW0gTGV2aXRza3kgd3JvdGU6Cj4gPiBPbiBNb24s
IDIwMjEtMTEtMjkgYXQgMjA6MTggKzAxMDAsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4gPiBCYXNp
Y2FsbHkgd2hhdCBJIHNlZSB0aGF0Cj4gPiAgCj4gPiAxLiB2Q1BVMiBkaXNhYmxlcyBpc19ydW5u
aW5nIGluIGF2aWMgcGh5c2ljYWwgaWQgY2FjaGUKPiA+IDIuIHZDUFUyIGNoZWNrcyB0aGF0IElS
UiBpcyBlbXB0eSBhbmQgaXQgaXMKPiA+IDMuIHZDUFUyIGRvZXMgc2NoZWR1bGUoKTsKPiA+ICAK
PiA+IGFuZCBpdCBrZWVwcyBvbiBzbGVlcGluZyBmb3JldmVyLiBJZiBJIGtpY2sgaXQgdmlhIHNp
Z25hbCAKPiA+IChsaWtlIGp1c3QgZG9pbmcgJ2luZm8gcmVnaXN0ZXJzJyBxZW11IGhtcCBjb21t
YW5kCj4gPiBvciBqdXN0IHN0b3AvY29udCBvbiB0aGUgc2FtZSBobXAgaW50ZXJmYWNlLCB0aGUK
PiA+IHZDUFUgd2FrZXMgdXAgYW5kIG5vdGljZXMgdGhhdCBJUlIgc3VkZGVubHkgaXMgbm90IGVt
cHR5LAo+ID4gYW5kIHRoZSBWTSBjb21lcyBiYWNrIHRvIGxpZmUgKGFuZCB0aGVuIGhhbmdzIGFm
dGVyIGEgd2hpbGUgYWdhaW4KPiA+IHdpdGggdGhlIHNhbWUgcHJvYmxlbS4uLi4pLgo+ID4gIAo+
ID4gQXMgZmFyIGFzIEkgc2VlIGluIHRoZSB0cmFjZXMsIHRoZSBiaXQgaW4gSVJSIGNhbWUgZnJv
bQo+ID4gYW5vdGhlciBWQ1BVIHdobyBkaWRuJ3QgcmVzcGVjdCB0aGUgaXJfcnVubmluZyBiaXQg
YW5kIGRpZG4ndCBnZXQgCj4gPiBBVklDX0lOQ09NUExFVEVfSVBJIFZNZXhpdC4KPiA+IEkgY2Fu
J3QgMTAwJSBwcm92ZSBpdCB5ZXQsIGJ1dCBldmVyeXRoaW5nIGluIHRoZSB0cmFjZSBzaG93cyB0
aGlzLgoKLi4uCgo+IEkgYW0gbm93IGFsbW9zdCBzdXJlIHRoYXQgdGhpcyBpcyBlcnJhdGEgIzEy
MzUuCj4gCj4gSSBoYWQgYXR0YWNoZWQgYSBrdm0tdW5pdC10ZXN0IEkgd3JvdGUgKHBhdGNoIGFn
YWluc3QgbWFzdGVyIG9mCj4gaHR0cHM6Ly9naXRsYWIuY29tL2t2bS11bml0LXRlc3RzL2t2bS11
bml0LXRlc3RzLmdpdC8pIHdoaWNoIGlzIGFibGUgdG8KPiByZXByb2R1Y2UgdGhlIGlzc3VlIG9u
IHN0b2NrIDUuMTUuMCBrZXJuZWwgKCpubyBwYXRjaGVzIGFwcGxpZWQgYXQgYWxsKikKPiBhZnRl
ciBqdXN0IGZldyBzZWNvbmRzLiAgSWYga3ZtIGlzIGxvYWRlZCB3aXRob3V0IGhhbHQtcG9sbGlu
ZyAodGhhdCBpcwo+IGhhbHRfcG9sbF9ucz0wIGlzIHVzZWQpLgo+IAo+IEhhbHQgcG9sbGluZyBh
bmQvb3IgU2VhbidzIHBhdGNoIGFyZSBub3QgdG8gYmxhbWUsIGl0IGp1c3QgY2hhbmdlcyB0aW1l
aW5nLgo+IFdpdGggU2VhbidzIHBhdGNoIEkgZG9uJ3QgbmVlZCB0byBkaXNhYmxlIGhhbGYgcG9s
bGluZy4KCkhtbSwgdGhhdCBzdWdnZXN0cyB0aGUgYnVnL2VycmF0dW0gaXMgZHVlIHRvIHRoZSBD
UFUgY29uc3VtaW5nIHN0YWxlIGRhdGEgZnJvbSAjNApmb3IgdGhlIElzUnVubmluZyBjaGVjayBp
biAjNSwgb3IgcmV0aXJpbmcgdW9wcyBmb3IgdGhlIElzUnVubmluZyBjaGVjayBiZWZvcmUKcmV0
aXJpbmcgdGhlIHZJUlIgdXBkYXRlLiAgSXQgd291bGQgYmUgaGVscGZ1bCBpZiB0aGUgZXJyYXR1
bSBhY3R1YWxseSBwcm92aWRlZAppbmZvIG9uIHRoZSAiaGlnaGx5IHNwZWNpZmljIGFuZCBkZXRh
aWxlZCBzZXQgb2YgaW50ZXJuYWwgdGltaW5nIGNvbmRpdGlvbnMiLiA6LS8KCiAgNC4gTG9va3Vw
IHRoZSB2QVBJQyBiYWNraW5nIHBhZ2UgYWRkcmVzcyBpbiB0aGUgUGh5c2ljYWwgQVBJQyB0YWJs
ZSB1c2luZyB0aGUKICAgICBndWVzdCBwaHlzaWNhbCBBUElDIElEIGFzIGFuIGluZGV4IGludG8g
dGhlIHRhYmxlLgogIDUuIEZvciBldmVyeSB2YWxpZCBkZXN0aW5hdGlvbjoKICAgICAtIEF0b21p
Y2FsbHkgc2V0IHRoZSBhcHByb3ByaWF0ZSBJUlIgYml0IGluIGVhY2ggb2YgdGhlIGRlc3RpbmF0
aW9uc+KAmSB2QVBJQwogICAgICAgYmFja2luZyBwYWdlLgogICAgIC0gQ2hlY2sgdGhlIElzUnVu
bmluZyBzdGF0dXMgb2YgZWFjaCBkZXN0aW5hdGlvbi4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
