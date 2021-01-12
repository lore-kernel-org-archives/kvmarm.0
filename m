Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA90C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 11:51:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A00FB23109
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 11:51:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A00FB23109
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01ED64B150;
	Tue, 12 Jan 2021 06:51:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2rnqB5vkCw8I; Tue, 12 Jan 2021 06:51:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4CC24B112;
	Tue, 12 Jan 2021 06:51:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 094074B103
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 06:51:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yj0w6A9wdt8H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 06:51:54 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC3F94B0F2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 06:51:53 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B666823104;
 Tue, 12 Jan 2021 11:51:52 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kzIDG-006ws6-Kb; Tue, 12 Jan 2021 11:51:50 +0000
MIME-Version: 1.0
Date: Tue, 12 Jan 2021 11:51:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
In-Reply-To: <d98aed718a26d0455d5549d53f97db06@kernel.org>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-10-maz@kernel.org> <20210111184154.GC17941@gaia>
 <129db8bd3913a90c96d4cfe4f55e27a0@kernel.org>
 <a122aa5c-4af9-e236-db82-db0ed885e0a5@arm.com>
 <d98aed718a26d0455d5549d53f97db06@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <a477277b3941dc6650571f8fe29fe4f6@kernel.org>
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

T24gMjAyMS0wMS0xMiAxMTo1MCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFN1enVraSwKPiAK
PiBPbiAyMDIxLTAxLTEyIDA5OjE3LCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+PiBIaSBNYXJj
LAo+PiAKPj4gT24gMS8xMS8yMSA3OjQ4IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gCj4gWy4u
Ll0KPiAKPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0dXJlLmMgCj4+
PiBiL2FyY2gvYXJtNjQva2VybmVsL2NwdWZlYXR1cmUuYwo+Pj4gaW5kZXggODk0YWY2MGI5NjY5
Li4wMGQ5OWU1OTNiNjUgMTAwNjQ0Cj4+PiAtLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0
dXJlLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva2VybmVsL2NwdWZlYXR1cmUuYwo+Pj4gQEAgLTc3
NCw2ICs3NzQsNyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgaW5pdF9jcHVfZnRyX3JlZyh1MzIgc3lz
X3JlZywgCj4+PiB1NjQgbmV3KQo+Pj4gIMKgwqDCoMKgIHU2NCBzdHJpY3RfbWFzayA9IH4weDBV
TEw7Cj4+PiAgwqDCoMKgwqAgdTY0IHVzZXJfbWFzayA9IDA7Cj4+PiAgwqDCoMKgwqAgdTY0IHZh
bGlkX21hc2sgPSAwOwo+Pj4gK8KgwqDCoCB1NjQgb3ZlcnJpZGVfdmFsID0gMCwgb3ZlcnJpZGVf
bWFzayA9IDA7Cj4+PiAKPj4+ICDCoMKgwqDCoCBjb25zdCBzdHJ1Y3QgYXJtNjRfZnRyX2JpdHMg
KmZ0cnA7Cj4+PiAgwqDCoMKgwqAgc3RydWN0IGFybTY0X2Z0cl9yZWcgKnJlZyA9IGdldF9hcm02
NF9mdHJfcmVnKHN5c19yZWcpOwo+Pj4gQEAgLTc4MSw5ICs3ODIsMzUgQEAgc3RhdGljIHZvaWQg
X19pbml0IGluaXRfY3B1X2Z0cl9yZWcodTMyIHN5c19yZWcsIAo+Pj4gdTY0IG5ldykKPj4+ICDC
oMKgwqDCoCBpZiAoIXJlZykKPj4+ICDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsKPj4+IAo+Pj4g
K8KgwqDCoCBpZiAocmVnLT5vdmVycmlkZV9tYXNrICYmIHJlZy0+b3ZlcnJpZGVfdmFsKSB7Cj4+
PiArwqDCoMKgwqDCoMKgwqAgb3ZlcnJpZGVfbWFzayA9ICpyZWctPm92ZXJyaWRlX21hc2s7Cj4+
PiArwqDCoMKgwqDCoMKgwqAgb3ZlcnJpZGVfdmFsID0gKnJlZy0+b3ZlcnJpZGVfdmFsOwo+Pj4g
K8KgwqDCoCB9Cj4+PiArCj4+PiAgwqDCoMKgwqAgZm9yIChmdHJwID0gcmVnLT5mdHJfYml0czsg
ZnRycC0+d2lkdGg7IGZ0cnArKykgewo+Pj4gIMKgwqDCoMKgwqDCoMKgwqAgdTY0IGZ0cl9tYXNr
ID0gYXJtNjRfZnRyX21hc2soZnRycCk7Cj4+PiAgwqDCoMKgwqDCoMKgwqDCoCBzNjQgZnRyX25l
dyA9IGFybTY0X2Z0cl92YWx1ZShmdHJwLCBuZXcpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIHM2NCBm
dHJfb3ZyID0gYXJtNjRfZnRyX3ZhbHVlKGZ0cnAsIG92ZXJyaWRlX3ZhbCk7Cj4+PiArCj4+PiAr
wqDCoMKgwqDCoMKgwqAgaWYgKChmdHJfbWFzayAmIG92ZXJyaWRlX21hc2spID09IGZ0cl9tYXNr
KSB7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoZnRyX292ciA8IGZ0cl9uZXcpIHsK
Pj4gCj4+IEhlcmUgd2UgYXNzdW1lIHRoYXQgYWxsIHRoZSBmZWF0dXJlcyBhcmUgRlRSX0xPV0VS
X1NBRkUuIFdlIGNvdWxkCj4+IHByb2JhYmx5IHVzZSBhcm02NF9mdHJfc2FmZV92YWx1ZShmdHJw
LCBmdHJfbmV3LCBmdHJfb3ZyKSBoZXJlID8KPj4gVGhhdCB3b3VsZCBjb3ZlciB1cyBmb3IgYm90
aCBISUdIRVJfU0FGRSBhbmQgTE9XRVJfU0FGRSBmZWF0dXJlcy4KPj4gSG93ZXZlciB0aGF0IG1h
eSBiZSByZXN0cmljdGl2ZSBmb3IgRlRSX0VYQUNULCBhcyB3ZSB0aGUgc2FmZQo+PiB2YWx1ZSB3
b3VsZCBiZSBzZXQgdG8gImZ0ci0+c2FmZV92YWwiLiBJIGd1ZXNzIHRoYXQgbWF5IGJlIGJldHRl
cgo+PiB0aGFuIGZvcmNpbmcgdG8gdXNlIGFuIHVuc2FmZSB2YWx1ZSBmb3IgdGhlIGJvb3QgQ1BV
LCB3aGljaCBjb3VsZAo+PiBhbnl3YXkgY29uZmxpY3Qgd2l0aCB0aGUgb3RoZXIgQ1BVcyBhbmQg
ZXZlbnR1YWxseSB0cmlnZ2VyIHRoZQo+PiBmdHIgYWx1ZSB0byBiZSBzYWZlX3ZhbC4KPiAKPiBJ
IGxpa2UgdGhlIGlkZWEgb2YgdXNpbmcgdGhlIGhlbHBlciwgYXMgaXQgY2xlYW51cHMgdXAgdGhl
IGNvZGUgYSBiaXQuCj4gSG93ZXZlciwgbm90IGJlaW5nIHRvIHNldCBhIGZlYXR1cmUgdG8gYSBj
ZXJ0YWluIHZhbHVlIGNvdWxkIGJlIAo+IHJlc3RyaWN0aXZlLAo+IGFzIGluIGdlbmVyYWwsIGl0
IG1lYW5zIHRoYXQgd2UgY2FuIG9ubHkgZGlzYWJsZSBhIGZlYXR1cmUgYW5kIG5vdCAKPiBhZGp1
c3QKPiBpdHMgbGV2ZWwgb2Ygc3VwcG9ydC4KPiAKPiBUYWtlIFBNVVZFUiBmb3IgZXhhbXBsZTog
d2l0aCB0aGUgaGVscGVyLCBJIGNhbid0IG92ZXJyaWRlIGl0IGZyb20gdjguNCAKPiB0bwo+IHY4
LjEuIEkgY2FuIG9ubHkgZ28gdG8gdjguMC4KCkFjdHVhbGx5LCB3ZSBjYW4gb25seSAqZGlzYWJs
ZSogdGhlIFBNVSBhbHRvZ2V0aGVyLiBTYW1lIHF1ZXN0aW9uIAp0aG91Z2guLi4KCiAgICAgICAg
IE0uCgo+IAo+IElzIGl0IHNvbWV0aGluZyB3ZSBjYXJlIGFib3V0Pwo+IAo+IFRoYW5rcywKPiAK
PiAgICAgICAgIE0uCgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnku
Li4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
