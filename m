Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F81C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 15:19:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DEAD60F41
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 15:19:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6DEAD60F41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC4664A4A4;
	Tue, 10 Aug 2021 11:19:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GRDnDNMmq3od; Tue, 10 Aug 2021 11:18:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6D5B4A126;
	Tue, 10 Aug 2021 11:18:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C821E4A126
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 11:18:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MhBQ8f0kW4W6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 11:18:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5897F49FB0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 11:18:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F14001FB;
 Tue, 10 Aug 2021 08:18:48 -0700 (PDT)
Received: from [10.163.67.89] (unknown [10.163.67.89])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA9403F718;
 Tue, 10 Aug 2021 08:18:45 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: arm64: Define KVM_PHYS_SHIFT_MIN
To: Marc Zyngier <maz@kernel.org>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-6-git-send-email-anshuman.khandual@arm.com>
 <2dbeb2c329cfeb1ee9a7331683cdbc97@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <43c5ffa3-b3c5-9154-72b5-811eeb9ece8f@arm.com>
Date: Tue, 10 Aug 2021 20:49:38 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2dbeb2c329cfeb1ee9a7331683cdbc97@kernel.org>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

CgpPbiA4LzEwLzIxIDY6NTkgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiAyMDIxLTA4LTEw
IDA4OjAyLCBBbnNodW1hbiBLaGFuZHVhbCB3cm90ZToKPj4gRHJvcCB0aGUgaGFyZCBjb2RlZCB2
YWx1ZSBmb3IgdGhlIG1pbmltdW0gSVBBIHJhbmdlIGkuZSAzMiBiaXQuIEluc3RlYWQKPj4gZGVm
aW5lIGEgbWFjcm8gS1ZNX1BIWVNfU0hJRlRfTUlOIHdoaWNoIGltcHJvdmVzIHRoZSBjb2RlIHJl
YWRhYmlsaXR5Lgo+Pgo+PiBDYzogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4gQ2M6
IEphbWVzIE1vcnNlIDxqYW1lcy5tb3JzZUBhcm0uY29tPgo+PiBDYzogQWxleGFuZHJ1IEVsaXNl
aSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgo+PiBDYzogU3V6dWtpIEsgUG91bG9zZSA8c3V6
dWtpLnBvdWxvc2VAYXJtLmNvbT4KPj4gQ2M6IENhdGFsaW4gTWFyaW5hcyA8Y2F0YWxpbi5tYXJp
bmFzQGFybS5jb20+Cj4+IENjOiBXaWxsIERlYWNvbiA8d2lsbEBrZXJuZWwub3JnPgo+PiBDYzog
bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCj4+IENjOiBrdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cj4+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnCj4+IFNp
Z25lZC1vZmYtYnk6IEFuc2h1bWFuIEtoYW5kdWFsIDxhbnNodW1hbi5raGFuZHVhbEBhcm0uY29t
Pgo+PiAtLS0KPj4gwqBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9tbXUuaCB8IDMgKystCj4+
IMKgYXJjaC9hcm02NC9rdm0vcmVzZXQuY8KgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+PiDC
oDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+Pgo+PiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fbW11LmggYi9hcmNoL2FybTY0
L2luY2x1ZGUvYXNtL2t2bV9tbXUuaAo+PiBpbmRleCBiNTJjNWM0YjlhM2QuLjcxNmY5OTk4MThk
OSAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fbW11LmgKPj4gKysr
IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fbW11LmgKPj4gQEAgLTE0MSw3ICsxNDEsOCBA
QCBzdGF0aWMgX19hbHdheXNfaW5saW5lIHVuc2lnbmVkIGxvbmcKPj4gX19rZXJuX2h5cF92YSh1
bnNpZ25lZCBsb25nIHYpCj4+IMKgICogV2UgY3VycmVudGx5IHN1cHBvcnQgdXNpbmcgYSBWTS1z
cGVjaWZpZWQgSVBBIHNpemUuIEZvciBiYWNrd2FyZAo+PiDCoCAqIGNvbXBhdGliaWxpdHksIHRo
ZSBkZWZhdWx0IElQQSBzaXplIGlzIGZpeGVkIHRvIDQwYml0cy4KPj4gwqAgKi8KPj4gLSNkZWZp
bmUgS1ZNX1BIWVNfU0hJRlTCoMKgwqAgKDQwKQo+PiArI2RlZmluZSBLVk1fUEhZU19TSElGVMKg
wqDCoMKgwqDCoMKgICg0MCkKPj4gKyNkZWZpbmUgS1ZNX1BIWVNfU0hJRlRfTUlOwqDCoMKgICgz
MikKPj4KPj4gwqAjZGVmaW5lIGt2bV9waHlzX3NoaWZ0KGt2bSnCoMKgwqDCoMKgwqDCoCBWVENS
X0VMMl9JUEEoa3ZtLT5hcmNoLnZ0Y3IpCj4+IMKgI2RlZmluZSBrdm1fcGh5c19zaXplKGt2bSnC
oMKgwqDCoMKgwqDCoCAoX0FDKDEsIFVMTCkgPDwga3ZtX3BoeXNfc2hpZnQoa3ZtKSkKPj4gZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMgYi9hcmNoL2FybTY0L2t2bS9yZXNldC5j
Cj4+IGluZGV4IGNiYTc4NzJkNjlhOC4uOGRjOGI0YjlkZTM3IDEwMDY0NAo+PiAtLS0gYS9hcmNo
L2FybTY0L2t2bS9yZXNldC5jCj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMKPj4gQEAg
LTM2OSw3ICszNjksNyBAQCBpbnQga3ZtX2FybV9zZXR1cF9zdGFnZTIoc3RydWN0IGt2bSAqa3Zt
LCB1bnNpZ25lZAo+PiBsb25nIHR5cGUpCj4+IMKgwqDCoMKgIHBoeXNfc2hpZnQgPSBLVk1fVk1f
VFlQRV9BUk1fSVBBX1NJWkUodHlwZSk7Cj4+IMKgwqDCoMKgIGlmIChwaHlzX3NoaWZ0KSB7Cj4+
IMKgwqDCoMKgwqDCoMKgwqAgaWYgKHBoeXNfc2hpZnQgPiBrdm1faXBhX2xpbWl0IHx8Cj4+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBoeXNfc2hpZnQgPCAzMikKPj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcGh5c19zaGlmdCA8IEtWTV9QSFlTX1NISUZUX01JTikKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+PiDCoMKgwqDCoCB9IGVsc2Ugewo+PiDCoMKg
wqDCoMKgwqDCoMKgIHBoeXNfc2hpZnQgPSBLVk1fUEhZU19TSElGVDsKPiAKPiBUaGlzIGlzIG5v
dCBhIEtWTSBwcm9wZXJ0eSwgYnV0IGFuIGFyY2hpdGVjdHVyYWwgb25lLiBJZiB5b3UKCkFyY2hp
dGVjdHVyYWwgcHJvcGVydHkgd2hpY2ggc3VnZ2VzdCB0aGUgbWluaW11bSBwaHlzaWNhbCBhZGRy
ZXNzIHNoaWZ0CnN1cHBvcnRlZCBvbiBhIHBsYXRmb3JtLCBhcyBpbmRpY2F0ZWQgdmlhIElEX0FB
NjRNTUZSMC5QQVJBTkdFID0gMHgwID8KCj4gd2FudCB0byByZXBsYWNlIGl0IHdpdGggc29tZXRo
aW5nIG1vcmUgcmVhZGFibGUsIHBsZWFzZQo+IG1ha2UgaXQgZ2xvYmFsIHRvIHRoZSB3aG9sZSBv
ZiBhcm02NCAoQVJNNjRfTUlOX1BBUkFOR0U/KS4KClN1cmUsIHdpbGwgZG8uCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
