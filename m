Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E75C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 14:59:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 675A64B9BB;
	Fri, 25 Feb 2022 09:59:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YMY8eq10lxQT; Fri, 25 Feb 2022 09:59:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 910224BA5E;
	Fri, 25 Feb 2022 09:59:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 041654BBE4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 21:12:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mbxmJQLb0otA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 21:12:43 -0500 (EST)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9CC74BBE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 21:12:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1645755162; x=1677291162;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=OjwBjKUhnyQUaR178VPG79ZiTP2RcSZHYXmNw8T4lRs=;
 b=M+uXnBkly+tNyfA6uVrcwE/TYcaAx12sBEsoOJ/bkFXV3t8xZv8SMPS5
 E8UUEVYx29lg85qdLydObL4fz6WKqnLKAz6sRFBzNiiiVrUy/45wdi0X/
 eQDr+JBOLCDqF8OkQgun+kB5bsd5UmueELYiVP6JQqqLKXzw6DvDsTVVp
 3fy15SZx21XOB1pJ/FxFxGHyDpG93G6Dya9Y9tfmN8z9F9AIZ7+faJ86s
 92cBE8GiIdYV/hF70FOs3jnLMM6ppW1AZ+qFK3ybX7FzFVqF3W7C012tm
 1WyPNyE2pwfIDlKXdUVvl5jWzy6WhkI4emD0+ZC3cDDCCTTbsnfUH6tvc Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="233024207"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; d="scan'208";a="233024207"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
 by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 Feb 2022 18:12:41 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; d="scan'208";a="639958422"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.255.31.203])
 ([10.255.31.203])
 by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 Feb 2022 18:12:34 -0800
Subject: Re: [kbuild-all] Re: [PATCH v2 6/9] KVM: arm64: Detect and handle
 hypervisor stack overflows
To: Marc Zyngier <maz@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
References: <20220222165212.2005066-7-kaleshsingh@google.com>
 <202202231727.L621fVgD-lkp@intel.com> <875yp63ptg.wl-maz@kernel.org>
 <YhYpvfZaSjrAtkZp@rli9-dbox> <cb750267af0636c49d2f8aa354f086a5@kernel.org>
 <CAMj1kXHsNsQXbeeS1zcy+xYA7kSE5apbLpChohfvkABS7Z6jKg@mail.gmail.com>
 <89c48bd2a9b32b4607d1515714fa3c1b@kernel.org>
From: "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <16f47fa9-90b4-0b5c-33cb-cb004fc39266@intel.com>
Date: Fri, 25 Feb 2022 10:12:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <89c48bd2a9b32b4607d1515714fa3c1b@kernel.org>
Content-Language: en-US
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, llvm@lists.linux.dev,
 Joey Gouly <joey.gouly@arm.com>, Kalesh Singh <kaleshsingh@google.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 kernel test robot <lkp@intel.com>, surenb@google.com,
 Android Kernel Team <kernel-team@android.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Peter Collingbourne <pcc@google.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kbuild-all@lists.01.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

