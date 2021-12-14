Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388EBC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 15:37:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A35204B08B;
	Tue, 14 Dec 2021 10:37:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmx.net
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0BStNpR93mGK; Tue, 14 Dec 2021 10:37:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 314954B11F;
	Tue, 14 Dec 2021 10:37:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57D694B108
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 19:41:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JrOjsxqwYP1W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 19:41:10 -0500 (EST)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 648F74B0DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 19:41:10 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=badeba3b8450; t=1639442466;
 bh=x+fZrRYuNqWTm7ySO5o7puV6MUl6MtNpHN4+gRjZwwg=;
 h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
 b=JHk7uROMK+QfYN+B9+1p18Dqgv00hZZOWmHtTTdd2AbAE9+3kzj/X4/V6FU33oChp
 kJmShjvVAHquIoMVE0rbhpAoOd32yFhFER5HVTpdxV5+ov7KMIMJe2dJOlo+A11nsG
 2tjbmT+vrSdHV/MBg6PfNlLLBCj+w1+evdURZ7ZA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MHGCo-1mjiSY03wO-00DEJM; Tue, 14
 Dec 2021 01:41:06 +0100
Message-ID: <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
Date: Tue, 14 Dec 2021 08:41:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Peter Maydell <peter.maydell@linaro.org>
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
In-Reply-To: <87lf0ojvq2.wl-maz@kernel.org>
X-Provags-ID: V03:K1:kqpzAu/eG4OLGRpccTu9TNviy8yVkd7k6n1KoUfdw6cxWIe70oe
 ohHL2eq3dkNH+nuxeJgViXKfa3NuFi6LdPpBHynjXHcbopIiFBJp9BS+qZduERWuTI4IodA
 nrmyAUsqHfq+8HTmEUbZd6ZIkEKDLTDcYUu3HeeUC7SGlKdiKz/DtYtxaNyR8DAf/Q/xizq
 OHLpGloQPCja7txstEltA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fIvSpY6mXno=:t4ZjrlsqtZsPPu1e9jVNA7
 Ba67gsxn01qKyzy6uMd/EO+MVYiDm6QfTH4ZLxjI0LFxdBuIbFL0Jo6TdsmCdEN+GPyoeNCBk
 F0w+K3JSV4xy7n+CLuJt7LRSBnWDi3q5PJj72liNHzdVVrcohfNL9L9uqakYVXK6oIiNB30p0
 HT9BaNDaki2R6jB+SHxS8R+g4YhB3GCs/LzOOg7zkP1yVMItN8B4RBnQbJaaFESXB+guVqHVE
 OcsZ2/tZ3/SUtS0hdn0dFQh6aOv/P1ksnfQRT7zUBnBTIQMuMaBMgNP3uD44iLiSo9vxoYUXJ
 XPVhU7ijen+eLBFcJFpQpA6a+devcthD8cSHjwNvFmHsUaUpkozeBW/P67WYln9q5hlDVpG73
 T4nxA8dDBxsX0hpD7BTo5we6Mrn45uklNP7SBccTn0MERqwlAi9q48au80Ip7CKugK2EnLcSr
 0VGr6GwPXcvhC8Cfc9EMxnc7jGPg3KEiWZZMUYP+z07A4mD5/D/P34V6DdFyFJaFc4toWTKCQ
 t+Y4IcI9WPVMtLJJB9VR+64UDYB++lqqeTbJAqeE8MQFoN/RlLjaphEO26tX31R5ZR/FTGhKs
 LprFCgHqvKz45l8XwCopAoLsAtztXRfH6fp777IPpb1oei6VRM6y4wNS5D1IfFhHDtyu96tRu
 K7rlq+p3PdcSYSLnQFMj7s5EnCanQqppUKigqPc9G0mboWP6XtN4rI1Gt7sx9DOqa3RYWZ5Rv
 1yG+IaRTtdCJBTzRtqo/LY18JrIAv8cURh9b0VMKmLM9mWzIO31hgTzUEl8GoaH0lZgc0OB89
 UVeW7YqeVOza+znsb+yZACvwv15yeHWsDeAM+0TGO1UyZ5xqUHXFmW5nWvuPG+HVT056mQHkG
 wjuoa/EsUnp8RFhMNMJ6d3dNDaTUcYM0eqgKaHMKWcQx6QWa8JU/DB1HdszZSboY8evqyNiXq
 e7AK5ArMqAjj4+IeDxD0+7iirl0PZT/GZf8mGCsgpl0u0A7wN1Xs5yLAO8y2FdYf0Sb5OONx9
 +BjQ6n69QYpTnpX8X7hMtOcv6NdJaLFg6UKHRsbkDzsVO1YoGjaA5C6E4ScB5TJyIQbypslil
 uEK5d0l8Gik7no=
