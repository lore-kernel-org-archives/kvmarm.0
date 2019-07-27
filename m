Return-Path: <SRS0=tpUV=VY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1294BC76194
	for <kvmarm@archiver.kernel.org>; Sat, 27 Jul 2019 06:14:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97DCB20840
	for <kvmarm@archiver.kernel.org>; Sat, 27 Jul 2019 06:14:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97DCB20840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D55D14A55C;
	Sat, 27 Jul 2019 02:14:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sRYSiF-KLM27; Sat, 27 Jul 2019 02:14:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0323B4A54E;
	Sat, 27 Jul 2019 02:14:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C67E4A54E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Jul 2019 02:14:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QNDC8zKckG1i for <kvmarm@lists.cs.columbia.edu>;
 Sat, 27 Jul 2019 02:14:04 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 563354A500
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Jul 2019 02:14:04 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 08A0BF04ED6C5744E314;
 Sat, 27 Jul 2019 14:13:59 +0800 (CST)
Received: from [127.0.0.1] (10.177.19.122) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 27 Jul 2019
 14:13:56 +0800
Subject: Re: [PATCH 1/3] KVM: arm/arm64: vgic-its: Introduce multiple LPI
 translation caches
To: Marc Zyngier <marc.zyngier@arm.com>
References: <20190724090437.49952-1-xiexiangyou@huawei.com>
 <20190724090437.49952-2-xiexiangyou@huawei.com>
 <a8b74b25-8c92-4aad-f94d-8371126798ef@arm.com>
 <c0f441b5-2ba2-0482-6736-eb7835a24f0a@huawei.com>
 <86blxhne2s.wl-marc.zyngier@arm.com>
From: Xiangyou Xie <xiexiangyou@huawei.com>
Message-ID: <0db37e66-4a5c-f6e7-65e2-c95fcbc4ee3b@huawei.com>
Date: Sat, 27 Jul 2019 14:13:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <86blxhne2s.wl-marc.zyngier@arm.com>
Content-Language: en-US
X-Originating-IP: [10.177.19.122]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

