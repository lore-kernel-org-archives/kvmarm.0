Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E4BC433B4
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 12:38:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EEE9860FDB
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 12:38:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEE9860FDB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58AB24B67E;
	Thu,  1 Apr 2021 08:38:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8f9j3nkwDLyi; Thu,  1 Apr 2021 08:38:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11D6A4B65B;
	Thu,  1 Apr 2021 08:38:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA77D4B60D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 08:38:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g+OvE8FTDYZ8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 08:38:20 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 715BF4B607
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 08:38:19 -0400 (EDT)
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.57])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FB2jD59sfz5j7n;
 Thu,  1 Apr 2021 20:36:00 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 1 Apr 2021 20:38:05 +0800
Received: from [10.174.185.210] (10.174.185.210) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 1 Apr 2021 20:38:05 +0800
Subject: Re: [PATCH v14 06/13] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <will@kernel.org>,
 <maz@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
 <alex.williamson@redhat.com>, <tn@semihalf.com>, <zhukeqian1@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-7-eric.auger@redhat.com>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <901720e6-6ca5-eb9a-1f24-0ca479bcfecc@huawei.com>
Date: Thu, 1 Apr 2021 20:37:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210223205634.604221-7-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 wangxingang5@huawei.com, lushenming@huawei.com, nicoleotsuka@gmail.com,
 vivek.gautam@arm.com, yi.l.liu@intel.com, vsethi@nvidia.com,
 zhangfei.gao@linaro.org
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