X-Mailman-Approved-At: Tue, 14 Dec 2021 10:37:24 -0500
Cc: libvirt-users@redhat.com,
 =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
 qemu-arm@nongnu.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
 qemu-discuss@nongnu.org
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

CgpPbiAyMDIxLzEyLzE0IDAwOjQ5LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gTW9uLCAxMyBE
ZWMgMjAyMSAxNjowNjoxNCArMDAwMCwKPiBQZXRlciBNYXlkZWxsIDxwZXRlci5tYXlkZWxsQGxp
bmFyby5vcmc+IHdyb3RlOgo+Pgo+PiBLVk0gb24gYmlnLmxpdHRsZSBzZXR1cHMgaXMgYSBrZXJu
ZWwtbGV2ZWwgcXVlc3Rpb24gcmVhbGx5OyBJJ3ZlCj4+IGNjJ2QgdGhlIGt2bWFybSBsaXN0Lgo+
Cj4gVGhhbmtzIFBldGVyIGZvciB0aHJvd2luZyB1cyB1bmRlciB0aGUgYmlnLWxpdHRsZSBidXMh
IDstKQo+Cj4+Cj4+IE9uIE1vbiwgMTMgRGVjIDIwMjEgYXQgMTU6MDIsIFF1IFdlbnJ1byA8cXV3
ZW5ydW8uYnRyZnNAZ214LmNvbT4gd3JvdGU6Cj4+Pgo+Pj4KPj4+Cj4+PiBPbiAyMDIxLzEyLzEz
IDIxOjE3LCBNaWNoYWwgUHLDrXZvem7DrWsgd3JvdGU6Cj4+Pj4gT24gMTIvMTEvMjEgMDI6NTgs
IFF1IFdlbnJ1byB3cm90ZToKPj4+Pj4gSGksCj4+Pj4+Cj4+Pj4+IFJlY2VudGx5IEkgZ290IG15
IGxpYnZpcnQgc2V0dXAgb24gYm90aCBSSzMzOTkgKFJvY2tQcm82NCkgYW5kIFJQSSBDTTQsCj4+
Pj4+IHdpdGggdXBzdHJlYW0ga2VybmVscy4KPj4+Pj4KPj4+Pj4gRm9yIFJQSSBDTTQgaXRzIG1v
c3RseSBzbW9vdGggc2FpbCwgYnV0IG9uIFJLMzM5OSBkdWUgdG8gaXRzIGxpdHRsZS5CSUcKPj4+
Pj4gc2V0dXAgKGNvcmUgMC0zIGFyZSA0eCBBNTUgY29yZXMsIGFuZCBjb3JlIDQtNSBhcmUgMngg
QTcyIGNvcmVzKSwgaXQKPj4+Pj4gYnJpbmdzIHF1aXRlIHNvbWUgdHJvdWJsZXMgZm9yIFZNcy4K
Pj4+Pj4KPj4+Pj4gSW4gc2hvcnQsIHdpdGhvdXQgcHJvcGVyIGNwdXNldCB0byBiaW5kIHRoZSBW
TSB0byBlaXRoZXIgYWxsIEE3MiBjb3Jlcwo+Pj4+PiBvciBhbGwgQTU1IGNvcmVzLCB0aGUgVk0g
d2lsbCBtb3N0bHkgZmFpbCB0byBib290Lgo+Cj4gcy9BNTUvQTUzLy4gVGhlcmUgd2VyZSB0aGFu
a2Z1bGx5IG5vIEE3MitBNTUgZXZlciBwcm9kdWNlZCAoanVzdCB0aGUKPiB0aG91Z2ggb2YgaXQg
bWFrZXMgbWUgc2ljaykuCj4KPj4+Pj4KPj4+Pj4gQ3VycmVudGx5IHRoZSB3b3JraW5nIHhtbCBp
czoKPj4+Pj4KPj4+Pj4gICAgIDx2Y3B1IHBsYWNlbWVudD0nc3RhdGljJyBjcHVzZXQ9JzQtNSc+
MjwvdmNwdT4KPj4+Pj4gICAgIDxjcHUgbW9kZT0naG9zdC1wYXNzdGhyb3VnaCcgY2hlY2s9J25v
bmUnLz4KPj4+Pj4KPj4+Pj4gQnV0IGV2ZW4gd2l0aCB2Y3B1cGluLCBwaW5uaW5nIGVhY2ggdmNw
dSB0byBlYWNoIHBoeXNpY2FsIGNvcmUsIFZNIHdpbGwKPj4+Pj4gbW9zdGx5IGZhaWwgdG8gc3Rh
cnQgdXAgZHVlIHRvIHZjcHUgaW5pdGlhbGl6YXRpb24gZmFpbGVkIHdpdGggLUVJTlZBTC4KPgo+
IERpc2NsYWltZXI6IEkga25vdyBub3RoaW5nIGFib3V0IGxpYnZpcnQgKGFuZCBubywgSSBkb24n
dCB3YW50IHRvCj4ga25vdyEgOy0pLgo+Cj4gSG93ZXZlciwgZm9yIHRoaW5ncyB0byBiZSByZWxp
YWJsZSwgeW91IG5lZWQgdG8gdGFza3NldCB0aGUgd2hvbGUgUUVNVQo+IHByb2Nlc3MgdG8gdGhl
IENQVSB0eXBlIHlvdSBpbnRlbmQgdG8gdXNlLgoKWWVwLCB0aGF0J3Mgd2hhdCBJJ20gZG9pbmcu
Cgo+IFRoYXQncyBiZWNhdXNlLCBBRkFJQ1QsCj4gUUVNVSB3aWxsIHNuYXBzaG90IHRoZSBzeXN0
ZW0gcmVnaXN0ZXJzIG91dHNpZGUgb2YgdGhlIHZjcHUgdGhyZWFkcywKPiBhbmQgYXR0ZW1wdCB0
byB1c2UgdGhlIHJlc3VsdCB0byBjb25maWd1cmUgdGhlIGFjdHVhbCB2Y3B1IHRocmVhZHMuIElm
Cj4gdGhleSBoYXBwZW4gdG8gcnVuIG9uIGRpZmZlcmVudCBDUFUgdHlwZXMsIHRoZSBzeXNyZWdz
IHdpbGwgZGlmZmVyIGluCj4gaW5jb21wYXRpYmxlIHdheXMgYW5kIGFuIGVycm9yIHdpbGwgYmUg
cmV0dXJuZWQuIFRoaXMgbWF5IG9yIG1heSBub3QKPiBiZSBhIGJ1ZywgSSBkb24ndCBrbm93IChJ
IHNlZSBpdCBhcyBhIGZlYXR1cmUpLgoKVGhlbiB0aGlzIGJyaW5ncyBhbm90aGVyIHF1ZXN0aW9u
LgoKSWYgd2UgY2FuIHBpbiBlYWNoIHZDUFUgdG8gZWFjaCBwaHlzaWNhbCBjb3JlIChib3RoIGxp
dHRsZSBhbmQgYmlnKSwKdGhlbiBhcyBsb25nIGFzIHRoZSByZWdpc3RlcnMgYXJlIHBlci12Q1BV
IGJhc2VkLCBpdCBzaG91bGQgYmUgYWJsZSB0bwpwYXNzIGJvdGggYmlnIGFuZCBsaXR0bGUgY29y
ZXMgdG8gdGhlIFZNLgoKWWVhaCwgSSB0b3RhbGx5IHVuZGVyc3RhbmQgdGhpcyBzY3JldyB1cCB0
aGUgc2NoZWR1bGluZywgYnV0IHRoYXQncyBhdApsZWFzdCB3aGF0IChzb21lIGluc2FuZSkgdXNl
cnMgd2FudCAoanVzdCBsaWtlIG1lKS4KCj4KPiBJZiB5b3UgYXJlIGFubm95ZWQgd2l0aCB0aGlz
IGJlaGF2aW91ciwgeW91IGNhbiBhbHdheXMgdXNlIGEgZGlmZmVyZW50Cj4gVk1NIHRoYXQgd29u
J3QgY2FyZSBhYm91dCBzdWNoIGRpZmZlcmVuY2UgKGNyb3N2bSBvciBrdm10b29sLCB0byBuYW1l
Cj4gYSBmZXcpLgoKU291bmRzIHByZXR0eSBpbnRlcmVzdGluZywgYSBuZXcgd29ybGQgYnV0IHdp
dGhvdXQgbGlidmlydC4uLgoKPiBIb3dldmVyLCB0aGUgZ3Vlc3Qgd2lsbCBiZSBhYmxlIHRvIG9i
c2VydmUgdGhlIG1pZ3JhdGlvbiBmcm9tCj4gb25lIGNwdSB0eXBlIHRvIGFub3RoZXIuIFRoaXMg
bWF5IG9yIG1heSBub3QgYWZmZWN0IHlvdXIgZ3Vlc3Qncwo+IGJlaGF2aW91ci4KCk5vdCBzdXJl
IGlmIGl0J3MgcG9zc2libGUgdG8gcGluIGVhY2ggdkNQVSB0aHJlYWQgdG8gZWFjaCBjb3JlLCBi
dXQgbGV0Cm1lIHRyeS4KCj4KPiBJIHBlcnNvbmFsbHkgZmluZCB0aGUgUUVNVSBiZWhhdmlvdXIg
cmVhc29uYWJsZS4gS1ZNL2FybTY0IG1ha2UgbGl0dGxlCj4gZWZmb3J0IHRvIHN1cHBvcnQgQkwg
dmlydHVhbGlzYXRpb24gYXMgZGVzaWduIGNob2ljZSAoSSB2YWx1ZSBteQo+IHNhbml0eSksIGFu
ZCB1c2Vyc3BhY2UgaXMgc3RpbGwgaW4gY29udHJvbCBvZiB0aGUgcGxhY2VtZW50Lgo+Cj4+Pj4+
IFRoaXMgYnJpbmdzIGEgcHJvYmxlbSwgaW4gdGhlb3J5IFJLMzM5OSBTb0Mgc2hvdWxkIG91dC1w
ZXJmb3JtIEJDTTI3MTEKPj4+Pj4gaW4gbXVsdGktY29yZSBwZXJmb3JtYW5jZSwgYnV0IGlmIGEg
Vk0gY2FuIG9ubHkgYmUgYmluZCB0byBlaXRoZXIgQTcyIG9yCj4+Pj4+IEE1NSBjb3JlcywgdGhl
biB0aGUgcGVyZm9ybWFuY2UgaXMgbm8gbG9uZ2VyIGNvbXBldGl0aXZlIGFnYWluc3QKPj4+Pj4g
QkNNMjcxMSwgd2FzdGluZyB0aGUgUENJRSAyLjAgeDQgY2FwYWNpdHkuCj4KPiBWb3RlIHdpdGgg
eW91ciBtb25leS4gSWYgeW91IHRvbyB0aGluayB0aGF0IEJMIHN5c3RlbXMgYXJlIHV0dGVyIGNy
YXAsCj4gZG8gbm90IGJ1eSB0aGVtISBPciB0cmVhdCB0aGVtIGFzICd0d28gc3lzdGVtcyBpbiBv
bmUnLCB3aGljaCBpcyB3aGF0Cj4gSSBkby4gRnJvbSB0aGF0IGFuZ2xlLCB0aGlzIGlzIG9mIGdy
ZWF0IHZhbHVlISA7LSkKCkkgZ3Vlc3MgSSdtIHNldHRpbmcgbXkgZXhwZWN0YXRpb24gdG9vIGhp
Z2ggZm9yIHJrMzM5OSwganVzdCBzZWVpbmcgaXRzCm11bHRpLXRocmVhZCBwZXJmIGJlYXRpbmcg
UlBJNCBhbmQgaGFzIGJldHRlciBJTyBkb2Vzbid0IG1lYW4gaXQncyBhCnBlcmZlY3QgZml0IGZv
ciBWTS4KCkhvcGVzIHJrMzU4OCBjb3VsZCBjaGFuZ2UgaXQuCgpGb3Igbm93IEkgZ3Vlc3Mgb3Zl
cmNsb2NraW5nIHRoZSBiaWcgY29yZSB0byAyLjJHIGlzIHdoYXQgSSBjYW4gZG8gdG8KZ3JhYiBt
b3JlIHBlcmZvcm1hbmNlIGZyb20gdGhlIGJvYXJkLgoKVGhhbmtzIGZvciB5b3VyIGRldGFpbGVk
IHJlYXNvbiBhbmQgbmV3IGFkdmljZXMhClF1Cgo+Cj4+Pj4+IEkgZ3Vlc3Mgd2l0aCBwcm9qZWN0
cyBsaWtlIEFzYWhpIExpbnV4IG1ha2luZyBwcm9ncmVzcywgdGhlcmUgd2lsbCBiZQo+Pj4+PiBt
b3JlIGFuZCBtb3JlIHN1Y2ggcHJvYmxlbXMuCj4KPiBXZWxsLCBub3QgbW9yZSB0aGFuIGFueSBv
dGhlciBiaWctbGl0dGxlIHN5c3RlbS4gVGhleSBzdWZmZXIgZnJvbQo+IHNpbWlsYXIgaXNzdWVz
LCBwbHVzIHRob3NlIHJlc3VsdGluZyBmcm9tIG5vdCBmdWxseSBpbXBsZW1lbnRpbmcgdGhlCj4g
QVJNIGFyY2hpdGVjdHVyZS4gVGhleSBhcmUgaG93ZXZlciBtb3JlIGNvbnNpc3RlbnQgaW4gdGhl
aXIgZmVhdHVyZQo+IHNldCB0aGFuIHRoZSBBUk0gaW1wbGVtZW50YXRpb25zIGV2ZXIgd2VyZS4K
Pgo+Pj4+Pgo+Pj4+PiBBbnkgY2x1ZSBvbiBob3cgdG8gcHJvcGVybHkgcGFzcyBhbGwgcGh5c2lj
YWwgQ1BVIGNvcmVzIHRvIFZNIGZvcgo+Pj4+PiBsaXR0bGUuQklHIHNldHVwPwo+Pj4+Pgo+Pj4+
Cj4+Pj4gSSBoYXZlIG5ldmVyIG1ldCBiaWcuTElUVExFIGJ1dCBteSB1bmRlcnN0YW5kaW5nIHdh
cyB0aGF0IHRob3NlIGJpZwo+Pj4+IGNvcmVzIGFyZSBjb21wYXRpYmxlIHdpdGggbGl0dGxlIG9u
ZXMgYW5kIHRoZSBvbmx5IGRpZmZlcmVuY2UgaXMgdGhhdAo+Pj4+IHRoZSBiaWcgb25lcyBhcmUg
c2h1dCBvZmYgaWYgdGhlcmUncyBubyBkZW1hbmQgKHRvIHNhdmUgZW5lcmd5KSBsZWF2aW5nCj4+
Pj4gb25seSB0aGUgbGl0dGxlIG9uZXMgcnVubmluZy4KPgo+IE5vLiBUaGV5IGFyZSBhbGwgbm90
aW9uYWxseSBydW5uaW5nLiBJdCBpcyB0aGUgc2NoZWR1bGVyIHRoYXQgcGxhY2VzCj4gdGFza3Mg
KHN1Y2ggYXMgYSB2Y3B1KSBvbiBhICdjb252ZW5pZW50JyBjb3JlLCB3aGVyZSAnY29udmVuaWVu
dCcKPiBkZXBlbmRzIG9uIHRoZSBzY2hlZHVsaW5nIHBvbGljeS4KPgo+IEhUSCwKPgo+IAlNLgo+
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
