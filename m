Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0167EECAAD8
	for <kvmarm@archiver.kernel.org>; Fri, 16 Sep 2022 09:01:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE674BBD6;
	Fri, 16 Sep 2022 05:01:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@misterjones.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OIJbRPuYwZbO; Fri, 16 Sep 2022 05:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA824BC09;
	Fri, 16 Sep 2022 05:01:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 679C34BBFF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 05:01:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w+Y2EHVdekiz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 05:01:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 833514BBD6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 05:01:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=misterjones.org; s=dkim20211231; h=Content-Transfer-Encoding:Content-Type:
 Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
 :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
 Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
 List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=WpOIYPFmZvX+Hf2mD/HENyssqGqbLDXFAm0gYQobp9o=; b=vw30vGqbyjYmaM3nKnskMxB/y+
 lw/jA0e/qsYeOLKWeB+M9pBy79w1bxVNFdGPnj1q7bDvJSGbFGE9g/6/s3WogeA7TOX1YXUyGg1x0
 pTlP11nDz1yB2tnWgOoUfZONTyL1unFVmhgDysLveBpkJ7DtJcohL8NqRL+bFBB7z/KUIt+Jg8S7L
 /g0VlHBwX0VvkVE6n9reRzOGt0hMoehxgxc6H3FCI/q3fovs9/b6nZbmWJpwad6zQ2KeRKuGadLzE
 9DCBQxYnOHWwYY4Gvcv0wEak1BiL7zsNN0+ZPOQ2niZSKo3HdGerEmF7aAZ8QPwNPdyuKP+AkoKqD
 y63NDfkw==;
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@misterjones.org>) id 1oZ7DJ-00AZwo-Lg;
 Fri, 16 Sep 2022 10:00:45 +0100
MIME-Version: 1.0
Date: Fri, 16 Sep 2022 10:00:45 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH kernel] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform
 dependent
In-Reply-To: <59dfb450-5a91-f27b-6edf-0adfa89729b7@ozlabs.ru>
References: <20220504074807.3616813-1-aik@ozlabs.ru>
 <0d4bb0fa-10c6-3f5a-34c8-293144b3fdbb@ozlabs.ru>
 <59dfb450-5a91-f27b-6edf-0adfa89729b7@ozlabs.ru>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <4884805567a0288ab1dbefb8aec819a2@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: aik@ozlabs.ru, kvm-ppc@vger.kernel.org,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org, farosas@linux.ibm.com,
 x86@kernel.org, linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 alex.williamson@redhat.com, kvm-riscv@lists.infradead.org, pbonzini@redhat.com,
 linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Fabiano Rosas <farosas@linux.ibm.com>, x86@kernel.org,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMi0wOS0xMyAxMzo1MCwgQWxleGV5IEthcmRhc2hldnNraXkgd3JvdGU6Cj4gUGluZz8g
