Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370D6C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 14:54:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D28123130
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 14:54:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D28123130
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8954B184;
	Tue, 12 Jan 2021 09:54:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dGlhFb8cRcj6; Tue, 12 Jan 2021 09:54:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 509424B198;
	Tue, 12 Jan 2021 09:54:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 634DE4B198
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 09:54:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7lpbb5AKWcfw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 09:54:11 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9E774B184
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 09:54:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7AB1320739;
 Tue, 12 Jan 2021 14:54:09 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kzL3f-006zzO-CO; Tue, 12 Jan 2021 14:54:07 +0000
MIME-Version: 1.0
Date: Tue, 12 Jan 2021 14:54:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 09/21] arm64: cpufeature: Add global feature override
 facility
In-Reply-To: <168970f2-89d8-4e57-ab8d-59fa52bd830a@arm.com>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-10-maz@kernel.org> <20210111184154.GC17941@gaia>
 <129db8bd3913a90c96d4cfe4f55e27a0@kernel.org>
 <a122aa5c-4af9-e236-db82-db0ed885e0a5@arm.com>
 <d98aed718a26d0455d5549d53f97db06@kernel.org>
 <168970f2-89d8-4e57-ab8d-59fa52bd830a@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <750d69f418b78deb5031da86df119911@kernel.org>
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

