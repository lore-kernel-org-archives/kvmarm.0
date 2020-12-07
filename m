Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441B7C4361B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 15:56:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 969712388D
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 15:56:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 969712388D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3504B236;
	Mon,  7 Dec 2020 10:56:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u1F6IeyOTLop; Mon,  7 Dec 2020 10:56:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3D4D4B260;
	Mon,  7 Dec 2020 10:56:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C18604B25B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 10:56:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0hYO--KMjHmE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 10:55:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A2F84B236
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 10:55:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6113423741;
 Mon,  7 Dec 2020 15:55:58 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kmIrk-00Gnm0-3l; Mon, 07 Dec 2020 15:55:56 +0000
MIME-Version: 1.0
Date: Mon, 07 Dec 2020 15:55:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v6 1/2] arm64: kvm: Save/restore MTE registers
In-Reply-To: <03566358-21b0-11d9-c4f6-d07d137a1009@arm.com>
References: <20201127152113.13099-1-steven.price@arm.com>
 <20201127152113.13099-2-steven.price@arm.com>
 <946b1e7b06c4d286a78cf61408e0fc8d@kernel.org>
 <03566358-21b0-11d9-c4f6-d07d137a1009@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <07e40bbcf734e8c63630168406262bb2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com,
 will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Dave.Martin@arm.com, mark.rutland@arm.com, tglx@linutronix.de,
 qemu-devel@nongnu.org, quintela@redhat.com, dgilbert@redhat.com,
 richard.henderson@linaro.org, peter.maydell@linaro.org, Haibo.Xu@arm.com,
 drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0xMi0wNyAxNDo0OCwgU3RldmVuIFByaWNlIHdyb3RlOgo+IE9uIDAzLzEyLzIwMjAg
