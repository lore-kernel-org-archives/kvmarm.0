Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13D4C4332D
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:01:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F78320767
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:01:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYCIgVPL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F78320767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7F04A4E5;
	Fri, 20 Mar 2020 05:01:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AGjL7Z7DMCDu; Fri, 20 Mar 2020 05:01:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6F5B4B082;
	Fri, 20 Mar 2020 05:01:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6BD4A4CD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:01:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yn8osEfUIAkG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 05:01:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4758D4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:01:44 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1E46520752;
 Fri, 20 Mar 2020 09:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584694903;
 bh=5GzmaNdbQWq4mwgMPIV3aDUnqAewqh/ptfOGOHCK+xw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=jYCIgVPLeSi75fxMO5TZ8B5x9GAI/akoG5C2R9NKp2C++xG9c/7L59CgHOC3bQ/KK
 kxFbkaBZ/58TE5YR3tosXwXXhILQr5LeIR5nykEBB/cPR+MxWI5ff+pta1Dvp7u55A
 a0/KdFglc2/CRpBetrGMRzDIrczZ3ze842l/MkGE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jFDXA-00EBob-Vl; Fri, 20 Mar 2020 09:01:41 +0000
MIME-Version: 1.0
Date: Fri, 20 Mar 2020 09:01:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
Message-ID: <256b58a9679412c96600217f316f424f@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
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

