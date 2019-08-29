Return-Path: <SRS0=G53S=WZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF234C3A59F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A05B2189D
	for <kvmarm@archiver.kernel.org>; Thu, 29 Aug 2019 08:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A05B2189D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA244A551;
	Thu, 29 Aug 2019 04:18:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BE8TvJlTj+Wf; Thu, 29 Aug 2019 04:18:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C57C4A559;
	Thu, 29 Aug 2019 04:18:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1814A551
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Aug 2019 04:18:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pMtwQXM07QaU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Aug 2019 04:18:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02B1D4A521
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Aug 2019 04:18:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C78728;
 Thu, 29 Aug 2019 01:18:37 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D0483F246;
 Thu, 29 Aug 2019 01:18:36 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 04/16] arm/arm64: selftest: Add
 prefetch abort test
To: Mark Rutland <mark.rutland@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-5-git-send-email-alexandru.elisei@arm.com>
 <20190828140925.GC41023@lakrids.cambridge.arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e6b8a3c9-2e11-c806-da5b-8b66d8f63ce3@arm.com>
Date: Thu, 29 Aug 2019 09:18:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190828140925.GC41023@lakrids.cambridge.arm.com>
Content-Language: en-US
Cc: maz@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, andre.przywara@arm.com
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

T24gOC8yOC8xOSAzOjA5IFBNLCBNYXJrIFJ1dGxhbmQgd3JvdGU6Cj4gT24gV2VkLCBBdWcgMjgs
IDIwMTkgYXQgMDI6Mzg6MTlQTSArMDEwMCwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4gV2hl
biBhIGd1ZXN0IHRyaWVzIHRvIGV4ZWN1dGUgY29kZSBmcm9tIE1NSU8gbWVtb3J5LCBLVk0gaW5q
ZWN0cyBhbgo+PiBleHRlcm5hbCBhYm9ydCBpbnRvIHRoYXQgZ3Vlc3QuIFdlIGhhdmUgbm93IGZp
eGVkIHRoZSBwc2NpIHRlc3QgdG8gbm90Cj4+IGZldGNoIGluc3RydWN0aW9ucyBmcm9tIHRoZSBJ
L08gcmVnaW9uLCBhbmQgaXQncyBub3QgdGhhdCBvZnRlbiB0aGF0IGEKPj4gZ3Vlc3QgbWlzYmVo
YXZlcyBpbiBzdWNoIGEgd2F5LiBMZXQncyBleHBhbmQgb3VyIGNvdmVyYWdlIGJ5IGFkZGluZyBh
Cj4+IHByb3BlciB0ZXN0IHRhcmdldHRpbmcgdGhpcyBjb3JuZXIgY2FzZS4KPj4KPj4gU2lnbmVk
LW9mZi1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVsaXNlaUBhcm0uY29tPgo+PiAt
LS0KPj4gVGhlIGZhdWx0IGluamVjdGlvbiBwYXRoIGlzIGJyb2tlbiBmb3IgbmVzdGVkIGd1ZXN0
cyBbMV0uIFlvdSBjYW4gdXNlIHRoZQo+PiBsYXN0IHBhdGNoIGZyb20gdGhlIHRocmVhZCBbMl0g
dG8gc3VjY2Vzc2Z1bGx5IHJ1biB0aGUgdGVzdCBhdCBFTDIuCj4+Cj4+IFsxXSBodHRwczovL3d3
dy5zcGluaWNzLm5ldC9saXN0cy9hcm0ta2VybmVsL21zZzc0NTM5MS5odG1sCj4+IFsyXSBodHRw
czovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9hcm0ta2VybmVsL21zZzc1MDMxMC5odG1sCj4+Cj4+
ICBsaWIvYXJtNjQvYXNtL2Vzci5oIHwgIDMgKysKPj4gIGFybS9zZWxmdGVzdC5jICAgICAgfCA5
NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQo+
PiAgMiBmaWxlcyBjaGFuZ2VkLCA5NiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQo+Pgo+
PiBkaWZmIC0tZ2l0IGEvbGliL2FybTY0L2FzbS9lc3IuaCBiL2xpYi9hcm02NC9hc20vZXNyLmgK
Pj4gaW5kZXggOGU1YWY0ZDkwNzY3Li44YzM1MTYzMWIwYTAgMTAwNjQ0Cj4+IC0tLSBhL2xpYi9h
cm02NC9hc20vZXNyLmgKPj4gKysrIGIvbGliL2FybTY0L2FzbS9lc3IuaAo+PiBAQCAtNDQsNCAr
NDQsNyBAQAo+PiAgI2RlZmluZSBFU1JfRUwxX0VDX0JLUFQzMgkoMHgzOCkKPj4gICNkZWZpbmUg
RVNSX0VMMV9FQ19CUks2NAkoMHgzQykKPj4gIAo+PiArI2RlZmluZSBFU1JfRUwxX0ZTQ19NQVNL
CSgweDNGKQo+PiArI2RlZmluZSBFU1JfRUwxX0ZTQ19FWFRBQlQJKDB4MTApCj4+ICsKPj4gICNl
bmRpZiAvKiBfQVNNQVJNNjRfRVNSX0hfICovCj4+IGRpZmYgLS1naXQgYS9hcm0vc2VsZnRlc3Qu
YyBiL2FybS9zZWxmdGVzdC5jCj4+IGluZGV4IDE3NjIzMWYzMmVlMS4uMThjYzBhZDhmNzI5IDEw
MDY0NAo+PiAtLS0gYS9hcm0vc2VsZnRlc3QuYwo+PiArKysgYi9hcm0vc2VsZnRlc3QuYwo+PiBA
QCAtMTYsNiArMTYsOCBAQAo+PiAgI2luY2x1ZGUgPGFzbS9wc2NpLmg+Cj4+ICAjaW5jbHVkZSA8
YXNtL3NtcC5oPgo+PiAgI2luY2x1ZGUgPGFzbS9iYXJyaWVyLmg+Cj4+ICsjaW5jbHVkZSA8YXNt
L21tdS5oPgo+PiArI2luY2x1ZGUgPGFzbS9wZ3RhYmxlLmg+Cj4+ICAKPj4gIHN0YXRpYyB2b2lk
IF9fdXNlcl9wc2NpX3N5c3RlbV9vZmYodm9pZCkKPj4gIHsKPj4gQEAgLTYwLDkgKzYyLDM4IEBA
IHN0YXRpYyB2b2lkIGNoZWNrX3NldHVwKGludCBhcmdjLCBjaGFyICoqYXJndikKPj4gIAkJcmVw
b3J0X2Fib3J0KCJtaXNzaW5nIGlucHV0Iik7Cj4+ICB9Cj4+ICAKPj4gK2V4dGVybiBwZ2RfdCAq
bW11X2lkbWFwOwo+PiArc3RhdGljIHZvaWQgcHJlcF9pb19leGVjKHZvaWQpCj4+ICt7Cj4+ICsJ
cGdkX3QgKnBnZCA9IHBnZF9vZmZzZXQobW11X2lkbWFwLCAwKTsKPj4gKwl1bnNpZ25lZCBsb25n
IHNjdGxyOwo+PiArCj4+ICsJLyoKPj4gKwkgKiBBQXJjaDY0IHRyZWF0cyBhbGwgcmVnaW9ucyB3
cml0YWJsZSBhdCBFTDAgYXMgUFhOLgo+IEkgZGlkbid0IHRoaW5rIHRoYXQgd2FzIHRoZSBjYXNl
LCBhbmQgSSBjYW4ndCBmaW5kIHdvcmRpbmcgdG8gdGhhdAo+IGVmZmVjdCBpbiB0aGUgQVJNIEFS
TSAobG9va2luZyBhdCBBUk0gRERJIDA0ODdFLmEpLiBXaGVyZSBpcyB0aGF0Cj4gc3RhdGVkPwoK
SXQncyBpbiBBUk0gRERJIDA0ODdFLmEsIHRhYmxlIEQ1LTMzLCBmb290bm90ZSBjOiAiTm90IGV4
ZWN1dGFibGUsIGJlY2F1c2UKQUFyY2g2NCBleGVjdXRpb24gdHJlYXRzIGFsbCByZWdpb25zIHdy
aXRhYmxlIGF0IEVMMCBhcyBiZWluZyBQWE4iLiBJJ2xsIHVwZGF0ZQp0aGUgY29tbWVudCB0byBp
bmNsdWRlIHRoZSBxdW90ZS4KCj4KPj4gQ2xlYXIgdGhlIHVzZXIgYml0Cj4+ICsJICogc28gd2Ug
Y2FuIGV4ZWN1dGUgY29kZSBmcm9tIHRoZSBib3R0b20gSS9PIHNwYWNlICgwRy0xRykgdG8gc2lt
dWxhdGUKPj4gKwkgKiBhIG1pc2JlaGF2ZWQgZ3Vlc3QuCj4+ICsJICovCj4+ICsJcGdkX3ZhbCgq
cGdkKSAmPSB+UE1EX1NFQ1RfVVNFUjsKPj4gKwlmbHVzaF9kY2FjaGVfYWRkcigodW5zaWduZWQg
bG9uZylwZ2QpOwo+IFRoZSB2aXJ0dWFsaXphdGlvbiBleHRlbnNpb25zIGltcGx5IGNvaGVyZW50
IHBhZ2UgdGFibGUgd2Fsa3MsIHNvIEkKPiBkb24ndCB0aGluayB0aGUgY2FjaGUgbWFpbnRlbmFu
Y2UgaXMgbmVjZXNzYXJ5IChwcm92aWRlZAo+IFRDUl9FTDEue1NIKixPUkdOKixJUkdOKn0gYXJl
IGNvbmZpZ3VyZWQgYXBwcm9wcmlhdGVseS4KCkkgd2FzIGZvbGxvd2luZyB0aGUgcGF0dGVybiBm
cm9tIGxpYi9hcm0vbW11LmMuIFlvdSBhcmUgY29ycmVjdCwgYW5kIExpbnV4CmRvZXNuJ3QgZG8g
YW55IGRjYWNoZSBtYWludGVuYW5jZSBlaXRoZXIgKGp1ZGdpbmcgYnkgbG9va2luZyBhdCBib3Ro
IHNldF9wdGUKKGZvciBhcm02NCkgYW5kIHZhcmlvdXMgaW1wbGVtZW50YXRpb25zIGZvciBzZXRf
cHRlX2V4dCAoZm9yIGFybXY3KSkuCgpGb3IgZnV0dXJlIHJlZmVyZW5jZSwgQVJNIERESSAwNDg3
RS5hLCBpbiBzZWN0aW9uIEQxMy4yLjcyLCBzdGF0ZXMgYWJvdXQgdGhlCklEX01NRlIzX0VMMSBy
ZWdpc3RlcjoKCiJDb2hXYWxrLCBiaXRzIFsyMzoyMF0KCkNvaGVyZW50IFdhbGsuIEluZGljYXRl
cyB3aGV0aGVyIFRyYW5zbGF0aW9uIHRhYmxlIHVwZGF0ZXMgcmVxdWlyZSBhIGNsZWFuIHRvCnRo
ZSBQb2ludCBvZiBVbmlmaWNhdGlvbi4gRGVmaW5lZCB2YWx1ZXMgYXJlOgowYjAwMDAgVXBkYXRl
cyB0byB0aGUgdHJhbnNsYXRpb24gdGFibGVzIHJlcXVpcmUgYSBjbGVhbiB0byB0aGUgUG9pbnQg
b2YKVW5pZmljYXRpb24gdG8gZW5zdXJlIHZpc2liaWxpdHkgYnkgc3Vic2VxdWVudCB0cmFuc2xh
dGlvbiB0YWJsZSB3YWxrcy4KMGIwMDAxIFVwZGF0ZXMgdG8gdGhlIHRyYW5zbGF0aW9uIHRhYmxl
cyBkbyBub3QgcmVxdWlyZSBhIGNsZWFuIHRvIHRoZSBQb2ludCBvZgpVbmlmaWNhdGlvbiB0byBl
bnN1cmUgdmlzaWJpbGl0eSBieSBzdWJzZXF1ZW50IHRyYW5zbGF0aW9uIHRhYmxlIHdhbGtzLgoK
SW4gQXJtdjgtQSB0aGUgb25seSBwZXJtaXR0ZWQgdmFsdWUgaXMgMGIwMDAxLiIKCkZvciBhcm12
NywgQVJNIERESSAwNDA2Qy5kIHN0YXRlcyBpbiBzZWN0aW9uIEIzLjMuMSBUcmFuc2xhdGlvbiB0
YWJsZSB3YWxrczoKCiJJZiBhbiBpbXBsZW1lbnRhdGlvbiBpbmNsdWRlcyB0aGUgTXVsdGlwcm9j
ZXNzaW5nIEV4dGVuc2lvbnMsIHRyYW5zbGF0aW9uIHRhYmxlCndhbGtzIG11c3QgYWNjZXNzIGRh
dGEgb3IgdW5pZmllZCBjYWNoZXMsIG9yIGRhdGEgYW5kIHVuaWZpZWQgY2FjaGVzLCBvZiBvdGhl
cgphZ2VudHMgcGFydGljaXBhdGluZyBpbiB0aGUgY29oZXJlbmN5IHByb3RvY29sLCBhY2NvcmRp
bmcgdG8gdGhlIHNoYXJlYWJpbGl0eQphdHRyaWJ1dGVzIGRlc2NyaWJlZCBpbiB0aGXCoCBUVEJS
LiBUaGVzZSBzaGFyZWFiaWxpdHkgYXR0cmlidXRlcyBtdXN0IGJlCmNvbnNpc3RlbnQgd2l0aCB0
aGUgc2hhcmVhYmlsaXR5IGF0dHJpYnV0ZXMgZm9yIHRoZSB0cmFuc2xhdGlvbiB0YWJsZXMgdGhl
bXNlbHZlcy4iCgphbmQgaW4gc2VjdGlvbiBCMS43IHRoYXQgdmlydHVhbGl6YXRpb24gZXh0ZW5z
aW9ucyByZXF1aXJlIHRoZSBtdWx0aXByb2Nlc3NpbmcKZXh0ZW5zaW9ucy4KClNvIHRoZSBkY2Fj
aGUgbWFpbnRlbmFuY2Ugb3BlcmF0aW9ucyBhcmUgbm90IG5lZWRlZCwgSSdsbCByZW1vdmUgdGhl
bSwgdGhhbmsgeW91CmZvciBwb2ludGluZyB0aGlzIG91dC4KClRoYW5rcywKQWxleAo+Cj4+ICsJ
Zmx1c2hfdGxiX3BhZ2UoMCk7Cj4+ICsKPj4gKwkvKiBNYWtlIHN1cmUgd2UgY2FuIGFjdHVhbGx5
IGV4ZWN1dGUgZnJvbSBhIHdyaXRhYmxlIHJlZ2lvbiAqLwo+PiArI2lmZGVmIF9fYXJtX18KPj4g
Kwlhc20gdm9sYXRpbGUoIm1yYyBwMTUsIDAsICUwLCBjMSwgYzAsIDAiOiAiPXIiIChzY3Rscikp
Owo+PiArCXNjdGxyICY9IH5DUl9TVDsKPj4gKwlhc20gdm9sYXRpbGUoIm1jciBwMTUsIDAsICUw
LCBjMSwgYzAsIDAiIDo6ICJyIiAoc2N0bHIpKTsKPj4gKyNlbHNlCj4+ICsJc2N0bHIgPSByZWFk
X3N5c3JlZyhzY3Rscl9lbDEpOwo+PiArCXNjdGxyICY9IH5TQ1RMUl9FTDFfV1hOOwo+PiArCXdy
aXRlX3N5c3JlZyhzY3Rsciwgc2N0bHJfZWwxKTsKPj4gKyNlbmRpZgo+PiArCWlzYigpOwo+PiAr
fQo+IFRoYW5rcywKPiBNYXJrLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
