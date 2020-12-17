Return-Path: <SRS0=/4+A=FV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C480C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 09:07:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3881F23437
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 09:07:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3881F23437
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1054B235;
	Thu, 17 Dec 2020 04:07:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bhnR-2bCdCKB; Thu, 17 Dec 2020 04:07:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F9C54B236;
	Thu, 17 Dec 2020 04:07:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A125A4B2AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 23:19:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JYq+i+s07oSN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2020 23:19:46 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74D434B235
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 23:19:45 -0500 (EST)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CxJf46wsZzkr0L;
 Thu, 17 Dec 2020 12:18:52 +0800 (CST)
Received: from [10.174.187.231] (10.174.187.231) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 17 Dec 2020 12:19:35 +0800
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
 <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
 <49610291-cf57-ff78-d0ac-063af24efbb4@huawei.com>
 <48c10467-30f3-9b5c-bbcb-533a51516dc5@huawei.com>
 <2ad38077300bdcaedd2e3b073cd36743@kernel.org>
 <9b80d460-e149-20c8-e9b3-e695310b4ed1@huawei.com>
 <274dafb2e21f49326a64bb575e668793@kernel.org>
 <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
 <f8b398df-9945-9ce6-18e6-970637a1bb51@redhat.com>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <5732e2a2-7b78-dcbe-bd7d-77541c7bcf16@huawei.com>
Date: Thu, 17 Dec 2020 12:19:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <f8b398df-9945-9ce6-18e6-970637a1bb51@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.231]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Thu, 17 Dec 2020 04:07:35 -0500
Cc: Neo Jia <cjia@nvidia.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

