Return-Path: <SRS0=Iiz7=EJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0699CC2D0A3
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 11:31:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14FE0206B5
	for <kvmarm@archiver.kernel.org>; Tue,  3 Nov 2020 11:31:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14FE0206B5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 416D74B394;
	Tue,  3 Nov 2020 06:31:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pZNScMMuSkOe; Tue,  3 Nov 2020 06:31:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 023204B312;
	Tue,  3 Nov 2020 06:31:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B322F4B312
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 06:31:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cFAGeRiRsOaD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2020 06:31:48 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D4614B2F5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2020 06:31:48 -0500 (EST)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CQSKp4rH0z15QQG;
 Tue,  3 Nov 2020 19:31:42 +0800 (CST)
Received: from [10.67.76.251] (10.67.76.251) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0;
 Tue, 3 Nov 2020 19:31:37 +0800
Subject: Re: [RFC] KVM: arm64: Don't force broadcast tlbi when guest is running
To: Marc Zyngier <maz@kernel.org>
References: <1603331829-33879-1-git-send-email-zhangshaokun@hisilicon.com>
 <be1d84d42df6203ad993e8d20d9bd6da@kernel.org>
 <0a7032a7-ff23-b537-fdbd-8189380d4f41@hisilicon.com>
 <65c347bb6442ae003caee28c10467ae1@kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <18edd19d-15a1-bff2-8349-3f702d4c36c2@hisilicon.com>
Date: Tue, 3 Nov 2020 19:31:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <65c347bb6442ae003caee28c10467ae1@kernel.org>
X-Originating-IP: [10.67.76.251]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

