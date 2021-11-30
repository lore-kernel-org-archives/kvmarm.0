Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF893C4321E
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 16:07:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14EF84B1AB;
	Tue, 30 Nov 2021 11:07:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lubUh9BkPrdp; Tue, 30 Nov 2021 11:07:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C56A24B1B3;
	Tue, 30 Nov 2021 11:07:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6242C4B13D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 11:07:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8dRgdqI9YoEn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Nov 2021 11:07:49 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB4D94B137
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 11:07:48 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id
 i8-20020a7bc948000000b0030db7b70b6bso19935698wml.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 08:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=3a/iKsjufsiAbrGQuBxVCPIZkwax7Upszpd7LsuYfCk=;
 b=ZI1KOydZ+qECl1hqlo+ZNsiRXNRPZ13T8K4/YJ6MoYcN5dN+LuRV3/IQ1KEUDcU0Vw
 Vjwuujw+ZbUsGVxN5Eebh9Z/n26MQhlQ8ehFqn4X/Hvewkjsw0COQl31001ZyKeNY6Mz
 nuTJWwgKAs8576y3o//cH27vL1awmnJNNBybZbxu9KQow1/gfFg/9iui3rvWtw7fesoJ
 uB58hek4VV+WXZz0jg3T4XAAPkiLiwUG82CWXZnawo+wiwrKp8M/XU1sqUquvCA81ibB
 cUgcgGRDa/rJerB9C4tYdPDW2u0xS9fOOZeboK+o+lFF3SNVDw/1NfjIHFtj7/tD9ggY
 AZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=3a/iKsjufsiAbrGQuBxVCPIZkwax7Upszpd7LsuYfCk=;
 b=g5UFAWYnfJkdErJZjj7/1EJShEgR8ncy1sFfS78t0LHcoZYpF9ubarnSv0NM/dMm2o
 58NWNoNw+WEwVppQurp2yLissgvk+Q7woo5lpiAJaqiDvKHY9Uu+r3Sztk0/dCz6XbDV
 IVwvGp2DXHDsoTsM0m4kMsvSVVZnZEI/eMUjMSi04w9XQGyEs3cbHCARo6WpzPvjH3vJ
 uqLRAMYRkrNajFsRH5ww9ausxPu1BN5MOzauYEhejMYU4GEDnxrG+x9q9Rh9b01Q+dIJ
 u4XN+r6DcWnA/2Kb/0Rrpgy1AtVTouzw9q11zJNYpiGJ8eOjHeYr08g3nGbid5Qq1DPc
 xiLw==
X-Gm-Message-State: AOAM53040IQKQEahyQSy0ZRE8qk3UmvtgZR5e1SvjDRxrCi8pIzrElVO
 4qEmGXsiOW44UKxuvSXPgdI=
X-Google-Smtp-Source: ABdhPJx5Dhy4cMIe37LwwIVlRqxg9qfG8bQ1tYjpplU8k4zyM3CqmxKNVQMvmem1SJ3HAhFFd8xyTQ==
X-Received: by 2002:a05:600c:3489:: with SMTP id
 a9mr411960wmq.120.1638288467956; 
 Tue, 30 Nov 2021 08:07:47 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a?
 ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
 by smtp.googlemail.com with ESMTPSA id m36sm3269698wms.25.2021.11.30.08.07.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 30 Nov 2021 08:07:47 -0800 (PST)
Message-ID: <3f5adff7-f321-0688-c817-84975ebd3d14@redhat.com>
Date: Tue, 30 Nov 2021 17:07:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 10/43] KVM: arm64: Move vGIC v4 handling for WFI out
 arch callback hook
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-11-seanjc@google.com>
 <9236e715-c471-e1c8-6117-6f37b908a6bd@redhat.com>
 <875ytjbxpq.wl-maz@kernel.org>
 <be1cf8c7-ed87-b8eb-1bca-0a6c7505d7f8@redhat.com>
 <3490c50e-50d2-f906-3383-b87e14b14fab@redhat.com>
 <4826a7e2dbecc5d57323d18d725d6d69@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4826a7e2dbecc5d57323d18d725d6d69@kernel.org>
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

