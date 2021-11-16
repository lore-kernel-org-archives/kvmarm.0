Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0F2C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 18:44:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C060C61872
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 18:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C060C61872
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EA9E4B0BE;
	Tue, 16 Nov 2021 13:44:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5I5aiz4NjONz; Tue, 16 Nov 2021 13:44:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01B3E4B0CE;
	Tue, 16 Nov 2021 13:44:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 649FD4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 13:44:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wowuu3Zi7ieU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 13:43:58 -0500 (EST)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4BFC4A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 13:43:58 -0500 (EST)
Received: by mail-pj1-f44.google.com with SMTP id
 nh10-20020a17090b364a00b001a69adad5ebso231486pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 10:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=GcGOJgSWz7oEIbfl5QNUvPpuAyaNetXEQN0oWs9ap2w=;
 b=NfWEHKgpp9hvAVj4IrdvyWcutj+oRm5oA4DhrzE5j01yRw6SEr+OqI8zdgqPehlHuc
 lvLy/whsET41Ju6UmVvOInCo7Ww6t6yLH5qUrncwy6VAmxauCnt99O3r1yirLCVccCfN
 0Gay6uTBhe2zfp68q3FXHdSVfO1Z/lBlR6uw3b9mZM9XbPEBfKBoCa/a9sEvB1P9oZqk
 5YTcHvsnOOA5rsa3JP9041e/6BOvKA/Xr3X/sbaLIuC63lGrovFZ7b1eudI5InxTZkUr
 CdOzfVuUVUCDHbMPcWrZAb1YNJexcHENRayQEJiryVfwYQQPdJtpV9LDoK9LoF2MR12X
 8enQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=GcGOJgSWz7oEIbfl5QNUvPpuAyaNetXEQN0oWs9ap2w=;
 b=nt764L3lP31tAb2cfYxr5eVZ35uMRu5aWLxpnZHPH+DPS6pUKJyXxtFfMiWy0VWnue
 VgCW1Oj5+7hfIjmsBYIc9rJ9raHTLP23hUgLSn8jWRC9nspzpKVo3DHsans9Rj7YgVWm
 1NZUmP4BwKQA1UGDHvYulr+6Kndj+NtwRTSrqPaGUi4tGfFPipdEBwBqXrgBs8+f6CBR
 owB4ArN/tb2psmtMLcRgYAtM8CcGo/vcL2YwViX9kJJYPM1WX18w8MB10SNS611LLdBY
 kkM90VLkHgJaUJ1o7HUymj3hLeeyzRsjU1qEH0SK9OH35UOPO902Of9LJMIh1O6ab0/f
 RCig==
X-Gm-Message-State: AOAM533zZQGrBg5AF4mSqsfp5cjzA5TPh6sDS+sahd9LlbXGA8mBBi4k
 ejkSmh5ibgHL4GJPDwBR25e6vQ==
X-Google-Smtp-Source: ABdhPJy95F12FbARJJuG3RP+KItNypekR2/l+xifaD1kKSsYtJFW/+wQ/332xG0BY0Bxhx2ISOUtlQ==
X-Received: by 2002:a17:90b:4b46:: with SMTP id
 mi6mr1449604pjb.188.1637088237573; 
 Tue, 16 Nov 2021 10:43:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id r8sm15237754pgp.30.2021.11.16.10.43.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 16 Nov 2021 10:43:56 -0800 (PST)
Date: Tue, 16 Nov 2021 18:43:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 6/7] KVM: powerpc: Use Makefile.kvm for common files
Message-ID: <YZP76Un0mip17E1K@google.com>
References: <5047c2591310e503491850ef683f251395247d50.camel@infradead.org>
 <20211116115051.119956-1-dwmw2@infradead.org>
 <20211116115051.119956-6-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211116115051.119956-6-dwmw2@infradead.org>
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

