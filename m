Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9428AC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 18:34:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 354114B10E;
	Thu,  9 Dec 2021 13:34:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ln2cucWMy9zm; Thu,  9 Dec 2021 13:34:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB2A4B10B;
	Thu,  9 Dec 2021 13:34:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1160C4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 13:34:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 170yk64lo6VQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 13:34:51 -0500 (EST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com
 [209.85.208.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF4704B0E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 13:34:50 -0500 (EST)
Received: by mail-ed1-f53.google.com with SMTP id x10so5152013edd.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Dec 2021 10:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=+zI/uY0HbhRQxbU0uDHdKiysuc/BimXIFXVd1mgbhUs=;
 b=c3ECy+yxCV+HPacayaTpJOgHPIHwef7ZJNvYQDpgYKf18CpWjfUTkVnWfQqn++/o10
 Fp3Xr36EmfHMBSPk84IPd5g4Yhe/gP5KzzIrO4F3p/AkP2/qm7MeQNy8eyZNAuLL5h/P
 fJOWgXvFlGIzamG9sRPW0HwPhw7FfV4qYg/m4VTx5oE8rSaKk16KDX0fWUkgcqKre3A2
 MmQshaP3JXfmbO4cXh5eNC1IEkpEJlGUeBn7FF9dRJKU/FVOwnzUIlt1sUli0icW5LsR
 3Vbgd+KFeP+zI91Omkntwb3DYSkKK7IBWJYW2omwyqo0LZhG74wb+VUPnNC36+FfsfG0
 tS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=+zI/uY0HbhRQxbU0uDHdKiysuc/BimXIFXVd1mgbhUs=;
 b=PkjIOcJbK4M5UPAlqGhX/L94Fd78AEws4CPed3+3fNpBxUL+7ylWd+tlG2hV7Eb+rB
 cjLhSV2cxmhFVyBati/f0wcugC7C+02jdmWNT1MdQ6/1ptJJCd7JAGUhBCfK8Wmgui/L
 eQ2+9Gb2NRUgveo9FDaagggkoXJk7QpIhiyGGMt4g4UjTimeoo9hH3dGRZeblyf3AXPQ
 qxcOrcr5tPByrFB/FZYA+tyQhxANHFXS2jAKc8Ynp8r84e9CzGrLSgo+VNLipuLBnb2r
 e//2FIFf7c/Lzu+ikcXW2Cs0oIZ6sE5BFmhAsNkIB5b0N4f8qBxnB6lQDdMQys2ShTpm
 okfw==
X-Gm-Message-State: AOAM5332ZetxMwGR6kXrTuvwXPsngCWoRvwkHBiuM/XJSxpIV4AC8Q6Q
 oiyXdwsjt0k1tuBfmDnzcv8=
X-Google-Smtp-Source: ABdhPJyzZnV4yIOIpx1yw9gOS9Nnuyioy0GPnW+twuf6B+q2BDrnhU8giByTdwbtnr3yemfopJ87vw==
X-Received: by 2002:a17:906:938f:: with SMTP id
 l15mr17905624ejx.302.1639074889734; 
 Thu, 09 Dec 2021 10:34:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id k16sm260233edq.77.2021.12.09.10.34.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Dec 2021 10:34:49 -0800 (PST)
Message-ID: <2617aea0-af09-5c0d-1fd7-65e2a814b516@redhat.com>
Date: Thu, 9 Dec 2021 19:34:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 00/12] KVM: x86/xen: Add in-kernel Xen event channel
 delivery
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211121125451.9489-1-dwmw2@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTEvMjEvMjEgMTM6NTQsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiBJbnRyb2R1Y2UgdGhl
IGJhc2ljIGNvbmNlcHQgb2YgMiBsZXZlbCBldmVudCBjaGFubmVscyBmb3Iga2VybmVsIGRlbGl2
ZXJ5LAo+IHdoaWNoIGlzIGp1c3QgYSBzaW1wbGUgbWF0dGVyIG9mIGEgZmV3IHRlc3RfYW5kX3Nl
dF9iaXQgY2FsbHMgb24gYSBtYXBwZWQKPiBzaGFyZWQgaW5mbyBwYWdlLgo+IAo+IFRoaXMgY2Fu
IGJlIHVzZWQgZm9yIHJvdXRpbmcgTVNJIG9mIHBhc3N0aHJvdWdoIGRldmljZXMgdG8gUElSUSBl
dmVudAo+IGNoYW5uZWxzIGluIGEgWGVuIGd1ZXN0LCBhbmQgd2UgY2FuIGJ1aWxkIG9uIGl0IGZv
ciBkZWxpdmVyaW5nIElQSXMgYW5kCj4gdGltZXJzIGRpcmVjdGx5IGZyb20gdGhlIGtlcm5lbCB0
b28uCj4gCj4gdjE6IFVzZSBrdm1fbWFwX2dmbigpIGFsdGhvdWdoIEkgZGlkbid0IHF1aXRlIHNl
ZSBob3cgaXQgd29ya3MuCj4gCj4gdjI6IEF2b2lkIGt2bV9tYXBfZ2ZuKCkgYW5kIGltcGxlbWVu
dCBhIHNhZmUgbWFwcGluZyB3aXRoIGludmFsaWRhdGlvbgo+ICAgICAgc3VwcG9ydCBmb3IgbXlz
ZWxmLgo+IAo+IHYzOiBSZWludmVudCBnZm5fdG9fcGZuX2NhY2hlIHdpdGggc2FuZSBpbnZhbGlk
YXRpb24gc2VtYW50aWNzLCBmb3IgbXkKPiAgICAgIHVzZSBjYXNlIGFzIHdlbGwgYXMgbmVzdGlu
Zy4KPiAKPiB2NDogUmV3b3JrIGRpcnR5IGhhbmRsaW5nLCBhcyBpdCBiZWNhbWUgYXBwYXJlbnRs
eSB0aGF0IHdlIG5lZWQgYW4gYWN0aXZlCj4gICAgICB2Q1BVIGNvbnRleHQgdG8gbWFyayBwYWdl
cyBkaXJ0eSBzbyBpdCBjYW4ndCBiZSBkb25lIGZyb20gdGhlIE1NVQo+ICAgICAgbm90aWZpZXIg
ZHVpbmcgdGhlIGludmFsaWRhdGlvbjsgaXQgaGFzIHRvIGhhcHBlbiBvbiB1bm1hcC4KPiAKPiB2
NTogRml4IHNwYXJzZSB3YXJuaW5ncyByZXBvcnRlZCBieSBrZXJuZWwgdGVzdCByb2JvdDxsa3BA
aW50ZWwuY29tPi4KPiAKPiAgICAgIEZpeCByZXZhbGlkYXRpb24gd2hlbiBtZW1zbG90cyBjaGFu
Z2UgYnV0IHRoZSByZXN1bHRpbmcgSFZBIHN0YXlzCj4gICAgICB0aGUgc2FtZS4gV2UgY2FuIHVz
ZSB0aGUgc2FtZSBrZXJuZWwgbWFwcGluZyBpbiB0aGF0IGNhc2UsIGlmIHRoZQo+ICAgICAgSFZB
IOKGkiBQRk4gdHJhbnNsYXRpb24gd2FzIHZhbGlkIGJlZm9yZS4gU28gdGhhdCBwcm9iYWJseSBt
ZWFucyB3ZQo+ICAgICAgc2hvdWxkbid0IHVubWFwIHRoZSAib2xkX2h2YSIuIEF1Z21lbnQgdGhl
IHRlc3QgY2FzZSB0byBleGVyY2lzZQo+ICAgICAgdGhhdCBvbmUgdG9vLgo+IAo+ICAgICAgSW5j
bHVkZSB0aGUgZml4IGZvciB0aGUgZGlydHkgcmluZyB2cy4gWGVuIHNoaW5mbyBvb3BzIHJlcG9y
dGVkCj4gICAgICBieSBidXR0M3JmbHloNGNrPGJ1dHRlcmZseWh1YW5neHhAZ21haWwuY29tPi4K
PiAKPiAKPiBBcyBpbiB0aGUgcHJldmlvdXMgdHdvIHJvdW5kcywgdGhlIGxhc3QgcGF0Y2ggKHRo
aXMgdGltZSBwYXRjaCAxMikgaXMKPiBpbmNsdWRlZCBhcyBpbGx1c3RyYXRpb24gb2YgaG93IHdl
Km1pZ2h0KiAgdXNlIHRoaXMgZm9yIGZpeGluZyB0aGUgVUFGCj4gYnVncyBpbiBuZXN0aW5nLCBi
dXQgaXNuJ3QgaW50ZW5kZWQgdG8gYmUgYXBwbGllZCBhcy1pcy4gUGF0Y2hlcyAxLTExIGFyZS4K
ClF1ZXVlZCAxLTcsIHdpbGwgYmUgb24ga3ZtL25leHQgdG9tb3Jyb3cgdGhvdWdoLgoKUGFvbG8K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
