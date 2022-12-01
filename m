Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B146DC4321E
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 22:00:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3136C403A6;
	Thu,  1 Dec 2022 17:00:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zSdMfPUS-KHu; Thu,  1 Dec 2022 17:00:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 809144A0D8;
	Thu,  1 Dec 2022 17:00:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 884DC403C4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 17:00:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z4GIIAvAfkd5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 17:00:18 -0500 (EST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
 [209.85.128.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AC82403A6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 17:00:18 -0500 (EST)
Received: by mail-wm1-f41.google.com with SMTP id
 ay14-20020a05600c1e0e00b003cf6ab34b61so5097882wmb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 14:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=QIafPhFD9IJ7Ly0CwNSGH3i2Rs4yyu6nN9+ipEhZh0A=;
 b=jjyByQFW3CViXa2XSpO0S5OezirA8iriSGyNq1Emb3eAjXPvAcs8h/qhWZvQRHrkM7
 E4yO5aU5oCECenX1ChS/eFoKmPv0xbsgDyU0kSVTl00jl03ZBLNhtOgaVKcwhuzhfB8T
 N7R+KHdaQ76bY3Z76ec67H1IKhJ28BX8clWmhefVQ98++dEoXnF5l49Qy+3a5Cak9CFt
 EIL7cmRV6y+1rtO82GUIbFuUYJjyYdwwYbZEtJNme41VeTXnC4oIE2dnPOWtcMsSXZFG
 q6jTLuz1FCKKC86LuPzjUTBAJLTqeyAPRmVpOXM4szcQvlKMGYRA5VkbQrYDVl2oy6Mj
 mCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=QIafPhFD9IJ7Ly0CwNSGH3i2Rs4yyu6nN9+ipEhZh0A=;
 b=x/qRvwb4/W5AupaC+6FTOOnl1qEwmAjm2yGxZEVTZzLqEToTjZcytFUOdf0py7Ib0w
 R8fnJ/V3X3bD9p46QriEIsWIpDLTD0aFiK7OQ+csmbVdRfhXaZJw1oMnqu9OTLc/iS4u
 cAUa001bAqlPz88NDDBAq3/RUpryk+sN+51Vf3wkbhplbBW9XlzVnOqrVNhsalfR98BK
 KhCQ0WnnvxYEoYydqGF9QQvRUvRUdqEtzV6QzCJITBcAtgV1NT31p8H2my02fIafYJHQ
 tZ5wrGDW1ygnNCC3sj9GJmrcu5CAqYrC+tqLQruJDRkmzUCL/FgMkk57HOmhWB5Nc7Je
 d/tA==
X-Gm-Message-State: ANoB5pkd4O5d/un1uTQWkUQQyw4rC1KtCV1+JH+4SLB6VyTHqDXWAiKv
 FxP8/FoIGOEjlSFIhobhwVU0GQ==
X-Google-Smtp-Source: AA0mqf6xx+vYTMkMQZD2sUVXTGHs5cp2mVsSPKIbRGdbGqnCPXkM+pX1knRmP86IOvF6J1/cipiL/g==
X-Received: by 2002:a05:600c:3495:b0:3cf:ae53:918f with SMTP id
 a21-20020a05600c349500b003cfae53918fmr38954917wmq.131.1669932017038; 
 Thu, 01 Dec 2022 14:00:17 -0800 (PST)
Received: from [192.168.1.115] ([185.126.107.38])
 by smtp.gmail.com with ESMTPSA id
 k12-20020adfe8cc000000b00241b5af8697sm5556585wrn.85.2022.12.01.14.00.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 01 Dec 2022 14:00:16 -0800 (PST)
Message-ID: <beb697c2-dfad-780e-4638-76b229f28731@linaro.org>
Date: Thu, 1 Dec 2022 23:00:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v2 21/50] KVM: MIPS: Hardcode callbacks to hardware
 virtualization extensions
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-22-seanjc@google.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20221130230934.1014142-22-seanjc@google.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org
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

T24gMS8xMi8yMiAwMDowOSwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToKPiBOb3cgdGhhdCBL
Vk0gbm8gbG9uZ2VyIHN1cHBvcnRzIHRyYXAtYW5kLWVtdWxhdGUgKHNlZSBjb21taXQgNDVjN2U4
YWY0YTVlCj4gIk1JUFM6IFJlbW92ZSBLVk1fVEUgc3VwcG9ydCIpLCBoYXJkY29kZSB0aGUgTUlQ
UyBjYWxsYmFja3MgdG8gdGhlCj4gdmlydHVhbGl6YXRpb24gY2FsbGJhY2tzLgo+IAo+IEhhcmNv
ZGluZyB0aGUgY2FsbGJhY2tzIGVsaW1pbmF0ZXMgdGhlIHRlY2huaWNhbGx5LXVubmVjZXNzYXJ5
IGNoZWNrIG9uCj4gbm9uLU5VTEwga3ZtX21pcHNfY2FsbGJhY2tzIGluIGt2bV9hcmNoX2luaXQo
KS4gIE1JUFMgaGFzIG5ldmVyIHN1cHBvcnRlZAo+IG11bHRpcGxlIGluLXRyZWUgbW9kdWxlcywg
aS5lLiBiYXJyaW5nIGFuIG91dC1vZi10cmVlIG1vZHVsZSwgd2hlcmUKPiBjb3B5aW5nIGFuZCBy
ZW5hbWluZyBrdm0ua28gY291bnRzIGFzICJvdXQtb2YtdHJlZSIsIEtWTSBjb3VsZCBuZXZlcgo+
IGVuY291bnRlciBhIG5vbi1OVUxMIHNldCBvZiBjYWxsYmFja3MgZHVyaW5nIG1vZHVsZSBpbml0
Lgo+IAo+IFRoZSBjYWxsYmFjayBjaGVjayBpcyBhbHNvIHN1YnRseSBicm9rZW4sIGFzIGl0IGlz
IG5vdCB0aHJlYWQgc2FmZSwKPiBpLmUuIGlmIHRoZXJlIHdlcmUgbXVsdGlwbGUgbW9kdWxlcywg
bG9hZGluZyBib3RoIGNvbmN1cnJlbnRseSB3b3VsZAo+IGNyZWF0ZSBhIHJhY2UgYmV0d2VlbiBj
aGVja2luZyBhbmQgc2V0dGluZyBrdm1fbWlwc19jYWxsYmFja3MuCj4gCj4gR2l2ZW4gdGhhdCBv
dXQtb2YtdHJlZSBzaGVuYW5pZ2FucyBhcmUgbm90IHRoZSBrZXJuZWwncyByZXNwb25zaWJpbGl0
eSwKPiBoYXJkY29kZSB0aGUgY2FsbGJhY2tzIHRvIHNpbXBsaWZ5IHRoZSBjb2RlLgo+IAo+IFNp
Z25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPgo+IC0t
LQo+ICAgYXJjaC9taXBzL2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggfCAgMiArLQo+ICAgYXJjaC9t
aXBzL2t2bS9NYWtlZmlsZSAgICAgICAgICAgfCAgMiArLQo+ICAgYXJjaC9taXBzL2t2bS9jYWxs
YmFjay5jICAgICAgICAgfCAxNCAtLS0tLS0tLS0tLS0tLQo+ICAgYXJjaC9taXBzL2t2bS9taXBz
LmMgICAgICAgICAgICAgfCAgOSArKy0tLS0tLS0KPiAgIGFyY2gvbWlwcy9rdm0vdnouYyAgICAg
ICAgICAgICAgIHwgIDcgKysrKy0tLQo+ICAgNSBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMo
KyksIDI2IGRlbGV0aW9ucygtKQo+ICAgZGVsZXRlIG1vZGUgMTAwNjQ0IGFyY2gvbWlwcy9rdm0v
Y2FsbGJhY2suYwo+IAo+IGRpZmYgLS1naXQgYS9hcmNoL21pcHMvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaCBiL2FyY2gvbWlwcy9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4gaW5kZXggMjhmMGJhOTdk
YjcxLi4yODAzYzljMjFlZjkgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9taXBzL2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmgKPiArKysgYi9hcmNoL21pcHMvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+IEBAIC03
NTgsNyArNzU4LDcgQEAgc3RydWN0IGt2bV9taXBzX2NhbGxiYWNrcyB7Cj4gICAJdm9pZCAoKnZj
cHVfcmVlbnRlcikoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKPiAgIH07Cj4gICBleHRlcm4gc3Ry
dWN0IGt2bV9taXBzX2NhbGxiYWNrcyAqa3ZtX21pcHNfY2FsbGJhY2tzOwoKSUlVQyB3ZSBjb3Vs
ZCBldmVuIGNvbnN0aWZ5IHRoaXMgcG9pbnRlci4KCkFueXdheSwKUmV2aWV3ZWQtYnk6IFBoaWxp
cHBlIE1hdGhpZXUtRGF1ZMOpIDxwaGlsbWRAbGluYXJvLm9yZz4KCj4gZGlmZiAtLWdpdCBhL2Fy
Y2gvbWlwcy9rdm0vbWlwcy5jIGIvYXJjaC9taXBzL2t2bS9taXBzLmMKPiBpbmRleCBhZjI5NDkw
ZDk3NDAuLmYwYTZjMjQ1ZDFmZiAxMDA2NDQKPiAtLS0gYS9hcmNoL21pcHMva3ZtL21pcHMuYwo+
ICsrKyBiL2FyY2gvbWlwcy9rdm0vbWlwcy5jCj4gQEAgLTEwMTIsMTcgKzEwMTIsMTIgQEAgbG9u
ZyBrdm1fYXJjaF92bV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwgdW5zaWduZWQgaW50IGlvY3Rs
LCB1bnNpZ25lZCBsb25nIGFyZykKPiAgIAo+ICAgaW50IGt2bV9hcmNoX2luaXQodm9pZCAqb3Bh
cXVlKQo+ICAgewo+IC0JaWYgKGt2bV9taXBzX2NhbGxiYWNrcykgewo+IC0JCWt2bV9lcnIoImt2
bTogbW9kdWxlIGFscmVhZHkgZXhpc3RzXG4iKTsKPiAtCQlyZXR1cm4gLUVFWElTVDsKPiAtCX0K
PiAtCj4gLQlyZXR1cm4ga3ZtX21pcHNfZW11bGF0aW9uX2luaXQoJmt2bV9taXBzX2NhbGxiYWNr
cyk7Cj4gKwlyZXR1cm4ga3ZtX21pcHNfZW11bGF0aW9uX2luaXQoKTsKPiAgIH0KPiAgIAo+ICAg
dm9pZCBrdm1fYXJjaF9leGl0KHZvaWQpCj4gICB7Cj4gLQlrdm1fbWlwc19jYWxsYmFja3MgPSBO
VUxMOwo+ICsKPiAgIH0KPiAgIAo+ICAgaW50IGt2bV9hcmNoX3ZjcHVfaW9jdGxfZ2V0X3NyZWdz
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPiBkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL2t2bS92ei5j
IGIvYXJjaC9taXBzL2t2bS92ei5jCj4gaW5kZXggYzcwNmY1ODkwYTA1Li5kYWZhYjAwM2VhMGQg
MTAwNjQ0Cj4gLS0tIGEvYXJjaC9taXBzL2t2bS92ei5jCj4gKysrIGIvYXJjaC9taXBzL2t2bS92
ei5jCj4gQEAgLTMzMDQsNyArMzMwNCwxMCBAQCBzdGF0aWMgc3RydWN0IGt2bV9taXBzX2NhbGxi
YWNrcyBrdm1fdnpfY2FsbGJhY2tzID0gewo+ICAgCS52Y3B1X3JlZW50ZXIgPSBrdm1fdnpfdmNw
dV9yZWVudGVyLAo+ICAgfTsKPiAgIAo+IC1pbnQga3ZtX21pcHNfZW11bGF0aW9uX2luaXQoc3Ry
dWN0IGt2bV9taXBzX2NhbGxiYWNrcyAqKmluc3RhbGxfY2FsbGJhY2tzKQo+ICsvKiBGSVhNRTog
R2V0IHJpZCBvZiB0aGUgY2FsbGJhY2tzIG5vdyB0aGF0IHRyYXAtYW5kLWVtdWxhdGUgaXMgZ29u
ZS4gKi8KPiArc3RydWN0IGt2bV9taXBzX2NhbGxiYWNrcyAqa3ZtX21pcHNfY2FsbGJhY2tzID0g
Jmt2bV92el9jYWxsYmFja3M7Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
