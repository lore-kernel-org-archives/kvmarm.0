Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6D1C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 08:42:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A420820723
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 08:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A420820723
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 382204B211;
	Wed, 27 May 2020 04:42:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lHOglz26wKVz; Wed, 27 May 2020 04:42:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 330014B1BB;
	Wed, 27 May 2020 04:42:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 741114B199
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 04:42:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EemuAlSztFSD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 04:42:25 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8B1A4B172
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 04:42:24 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id BB54F1344ACB74EED863;
 Wed, 27 May 2020 16:42:21 +0800 (CST)
Received: from [10.173.222.27] (10.173.222.27) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Wed, 27 May 2020 16:42:14 +0800
Subject: Re: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
To: Marc Zyngier <maz@kernel.org>
References: <20200526161136.451312-1-maz@kernel.org>
 <47d6d521-f05e-86fe-4a94-ce21754100ae@huawei.com>
 <1d3658f4b92a690ba05367f2a22a7331@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <628e9f4b-0587-bde6-05f3-6877e37bd659@huawei.com>
Date: Wed, 27 May 2020 16:42:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1d3658f4b92a690ba05367f2a22a7331@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYywKCk9uIDIwMjAvNS8yNyAxNTo1NSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFpl
bmdodWksCj4gCj4gT24gMjAyMC0wNS0yNyAwODo0MSwgWmVuZ2h1aSBZdSB3cm90ZToKPj4gT24g
MjAyMC81LzI3IDA6MTEsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IE9uIGEgc3lzdGVtIHRoYXQg
dXNlcyBTUElzIHRvIGltcGxlbWVudCBNU0lzIChhcyBpdCB3b3VsZCBiZQo+Pj4gdGhlIGNhc2Ug
b24gYSBHSUN2MiBzeXN0ZW0gZXhwb3NpbmcgYSBHSUN2Mm0gdG8gaXRzIGd1ZXN0cyksCj4+PiB3
ZSBkZW55IHRoZSBwb3NzaWJpbGl0eSBvZiBpbmplY3RpbmcgU1BJcyBvbiB0aGUgaW4tYXRvbWlj
Cj4+PiBmYXN0LXBhdGguCj4+Pgo+Pj4gVGhpcyByZXN1bHRzIGluIGEgdmVyeSBsYXJnZSBhbW91
bnQgb2YgY29udGV4dC1zd2l0Y2hlcwo+Pj4gKHJvdWdobHkgZXF1aXZhbGVudCB0byB0d2ljZSB0
aGUgaW50ZXJydXB0IHJhdGUpIG9uIHRoZSBob3N0LAo+Pj4gYW5kIHN1Ym9wdGltYWwgcGVyZm9y
bWFuY2UgZm9yIHRoZSBndWVzdCAoYXMgbWVhc3VyZWQgd2l0aAo+Pj4gYSB0ZXN0IHdvcmtsb2Fk
IGludm9sdmluZyBhIHZpcnRpbyBpbnRlcmZhY2UgYmFja2VkIGJ5IHZob3N0LW5ldCkuCj4+PiBH
aXZlbiB0aGF0IEdJQ3YyIHN5c3RlbXMgYXJlIHVzdWFsbHkgb24gdGhlIGxvdy1lbmQgb2YgdGhl
IHNwZWN0cnVtCj4+PiBwZXJmb3JtYW5jZSB3aXNlLCB0aGV5IGNvdWxkIGRvIHdpdGhvdXQgdGhl
IGFnZ3JhdmF0aW9uLgo+Pj4KPj4+IFdlIHNvbHZlZCB0aGlzIGZvciBHSUN2MytJVFMgYnkgaGF2
aW5nIGEgdHJhbnNsYXRpb24gY2FjaGUuIEJ1dAo+Pj4gU1BJcyBkbyBub3QgbmVlZCBhbnkgZXh0
cmEgaW5mcmFzdHJ1Y3R1cmUsIGFuZCBjYW4gYmUgaW1tZWRpYXRlbHkKPj4+IGluamVjdGVkIGlu
IHRoZSB2aXJ0dWFsIGRpc3RyaWJ1dG9yIGFzIHRoZSBsb2NraW5nIGlzIGFscmVhZHkKPj4+IGhl
YXZ5IGVub3VnaCB0aGF0IHdlIGRvbid0IG5lZWQgdG8gd29ycnkgYWJvdXQgYW55dGhpbmcuCj4+
Pgo+Pj4gVGhpcyBoYWx2ZXMgdGhlIG51bWJlciBvZiBjb250ZXh0IHN3aXRjaGVzIGZvciB0aGUg
c2FtZSB3b3JrbG9hZC4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBr
ZXJuZWwub3JnPgo+Pj4gLS0tCj4+PiDCoCBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJxZmQu
YyB8IDIwICsrKysrKysrKysrKysrKystLS0tCj4+PiDCoCBhcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtaXRzLmPCoMKgIHzCoCAzICstLQo+Pj4gwqAgMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRp
b25zKCspLCA2IGRlbGV0aW9ucygtKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtaXJxZmQuYyAKPj4+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycWZk
LmMKPj4+IGluZGV4IGQ4Y2RmZWE1Y2M5Ni4uMTFhOWY4MTExNWFiIDEwMDY0NAo+Pj4gLS0tIGEv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycWZkLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy1pcnFmZC5jCj4+PiBAQCAtMTA3LDE1ICsxMDcsMjcgQEAgaW50IGt2bV9hcmNo
X3NldF9pcnFfaW5hdG9taWMoc3RydWN0IAo+Pj4ga3ZtX2tlcm5lbF9pcnFfcm91dGluZ19lbnRy
eSAqZSwKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBr
dm0gKmt2bSwgaW50IGlycV9zb3VyY2VfaWQsIGludCBsZXZlbCwKPj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgbGluZV9zdGF0dXMpCj4+Cj4+IC4uLiBhbmQg
eW91IG1heSBhbHNvIG5lZWQgdG8gdXBkYXRlIHRoZSBjb21tZW50IG9uIHRvcCBvZiBpdCB0bwo+
PiByZWZsZWN0IHRoaXMgY2hhbmdlLgo+Pgo+PiAvKioKPj4gwqAqIGt2bV9hcmNoX3NldF9pcnFf
aW5hdG9taWM6IGZhc3QtcGF0aCBmb3IgaXJxZmQgaW5qZWN0aW9uCj4+IMKgKgo+PiDCoCogQ3Vy
cmVudGx5IG9ubHkgZGlyZWN0IE1TSSBpbmplY3Rpb24gaXMgc3VwcG9ydGVkLgo+PiDCoCovCj4g
Cj4gQXMgZmFyIGFzIEkgY2FuIHRlbGwsIGl0IGlzIHN0aWxsIHZhbGlkIChhdCBsZWFzdCBmcm9t
IHRoZSBndWVzdCdzCj4gcGVyc3BlY3RpdmUpLiBZb3UgY291bGQgaW4gcHJhY3RpY2UgdXNlIHRo
YXQgdG8gZGVhbCB3aXRoIGxldmVsCj4gaW50ZXJydXB0cywgYnV0IHdlIG9ubHkgaW5qZWN0IHRo
ZSByaXNpbmcgZWRnZSBvbiB0aGlzIHBhdGgsIG5ldmVyCj4gdGhlIGZhbGxpbmcgZWRnZS4gU28g
ZWZmZWN0aXZlbHksIHRoaXMgaXMgbGltaXRlZCB0byBlZGdlIGludGVycnVwdHMsCj4gd2hpY2gg
aXMgbW9zdGx5IE1TSXMuCgpPb3BzLi4uIEkgaGFkIHdyb25nbHkgbWl4ZWQgTVNJIHdpdGggdGhl
IGFyY2hpdGVjdHVyZS1kZWZpbmVkIExQSSwgYW5kCndhcyB0aGluayB0aGF0IHdlIHNob3VsZCBh
ZGQgc29tZXRoaW5nIGxpa2UgImRpcmVjdCBTUEkgaW5qZWN0aW9uIGlzCmFsc28gc3VwcG9ydGVk
IG5vdyIuIFNvcnJ5LgoKPiAKPiBVbmxlc3MgeW91IGFyZSB0aGlua2luZyBvZiBzb21ldGhpbmcg
ZWxzZSB3aGljaCBJIHdvdWxkIGhhdmUgbWlzc2VkPwoKTm8sIHBsZWFzZSBpZ25vcmUgdGhlIG5v
aXN5LgoKClRoYW5rcywKWmVuZ2h1aQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
