Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EF9C07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 15:28:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B37961417
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 15:28:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B37961417
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E93B14A126;
	Mon, 19 Jul 2021 11:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0uP9xAOxxgNK; Mon, 19 Jul 2021 11:28:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF3E84A023;
	Mon, 19 Jul 2021 11:28:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E4AA49FB0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:28:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Ji+9GB2BrQx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 11:28:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C2840FC7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:28:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 151981FB;
 Mon, 19 Jul 2021 08:28:21 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91F053F66F;
 Mon, 19 Jul 2021 08:28:18 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, maz@kernel.org
References: <20210608154805.216869-1-jean-philippe@linaro.org>
Message-ID: <c29ff5c8-9c94-6a6c-6142-3bed440676bf@arm.com>
Date: Mon, 19 Jul 2021 16:29:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210608154805.216869-1-jean-philippe@linaro.org>
Content-Language: en-US
Cc: salil.mehta@huawei.com, lorenzo.pieralisi@arm.com, kvm@vger.kernel.org,
 corbet@lwn.net, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 jonathan.cameron@huawei.com, pbonzini@redhat.com, will@kernel.org,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgSmVhbi1QaGlsaXBwZSwKCkknbSBub3QgcmVhbGx5IGZhbWlsaWFyIHdpdGggdGhpcyBwYXJ0