T24gMjAyMS0wMS0xMiAxMTo1OSwgU3V6dWtpIEsgUG91bG9zZSB3cm90ZToKPiBPbiAxLzEyLzIx
IDExOjUwIEFNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IEhpIFN1enVraSwKPj4gCj4+IE9uIDIw
MjEtMDEtMTIgMDk6MTcsIFN1enVraSBLIFBvdWxvc2Ugd3JvdGU6Cj4+PiBIaSBNYXJjLAo+Pj4g
Cj4+PiBPbiAxLzExLzIxIDc6NDggUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gCj4+IFsuLi5d
Cj4+IAo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0dXJlLmMgCj4+
Pj4gYi9hcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0dXJlLmMKPj4+PiBpbmRleCA4OTRhZjYwYjk2
NjkuLjAwZDk5ZTU5M2I2NSAxMDA2NDQKPj4+PiAtLS0gYS9hcmNoL2FybTY0L2tlcm5lbC9jcHVm
ZWF0dXJlLmMKPj4+PiArKysgYi9hcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0dXJlLmMKPj4+PiBA
QCAtNzc0LDYgKzc3NCw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBpbml0X2NwdV9mdHJfcmVnKHUz
MiBzeXNfcmVnLCAKPj4+PiB1NjQgbmV3KQo+Pj4+IMKgwqDCoMKgwqAgdTY0IHN0cmljdF9tYXNr
ID0gfjB4MFVMTDsKPj4+PiDCoMKgwqDCoMKgIHU2NCB1c2VyX21hc2sgPSAwOwo+Pj4+IMKgwqDC
oMKgwqAgdTY0IHZhbGlkX21hc2sgPSAwOwo+Pj4+ICvCoMKgwqAgdTY0IG92ZXJyaWRlX3ZhbCA9
IDAsIG92ZXJyaWRlX21hc2sgPSAwOwo+Pj4+IAo+Pj4+IMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0
IGFybTY0X2Z0cl9iaXRzICpmdHJwOwo+Pj4+IMKgwqDCoMKgwqAgc3RydWN0IGFybTY0X2Z0cl9y
ZWcgKnJlZyA9IGdldF9hcm02NF9mdHJfcmVnKHN5c19yZWcpOwo+Pj4+IEBAIC03ODEsOSArNzgy
LDM1IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBpbml0X2NwdV9mdHJfcmVnKHUzMiAKPj4+PiBzeXNf
cmVnLCB1NjQgbmV3KQo+Pj4+IMKgwqDCoMKgwqAgaWYgKCFyZWcpCj4+Pj4gwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybjsKPj4+PiAKPj4+PiArwqDCoMKgIGlmIChyZWctPm92ZXJyaWRlX21hc2sg
JiYgcmVnLT5vdmVycmlkZV92YWwpIHsKPj4+PiArwqDCoMKgwqDCoMKgwqAgb3ZlcnJpZGVfbWFz
ayA9ICpyZWctPm92ZXJyaWRlX21hc2s7Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIG92ZXJyaWRlX3Zh
bCA9ICpyZWctPm92ZXJyaWRlX3ZhbDsKPj4+PiArwqDCoMKgIH0KPj4+PiArCj4+Pj4gwqDCoMKg
wqDCoCBmb3IgKGZ0cnAgPSByZWctPmZ0cl9iaXRzOyBmdHJwLT53aWR0aDsgZnRycCsrKSB7Cj4+
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHU2NCBmdHJfbWFzayA9IGFybTY0X2Z0cl9tYXNrKGZ0cnAp
Owo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBzNjQgZnRyX25ldyA9IGFybTY0X2Z0cl92YWx1ZShm
dHJwLCBuZXcpOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCBzNjQgZnRyX292ciA9IGFybTY0X2Z0cl92
YWx1ZShmdHJwLCBvdmVycmlkZV92YWwpOwo+Pj4+ICsKPj4+PiArwqDCoMKgwqDCoMKgwqAgaWYg
KChmdHJfbWFzayAmIG92ZXJyaWRlX21hc2spID09IGZ0cl9tYXNrKSB7Cj4+Pj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgaWYgKGZ0cl9vdnIgPCBmdHJfbmV3KSB7Cj4+PiAKPj4+IEhlcmUgd2Ug
YXNzdW1lIHRoYXQgYWxsIHRoZSBmZWF0dXJlcyBhcmUgRlRSX0xPV0VSX1NBRkUuIFdlIGNvdWxk
Cj4+PiBwcm9iYWJseSB1c2UgYXJtNjRfZnRyX3NhZmVfdmFsdWUoZnRycCwgZnRyX25ldywgZnRy
X292cikgaGVyZSA/Cj4+PiBUaGF0IHdvdWxkIGNvdmVyIHVzIGZvciBib3RoIEhJR0hFUl9TQUZF
IGFuZCBMT1dFUl9TQUZFIGZlYXR1cmVzLgo+Pj4gSG93ZXZlciB0aGF0IG1heSBiZSByZXN0cmlj
dGl2ZSBmb3IgRlRSX0VYQUNULCBhcyB3ZSB0aGUgc2FmZQo+Pj4gdmFsdWUgd291bGQgYmUgc2V0
IHRvICJmdHItPnNhZmVfdmFsIi4gSSBndWVzcyB0aGF0IG1heSBiZSBiZXR0ZXIKPj4+IHRoYW4g
Zm9yY2luZyB0byB1c2UgYW4gdW5zYWZlIHZhbHVlIGZvciB0aGUgYm9vdCBDUFUsIHdoaWNoIGNv
dWxkCj4+PiBhbnl3YXkgY29uZmxpY3Qgd2l0aCB0aGUgb3RoZXIgQ1BVcyBhbmQgZXZlbnR1YWxs
eSB0cmlnZ2VyIHRoZQo+Pj4gZnRyIGFsdWUgdG8gYmUgc2FmZV92YWwuCj4+IAo+PiBJIGxpa2Ug
dGhlIGlkZWEgb2YgdXNpbmcgdGhlIGhlbHBlciwgYXMgaXQgY2xlYW51cHMgdXAgdGhlIGNvZGUg
YSBiaXQuCj4+IEhvd2V2ZXIsIG5vdCBiZWluZyB0byBzZXQgYSBmZWF0dXJlIHRvIGEgY2VydGFp
biB2YWx1ZSBjb3VsZCBiZSAKPj4gcmVzdHJpY3RpdmUsCj4+IGFzIGluIGdlbmVyYWwsIGl0IG1l
YW5zIHRoYXQgd2UgY2FuIG9ubHkgZGlzYWJsZSBhIGZlYXR1cmUgYW5kIG5vdCAKPj4gYWRqdXN0
Cj4+IGl0cyBsZXZlbCBvZiBzdXBwb3J0Lgo+PiAKPj4gVGFrZSBQTVVWRVIgZm9yIGV4YW1wbGU6
IHdpdGggdGhlIGhlbHBlciwgSSBjYW4ndCBvdmVycmlkZSBpdCBmcm9tIAo+PiB2OC40IHRvCj4+
IHY4LjEuIEkgY2FuIG9ubHkgZ28gdG8gdjguMC4KPiAKPiBNeSBwb2ludCBpcywgd2Ugc2V0IHRo
aXMgb25seSBmb3IgdGhlICJpbml0IiBvZiBjcHUgZmVhdHVyZXMuIFNvLCBldmVuIAo+IGlmIHdl
Cj4gaW5pdCB0byBhIGN1c3RvbSAsIG5vbi0oZGVmYXVsdC1zYWZlKSB2YWx1ZSwgdGhlIHNlY29u
ZGFyeSBDUFVzIGNvdWxkIAo+IHNjcmVhbSwKPiBhbmQgdGhlIHN5c3RlbSB3aWRlIHNhZmUgdmFs
dWUgY291bGQgZmFsbCBiYWNrIHRvIHRoZSAic2FmZSIgdmFsdWUgZm9yCj4gRVhBQ1QgZmVhdHVy
ZXMsIG5vIG1hdHRlciB3aGF0IHlvdSBkaWQgdG8gaW5pdCBpdC4KClJpZ2h0LiBTbyBsZXQncyBn
byB3aXRoIHRoZSBzYWZlIHZhbHVlIGZvciBFWEFDVCBmZWF0dXJlcyBmb3Igbm93LAphbmQgbGV0
IHRoZSBvdmVycmlkZSBmYWlsIGlmIHRoYXQncyBub3Qgd2hhdCB0aGUgdXNlciBhc2tlZCBmb3Iu
CgpBZnRlciBhbGwsIHRoZXJlIGFyZSBvbmx5IHNvIG1hbnkgdGhpbmdzIHdlIHdhbnQgdG8gc3Vw
cG9ydCBhcwphbiBvdmVycmlkZSwgYW5kIGluIGFsbCB0aGUgY2FzZXMgYXQgaGFuZCwgdXNpbmcg
dGhlIHNhZmUgdmFsdWUKYWN0dWFsbHkgbWF0Y2hlcyB3aGF0IHdlIHdhbnQgdG8gZG8uCgpXZSBj
YW4gYWx3YXlzIHJldmlzaXQgdGhpcyBpZiBhbmQgd2hlbiB3ZSBuZWVkIGEgZGlmZmVyZW50IGJl
aGF2aW91ci4KClRoYW5rcywKCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBq
dXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
