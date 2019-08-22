Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD87C3A59D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:05:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1EC7205ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1EC7205ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F1B4A584;
	Thu, 22 Aug 2019 05:29:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A96j7qAKoshU; Thu, 22 Aug 2019 05:29:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6610B4A537;
	Thu, 22 Aug 2019 05:29:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F7D4A537
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 05:29:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NxlxVslKzmRJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 05:29:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94C7A4A4EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 05:29:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F9B2360;
 Thu, 22 Aug 2019 02:29:22 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 93FFA3F246; Thu, 22 Aug 2019 02:29:20 -0700 (PDT)
Subject: Re: Can we boot a 512U kvm guest?
To: Auger Eric <eric.auger@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.cs.columbia.edu, qemu-arm@nongnu.org
References: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
 <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <fbeb47df-7ea2-04ce-5fe3-a6a6a4751b8b@kernel.org>
Date: Thu, 22 Aug 2019 10:29:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
Content-Language: en-US
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org
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

SGkgRXJpYywKCk9uIDIyLzA4LzIwMTkgMTA6MDgsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4gSGkgWmVu
Z2h1aSwKPiAKPiBPbiA4LzEzLzE5IDEwOjUwIEFNLCBaZW5naHVpIFl1IHdyb3RlOgo+PiBIaSBm
b2xrcywKPj4KPj4gU2luY2UgY29tbWl0IGUyNTAyOGM4ZGVkMCAoIktWTTogYXJtL2FybTY0OiBC
dW1wIFZHSUNfVjNfTUFYX0NQVVMgdG8KPj4gNTEyIiksIHdlIHNlZW1lZCB0byBiZSBhbGxvd2Vk
IHRvIGJvb3QgYSA1MTJVIGd1ZXN0LsKgIEJ1dCBJIGZhaWxlZCB0bwo+PiBzdGFydCBpdCB1cCB3
aXRoIHRoZSBsYXRlc3QgUUVNVS7CoCBJIGd1ZXNzIHRoZXJlIGFyZSBhdCBsZWFzdCAqdHdvKgo+
PiByZWFzb25zIChsaW1pdGF0aW9ucykuCj4+Cj4+IEZpcnN0IEkgZ290IGEgUUVNVSBhYm9ydDoK
Pj4gwqDCoMKgwqAia3ZtX3NldF9pcnE6IEludmFsaWQgYXJndW1lbnQiCj4+Cj4+IEVuYWJsZSB0
aGUgdHJhY2Vfa3ZtX2lycV9saW5lKCkgdW5kZXIgZGVidWdmcywgd2hlbiBpdCBjb21lZCB3aXRo
Cj4+IHZjcHUtMjU2LCBJIGdvdDoKPj4gwqDCoMKgwqAiSW5qZWN0IFVOS05PV04gaW50ZXJydXB0
ICgzKSwgdmNwdS0+aWR4OiAwLCBudW06IDIzLCBsZXZlbDogMCIKPj4gYW5kIGt2bV92bV9pb2N0
bF9pcnFfbGluZSgpIHJldHVybnMgLUVJTlZBTCB0byB1c2VyLXNwYWNlLi4uCj4+Cj4+IFNvIHRo
ZSB0aGluZyBpcyB0aGF0IHdlIG9ubHkgaGF2ZSA4IGJpdHMgZm9yIHZjcHVfaW5kZXggZmllbGQg
KFsyMzoxNl0pCj4+IGluIEtWTV9JUlFfTElORSBpb2N0bC7CoCBpcnFfdHlwZSBmaWVsZCB3aWxs
IGJlIGNvcnJ1cHRlZCBpZiB3ZSBpbmplY3QgYQo+PiBQUEkgdG8gdmNwdS0yNTYsIHdob3NlIHZj
cHVfaW5kZXggd2lsbCB0YWtlIDkgYml0cy4KPj4KPj4gSSB0ZW1wb3JhcmlseSBwYXRjaGVkIHRo
ZSBLVk0gYW5kIFFFTVUgd2l0aCB0aGUgZm9sbG93aW5nIGRpZmY6Cj4+Cj4+IC0tLTg8LS0tCj4+
IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPj4gYi9hcmNo
L2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPj4gaW5kZXggOTU1MTZhNC4uMzlhMGZiMSAx
MDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCj4+ICsrKyBi
L2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaAo+PiBAQCAtMzI1LDEwICszMjUsMTAg
QEAgc3RydWN0IGt2bV92Y3B1X2V2ZW50cyB7Cj4+IMKgI2RlZmluZcKgwqAgS1ZNX0FSTV9WQ1BV
X1RJTUVSX0lSUV9QVElNRVLCoMKgwqDCoMKgwqDCoCAxCj4+Cj4+IMKgLyogS1ZNX0lSUV9MSU5F
IGlycSBmaWVsZCBpbmRleCB2YWx1ZXMgKi8KPj4gLSNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9T
SElGVMKgwqDCoMKgwqDCoMKgIDI0Cj4+IC0jZGVmaW5lIEtWTV9BUk1fSVJRX1RZUEVfTUFTS8Kg
wqDCoMKgwqDCoMKgIDB4ZmYKPj4gKyNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9TSElGVMKgwqDC
oMKgwqDCoMKgIDI4Cj4+ICsjZGVmaW5lIEtWTV9BUk1fSVJRX1RZUEVfTUFTS8KgwqDCoMKgwqDC
oMKgIDB4Zgo+PiDCoCNkZWZpbmUgS1ZNX0FSTV9JUlFfVkNQVV9TSElGVMKgwqDCoMKgwqDCoMKg
IDE2Cj4+IC0jZGVmaW5lIEtWTV9BUk1fSVJRX1ZDUFVfTUFTS8KgwqDCoMKgwqDCoMKgIDB4ZmYK
Pj4gKyNkZWZpbmUgS1ZNX0FSTV9JUlFfVkNQVV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZmYKPj4g
wqAjZGVmaW5lIEtWTV9BUk1fSVJRX05VTV9TSElGVMKgwqDCoMKgwqDCoMKgIDAKPj4gwqAjZGVm
aW5lIEtWTV9BUk1fSVJRX05VTV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZmZmCj4+Cj4+IC0tLTg8
LS0tCj4+Cj4+IEl0IG1ha2VzIHRoaW5ncyBhIGJpdCBiZXR0ZXIsIGl0IGFsc28gaW1tZWRpYXRl
bHkgQlJFQUtzIHRoZSBhcGkgd2l0aAo+PiBvbGQgdmVyc2lvbnMuCj4+Cj4+Cj4+IE5leHQgY29t
ZXMgb25lIG1vcmUgUUVNVSBhYm9ydCAod2l0aCB0aGUgImZpeCIgYWJvdmUpOgo+PiDCoMKgwqDC
oCJGYWlsZWQgdG8gc2V0IGRldmljZSBhZGRyZXNzOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZSIK
Pj4KPj4gV2UgcmVnaXN0ZXIgdHdvIGlvIGRldmljZXMgKHJkX2RldiBhbmQgc2dpX2Rldikgb24g
S1ZNX01NSU9fQlVTIGZvcgo+PiBlYWNoIHJlZGlzdHJpYnV0b3IuIDUxMiB2Y3B1cyB0YWtlIDEw
MjQgaW8gZGV2aWNlcywgd2hpY2ggaXMgYmV5b25kIHRoZQo+PiBtYXhpbXVtIGxpbWl0YXRpb24g
b2YgdGhlIGN1cnJlbnQga2VybmVsIC0gTlJfSU9CVVNfREVWUyAoMTAwMCkuCj4+IFNvIHdlIGdl
dCBhIEVOT1NQQyBlcnJvciBoZXJlLgo+IAo+IERvIHlvdSBwbGFuIHRvIHNlbmQgYSBwYXRjaCBm
b3IgaW5jcmVhc2luZyB0aGUgTlJfSU9CVVNfREVWUz8gT3RoZXJ3aXNlCj4gSSBjYW4gZG8gaXQu
CgpJIHJlYWxseSB3b25kZXIgd2hldGhlciB0aGF0J3MgYSBzZW5zaWJsZSB0aGluZyB0byBkbyBv
biBpdHMgb3duLgoKTG9va2luZyBhdCB0aGUgaW1wbGVtZW50YXRpb24gb2Yga3ZtX2lvX2J1c19y
ZWdpc3Rlcl9kZXYgKHdoaWNoIGNvcGllcwp0aGUgd2hvbGUgYXJyYXkgZWFjaCB0aW1lIHdlIGlu
c2VydCBhIGRldmljZSksIHdlIGhhdmUgYW4gb2J2aW91cyBpc3N1ZQp3aXRoIHN5c3RlbXMgdGhh
dCBjcmVhdGUgYSBsYXJnZSBudW1iZXIgb2YgZGV2aWNlIHN0cnVjdHVyZXMsIGxlYWRpbmcgdG8K
bGFyZ2UgdHJhbnNpZW50IG1lbW9yeSB1c2FnZSBhbmQgc2xvdyBndWVzdCBzdGFydC4KCldlIGNv
dWxkIGFsc28gdHJ5IGFuZCByZWR1Y2UgdGhlIG51bWJlciBvZiBkZXZpY2VzIHdlIGluc2VydCBi
eSBtYWtpbmcKdGhlIHJlZGlzdHJpYnV0b3IgYSBzaW5nbGUgZGV2aWNlICh3aGljaCBpdCBpcyBp
biByZWFsaXR5KS4gSXQgcHJvYmFibHkKbWVhbnMgd2UgbmVlZCB0byBtYWtlIHRoZSBNTUlPIGRl
Y29kaW5nIG1vcmUgZmxleGlibGUuCgpUaGFua3MsCgoJTS4KLS0gCkphenogaXMgbm90IGRlYWQs
IGl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
