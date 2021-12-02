Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA60DC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 10:31:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CB4C4B1AC;
	Thu,  2 Dec 2021 05:31:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hqs7qRtMq2+n; Thu,  2 Dec 2021 05:31:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2958B4B13D;
	Thu,  2 Dec 2021 05:31:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 777E64B08E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 05:31:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zyQtJOZGoLkJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 05:31:41 -0500 (EST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com
 [209.85.208.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD76940256
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 05:31:40 -0500 (EST)
Received: by mail-ed1-f44.google.com with SMTP id z5so49005068edd.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 02:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=N6k1dm8k+AuxT/kkINJ2uWzQD41QhKsh8yex3G7gZCI=;
 b=G/KcWY4NdiSiLbGwFVbMpplGKklwuLS8kzHzGur5jlThpat8rYTmvJEuvKnby0ikS5
 iMXoT3JaN8/6uGdTfqTV64IRpBhuVbTwgoqPRIuAnlOPg4YXFHbD8LSvudKuqUlIFuXo
 1B6vYQLwbiH5PukJHZ2d+B/hG4wyhNqTRUH+WJYFxX/aAnWG5ofBg3HiNT96ZFyJ9nM8
 RMfYqLt3L+O6eWXJQeNtUQxDFA97RXOHZgU97mHvKCkbWJ/oRSQWohVhbpxKbOUFzh4K
 /WIYiCEYMqmZsjs0IaWV39/CdP/UEiDeWQkZevioyJUXTo+ileWjeLZdsdLPjDzl5ytc
 MDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=N6k1dm8k+AuxT/kkINJ2uWzQD41QhKsh8yex3G7gZCI=;
 b=Q7iNMXYcDJhniIcwlDSL4+md/Van9NkTnyfFVuK4dHn7dWiQI8EF1VCA+YC7gDD/a4
 pWf6XroyR/9RzAqRhAa6EzZkN/GngFWQH902qgJXVY77OacjIZKDbbWh7axZEmZN0NHi
 ZzpFR5EWeEtZ792aNJ+8y5A9SC/d4TKPSt8Sn/MDSn2DWjof9cMEdUas8QgBeqQoDIX9
 087uC8xszjHz2XVzBy154wuArECaY/eYBQUYT72cp2zcgLq8+6MZfkOCoCNZAIzXCiZF
 BaibE7bdqnaZn8wetiXA8CJ6+Pv9eZEq9ldrDwUZNmULyIEzsTynKaerb9vqAXv3Bt4Q
 labA==
X-Gm-Message-State: AOAM533QE08P23G5pvGWBUHL0/1chRgoTsOFOjPBuiTkHKvXYXOCiN4Q
 RnhfF4rbsnkjrydUQDpZ//4=
X-Google-Smtp-Source: ABdhPJwhpBxx1yFRODBtJrFnn3nCW7H/sTu+w+jLDDEQAemKg7xUPHKBK5f7DJw2WZKCGsUGKU9xRg==
X-Received: by 2002:a17:906:ce2a:: with SMTP id
 sd10mr14431289ejb.154.1638441099804; 
 Thu, 02 Dec 2021 02:31:39 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a?
 ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
 by smtp.googlemail.com with ESMTPSA id w5sm1912110edc.58.2021.12.02.02.31.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Dec 2021 02:31:39 -0800 (PST)
Message-ID: <6200f141-8e6f-fe68-9539-22aa68559cb7@redhat.com>
Date: Thu, 2 Dec 2021 11:31:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
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
 <Yagoo7R8P5xVilsj@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yagoo7R8P5xVilsj@google.com>
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
 kvm-riscv@lists.infradead.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

T24gMTIvMi8yMSAwMzowMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBIbW0sIHRoYXQg
c3VnZ2VzdHMgdGhlIGJ1Zy9lcnJhdHVtIGlzIGR1ZSB0byB0aGUgQ1BVIGNvbnN1bWluZyBzdGFs
ZSBkYXRhIGZyb20gIzQKPiBmb3IgdGhlIElzUnVubmluZyBjaGVjayBpbiAjNSwgb3IgcmV0aXJp
bmcgdW9wcyBmb3IgdGhlIElzUnVubmluZyBjaGVjayBiZWZvcmUKPiByZXRpcmluZyB0aGUgdklS
UiB1cGRhdGUuCgpZZXMsIHRoaXMgc2VlbXMgdG8gYmUgYW4gZXJyb3IgaW4gdGhlIGltcGxlbWVu
dGF0aW9uIG9mIHN0ZXAgNS4gIEluIAphc3NlbWJseSwgYXRvbWljIG9wZXJhdGlvbnMgaGF2ZSBp
bXBsaWNpdCBtZW1vcnkgYmFycmllcnMsIGJ1dCB3aG8ga25vd3MgCndoYXQncyBnb2luZyBvbiBp
biBtaWNyb2NvZGUuICBTbyBlaXRoZXIgaXQncyB0aGUgZm9ybWVyLCBvciBzb21ldGhpbmcgCmlz
IGdvaW5nIG9uIHRoYXQncyBzcGVjaWZpYyB0byB0aGUgbWljcm9jb2RlIHNlcXVlbmNlciwgb3Ig
aXQncyBhIG1vcmUgCm11bmRhbmUgaW1wbGVtZW50YXRpb24gYnVnLgoKSW4gYW55IGNhc2UsIEFW
SUMgaXMgZGlzYWJsZWQgZm9yIG5vdyBhbmQgd2lsbCBuZWVkIGEgbGlzdCBvZiBtb2RlbCAKd2hl
cmUgaXQgd29ya3MsIHNvIEknbGwgZ28gb24gYW5kIHF1ZXVlIHRoZSBmaXJzdCBwYXJ0IG9mIHRo
aXMgc2VyaWVzLgoKUGFvbG8KCj4gSXQgd291bGQgYmUgaGVscGZ1bCBpZiB0aGUgZXJyYXR1bSBh
Y3R1YWxseSBwcm92aWRlZAo+IGluZm8gb24gdGhlICJoaWdobHkgc3BlY2lmaWMgYW5kIGRldGFp
bGVkIHNldCBvZiBpbnRlcm5hbCB0aW1pbmcgY29uZGl0aW9ucyIuIDotLwo+IAo+ICAgIDQuIExv
b2t1cCB0aGUgdkFQSUMgYmFja2luZyBwYWdlIGFkZHJlc3MgaW4gdGhlIFBoeXNpY2FsIEFQSUMg
dGFibGUgdXNpbmcgdGhlCj4gICAgICAgZ3Vlc3QgcGh5c2ljYWwgQVBJQyBJRCBhcyBhbiBpbmRl
eCBpbnRvIHRoZSB0YWJsZS4KPiAgICA1LiBGb3IgZXZlcnkgdmFsaWQgZGVzdGluYXRpb246Cj4g
ICAgICAgLSBBdG9taWNhbGx5IHNldCB0aGUgYXBwcm9wcmlhdGUgSVJSIGJpdCBpbiBlYWNoIG9m
IHRoZSBkZXN0aW5hdGlvbnPigJkgdkFQSUMKPiAgICAgICAgIGJhY2tpbmcgcGFnZS4KPiAgICAg
ICAtIENoZWNrIHRoZSBJc1J1bm5pbmcgc3RhdHVzIG9mIGVhY2ggZGVzdGluYXRpb24uCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