T24gVHVlLCBOb3YgMTYsIDIwMjEsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiBGcm9tOiBEYXZp
ZCBXb29kaG91c2UgPGR3bXdAYW1hem9uLmNvLnVrPgo+IAo+IEl0J3MgYWxsIGZhaXJseSBiYXJv
cXVlIGJ1dCBpbiB0aGUgZW5kLCBJIGRvbid0IHRoaW5rIHRoZXJlJ3MgYW55IHJlYXNvbgo+IGZv
ciAkKEtWTSkvaXJxY2hpcC5vIHRvIGhhdmUgYmVlbiBoYW5kbGVkIGRpZmZlcmVudGx5LCBhcyB0
aGV5IGFsbCBlbmQKPiB1cCBpbiAkKGt2bS15KSBpbiB0aGUgZW5kIGFueXdheSwgcmVnYXJkbGVz
cyBvZiB3aGV0aGVyIHRoZXkgZ2V0IHRoZXJlCj4gdmlhICQoY29tbW9uLW9ianMteSkgYW5kIHRo
ZSBDUFUtc3BlY2lmaWMgb2JqZWN0IGxpc3RzLgo+IAo+IFRoZSBnZW5lcmljIE1ha2VmaWxlLmt2
bSB1c2VzIEhBVkVfS1ZNX0lSUUNISVAgZm9yIGlycWNoaXAubyBpbnN0ZWFkIG9mCj4gSEFWRV9L
Vk1fSVJRX1JPVVRJTkcuIFRoYXQgY2hhbmdlIGlzIGZpbmUgKGFuZCBhcmd1YWJseSBjb3JyZWN0
KSBiZWNhdXNlCj4gdGhleSBhcmUgYm90aCBzZXQgdG9nZXRoZXIgZm9yIEtWTV9NUElDLCBvciBu
ZWl0aGVyIGlzIHNldC4KCk5vcGUuCgogIFN5bWJvbDogSEFWRV9LVk1fSVJRQ0hJUCBbPXldCiAg
VHlwZSAgOiBib29sCiAgRGVmaW5lZCBhdCB2aXJ0L2t2bS9LY29uZmlnOjcKICBTZWxlY3RlZCBi
eSBbbV06CiAgICAtIEtWTV9YSUNTIFs9eV0gJiYgVklSVFVBTElaQVRJT04gWz15XSAmJiBLVk1f
Qk9PSzNTXzY0IFs9bV0gJiYgIUtWTV9NUElDIFs9bl0KICBTZWxlY3RlZCBieSBbbl06CiAgICAt
IEtWTV9NUElDIFs9bl0gJiYgVklSVFVBTElaQVRJT04gWz15XSAmJiBLVk0gWz15XSAmJiBFNTAw
IFs9bl0KCmxlYWRzIHRvIHRoaXMgYW5kIGEgd2hvbGUgcGlsZSBvZiBvdGhlciBlcnJvcnMKCmFy
Y2gvcG93ZXJwYy9rdm0vLi4vLi4vLi4vdmlydC9rdm0vaXJxY2hpcC5jOiBJbiBmdW5jdGlvbiDi
gJhrdm1faXJxX21hcF9nc2nigJk6CmFyY2gvcG93ZXJwYy9rdm0vLi4vLi4vLi4vdmlydC9rdm0v
aXJxY2hpcC5jOjMxOjM1OiBlcnJvcjogaW52YWxpZCB1c2Ugb2YgdW5kZWZpbmVkIHR5cGUg4oCY
c3RydWN0IGt2bV9pcnFfcm91dGluZ190YWJsZeKAmQogICAzMSB8ICAgICAgICAgaWYgKGlycV9y
dCAmJiBnc2kgPCBpcnFfcnQtPm5yX3J0X2VudHJpZXMpIHsKICAgICAgfCAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXn4KCgpTaWRlIHRvcGljLCBwbGVhc2UgZG9uJ3QgcG9zdCBh
IG5ldyB2ZXJzaW9uL3NlcmllcyBpbi1yZXBseS10byBhIGRpZmZlcmVudCBzZXJpZXMuCmI0IGFs
c28gZ2V0cyBjb25mdXNlZCBpbiB0aGlzIGNhc2UsIGUuZy4gaXQgdHJpZWQgdG8gZ3JhYiB0aGUg
b3JpZ2luYWwgcGF0Y2guICBiNApoYXMgYWxzbyBtYWRlIG1lIHJlYWxseSBsYXp5LCBoZWF2ZW4g
Zm9yYmlkIEkgYWN0dWFsbHkgaGFkIHRvIG1hbnVhbGx5IGdyYWIgdGhlc2UKZnJvbSBtdXR0IDot
KQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
