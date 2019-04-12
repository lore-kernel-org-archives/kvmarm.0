Return-Path: <SRS0=yTkG=SO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27455C10F14
	for <kvmarm@archiver.kernel.org>; Fri, 12 Apr 2019 09:37:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A331F205F4
	for <kvmarm@archiver.kernel.org>; Fri, 12 Apr 2019 09:37:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A331F205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C274A482;
	Fri, 12 Apr 2019 05:37:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N1FHAWB9Iw4A; Fri, 12 Apr 2019 05:37:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB514A4C3;
	Fri, 12 Apr 2019 05:37:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64224A482
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 05:37:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ja3YLIvM8-XZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Apr 2019 05:37:16 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0638E4A476
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 05:37:15 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id AF22C68F1E796B373A28;
 Fri, 12 Apr 2019 17:37:12 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.408.0; Fri, 12 Apr 2019
 17:37:04 +0800
Subject: Re: [PATCH 2/2] kvm: arm: Unify handling THP backed host memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 <linux-arm-kernel@lists.infradead.org>
References: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-3-git-send-email-suzuki.poulose@arm.com>
 <c48b2bd4-68e6-dbc0-b010-78a23a889196@huawei.com>
 <1bac514c-e4f0-a609-96ed-f48ef3461da1@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e5f35fa6-ab8d-695a-6c66-bfb2b2465b2a@huawei.com>
Date: Fri, 12 Apr 2019 17:34:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <1bac514c-e4f0-a609-96ed-f48ef3461da1@arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190412093453.0FEXSZm3amITqPDFtiGJ2X45BB0gYJjCFiiuimz6fkQ@z>

