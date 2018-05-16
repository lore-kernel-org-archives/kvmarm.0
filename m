From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: use vnc in arm-kvm
Date: Wed, 16 May 2018 10:12:18 +0100
Message-ID: <493cf6d2-8804-1ffb-06a9-617188c44677@arm.com>
References: <AHwADAAHAYrOX6gNq*WMHKrQ.1.1526437495977.Hmail.lizhuoyao@hikdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C311D40196
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 05:02:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E6pchRINiENk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 05:02:12 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B94B4A0E3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 05:02:01 -0400 (EDT)
In-Reply-To: <AHwADAAHAYrOX6gNq*WMHKrQ.1.1526437495977.Hmail.lizhuoyao@hikdata.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lizhuoyao <lizhuoyao@hikdata.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gMTYvMDUvMTggMDM6MjQsIGxpemh1b3lhbyB3cm90ZToKPiBoaSBldmVyeW9uZToKPiDCoCBj
dXJyZW50bHksIEkgbWVldCBhIHByb2JsZW0gYWJvdXQgcWVtdS5Vc2UgdmlydC1pbnN0YWxsIG9y
ZGVyIHRvCj4gY3JlYXRlIGEgZG9tYWluLCByZXR1cm4gYSBmYWlsZWQ6Cj4gwqAgb3JkZXI6X3Zp
cnQtaW5zdGFsbCAtbiBjZW50b3MtZ2cgLXIgMTAyNCAtLWRpc2sKPiBjZW50b3MtZ2cuaW1nLGZv
cm1hdD1xY293MixzaXplPTEwIC0tY2Ryb20KPiAvaG9tZS9DZW50b3MtNy1hYXJjaDY0LUV2ZXJ5
dGhpbmcuaXNvIC0tZ3JhcGhpY3Mgdm5jLCBsaXN0ZW49MC4wLjAuMAo+IF/CoMKgIGZhaWxlZDpf
dGhpcyBRRU1VIGRvZXMgbm90IHN1cHBvcnQgJ2NpcnJ1cycgdmlkZW8gZGV2aWNlX18KPiBfwqDC
oCBUaGlzIGlzc3VlIG9ubHkgaGFwcGVuIGluIGFybSxhbmQgaXQncyBvayBpbiB4ODYuIEkgZ2V0
IHNvbWUgbWVzc2FnZQo+IGluIHRoZSBpbnRlcm5ldCB0aGF0IFZHQSBpcyBhIChtb3JlIG9yIGxl
c3MpIHg4Ni1zcGVjaWZpYyBzdGFuZGFyZCwgbm90Cj4gYXZhaWxhYmxlIG9uIEFSTS4gUmlnaHQ/
Cj4gdG9vbDogcWVtdS0yLjEyLjAgbGlidmlydC0zLjIuMF9fCgpWR0EsIG9yIHJhdGhlciB0aGUg
d2F5IGl0IGlzIHVzZWQgaW4gdGhlIExpbnV4IGtlcm5lbCBjYW5ub3QgYmUKcmVhbGlzdGljYWxs
eSBzdXBwb3J0ZWQgb24gQVJNIGF0IHRoZSBtb21lbnQuIEJ1dCBpZiB5b3Ugd2FudCBhCmdyYXBo
aWNhbCBkaXNwbGF5LCB3aHkgbm90IHVzaW5nIHZpcnRpby1ncHU/CgpJdCB3b3JrcyB3ZWxsIGVu
b3VnaCBmb3IgbWUsIGFsdGhvdWdoIEkgZG8gbm90IHVzZSBsaWJ2aXJ0LCBhbmQgc3RpY2sKdG8g
anVzdCBxZW11LiBGb3IgdGhlIHJlY29yZCwgdGhpcyBpcyB0aGUgcmVsZXZhbnQgc2VjdGlvbiBv
ZiBteSBjb21tYW5kCmxpbmU6CgotZGV2aWNlIHZpcnRpby1ncHUtcGNpIC1kaXNwbGF5IHNkbCAt
ZGV2aWNlIHZpcnRpby10YWJsZXQtcGNpIC1kZXZpY2UKdXNiLWVoY2ksaWQ9ZWhjaSAtZGV2aWNl
IHVzYi1rYmQKCkkndmUganVzdCBjaGVja2VkIHdpdGggVk5DOgoKLWRldmljZSB2aXJ0aW8tZ3B1
LXBjaSAtZGlzcGxheSB2bmM9MTI3LjAuMC4xOjAsdG89MTAwIC1kZXZpY2UKdmlydGlvLXRhYmxl
dC1wY2kgLWRldmljZSB1c2ItZWhjaSxpZD1laGNpIC1kZXZpY2UgdXNiLWtiZAoKYW5kIGFsdGhv
dWdoIGl0IGlzIG11Y2ggc2xvd2VyIChub3Qgc3VycHJpc2luZyksIGl0IHNlZW1zIHRvIHdvcmsg
anVzdAphcyB3ZWxsLgoKSG9wZSB0aGlzIGhlbHBzLAoKCU0uCi0tIApKYXp6IGlzIG5vdCBkZWFk
LiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