CgpPbiAyLzI0LzIwMjIgNjozOSBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjItMDIt
MjMgMTI6NTYsIEFyZCBCaWVzaGV1dmVsIHdyb3RlOgo+PiBPbiBXZWQsIDIzIEZlYiAyMDIyIGF0
IDEzOjU0LCBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPiB3cm90ZToKPj4+Cj4+PiBPbiAy
MDIyLTAyLTIzIDEyOjM0LCBQaGlsaXAgTGkgd3JvdGU6Cj4+PiA+IE9uIFdlZCwgRmViIDIzLCAy
MDIyIGF0IDA5OjE2OjU5QU0gKzAwMDAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4+ID4+IE9uIFdl
ZCwgMjMgRmViIDIwMjIgMDk6MDU6MTggKzAwMDAsCj4+PiA+PiBrZXJuZWwgdGVzdCByb2JvdCA8
bGtwQGludGVsLmNvbT4gd3JvdGU6Cj4+PiA+PiA+Cj4+PiA+PiA+IEhpIEthbGVzaCwKPj4+ID4+
ID4KPj4+ID4+ID4gVGhhbmsgeW91IGZvciB0aGUgcGF0Y2ghIFBlcmhhcHMgc29tZXRoaW5nIHRv
IGltcHJvdmU6Cj4+PiA+PiA+Cj4+PiA+PiA+IFthdXRvIGJ1aWxkIHRlc3QgV0FSTklORyBvbiAK
Pj4+IGNmYjkyNDQwZWU3MWFkY2MyMTA1YjA4OTBiYjAxYWMzY2RkYjg1MDddCj4+PiA+PiA+Cj4+
PiA+PiA+IHVybDogICAgCj4+PiBodHRwczovL2dpdGh1Yi5jb20vMGRheS1jaS9saW51eC9jb21t
aXRzL0thbGVzaC1TaW5naC9LVk0tYXJtNjQtSHlwZXJ2aXNvci1zdGFjay1lbmhhbmNlbWVudHMv
MjAyMjAyMjMtMDEwNTIyIAo+Pj4KPj4+ID4+ID4gYmFzZTrCoMKgIGNmYjkyNDQwZWU3MWFkY2My
MTA1YjA4OTBiYjAxYWMzY2RkYjg1MDcKPj4+ID4+ID4gY29uZmlnOiBhcm02NC1yYW5kY29uZmln
LXIwMTEtMjAyMjAyMjEgCj4+PiAoaHR0cHM6Ly9kb3dubG9hZC4wMS5vcmcvMGRheS1jaS9hcmNo
aXZlLzIwMjIwMjIzLzIwMjIwMjIzMTcyNy5MNjIxZlZnRC1sa3BAaW50ZWwuY29tL2NvbmZpZykg
Cj4+Pgo+Pj4gPj4gPiBjb21waWxlcjogY2xhbmcgdmVyc2lvbiAxNS4wLjAgCj4+PiAoaHR0cHM6
Ly9naXRodWIuY29tL2xsdm0vbGx2bS1wcm9qZWN0IAo+Pj4gZDI3MWZjMDRkNWI5N2IxMmU2Yjc5
N2M2MDY3ZDNjOTZhOGQ3NDcwZSkKPj4+ID4+ID4gcmVwcm9kdWNlICh0aGlzIGlzIGEgVz0xIGJ1
aWxkKToKPj4+ID4+ID7CoMKgwqDCoMKgwqDCoMKgIHdnZXQgCj4+PiBodHRwczovL3Jhdy5naXRo
dWJ1c2VyY29udGVudC5jb20vaW50ZWwvbGtwLXRlc3RzL21hc3Rlci9zYmluL21ha2UuY3Jvc3Mg
Cj4+PiAtTyB+L2Jpbi9tYWtlLmNyb3NzCj4+PiA+PiA+wqDCoMKgwqDCoMKgwqDCoCBjaG1vZCAr
eCB+L2Jpbi9tYWtlLmNyb3NzCj4+PiA+PiA+wqDCoMKgwqDCoMKgwqDCoCAjIGluc3RhbGwgYXJt
NjQgY3Jvc3MgY29tcGlsaW5nIHRvb2wgZm9yIGNsYW5nIGJ1aWxkCj4+PiA+PiA+wqDCoMKgwqDC
oMKgwqDCoCAjIGFwdC1nZXQgaW5zdGFsbCBiaW51dGlscy1hYXJjaDY0LWxpbnV4LWdudQo+Pj4g
Pj4gPsKgwqDCoMKgwqDCoMKgwqAgIyAKPj4+IGh0dHBzOi8vZ2l0aHViLmNvbS8wZGF5LWNpL2xp
bnV4L2NvbW1pdC83ZmU5OWZkNDBmN2M0YjI5NzMyMTgwNDVjYTViOWM5MTYwNTI0ZGIxIAo+Pj4K
Pj4+ID4+ID7CoMKgwqDCoMKgwqDCoMKgIGdpdCByZW1vdGUgYWRkIGxpbnV4LXJldmlldyAKPj4+
IGh0dHBzOi8vZ2l0aHViLmNvbS8wZGF5LWNpL2xpbnV4Cj4+PiA+PiA+wqDCoMKgwqDCoMKgwqDC
oCBnaXQgZmV0Y2ggLS1uby10YWdzIGxpbnV4LXJldmlldyAKPj4+IEthbGVzaC1TaW5naC9LVk0t
YXJtNjQtSHlwZXJ2aXNvci1zdGFjay1lbmhhbmNlbWVudHMvMjAyMjAyMjMtMDEwNTIyCj4+PiA+
PiA+wqDCoMKgwqDCoMKgwqDCoCBnaXQgY2hlY2tvdXQgN2ZlOTlmZDQwZjdjNGIyOTczMjE4MDQ1
Y2E1YjljOTE2MDUyNGRiMQo+Pj4gPj4gPsKgwqDCoMKgwqDCoMKgwqAgIyBzYXZlIHRoZSBjb25m
aWcgZmlsZSB0byBsaW51eCBidWlsZCB0cmVlCj4+PiA+PiA+wqDCoMKgwqDCoMKgwqDCoCBta2Rp
ciBidWlsZF9kaXIKPj4+ID4+ID7CoMKgwqDCoMKgwqDCoMKgIENPTVBJTEVSX0lOU1RBTExfUEFU
SD0kSE9NRS8wZGF5IENPTVBJTEVSPWNsYW5nIAo+Pj4gbWFrZS5jcm9zcyBXPTEgTz1idWlsZF9k
aXIgQVJDSD1hcm02NCBTSEVMTD0vYmluL2Jhc2ggYXJjaC9hcm02NC8KPj4+ID4+ID4KPj4+ID4+
ID4gSWYgeW91IGZpeCB0aGUgaXNzdWUsIGtpbmRseSBhZGQgZm9sbG93aW5nIHRhZyBhcyBhcHBy
b3ByaWF0ZQo+Pj4gPj4gPiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRl
bC5jb20+Cj4+PiA+PiA+Cj4+PiA+PiA+IEFsbCB3YXJuaW5ncyAobmV3IG9uZXMgcHJlZml4ZWQg
YnkgPj4pOgo+Pj4gPj4gPgo+Pj4gPj4gPsKgwqDCoCBpbmNsdWRlL2xpbnV4L3N0ZGRlZi5oOjg6
MTQ6IG5vdGU6IGV4cGFuZGVkIGZyb20gbWFjcm8gJ05VTEwnCj4+PiA+PiA+wqDCoMKgICNkZWZp
bmUgTlVMTCAoKHZvaWQgKikwKQo+Pj4gPj4gPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIF5+fn5+fn5+fn5+Cj4+PiA+PiA+wqDCoMKgIGFyY2gvYXJtNjQva3ZtL2h5cC9udmhlL3N3
aXRjaC5jOjIwMDoyNzogd2FybmluZzogaW5pdGlhbGl6ZXIgCj4+PiBvdmVycmlkZXMgcHJpb3Ig
aW5pdGlhbGl6YXRpb24gb2YgdGhpcyBzdWJvYmplY3QgCj4+PiBbLVdpbml0aWFsaXplci1vdmVy
cmlkZXNdCj4+PiA+PiA+wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBbRVNSX0VMeF9FQ19GUF9BU0lN
RF3CoMKgwqDCoMKgwqDCoMKgwqDCoCA9IGt2bV9oeXBfaGFuZGxlX2Zwc2ltZCwKPj4+ID4+ID7C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+Cj4+
PiA+PiA+wqDCoMKgIGFyY2gvYXJtNjQva3ZtL2h5cC9udmhlL3N3aXRjaC5jOjE5NjoyODogbm90
ZTogcHJldmlvdXMgCj4+PiBpbml0aWFsaXphdGlvbiBpcyBoZXJlCj4+PiA+PiA+wqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBbMCAuLi4gRVNSX0VMeF9FQ19NQVhdwqDCoMKgwqDCoMKgwqDCoMKgID0g
TlVMTCwKPj4+ID4+ID7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXn5+fgo+Pj4g
Pj4gPsKgwqDCoCBpbmNsdWRlL2xpbnV4L3N0ZGRlZi5oOjg6MTQ6IG5vdGU6IGV4cGFuZGVkIGZy
b20gbWFjcm8gJ05VTEwnCj4+PiA+PiA+wqDCoMKgICNkZWZpbmUgTlVMTCAoKHZvaWQgKikwKQo+
Pj4gPj4gPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF5+fn5+fn5+fn5+Cj4+PiA+
Pgo+Pj4gPj4gS2FsZXNoLCBwbGVhc2UgaWdub3JlIHRoaXMgbm9uc2Vuc2UuIFRoZXJlIG1heSBi
ZSB0aGluZ3MgdG8gaW1wcm92ZSwKPj4+ID4+IGJ1dCB0aGlzIGlzICpOT1QqIG9uZSBvZiB0aGVt
Lgo+Pj4gPj4KPj4+ID4+IFRoZXNlIHJlcG9ydHMgYXJlIHByZXR0eSB1c2VsZXNzLCBhbmQganVz
dCBsZWFkIHBlb3BsZSB0byBpZ25vcmUgcmVhbAo+Pj4gPj4gYnVnIHJlcG9ydHMuCj4+PiA+Cj4+
PiA+IEhpIEthbGVzaCwgc29ycnkgdGhlcmUncmUgc29tZSBpcnJlbGV2YW50IGlzc3VlcyBtaXhl
ZCBpbiB0aGUgcmVwb3J0LAo+Pj4gPiBraW5kbHkgaWdub3JlIHRoZW0uIEFuZCB0aGUgdmFsdWFi
bGUgb25lcyBhcmUgdGhlIG5ldyBvbmVzIHRoYXQKPj4+ID4gcHJlZml4ZWQgYnkgPj4sIGFzIHRo
ZSBiZWxvdyBvbmUgaW4gb3JpZ2luYWwgcmVwb3J0Lgo+Pj4gPgo+Pj4gPj4+IGFyY2gvYXJtNjQv
a3ZtL2h5cC9udmhlL3N3aXRjaC5jOjM3MjoxNzogd2FybmluZzogbm8gcHJldmlvdXMKPj4+ID4+
PiBwcm90b3R5cGUgZm9yIGZ1bmN0aW9uICdoeXBfcGFuaWNfYmFkX3N0YWNrJyBbLVdtaXNzaW5n
LXByb3RvdHlwZXNdCj4+PiA+wqDCoMKgIHZvaWQgX19ub3JldHVybiBoeXBfcGFuaWNfYmFkX3N0
YWNrKHZvaWQpCj4+PiA+wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXgo+
Pj4KPj4+IFRoaXMgaXMgb25seSBjYWxsZWQgZnJvbSBhc3NlbWJseSBjb2RlLCBzbyBhIHByb3Rv
dHlwZSB3b3VsZG4ndCBicmluZwo+Pj4gbXVjaC4KPj4+Cj4+Cj4+IFNob3VsZCBwcm9iYWJseSBi
ZSBtYXJrZWQgYXMgJ2FzbWxpbmthZ2UnIHRoZW4uIEkndmUgc3VnZ2VzdGVkIG1hbnkKPj4gdGlt
ZXMgYWxyZWFkeSB0aGF0IHRoaXMgYm9ndXMgZGlhZ25vc3RpYyBzaG91bGQgZWl0aGVyIGJlIGRp
c2FibGVkLCBvcgo+PiBkaXNyZWdhcmQgJ2FzbWxpbmthZ2UnIHN5bWJvbHMuCj4gCj4gWWVzLCBh
c21saW5rYWdlIGlzIGRlZmluaXRlbHkgbWlzc2luZy4KPiAKPiBCdXQgaXQgaXMgcHJldHR5IG9i
dmlvdXMgdGhhdCB0aGUgcm9ib3QgcGVvcGxlIGFyZW4ndCBpbnRlcmVzdGVkIGluCj4gZml4aW5n
IHRoaXMgcGFydGljdWxhciBpc3N1ZSwgZ2l2ZW4gaG93IGxvbmcgd2UgaGF2ZSBiZWVuIHN1Z2dl
c3RpbmcKPiB0aGlzLi4uCj4gCj4gIMKgwqDCoMKgwqDCoMKgIE0uCgpIaSBNYXJjLCBBcmQsCgpX
ZSBoYXZlIGlnbm9yZWQgdGhlIHdhcm5pbmcgcmVsYXRlZCB0byBhc21saW5rYWdlIGFjY29yZGlu
ZyB0byB0aGUgYmVsb3cgCmFkdmljZToKIApodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL0NB
TWoxa1hIclJZYWdTVm5pU2V0SGRHMTVya1FTK2ZtNHpWT3ROPVpkYTNXMFFhRW9KQUBtYWlsLmdt
YWlsLmNvbS8KCmRvIHlvdSB3YW50IHRoZSBib3QgaWdub3JlIHN1Y2ggd2FybmluZyBpZiBhc21s
aW5rYWdlIG5vdCBzcGVjaWZpZWQ/CgpCZXN0IFJlZ2FyZHMsClJvbmcgQ2hlbgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
