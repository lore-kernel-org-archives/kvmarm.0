Return-Path: <SRS0=XU7X=JY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A327CC433ED
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 14:52:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 123A561178
	for <kvmarm@archiver.kernel.org>; Tue, 27 Apr 2021 14:52:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 123A561178
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F98C4B16C;
	Tue, 27 Apr 2021 10:52:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Le6Z-0LxmgP0; Tue, 27 Apr 2021 10:52:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 320294B158;
	Tue, 27 Apr 2021 10:52:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4CCC4B158
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 10:52:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yn7v6pZi-Sgr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Apr 2021 10:52:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7488B4B14E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Apr 2021 10:52:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94A2231B;
 Tue, 27 Apr 2021 07:52:12 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D95303F73B;
 Tue, 27 Apr 2021 07:52:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to
 non-memory
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20210426103605.616908-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e6d955f1-f2a4-9505-19ab-5a770f821386@arm.com>
Date: Tue, 27 Apr 2021 15:52:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210426103605.616908-1-maz@kernel.org>
Content-Language: en-US
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Krishna Reddy <vdumpa@nvidia.com>, Sumit Gupta <sumitg@nvidia.com>,
 kernel-team@android.com
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

SGksCgpJJ3ZlIGJlZW4gdHJ5aW5nIHRvIHJlcHJvZHVjZSB0aGUgcGFuaWMsIGJ1dCBJIGhhdmVu
J3QgaGFkIGFueSBzdWNjZXNzLgoKV2l0aCBhIGtub3duIHdvcmtpbmcgUENJIHBhc3N0cm91Z2gg
ZGV2aWNlLCB0aGlzIGlzIGhvdyBJIGNoYW5nZWQga3ZtdG9vbDoKCmRpZmYgLS1naXQgYS92Zmlv
L2NvcmUuYyBiL3ZmaW8vY29yZS5jCmluZGV4IDNmZjJjMGIuLmI0ZWU3ZTkgMTAwNjQ0Ci0tLSBh
L3ZmaW8vY29yZS5jCisrKyBiL3ZmaW8vY29yZS5jCkBAIC0yNjEsNiArMjYxLDkgQEAgaW50IHZm
aW9fbWFwX3JlZ2lvbihzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiwK
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7CsKgwqDCoMKgwqDCoMKg
IH0KwqAKK8KgwqDCoMKgwqDCoCBjaGFyIGMgPSAqKGNoYXIgKiliYXNlOworwqDCoMKgwqDCoMKg
IGZwcmludGYoc3RkZXJyLCAiYyA9ICVjXG4iLCBjKTsKKwrCoMKgwqDCoMKgwqDCoCByZXR1cm4g
MDsKwqB9CsKgCldoYXQgdGhlIGNoYW5nZSBpcyBkb2luZyBpcyByZWFkaW5nIGZyb20gdGhlIEJB
UiByZWdpb24gYWZ0ZXIgaXQncyBoYXMgYmVlbgptbWFwJ2VkIGludG8gdXNlcnNwYWNlLiBJIGNh
biBzZWUgdGhhdCB0aGUgcmVhZCBoaXRzIHZmaW9fcGNpX21tYXBfZmF1bHQoKSwgd2hpY2gKY2Fs
bHMgaW9fcmVtYXBfcGZuX3JhbmdlKCksIGJ1dCBJIGNhbid0IGZpZ3VyZSBvdXQgaG93IEkgY2Fu
IHRyaWdnZXIgdGhlIE1NVQpub3RpZmllcnMuIEFueSBzdWdnZXN0aW9ucz8KClRoZSBjb21tZW50
IFsxXSBzdWdnZXN0ZWQgdGhhdCB0aGUgcGFuaWMgaXMgdHJpZ2dlcmVkIGR1cmluZyBwYWdlIGFn
aW5nLgp2ZmlvX3BjaV9tbWFwKCkgc2V0cyB0aGUgVk1fUEZOTUFQIGZvciB0aGUgVk1BIGFuZCBJ
IHNlZSBpbiB0aGUgRG9jdW1lbnRhdGlvbiB0aGF0CnBhZ2VzIHdpdGggVk1fUEZOTUFQIGFyZSBh
ZGRlZCB0byB0aGUgdW5ldmljdGFibGUgTFJVIGxpc3QsIGRvZXNuJ3QgdGhhdCBtZWFuIGl0J3MK
bm90IHN1YmplY3QgdGhlIHBhZ2UgYWdpbmc/IEkgZmVlbCBsaWtlIHRoZXJlJ3Mgc29tZXRoaW5n
IEknbSBtaXNzaW5nLgoKWzFdCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9CWTVQUjEyTUIz
NzY0MkI5QUM3RTVEOTA3RjVBNjY0RjZCMzQ1OUBCWTVQUjEyTUIzNzY0Lm5hbXByZDEyLnByb2Qu
b3V0bG9vay5jb20vCgpUaGFua3MsCgpBbGV4CgpPbiA0LzI2LzIxIDExOjM2IEFNLCBNYXJjIFp5
bmdpZXIgd3JvdGU6Cj4gU3VtaXQgR3VwdGEgYW5kIEtyaXNobmEgUmVkZHkgYm90aCByZXBvcnRl
ZCB0aGF0IGZvciBNTUlPIHJlZ2lvbnMKPiBtYXBwZWQgaW50byB1c2Vyc3BhY2UgdXNpbmcgVkZJ
TywgYSBQVEUgdXBkYXRlIGNhbiB0cmlnZ2VyIGEgTU1VCj4gbm90aWZpZXIgcmVhY2hpbmcga3Zt
X3NldF9zcHRlX2h2YSgpLgo+Cj4gVGhlcmUgaXMgYW4gYXNzdW1wdGlvbiBiYWtlZCBpbiBrdm1f
c2V0X3NwdGVfaHZhKCkgdGhhdCBpdCBvbmx5Cj4gZGVhbHMgd2l0aCBtZW1vcnkgcGFnZXMsIGFu
ZCBub3QgTU1JTy4gRm9yIHRoaXMgcHVycG9zZSwgaXQKPiBwZXJmb3JtcyBhIGNhY2hlIGNsZWFu
aW5nIG9mIHRoZSBwb3RlbnRpYWxseSBuZXdseSBtYXBwZWQgcGFnZS4KPiBIb3dldmVyLCBmb3Ig
YSBNTUlPIHJhbmdlLCB0aGlzIGV4cGxvZGVzIGFzIHRoZXJlIGlzIG5vIGxpbmVhcgo+IG1hcHBp
bmcgZm9yIHRoaXMgcmFuZ2UgKGFuZCBkb2luZyBjYWNoZSBtYWludGVuYW5jZSBvbiBpdCB3b3Vs
ZAo+IG1ha2UgbGl0dGxlIHNlbnNlIGFueXdheSkuCj4KPiBDaGVjayBmb3IgdGhlIHZhbGlkaXR5
IG9mIHRoZSBwYWdlIGJlZm9yZSBwZXJmb3JtaW5nIHRoZSBDTU8KPiBhZGRyZXNzZXMgdGhlIHBy
b2JsZW0uCj4KPiBSZXBvcnRlZC1ieTogS3Jpc2huYSBSZWRkeSA8dmR1bXBhQG52aWRpYS5jb20+
Cj4gUmVwb3J0ZWQtYnk6IFN1bWl0IEd1cHRhIDxzdW1pdGdAbnZpZGlhLmNvbT4sCj4gVGVzdGVk
LWJ5OiBTdW1pdCBHdXB0YSA8c3VtaXRnQG52aWRpYS5jb20+LAo+IFNpZ25lZC1vZmYtYnk6IE1h
cmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvci81YTg4MjViYy0yODZlLWIzMTYtNTE1Zi0zYmQzYzljNzBhODBAbnZpZGlhLmNvbQo+IC0t
LQo+ICBhcmNoL2FybTY0L2t2bS9tbXUuYyB8IDMgKystCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2
bS9tbXUuYyBiL2FyY2gvYXJtNjQva3ZtL21tdS5jCj4gaW5kZXggY2Q0ZDUxYWUzZDRhLi41NjRh
MGY3ZmNkMDUgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vbW11LmMKPiArKysgYi9hcmNo
L2FybTY0L2t2bS9tbXUuYwo+IEBAIC0xMjM2LDcgKzEyMzYsOCBAQCBpbnQga3ZtX3NldF9zcHRl
X2h2YShzdHJ1Y3Qga3ZtICprdm0sIHVuc2lnbmVkIGxvbmcgaHZhLCBwdGVfdCBwdGUpCj4gIAkg
KiBXZSd2ZSBtb3ZlZCBhIHBhZ2UgYXJvdW5kLCBwcm9iYWJseSB0aHJvdWdoIENvVywgc28gbGV0
J3MgdHJlYXQgaXQKPiAgCSAqIGp1c3QgbGlrZSBhIHRyYW5zbGF0aW9uIGZhdWx0IGFuZCBjbGVh
biB0aGUgY2FjaGUgdG8gdGhlIFBvQy4KPiAgCSAqLwo+IC0JY2xlYW5fZGNhY2hlX2d1ZXN0X3Bh
Z2UocGZuLCBQQUdFX1NJWkUpOwo+ICsJaWYgKCFrdm1faXNfZGV2aWNlX3BmbihwZm4pKQo+ICsJ
CWNsZWFuX2RjYWNoZV9ndWVzdF9wYWdlKHBmbiwgUEFHRV9TSVpFKTsKPiAgCWhhbmRsZV9odmFf
dG9fZ3BhKGt2bSwgaHZhLCBlbmQsICZrdm1fc2V0X3NwdGVfaGFuZGxlciwgJnBmbik7Cj4gIAly
ZXR1cm4gMDsKPiAgfQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
