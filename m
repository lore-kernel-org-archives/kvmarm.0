Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F202C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 08:39:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54145239E5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 08:39:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54145239E5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 953C84B29C;
	Tue,  8 Dec 2020 03:39:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9EhTKzSzfQAv; Tue,  8 Dec 2020 03:39:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD274B26F;
	Tue,  8 Dec 2020 03:39:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C684B27F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 03:25:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9pyRtxDCvf4E for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 03:25:28 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C90CE4B279
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 03:25:25 -0500 (EST)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CqtX05LC1zhpDC;
 Tue,  8 Dec 2020 16:24:48 +0800 (CST)
Received: from [10.174.187.47] (10.174.187.47) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 16:25:13 +0800
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>
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
Message-ID: <77f60f4e-a832-97aa-7ec6-da9d596438b2@huawei.com>
Date: Tue, 8 Dec 2020 16:25:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <59ec07e5-c017-8644-b96f-e87fe600c490@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.47]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Tue, 08 Dec 2020 03:39:35 -0500
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Neo Jia <cjia@nvidia.com>,
 kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
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

T24gMjAyMC8xMi8xIDIwOjE1LCBTaGVubWluZyBMdSB3cm90ZToKPiBPbiAyMDIwLzEyLzEgMTk6
NTAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMC0xMi0wMSAxMTo0MCwgU2hlbm1pbmcg
THUgd3JvdGU6Cj4+PiBPbiAyMDIwLzEyLzEgMTg6NTUsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+
PiBPbiAyMDIwLTExLTMwIDA3OjIzLCBTaGVubWluZyBMdSB3cm90ZToKPj4+Pgo+Pj4+IEhpIFNo
ZW5taW5nLAo+Pj4+Cj4+Pj4+IFdlIGFyZSBwb25kZXJpbmcgb3ZlciB0aGlzIHByb2JsZW0gdGhl
c2UgZGF5cywgYnV0IHN0aWxsIGRvbid0IGdldCBhCj4+Pj4+IGdvb2Qgc29sdXRpb24uLi4KPj4+
Pj4gQ291bGQgeW91IGdpdmUgdXMgc29tZSBhZHZpY2Ugb24gdGhpcz8KPj4+Pj4KPj4+Pj4gT3Ig
Y291bGQgd2UgbW92ZSB0aGUgcmVzdG9yaW5nIG9mIHRoZSBwZW5kaW5nIHN0YXRlcyAoaW5jbHVk
ZSB0aGUgc3luYwo+Pj4+PiBmcm9tIGd1ZXN0IFJBTSBhbmQgdGhlIHRyYW5zZmVyIHRvIEhXKSB0
byB0aGUgR0lDIFZNIHN0YXRlIGNoYW5nZSBoYW5kbGVyLAo+Pj4+PiB3aGljaCBpcyBjb21wbGV0
ZWx5IGNvcnJlc3BvbmRpbmcgdG8gc2F2ZV9wZW5kaW5nX3RhYmxlcyAobW9yZSBzeW1tZXRyaWM/
KQo+Pj4+PiBhbmQgZG9uJ3QgZXhwb3NlIEdJQ3Y0Li4uCj4+Pj4KPj4+PiBXaGF0IGlzICJ0aGUg
R0lDIFZNIHN0YXRlIGNoYW5nZSBoYW5kbGVyIj8gSXMgdGhhdCBhIFFFTVUgdGhpbmc/Cj4+Pgo+
Pj4gWWVhaCwgaXQgaXMgYSBhIFFFTVUgdGhpbmcuLi4KPj4+Cj4+Pj4gV2UgZG9uJ3QgcmVhbGx5
IGhhdmUgdGhhdCBjb25jZXB0IGluIEtWTSwgc28gSSdkIGFwcHJlY2lhdGUgaWYgeW91IGNvdWxk
Cj4+Pj4gYmUgYSBiaXQgbW9yZSBleHBsaWNpdCBvbiB0aGlzLgo+Pj4KPj4+IE15IHRob3VnaHQg
aXMgdG8gYWRkIGEgbmV3IGludGVyZmFjZSAodG8gUUVNVSkgZm9yIHRoZSByZXN0b3Jpbmcgb2YK
Pj4+IHRoZSBwZW5kaW5nIHN0YXRlcywgd2hpY2ggaXMgY29tcGxldGVseSBjb3JyZXNwb25kaW5n
IHRvCj4+PiBLVk1fREVWX0FSTV9WR0lDX1NBVkVfUEVORElOR19UQUJMRVMuLi4KPj4+IEFuZCBp
dCBpcyBjYWxsZWQgZnJvbSB0aGUgR0lDIFZNIHN0YXRlIGNoYW5nZSBoYW5kbGVyIGluIFFFTVUs
IHdoaWNoCj4+PiBpcyBoYXBwZW5pbmcgYWZ0ZXIgdGhlIHJlc3RvcmluZyAoY2FsbCBrdm1fdmdp
Y192NF9zZXRfZm9yd2FyZGluZygpKQo+Pj4gYnV0IGJlZm9yZSB0aGUgc3RhcnRpbmcgKHJ1bm5p
bmcpIG9mIHRoZSBWRklPIGRldmljZS4KPj4KPj4gUmlnaHQsIHRoYXQgbWFrZXMgc2Vuc2UuIEkg
c3RpbGwgd29uZGVyIGhvdyBtdWNoIHRoZSBHSUMgc2F2ZS9yZXN0b3JlCj4+IHN0dWZmIGRpZmZl
cnMgZnJvbSBvdGhlciBhcmNoaXRlY3R1cmVzIHRoYXQgaW1wbGVtZW50IHNpbWlsYXIgZmVhdHVy
ZXMsCj4+IHN1Y2ggYXMgeDg2IHdpdGggVlQtRC4KPiAKPiBJIGFtIG5vdCBmYW1pbGlhciB3aXRo
IGl0Li4uCj4gCj4+Cj4+IEl0IGlzIG9idmlvdXNseSB0b28gbGF0ZSB0byBjaGFuZ2UgdGhlIHVz
ZXJzcGFjZSBpbnRlcmZhY2UsIGJ1dCBJIHdvbmRlcgo+PiB3aGV0aGVyIHdlIG1pc3NlZCBzb21l
dGhpbmcgYXQgdGhlIHRpbWUuCj4gCj4gVGhlIGludGVyZmFjZSBzZWVtcyB0byBiZSByZWFsbHkg
YXN5bW1ldHJpY2FsPy4uLgo+IAo+IE9yIGlzIHRoZXJlIGEgcG9zc2liaWxpdHkgdGhhdCB3ZSBj
b3VsZCBrbm93IHdoaWNoIGlycSBpcyBodyBiZWZvcmUgdGhlIFZGSU8KPiBkZXZpY2UgY2FsbHMg
a3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoKT8KPiAKPiBUaGFua3MsCj4gU2hlbm1pbmcKPiAK
Pj4KPj4gVGhhbmtzLAo+Pgo+PiDCoMKgwqDCoMKgwqDCoCBNLgo+IC4KPiAKCkhpIE1hcmMsCgpJ
IGFtIGxlYXJuaW5nIFZULWQgUG9zdGVkIEludGVycnVwdCAoUEkpIHRoZXNlIGRheXMuCgpBcyBm
YXIgYXMgSSBjYW4gdGVsbCwgdGhlIHBvc3RlZCBpbnRlcnJ1cHRzIGFyZSBmaXJzdGx5IHJlY29y
ZGVkIGluIHRoZSBQb3N0ZWQKSW50ZXJydXB0IFJlcXVlc3QgKCpQSVIqKSBmaWVsZCBvZiB0aGUg
UG9zdGVkIEludGVycnVwdCBEZXNjcmlwdG9yIChhIHRlbXBvcmFyeQpzdG9yYWdlIGFyZWEgKGRh
dGEgc3RydWN0dXJlIGluIG1lbW9yeSkgd2hpY2ggaXMgc3BlY2lmaWMgdG8gUEkpLCBhbmQgd2hl
biB0aGUKdkNQVSBpcyBydW5uaW5nLCBhIG5vdGlmaWNhdGlvbiBldmVudCAoaG9zdCB2ZWN0b3Ip
IHdpbGwgYmUgZ2VuZXJhdGVkIGFuZCBzZW50CnRvIHRoZSBDUFUgKHRoZSB0YXJnZXQgdkNQVSBp
cyBjdXJyZW50bHkgc2NoZWR1bGVkIG9uIGl0KSwgd2hpY2ggd2lsbCBjYXVzZSB0aGUKQ1BVIHRv
IHRyYW5zZmVyIHRoZSBwb3N0ZWQgaW50ZXJydXB0IGluIHRoZSBQSVIgZmllbGQgdG8gdGhlICpW
aXJ0dWFsLUFQSUMgcGFnZSoKKGEgZGF0YSBzdHJ1Y3R1cmUgaW4ga3ZtLCB0aGUgdmlydHVhbCBp
bnRlcnJ1cHRzIGRlbGl2ZXJlZCB0aHJvdWdoIGt2bSBhcmUgcHV0CmhlcmUsIGFuZCBpdCBpcyBh
bHNvIGFjY2Vzc2VkIGJ5IHRoZSBWTVggbWljcm9jb2RlICh0aGUgbGF5b3V0IG1hdGNoZXMgdGhl
IHJlZ2lzdGVyCmxheW91dCBzZWVuIGJ5IHRoZSBndWVzdCkpIG9mIHRoZSB2Q1BVIGFuZCBkaXJl
Y3RseSBkZWxpdmVyIGl0IHRvIHRoZSB2Q1BVLgoKU28gdGhleSBvbmx5IGhhdmUgdG8gc3luYyB0
aGUgUElSIGZpZWxkIHRvIHRoZSBWaXJ0dWFsLUFQSUMgcGFnZSBmb3IgdGhlIG1pZ3JhdGlvbgpz
YXZpbmcsIGFuZCBkbyBub3RoaW5nIGZvciB0aGUgcmVzdW1pbmcuLi4KCkJlc2lkZXMsIG9uIHg4
NiB0aGUgc2V0dGluZyBvZiB0aGUgSVJRIGJ5cGFzcyBpcyBpbmRlcGVuZGVudCBvZiB0aGUgVk0g
aW50ZXJydXB0CnNldHVwLi4uCgpOb3Qgc3VyZSBpZiBJIGhhdmUgbWlzc2VkIHNvbWV0aGluZy4K
CkluIGFkZGl0aW9uLCBJIGZvdW5kIHRoYXQgdGhlIGVuYWJsaW5nIG9mIHRoZSB2QVBJQyBpcyBh
dCB0aGUgZW5kIG9mIHRoZSBtaWdyYXRpb24KKGp1c3QgYmVmb3JlIHRoZSBWTSBzdGFydCkgb24g
eDg2LiBTbyBJIGFtIHdvbmRlcmluZyBpZiB3ZSBjb3VsZCBtb3ZlIHRoZSBjYWxsaW5nCm9mICp2
Z2ljX2VuYWJsZV9scGlzKCkqIGJhY2ssIGFuZCB0cmFuc2ZlciB0aGUgcGVuZGluZyBzdGF0ZSB0
byB0aGUgVlBUIHRoZXJlIGlmIHRoZQppcnEgaXMgaHcgKGFuZCBJIHRoaW5rIHRoZSBzZW1hbnRp
Y3Mgb2YgdGhpcyBmdW5jdGlvbiBzaG91bGQgaW5jbHVkZSB0aGUgdHJhbnNmZXIpLgpJbiBmYWN0
LCB0aGlzIGZ1bmN0aW9uIGlzIGRlcGVuZGVudCBvbiB0aGUgcmVzdG9yaW5nIG9mIHRoZSB2Z2lj
KGxwaV9saXN0KS4uLgoKQWZ0ZXIgZXhwbG9yYXRpb24sIHRoZXJlIHNlZW1zIHRvIGJlIG5vIHBl
cmZlY3QgcGxhY2UgdG8gdHJhbnNmZXIgdGhlIHBlbmRpbmcgc3RhdGVzCnRvIEhXIGluIG9yZGVy
IHRvIGJlIGNvbXBhdGlibGUgd2l0aCB0aGUgZXhpc3RpbmcgaW50ZXJmYWNlIGFuZCB1bmRlciB0
aGUgY3VycmVudAphcmNoaXRlY3R1cmUsIGJ1dCB3ZSBoYXZlIHRvIGNob29zZSBvbmUgc29sdXRp
b24/CgpUaGFua3MsClNoZW5taW5nCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