SGkgTWFyYywKCkFwb2xvZ2llcyB0aGF0IHJlcGx5IGxhdGVyIGJlY2F1c2Ugb2Ygb3V0IG9mIG9m
ZmljZSBzb21lIGRheXMuCgrlnKggMjAyMC8xMC8yMyAxNzoxNywgTWFyYyBaeW5naWVyIOWGmemB
kzoKPiBPbiAyMDIwLTEwLTIzIDAyOjI2LCBTaGFva3VuIFpoYW5nIHdyb3RlOgo+PiBIaSBNYXJj
77yMCj4+Cj4+IOWcqCAyMDIwLzEwLzIyIDIwOjAzLCBNYXJjIFp5bmdpZXIg5YaZ6YGTOgo+Pj4g
T24gMjAyMC0xMC0yMiAwMjo1NywgU2hhb2t1biBaaGFuZyB3cm90ZToKPj4+PiBGcm9tOiBOaWFu
eWFvIFRhbmcgPHRhbmduaWFueWFvQGh1YXdlaS5jb20+Cj4+Pj4KPj4+PiBOb3cgSENSX0VMMi5G
QiBpcyBzZXQgdG8gZm9yY2UgYnJvYWRjYXN0IHRsYmkgdG8gYWxsIG9ubGluZSBwY3B1cywKPj4+
PiBldmVuIHRob3NlIHZjcHUgZG8gbm90IHJlc2lkZW50IG9uLiBJdCB3b3VsZCBnZXQgd29yc2Ug
YXMgc3lzdGVtCj4+Pj4gZ2V0cyBsYXJnZXIgYW5kIG1vcmUgcGNwdXMgZ2V0IG9ubGluZS4KPj4+
PiBMZXQncyBkaXNhYmxlIGZvcmNlLWJyb2FkY2FzdC4gV2UgZmx1c2ggdGxiaSB3aGVuIG1vdmUg
dmNwdSB0byBhCj4+Pj4gbmV3IHBjcHUsIGluIGNhc2Ugb2xkIHBhZ2UgbWFwcGluZyBzdGlsbCBl
eGlzdHMgb24gbmV3IHBjcHUuCj4+Pj4KPj4+PiBDYzogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVs
Lm9yZz4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBOaWFueWFvIFRhbmcgPHRhbmduaWFueWFvQGh1YXdl
aS5jb20+Cj4+Pj4gU2lnbmVkLW9mZi1ieTogU2hhb2t1biBaaGFuZyA8emhhbmdzaGFva3VuQGhp
c2lsaWNvbi5jb20+Cj4+Pj4gLS0tCj4+Pj4gwqBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9h
cm0uaCB8IDIgKy0KPj4+PiDCoGFyY2gvYXJtNjQva3ZtL2FybS5jwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHwgNCArKystCj4+Pj4gwqAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKPj4+Pgo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUv
YXNtL2t2bV9hcm0uaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FybS5oCj4+Pj4gaW5k
ZXggNjRjZTI5Mzc4NDY3Li5mODVlYTljNjQ5Y2IgMTAwNjQ0Cj4+Pj4gLS0tIGEvYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9rdm1fYXJtLmgKPj4+PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2t2bV9hcm0uaAo+Pj4+IEBAIC03NSw3ICs3NSw3IEBACj4+Pj4gwqAgKiBQVFc6wqDCoMKgwqDC
oMKgwqAgVGFrZSBhIHN0YWdlMiBmYXVsdCBpZiBhIHN0YWdlMSB3YWxrIHN0ZXBzIGluIGRldmlj
ZSBtZW1vcnkKPj4+PiDCoCAqLwo+Pj4+IMKgI2RlZmluZSBIQ1JfR1VFU1RfRkxBR1MgKEhDUl9U
U0MgfCBIQ1JfVFNXIHwgSENSX1RXRSB8IEhDUl9UV0kgfCBIQ1JfVk0gfCBcCj4+Pj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBIQ1JfQlNVX0lTIHwgSENSX0ZCIHwgSENSX1RBQyB8IFwKPj4+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEhDUl9CU1VfSVMgfCBIQ1JfVEFDIHwgXAo+Pj4+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEhDUl9BTU8gfCBIQ1JfU1dJTyB8IEhDUl9USURD
UCB8IEhDUl9SVyB8IEhDUl9UTE9SIHwgXAo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IEhDUl9GTU8gfCBIQ1JfSU1PIHwgSENSX1BUVyApCj4+Pj4gwqAjZGVmaW5lIEhDUl9WSVJUX0VY
Q1BfTUFTSyAoSENSX1ZTRSB8IEhDUl9WSSB8IEhDUl9WRikKPj4+PiBkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9rdm0vYXJtLmMgYi9hcmNoL2FybTY0L2t2bS9hcm0uYwo+Pj4+IGluZGV4IGFjZjlh
OTkzZGZiNi4uODQ1YmU5MTFmODg1IDEwMDY0NAo+Pj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL2Fy
bS5jCj4+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4+PiBAQCAtMzM0LDggKzMzNCwx
MCBAQCB2b2lkIGt2bV9hcmNoX3ZjcHVfbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludCBj
cHUpCj4+Pj4gwqDCoMKgwqAgLyoKPj4+PiDCoMKgwqDCoMKgICogV2UgbWlnaHQgZ2V0IHByZWVt
cHRlZCBiZWZvcmUgdGhlIHZDUFUgYWN0dWFsbHkgcnVucywgYnV0Cj4+Pj4gwqDCoMKgwqDCoCAq
IG92ZXItaW52YWxpZGF0aW9uIGRvZXNuJ3QgYWZmZWN0IGNvcnJlY3RuZXNzLgo+Pj4+ICvCoMKg
wqDCoCAqIERpcnR5IHRsYiBtaWdodCBzdGlsbCBleGlzdCB3aGVuIHZjcHUgcmFuIG9uIG90aGVy
IHBjcHUKPj4+PiArwqDCoMKgwqAgKiBhbmQgbW9kaWZpZWQgcGFnZSBtYXBwaW5nLgo+Pj4+IMKg
wqDCoMKgwqAgKi8KPj4+PiAtwqDCoMKgIGlmICgqbGFzdF9yYW4gIT0gdmNwdS0+dmNwdV9pZCkg
ewo+Pj4+ICvCoMKgwqAgaWYgKCpsYXN0X3JhbiAhPSB2Y3B1LT52Y3B1X2lkIHx8IHZjcHUtPmNw
dSAhPSBjcHUpIHsKPj4+PiDCoMKgwqDCoMKgwqDCoMKgIGt2bV9jYWxsX2h5cChfX2t2bV90bGJf
Zmx1c2hfbG9jYWxfdm1pZCwgbW11KTsKPj4+PiDCoMKgwqDCoMKgwqDCoMKgICpsYXN0X3JhbiA9
IHZjcHUtPnZjcHVfaWQ7Cj4+Pj4gwqDCoMKgwqAgfQo+Pj4KPj4+IFRoaXMgYnJlYWtzIHVuaXBy
b2Nlc3NvciBzZW1hbnRpY3MgZm9yIEktY2FjaGUgaW52YWxpZGF0aW9uLiBXaGF0IGNvdWxkCj4+
Cj4+IE9vcHMsIEl0IHNoYWxsIGNvbnNpZGVyIHRoaXMuCj4+Cj4+PiBwb3NzaWJseSBnbyB3cm9u
Zz8gWW91IGFsc28gZmFpbCB0byBwcm92aWRlIGFueSBkYXRhIHRoYXQgd291bGQgYmFjayB1cAo+
Pj4geW91ciBjbGFpbSwgYXMgdXN1YWwuCj4+Cj4+IFRlc3QgVW5peGJlbmNoIHNwYXduIGluIGVh
Y2ggNFU4RyB2bSBvbiBLdW5wZW5nIDkyMDoKPj4gKDEpIDI0IDRVOEcgVk1zLCBlYWNoIHZjcHUg
aXMgdGFza3NldCB0byBvbmUgcGNwdSB0byBtYWtlIHN1cmUKPj4gZWFjaCB2bSBzZXBlcmF0ZWQu
Cj4gCj4gVGhhdCdzIGEgdmVyeSBuYXJyb3cgdXNlIGNhc2UuCj4gCj4+ICgyKSAxIDRVOEcgVk0K
Pj4gUmVzdWx0Ogo+PiAoMSkgODAwICogMjQKPj4gKDIpIDMyMDAKPiAKPiBJIGRvbid0IGtub3cg
d2hhdCB0aGVzZSBudW1iZXJzIGFyZS4KClRoZXNlIGFyZSB1bml4YmVuY2ggc2NvcmVzLCB0aGUg
aGlnaGVyIHRoZSBiZXR0ZXIuCgo+IAo+PiBCeSByZXN0cmljdGluZyBEVk0gYnJvYWRjYXN0aW5n
IGFjcm9zcyBOVU1BLCByZXN1bHQgKDEpIGNhbgo+PiBiZSBpbXByb3ZlZCB0byAyMzAwICogMjQu
IEluIHNwYXduIHRlc3RjYXNlLCB0bGJpaXMgdXNlZAo+PiBpbiBjcmVhdGluZyBwcm9jZXNzLgo+
IAo+IExpbnV4IGFsd2F5cyB1c2UgVExCSSBJUywgZXhjZXB0IGluIHNvbWUgdmVyeSByYXJlIGNh
c2VzLgo+IElmIHlvdXIgSFcgYnJvYWRjYXN0cyBpbnZhbGlkYXRpb25zIGFjcm9zcyB0aGUgd2hv
bGUgc3lzdGVtCj4gd2l0aG91dCBhbnkgZmlsdGVyaW5nLCBpdCBpcyBib3VuZCB0byBiZSBiYWQu
Cj4gCj4+IEZ1cnRoZXIsIHdlIGNvbnNpZGVyIHJlc3RyaWN0aW5nIHRsYmkgYnJvYWRjYXN0IHJh
bmdlIGFuZCBtYWtlCj4+IHRsYmkgbW9yZSBhY2N1cmF0ZS4KPj4gT25lIHNjaGVtZSBpcyByZXBs
YWNpbmcgdGxiaWlzIHdpdGggaXBpICsgdGxiaSArIEhDUl9FTDIuRkI9MC4KPiAKPiBBaC4gVGhh
dCBvbGQgdGhpbmcgYWdhaW4uIE5vLCB0aGFuayB5b3UuIFRoZSByaWdodCB0aGluZyB0byBkbwo+
IGlzIHRvIGJ1aWxkIENQVXMgYW5kIGludGVyY29ubmVjdHMgdGhhdCBwcm9wZXJseSBkZWFscyB3
aXRoCj4gSVMgaW52YWxpZGF0aW9ucyBieSBub3Qgc2VuZGluZyBEVk0gbWVzc2FnZXMgdG8gcGxh
Y2VzIHdoZXJlCj4gdGhpbmdzIGRvbid0IHJ1biAoc25vb3AgZmlsdGVycz8pLiBJIGFsc28gZG91
YnQgdGhlIGFybTY0Cj4gbWFpbnRhaW5lcnMgd291bGQgYmUgc3ltcGF0aGV0aWMgdG8gdGhlIGlk
ZWEgYW55d2F5LgoKV2UgYWxzbyBkbyB0aGUgc2FtZSB0ZXN0IG9uIGludGVsIDYyNDggYW5kIGdl
dCBiZXR0ZXIgcmVzdWx0LApsZXNzIHBlcmZvcm1hbmNlIGRyb3AgaW4gbXVsdGktdm0gY2FzZSBj
b21wYXJlIHRvIHNpbmdsZSB2bS4KSW50ZWwgdXNlIGlwaSArIGZsdXNoIHRsYiBzY2VuYXJpbywg
ZG8geW91IHRoaW5rIHRoaXMgc2NlbmFyaW8gaXMKbWVhbmluZ2Z1bCBvbiBBcm0gYXJjaGl0ZWN0
IGhhcmR3YXJlPwoKPiAKPj4gQ29uc2lkZXIgSS1jYWNoZSBpbnZhbGlkYXRpb24sIEtWTSBhbHNv
IG5lZWRzIHRvIGludmFsaWQgaWNhY2hlCj4+IHdoZW4gbW92aW5nIHZjcHUgdG8gYSBuZXcgcGNw
dS4KPj4gRG8gd2UgbWlzcyBhbnkgY2FzZXMgdGhhdCBuZWVkIEhDUl9FTDIuRkIgPT0gMT8KPj4g
RXZlbnR1YWxseSB3ZSBleHBlY3QgSENSX0VMMi5GQiA9PSAwIGlmIGl0IGlzIHBvc3NpYmxlLgo+
IAo+IEkgaGF2ZSBubyBpbnRlbnRpb24gdG8gZXZlciBzZXQgRkIgdG8gMCwgYXMgdGhpcyB3b3Vs
ZCByZXN1PiBpbiBvdmVyLWludmFsaWRhdGlvbiBpbiB0aGUgZ2VuZXJhbCBjYXNlLCBhbmQgd29y
c2UgcGVyZm9ybWFuY2UKClRoZSByZWFzb24gdGhhdCB3ZSB3YW50IHRvIGRpc2FibGUgRkIgaXMg
dGhhdCBJUEkgc29sdXRpb24KaXMgbmVlZGVkIGlmIGl0IGlzIGFjY2VwdGVkLgoKVGhhbmtzLApT
aGFva3VuCgo+IG9uIHdlbGwgZGVzaWduZWQgc3lzdGVtcy4KPiAKPiDCoMKgwqDCoMKgwqDCoCBN
LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
