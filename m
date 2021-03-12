Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3215C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 11:34:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF18D64FC3
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 11:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF18D64FC3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A3F54B2FD;
	Fri, 12 Mar 2021 06:34:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G0HyASMAQ5co; Fri, 12 Mar 2021 06:34:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C7F14B30B;
	Fri, 12 Mar 2021 06:34:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2CF84B30B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 06:34:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Amui+j9Zgd4m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 06:34:32 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F20E4B2FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 06:34:31 -0500 (EST)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DxkDk5yxmzNlm9;
 Fri, 12 Mar 2021 19:32:06 +0800 (CST)
Received: from [10.174.184.135] (10.174.184.135) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 19:34:18 +0800
Subject: Re: [PATCH v3 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state
 to physical side
To: Marc Zyngier <maz@kernel.org>
References: <20210127121337.1092-1-lushenming@huawei.com>
 <20210127121337.1092-4-lushenming@huawei.com> <87tupif3x3.wl-maz@kernel.org>
 <0820f429-4c29-acd6-d9e0-af9f6deb68e4@huawei.com>
 <87k0qcg2s6.wl-maz@kernel.org>
 <aecfbf72-c653-e967-b539-89f629b52cde@huawei.com>
 <87h7lgfwzu.wl-maz@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <df4b939d-27c1-be84-ea7e-327251958cde@huawei.com>
Date: Fri, 12 Mar 2021 19:34:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <87h7lgfwzu.wl-maz@kernel.org>
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

T24gMjAyMS8zLzEyIDE5OjEwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gRnJpLCAxMiBNYXIg
MjAyMSAxMDo0ODoyOSArMDAwMCwKPiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29t
PiB3cm90ZToKPj4KPj4gT24gMjAyMS8zLzEyIDE3OjA1LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+
PiBPbiBUaHUsIDExIE1hciAyMDIxIDEyOjMyOjA3ICswMDAwLAo+Pj4gU2hlbm1pbmcgTHUgPGx1
c2hlbm1pbmdAaHVhd2VpLmNvbT4gd3JvdGU6Cj4+Pj4KPj4+PiBPbiAyMDIxLzMvMTEgMTc6MTQs
IE1hcmMgWnluZ2llciB3cm90ZToKPj4+Pj4gT24gV2VkLCAyNyBKYW4gMjAyMSAxMjoxMzozNiAr
MDAwMCwKPj4+Pj4gU2hlbm1pbmcgTHUgPGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4gd3JvdGU6Cj4+
Pj4+Pgo+Pj4+Pj4gRnJvbTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+Pj4+
Pgo+Pj4+Pj4gV2hlbiBzZXR0aW5nIHRoZSBmb3J3YXJkaW5nIHBhdGggb2YgYSBWTFBJIChzd2l0
Y2ggdG8gdGhlIEhXIG1vZGUpLAo+Pj4+Pj4gd2UgY291bGQgYWxzbyB0cmFuc2ZlciB0aGUgcGVu
ZGluZyBzdGF0ZSBmcm9tIGlycS0+cGVuZGluZ19sYXRjaCB0bwo+Pj4+Pj4gVlBUIChlc3BlY2lh
bGx5IGluIG1pZ3JhdGlvbiwgdGhlIHBlbmRpbmcgc3RhdGVzIG9mIFZMUElzIGFyZSByZXN0b3Jl
ZAo+Pj4+Pj4gaW50byBrdm3igJlzIHZnaWMgZmlyc3QpLiBBbmQgd2UgY3VycmVudGx5IHNlbmQg
IklOVCtWU1lOQyIgdG8gdHJpZ2dlcgo+Pj4+Pj4gYSBWTFBJIHRvIHBlbmRpbmcuCj4+Pj4+Pgo+
Pj4+Pj4gU2lnbmVkLW9mZi1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+
Pj4+Pj4gLS0tCj4+Pj4+PiAgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMgfCAxNCArKysr
KysrKysrKysrKwo+Pj4+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspCj4+Pj4+
Pgo+Pj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jIGIvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4+Pj4+IGluZGV4IGFjMDI5YmEzZDMzNy4uYTM1
NDJhZjZmMDRhIDEwMDY0NAo+Pj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0
LmMKPj4+Pj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+Pj4+PiBAQCAt
NDQ5LDYgKzQ0OSwyMCBAQCBpbnQga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoc3RydWN0IGt2
bSAqa3ZtLCBpbnQgdmlycSwKPj4+Pj4+ICAJaXJxLT5ob3N0X2lycQk9IHZpcnE7Cj4+Pj4+PiAg
CWF0b21pY19pbmMoJm1hcC52cGUtPnZscGlfY291bnQpOwo+Pj4+Pj4gIAo+Pj4+Pj4gKwkvKiBU
cmFuc2ZlciBwZW5kaW5nIHN0YXRlICovCj4+Pj4+PiArCWlmIChpcnEtPnBlbmRpbmdfbGF0Y2gp
IHsKPj4+Pj4+ICsJCXJldCA9IGlycV9zZXRfaXJxY2hpcF9zdGF0ZShpcnEtPmhvc3RfaXJxLAo+
Pj4+Pj4gKwkJCQkJICAgIElSUUNISVBfU1RBVEVfUEVORElORywKPj4+Pj4+ICsJCQkJCSAgICBp
cnEtPnBlbmRpbmdfbGF0Y2gpOwo+Pj4+Pj4gKwkJV0FSTl9SQVRFTElNSVQocmV0LCAiSVJRICVk
IiwgaXJxLT5ob3N0X2lycSk7Cj4+Pj4+PiArCj4+Pj4+PiArCQkvKgo+Pj4+Pj4gKwkJICogTGV0
IGl0IGJlIHBydW5lZCBmcm9tIGFwX2xpc3QgbGF0ZXIgYW5kIGRvbid0IGJvdGhlcgo+Pj4+Pj4g
KwkJICogdGhlIExpc3QgUmVnaXN0ZXIuCj4+Pj4+PiArCQkgKi8KPj4+Pj4+ICsJCWlycS0+cGVu
ZGluZ19sYXRjaCA9IGZhbHNlOwo+Pj4+Pgo+Pj4+PiBOQUsuIElmIHRoZSBpbnRlcnJ1cHQgaXMg
b24gdGhlIEFQIGxpc3QsIGl0IG11c3QgYmUgcHJ1bmVkIGZyb20gaXQKPj4+Pj4gKmltbWVkaWF0
ZWx5Ki4gVGhlIG9ubHkgY2FzZSB3aGVyZSBpdCBjYW4gYmUgIXBlbmRpbmcgYW5kIHN0aWxsIG9u
IHRoZQo+Pj4+PiBBUCBsaXN0IGlzIGluIGludGVydmFsIGJldHdlZW4gc3luYyBhbmQgcHJ1bmUu
IElmIHdlIHN0YXJ0IG1lc3NpbmcKPj4+Pj4gd2l0aCB0aGlzLCB3ZSBjYW4ndCByZWFzb24gYWJv
dXQgdGhlIHN0YXRlIG9mIHRoaXMgbGlzdCBhbnltb3JlLgo+Pj4+Pgo+Pj4+PiBDb25zaWRlciBj
YWxsaW5nIHZnaWNfcXVldWVfaXJxX3VubG9jaygpIGhlcmUuCj4+Pj4KPj4+PiBUaGFua3MgZm9y
IGdpdmluZyBhIGhpbnQsIGJ1dCBpdCBzZWVtcyB0aGF0IHZnaWNfcXVldWVfaXJxX3VubG9jaygp
IG9ubHkKPj4+PiBxdWV1ZXMgYW4gSVJRIGFmdGVyIGNoZWNraW5nLCBkaWQgeW91IG1lYW4gdmdp
Y19wcnVuZV9hcF9saXN0KCkgaW5zdGVhZD8KPj4+Cj4+PiBObywgSSByZWFsbHkgbWVhbiB2Z2lj
X3F1ZXVlX2lycV91bmxvY2soKS4gSXQgY2FuIGJlIHVzZWQgdG8gcmVtb3ZlCj4+PiB0aGUgcGVu
ZGluZyBzdGF0ZSBmcm9tIGFuIGludGVycnVwdCwgYW5kIGRyb3AgaXQgZnJvbSB0aGUgQVAKPj4+
IGxpc3QuIFRoaXMgaXMgZXhhY3RseSB3aGF0IGhhcHBlbnMgd2hlbiBjbGVhcmluZyB0aGUgcGVu
ZGluZyBzdGF0ZSBvZgo+Pj4gYSBsZXZlbCBpbnRlcnJ1cHQsIGZvciBleGFtcGxlLgo+Pgo+PiBI
aSwgSSBoYXZlIGdvbmUgdGhyb3VnaCB2Z2ljX3F1ZXVlX2lycV91bmxvY2sgbW9yZSB0aGFuIG9u
Y2UsIGJ1dAo+PiBzdGlsbCBjYW4ndCBmaW5kIHRoZSBwbGFjZSBpbiBpdCB0byBkcm9wIGFuIElS
USBmcm9tIHRoZSBBUAo+PiBsaXN0Li4uIERpZCBJIG1pc3Mgc29tZXRoaW5nID8uLi4gIE9yIGNv
dWxkIHlvdSBoZWxwIHRvIHBvaW50IGl0Cj4+IG91dD8gVGhhbmtzIHZlcnkgbXVjaCBmb3IgdGhp
cyEKPiAKPiBOTywgeW91IGFyZSByaWdodC4gSSB0aGluayB0aGlzIGlzIGEgbWlzc2luZyBvcHRp
bWlzYXRpb24uIFBsZWFzZSBjYWxsCj4gdGhlIGZ1bmN0aW9uIGFueXdheSwgYXMgdGhhdCdzIHdo
YXQgaXMgcmVxdWlyZWQgdG8gY29tbXVuaWNhdGUgYQo+IGNoYW5nZSBvZiBzdGF0ZSBpbiBnZW5l
cmFsLj4KPiBJJ2xsIGhhdmUgYSB0aGluayBhYm91dCBpdC4KCk1heWJlIHdlIGNvdWxkIGNhbGwg
dmdpY19wcnVuZV9hcF9saXN0KCkgaWYgKGlycS0+dmNwdSAmJiAhdmdpY190YXJnZXRfb3JhY2xl
KGlycSkpIGluIHZnaWNfcXVldWVfaXJxX3VubG9jaygpLi4uCgpPSywgSSB3aWxsIHJldGVzdCB0
aGlzIHNlcmllcyBhbmQgc2VuZCBhIHY0IHNvb24uIDotKQoKVGhhbmtzLApTaGVubWluZwoKPiAK
PiBUaGFua3MsCj4gCj4gCU0uCj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
