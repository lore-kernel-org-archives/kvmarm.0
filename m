Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81ACC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:51:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29C6761AFF
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 29C6761AFF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADCCB4B1A9;
	Thu, 18 Nov 2021 13:51:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U9eGY7unZHji; Thu, 18 Nov 2021 13:51:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA96D4B1B0;
	Thu, 18 Nov 2021 13:51:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2B6E4B1AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:51:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VlbzOgngFkcq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 13:51:00 -0500 (EST)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C59494B19D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:51:00 -0500 (EST)
Received: by mail-pg1-f172.google.com with SMTP id r132so6209192pgr.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 10:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=zAr8G8m6HwrPqqoGdIArvc5MN7TTOd03aeCBtzrDy6c=;
 b=rbZpSNPBshLLEgA/oYmPUPBbBkHwOg37klgFkMWXqRk+AzrmyZ/M8ccKC2y8hmj5XX
 PLpPwnUPPnPUTd02kdHoVA+HzFD/83CjjC3Xbl8iUzGpDaC5IgVnhNZp/tysG3KqErGy
 5NHK+nazoYp2JBbWoBCcZ90G56QCBVHGDC2bRvtFDuQptjhoIwkzkNewqtOfKXf5uclO
 DhLKIN93hjB32b8vl6mql00pPTkF1CnjBXdgyjfBHRSJU7IHYoN8ZQlZWFAH1r/9oUd0
 jnvQBNIOdWFfAc3UrHP8NU5X0ygb/qQXibVUtpmNCElsCb3HlLNAGjLYo0jNbS4Fc47o
 oIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=zAr8G8m6HwrPqqoGdIArvc5MN7TTOd03aeCBtzrDy6c=;
 b=X1vXINvksYy1VIEXZvZ78nPu5JO7YRiYSMT9YAe96wfoTm8uZBlBZkhMn5iOxlGRSO
 +IkUwx1/uAtHsx/apOuIMeTqcgsFkwOD3LLFEYCN9jOyfHuGGIA1RaJGGDDG56Uhq5Py
 ejRZe818LkCBo1mRzENSeXir7JXfi2/S06UEZ9aAjefigozaKacDhKpROJY9M256/gJL
 13opezZNneGCRZgj25avhdf5WXX5PTjqf0/aPq01N0Nwcttii8b4R2HbIekbhLEdjJ+5
 fcZjEZix0AXwhUkSJ7WWuDpuHf+ftfljlP5OZh2pPKgIIZy7yNr4F/b+SnBcZwMSCCeS
 +XRw==
X-Gm-Message-State: AOAM5323WyqBWaU0Z+T9c29RaWHUNHQ39FkeowCUWq3nehvkYHTb2iMJ
 OWbX2CD/hAZu3UCJx2tCQ8Bbmw==
X-Google-Smtp-Source: ABdhPJwrEgdsIYmbNbF+vA4sWC6GNXtBMPWh0SewfV4Te7mVM91SE0D0KPe2RQ2SZU3Fb1o23V6Nkg==
X-Received: by 2002:a05:6a00:b49:b0:49f:bad2:bd7c with SMTP id
 p9-20020a056a000b4900b0049fbad2bd7cmr58136547pfo.64.1637261459650; 
 Thu, 18 Nov 2021 10:50:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id y18sm306696pgh.18.2021.11.18.10.50.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 10:50:59 -0800 (PST)
Date: Thu, 18 Nov 2021 18:50:55 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3 08/12] KVM: Propagate vcpu explicitly to
 mark_page_dirty_in_slot()
Message-ID: <YZagjzYUsixbFre9@google.com>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org>
 <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
 <4c48546b-eb4a-dff7-cc38-5df54f73f5d4@redhat.com>
 <20b5952e76c54a3a5dfe5a898e3b835404ac6fb1.camel@infradead.org>
 <YZaeL5YztL3p1nLM@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YZaeL5YztL3p1nLM@google.com>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

T24gVGh1LCBOb3YgMTgsIDIwMjEsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6Cj4gT24gVGh1
LCBOb3YgMTgsIDIwMjEsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiA+IFRoYXQgbGVhdmVzIHRo
ZSBvbmUgaW4gVERQIE1NVSBoYW5kbGVfY2hhbmdlZF9zcHRlX2RpcnR5X2xvZygpIHdoaWNoCj4g
PiBBRkFJQ1QgY2FuIHRyaWdnZXIgdGhlIHNhbWUgY3Jhc2ggc2VlbiBieSBidXR0M3JmbHloNGNr
IOKAlCBjYW4ndCB0aGF0Cj4gPiBoYXBwZW4gZnJvbSBhIHRocmVhZCB3aGVyZSBrdm1fZ2V0X3J1
bm5pbmdfdmNwdSgpIGlzIE5VTEwgdG9vPyBGb3IgdGhhdAo+ID4gb25lIEknbSBub3Qgc3VyZS4K
PiAKPiBJIHRoaW5rIGNvdWxkIGJlIHRyaWdnZXIgaW4gdGhlIFREUCBNTVUgdmlhIGt2bV9tbXVf
bm90aWZpZXJfcmVsZWFzZSgpCj4gLT4ga3ZtX21tdV96YXBfYWxsKCksIGUuZy4gaWYgdGhlIHVz
ZXJzcGFjZSBWTU0gZXhpdHMgd2hpbGUgZGlydHkgbG9nZ2luZyBpcwo+IGVuYWJsZWQuICBUaGF0
IHNob3VsZCBiZSBlYXN5IHRvIChkaXMpcHJvdmUgdmlhIGEgc2VsZnRlc3QuCgpTY3JhdGNoIHRo
YXQsIHRoZSBkaXJ0eSBsb2cgdXBkYXRlIGlzIGd1YXJkZWQgYnkgdGhlIG5ld19zcHRlIGJlaW5n
IHByZXNlbnQsIHNvCnphcHBpbmcgb2YgYW55IGtpbmQgd29uJ3QgdHJpZ2dlciBpdC4KCkN1cnJl
bnRseSwgSSBiZWxpZXZlIHRoZSBvbmx5IHBhdGggdGhhdCB3b3VsZCBjcmVhdGUgYSBwcmVzZW50
IFNQVEUgd2l0aG91dCBhbgphY3RpdmUgdkNQVSBpcyBtbXVfbm90aWZlci5jaGFuZ2VfcHRlLCBi
dXQgdGhhdCBzcXVlYWtzIGJ5IGJlY2F1c2UgaXRzIHJlcXVpcmVkCnRvIGJlIHdyYXBwZWQgd2l0
aCBpbnZhbGlkYXRlX3JhbmdlX3tzdGFydCxlbmR9KE1NVV9OT1RJRllfQ0xFQVIpLCBhbmQgS1ZN
IHphcHMKaW4gdGhhdCBzaXR1YXRpb24uCgpCZW4ncyBzZXJpZXMgdG8gcHJvbW90ZSBwYWdlcyBv
biBkaXNhYmxpbmcgb2YgZGlydHkgbG9nZ2luZyB3aWxsIGFsc28gc3FldWFrIGJ5CmJlY2F1c2Ug
ZGlydHkgbG9nZ2luZyBpcyBvYnZpb3VzbHkgZGlzYWJsZWQuCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