T24gMjAyMC8xMi8xNiAxODozNSwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBTaGVubWluZywKPiAK
PiBPbiAxMi8xLzIwIDE6MTUgUE0sIFNoZW5taW5nIEx1IHdyb3RlOgo+PiBPbiAyMDIwLzEyLzEg
MTk6NTAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IE9uIDIwMjAtMTItMDEgMTE6NDAsIFNoZW5t
aW5nIEx1IHdyb3RlOgo+Pj4+IE9uIDIwMjAvMTIvMSAxODo1NSwgTWFyYyBaeW5naWVyIHdyb3Rl
Ogo+Pj4+PiBPbiAyMDIwLTExLTMwIDA3OjIzLCBTaGVubWluZyBMdSB3cm90ZToKPj4+Pj4KPj4+
Pj4gSGkgU2hlbm1pbmcsCj4+Pj4+Cj4+Pj4+PiBXZSBhcmUgcG9uZGVyaW5nIG92ZXIgdGhpcyBw
cm9ibGVtIHRoZXNlIGRheXMsIGJ1dCBzdGlsbCBkb24ndCBnZXQgYQo+Pj4+Pj4gZ29vZCBzb2x1
dGlvbi4uLgo+Pj4+Pj4gQ291bGQgeW91IGdpdmUgdXMgc29tZSBhZHZpY2Ugb24gdGhpcz8KPj4+
Pj4+Cj4+Pj4+PiBPciBjb3VsZCB3ZSBtb3ZlIHRoZSByZXN0b3Jpbmcgb2YgdGhlIHBlbmRpbmcg
c3RhdGVzIChpbmNsdWRlIHRoZSBzeW5jCj4+Pj4+PiBmcm9tIGd1ZXN0IFJBTSBhbmQgdGhlIHRy
YW5zZmVyIHRvIEhXKSB0byB0aGUgR0lDIFZNIHN0YXRlIGNoYW5nZSBoYW5kbGVyLAo+Pj4+Pj4g
d2hpY2ggaXMgY29tcGxldGVseSBjb3JyZXNwb25kaW5nIHRvIHNhdmVfcGVuZGluZ190YWJsZXMg
KG1vcmUgc3ltbWV0cmljPykKPj4+Pj4+IGFuZCBkb24ndCBleHBvc2UgR0lDdjQuLi4KPj4+Pj4K
Pj4+Pj4gV2hhdCBpcyAidGhlIEdJQyBWTSBzdGF0ZSBjaGFuZ2UgaGFuZGxlciI/IElzIHRoYXQg
YSBRRU1VIHRoaW5nPwo+Pj4+Cj4+Pj4gWWVhaCwgaXQgaXMgYSBhIFFFTVUgdGhpbmcuLi4KPj4+
Pgo+Pj4+PiBXZSBkb24ndCByZWFsbHkgaGF2ZSB0aGF0IGNvbmNlcHQgaW4gS1ZNLCBzbyBJJ2Qg
YXBwcmVjaWF0ZSBpZiB5b3UgY291bGQKPj4+Pj4gYmUgYSBiaXQgbW9yZSBleHBsaWNpdCBvbiB0
aGlzLgo+Pj4+Cj4+Pj4gTXkgdGhvdWdodCBpcyB0byBhZGQgYSBuZXcgaW50ZXJmYWNlICh0byBR
RU1VKSBmb3IgdGhlIHJlc3RvcmluZyBvZgo+Pj4+IHRoZSBwZW5kaW5nIHN0YXRlcywgd2hpY2gg
aXMgY29tcGxldGVseSBjb3JyZXNwb25kaW5nIHRvCj4+Pj4gS1ZNX0RFVl9BUk1fVkdJQ19TQVZF
X1BFTkRJTkdfVEFCTEVTLi4uCj4+Pj4gQW5kIGl0IGlzIGNhbGxlZCBmcm9tIHRoZSBHSUMgVk0g
c3RhdGUgY2hhbmdlIGhhbmRsZXIgaW4gUUVNVSwgd2hpY2gKPj4+PiBpcyBoYXBwZW5pbmcgYWZ0
ZXIgdGhlIHJlc3RvcmluZyAoY2FsbCBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZygpKQo+Pj4+
IGJ1dCBiZWZvcmUgdGhlIHN0YXJ0aW5nIChydW5uaW5nKSBvZiB0aGUgVkZJTyBkZXZpY2UuCj4+
Pgo+Pj4gUmlnaHQsIHRoYXQgbWFrZXMgc2Vuc2UuIEkgc3RpbGwgd29uZGVyIGhvdyBtdWNoIHRo
ZSBHSUMgc2F2ZS9yZXN0b3JlCj4+PiBzdHVmZiBkaWZmZXJzIGZyb20gb3RoZXIgYXJjaGl0ZWN0
dXJlcyB0aGF0IGltcGxlbWVudCBzaW1pbGFyIGZlYXR1cmVzLAo+Pj4gc3VjaCBhcyB4ODYgd2l0
aCBWVC1ELgo+Pgo+PiBJIGFtIG5vdCBmYW1pbGlhciB3aXRoIGl0Li4uCj4+Cj4+Pgo+Pj4gSXQg
aXMgb2J2aW91c2x5IHRvbyBsYXRlIHRvIGNoYW5nZSB0aGUgdXNlcnNwYWNlIGludGVyZmFjZSwg
YnV0IEkgd29uZGVyCj4+PiB3aGV0aGVyIHdlIG1pc3NlZCBzb21ldGhpbmcgYXQgdGhlIHRpbWUu
Cj4+Cj4+IFRoZSBpbnRlcmZhY2Ugc2VlbXMgdG8gYmUgcmVhbGx5IGFzeW1tZXRyaWNhbD8uLi4K
PiAKPiBpbiBxZW11IGQ1YWEwYzIyOWEgKCJody9pbnRjL2FybV9naWN2M19rdm06IEltcGxlbWVu
dCBwZW5kaW5nIHRhYmxlCj4gc2F2ZSIpIGNvbW1pdCBtZXNzYWdlLCBpdCBpcyB0cmFjZWQ6Cj4g
Cj4gIlRoZXJlIGlzIG5vIGV4cGxpY2l0IHJlc3RvcmUgYXMgdGhlIHRhYmxlcyBhcmUgaW1wbGlj
aXRseSBzeW5jJ2VkCj4gb24gSVRTIHRhYmxlIHJlc3RvcmUgYW5kIG9uIExQSSBlbmFibGUgYXQg
cmVkaXN0cmlidXRvciBsZXZlbC4iCj4gCj4gQXQgdGhhdCB0aW1lIHRoZXJlIHdhcyBubyByZWFs
IGp1c3RpZmljYXRpb24gYmVoaW5kIGFkZGluZyB0aGUgUkVTVE9SRQo+IGZlbGxvdyBhdHRyLgo+
IAo+IE1heWJlIGEgc3R1cGlkIHF1ZXN0aW9uIGJ1dCBpc24ndCBpdCBwb3NzaWJsZSB0byB1bnNl
dCB0aGUgZm9yd2FyZGluZwo+IHdoZW4gc2F2aW5nIGFuZCByZWx5IG9uIFZGSU8gdG8gYXV0b21h
dGljYWxseSByZXN0b3JlIGl0IHdoZW4gcmVzdW1pbmcKPiBvbiBkZXN0aW5hdGlvbj8KCkl0IHNl
ZW1zIHRoYXQgdGhlIHVuc2V0X2ZvcndhcmRpbmcgd291bGQgbm90IGJlIGNhbGxlZCB3aGVuIHNh
dmluZywgaXQgd291bGQKYmUgY2FsbGVkIGFmdGVyIG1pZ3JhdGlvbiBjb21wbGV0aW9uLi4uCkFz
IGZvciB0aGUgcmVzdW1pbmcvc2V0X2ZvcndhcmRpbmcsIEkgc3RpbGwgd29uZGVyOiBpcyBpdCBy
ZWFsbHkgaW1wcm9wZXIgdG8KdHJhbnNmZXIgdGhlIHBlbmRpbmcgc3RhdGVzIGZyb20gdmdpYyB0
byBWUFQgaW4gc2V0X2ZvcndhcmRpbmcgKG5vdCBvbmx5IGluCm1pZ3JhdGlvbik/Li4uICAtXy0K
ClRoYW5rcywKU2hlbm1pbmcKCj4gCj4gVGhhbmtzCj4gCj4gRXJpYwo+IAo+IAo+Pgo+PiBPciBp
cyB0aGVyZSBhIHBvc3NpYmlsaXR5IHRoYXQgd2UgY291bGQga25vdyB3aGljaCBpcnEgaXMgaHcg
YmVmb3JlIHRoZSBWRklPCj4+IGRldmljZSBjYWxscyBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGlu
ZygpPwo+Pgo+PiBUaGFua3MsCj4+IFNoZW5taW5nCj4+Cj4+Pgo+Pj4gVGhhbmtzLAo+Pj4KPj4+
IMKgwqDCoMKgwqDCoMKgIE0uCj4+Cj4gCj4gLgo+IApfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