T24gMTEvMzAvMjEgMTM6MDQsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+Cj4+PiBJIGhhdmUgInF1
ZXVlZCIgaXQsIGJ1dCB0aGF0J3MganVzdCBteSBxdWV1ZSAtIGl0J3Mgbm90IG9uIGtlcm5lbC5v
cmcgCj4+PiBhbmQgaXQncyBub3QgZ29pbmcgdG8gYmUgaW4gNS4xNiwgYXQgbGVhc3Qgbm90IGlu
IHRoZSBmaXJzdCBiYXRjaC4KPj4+Cj4+PiBUaGVyZSdzIHBsZW50eSBvZiB0aW1lIGZvciBtZSB0
byByZWJhc2Ugb24gdG9wIG9mIGEgZml4LCBpZiB5b3Ugd2FudCAKPj4+IHRvIHNlbmQgdGhlIGZp
eCB0aHJvdWdoIHlvdXIga3ZtLWFybSBwdWxsIHJlcXVlc3QuwqAgSnVzdCBDYyBtZSBzbyAKPj4+
IHRoYXQgSSB1bmRlcnN0YW5kIHdoYXQncyBnb2luZyBvbi4KPj4KPj4gU2luY2UgYSBtb250aCBo
YXMgcGFzc2VkIGFuZCBJIGRpZG4ndCBzZWUgYW55dGhpbmcgcmVsYXRlZCBpbiB0aGUKPj4gS1ZN
LUFSTSBwdWxsIHJlcXVlc3RzLCBJIGFtIGdvaW5nIHRvIHF1ZXVlIHRoaXMgcGF0Y2guwqAgQW55
IGNvbmZsaWN0cwo+PiBjYW4gYmUgcmVzb2x2ZWQgdGhyb3VnaCBhIGt2bWFybS0+a3ZtIG1lcmdl
IG9mIGVpdGhlciBhIHRvcGljIGJyYW5jaAo+PiBvciBhIHRhZyB0aGF0IGlzIGRlc3RpbmVkIHRv
IDUuMTYuCj4gCj4gQ2FuIHlvdSBhdCBsZWFzdCBzcGVsbCBvdXQgKndoZW4qIHRoaXMgd2lsbCBs
YW5kPwoKSXQgd2lsbCBiZSBpbiBrdm0vbmV4dCBhcyBzb29uIGFzIEkgZmluaXNoIHJ1bm5pbmcg
dGVzdHMgb24gaXQsIHdoaWNoIAptYXkgdGFrZSBhIGNvdXBsZSBtb3JlIGRheXMgYmVjYXVzZSBJ
J20gdXBkYXRpbmcgbXkgbWFjaGluZXMgdG8gbmV3ZXIgCm9wZXJhdGluZyBzeXN0ZW1zLgoKPiBU
aGVyZSBpcywgaW4gZ2VuZXJhbCwgYSBjZXJ0YWluIGxhY2sgb2YgY2xhcml0eSBhYm91dCB3aGF0
IHlvdSBhcmUgcXVldWluZywKPiB3aGVyZSB5b3UgYXJlIHF1ZXVpbmcgaXQsIGFuZCB3aGF0IHJl
bGVhc2UgaXQgdGFyZ2V0cy4KCk9rLCB0aGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLiAgR2VuZXJh
bGx5IHNwZWFraW5nOgoKLSBrdm0vbWFzdGVyIGlzIHN0dWZmIHRoYXQgaXMgbWVyZ2VkIGFuZCB3
aWxsIGJlIGluIHRoZSBuZXh0IC1yYywgcmlnaHQgCm5vdyA1LjE2LXJjNC4gIEl0IHNob3VsZG4n
dCBldmVyIHJld2luZCAodGhvdWdoIGl0IG1heSBoYXBwZW4sIGl0IGlzIHJhcmUpCgotIGt2bS9u
ZXh0IGlzIHN0dWZmIHRoYXQgaXMgbWVyZ2VkIGFuZCB3aWxsIGJlIGluIHRoZSBuZXh0IG1lcmdl
IHdpbmRvdywgCnJpZ2h0IG5vdyA1LjE3LiAgSXQgYWxzbyBzaG91bGRuJ3QgcmV3aW5kLgoKLSBr
dm0vcXVldWUgaXMgc3R1ZmYgdGhhdCB0aGUgc3VibWl0dGVyIHNob3VsZG4ndCBjYXJlIGFib3V0
LCBhbmQgdGhhdCAKb3RoZXIgcGVvcGxlIHNob3VsZCBvbmx5IGNhcmUgYWJvdXQgdG8gY2hlY2sg
Zm9yIGNvbmZsaWN0cy4gIFdoZW4gSSBzYXkgCkkgInF1ZXVlZCIgYSBwYXRjaCBpdCBnb2VzIGlu
IGt2bS9xdWV1ZSwgYW5kIHRoZXJlJ3MgdGltZSB0byByZW1vdmUgaXQgCmlmIHNvbWV0aGluZyBi
cmVha3MuCgpSZWdhcmRpbmcgdGhpcyBzZXJpZXM6CgotIEkgYW0gcXVldWluZyBpdCB1cCB0byB0
aGlzIHBhdGNoCgotIEkgYW0gcXVldWluZyBpdCB0byBrdm0vbmV4dCwgbWVhbmluZyBpdCB0YXJn
ZXRzIDUuMTcKCi0gaXQgbG9va3MgbGlrZSB0aGUgbmV4dCBvbmUgKDExLzQzKSB0cmlnZ2VycyBh
IGtub3duIEFNRCBlcnJhdGEsIHNvIEknbSAKaG9sZGluZyBvbiB0aGUgcmVzdCB1bnRpbCB3ZSB1
bmRlcnN0YW5kIGlmIGl0IGFjdHVhbGx5IGRvZXMsIGFuZCBpZiBzbyAKaWYgQU1EIEFWSUMgaXMg
ZG9vbWVkLiAgRm9yIHRoZSB0aW1lIGJlaW5nLCBpdCB3aWxsIHN0YXkgaW4ga3ZtL3F1ZXVlLgoK
UGFvbG8KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