SGkgTWFyYywKCkFkZGluZyBhIG5ldyBscGkgdG8gbHBpX2xpc3QsIHRoZSBjb250ZW50cyBvZiB0
aGUgY2FjaGVzIHdpbGwgbm90IGJlIAp1cGRhdGVkIGltbWVkaWF0ZWx5IHVudGlsIHRoZSBpcnEg
aXMgaW5qZWN0ZWQuCgpJcnEncyByZWZlcmVuY2UgY291bnQgd2lsbCBiZSBpbmNyZWFzZWQgd2hl
biBzeW5jaHJvbml6ZWQgdG8gZWFjaCBjYWNoZSwgCmFuZCByZWR1Y2VkIGFmdGVyIGRlbGV0aW5n
IGZyb20gZWFjaCBjYWNoZS4gT25seSB3aGVuIGlycSBpcyByZW1vdmVkIApmcm9tIGFsbCBjYWNo
ZXMsIHRoZSByZWZlcmVuY2UgY291bnQgaXMgcmVkdWNlZCB0byAwLCB3aGljaCBpcyBhbGxvd2Vk
IAp0byBiZSByZW1vdmVkIGZyb20gbHBpX2xpc3QuCgpTbyBJIHRoaW5rIHRoYXQgdGhlIHJlZmVy
ZW5jZSBjb3VudCBvZiBJUlEgY2FuIGd1YXJhbnRlZSB0aGUgY29uc2lzdGVuY3kgCm9mIGxwaV9s
aXN0IGFuZCBjYWNoZSwgaXMgcmlnaHQ/CgpXaGVuIG11bHRpcGxlIENQVXMgaW5qZWN0IGRpZmZl
cmVudCBscGkgaW50ZXJydXB0cyBhdCB0aGUgc2FtZSB0aW1lLCAKd2hpY2ggbWF5IHJlc3VsdCBp
biBkaWZmZXJlbnQgc29ydHMgb2YgaW50ZXJydXB0cyBpbiBkaWZmZXJlbnQgY2FjaGVzLCAKZXZl
biBzb21lIGludGVycnVwdHMgb2YgYSBjZXJ0YWluIGNhY2hlIGFyZSBvdmVyZmxvd2VkLgpFZzoK
VGhlIGNvbnRlbnRzIG9mIHRoZSBjYWNoZSBhdCBhIGNlcnRhaW4gbW9tZW5077yaCmNhY2hlIDA6
IGMtPmItPmEKY2FjaGUgMTogYS0+Yi0+YwoKVGhlbiwgaW5qZWN0IHR3byBpbnRlcnJ1cHRzICJk
LGUiIHNpbXVsdGFuZW91c2x5LCB0aGUgZm9sbG93aW5nIHJlc3VsdHMgCm1heSBvY2N1cjoKY2Fj
aGUgMDogZS0+ZC0+YwpjYWNoZSAxOiBkLT5lLT5hCgpCdXQgdGhpcyBpcyBubyBwcm9ibGVtLCBq
dXN0IG1ha2Ugc3VyZSB0aGF0IHRoZSBpcnEgZm91bmQgaXMgY29ycmVjdC4KCkluIGFkZGl0aW9u
LCBhYm91dCBMb2NraW5nIG9yZGVyOgprdm0tPmxvY2sgKG11dGV4KQogICBpdHMtPmNtZF9sb2Nr
IChtdXRleCkKICAgICBpdHMtPml0c19sb2NrIChtdXRleCkKICAgICAgIHZnaWNfY3B1LT5hcF9s
aXN0X2xvY2sKICAgICAgICAgY2FjaGUtPmxwaV9jYWNoZV9sb2NrICAvKiovCiAgICAgICAgICAg
IGt2bS0+bHBpX2xpc3RfbG9jawkKICAgICAgICAgICAgICB2Z2ljX2lycS0+aXJxX2xvY2sJCgpU
aGFua3MsCgpYaWFuZ3lvdS4KCk9uIDIwMTkvNy8yNiAyMTowMiwgTWFyYyBaeW5naWVyIHdyb3Rl
Ogo+IE9uIEZyaSwgMjYgSnVsIDIwMTkgMTM6MzU6MjAgKzAxMDAsCj4gWGlhbmd5b3UgWGllIDx4
aWV4aWFuZ3lvdUBodWF3ZWkuY29tPiB3cm90ZToKPj4KPj4gSGkgTWFyYywKPj4KPj4gU29ycnks
IHRoZSB0ZXN0IGRhdGEgd2FzIG5vdCBwb3N0ZWQgaW4gdGhlIHByZXZpb3VzIGVtYWlsLgo+Pgo+
PiBJIHRlc3RlZCB0aGUgaW1wYWN0IG9mIHZpcnR1YWwgaW50ZXJydXB0IGluamVjdGlvbiB0aW1l
LWNvbnN1bWluZ++8mgo+PiBSdW4gdGhlIGlwZXJmIGNvbW1hbmQgdG8gc2VuZCBVRFAgcGFja2V0
cyB0byB0aGUgVk06Cj4+IAlpcGVyZiAtYyAkSVAgLXUgLWIgNDBtIC1sIDY0IC10IDYwMDAmCj4+
IFRoZSB2bSBqdXN0IHJlY2VpdmUgVURQIHRyYWZmaWMuIFdoZW4gY29uZmlndXJlIG11bHRpcGxl
IE5JQ3MsIGVhY2gKPj4gTklDIHJlY2VpdmVzIHRoZSBhYm92ZSBpcGVyZiBVRFAgdHJhZmZpYywg
VGhpcyBtYXkgcmVmbGVjdCB0aGUKPj4gcGVyZm9ybWFuY2UgaW1wYWN0IG9mIHNoYXJlZCByZXNv
dXJjZSBjb21wZXRpdGlvbiwgc3VjaCBhcyBsb2NrLgo+Pgo+PiBPYnNlcnZpbmcgdGhlIGRlbGF5
IG9mIHZpcnR1YWwgaW50ZXJydXB0IGluamVjdGlvbjogdGhlIHRpbWUgc3BlbnQgYnkKPj4gdGhl
ICJpcnFmZF93YWtldXAiLCAiaXJxZmRfaW5qZWN0IiBmdW5jdGlvbiwgYW5kIGt3b3JrZXIgY29u
dGV4dAo+PiBzd2l0Y2guCj4+IFRoZSBsZXNzIHRoZSBiZXR0ZXIuCj4+Cj4+IElUUyB0cmFuc2xh
dGlvbiBjYWNoZSBncmVhdGx5IHJlZHVjZXMgdGhlIGRlbGF5IG9mIGludGVycnVwdCBpbmplY3Rp
b24KPj4gY29tcGFyZWQgdG8ga3dvcmtlciB0aHJlYWQsIGJlY2F1c2UgaXQgZWxpbWluYXRlIHdh
a2V1cCBhbmQgdW5jZXJ0YWluCj4+IHNjaGVkdWxpbmcgZGVsYXk6Cj4+ICAgICAgICAgICAgICAg
ICAgICBrd29ya2VyICAgICAgICAgICAgICBJVFMgdHJhbnNsYXRpb24gY2FjaGUgICAgaW1wcm92
ZWQKPj4gICAgMSBOSUMgICAgICAgICAgIDYuNjkyIHVzICAgICAgICAgICAgICAgICAxLjc2NiB1
cwo+PiA3My42JQo+PiAgIDEwIE5JQ3MgICAgICAgICAgNy41MzYgdXMgICAgICAgICAgICAgICAg
IDIuNTc0IHVzCj4+IDY1LjglCj4gCj4gT0ssIHRoYXQncyBwcmV0dHkgaW50ZXJlc3RpbmcuIEl0
IHdvdWxkIGhhdmUgYmVlbiBnb29kIHRvIHBvc3Qgc3VjaAo+IGRhdGEgaW4gcmVwbHkgdG8gdGhl
IElUUyBjYWNoZSBzZXJpZXMuCj4gCj4+Cj4+IEluY3JlYXNlcyB0aGUgbnVtYmVyIG9mIGxwaV90
cmFuc2xhdGlvbl9jYWNoZSByZWR1Y2UgbG9jayBjb21wZXRpdGlvbi4KPj4gTXVsdGktaW50ZXJy
dXB0IGNvbmN1cnJlbnQgaW5qZWN0aW9ucyBwZXJmb3JtIGJldHRlcjoKPj4KPj4gICAgICAgICAg
ICAgIElUUyB0cmFuc2xhdGlvbiBjYWNoZSAgICAgIHdpdGggcGF0Y2ggICAgICAgICAgICAgaW1w
cm92ZWQKPj4gICAgIDEgTklDICAgICAgICAxLjc2NiB1cyAgICAgICAgICAgICAgICAgMS42OTQg
dXMgICAgICAgICAgICAgICAgNC4xJQo+PiAgIDEwIE5JQ3MgICAgICAgIDIuNTc0IHVzICAgICAg
ICAgICAgICAgICAxLjg0OCB1cyAgICAgICAgICAgICAgIDI4LjIlCj4gCj4gCj4gVGhhdCdzIHNv
cnQgb2ZmIGludGVyZXN0aW5nIHRvbywgYnV0IGl0IGRvZXNuJ3QgYW5zd2VyIGFueSBvZiB0aGUK
PiBxdWVzdGlvbnMgSSBoYWQgaW4gcmVzcG9uc2UgdG8geW91ciBwYXRjaDogSG93IGRvIHlvdSBl
bnN1cmUgbXV0dWFsCj4gZXhjbHVzaW9uIHdpdGggdGhlIExQSSBsaXN0IGJlaW5nIGNvbmN1cnJl
bnRseSB1cGRhdGVkPyBIb3cgZG9lcyB0aGUKPiBuZXcgbG9ja2luZyBmaXQgaW4gdGhlIGN1cnJl
bnQgbG9ja2luZyBzY2hlbWU/Cj4gCj4gVGhhbmtzLAo+IAo+IAlNLgo+IAo+PiBSZWdhcmRzLAo+
Pgo+PiBYaWFuZ3lvdQo+Pgo+PiBPbiAyMDE5LzcvMjQgMTk6MDksIE1hcmMgWnluZ2llciB3cm90
ZToKPj4+IEhpIFhpYW5neW91LAo+Pj4KPj4+IE9uIDI0LzA3LzIwMTkgMTA6MDQsIFhpYW5neW91
IFhpZSB3cm90ZToKPj4+PiBCZWNhdXNlIGRpc3QtPmxwaV9saXN0X2xvY2sgaXMgYSBwZXJWTSBs
b2NrLCB3aGVuIGEgdmlydHVhbCBtYWNoaW5lCj4+Pj4gaXMgY29uZmlndXJlZCB3aXRoIG11bHRp
cGxlIHZpcnR1YWwgTklDIGRldmljZXMgYW5kIHJlY2VpdmVzCj4+Pj4gbmV0d29yayBwYWNrZXRz
IGF0IHRoZSBzYW1lIHRpbWUsIGRpc3QtPmxwaV9saXN0X2xvY2sgd2lsbCBiZWNvbWUKPj4+PiBh
IHBlcmZvcm1hbmNlIGJvdHRsZW5lY2suCj4+Pgo+Pj4gSSdtIHNvcnJ5LCBidXQgeW91J2xsIGhh
dmUgdG8gc2hvdyBtZSBzb21lIHJlYWwgbnVtYmVycyBiZWZvcmUgSQo+Pj4gY29uc2lkZXIgYW55
IG9mIHRoaXMuIFRoZXJlIGlzIGEgcmVhc29uIHdoeSB0aGUgb3JpZ2luYWwgc2VyaWVzIHN0aWxs
Cj4+PiBpc24ndCBpbiBtYWlubGluZSwgYW5kIHRoYXQncyBiZWNhdXNlIHBlb3BsZSBkb24ndCBw
b3N0IGFueSBudW1iZXJzLgo+Pj4gQWRkaW5nIG1vcmUgcGF0Y2hlcyBpcyBub3QgZ29pbmcgdG8g
Y2hhbmdlIHRoYXQgc21hbGwgZmFjdC4KPj4+Cj4+Pj4gVGhpcyBwYXRjaCBpbmNyZWFzZXMgdGhl
IG51bWJlciBvZiBscGlfdHJhbnNsYXRpb25fY2FjaGUgdG8gZWlnaHQsCj4+Pj4gaGFzaGVzIHRo
ZSBjcHVpZCB0aGF0IGV4ZWN1dGVzIGlycWZkX3dha2V1cCwgYW5kIGNob29zZXMgd2hpY2gKPj4+
PiBscGlfdHJhbnNsYXRpb25fY2FjaGUgdG8gdXNlLgo+Pj4KPj4+IFNvIHlvdSd2ZSBub3cgc3dp
dGNoZWQgdG8gYSBwZXItY2FjaGUgbG9jaywgbWVhbmluZyB0aGF0IHRoZSByZXN0IG9mIHRoZQo+
Pj4gSVRTIGNvZGUgY2FuIG1hbmlwdWxhdGUgdGhlIHRoZSBscGlfbGlzdCB3aXRob3V0IHN5bmNo
cm9uaXphdGlvbiB3aXRoCj4+PiB0aGUgY2FjaGVzLiBIYXZlIHlvdSB3b3JrZWQgb3V0IGFsbCB0
aGUgcG9zc2libGUgcmFjZXM/IEFsc28sIGhvdyBkb2VzCj4+PiB0aGlzIG5ldyBsb2NrIGNsYXNz
IGZpdHMgaW4gdGhlIHdob2xlIGxvY2tpbmcgaGllcmFyY2h5Pwo+Pj4KPj4+IElmIHlvdSB3YW50
IHNvbWV0aGluZyB0aGF0IGlzIGFjdHVhbGx5IHNjYWxhYmxlLCBkbyBpdCB0aGUgcmlnaHQgd2F5
Lgo+Pj4gVXNlIGEgYmV0dGVyIGRhdGEgc3RydWN0dXJlIHRoYW4gYSBsaXN0LCBzd2l0Y2ggdG8g
dXNpbmcgUkNVIHJhdGhlciB0aGFuCj4+PiB0aGUgY3VycmVudCBsb2NraW5nIHN0cmF0ZWd5LiBC
dXQgeW91ciBjdXJyZW50IGFwcHJvYWNoIGxvb2tzIHF1aXRlIGZyYWdpbGUuCj4+Pgo+Pj4gVGhh
bmtzLAo+Pj4KPj4+IAlNLgo+Pj4KPj4KPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
