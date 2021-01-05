Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E38C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 13:03:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D08E22240
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 13:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D08E22240
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9AB4B1A4;
	Tue,  5 Jan 2021 08:03:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HZIx3uy7LlXy; Tue,  5 Jan 2021 08:03:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BB834B1A7;
	Tue,  5 Jan 2021 08:03:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DE444B1A4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 08:02:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AdA+M2Gr2Fww for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 08:02:56 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D32C4B113
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 08:02:56 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D9CLp3N5yz7QY8;
 Tue,  5 Jan 2021 21:01:54 +0800 (CST)
Received: from [10.174.184.196] (10.174.184.196) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 21:02:38 +0800
Subject: Re: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
To: Marc Zyngier <maz@kernel.org>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-3-lushenming@huawei.com>
 <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <0fa19ab1-60ba-9067-e1aa-ee78191c52ed@huawei.com>
Date: Tue, 5 Jan 2021 21:02:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <b0f0b2544f8e231ebb5b5545be226164@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.196]
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

T24gMjAyMS8xLzUgMTc6MTMsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIxLTAxLTA0IDA4
OjE2LCBTaGVubWluZyBMdSB3cm90ZToKPj4gQWZ0ZXIgcGF1c2luZyBhbGwgdkNQVXMgYW5kIGRl
dmljZXMgY2FwYWJsZSBvZiBpbnRlcnJ1cHRpbmcsIGluIG9yZGVyCj4+IHRvIHNhdmUgdGhlIGlu
Zm9ybWF0aW9uIG9mIGFsbCBpbnRlcnJ1cHRzLCBiZXNpZGVzIGZsdXNoaW5nIHRoZSBwZW5kaW5n
Cj4+IHN0YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFsc28gdHJ5IHRvIGZsdXNoIHRoZSBzdGF0
ZXMgb2YgVkxQSXMgaW4gdGhlCj4+IHZpcnR1YWwgcGVuZGluZyB0YWJsZXMgaW50byBndWVzdCBS
QU0sIGJ1dCB3ZSBuZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQKPj4gc2FmZWx5IHVubWFwIHRoZSB2
UEVzIGZpcnN0Lgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0Bo
dWF3ZWkuY29tPgo+PiAtLS0KPj4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyB8IDU4
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tCj4+IMKgMSBmaWxlIGNoYW5nZWQs
IDUyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5j
Cj4+IGluZGV4IDljZGYzOWE5NGE2My4uYTU4Yzk0MTI3Y2IwIDEwMDY0NAo+PiAtLS0gYS9hcmNo
L2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtdjMuYwo+PiBAQCAtMSw2ICsxLDggQEAKPj4gwqAvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMC1vbmx5Cj4+Cj4+IMKgI2luY2x1ZGUgPGxpbnV4L2lycWNoaXAvYXJtLWdpYy12
My5oPgo+PiArI2luY2x1ZGUgPGxpbnV4L2lycS5oPgo+PiArI2luY2x1ZGUgPGxpbnV4L2lycWRv
bWFpbi5oPgo+PiDCoCNpbmNsdWRlIDxsaW51eC9rdm0uaD4KPj4gwqAjaW5jbHVkZSA8bGludXgv
a3ZtX2hvc3QuaD4KPj4gwqAjaW5jbHVkZSA8a3ZtL2FybV92Z2ljLmg+Cj4+IEBAIC0zNTYsNiAr
MzU4LDM4IEBAIGludCB2Z2ljX3YzX2xwaV9zeW5jX3BlbmRpbmdfc3RhdHVzKHN0cnVjdCBrdm0K
Pj4gKmt2bSwgc3RydWN0IHZnaWNfaXJxICppcnEpCj4+IMKgwqDCoMKgIHJldHVybiAwOwo+PiDC
oH0KPj4KPj4gKy8qCj4+ICsgKiBUaGUgZGVhY3RpdmF0aW9uIG9mIHRoZSBkb29yYmVsbCBpbnRl
cnJ1cHQgd2lsbCB0cmlnZ2VyIHRoZQo+PiArICogdW5tYXBwaW5nIG9mIHRoZSBhc3NvY2lhdGVk
IHZQRS4KPj4gKyAqLwo+PiArc3RhdGljIHZvaWQgdW5tYXBfYWxsX3ZwZXMoc3RydWN0IHZnaWNf
ZGlzdCAqZGlzdCkKPj4gK3sKPj4gK8KgwqDCoCBzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2M7Cj4+ICvC
oMKgwqAgaW50IGk7Cj4+ICsKPj4gK8KgwqDCoCBpZiAoIWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5o
YXNfZ2ljdjRfMSkKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybjsKPj4gKwo+PiArwqDCoMKgIGZv
ciAoaSA9IDA7IGkgPCBkaXN0LT5pdHNfdm0ubnJfdnBlczsgaSsrKSB7Cj4+ICvCoMKgwqDCoMKg
wqDCoCBkZXNjID0gaXJxX3RvX2Rlc2MoZGlzdC0+aXRzX3ZtLnZwZXNbaV0tPmlycSk7Cj4+ICvC
oMKgwqDCoMKgwqDCoCBpcnFfZG9tYWluX2RlYWN0aXZhdGVfaXJxKGlycV9kZXNjX2dldF9pcnFf
ZGF0YShkZXNjKSk7Cj4+ICvCoMKgwqAgfQo+PiArfQo+PiArCj4+ICtzdGF0aWMgdm9pZCBtYXBf
YWxsX3ZwZXMoc3RydWN0IHZnaWNfZGlzdCAqZGlzdCkKPj4gK3sKPj4gK8KgwqDCoCBzdHJ1Y3Qg
aXJxX2Rlc2MgKmRlc2M7Cj4+ICvCoMKgwqAgaW50IGk7Cj4+ICsKPj4gK8KgwqDCoCBpZiAoIWt2
bV92Z2ljX2dsb2JhbF9zdGF0ZS5oYXNfZ2ljdjRfMSkKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVy
bjsKPj4gKwo+PiArwqDCoMKgIGZvciAoaSA9IDA7IGkgPCBkaXN0LT5pdHNfdm0ubnJfdnBlczsg
aSsrKSB7Cj4+ICvCoMKgwqDCoMKgwqDCoCBkZXNjID0gaXJxX3RvX2Rlc2MoZGlzdC0+aXRzX3Zt
LnZwZXNbaV0tPmlycSk7Cj4+ICvCoMKgwqDCoMKgwqDCoCBpcnFfZG9tYWluX2FjdGl2YXRlX2ly
cShpcnFfZGVzY19nZXRfaXJxX2RhdGEoZGVzYyksIGZhbHNlKTsKPj4gK8KgwqDCoCB9Cj4+ICt9
Cj4+ICsKPj4gwqAvKioKPj4gwqAgKiB2Z2ljX3YzX3NhdmVfcGVuZGluZ190YWJsZXMgLSBTYXZl
IHRoZSBwZW5kaW5nIHRhYmxlcyBpbnRvIGd1ZXN0IFJBTQo+PiDCoCAqIGt2bSBsb2NrIGFuZCBh
bGwgdmNwdSBsb2NrIG11c3QgYmUgaGVsZAo+PiBAQCAtMzY1LDE0ICszOTksMTggQEAgaW50IHZn
aWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhzdHJ1Y3Qga3ZtICprdm0pCj4+IMKgwqDCoMKgIHN0
cnVjdCB2Z2ljX2Rpc3QgKmRpc3QgPSAma3ZtLT5hcmNoLnZnaWM7Cj4+IMKgwqDCoMKgIHN0cnVj
dCB2Z2ljX2lycSAqaXJxOwo+PiDCoMKgwqDCoCBncGFfdCBsYXN0X3B0ciA9IH4oZ3BhX3QpMDsK
Pj4gLcKgwqDCoCBpbnQgcmV0Owo+PiArwqDCoMKgIGludCByZXQgPSAwOwo+PiDCoMKgwqDCoCB1
OCB2YWw7Cj4+Cj4+ICvCoMKgwqAgLyogQXMgYSBwcmVwYXJhdGlvbiBmb3IgZ2V0dGluZyBhbnkg
VkxQSSBzdGF0ZXMuICovCj4+ICvCoMKgwqAgdW5tYXBfYWxsX3ZwZXMoZGlzdCk7Cj4gCj4gV2hh
dCBpZiB0aGUgVlBFcyBhcmUgbm90IG1hcHBlZCB5ZXQ/IElzIGl0IHBvc3NpYmxlIHRvIHNuYXBz
aG90IGEgVk0KPiB0aGF0IGhhcyBub3QgcnVuIGF0IGFsbD8KCldoYXQgSSBzZWUgaW4gUUVNVSBp
cyB0aGF0IHRoZSBzYXZpbmcgb2YgdGhlIHBlbmRpbmcgdGFibGVzIHdvdWxkIG9ubHkgYmUKY2Fs
bGVkIHdoZW4gc3RvcHBpbmcgdGhlIFZNIGFuZCBpdCBuZWVkcyB0aGUgY3VycmVudCBWTSBzdGF0
ZSB0byBiZSBSVU5OSU5HLgoKPiAKPj4gKwo+PiDCoMKgwqDCoCBsaXN0X2Zvcl9lYWNoX2VudHJ5
KGlycSwgJmRpc3QtPmxwaV9saXN0X2hlYWQsIGxwaV9saXN0KSB7Cj4+IMKgwqDCoMKgwqDCoMKg
wqAgaW50IGJ5dGVfb2Zmc2V0LCBiaXRfbnI7Cj4+IMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGt2
bV92Y3B1ICp2Y3B1Owo+PiDCoMKgwqDCoMKgwqDCoMKgIGdwYV90IHBlbmRiYXNlLCBwdHI7Cj4+
IMKgwqDCoMKgwqDCoMKgwqAgYm9vbCBzdG9yZWQ7Cj4+ICvCoMKgwqDCoMKgwqDCoCBib29sIGlz
X3BlbmRpbmcgPSBpcnEtPnBlbmRpbmdfbGF0Y2g7Cj4+Cj4+IMKgwqDCoMKgwqDCoMKgwqAgdmNw
dSA9IGlycS0+dGFyZ2V0X3ZjcHU7Cj4+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKCF2Y3B1KQo+PiBA
QCAtMzg3LDI0ICs0MjUsMzIgQEAgaW50IHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhzdHJ1
Y3Qga3ZtICprdm0pCj4+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKHB0ciAhPSBsYXN0X3B0cikgewo+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0ga3ZtX3JlYWRfZ3Vlc3RfbG9jayhrdm0s
IHB0ciwgJnZhbCwgMSk7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KQo+PiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBsYXN0X3B0ciA9IHB0cjsKPj4gwqDCoMKgwqDCoMKgwqDCoCB9Cj4+Cj4+IMKgwqDCoMKgwqDC
oMKgwqAgc3RvcmVkID0gdmFsICYgKDFVIDw8IGJpdF9ucik7Cj4+IC3CoMKgwqDCoMKgwqDCoCBp
ZiAoc3RvcmVkID09IGlycS0+cGVuZGluZ19sYXRjaCkKPj4gKwo+PiArwqDCoMKgwqDCoMKgwqAg
aWYgKGlycS0+aHcpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZnaWNfdjRfZ2V0X3ZscGlf
c3RhdGUoaXJxLCAmaXNfcGVuZGluZyk7Cj4gCj4gWW91IGRvbid0IGNoZWNrIHRoZSByZXR1cm4g
dmFsdWUgaGVyZSwgc28gSSB3b25kZXIgd2h5IHRoZSBjaGVja3MKPiBpbiB2Z2ljX3Y0X2dldF92
bHBpX3N0YXRlKCkuCgpTaW5jZSBJIGhhdmUgYWxyZWFkeSBjaGVja2VkIHRoZSBjb25kaXRpb24g
YW5kIHJlcG9ydGVkIGluIHNhdmVfaXRzX3RhYmxlcwoocGF0Y2ggNCksIEkganVzdCBjaGVjayBp
biBnZXRfdmxwaV9zdGF0ZSBhbmQgZG9uJ3QgcmVwb3J0IGFnYWluIGhlcmUuCgo+IAo+IEFub3Ro
ZXIgdGhpbmcgdGhhdCB3b3JyaWVzIG1lIGlzIHRoYXQgdmdpY192NF9nZXRfdmxwaV9zdGF0ZSgp
IGRvZXNuJ3QKPiBoYXZlIGFueSBjYWNoZSBpbnZhbGlkYXRpb24sIGFuZCBjYW4gZW5kLXVwIGhp
dHRpbmcgaW4gdGhlIENQVSBjYWNoZQo+ICh0aGVyZSBpcyBubyBndWFyYW50ZWUgb2YgY29oZXJl
bmN5IGJldHdlZW4gdGhlIEdJQyBhbmQgdGhlIENQVSwgb25seQo+IHRoYXQgdGhlIEdJQyB3aWxs
IGhhdmUgZmx1c2hlZCBpdHMgY2FjaGVzKS4KPiAKPiBJJ2QgZXhwZWN0IHRoaXMgdG8gaGFwcGVu
IGF0IHVubWFwIHRpbWUsIHRob3VnaCwgaW4gb3JkZXIgdG8gYXZvaWQKPiByZXBlYXRlZCBzaW5n
bGUgYnl0ZSBpbnZhbGlkYXRpb25zLgoKT2ssIEkgd2lsbCBhZGQgYSBjYWNoZSBpbnZhbGlkYXRp
b24gYXQgdW5tYXAgdGltZS4KCj4gCj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIGlmIChzdG9yZWQg
PT0gaXNfcGVuZGluZykKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+Pgo+
PiAtwqDCoMKgwqDCoMKgwqAgaWYgKGlycS0+cGVuZGluZ19sYXRjaCkKPj4gK8KgwqDCoMKgwqDC
oMKgIGlmIChpc19wZW5kaW5nKQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmFsIHw9IDEg
PDwgYml0X25yOwo+PiDCoMKgwqDCoMKgwqDCoMKgIGVsc2UKPj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHZhbCAmPSB+KDEgPDwgYml0X25yKTsKPj4KPj4gwqDCoMKgwqDCoMKgwqDCoCByZXQg
PSBrdm1fd3JpdGVfZ3Vlc3RfbG9jayhrdm0sIHB0ciwgJnZhbCwgMSk7Cj4+IMKgwqDCoMKgwqDC
oMKgwqAgaWYgKHJldCkKPj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsKPj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+IMKgwqDCoMKgIH0KPj4gLcKgwqDC
oCByZXR1cm4gMDsKPj4gKwo+PiArb3V0Ogo+PiArwqDCoMKgIG1hcF9hbGxfdnBlcyhkaXN0KTsK
Pj4gKwo+PiArwqDCoMKgIHJldHVybiByZXQ7Cj4+IMKgfQo+Pgo+PiDCoC8qKgo+IAo+IFRoYW5r
cywKPiAKPiDCoMKgwqDCoMKgwqDCoCBNLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
