Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC29C63798
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C33F2086A
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C33F2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9984BDB5;
	Tue, 24 Nov 2020 09:49:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H+JN4bRgoSOe; Tue, 24 Nov 2020 09:49:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 395D14BDA4;
	Tue, 24 Nov 2020 09:49:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6AA44BCE7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 02:40:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MofRZkr452au for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 02:40:26 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC8D94BC96
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 02:40:25 -0500 (EST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CgGBp5scLz71kd;
 Tue, 24 Nov 2020 15:40:02 +0800 (CST)
Received: from [10.174.187.74] (10.174.187.74) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 15:40:14 +0800
Subject: Re: [RFC PATCH v1 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
To: Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-3-lushenming@huawei.com>
 <f3ea1b24436bb86b5a5633f8ccc9b3d1@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <90f04f50-c1ba-55b2-0f93-1e755b40b487@huawei.com>
Date: Tue, 24 Nov 2020 15:40:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <f3ea1b24436bb86b5a5633f8ccc9b3d1@kernel.org>
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

T24gMjAyMC8xMS8yMyAxNzoxOCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMTEtMjMg
MDY6NTQsIFNoZW5taW5nIEx1IHdyb3RlOgo+PiBBZnRlciBwYXVzaW5nIGFsbCB2Q1BVcyBhbmQg
ZGV2aWNlcyBjYXBhYmxlIG9mIGludGVycnVwdGluZywgaW4gb3JkZXIKPiDCoMKgwqDCoMKgwqDC
oCBeXl5eXl5eXl5eXl5eXl5eXgo+IFNlZSBteSBjb21tZW50IGJlbG93IGFib3V0IHRoaXMuCj4g
Cj4+IHRvIHNhdmUgdGhlIGluZm9ybWF0aW9uIG9mIGFsbCBpbnRlcnJ1cHRzLCBiZXNpZGVzIGZs
dXNoaW5nIHRoZSBwZW5kaW5nCj4+IHN0YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFsc28gdHJ5
IHRvIGZsdXNoIHRoZSBzdGF0ZXMgb2YgVkxQSXMgaW4gdGhlCj4+IHZpcnR1YWwgcGVuZGluZyB0
YWJsZXMgaW50byBndWVzdCBSQU0sIGJ1dCB3ZSBuZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQKPj4g
c2FmZWx5IHVubWFwIHRoZSB2UEVzIGZpcnN0Lgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBTaGVubWlu
ZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+PiAtLS0KPj4gwqBhcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtdjMuYyB8IDYyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tCj4+
IMKgMSBmaWxlIGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4+Cj4+
IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyBiL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy12My5jCj4+IGluZGV4IDljZGYzOWE5NGE2My4uZTFiM2FhNGIyYjEyIDEw
MDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+PiArKysgYi9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+PiBAQCAtMSw2ICsxLDggQEAKPj4gwqAvLyBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5Cj4+Cj4+IMKgI2luY2x1ZGUgPGxpbnV4
L2lycWNoaXAvYXJtLWdpYy12My5oPgo+PiArI2luY2x1ZGUgPGxpbnV4L2lycS5oPgo+PiArI2lu
Y2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5oPgo+PiDCoCNpbmNsdWRlIDxsaW51eC9rdm0uaD4KPj4g
wqAjaW5jbHVkZSA8bGludXgva3ZtX2hvc3QuaD4KPj4gwqAjaW5jbHVkZSA8a3ZtL2FybV92Z2lj
Lmg+Cj4+IEBAIC0zNTYsNiArMzU4LDM5IEBAIGludCB2Z2ljX3YzX2xwaV9zeW5jX3BlbmRpbmdf
c3RhdHVzKHN0cnVjdCBrdm0KPj4gKmt2bSwgc3RydWN0IHZnaWNfaXJxICppcnEpCj4+IMKgwqDC
oMKgIHJldHVybiAwOwo+PiDCoH0KPj4KPj4gKy8qCj4+ICsgKiBXaXRoIEdJQ3Y0LjEsIHdlIGNh
biBnZXQgdGhlIFZMUEkncyBwZW5kaW5nIHN0YXRlIGFmdGVyIHVubWFwcGluZwo+PiArICogdGhl
IHZQRS4gVGhlIGRlYWN0aXZhdGlvbiBvZiB0aGUgZG9vcmJlbGwgaW50ZXJydXB0IHdpbGwgdHJp
Z2dlcgo+PiArICogdGhlIHVubWFwcGluZyBvZiB0aGUgYXNzb2NpYXRlZCB2UEUuCj4+ICsgKi8K
Pj4gK3N0YXRpYyB2b2lkIGdldF92bHBpX3N0YXRlX3ByZShzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0
KQo+PiArewo+PiArwqDCoMKgIHN0cnVjdCBpcnFfZGVzYyAqZGVzYzsKPj4gK8KgwqDCoCBpbnQg
aTsKPj4gKwo+PiArwqDCoMKgIGlmICgha3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLmhhc19naWN2NF8x
KQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+PiArCj4+ICvCoMKgwqAgZm9yIChpID0gMDsg
aSA8IGRpc3QtPml0c192bS5ucl92cGVzOyBpKyspIHsKPj4gK8KgwqDCoMKgwqDCoMKgIGRlc2Mg
PSBpcnFfdG9fZGVzYyhkaXN0LT5pdHNfdm0udnBlc1tpXS0+aXJxKTsKPj4gK8KgwqDCoMKgwqDC
oMKgIGlycV9kb21haW5fZGVhY3RpdmF0ZV9pcnEoaXJxX2Rlc2NfZ2V0X2lycV9kYXRhKGRlc2Mp
KTsKPj4gK8KgwqDCoCB9Cj4+ICt9Cj4+ICsKPj4gK3N0YXRpYyB2b2lkIGdldF92bHBpX3N0YXRl
X3Bvc3Qoc3RydWN0IHZnaWNfZGlzdCAqZGlzdCkKPiAKPiBuaXQ6IHRoZSBuYW1pbmcgZmVlbHMg
YSBiaXQuLi4gb2RkLiBQcmUvcG9zdCB3aGF0PwoKTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHRo
ZSB1bm1hcHBpbmcgaXMgYSBwcmVwYXJhdGlvbiBmb3IgZ2V0X3ZscGlfc3RhdGUuLi4KTWF5YmUg
anVzdCBjYWxsIGl0IHVubWFwL21hcF9hbGxfdnBlcz8KCj4gCj4+ICt7Cj4+ICvCoMKgwqAgc3Ry
dWN0IGlycV9kZXNjICpkZXNjOwo+PiArwqDCoMKgIGludCBpOwo+PiArCj4+ICvCoMKgwqAgaWYg
KCFrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEpCj4+ICvCoMKgwqDCoMKgwqDCoCBy
ZXR1cm47Cj4+ICsKPj4gK8KgwqDCoCBmb3IgKGkgPSAwOyBpIDwgZGlzdC0+aXRzX3ZtLm5yX3Zw
ZXM7IGkrKykgewo+PiArwqDCoMKgwqDCoMKgwqAgZGVzYyA9IGlycV90b19kZXNjKGRpc3QtPml0
c192bS52cGVzW2ldLT5pcnEpOwo+PiArwqDCoMKgwqDCoMKgwqAgaXJxX2RvbWFpbl9hY3RpdmF0
ZV9pcnEoaXJxX2Rlc2NfZ2V0X2lycV9kYXRhKGRlc2MpLCBmYWxzZSk7Cj4+ICvCoMKgwqAgfQo+
PiArfQo+PiArCj4+IMKgLyoqCj4+IMKgICogdmdpY192M19zYXZlX3BlbmRpbmdfdGFibGVzIC0g
U2F2ZSB0aGUgcGVuZGluZyB0YWJsZXMgaW50byBndWVzdCBSQU0KPj4gwqAgKiBrdm0gbG9jayBh
bmQgYWxsIHZjcHUgbG9jayBtdXN0IGJlIGhlbGQKPj4gQEAgLTM2NSwxNCArNDAwLDE3IEBAIGlu
dCB2Z2ljX3YzX3NhdmVfcGVuZGluZ190YWJsZXMoc3RydWN0IGt2bSAqa3ZtKQo+PiDCoMKgwqDC
oCBzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0ID0gJmt2bS0+YXJjaC52Z2ljOwo+PiDCoMKgwqDCoCBz
dHJ1Y3QgdmdpY19pcnEgKmlycTsKPj4gwqDCoMKgwqAgZ3BhX3QgbGFzdF9wdHIgPSB+KGdwYV90
KTA7Cj4+IC3CoMKgwqAgaW50IHJldDsKPj4gK8KgwqDCoCBpbnQgcmV0ID0gMDsKPj4gwqDCoMKg
wqAgdTggdmFsOwo+Pgo+PiArwqDCoMKgIGdldF92bHBpX3N0YXRlX3ByZShkaXN0KTsKPj4gKwo+
PiDCoMKgwqDCoCBsaXN0X2Zvcl9lYWNoX2VudHJ5KGlycSwgJmRpc3QtPmxwaV9saXN0X2hlYWQs
IGxwaV9saXN0KSB7Cj4+IMKgwqDCoMKgwqDCoMKgwqAgaW50IGJ5dGVfb2Zmc2V0LCBiaXRfbnI7
Cj4+IMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGt2bV92Y3B1ICp2Y3B1Owo+PiDCoMKgwqDCoMKg
wqDCoMKgIGdwYV90IHBlbmRiYXNlLCBwdHI7Cj4+IMKgwqDCoMKgwqDCoMKgwqAgYm9vbCBzdG9y
ZWQ7Cj4+ICvCoMKgwqDCoMKgwqDCoCBib29sIGlzX3BlbmRpbmcgPSBpcnEtPnBlbmRpbmdfbGF0
Y2g7Cj4+Cj4+IMKgwqDCoMKgwqDCoMKgwqAgdmNwdSA9IGlycS0+dGFyZ2V0X3ZjcHU7Cj4+IMKg
wqDCoMKgwqDCoMKgwqAgaWYgKCF2Y3B1KQo+PiBAQCAtMzg3LDI0ICs0MjUsMzYgQEAgaW50IHZn
aWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhzdHJ1Y3Qga3ZtICprdm0pCj4+IMKgwqDCoMKgwqDC
oMKgwqAgaWYgKHB0ciAhPSBsYXN0X3B0cikgewo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0ID0ga3ZtX3JlYWRfZ3Vlc3RfbG9jayhrdm0sIHB0ciwgJnZhbCwgMSk7Cj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHJldHVybiByZXQ7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBv
dXQ7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBsYXN0X3B0ciA9IHB0cjsKPj4gwqDCoMKg
wqDCoMKgwqDCoCB9Cj4+Cj4+IMKgwqDCoMKgwqDCoMKgwqAgc3RvcmVkID0gdmFsICYgKDFVIDw8
IGJpdF9ucik7Cj4+IC3CoMKgwqDCoMKgwqDCoCBpZiAoc3RvcmVkID09IGlycS0+cGVuZGluZ19s
YXRjaCkKPj4gKwo+PiArwqDCoMKgwqDCoMKgwqAgLyogYWxzbyBmbHVzaCBodyBwZW5kaW5nIHN0
YXRlICovCj4gCj4gVGhpcyBjb21tZW50IGxvb2tzIG91dCBvZiBwbGFjZSwgYXMgd2UgYXJlbid0
IGZsdXNoaW5nIGFueXRoaW5nLgoKT2ssIEkgd2lsbCBjb3JyZWN0IGl0LgoKPiAKPj4gK8KgwqDC
oMKgwqDCoMKgIGlmIChpcnEtPmh3KSB7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdBUk5f
UkFURUxJTUlUKGlycV9nZXRfaXJxY2hpcF9zdGF0ZShpcnEtPmhvc3RfaXJxLAo+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBJUlFDSElQX1NUQVRFX1BF
TkRJTkcsICZpc19wZW5kaW5nKSwKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICJJUlEgJWQiLCBpcnEtPmhvc3RfaXJxKTsKPiAKPiBJc24ndCB0aGlzIGdv
aW5nIHRvIHdhcm4gbGlrZSBtYWQgb24gYSBHSUN2NC4wIHN5c3RlbSB3aGVyZSB0aGlzLCBieSBk
ZWZpbml0aW9uLAo+IHdpbGwgZ2VuZXJhdGUgYW4gZXJyb3I/CgpBcyB3ZSBoYXZlIHJldHVybmVk
IGFuIGVycm9yIGluIHNhdmVfaXRzX3RhYmxlcyBpZiBodyAmJiAhaGFzX2dpY3Y0XzEsIHdlIGRv
bid0CmhhdmUgdG8gd2FybiB0aGlzIGhlcmU/Cgo+IAo+PiArwqDCoMKgwqDCoMKgwqAgfQo+PiAr
Cj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoc3RvcmVkID09IGlzX3BlbmRpbmcpCj4+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPj4KPj4gLcKgwqDCoMKgwqDCoMKgIGlmIChpcnEt
PnBlbmRpbmdfbGF0Y2gpCj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoaXNfcGVuZGluZykKPj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZhbCB8PSAxIDw8IGJpdF9ucjsKPj4gwqDCoMKgwqDCoMKg
wqDCoCBlbHNlCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB2YWwgJj0gfigxIDw8IGJpdF9u
cik7Cj4+Cj4+IMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0ga3ZtX3dyaXRlX2d1ZXN0X2xvY2soa3Zt
LCBwdHIsICZ2YWwsIDEpOwo+PiDCoMKgwqDCoMKgwqDCoMKgIGlmIChyZXQpCj4+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdv
dG8gb3V0Owo+PiDCoMKgwqDCoCB9Cj4+IC3CoMKgwqAgcmV0dXJuIDA7Cj4+ICsKPj4gK291dDoK
Pj4gK8KgwqDCoCBnZXRfdmxwaV9zdGF0ZV9wb3N0KGRpc3QpOwo+IAo+IFRoaXMgYml0IHdvcnJp
ZXMgbWU6IHlvdSBoYXZlIHVubWFwcGVkIHRoZSBWUEVzLCBzbyBhbnkgaW50ZXJydXB0IHRoYXQg
aGFzIGJlZW4KPiBnZW5lcmF0ZWQgZHVyaW5nIHRoYXQgcGhhc2UgaXMgbm93IGZvcmV2ZXIgbG9z
dCAodGhlIEdJQyBkb2Vzbid0IGhhdmUgb3duZXJzaGlwCj4gb2YgdGhlIHBlbmRpbmcgdGFibGVz
KS4KCkluIG15IG9waW5pb24sIGR1cmluZyB0aGlzIHBoYXNlLCB0aGUgZGV2aWNlcyBjYXBhYmxl
IG9mIGludGVycnVwdGluZyBzaG91bGQgaGF2ZQphbHJlYWR5IGJlZW4gcGF1c2VkIChwcmV2ZW50
IGZyb20gc2VuZGluZyBpbnRlcnJ1cHRzKSwgc3VjaCBhcyBWRklPIG1pZ3JhdGlvbiBwcm90b2Nv
bApoYXMgYWxyZWFkeSByZWFsaXplZCBpdC4KCj4gCj4gRG8geW91IHJlYWxseSBleHBlY3QgdGhl
IFZNIHRvIGJlIHJlc3RhcnRhYmxlIGZyb20gdGhhdCBwb2ludD8gSSBkb24ndCBzZWUgaG93Cj4g
dGhpcyBpcyBwb3NzaWJsZS4KPiAKCklmIHRoZSBtaWdyYXRpb24gaGFzIGVuY291bnRlcmVkIGFu
IGVycm9yLCB0aGUgc3JjIFZNIG1pZ2h0IGJlIHJlc3RhcnRlZCwgc28gd2UgaGF2ZSB0bwptYXAg
dGhlIHZQRXMgYmFjay4KCj4+ICsKPj4gK8KgwqDCoCByZXR1cm4gcmV0Owo+PiDCoH0KPj4KPj4g
wqAvKioKPiAKPiBUaGFua3MsCj4gCj4gwqDCoMKgwqDCoMKgwqAgTS4KClRoYW5rcywKU2hlbm1p
bmcKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