SGkgWmVuZ2h1aSwKCk9uIDIwMjAtMDMtMjAgMDM6NTMsIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
TWFyYywKPiAKPiBPbiAyMDIwLzMvMTkgMjA6MTAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+IEJ1
dCBJIHdvbmRlciB0aGF0IHNob3VsZCB3ZSB1c2UgbmFzc2dpcmVxIHRvICpvbmx5KiBrZWVwIHRy
YWNrIHdoYXQKPj4+IHRoZSBndWVzdCBoYWQgd3JpdHRlbiBpbnRvIHRoZSBHSUNEX0NUTFIubkFT
U0dJcmVxLsKgIElmIG5vdCwgd2UgbWF5Cj4+PiBsb3NlIHRoZSBndWVzdC1yZXF1ZXN0IGJpdCBh
ZnRlciBtaWdyYXRpb24gYW1vbmcgaG9zdHMgd2l0aCBkaWZmZXJlbnQKPj4+IGhhc19naWN2NF8x
IHNldHRpbmdzLgo+PiAKPj4gSSdtIHVuc3VyZSBvZiB3aGF0IHlvdSdyZSBzdWdnZXN0aW5nIGhl
cmUuIElmIHVzZXJzcGFjZSB0cmllcyB0byBzZXQKPj4gR0lDRF9DVExSLm5BU1NHSXJlcSBvbiBh
IG5vbi00LjEgaG9zdCwgdGhpcyBiaXQgd2lsbCBub3QgbGF0Y2guCj4gCj4gVGhpcyBpcyBleGFj
dGx5IHdoYXQgSSAqd2FzKiBjb25jZXJuaW5nIGFib3V0Lgo+IAo+PiBVc2Vyc3BhY2UgY2FuIGNo
ZWNrIHRoYXQgYXQgcmVzdG9yZSB0aW1lLiBPciB3ZSBjb3VsZCBmYWlsIHRoZQo+PiB1c2Vyc3Bh
Y2Ugd3JpdGUsIHdoaWNoIGlzIGEgYml0IG9kZCAodGhlIGJpdCBpcyBvdGhlcndpc2UgUkVTMCku
Cj4+IAo+PiBDb3VsZCB5b3UgY2xhcmlmeSB5b3VyIHByb3Bvc2FsPwo+IAo+IExldCdzIGFzc3Vt
ZSB0d28gaG9zdHMgYmVsb3cuICdoYXNfZ2ljdjRfMScgaXMgdHJ1ZSBvbiBob3N0LUEgd2hpbGUK
PiBpdCBpcyBmYWxzZSBvbiBob3N0LUIgYmVjYXVzZSBvZiBsYWNrIG9mIEhXIHN1cHBvcnQgb3Ig
dGhlIGtlcm5lbAo+IHBhcmFtZXRlciAia3ZtLWFybS52Z2ljX3Y0X2VuYWJsZT0wIi4KPiAKPiBJ
ZiB3ZSBtaWdyYXRlIGd1ZXN0IHRocm91Z2ggQS0+Qi0+QSwgd2UgbWF5IGVuZC11cCBsb3NlIHRo
ZSBpbml0aWFsCj4gZ3Vlc3QtcmVxdWVzdCAibkFTU0dJcmVxPTEiIGFuZCBkb24ndCB1c2UgZGly
ZWN0IHZTR0kgZGVsaXZlcnkgZm9yCj4gdGhpcyBndWVzdCB3aGVuIGl0J3MgbWlncmF0ZWQgYmFj
ayB0byBob3N0LUEuCgpNeSBwb2ludCBhYm92ZSBpcyB0aGF0IHdlIHNob3VsZG4ndCBhbGxvdyB0
aGUgQS0+QiBtaWdyYXRpb24gdGhlIGZpcnN0CnBsYWNlLCBhbmQgZmFpbCBpdCBhcyBxdWlja2x5
IGFzIHBvc3NpYmxlLiBXZSBkb24ndCBrbm93IHdoYXQgdGhlIGd1ZXN0CmhhcyBvYnNlcnZlZCBp
biB0ZXJtcyBvZiBHSUMgY2FwYWJpbGl0eSwgYW5kIGl0IG1heSBub3QgaGF2ZSBlbmFibGVkIHRo
ZQpuZXcgZmxhdm91ciBvZiBTR0lzIGp1c3QgeWV0LgoKPiBUaGlzIGNhbiBiZSAiZml4ZWQiIGJ5
IGtlZXAgdHJhY2sgb2Ygd2hhdCBndWVzdCBoYWQgd3JpdHRlbiBpbnRvCj4gbkFTU0dJcmVxLiBB
bmQgd2UgbmVlZCB0byBldmFsdWF0ZSB0aGUgbmVlZCBmb3IgdXNpbmcgZGlyZWN0IHZTR0kKPiBm
b3IgYSBzcGVjaWZpZWQgZ3Vlc3QgYnkgJ2hhc19naWN2NF8xICYmIG5hc3NnaXJlcScuCgpJdCBm
ZWVscyBvZGQuIEl0IG1lYW5zIHdlIGhhdmUgbW9yZSBzdGF0ZSB0aGFuIHRoZSBIVyBub3JtYWxs
eSBoYXMuCkkgaGF2ZSBhbiBhbHRlcm5hdGl2ZSBwcm9wb3NhbCwgc2VlIGJlbG93LgoKPiBCdXQg
aWYgaXQncyBleHBlY3RlZCB0aGF0ICJpZiB1c2Vyc3BhY2UgdHJpZXMgdG8gc2V0IG5BU1NHSXJl
cSBvbgo+IGEgbm9uLTQuMSBob3N0LCB0aGlzIGJpdCB3aWxsIG5vdCBsYXRjaCIsIHRoZW4gdGhp
cyBzaG91bGRuJ3QgYmUKPiBhIHByb2JsZW0gYXQgYWxsLgoKV2VsbCwgdGhhdCBpcyB0aGUgc2Vt
YW50aWNzIG9mIHRoZSBSRVMwIGJpdC4gSXQgYXBwbGllcyBmcm9tIGJvdGgKZ3Vlc3QgYW5kIHVz
ZXJzcGFjZS4KCkFuZCBhY3R1YWxseSwgbWF5YmUgd2UgY2FuIGhhbmRsZSB0aGF0IHByZXR0eSBj
aGVhcGx5LiBJZiB1c2Vyc3BhY2UKdHJpZXMgdG8gcmVzdG9yZSBHSUNEX1RZUEVSMiB0byBhIHZh
bHVlIHRoYXQgaXNuJ3Qgd2hhdCBLVk0gY2FuCm9mZmVyLCB3ZSBqdXN0IHJldHVybiBhbiBlcnJv
ci4gRXhhY3RseSBsaWtlIHdlIGRvIGZvciBHSUNEX0lJRFIuCkhlbmNlIHRoZSBmb2xsb3dpbmcg
cGF0Y2g6CgpkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLXYzLmMgCmIv
dmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKaW5kZXggMjhiNjM5ZmQxYWJjLi5lNzJk
Y2M0NTQyNDcgMTAwNjQ0Ci0tLSBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12My5jCisr
KyBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1pby12My5jCkBAIC0xNTYsNiArMTU2LDcgQEAg
c3RhdGljIGludCB2Z2ljX21taW9fdWFjY2Vzc193cml0ZV92M19taXNjKHN0cnVjdCAKa3ZtX3Zj
cHUgKnZjcHUsCiAgCXN0cnVjdCB2Z2ljX2Rpc3QgKmRpc3QgPSAmdmNwdS0+a3ZtLT5hcmNoLnZn
aWM7CgogIAlzd2l0Y2ggKGFkZHIgJiAweDBjKSB7CisJY2FzZSBHSUNEX1RZUEVSMjoKICAJY2Fz
ZSBHSUNEX0lJRFI6CiAgCQlpZiAodmFsICE9IHZnaWNfbW1pb19yZWFkX3YzX21pc2ModmNwdSwg
YWRkciwgbGVuKSkKICAJCQlyZXR1cm4gLUVJTlZBTDsKCkJlaW5nIGEgUk8gcmVnaXN0ZXIsIHdy
aXRpbmcgc29tZXRoaW5nIHRoYXQgaXNuJ3QgY29tcGF0aWJsZSB3aXRoIHRoZQpwb3NzaWJsZSBi
ZWhhdmlvdXIgb2YgdGhlIGh5cGVydmlzb3Igd2lsbCBqdXN0IHJldHVybiBhbiBlcnJvci4KCldo
YXQgZG8geW91IHRoaW5rPwoKPiBBbnl3YXkgdGhpcyBpcyBub3QgYSBiaWcgZGVhbCB0byBtZSBh
bmQgSSB3b24ndCBjb21wbGFpbiBhYm91dCBpdAo+IGluIHRoZSBmdXR1cmUgOy0pIEVpdGhlciB3
YXksIGZvciB0aGlzIHBhdGNoOgo+IAo+IFJldmlld2VkLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdo
dWlAaHVhd2VpLmNvbT4KClRoYW5rcyBhIGxvdCEKCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5v
dCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