Ck9uIDIwMTkvNC8xMSAyMzoxNiwgU3V6dWtpIEsgUG91bG9zZSB3cm90ZToKPiBIaSBaaGVuZ3Vp
LAo+IAo+IE9uIDExLzA0LzIwMTkgMDI6NTksIFplbmdodWkgWXUgd3JvdGU6Cj4+IEhpIFN1enVr
aSwKPj4KPj4gT24gMjAxOS80LzEwIDIzOjIzLCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+Pj4g
V2Ugc3VwcG9ydCBtYXBwaW5nIGhvc3QgbWVtb3J5IGJhY2tlZCBieSBQTUQgdHJhbnNwYXJlbnQg
aHVnZXBhZ2VzCj4+PiBhdCBzdGFnZTIgYXMgaHVnZSBwYWdlcy4gSG93ZXZlciB0aGUgY2hlY2tz
IGFyZSBub3cgc3ByZWFkIGFjcm9zcwo+Pj4gdHdvIGRpZmZlcmVudCBwbGFjZXMuIExldCB1cyB1
bmlmeSB0aGUgaGFuZGxpbmcgb2YgdGhlIFRIUHMgdG8KPj4+IGtlZXAgdGhlIGNvZGUgY2xlYW5l
ciAoYW5kIGZ1dHVyZSBwcm9vZiBmb3IgUFVEIFRIUCBzdXBwb3J0KS4KPj4+IFRoaXMgcGF0Y2gg
bW92ZXMgdHJhbnNwYXJlbnRfaHVnZXBhZ2VfYWRqdXN0KCkgY2xvc2VyIHRvIHRoZSBjYWxsZXIK
Pj4+IHRvIGF2b2lkIGEgZm9yd2FyZCBkZWNsYXJhdGlvbiBmb3IgCj4+PiBmYXVsdF9zdXBwb3J0
c19zdGFnZTJfaHVnZV9tYXBwaW5ncygpLgo+Pj4KPj4+IEFsc28sIHNpbmNlIHdlIGFscmVhZHkg
aGFuZGxlIHRoZSBjYXNlIHdoZXJlIHRoZSBob3N0IFZBIGFuZCB0aGUgZ3Vlc3QKPj4+IFBBIG1h
eSBub3QgYmUgYWxpZ25lZCwgdGhlIGV4cGxpY2l0IFZNX0JVR19PTigpIGlzIG5vdCByZXF1aXJl
ZC4KPj4+Cj4+PiBDYzogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KPj4+IENj
OiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGFybS5jb20+Cj4+PiBDYzogWm5l
Z2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBTdXp1a2kg
SyBQb3Vsb3NlIDxzdXp1a2kucG91bG9zZUBhcm0uY29tPgo+Pj4gLS0tCj4+PiDCoMKgIHZpcnQv
a3ZtL2FybS9tbXUuYyB8IDEyMyAKPj4+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4+PiDCoMKgIDEgZmlsZSBjaGFuZ2VkLCA2MiBpbnNlcnRp
b25zKCspLCA2MSBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJt
L21tdS5jIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+PiBpbmRleCA2ZDczMzIyLi43MTRlZWMyIDEw
MDY0NAo+Pj4gLS0tIGEvdmlydC9rdm0vYXJtL21tdS5jCj4+PiArKysgYi92aXJ0L2t2bS9hcm0v
bW11LmMKPj4+IEBAIC0xMzgwLDUzICsxMzgwLDYgQEAgaW50IGt2bV9waHlzX2FkZHJfaW9yZW1h
cChzdHJ1Y3Qga3ZtICprdm0sIAo+Pj4gcGh5c19hZGRyX3QgZ3Vlc3RfaXBhLAo+Pj4gwqDCoMKg
wqDCoMKgIHJldHVybiByZXQ7Cj4+PiDCoMKgIH0KPj4+IC1zdGF0aWMgYm9vbCB0cmFuc3BhcmVu
dF9odWdlcGFnZV9hZGp1c3Qoa3ZtX3Bmbl90ICpwZm5wLCBwaHlzX2FkZHJfdCAKPj4+ICppcGFw
KQo+Pj4gLXsKPj4+IC3CoMKgwqAga3ZtX3Bmbl90IHBmbiA9ICpwZm5wOwo+Pj4gLcKgwqDCoCBn
Zm5fdCBnZm4gPSAqaXBhcCA+PiBQQUdFX1NISUZUOwo+Pj4gLcKgwqDCoCBzdHJ1Y3QgcGFnZSAq
cGFnZSA9IHBmbl90b19wYWdlKHBmbik7Cj4+PiAtCj4+PiAtwqDCoMKgIC8qCj4+PiAtwqDCoMKg
wqAgKiBQYWdlVHJhbnNDb21wb3VuZE1hcCgpIHJldHVybnMgdHJ1ZSBmb3IgVEhQIGFuZAo+Pj4g
LcKgwqDCoMKgICogaHVnZXRsYmZzLiBNYWtlIHN1cmUgdGhlIGFkanVzdG1lbnQgaXMgZG9uZSBv
bmx5IGZvciBUSFAKPj4+IC3CoMKgwqDCoCAqIHBhZ2VzLgo+Pj4gLcKgwqDCoMKgICovCj4+PiAt
wqDCoMKgIGlmICghUGFnZUh1Z2UocGFnZSkgJiYgUGFnZVRyYW5zQ29tcG91bmRNYXAocGFnZSkp
IHsKPj4+IC3CoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIG1hc2s7Cj4+PiAtwqDCoMKgwqDC
oMKgwqAgLyoKPj4+IC3CoMKgwqDCoMKgwqDCoMKgICogVGhlIGFkZHJlc3Mgd2UgZmF1bHRlZCBv
biBpcyBiYWNrZWQgYnkgYSB0cmFuc3BhcmVudCBodWdlCj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAq
IHBhZ2UuwqAgSG93ZXZlciwgYmVjYXVzZSB3ZSBtYXAgdGhlIGNvbXBvdW5kIGh1Z2UgcGFnZSBh
bmQKPj4+IC3CoMKgwqDCoMKgwqDCoMKgICogbm90IHRoZSBpbmRpdmlkdWFsIHRhaWwgcGFnZSwg
d2UgbmVlZCB0byB0cmFuc2ZlciB0aGUKPj4+IC3CoMKgwqDCoMKgwqDCoMKgICogcmVmY291bnQg
dG8gdGhlIGhlYWQgcGFnZS7CoCBXZSBoYXZlIHRvIGJlIGNhcmVmdWwgdGhhdCB0aGUKPj4+IC3C
oMKgwqDCoMKgwqDCoMKgICogVEhQIGRvZXNuJ3Qgc3RhcnQgdG8gc3BsaXQgd2hpbGUgd2UgYXJl
IGFkanVzdGluZyB0aGUKPj4+IC3CoMKgwqDCoMKgwqDCoMKgICogcmVmY291bnRzLgo+Pj4gLcKg
wqDCoMKgwqDCoMKgwqAgKgo+Pj4gLcKgwqDCoMKgwqDCoMKgwqAgKiBXZSBhcmUgc3VyZSB0aGlz
IGRvZXNuJ3QgaGFwcGVuLCBiZWNhdXNlIG1tdV9ub3RpZmllcl9yZXRyeQo+Pj4gLcKgwqDCoMKg
wqDCoMKgwqAgKiB3YXMgc3VjY2Vzc2Z1bCBhbmQgd2UgYXJlIGhvbGRpbmcgdGhlIG1tdV9sb2Nr
LCBzbyBpZiB0aGlzCj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAqIFRIUCBpcyB0cnlpbmcgdG8gc3Bs
aXQsIGl0IHdpbGwgYmUgYmxvY2tlZCBpbiB0aGUgbW11Cj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAq
IG5vdGlmaWVyIGJlZm9yZSB0b3VjaGluZyBhbnkgb2YgdGhlIHBhZ2VzLCBzcGVjaWZpY2FsbHkK
Pj4+IC3CoMKgwqDCoMKgwqDCoMKgICogYmVmb3JlIGJlaW5nIGFibGUgdG8gY2FsbCBfX3NwbGl0
X2h1Z2VfcGFnZV9yZWZjb3VudCgpLgo+Pj4gLcKgwqDCoMKgwqDCoMKgwqAgKgo+Pj4gLcKgwqDC
oMKgwqDCoMKgwqAgKiBXZSBjYW4gdGhlcmVmb3JlIHNhZmVseSB0cmFuc2ZlciB0aGUgcmVmY291
bnQgZnJvbSBQR190YWlsCj4+PiAtwqDCoMKgwqDCoMKgwqDCoCAqIHRvIFBHX2hlYWQgYW5kIHN3
aXRjaCB0aGUgcGZuIGZyb20gYSB0YWlsIHBhZ2UgdG8gdGhlIGhlYWQKPj4+IC3CoMKgwqDCoMKg
wqDCoMKgICogcGFnZSBhY2NvcmRpbmdseS4KPj4+IC3CoMKgwqDCoMKgwqDCoMKgICovCj4+PiAt
wqDCoMKgwqDCoMKgwqAgbWFzayA9IFBUUlNfUEVSX1BNRCAtIDE7Cj4+PiAtwqDCoMKgwqDCoMKg
wqAgVk1fQlVHX09OKChnZm4gJiBtYXNrKSAhPSAocGZuICYgbWFzaykpOwo+Pj4gLcKgwqDCoMKg
wqDCoMKgIGlmIChwZm4gJiBtYXNrKSB7Cj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqaXBh
cCAmPSBQTURfTUFTSzsKPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9yZWxlYXNlX3Bm
bl9jbGVhbihwZm4pOwo+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGZuICY9IH5tYXNrOwo+
Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX2dldF9wZm4ocGZuKTsKPj4+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICpwZm5wID0gcGZuOwo+Pj4gLcKgwqDCoMKgwqDCoMKgIH0KPj4+IC0K
Pj4+IC3CoMKgwqDCoMKgwqDCoCByZXR1cm4gdHJ1ZTsKPj4+IC3CoMKgwqAgfQo+Pj4gLQo+Pj4g
LcKgwqDCoCByZXR1cm4gZmFsc2U7Cj4+PiAtfQo+Pj4gLQo+Pj4gwqDCoCAvKioKPj4+IMKgwqDC
oCAqIHN0YWdlMl93cF9wdGVzIC0gd3JpdGUgcHJvdGVjdCBQTUQgcmFuZ2UKPj4+IMKgwqDCoCAq
IEBwbWQ6wqDCoMKgIHBvaW50ZXIgdG8gcG1kIGVudHJ5Cj4+PiBAQCAtMTY3Nyw2ICsxNjMwLDYx
IEBAIHN0YXRpYyBib29sIAo+Pj4gZmF1bHRfc3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGluZyhz
dHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICptZW1zbG90LAo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKGh2YSAmIH4obWFwX3NpemUgLSAxKSkgKyBtYXBfc2l6ZSA8PSB1YWRkcl9lbmQ7Cj4+
PiDCoMKgIH0KPj4+ICsvKgo+Pj4gKyAqIENoZWNrIGlmIHRoZSBnaXZlbiBodmEgaXMgYmFja2Vk
IGJ5IGEgdHJhbnNwYXJlbnQgaHVnZSBwYWdlIChUSFApCj4+PiArICogYW5kIHdoZXRoZXIgaXQg
Y2FuIGJlIG1hcHBlZCB1c2luZyBibG9jayBtYXBwaW5nIGluIHN0YWdlMi4gSWYgCj4+PiBzbywg
YWRqdXN0Cj4+PiArICogdGhlIHN0YWdlMiBQRk4gYW5kIElQQSBhY2NvcmRpbmdseS4gT25seSBQ
TURfU0laRSBUSFBzIGFyZSBjdXJyZW50bHkKPj4+ICsgKiBzdXBwb3J0ZWQuIFRoaXMgd2lsbCBu
ZWVkIHRvIGJlIHVwZGF0ZWQgdG8gc3VwcG9ydCBvdGhlciBUSFAgc2l6ZXMuCj4+PiArICoKPj4+
ICsgKiBSZXR1cm5zIHRoZSBzaXplIG9mIHRoZSBtYXBwaW5nLgo+Pj4gKyAqLwo+Pj4gK3N0YXRp
YyB1bnNpZ25lZCBsb25nCj4+PiArdHJhbnNwYXJlbnRfaHVnZXBhZ2VfYWRqdXN0KHN0cnVjdCBr
dm1fbWVtb3J5X3Nsb3QgKm1lbXNsb3QsCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHVuc2lnbmVkIGxvbmcgaHZhLCBrdm1fcGZuX3QgKnBmbnAsCj4+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHBoeXNfYWRkcl90ICppcGFwKQo+Pj4gK3sKPj4+ICvCoMKgwqAg
a3ZtX3Bmbl90IHBmbiA9ICpwZm5wOwo+Pj4gK8KgwqDCoCBzdHJ1Y3QgcGFnZSAqcGFnZSA9IHBm
bl90b19wYWdlKHBmbik7Cj4+PiArCj4+PiArwqDCoMKgIC8qCj4+PiArwqDCoMKgwqAgKiBQYWdl
VHJhbnNDb21wb3VuZE1hcCgpIHJldHVybnMgdHJ1ZSBmb3IgVEhQIGFuZAo+Pj4gK8KgwqDCoMKg
ICogaHVnZXRsYmZzLiBNYWtlIHN1cmUgdGhlIGFkanVzdG1lbnQgaXMgZG9uZSBvbmx5IGZvciBU
SFAKPj4+ICvCoMKgwqDCoCAqIHBhZ2VzLiBBbHNvIG1ha2Ugc3VyZSB0aGF0IHRoZSBIVkEgYW5k
IElQQSBhcmUgc3VmZmljaWVudGx5Cj4+PiArwqDCoMKgwqAgKiBhbGlnbmVkIGFuZCB0aGF0IHRo
ZcKgIGJsb2NrIG1hcCBpcyBjb250YWluZWQgd2l0aGluIHRoZSBtZW1zbG90Lgo+Pj4gK8KgwqDC
oMKgICovCj4+PiArwqDCoMKgIGlmICghUGFnZUh1Z2UocGFnZSkgJiYgUGFnZVRyYW5zQ29tcG91
bmRNYXAocGFnZSkgJiYKPj4KPj4gV2UgbWFuYWdlZCB0byBnZXQgaGVyZSwgZW5zdXJlIHRoYXQg
d2Ugb25seSBwbGF5IHdpdGggbm9ybWFsIHNpemUgcGFnZXMKPj4gYW5kIG5vIGh1Z2V0bGJmcyBw
YWdlcyB3aWxsIGJlIGludm9sdmVkLsKgICIhUGFnZUh1Z2UocGFnZSkiIHdpbGwgYWx3YXlzCj4+
IHJldHVybiB0cnVlIGFuZCB3ZSBjYW4gbGV0IGl0IGdvLgo+IAo+IEkgdGhpbmsgdGhhdCBpcyBh
IGJpdCB0cmlja3kuIElmIHNvbWVvbmUgZXZlciBtb2RpZmllcyB0aGUgdXNlcl9tZW1fYWJvcnQo
KQo+IGFuZCB3ZSBlbmQgdXAgaW4gZ2V0dGluZyBjYWxsZWQgd2l0aCBhIEh1Z2VUTEIgYmFja2Vk
IHBhZ2UgdGhpbmdzIGNvdWxkIGdvCj4gd3JvbmcuCgpUaGF0IHdpbGwgYmUgYmFkLiBJJ20gbm90
IHN1cmUgaWYgaXQncyBwb3NzaWJsZSBpbiB0aGUgZnV0dXJlLgoKPiBJIGNvdWxkIGRvIHJlbW92
ZSB0aGUgY2hlY2ssIGJ1dCB3b3VsZCBsaWtlIHRvIGFkZCBhIFdBUk5fT05fT05DRSgpIHRvIG1h
a2UKPiBzdXJlIG91ciBhc3N1bXB0aW9uIGlzIGhlbGQuCj4gCj4gaS5lLAo+ICDCoMKgwqDCoFdB
Uk5fT05fT05DRShQYWdlSHVnZShwYWdlKSk7CgpCdXQgdGhpcyBpcyBhIGNhcmVmdWwgYXBwcm9h
Y2guIEkgdGhpbmsgdGhpcyB3aWxsIGJlIHZhbHVhYmxlIGJvdGggZm9yCmRldmVsb3BlcnMgYW5k
IHRoZSBjb2RlIGl0c2VsZi4gVGhhbmtzIQoKCnplbmdodWkKCj4gCj4gIMKgwqDCoMKgaWYgKFBh
Z2VUcmFuc0NvbXBvdW5kTWFwKHBhZ2UpICYmPj4gKyAKPiBmYXVsdF9zdXBwb3J0c19zdGFnZTJf
aHVnZV9tYXBwaW5nKG1lbXNsb3QsIGh2YSwgUE1EX1NJWkUpKSB7Cj4gCj4gLi4uCj4gCgoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
