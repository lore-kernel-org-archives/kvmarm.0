Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B3BC433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 11:50:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BFAD23109
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 11:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BFAD23109
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB3A54B2BE;
	Tue, 12 Jan 2021 06:50:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 56m8rcBJ9z8n; Tue, 12 Jan 2021 06:50:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7474B2BB;
	Tue, 12 Jan 2021 06:50:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87EC34B2B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 06:50:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DgxSoELEzagi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 06:50:18 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50E1D4B2B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 06:50:18 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 05C6F23104;
 Tue, 12 Jan 2021 11:50:17 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kzIBi-006wqv-RB; Tue, 12 Jan 2021 11:50:14 +0000
MIME-Version: 1.0
Date: Tue, 12 Jan 2021 11:50:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
In-Reply-To: <a122aa5c-4af9-e236-db82-db0ed885e0a5@arm.com>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-10-maz@kernel.org> <20210111184154.GC17941@gaia>
 <129db8bd3913a90c96d4cfe4f55e27a0@kernel.org>
 <a122aa5c-4af9-e236-db82-db0ed885e0a5@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <d98aed718a26d0455d5549d53f97db06@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

SGkgU3V6dWtpLAoKT24gMjAyMS0wMS0xMiAwOToxNywgU3V6dWtpIEsgUG91bG9zZSB3cm90ZToK
PiBIaSBNYXJjLAo+IAo+IE9uIDEvMTEvMjEgNzo0OCBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgoK
Wy4uLl0KCj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0dXJlLmMgCj4+
IGIvYXJjaC9hcm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jCj4+IGluZGV4IDg5NGFmNjBiOTY2OS4u
MDBkOTllNTkzYjY1IDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0dXJl
LmMKPj4gKysrIGIvYXJjaC9hcm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jCj4+IEBAIC03NzQsNiAr
Nzc0LDcgQEAgc3RhdGljIHZvaWQgX19pbml0IGluaXRfY3B1X2Z0cl9yZWcodTMyIHN5c19yZWcs
IAo+PiB1NjQgbmV3KQo+PiAgwqDCoMKgwqAgdTY0IHN0cmljdF9tYXNrID0gfjB4MFVMTDsKPj4g
IMKgwqDCoMKgIHU2NCB1c2VyX21hc2sgPSAwOwo+PiAgwqDCoMKgwqAgdTY0IHZhbGlkX21hc2sg
PSAwOwo+PiArwqDCoMKgIHU2NCBvdmVycmlkZV92YWwgPSAwLCBvdmVycmlkZV9tYXNrID0gMDsK
Pj4gCj4+ICDCoMKgwqDCoCBjb25zdCBzdHJ1Y3QgYXJtNjRfZnRyX2JpdHMgKmZ0cnA7Cj4+ICDC
oMKgwqDCoCBzdHJ1Y3QgYXJtNjRfZnRyX3JlZyAqcmVnID0gZ2V0X2FybTY0X2Z0cl9yZWcoc3lz
X3JlZyk7Cj4+IEBAIC03ODEsOSArNzgyLDM1IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBpbml0X2Nw
dV9mdHJfcmVnKHUzMiBzeXNfcmVnLCAKPj4gdTY0IG5ldykKPj4gIMKgwqDCoMKgIGlmICghcmVn
KQo+PiAgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm47Cj4+IAo+PiArwqDCoMKgIGlmIChyZWctPm92
ZXJyaWRlX21hc2sgJiYgcmVnLT5vdmVycmlkZV92YWwpIHsKPj4gK8KgwqDCoMKgwqDCoMKgIG92
ZXJyaWRlX21hc2sgPSAqcmVnLT5vdmVycmlkZV9tYXNrOwo+PiArwqDCoMKgwqDCoMKgwqAgb3Zl
cnJpZGVfdmFsID0gKnJlZy0+b3ZlcnJpZGVfdmFsOwo+PiArwqDCoMKgIH0KPj4gKwo+PiAgwqDC
oMKgwqAgZm9yIChmdHJwID0gcmVnLT5mdHJfYml0czsgZnRycC0+d2lkdGg7IGZ0cnArKykgewo+
PiAgwqDCoMKgwqDCoMKgwqDCoCB1NjQgZnRyX21hc2sgPSBhcm02NF9mdHJfbWFzayhmdHJwKTsK
Pj4gIMKgwqDCoMKgwqDCoMKgwqAgczY0IGZ0cl9uZXcgPSBhcm02NF9mdHJfdmFsdWUoZnRycCwg
bmV3KTsKPj4gK8KgwqDCoMKgwqDCoMKgIHM2NCBmdHJfb3ZyID0gYXJtNjRfZnRyX3ZhbHVlKGZ0
cnAsIG92ZXJyaWRlX3ZhbCk7Cj4+ICsKPj4gK8KgwqDCoMKgwqDCoMKgIGlmICgoZnRyX21hc2sg
JiBvdmVycmlkZV9tYXNrKSA9PSBmdHJfbWFzaykgewo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBpZiAoZnRyX292ciA8IGZ0cl9uZXcpIHsKPiAKPiBIZXJlIHdlIGFzc3VtZSB0aGF0IGFsbCB0
aGUgZmVhdHVyZXMgYXJlIEZUUl9MT1dFUl9TQUZFLiBXZSBjb3VsZAo+IHByb2JhYmx5IHVzZSBh
cm02NF9mdHJfc2FmZV92YWx1ZShmdHJwLCBmdHJfbmV3LCBmdHJfb3ZyKSBoZXJlID8KPiBUaGF0
IHdvdWxkIGNvdmVyIHVzIGZvciBib3RoIEhJR0hFUl9TQUZFIGFuZCBMT1dFUl9TQUZFIGZlYXR1
cmVzLgo+IEhvd2V2ZXIgdGhhdCBtYXkgYmUgcmVzdHJpY3RpdmUgZm9yIEZUUl9FWEFDVCwgYXMg
d2UgdGhlIHNhZmUKPiB2YWx1ZSB3b3VsZCBiZSBzZXQgdG8gImZ0ci0+c2FmZV92YWwiLiBJIGd1
ZXNzIHRoYXQgbWF5IGJlIGJldHRlcgo+IHRoYW4gZm9yY2luZyB0byB1c2UgYW4gdW5zYWZlIHZh
bHVlIGZvciB0aGUgYm9vdCBDUFUsIHdoaWNoIGNvdWxkCj4gYW55d2F5IGNvbmZsaWN0IHdpdGgg
dGhlIG90aGVyIENQVXMgYW5kIGV2ZW50dWFsbHkgdHJpZ2dlciB0aGUKPiBmdHIgYWx1ZSB0byBi
ZSBzYWZlX3ZhbC4KCkkgbGlrZSB0aGUgaWRlYSBvZiB1c2luZyB0aGUgaGVscGVyLCBhcyBpdCBj
bGVhbnVwcyB1cCB0aGUgY29kZSBhIGJpdC4KSG93ZXZlciwgbm90IGJlaW5nIHRvIHNldCBhIGZl
YXR1cmUgdG8gYSBjZXJ0YWluIHZhbHVlIGNvdWxkIGJlIApyZXN0cmljdGl2ZSwKYXMgaW4gZ2Vu
ZXJhbCwgaXQgbWVhbnMgdGhhdCB3ZSBjYW4gb25seSBkaXNhYmxlIGEgZmVhdHVyZSBhbmQgbm90
IAphZGp1c3QKaXRzIGxldmVsIG9mIHN1cHBvcnQuCgpUYWtlIFBNVVZFUiBmb3IgZXhhbXBsZTog
d2l0aCB0aGUgaGVscGVyLCBJIGNhbid0IG92ZXJyaWRlIGl0IGZyb20gdjguNCAKdG8KdjguMS4g
SSBjYW4gb25seSBnbyB0byB2OC4wLgoKSXMgaXQgc29tZXRoaW5nIHdlIGNhcmUgYWJvdXQ/CgpU
aGFua3MsCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMg
ZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