IG9mIEtWTSwgYW5kIEknbSBzdGlsbCB0cnlpbmcgdG8gZ2V0IG15IGhlYWQKYXJvdW5kIGhvdyB0
aGlzIHdvcmtzLCBzbyBwbGVhc2UgYmFyZSB3aXRoIG1lIGlmIEkgYXNrIHNpbGx5IHF1ZXN0aW9u
cy4KClRoaXMgaXMgaG93IEkgdW5kZXJzdGFuZCB0aGlzIHdpbGwgd29yazoKCjEuIFZNTSBvcHRz
IGluIHRvIGZvcndhcmQgSFZDIGNhbGxzIG5vdCBoYW5kbGVkIGJ5IEtWTS4KCjIuIFZNTSBvcHRz
IGluIHRvIGZvcndhcmQgUFNDSSBjYWxscywgb3RoZXIgdGhhbgpQU0NJXzFfMF9GTl9QU0NJX0ZF
QVRVUkVTKEFSTV9TTUNDQ19WRVJTSU9OX0ZVTkNfSUQpLgoKMy4gR3Vlc3QgZW11bGF0ZXMgUFND
SSBjYWxscyAoYW5kIGFsbCB0aGUgb3RoZXIgSFZDIGNhbGxzKS4KCsKgwqDCoCAzLmEgRm9yIENQ
VV9TVVNQRU5EIGNvbWluZyBmcm9tIFZDUFUgQSwgdXNlcnNwYWNlIGRvZXMgYQpLVk1fU0VUX01Q
X1NUQVRFKEtWTV9NUF9TVEFURV9IQUxURUQpIGlvY3RsIG9uIHRoZSBWQ1BVIGZkIHdoaWNoIHNl
dHMgdGhlIHJlcXVlc3QKS1ZNX1JFUV9TVVNQRU5ELgoKwqDCoMKgIDMuYiBUaGUgbmV4dCB0aW1l
IHRoZSBWQ1BVIGlzIHJ1biwgS1ZNIGJsb2NrcyB0aGUgVkNQVSBhcyBhIHJlc3VsdCBvZiB0aGUK
cmVxdWVzdC4ga3ZtX3ZjcHVfYmxvY2soKSBkb2VzIGEgc2NoZWR1bGUoKSBpbiBhIGxvb3AgdW50
aWwgaXQgZGVjaWRlcyB0aGF0IHRoZQpDUFUgbXVzdCB1bmJsb2NrLgoKwqDCoMKgIDMuYyBUaGUg
VkNQVSB3aWxsIHJ1biBhcyBub3JtYWwgYWZ0ZXIga3ZtX3ZjcHVfYmxvY2soKSByZXR1cm5zLgoK
UGxlYXNlIGNvcnJlY3QgbWUgaWYgSSBnb3Qgc29tZXRoaW5nIHdyb25nLgoKSSBoYXZlIGEgZmV3
IGdlbmVyYWwgcXVlc3Rpb25zLiBJdCBkb2Vzbid0IG1lYW4gdGhlcmUncyBzb21ldGhpbmcgd3Jv
bmcgd2l0aCB5b3VyCmFwcHJvYWNoLCBJJ20ganVzdCB0cnlpbmcgdG8gdW5kZXJzdGFuZCBpdCBi
ZXR0ZXIuCgoxLiBXaHkgZm9yd2FyZGluZyBQU0NJIGNhbGxzIHRvIHVzZXJzcGFjZSBkZXBlbmQg
b24gZW5hYmxpbmcgZm9yd2FyZGluZyBmb3Igb3RoZXIKSFZDIGNhbGxzPyBBcyBJIHVuZGVyc3Rh
bmQgZnJvbSB0aGUgcGF0Y2hlcywgdGhvc2UgaGFuZGxlIGRpc3RpbmN0IGZ1bmN0aW9uIElEcy4K
CjIuIEhWQyBjYWxsIGZvcndhcmRpbmcgdG8gdXNlcnNwYWNlIGFsc28gZm9yd2FyZHMgUFNDSSBm
dW5jdGlvbnMgd2hpY2ggYXJlIGRlZmluZWQKaW4gQVJNIERFTiAwMDIyRCwgYnV0IG5vdCAoeWV0
KSBpbXBsZW1lbnRlZCBieSBLVk0uIFdoYXQgaGFwcGVucyBpZiBLVk0ncyBQU0NJCmltcGxlbWVu
dGF0aW9uIGdldHMgc3VwcG9ydCBmb3Igb25lIG9mIHRob3NlIGZ1bmN0aW9ucz8gSG93IGRvZXMg
dXNlcnNwYWNlIGtub3cKdGhhdCBub3cgaXQgYWxzbyBuZWVkcyB0byBlbmFibGUgUFNDSSBjYWxs
IGZvcndhcmRpbmcgdG8gYmUgYWJsZSB0byBoYW5kbGUgdGhhdApmdW5jdGlvbj8KCkl0IGxvb2tz
IHRvIG1lIGxpa2UgdGhlIGJvdW5kYXJ5IGJldHdlZW4gdGhlIGZ1bmN0aW9ucyB0aGF0IGFyZSBm
b3J3YXJkZWQgd2hlbiBIVkMKY2FsbCBmb3J3YXJkaW5nIGlzIGVuYWJsZWQgYW5kIHRoZSBmdW5j
dGlvbnMgdGhhdCBhcmUgZm9yd2FyZGVkIHdoZW4gUFNDSSBjYWxsCmZvcndhcmRpbmcgaXMgZW5h
YmxlZCBpcyBiYXNlZCBvbiB3aGF0IExpbnV4IHY1LjEzIGhhbmRsZXMuIEhhdmUgeW91IGNvbnNp
ZGVyZWQKY2hvb3NpbmcgdGhpcyBib3VuZGFyeSBiYXNlZCBvbiBzb21ldGhpbmcgbGVzcyBhcmJp
dHJhcnksIGxpa2UgdGhlIGZ1bmN0aW9uIHR5cGVzCnNwZWNpZmllZCBpbiBBUk0gREVOIDAwMjhD
LCB0YWJsZSAyLTE/CgpJbiBteSBvcGluaW9uLCBzZXR0aW5nIHRoZSBNUCBzdGF0ZSB0byBIQUxU
RUQgbG9va3MgbGlrZSBhIHNlbnNpYmxlIGFwcHJvYWNoIHRvCmltcGxlbWVudGluZyBQU0NJX1NV
U1BFTkQuIEknbGwgdGFrZSBhIGNsb3NlciBsb29rIGF0IHRoZSBwYXRjaGVzIGFmdGVyIEkgZ2V0
IGEKYmV0dGVyIHVuZGVyc3RhbmRpbmcgYWJvdXQgd2hhdCBpcyBnb2luZyBvbi4KCk9uIDYvOC8y
MSA0OjQ4IFBNLCBKZWFuLVBoaWxpcHBlIEJydWNrZXIgd3JvdGU6Cj4gQWxsb3cgdXNlcnNwYWNl
IHRvIHJlcXVlc3QgaGFuZGxpbmcgUFNDSSBjYWxscyBmcm9tIGd1ZXN0cy4gT3VyIGdvYWwgaXMK
PiB0byBlbmFibGUgYSB2Q1BVIGhvdC1hZGQgc29sdXRpb24gZm9yIEFybSB3aGVyZSB0aGUgVk1N
IHByZXNlbnRzCj4gcG9zc2libGUgcmVzb3VyY2VzIHRvIHRoZSBndWVzdCBhdCBib290LCBhbmQg
Y29udHJvbHMgd2hpY2ggdkNQVXMgY2FuIGJlCj4gYnJvdWdodCB1cCBieSBhbGxvd2luZyBvciBk
ZW55aW5nIFBTQ0kgQ1BVX09OIGNhbGxzLiBQYXNzaW5nIEhWQyBhbmQKPiBQU0NJIHRvIHVzZXJz
cGFjZSBoYXMgYmVlbiBkaXNjdXNzZWQgb24gdGhlIGxpc3QgaW4gdGhlIGNvbnRleHQgb2YgdkNQ
VQo+IGhvdC1hZGQgWzEsMl0gYnV0IGl0IGNhbiBhbHNvIGJlIHVzZWZ1bCBmb3IgaW1wbGVtZW50
aW5nIG90aGVyIFNNQ0NDIGFuZAo+IHZlbmRvciBoeXBlcmNhbGxzIFszLDQsNV0uCj4KPiBQYXRj
aGVzIDEtMyBhbGxvdyB1c2Vyc3BhY2UgdG8gcmVxdWVzdCBXRkkgdG8gYmUgZXhlY3V0ZWQgaW4g
S1ZNLiBUaGF0CgpJIGRvbid0IHVuZGVyc3RhbmQgdGhpcy4gS1ZNLCBpbiBrdm1fdmNwdV9ibG9j
aygpLCBkb2VzIG5vdCBleGVjdXRlIGFuIFdGSS4KUFNDSV9TVVNQRU5EIGlzIGRvY3VtZW50ZWQg
YXMgYmVpbmcgaW5kaXN0aW5ndWlzaGFibGUgZnJvbSBhbiBXRkkgZnJvbSB0aGUgZ3Vlc3Qncwpw
b2ludCBvZiB2aWV3LCBidXQgaXQncyBpbXBsZW1lbnRhdGlvbiBpcyBub3QgYXJjaGl0ZWN0dXJh
bGx5IGRlZmluZWQuCgpUaGFua3MsCgpBbGV4Cgo+IHdheSB0aGUgVk1NIGNhbiBlYXNpbHkgaW1w
bGVtZW50IHRoZSBQU0NJIENQVV9TVVNQRU5EIGZ1bmN0aW9uLCB3aGljaCBpcwo+IG1hbmRhdG9y
eSBmcm9tIFBTQ0kgdjAuMiBvbndhcmRzIChldmVuIGlmIGl0IGRvZXNuJ3QgaGF2ZSBhIG1vcmUg
dXNlZnVsCj4gaW1wbGVtZW50YXRpb24gdGhhbiBXRkksIG5hdGl2ZWx5IGF2YWlsYWJsZSB0byB0
aGUgZ3Vlc3QpLgo+Cj4gUGF0Y2ggNCBsZXRzIHVzZXJzcGFjZSByZXF1ZXN0IGFueSBIVkMgdGhh
dCBpc24ndCBoYW5kbGVkIGJ5IEtWTSwgYW5kCj4gcGF0Y2ggNSBsZXRzIHVzZXJzcGFjZSByZXF1
ZXN0IFBTQ0kgY2FsbHMsIGRpc2FibGluZyBpbi1rZXJuZWwgUFNDSQo+IGhhbmRsaW5nLgo+Cj4g
SSdtIGZvY3VzaW5nIG9uIHRoZSBQU0NJIGJpdHMsIGJ1dCBhIGNvbXBsZXRlIHByb3RvdHlwZSBv
ZiB2Q1BVIGhvdC1hZGQKPiBmb3IgYXJtNjQgb24gTGludXggYW5kIFFFTVUsIG1vc3Qgb2YgaXQg
ZnJvbSBTYWxpbCBhbmQgSmFtZXMsIGlzCj4gYXZhaWxhYmxlIGF0IFs2XS4KPgo+IFsxXSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9rdm1hcm0vODI4NzkyNTgtNDZhNy1hNmU5LWVlNTQtZmMzNjky
YzFjZGMzQGFybS5jb20vCj4gWzJdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWFybS1r
ZXJuZWwvMjAyMDA2MjUxMzM3NTcuMjIzMzItMS1zYWxpbC5tZWh0YUBodWF3ZWkuY29tLwo+ICAg
ICAoRm9sbG93ZWQgYnkgS1ZNIGZvcnVtIGFuZCBMaW5hcm8gT3BlbiBkaXNjdXNzaW9ucykKPiBb
M10gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYXJtLWtlcm5lbC9mNTZjZjQyMC1hZmZj
LTM1ZjAtMjM1NS04MDFhOTI0YjhhMzVAYXJtLmNvbS8KPiBbNF0gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcva3ZtL2JmN2U4M2YxLWM1OGUtOGQ2NS1lZGQwLWQwOGYyN2I4Yjc2NkBhcm0uY29tLwo+
IFs1XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMTU2OTMzODQ1NC0yNjIwMi0yLWdpdC1z
ZW5kLWVtYWlsLWd1b2hleWlAaHVhd2VpLmNvbS8KPiBbNl0gaHR0cHM6Ly9qcGJydWNrZXIubmV0
L2dpdC9saW51eC9sb2cvP2g9Y3B1aHAvZGV2ZWwKPiAgICAgaHR0cHM6Ly9qcGJydWNrZXIubmV0
L2dpdC9xZW11L2xvZy8/aD1jcHVocC9kZXZlbCAgICAKPgo+IEplYW4tUGhpbGlwcGUgQnJ1Y2tl
ciAoNSk6Cj4gICBLVk06IGFybTY0OiBSZXBsYWNlIHBvd2VyX29mZiB3aXRoIG1wX3N0YXRlIGlu
IHN0cnVjdCBrdm1fdmNwdV9hcmNoCj4gICBLVk06IGFybTY0OiBNb3ZlIFdGSSBleGVjdXRpb24g
dG8gY2hlY2tfdmNwdV9yZXF1ZXN0cygpCj4gICBLVk06IGFybTY0OiBBbGxvdyB1c2Vyc3BhY2Ug
dG8gcmVxdWVzdCBXRkkKPiAgIEtWTTogYXJtNjQ6IFBhc3MgaHlwZXJjYWxscyB0byB1c2Vyc3Bh
Y2UKPiAgIEtWTTogYXJtNjQ6IFBhc3MgUFNDSSBjYWxscyB0byB1c2Vyc3BhY2UKPgo+ICBEb2N1
bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgICAgICB8IDQ2ICsrKysrKysrKysrKysrKy0tLS0K
PiAgRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcm0vcHNjaS5yc3QgfCAgMSArCj4gIGFyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCAgIHwgMTAgKysrLQo+ICBpbmNsdWRlL2t2bS9hcm1f
aHlwZXJjYWxscy5oICAgICAgICB8ICAxICsKPiAgaW5jbHVkZS9rdm0vYXJtX3BzY2kuaCAgICAg
ICAgICAgICAgfCAgNCArKwo+ICBpbmNsdWRlL3VhcGkvbGludXgva3ZtLmggICAgICAgICAgICB8
ICAzICsrCj4gIGFyY2gvYXJtNjQva3ZtL2FybS5jICAgICAgICAgICAgICAgIHwgNzEgKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0KPiAgYXJjaC9hcm02NC9rdm0vaGFuZGxlX2V4aXQuYyAg
ICAgICAgfCAgMyArLQo+ICBhcmNoL2FybTY0L2t2bS9oeXBlcmNhbGxzLmMgICAgICAgICB8IDI4
ICsrKysrKysrKysrLQo+ICBhcmNoL2FybTY0L2t2bS9wc2NpLmMgICAgICAgICAgICAgICB8IDY5
ICsrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0KPiAgMTAgZmlsZXMgY2hhbmdlZCwgMTcwIGlu
c2VydGlvbnMoKyksIDY2IGRlbGV0aW9ucygtKQo+Cl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
