Return-Path: <SRS0=bs2E=2C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EB9C43603
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 09:55:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8D06214AF
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 09:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8D06214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 496604AEB2;
	Thu, 12 Dec 2019 04:55:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EUUGR5UVoPZL; Thu, 12 Dec 2019 04:55:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DD084ACB7;
	Thu, 12 Dec 2019 04:55:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 492944ACDB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 04:55:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T5PZBUL5Z5I2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Dec 2019 04:55:35 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DC984A94D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 04:55:35 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ifLC0-0007AX-PZ; Thu, 12 Dec 2019 10:55:32 +0100
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Ensure 'params' is initialised when looking
 up sys register
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Thu, 12 Dec 2019 09:55:32 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191212094049.12437-1-will@kernel.org>
References: <20191212094049.12437-1-will@kernel.org>
Message-ID: <a4b931f697b2fc7ec6ef5356b84a3939@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, kernel-team@android.com, stable@vger.kernel.org,
 vijaya.kumar@cavium.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: stable@vger.kernel.org, Vijaya Kumar K <vijaya.kumar@cavium.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

T24gMjAxOS0xMi0xMiAwOTo0MCwgV2lsbCBEZWFjb24gd3JvdGU6Cj4gQ29tbWl0IDRiOTI3Yjk0
ZDVkZiAoIktWTTogYXJtL2FybTY0OiB2Z2ljOiBJbnRyb2R1Y2UgCj4gZmluZF9yZWdfYnlfaWQo
KSIpCj4gaW50cm9kdWNlZCAnZmluZF9yZWdfYnlfaWQoKScsIHdoaWNoIGxvb2tzIHVwIGEgc3lz
dGVtIHJlZ2lzdGVyIG9ubHkgCj4gaWYKPiB0aGUgJ2lkJyBpbmRleCBwYXJhbWV0ZXIgaWRlbnRp
ZmllcyBhIHZhbGlkIHN5c3RlbSByZWdpc3Rlci4gQXMgcGFydCAKPiBvZgo+IHRoZSBwYXRjaCwg
ZXhpc3RpbmcgY2FsbGVycyBvZiAnZmluZF9yZWcoKScgd2VyZSBwb3J0ZWQgb3ZlciB0byB0aGUg
Cj4gbmV3Cj4gaW50ZXJmYWNlLCBidXQgdGhpcyBicmVha3MgJ2luZGV4X3RvX3N5c19yZWdfZGVz
YygpJyBpbiB0aGUgY2FzZSB0aGF0IAo+IHRoZQo+IGluaXRpYWwgbG9va3VwIGluIHRoZSB2Q1BV
IHRhcmdldCB0YWJsZSBmYWlscyBiZWNhdXNlIHdlIHdpbGwgdGhlbiAKPiBjYWxsCj4gaW50byAn
ZmluZF9yZWcoKScgZm9yIHRoZSBzeXN0ZW0gcmVnaXN0ZXIgdGFibGUgd2l0aCBhbiB1bmluaXRp
YWxpc2VkCj4gJ3BhcmFtJyBhcyB0aGUga2V5IHRvIHRoZSBsb29rdXAuCj4KPiBHQ0MgMTAgaXMg
YnJpZ2h0IGVub3VnaCB0byBzcG90IHRoaXMgKGFtb25nc3QgYSB0b25uZSBvZiBmYWxzZSAKPiBw
b3NpdGl2ZXMsCj4gYnV0IGhleSEpOgo+Cj4gICB8IGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmM6
IEluIGZ1bmN0aW9uIAo+IOKAmGluZGV4X3RvX3N5c19yZWdfZGVzYy5wYXJ0LjAuaXNyYeKAmToK
PiAgIHwgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYzo5ODM6MzM6IHdhcm5pbmc6IOKAmHBhcmFt
cy5PcDLigJkgbWF5IGJlIAo+IHVzZWQgdW5pbml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uIFst
V21heWJlLXVuaW5pdGlhbGl6ZWRdCj4gICB8ICAgOTgzIHwgICAodTMyKSh4KS0+Q1JuLCAodTMy
KSh4KS0+Q1JtLCAodTMyKSh4KS0+T3AyKTsKPiAgIHwgWy4uLl0KPgo+IFJldmVydCB0aGUgaHVu
ayBvZiA0YjkyN2I5NGQ1ZGYgd2hpY2ggYnJlYWtzIAo+ICdpbmRleF90b19zeXNfcmVnX2Rlc2Mo
KScgc28KPiB0aGF0IHRoZSBvbGQgYmVoYXZpb3VyIG9mIGNoZWNraW5nIHRoZSBpbmRleCB1cGZy
b250IGlzIHJlc3RvcmVkLgoKSHVodWguLi4gV2VsbCBzcG90dGVkIEdDQyAxMCEgQW5kIHRoYW5r
cyBXaWxsIGZvciB0aGUgZml4LgoKPgo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KPiBD
YzogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPiBDYzogVmlqYXlhIEt1bWFyIEsgPFZp
amF5YS5LdW1hckBjYXZpdW0uY29tPgo+IEZpeGVzOiA0YjkyN2I5NGQ1ZGYgKCJLVk06IGFybS9h
cm02NDogdmdpYzogSW50cm9kdWNlIAo+IGZpbmRfcmVnX2J5X2lkKCkiKQo+IFNpZ25lZC1vZmYt
Ynk6IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+Cj4gLS0tCj4gIGFyY2gvYXJtNjQva3Zt
L3N5c19yZWdzLmMgfCA1ICsrKystCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5j
IGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwo+IGluZGV4IDQ2ODIyYWZjNTdlMC4uMDFhNTE1
ZTAxNzFlIDEwMDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPiArKysgYi9h
cmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCj4gQEAgLTIzNjAsOCArMjM2MCwxMSBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYwo+ICppbmRleF90b19zeXNfcmVnX2Rlc2Moc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LAo+ICAJaWYgKChpZCAmIEtWTV9SRUdfQVJNX0NPUFJPQ19NQVNLKSAh
PSBLVk1fUkVHX0FSTTY0X1NZU1JFRykKPiAgCQlyZXR1cm4gTlVMTDsKPgo+ICsJaWYgKCFpbmRl
eF90b19wYXJhbXMoaWQsICZwYXJhbXMpKQo+ICsJCXJldHVybiBOVUxMOwo+ICsKPiAgCXRhYmxl
ID0gZ2V0X3RhcmdldF90YWJsZSh2Y3B1LT5hcmNoLnRhcmdldCwgdHJ1ZSwgJm51bSk7Cj4gLQly
ID0gZmluZF9yZWdfYnlfaWQoaWQsICZwYXJhbXMsIHRhYmxlLCBudW0pOwo+ICsJciA9IGZpbmRf
cmVnKCZwYXJhbXMsIHRhYmxlLCBudW0pOwo+ICAJaWYgKCFyKQo+ICAJCXIgPSBmaW5kX3JlZygm
cGFyYW1zLCBzeXNfcmVnX2Rlc2NzLCBBUlJBWV9TSVpFKHN5c19yZWdfZGVzY3MpKTsKCkFwcGxp
ZWQsIHRoYW5rcy4KCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNt
ZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