SXQncyBiZWVuIGEgd2hpbGUgYW5kIHByb2JhYmx5IGdvdCBsb3N0IDotLwo+IAo+IE9uIDE4LzA1
LzIwMjIgMTY6MjcsIEFsZXhleSBLYXJkYXNoZXZza2l5IHdyb3RlOgo+PiAKPj4gCj4+IE9uIDUv
NC8yMiAxNzo0OCwgQWxleGV5IEthcmRhc2hldnNraXkgd3JvdGU6Cj4+PiBXaGVuIGludHJvZHVj
ZWQsIElSUUZEIHJlc2FtcGxpbmcgd29ya2VkIG9uIFBPV0VSOCB3aXRoIFhJQ1MuIEhvd2V2ZXIK
Pj4+IEtWTSBvbiBQT1dFUjkgaGFzIG5ldmVyIGltcGxlbWVudGVkIGl0IC0gdGhlIGNvbXBhdGli
aWxpdHkgbW9kZSBjb2RlCj4+PiAoIlhJQ1Mtb24tWElWRSIpIG1pc3NlcyB0aGUga3ZtX25vdGlm
eV9hY2tlZF9pcnEoKSBjYWxsIGFuZCB0aGUgCj4+PiBuYXRpdmUKPj4+IFhJVkUgbW9kZSBkb2Vz
IG5vdCBoYW5kbGUgSU5UeCBpbiBLVk0gYXQgYWxsLgo+Pj4gCj4+PiBUaGlzIG1vdmVkIHRoZSBj
YXBhYmlsaXR5IHN1cHBvcnQgYWR2ZXJ0aXNpbmcgdG8gcGxhdGZvcm1zIGFuZCBzdG9wcwo+Pj4g
YWR2ZXJ0aXNpbmcgaXQgb24gWElWRSwgaS5lLiBQT1dFUjkgYW5kIGxhdGVyLgo+Pj4gCj4+PiBT
aWduZWQtb2ZmLWJ5OiBBbGV4ZXkgS2FyZGFzaGV2c2tpeSA8YWlrQG96bGFicy5ydT4KPj4+IC0t
LQo+Pj4gCj4+PiAKPj4+IE9yIEkgY291bGQgbW92ZSB0aGlzIG9uZSB0b2dldGhlciB3aXRoIEtW
TV9DQVBfSVJRRkQuIFRob3VnaHRzPwo+PiAKPj4gCj4+IFBpbmc/Cj4+IAo+Pj4gCj4+PiAtLS0K
Pj4+IMKgIGFyY2gvYXJtNjQva3ZtL2FybS5jwqDCoMKgwqDCoMKgIHwgMyArKysKPj4+IMKgIGFy
Y2gvbWlwcy9rdm0vbWlwcy5jwqDCoMKgwqDCoMKgIHwgMyArKysKPj4+IMKgIGFyY2gvcG93ZXJw
Yy9rdm0vcG93ZXJwYy5jIHwgNiArKysrKysKPj4+IMKgIGFyY2gvcmlzY3Yva3ZtL3ZtLmPCoMKg
wqDCoMKgwqDCoCB8IDMgKysrCj4+PiDCoCBhcmNoL3MzOTAva3ZtL2t2bS1zMzkwLmPCoMKgIHwg
MyArKysKPj4+IMKgIGFyY2gveDg2L2t2bS94ODYuY8KgwqDCoMKgwqDCoMKgwqAgfCAzICsrKwo+
Pj4gwqAgdmlydC9rdm0va3ZtX21haW4uY8KgwqDCoMKgwqDCoMKgIHwgMSAtCj4+PiDCoCA3IGZp
bGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPj4+IAo+Pj4gZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2FybS5jIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMKPj4+
IGluZGV4IDUyM2JjOTM0ZmUyZi4uMDkyZjA2MTRiYWUzIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9h
cm02NC9rdm0vYXJtLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jCj4+PiBAQCAtMjEw
LDYgKzIxMCw5IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0cnVjdCBrdm0g
Kmt2bSwgCj4+PiBsb25nIGV4dCkKPj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1NFVF9HVUVT
VF9ERUJVRzoKPj4+IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1ZDUFVfQVRUUklCVVRFUzoKPj4+
IMKgwqDCoMKgwqAgY2FzZSBLVk1fQ0FQX1BUUF9LVk06Cj4+PiArI2lmZGVmIENPTkZJR19IQVZF
X0tWTV9JUlFGRAo+Pj4gK8KgwqDCoCBjYXNlIEtWTV9DQVBfSVJRRkRfUkVTQU1QTEU6Cj4+PiAr
I2VuZGlmCgpJIGRvbid0IG1pbmQgbW92aW5nIHRoaXMgYXJvdW5kLCBidXQgSSBvYmplY3QgdG8g
dGhlICNpZmRlZmVyeS4KClRoaXMgb3B0aW9uIGlzIGFsd2F5cyBzZWxlY3RlZCBvbiBhcm02NCwg
c28gaXQgY2FuIHNhZmVseSBiZSBhZGRlZAp0byB0aGUgbGlzdCB3aXRob3V0IGFueSBjb25kaXRp
b24uCgpUaGFua3MsCgogICAgICAgICBNLgotLSAKV2hvIHlvdSBqaXZpbicgd2l0aCB0aGF0IENv
c21payBEZWJyaXM/Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
