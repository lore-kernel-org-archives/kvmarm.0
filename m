Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5DFC56201
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7972C20782
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7972C20782
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5B594BDB8;
	Tue, 24 Nov 2020 09:49:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lgPhShlRKOks; Tue, 24 Nov 2020 09:49:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A1B4BDAD;
	Tue, 24 Nov 2020 09:49:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB1B34BB88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 08:11:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RoCUVH-w5XFv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 08:11:02 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61C194BB0C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 08:11:02 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CgPXG64DNz15Q2Q;
 Tue, 24 Nov 2020 21:10:38 +0800 (CST)
Received: from [10.174.187.74] (10.174.187.74) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 21:10:49 +0800
Subject: Re: [RFC PATCH v1 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
To: Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-3-lushenming@huawei.com>
 <f3ea1b24436bb86b5a5633f8ccc9b3d1@kernel.org>
 <90f04f50-c1ba-55b2-0f93-1e755b40b487@huawei.com>
 <4e2b87897485e38e251c447b9ad70eb6@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <86c2b9ad-7214-caef-0924-ec71b43aa003@huawei.com>
Date: Tue, 24 Nov 2020 21:10:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <4e2b87897485e38e251c447b9ad70eb6@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Tue, 24 Nov 2020 09:49:14 -0500
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

T24gMjAyMC8xMS8yNCAxNjoyNiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMTEtMjQg
MDc6NDAsIFNoZW5taW5nIEx1IHdyb3RlOgo+PiBPbiAyMDIwLzExLzIzIDE3OjE4LCBNYXJjIFp5
bmdpZXIgd3JvdGU6Cj4+PiBPbiAyMDIwLTExLTIzIDA2OjU0LCBTaGVubWluZyBMdSB3cm90ZToK
Pj4+PiBBZnRlciBwYXVzaW5nIGFsbCB2Q1BVcyBhbmQgZGV2aWNlcyBjYXBhYmxlIG9mIGludGVy
cnVwdGluZywgaW4gb3JkZXIKPj4+IMKgwqDCoMKgwqDCoMKgIF5eXl5eXl5eXl5eXl5eXl5eCj4+
PiBTZWUgbXkgY29tbWVudCBiZWxvdyBhYm91dCB0aGlzLgo+Pj4KPj4+PiB0byBzYXZlIHRoZSBp
bmZvcm1hdGlvbiBvZiBhbGwgaW50ZXJydXB0cywgYmVzaWRlcyBmbHVzaGluZyB0aGUgcGVuZGlu
Zwo+Pj4+IHN0YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFsc28gdHJ5IHRvIGZsdXNoIHRoZSBz
dGF0ZXMgb2YgVkxQSXMgaW4gdGhlCj4+Pj4gdmlydHVhbCBwZW5kaW5nIHRhYmxlcyBpbnRvIGd1
ZXN0IFJBTSwgYnV0IHdlIG5lZWQgdG8gaGF2ZSBHSUN2NC4xIGFuZAo+Pj4+IHNhZmVseSB1bm1h
cCB0aGUgdlBFcyBmaXJzdC4KPj4+Pgo+Pj4+IFNpZ25lZC1vZmYtYnk6IFNoZW5taW5nIEx1IDxs
dXNoZW5taW5nQGh1YXdlaS5jb20+Cj4+Pj4gLS0tCj4+Pj4gwqBhcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtdjMuYyB8IDYyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tCj4+Pj4g
wqAxIGZpbGUgY2hhbmdlZCwgNTYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKPj4+Pgo+
Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyBiL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12My5jCj4+Pj4gaW5kZXggOWNkZjM5YTk0YTYzLi5lMWIzYWE0YjJi
MTIgMTAwNjQ0Cj4+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKPj4+PiAr
KysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+Pj4+IEBAIC0xLDYgKzEsOCBAQAo+
Pj4+IMKgLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQo+Pj4+Cj4+Pj4g
wqAjaW5jbHVkZSA8bGludXgvaXJxY2hpcC9hcm0tZ2ljLXYzLmg+Cj4+Pj4gKyNpbmNsdWRlIDxs
aW51eC9pcnEuaD4KPj4+PiArI2luY2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5oPgo+Pj4+IMKgI2lu
Y2x1ZGUgPGxpbnV4L2t2bS5oPgo+Pj4+IMKgI2luY2x1ZGUgPGxpbnV4L2t2bV9ob3N0Lmg+Cj4+
Pj4gwqAjaW5jbHVkZSA8a3ZtL2FybV92Z2ljLmg+Cj4+Pj4gQEAgLTM1Niw2ICszNTgsMzkgQEAg
aW50IHZnaWNfdjNfbHBpX3N5bmNfcGVuZGluZ19zdGF0dXMoc3RydWN0IGt2bQo+Pj4+ICprdm0s
IHN0cnVjdCB2Z2ljX2lycSAqaXJxKQo+Pj4+IMKgwqDCoMKgIHJldHVybiAwOwo+Pj4+IMKgfQo+
Pj4+Cj4+Pj4gKy8qCj4+Pj4gKyAqIFdpdGggR0lDdjQuMSwgd2UgY2FuIGdldCB0aGUgVkxQSSdz
IHBlbmRpbmcgc3RhdGUgYWZ0ZXIgdW5tYXBwaW5nCj4+Pj4gKyAqIHRoZSB2UEUuIFRoZSBkZWFj
dGl2YXRpb24gb2YgdGhlIGRvb3JiZWxsIGludGVycnVwdCB3aWxsIHRyaWdnZXIKPj4+PiArICog
dGhlIHVubWFwcGluZyBvZiB0aGUgYXNzb2NpYXRlZCB2UEUuCj4+Pj4gKyAqLwo+Pj4+ICtzdGF0
aWMgdm9pZCBnZXRfdmxwaV9zdGF0ZV9wcmUoc3RydWN0IHZnaWNfZGlzdCAqZGlzdCkKPj4+PiAr
ewo+Pj4+ICvCoMKgwqAgc3RydWN0IGlycV9kZXNjICpkZXNjOwo+Pj4+ICvCoMKgwqAgaW50IGk7
Cj4+Pj4gKwo+Pj4+ICvCoMKgwqAgaWYgKCFrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0
XzEpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybjsKPj4+PiArCj4+Pj4gK8KgwqDCoCBmb3Ig
KGkgPSAwOyBpIDwgZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykgewo+Pj4+ICvCoMKgwqDCoMKg
wqDCoCBkZXNjID0gaXJxX3RvX2Rlc2MoZGlzdC0+aXRzX3ZtLnZwZXNbaV0tPmlycSk7Cj4+Pj4g
K8KgwqDCoMKgwqDCoMKgIGlycV9kb21haW5fZGVhY3RpdmF0ZV9pcnEoaXJxX2Rlc2NfZ2V0X2ly
cV9kYXRhKGRlc2MpKTsKPj4+PiArwqDCoMKgIH0KPj4+PiArfQo+Pj4+ICsKPj4+PiArc3RhdGlj
IHZvaWQgZ2V0X3ZscGlfc3RhdGVfcG9zdChzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0KQo+Pj4KPj4+
IG5pdDogdGhlIG5hbWluZyBmZWVscyBhIGJpdC4uLiBvZGQuIFByZS9wb3N0IHdoYXQ/Cj4+Cj4+
IE15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCB0aGUgdW5tYXBwaW5nIGlzIGEgcHJlcGFyYXRpb24g
Zm9yIGdldF92bHBpX3N0YXRlLi4uCj4+IE1heWJlIGp1c3QgY2FsbCBpdCB1bm1hcC9tYXBfYWxs
X3ZwZXM/Cj4gCj4gWWVzLCBtdWNoIGJldHRlci4KPiAKPiBbLi4uXQo+IAo+Pj4+ICvCoMKgwqDC
oMKgwqDCoCBpZiAoaXJxLT5odykgewo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdBUk5f
UkFURUxJTUlUKGlycV9nZXRfaXJxY2hpcF9zdGF0ZShpcnEtPmhvc3RfaXJxLAo+Pj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIElSUUNISVBfU1RBVEVf
UEVORElORywgJmlzX3BlbmRpbmcpLAo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAiSVJRICVkIiwgaXJxLT5ob3N0X2lycSk7Cj4+Pgo+Pj4gSXNuJ3Qg
dGhpcyBnb2luZyB0byB3YXJuIGxpa2UgbWFkIG9uIGEgR0lDdjQuMCBzeXN0ZW0gd2hlcmUgdGhp
cywgYnkgZGVmaW5pdGlvbiwKPj4+IHdpbGwgZ2VuZXJhdGUgYW4gZXJyb3I/Cj4+Cj4+IEFzIHdl
IGhhdmUgcmV0dXJuZWQgYW4gZXJyb3IgaW4gc2F2ZV9pdHNfdGFibGVzIGlmIGh3ICYmICFoYXNf
Z2ljdjRfMSwgd2UgZG9uJ3QKPj4gaGF2ZSB0byB3YXJuIHRoaXMgaGVyZT8KPiAKPiBBcmUgeW91
IHJlZmVycmluZyB0byB0aGUgY2hlY2sgaW4gdmdpY19pdHNfc2F2ZV9pdHQoKSB0aGF0IG9jY3Vy
cyBpbiBwYXRjaCA0Pwo+IEZhaXIgZW5vdWdoLCB0aG91Z2ggSSB0aGluayB0aGUgdXNlIG9mIGly
cV9nZXRfaXJxY2hpcF9zdGF0ZSgpIGlzbid0IHF1aXRlCj4gd2hhdCB3ZSB3YW50LCBhcyBwZXIg
bXkgY29tbWVudHMgb24gcGF0Y2ggIzEuCj4gCj4+Pgo+Pj4+ICvCoMKgwqDCoMKgwqDCoCB9Cj4+
Pj4gKwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoc3RvcmVkID09IGlzX3BlbmRpbmcpCj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+Pj4+Cj4+Pj4gLcKgwqDCoMKgwqDC
oMKgIGlmIChpcnEtPnBlbmRpbmdfbGF0Y2gpCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmIChpc19w
ZW5kaW5nKQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2YWwgfD0gMSA8PCBiaXRfbnI7
Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCBlbHNlCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHZhbCAmPSB+KDEgPDwgYml0X25yKTsKPj4+Pgo+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0g
a3ZtX3dyaXRlX2d1ZXN0X2xvY2soa3ZtLCBwdHIsICZ2YWwsIDEpOwo+Pj4+IMKgwqDCoMKgwqDC
oMKgwqAgaWYgKHJldCkKPj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Owo+
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gb3V0Owo+Pj4+IMKgwqDCoMKgIH0KPj4+
PiAtwqDCoMKgIHJldHVybiAwOwo+Pj4+ICsKPj4+PiArb3V0Ogo+Pj4+ICvCoMKgwqAgZ2V0X3Zs
cGlfc3RhdGVfcG9zdChkaXN0KTsKPj4+Cj4+PiBUaGlzIGJpdCB3b3JyaWVzIG1lOiB5b3UgaGF2
ZSB1bm1hcHBlZCB0aGUgVlBFcywgc28gYW55IGludGVycnVwdCB0aGF0IGhhcyBiZWVuCj4+PiBn
ZW5lcmF0ZWQgZHVyaW5nIHRoYXQgcGhhc2UgaXMgbm93IGZvcmV2ZXIgbG9zdCAodGhlIEdJQyBk
b2Vzbid0IGhhdmUgb3duZXJzaGlwCj4+PiBvZiB0aGUgcGVuZGluZyB0YWJsZXMpLgo+Pgo+PiBJ
biBteSBvcGluaW9uLCBkdXJpbmcgdGhpcyBwaGFzZSwgdGhlIGRldmljZXMgY2FwYWJsZSBvZiBp
bnRlcnJ1cHRpbmcKPj4gc2hvdWxkIGhhdmXCoCBhbHJlYWR5IGJlZW4gcGF1c2VkIChwcmV2ZW50
IGZyb20gc2VuZGluZyBpbnRlcnJ1cHRzKSwKPj4gc3VjaCBhcyBWRklPIG1pZ3JhdGlvbiBwcm90
b2NvbCBoYXMgYWxyZWFkeSByZWFsaXplZCBpdC4KPiAKPiBJcyB0aGF0IGEgaGFyZCBndWFyYW50
ZWU/IFBhdXNpbmcgZGV2aWNlcyAqbWF5KiBiZSBwb3NzaWJsZSBmb3IgYSBsaW1pdGVkCj4gc2V0
IG9mIGVuZHBvaW50cywgYnV0IEknbSBub3Qgc3VyZSB0aGF0IGlzIHVuaXZlcnNhbGx5IHBvc3Np
YmxlIHRvIHJlc3RhcnQKPiB0aGVtIGFuZCBleHBlY3QgYSBjb25zaXN0ZW50IHN0YXRlICh5b3Ug
aGF2ZSBqdXN0IGRyb3BwZWQgYSBidW5jaCBvZiBuZXR3b3JrCj4gcGFja2V0cyBvbiB0aGUgZmxv
b3IuLi4pLgoKTm8sIGFzIGZhciBhcyBJIGtub3csIGlmIHRoZSBWRklPIGRldmljZSBkb2VzIG5v
dCBzdXBwb3J0IHBhdXNlLCB0aGUgbWlncmF0aW9uIHdvdWxkCmZhaWwgZWFybHkuLi4gQW5kIHRo
ZSBzcGVjaWZpYyBhY3Rpb24gaXMgZGVjaWRlZCBieSB0aGUgdmVuZG9yIGRyaXZlci4KSW4gZmFj
dCwgdGhlIFZGSU8gbWlncmF0aW9uIGlzIHN0aWxsIGluIGFuIGV4cGVyaW1lbnRhbCBwaGFzZS4u
LiBJIHdpbGwgcGF5IGF0dGVudGlvbgp0byB0aGUgZm9sbG93LXVwIGRldmVsb3BtZW50LgoKPiAK
Pj4+IERvIHlvdSByZWFsbHkgZXhwZWN0IHRoZSBWTSB0byBiZSByZXN0YXJ0YWJsZSBmcm9tIHRo
YXQgcG9pbnQ/IEkgZG9uJ3Qgc2VlIGhvdwo+Pj4gdGhpcyBpcyBwb3NzaWJsZS4KPj4+Cj4+Cj4+
IElmIHRoZSBtaWdyYXRpb24gaGFzIGVuY291bnRlcmVkIGFuIGVycm9yLCB0aGUgc3JjIFZNIG1p
Z2h0IGJlCj4+IHJlc3RhcnRlZCwgc28gd2UgaGF2ZSB0byBtYXAgdGhlIHZQRXMgYmFjay4KPiAK
PiBBcyBJIHNhaWQgYWJvdmUsIEkgZG91YnQgaXQgaXMgdW5pdmVyc2FsbHkgcG9zc2libGUgdG8g
ZG8gc28sIGJ1dAo+IGFmdGVyIGFsbCwgdGhpcyBwcm9iYWJseSBpc24ndCB3b3JzZSB0aGF0IHJl
c3RhcnRpbmcgb24gdGhlIHRhcmdldC4uLgo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