MTc6MDcsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9zeXNyZWcuaCAKPj4+IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNy
ZWcuaAo+Pj4gaW5kZXggZTJlZjRjMmVkZjA2Li5iNjY2OGZmYTA0ZDkgMTAwNjQ0Cj4+PiAtLS0g
YS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oCj4+PiArKysgYi9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL3N5c3JlZy5oCj4+PiBAQCAtNTY5LDcgKzU2OSw4IEBACj4+PiDCoCNkZWZpbmUg
U0NUTFJfRUx4X03CoMKgwqAgKEJJVCgwKSkKPj4+IAo+Pj4gwqAjZGVmaW5lIFNDVExSX0VMeF9G
TEFHU8KgwqDCoCAoU0NUTFJfRUx4X03CoCB8IFNDVExSX0VMeF9BIHwgU0NUTFJfRUx4X0MgCj4+
PiB8IFwKPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgU0NUTFJfRUx4X1NBIHwgU0NUTFJf
RUx4X0kgfCBTQ1RMUl9FTHhfSUVTQikKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgU0NU
TFJfRUx4X1NBIHwgU0NUTFJfRUx4X0kgfCBTQ1RMUl9FTHhfSUVTQiB8IFwKPj4+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgU0NUTFJfRUx4X0lURlNCKQo+Pj4gCj4+PiDCoC8qIFNDVExSX0VM
MiBzcGVjaWZpYyBmbGFncy4gKi8KPj4+IMKgI2RlZmluZSBTQ1RMUl9FTDJfUkVTMcKgwqDCoCAo
KEJJVCg0KSnCoCB8IChCSVQoNSkpwqAgfCAoQklUKDExKSkgfCAKPj4+IChCSVQoMTYpKSB8IFwK
Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9oeXAvaW5jbHVkZS9oeXAvc3lzcmVnLXNy
LmgKPj4+IGIvYXJjaC9hcm02NC9rdm0vaHlwL2luY2x1ZGUvaHlwL3N5c3JlZy1zci5oCj4+PiBp
bmRleCBjY2U0M2JmZTE1OGYuLjQ1MjU1YmE2MDE1MiAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJt
NjQva3ZtL2h5cC9pbmNsdWRlL2h5cC9zeXNyZWctc3IuaAo+Pj4gKysrIGIvYXJjaC9hcm02NC9r
dm0vaHlwL2luY2x1ZGUvaHlwL3N5c3JlZy1zci5oCj4+PiBAQCAtMTgsNiArMTgsMTEgQEAKPj4+
IMKgc3RhdGljIGlubGluZSB2b2lkIF9fc3lzcmVnX3NhdmVfY29tbW9uX3N0YXRlKHN0cnVjdCBr
dm1fY3B1X2NvbnRleHQgCj4+PiAqY3R4dCkKPj4+IMKgewo+Pj4gwqDCoMKgwqAgY3R4dF9zeXNf
cmVnKGN0eHQsIE1EU0NSX0VMMSnCoMKgwqAgPSByZWFkX3N5c3JlZyhtZHNjcl9lbDEpOwo+Pj4g
K8KgwqDCoCBpZiAoc3lzdGVtX3N1cHBvcnRzX210ZSgpKSB7Cj4+IAo+PiBQbGVhc2UgbW92ZSB0
aGUgcGVyLVZNIHByZWRpY2F0ZSB0byB0aGlzIHBhdGNoIHNvIHRoYXQgaXQgY2FuIGJlIHVzZWQK
Pj4gbm90IHRvIHNhdmUvcmVzdG9yZSB0aGUgTVRFIHJlZ2lzdGVycyBpZiB3ZSBkb24ndCBuZWVk
IHRvLgo+IAo+IFRoZXJlIGlzbid0IGEgdmFsaWQgc3RydWN0IGt2bV92Y3B1IG9yIHN0cnVjdCBr
dm0gaGVyZS4gSSBrbm93IHRoZXJlJ3MKPiBjdHgtPl9faHlwX3J1bm5pbmdfdmNwdSBidXQgQUZB
SUNUIHRoYXQgaXMgb25seSB2YWxpZCB3aXRoIHRoZSBob3N0Cj4gY29udGV4dC4KCldlIGhhdmUg
cGVyLUNQVSB2YXJpYWJsZXMgZm9yIHRoZSBob3N0IGNvbnRleHQuIElmIApjdHgtPl9faHlwX3J1
bm5pbmdfdmNwdQppcyBub24gTlVMTCwgeW91IGtub3cgeW91J3JlIG9uIHRoZSBob3N0LgoKCj4g
Cj4+IAo+Pj4gK8KgwqDCoMKgwqDCoMKgIGN0eHRfc3lzX3JlZyhjdHh0LCBSR1NSX0VMMSnCoMKg
wqAgPSAKPj4+IHJlYWRfc3lzcmVnX3MoU1lTX1JHU1JfRUwxKTsKPj4+ICvCoMKgwqDCoMKgwqDC
oCBjdHh0X3N5c19yZWcoY3R4dCwgR0NSX0VMMSnCoMKgwqAgPSByZWFkX3N5c3JlZ19zKFNZU19H
Q1JfRUwxKTsKPj4+ICvCoMKgwqDCoMKgwqDCoCBjdHh0X3N5c19yZWcoY3R4dCwgVEZTUkUwX0VM
MSnCoMKgwqAgPSAKPj4+IHJlYWRfc3lzcmVnX3MoU1lTX1RGU1JFMF9FTDEpOwo+Pj4gK8KgwqDC
oCB9Cj4+IAo+PiBPdmVyYWxsLCBJIHN0aWxsIGRvbid0IHVuZGVyc3RhbmQgaG93IHRoaXMgaXMg
Z29pbmcgdG8gd29yayBvbmNlCj4+IHdlIGhhdmUgTVRFIGluIHRoZSBrZXJuZWwuIFlvdSBtZW50
aW9uZWQgaGF2aW5nIHRoZSBhYmlsaXR5IHRvCj4+IGNyZWF0ZSB0dXJuIG9mZiB0aGUgdGFnIGNo
ZWNrcyBhdCB0aW1lcywgYnV0IEkgZG9uJ3Qgc2VlIHRoYXQKPj4gaW4gdGhpcyBwYXRjaCAoYW5k
IEknbSBub3Qgc3VyZSB3ZSB3YW50IHRoYXQgZWl0aGVyKS4KPiAKPiBHaXZlbiB0aGF0IHRoaXMg
aXMgbm93IGhpZ2hseSB1bmxpa2VseSB0byBiZSBtZXJnZWQgZm9yIHY1LjExLCBJJ2xsCj4gcmVi
YXNlIG9udG8gb2YgdGhlIEtBU0FOIE1URSBzZXJpZXMgYW5kIGRvdWJsZSBjaGVjayBleGFjdGx5
IHdoYXQKPiBoYXBwZW5zLiBNeSB0aG91Z2h0IHdhcyB0aGF0IGl0IHNob3VsZCBiZSBhcyBzaW1w
bGUgYXMgc2V0dGluZyBUQ08sCj4gYnV0IHlvdXIgcHJldmlvdXMgY29tbWVudCBhYm91dCBtb3Zp
bmcgdGhlIHNhdmUvcmVzdG9yZSBpbnRvIGFzc2VtYmxlcgo+IG1pZ2h0IGJlIHdpc2UgaW4gY2Fz
ZSB0aGUgY29tcGlsZXIgc3RhcnRzIHBsYXlpbmcgd2l0aCBUQ08gaXRzZWxmLgoKSW5kZWVkLgoK
VGhhbmtzLAoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxz
IGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
