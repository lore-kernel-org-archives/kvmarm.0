Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA384C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 12:32:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 492A864FE0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 12:32:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 492A864FE0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99ADA4B3B0;
	Fri, 12 Mar 2021 07:32:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kQ4EH3ze24fA; Fri, 12 Mar 2021 07:32:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8115A4B2F7;
	Fri, 12 Mar 2021 07:32:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6880B4B2E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 07:32:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CAtRjZrNLouY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 07:32:12 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 021654B20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 07:32:11 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DxlWs2tZfzrTqr;
 Fri, 12 Mar 2021 20:30:17 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 20:31:56 +0800
Subject: Re: [PATCH v3 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state
 to physical side
To: Marc Zyngier <maz@kernel.org>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-4-lushenming@huawei.com> <87tupif3x3.wl-maz@kernel.org>
 <0820f429-4c29-acd6-d9e0-af9f6deb68e4@huawei.com>
 <87k0qcg2s6.wl-maz@kernel.org>
 <aecfbf72-c653-e967-b539-89f629b52cde@huawei.com>
 <87h7lgfwzu.wl-maz@kernel.org>
 <df4b939d-27c1-be84-ea7e-327251958cde@huawei.com>
 <87ft10fulr.wl-maz@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <40f40432-63b4-cceb-a9bd-09c6ef91f34d@huawei.com>
Date: Fri, 12 Mar 2021 20:31:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87ft10fulr.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alex Williamson <alex.williamson@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gMjAyMS8zLzEyIDIwOjAyLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gRnJpLCAxMiBNYXIg
MjAyMSAxMTozNDowNyArMDAwMCwKPiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29t
PiB3cm90ZToKPj4KPj4gT24gMjAyMS8zLzEyIDE5OjEwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+
PiBPbiBGcmksIDEyIE1hciAyMDIxIDEwOjQ4OjI5ICswMDAwLAo+Pj4gU2hlbm1pbmcgTHUgPGx1
c2hlbm1pbmdAaHVhd2VpLmNvbT4gd3JvdGU6Cj4+Pj4KPj4+PiBPbiAyMDIxLzMvMTIgMTc6MDUs
IE1hcmMgWnluZ2llciB3cm90ZToKPj4+Pj4gT24gVGh1LCAxMSBNYXIgMjAyMSAxMjozMjowNyAr
MDAwMCwKPj4+Pj4gU2hlbm1pbmcgTHUgPGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4gd3JvdGU6Cj4+
Pj4+Pgo+Pj4+Pj4gT24gMjAyMS8zLzExIDE3OjE0LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4+
Pj4gT24gV2VkLCAyNyBKYW4gMjAyMSAxMjoxMzozNiArMDAwMCwKPj4+Pj4+PiBTaGVubWluZyBM
dSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPiB3cm90ZToKPj4+Pj4+Pj4KPj4+Pj4+Pj4gRnJvbTog
WmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+Pj4+Pj4+Cj4+Pj4+Pj4+IFdoZW4g
c2V0dGluZyB0aGUgZm9yd2FyZGluZyBwYXRoIG9mIGEgVkxQSSAoc3dpdGNoIHRvIHRoZSBIVyBt
b2RlKSwKPj4+Pj4+Pj4gd2UgY291bGQgYWxzbyB0cmFuc2ZlciB0aGUgcGVuZGluZyBzdGF0ZSBm
cm9tIGlycS0+cGVuZGluZ19sYXRjaCB0bwo+Pj4+Pj4+PiBWUFQgKGVzcGVjaWFsbHkgaW4gbWln
cmF0aW9uLCB0aGUgcGVuZGluZyBzdGF0ZXMgb2YgVkxQSXMgYXJlIHJlc3RvcmVkCj4+Pj4+Pj4+
IGludG8ga3Zt4oCZcyB2Z2ljIGZpcnN0KS4gQW5kIHdlIGN1cnJlbnRseSBzZW5kICJJTlQrVlNZ
TkMiIHRvIHRyaWdnZXIKPj4+Pj4+Pj4gYSBWTFBJIHRvIHBlbmRpbmcuCj4+Pj4+Pj4+Cj4+Pj4+
Pj4+IFNpZ25lZC1vZmYtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+Pj4+
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+
Pj4+Pj4+PiAtLS0KPj4+Pj4+Pj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jIHwgMTQg
KysrKysrKysrKysrKysKPj4+Pj4+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCsp
Cj4+Pj4+Pj4+Cj4+Pj4+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djQuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+Pj4+Pj4+IGluZGV4IGFjMDI5
YmEzZDMzNy4uYTM1NDJhZjZmMDRhIDEwMDY0NAo+Pj4+Pj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtdjQuYwo+Pj4+Pj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djQuYwo+Pj4+Pj4+PiBAQCAtNDQ5LDYgKzQ0OSwyMCBAQCBpbnQga3ZtX3ZnaWNfdjRfc2V0X2Zv
cndhcmRpbmcoc3RydWN0IGt2bSAqa3ZtLCBpbnQgdmlycSwKPj4+Pj4+Pj4gIAlpcnEtPmhvc3Rf
aXJxCT0gdmlycTsKPj4+Pj4+Pj4gIAlhdG9taWNfaW5jKCZtYXAudnBlLT52bHBpX2NvdW50KTsK
Pj4+Pj4+Pj4gIAo+Pj4+Pj4+PiArCS8qIFRyYW5zZmVyIHBlbmRpbmcgc3RhdGUgKi8KPj4+Pj4+
Pj4gKwlpZiAoaXJxLT5wZW5kaW5nX2xhdGNoKSB7Cj4+Pj4+Pj4+ICsJCXJldCA9IGlycV9zZXRf
aXJxY2hpcF9zdGF0ZShpcnEtPmhvc3RfaXJxLAo+Pj4+Pj4+PiArCQkJCQkgICAgSVJRQ0hJUF9T
VEFURV9QRU5ESU5HLAo+Pj4+Pj4+PiArCQkJCQkgICAgaXJxLT5wZW5kaW5nX2xhdGNoKTsKPj4+
Pj4+Pj4gKwkJV0FSTl9SQVRFTElNSVQocmV0LCAiSVJRICVkIiwgaXJxLT5ob3N0X2lycSk7Cj4+
Pj4+Pj4+ICsKPj4+Pj4+Pj4gKwkJLyoKPj4+Pj4+Pj4gKwkJICogTGV0IGl0IGJlIHBydW5lZCBm
cm9tIGFwX2xpc3QgbGF0ZXIgYW5kIGRvbid0IGJvdGhlcgo+Pj4+Pj4+PiArCQkgKiB0aGUgTGlz
dCBSZWdpc3Rlci4KPj4+Pj4+Pj4gKwkJICovCj4+Pj4+Pj4+ICsJCWlycS0+cGVuZGluZ19sYXRj
aCA9IGZhbHNlOwo+Pj4+Pj4+Cj4+Pj4+Pj4gTkFLLiBJZiB0aGUgaW50ZXJydXB0IGlzIG9uIHRo
ZSBBUCBsaXN0LCBpdCBtdXN0IGJlIHBydW5lZCBmcm9tIGl0Cj4+Pj4+Pj4gKmltbWVkaWF0ZWx5
Ki4gVGhlIG9ubHkgY2FzZSB3aGVyZSBpdCBjYW4gYmUgIXBlbmRpbmcgYW5kIHN0aWxsIG9uIHRo
ZQo+Pj4+Pj4+IEFQIGxpc3QgaXMgaW4gaW50ZXJ2YWwgYmV0d2VlbiBzeW5jIGFuZCBwcnVuZS4g
SWYgd2Ugc3RhcnQgbWVzc2luZwo+Pj4+Pj4+IHdpdGggdGhpcywgd2UgY2FuJ3QgcmVhc29uIGFi
b3V0IHRoZSBzdGF0ZSBvZiB0aGlzIGxpc3QgYW55bW9yZS4KPj4+Pj4+Pgo+Pj4+Pj4+IENvbnNp
ZGVyIGNhbGxpbmcgdmdpY19xdWV1ZV9pcnFfdW5sb2NrKCkgaGVyZS4KPj4+Pj4+Cj4+Pj4+PiBU
aGFua3MgZm9yIGdpdmluZyBhIGhpbnQsIGJ1dCBpdCBzZWVtcyB0aGF0IHZnaWNfcXVldWVfaXJx
X3VubG9jaygpIG9ubHkKPj4+Pj4+IHF1ZXVlcyBhbiBJUlEgYWZ0ZXIgY2hlY2tpbmcsIGRpZCB5
b3UgbWVhbiB2Z2ljX3BydW5lX2FwX2xpc3QoKSBpbnN0ZWFkPwo+Pj4+Pgo+Pj4+PiBObywgSSBy
ZWFsbHkgbWVhbiB2Z2ljX3F1ZXVlX2lycV91bmxvY2soKS4gSXQgY2FuIGJlIHVzZWQgdG8gcmVt
b3ZlCj4+Pj4+IHRoZSBwZW5kaW5nIHN0YXRlIGZyb20gYW4gaW50ZXJydXB0LCBhbmQgZHJvcCBp
dCBmcm9tIHRoZSBBUAo+Pj4+PiBsaXN0LiBUaGlzIGlzIGV4YWN0bHkgd2hhdCBoYXBwZW5zIHdo
ZW4gY2xlYXJpbmcgdGhlIHBlbmRpbmcgc3RhdGUgb2YKPj4+Pj4gYSBsZXZlbCBpbnRlcnJ1cHQs
IGZvciBleGFtcGxlLgo+Pj4+Cj4+Pj4gSGksIEkgaGF2ZSBnb25lIHRocm91Z2ggdmdpY19xdWV1
ZV9pcnFfdW5sb2NrIG1vcmUgdGhhbiBvbmNlLCBidXQKPj4+PiBzdGlsbCBjYW4ndCBmaW5kIHRo
ZSBwbGFjZSBpbiBpdCB0byBkcm9wIGFuIElSUSBmcm9tIHRoZSBBUAo+Pj4+IGxpc3QuLi4gRGlk
IEkgbWlzcyBzb21ldGhpbmcgPy4uLiAgT3IgY291bGQgeW91IGhlbHAgdG8gcG9pbnQgaXQKPj4+
PiBvdXQ/IFRoYW5rcyB2ZXJ5IG11Y2ggZm9yIHRoaXMhCj4+Pgo+Pj4gTk8sIHlvdSBhcmUgcmln
aHQuIEkgdGhpbmsgdGhpcyBpcyBhIG1pc3Npbmcgb3B0aW1pc2F0aW9uLiBQbGVhc2UgY2FsbAo+
Pj4gdGhlIGZ1bmN0aW9uIGFueXdheSwgYXMgdGhhdCdzIHdoYXQgaXMgcmVxdWlyZWQgdG8gY29t
bXVuaWNhdGUgYQo+Pj4gY2hhbmdlIG9mIHN0YXRlIGluIGdlbmVyYWwuPgo+Pj4gSSdsbCBoYXZl
IGEgdGhpbmsgYWJvdXQgaXQuCj4+Cj4+IE1heWJlIHdlIGNvdWxkIGNhbGwgdmdpY19wcnVuZV9h
cF9saXN0KCkgaWYgKGlycS0+dmNwdSAmJgo+PiAhdmdpY190YXJnZXRfb3JhY2xlKGlycSkpIGlu
IHZnaWNfcXVldWVfaXJxX3VubG9jaygpLi4uCj4gCj4gVGhlIGxvY2tpbmcgaXMgcHJldHR5IHVn
bHkgaW4gdGhpcyBjYXNlLCBhbmQgSSBkb24ndCB3YW50IHRvIHJlcGFyc2UKPiB0aGUgd2hvbGUg
QVAgbGlzdC4gSXQgaXMgYmFzaWNhbGx5IGRvaW5nIHRoZSBzYW1lIHdvcmsgYXMgdGhlCj4gaW5z
ZXJ0aW9uLCBidXQgd2l0aCBhIGxpc3RfZGVsKCkgaW5zdGVhZCBvZiBhIGxpc3RfYWRkKCkuLi4K
Cm1ha2Ugc2Vuc2UuLgoKVGhhbmtzLApTaGVubWluZwoKPiAKPiBXZSBjYW4gbGl2ZSB3aXRob3V0
IGl0IGZvciBub3cuCj4gCj4+IE9LLCBJIHdpbGwgcmV0ZXN0IHRoaXMgc2VyaWVzIGFuZCBzZW5k
IGEgdjQgc29vbi4gOi0pCj4gCj4gVGhhbmtzLAo+IAo+IAlNLgo+IApfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
