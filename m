Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1373BC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 02:13:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A8DE22D50
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 02:13:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A8DE22D50
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70A4C4B311;
	Tue,  5 Jan 2021 21:13:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wS3uJ91WsvEw; Tue,  5 Jan 2021 21:13:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D2724B2F6;
	Tue,  5 Jan 2021 21:13:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EE344B2F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 21:13:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EdpUMhGDOvVh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 21:13:03 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11E164B266
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 21:13:03 -0500 (EST)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D9XtT5Hf1zj3Vx;
 Wed,  6 Jan 2021 10:12:01 +0800 (CST)
Received: from [10.174.184.196] (10.174.184.196) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 6 Jan 2021 10:12:50 +0800
Subject: Re: [RFC PATCH v2 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
To: Marc Zyngier <maz@kernel.org>
References: <20210104081613.100-1-lushenming@huawei.com>
 <20210104081613.100-4-lushenming@huawei.com>
 <76a7b9cca485dc8157d3be53189eac69@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <6b815f0e-d042-2ec6-369a-41a19cd1b9f9@huawei.com>
Date: Wed, 6 Jan 2021 10:12:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <76a7b9cca485dc8157d3be53189eac69@kernel.org>
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

T24gMjAyMS8xLzUgMTc6MjUsIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIxLTAxLTA0IDA4
OjE2LCBTaGVubWluZyBMdSB3cm90ZToKPj4gRnJvbTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1
YXdlaS5jb20+Cj4+Cj4+IFdoZW4gc2V0dGluZyB0aGUgZm9yd2FyZGluZyBwYXRoIG9mIGEgVkxQ
SSAoc3dpdGNoIHRvIHRoZSBIVyBtb2RlKSwKPj4gd2UgY291bGQgYWxzbyB0cmFuc2ZlciB0aGUg
cGVuZGluZyBzdGF0ZSBmcm9tIGlycS0+cGVuZGluZ19sYXRjaCB0bwo+PiBWUFQgKGVzcGVjaWFs
bHkgaW4gbWlncmF0aW9uLCB0aGUgcGVuZGluZyBzdGF0ZXMgb2YgVkxQSXMgYXJlIHJlc3RvcmVk
Cj4+IGludG8ga3Zt4oCZcyB2Z2ljIGZpcnN0KS4gQW5kIHdlIGN1cnJlbnRseSBzZW5kICJJTlQr
VlNZTkMiIHRvIHRyaWdnZXIKPj4gYSBWTFBJIHRvIHBlbmRpbmcuCj4+Cj4+IFNpZ25lZC1vZmYt
Ynk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+PiBTaWduZWQtb2ZmLWJ5OiBT
aGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+PiAtLS0KPj4gwqBhcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMtdjQuYyB8IDEyICsrKysrKysrKysrKwo+PiDCoDEgZmlsZSBjaGFuZ2Vk
LCAxMiBpbnNlcnRpb25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtdjQuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4+IGluZGV4IGYyMTFh
N2MzMjcwNC4uNzk0NWQ2ZDA5Y2RkIDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtdjQuYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwo+PiBAQCAt
NDU0LDYgKzQ1NCwxOCBAQCBpbnQga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoc3RydWN0IGt2
bSAqa3ZtLCBpbnQgdmlycSwKPj4gwqDCoMKgwqAgaXJxLT5ob3N0X2lyccKgwqDCoCA9IHZpcnE7
Cj4+IMKgwqDCoMKgIGF0b21pY19pbmMoJm1hcC52cGUtPnZscGlfY291bnQpOwo+Pgo+PiArwqDC
oMKgIC8qIFRyYW5zZmVyIHBlbmRpbmcgc3RhdGUgKi8KPj4gK8KgwqDCoCByZXQgPSBpcnFfc2V0
X2lycWNoaXBfc3RhdGUoaXJxLT5ob3N0X2lycSwKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIElSUUNISVBfU1RBVEVfUEVORElORywKPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlycS0+cGVuZGluZ19sYXRjaCk7Cj4+ICvCoMKgwqAg
V0FSTl9SQVRFTElNSVQocmV0LCAiSVJRICVkIiwgaXJxLT5ob3N0X2lycSk7Cj4gCj4gV2h5IGRv
IHRoaXMgaWYgcGVuZGluZ19sYXRjaCBpcyAwLCB3aGljaCBpcyBsaWtlbHkgdG8gYmUKPiB0aGUg
b3ZlcndoZWxtaW5nIGNhc2U/CgpZZXMsIHRoZXJlIGlzIG5vIG5lZWQgdG8gZG8gdGhpcyBpZiBw
ZW5kaW5nX2xhdGNoIGlzIDAuCgo+IAo+PiArCj4+ICvCoMKgwqAgLyoKPj4gK8KgwqDCoMKgICog
TGV0IGl0IGJlIHBydW5lZCBmcm9tIGFwX2xpc3QgbGF0ZXIgYW5kIGRvbid0IGJvdGhlcgo+PiAr
wqDCoMKgwqAgKiB0aGUgTGlzdCBSZWdpc3Rlci4KPj4gK8KgwqDCoMKgICovCj4+ICvCoMKgwqAg
aXJxLT5wZW5kaW5nX2xhdGNoID0gZmFsc2U7Cj4gCj4gV2hhdCBndWFyYW50ZWVzIHRoZSBwcnVu
aW5nPyBQcnVuaW5nIG9ubHkgaGFwcGVucyBvbiB2Y3B1IGV4aXQsCj4gd2hpY2ggbWVhbnMgd2Ug
bWF5IGhhdmUgdGhlIHNhbWUgaW50ZXJydXB0IHZpYSBib3RoIHRoZSBMUiBhbmQKPiB0aGUgc3Ry
ZWFtIGludGVyZmFjZSwgd2hpY2ggSSBkb24ndCBiZWxpZXZlIGlzIGxlZ2FsIChpdCBpcwo+IGxp
a2UgaGF2aW5nIHR3byBMUnMgaG9sZGluZyB0aGUgc2FtZSBpbnRlcnJ1cHQpLgoKU2luY2UgdGhl
IGlycSdzIHBlbmRpbmdfbGF0Y2ggaXMgc2V0IHRvIGZhbHNlIGhlcmUsIGl0IHdpbGwgbm90IGJl
CnBvcHVsYXRlZCB0byB0aGUgTFIgaW4gdmdpY19mbHVzaF9scl9zdGF0ZSgpICh2Z2ljX3Rhcmdl
dF9vcmFjbGUoKQp3aWxsIHJldHVybiBOVUxMKS4KCj4gCj4+ICsKPj4gwqBvdXQ6Cj4+IMKgwqDC
oMKgIG11dGV4X3VubG9jaygmaXRzLT5pdHNfbG9jayk7Cj4+IMKgwqDCoMKgIHJldHVybiByZXQ7
Cj4gCj4gVGhhbmtzLAo+IAo+IMKgwqDCoMKgwqDCoMKgIE0uCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