SGkgRXJpYywKCk9uIDIwMjEvMi8yNCA0OjU2LCBFcmljIEF1Z2VyIHdyb3RlOgo+IFdpdGggbmVz
dGVkIHN0YWdlIHN1cHBvcnQsIHNvb24gd2Ugd2lsbCBuZWVkIHRvIGludmFsaWRhdGUKPiBTMSBj
b250ZXh0cyBhbmQgcmFuZ2VzIHRhZ2dlZCB3aXRoIGFuIHVubWFuYWdlZCBhc2lkLCB0aGlzCj4g
bGF0dGVyIGJlaW5nIG1hbmFnZWQgYnkgdGhlIGd1ZXN0LiBTbyBsZXQncyBpbnRyb2R1Y2UgMiBo
ZWxwZXJzCj4gdGhhdCBhbGxvdyB0byBpbnZhbGlkYXRlIHdpdGggZXh0ZXJuYWxseSBtYW5hZ2Vk
IEFTSURzCj4KPiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5j
b20+Cj4KPiAtLS0KPgo+IHYxMyAtPiB2MTQKPiAtIEFjdHVhbGx5IHNlbmQgdGhlIE5IX0FTSUQg
Y29tbWFuZCAocmVwb3J0ZWQgYnkgWGluZ2FuZyBXYW5nKQo+IC0tLQo+ICAgZHJpdmVycy9pb21t
dS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMuYyB8IDM4ICsrKysrKysrKysrKysrKystLS0t
LQo+ICAgMSBmaWxlIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCj4K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hcm0vYXJtLXNtbXUtdjMvYXJtLXNtbXUtdjMu
YyBiL2RyaXZlcnMvaW9tbXUvYXJtL2FybS1zbW11LXYzL2FybS1zbW11LXYzLmMKPiBpbmRleCA1
NTc5ZWM0ZmNjYzguLjRjMTlhMTExNGRlNCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL2lvbW11L2Fy
bS9hcm0tc21tdS12My9hcm0tc21tdS12My5jCj4gKysrIGIvZHJpdmVycy9pb21tdS9hcm0vYXJt
LXNtbXUtdjMvYXJtLXNtbXUtdjMuYwo+IEBAIC0xODQzLDkgKzE4NDMsOSBAQCBpbnQgYXJtX3Nt
bXVfYXRjX2ludl9kb21haW4oc3RydWN0IGFybV9zbW11X2RvbWFpbiAqc21tdV9kb21haW4sIGlu
dCBzc2lkLAo+ICAgfQo+ICAgCj4gICAvKiBJT19QR1RBQkxFIEFQSSAqLwo+IC1zdGF0aWMgdm9p
ZCBhcm1fc21tdV90bGJfaW52X2NvbnRleHQodm9pZCAqY29va2llKQo+ICtzdGF0aWMgdm9pZCBf
X2FybV9zbW11X3RsYl9pbnZfY29udGV4dChzdHJ1Y3QgYXJtX3NtbXVfZG9tYWluICpzbW11X2Rv
bWFpbiwKPiArCQkJCSAgICAgICBpbnQgZXh0X2FzaWQpCj4gICB7Cj4gLQlzdHJ1Y3QgYXJtX3Nt
bXVfZG9tYWluICpzbW11X2RvbWFpbiA9IGNvb2tpZTsKPiAgIAlzdHJ1Y3QgYXJtX3NtbXVfZGV2
aWNlICpzbW11ID0gc21tdV9kb21haW4tPnNtbXU7Cj4gICAJc3RydWN0IGFybV9zbW11X2NtZHFf
ZW50IGNtZDsKPiAgIAo+IEBAIC0xODU2LDcgKzE4NTYsMTMgQEAgc3RhdGljIHZvaWQgYXJtX3Nt
bXVfdGxiX2ludl9jb250ZXh0KHZvaWQgKmNvb2tpZSkKPiAgIAkgKiBpbnNlcnRpb24gdG8gZ3Vh
cmFudGVlIHRob3NlIGFyZSBvYnNlcnZlZCBiZWZvcmUgdGhlIFRMQkkuIERvIGJlCj4gICAJICog
Y2FyZWZ1bCwgMDA3Lgo+ICAgCSAqLwo+IC0JaWYgKHNtbXVfZG9tYWluLT5zdGFnZSA9PSBBUk1f
U01NVV9ET01BSU5fUzEpIHsKPiArCWlmIChleHRfYXNpZCA+PSAwKSB7IC8qIGd1ZXN0IHN0YWdl
IDEgaW52YWxpZGF0aW9uICovCj4gKwkJY21kLm9wY29kZQk9IENNRFFfT1BfVExCSV9OSF9BU0lE
Owo+ICsJCWNtZC50bGJpLmFzaWQJPSBleHRfYXNpZDsKPiArCQljbWQudGxiaS52bWlkCT0gc21t
dV9kb21haW4tPnMyX2NmZy52bWlkOwo+ICsJCWFybV9zbW11X2NtZHFfaXNzdWVfY21kKHNtbXUs
ICZjbWQpOwo+ICsJCWFybV9zbW11X2NtZHFfaXNzdWVfc3luYyhzbW11KTsKPiArCX0gZWxzZSBp
ZiAoc21tdV9kb21haW4tPnN0YWdlID09IEFSTV9TTU1VX0RPTUFJTl9TMSkgewo+ICAgCQlhcm1f
c21tdV90bGJfaW52X2FzaWQoc21tdSwgc21tdV9kb21haW4tPnMxX2NmZy5jZC5hc2lkKTsKPiAg
IAl9IGVsc2Ugewo+ICAgCQljbWQub3Bjb2RlCT0gQ01EUV9PUF9UTEJJX1MxMl9WTUFMTDsKPiBA
QCAtMTg2Nyw2ICsxODczLDEzIEBAIHN0YXRpYyB2b2lkIGFybV9zbW11X3RsYl9pbnZfY29udGV4
dCh2b2lkICpjb29raWUpCj4gICAJYXJtX3NtbXVfYXRjX2ludl9kb21haW4oc21tdV9kb21haW4s
IDAsIDAsIDApOwo+ICAgfQo+ICAgCj4gK3N0YXRpYyB2b2lkIGFybV9zbW11X3RsYl9pbnZfY29u
dGV4dCh2b2lkICpjb29raWUpCj4gK3sKPiArCXN0cnVjdCBhcm1fc21tdV9kb21haW4gKnNtbXVf
ZG9tYWluID0gY29va2llOwo+ICsKPiArCV9fYXJtX3NtbXVfdGxiX2ludl9jb250ZXh0KHNtbXVf
ZG9tYWluLCAtMSk7Cj4gK30KPiArCj4gICBzdGF0aWMgdm9pZCBfX2FybV9zbW11X3RsYl9pbnZf
cmFuZ2Uoc3RydWN0IGFybV9zbW11X2NtZHFfZW50ICpjbWQsCj4gICAJCQkJICAgICB1bnNpZ25l
ZCBsb25nIGlvdmEsIHNpemVfdCBzaXplLAo+ICAgCQkJCSAgICAgc2l6ZV90IGdyYW51bGUsCj4g
QEAgLTE5MjYsOSArMTkzOSwxMCBAQCBzdGF0aWMgdm9pZCBfX2FybV9zbW11X3RsYl9pbnZfcmFu
Z2Uoc3RydWN0IGFybV9zbW11X2NtZHFfZW50ICpjbWQsCj4gICAJYXJtX3NtbXVfY21kcV9iYXRj
aF9zdWJtaXQoc21tdSwgJmNtZHMpOwo+ICAgfQo+ICAgCkhlcmUgaXMgdGhlIHBhcnQgb2YgY29k
ZSBpbiBfX2FybV9zbW11X3RsYl9pbnZfcmFuZ2UoKToKPiDCoMKgwqDCoMKgwqDCoCBpZiAoc21t
dS0+ZmVhdHVyZXMgJiBBUk1fU01NVV9GRUFUX1JBTkdFX0lOVikgewo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAvKiBHZXQgdGhlIGxlYWYgcGFnZSBzaXplICovCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRnID0gX19mZnMoc21tdV9kb21haW4tPmRvbWFpbi5wZ3Np
emVfYml0bWFwKTsKPgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBDb252ZXJ0
IHBhZ2Ugc2l6ZSBvZiAxMiwxNCwxNiAobG9nMikgdG8gMSwyLDMgKi8KPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgY21kLT50bGJpLnRnID0gKHRnIC0gMTApIC8gMjsKPgo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBEZXRlcm1pbmUgd2hhdCBsZXZlbCB0aGUgZ3Jh
bnVsZSBpcyBhdCAqLwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjbWQtPnRsYmku
dHRsID0gNCAtICgoaWxvZzIoZ3JhbnVsZSkgLSAzKSAvICh0ZyAtIDMpKTsKPgo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBudW1fcGFnZXMgPSBzaXplID4+IHRnOwo+IMKgwqDCoMKg
wqDCoMKgIH0KV2hlbiBwU01NVSBzdXBwb3J0cyBSSUwsIHdlIGdldCB0aGUgbGVhZiBwYWdlIHNp
emUgYnkgX19mZnMoc21tdV9kb21haW4tPgpkb21haW4ucGdzaXplX2JpdG1hcCkuIEluIG5lc3Rl
ZCBtb2RlLCBpdCBpcyBkZXRlcm1pbmVkIGJ5IGhvc3QgClBBR0VfU0laRS4gSWYKdGhlIGhvc3Qg
a2VybmVsIGFuZCBndWVzdCBrZXJuZWwgaGFzIGRpZmZlcmVudCB0cmFuc2xhdGlvbiBncmFudWxl
IChlLmcuIApob3N0IDE2SywKZ3Vlc3QgNEspLCBfX2FybV9zbW11X3RsYl9pbnZfcmFuZ2UoKSB3
aWxsIGlzc3VlIGFuIGluY29ycmVjdCB0bGJpIGNvbW1hbmQuCgpEbyB5b3UgaGF2ZSBhbnkgaWRl
YSBhYm91dCB0aGlzIGlzc3VlPwoKQmVzdCBSZWdhcmRzLApLdW5rdW4gSmlhbmcKPiAtc3RhdGlj
IHZvaWQgYXJtX3NtbXVfdGxiX2ludl9yYW5nZV9kb21haW4odW5zaWduZWQgbG9uZyBpb3ZhLCBz
aXplX3Qgc2l6ZSwKPiAtCQkJCQkgIHNpemVfdCBncmFudWxlLCBib29sIGxlYWYsCj4gLQkJCQkJ
ICBzdHJ1Y3QgYXJtX3NtbXVfZG9tYWluICpzbW11X2RvbWFpbikKPiArc3RhdGljIHZvaWQKPiAr
YXJtX3NtbXVfdGxiX2ludl9yYW5nZV9kb21haW4odW5zaWduZWQgbG9uZyBpb3ZhLCBzaXplX3Qg
c2l6ZSwKPiArCQkJICAgICAgc2l6ZV90IGdyYW51bGUsIGJvb2wgbGVhZiwgaW50IGV4dF9hc2lk
LAo+ICsJCQkgICAgICBzdHJ1Y3QgYXJtX3NtbXVfZG9tYWluICpzbW11X2RvbWFpbikKPiAgIHsK
PiAgIAlzdHJ1Y3QgYXJtX3NtbXVfY21kcV9lbnQgY21kID0gewo+ICAgCQkudGxiaSA9IHsKPiBA
QCAtMTkzNiw3ICsxOTUwLDEyIEBAIHN0YXRpYyB2b2lkIGFybV9zbW11X3RsYl9pbnZfcmFuZ2Vf
ZG9tYWluKHVuc2lnbmVkIGxvbmcgaW92YSwgc2l6ZV90IHNpemUsCj4gICAJCX0sCj4gICAJfTsK
PiAgIAo+IC0JaWYgKHNtbXVfZG9tYWluLT5zdGFnZSA9PSBBUk1fU01NVV9ET01BSU5fUzEpIHsK
PiArCWlmIChleHRfYXNpZCA+PSAwKSB7ICAvKiBndWVzdCBzdGFnZSAxIGludmFsaWRhdGlvbiAq
Lwo+ICsJCWNtZC5vcGNvZGUJPSBzbW11X2RvbWFpbi0+c21tdS0+ZmVhdHVyZXMgJiBBUk1fU01N
VV9GRUFUX0UySCA/Cj4gKwkJCQkgIENNRFFfT1BfVExCSV9FTDJfVkEgOiBDTURRX09QX1RMQklf
TkhfVkE7Cj4gKwkJY21kLnRsYmkuYXNpZAk9IGV4dF9hc2lkOwo+ICsJCWNtZC50bGJpLnZtaWQJ
PSBzbW11X2RvbWFpbi0+czJfY2ZnLnZtaWQ7Cj4gKwl9IGVsc2UgaWYgKHNtbXVfZG9tYWluLT5z
dGFnZSA9PSBBUk1fU01NVV9ET01BSU5fUzEpIHsKPiAgIAkJY21kLm9wY29kZQk9IHNtbXVfZG9t
YWluLT5zbW11LT5mZWF0dXJlcyAmIEFSTV9TTU1VX0ZFQVRfRTJIID8KPiAgIAkJCQkgIENNRFFf
T1BfVExCSV9FTDJfVkEgOiBDTURRX09QX1RMQklfTkhfVkE7Cj4gICAJCWNtZC50bGJpLmFzaWQJ
PSBzbW11X2RvbWFpbi0+czFfY2ZnLmNkLmFzaWQ7Cj4gQEAgLTE5NDQsNiArMTk2Myw3IEBAIHN0
YXRpYyB2b2lkIGFybV9zbW11X3RsYl9pbnZfcmFuZ2VfZG9tYWluKHVuc2lnbmVkIGxvbmcgaW92
YSwgc2l6ZV90IHNpemUsCj4gICAJCWNtZC5vcGNvZGUJPSBDTURRX09QX1RMQklfUzJfSVBBOwo+
ICAgCQljbWQudGxiaS52bWlkCT0gc21tdV9kb21haW4tPnMyX2NmZy52bWlkOwo+ICAgCX0KPiAr
Cj4gICAJX19hcm1fc21tdV90bGJfaW52X3JhbmdlKCZjbWQsIGlvdmEsIHNpemUsIGdyYW51bGUs
IHNtbXVfZG9tYWluKTsKPiAgIAo+ICAgCS8qCj4gQEAgLTE5ODIsNyArMjAwMiw3IEBAIHN0YXRp
YyB2b2lkIGFybV9zbW11X3RsYl9pbnZfcGFnZV9ub3N5bmMoc3RydWN0IGlvbW11X2lvdGxiX2dh
dGhlciAqZ2F0aGVyLAo+ICAgc3RhdGljIHZvaWQgYXJtX3NtbXVfdGxiX2ludl93YWxrKHVuc2ln
bmVkIGxvbmcgaW92YSwgc2l6ZV90IHNpemUsCj4gICAJCQkJICBzaXplX3QgZ3JhbnVsZSwgdm9p
ZCAqY29va2llKQo+ICAgewo+IC0JYXJtX3NtbXVfdGxiX2ludl9yYW5nZV9kb21haW4oaW92YSwg
c2l6ZSwgZ3JhbnVsZSwgZmFsc2UsIGNvb2tpZSk7Cj4gKwlhcm1fc21tdV90bGJfaW52X3Jhbmdl
X2RvbWFpbihpb3ZhLCBzaXplLCBncmFudWxlLCBmYWxzZSwgLTEsIGNvb2tpZSk7Cj4gICB9Cj4g
ICAKPiAgIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaW9tbXVfZmx1c2hfb3BzIGFybV9zbW11X2ZsdXNo
X29wcyA9IHsKPiBAQCAtMjUyMyw3ICsyNTQzLDcgQEAgc3RhdGljIHZvaWQgYXJtX3NtbXVfaW90
bGJfc3luYyhzdHJ1Y3QgaW9tbXVfZG9tYWluICpkb21haW4sCj4gICAKPiAgIAlhcm1fc21tdV90
bGJfaW52X3JhbmdlX2RvbWFpbihnYXRoZXItPnN0YXJ0LAo+ICAgCQkJCSAgICAgIGdhdGhlci0+
ZW5kIC0gZ2F0aGVyLT5zdGFydCArIDEsCj4gLQkJCQkgICAgICBnYXRoZXItPnBnc2l6ZSwgdHJ1
ZSwgc21tdV9kb21haW4pOwo+ICsJCQkJICAgICAgZ2F0aGVyLT5wZ3NpemUsIHRydWUsIC0xLCBz
bW11X2RvbWFpbik7Cj4gICB9Cj4gICAKPiAgIHN0YXRpYyBwaHlzX2FkZHJfdAoKCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
