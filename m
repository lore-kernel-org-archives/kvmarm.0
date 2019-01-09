From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvmarm:kvm-arm64/nv-wip-v5.0-rc1 4/75]
 arch/arm/kvm/../../../virt/kvm/arm/arch_timer.c:700:7: error:
 'SYS_CNTP_TVAL_EL0' undeclared
Date: Wed, 9 Jan 2019 10:43:42 +0000
Message-ID: <20190109104342.7c8ead84@donnerap.cambridge.arm.com>
References: <201901091219.igdmvhpC%fengguang.wu@intel.com>
 <a82a7868-f3c0-0b3e-d0b7-182992c268fa@arm.com>
 <8fd0977c-9ca1-8ad8-a6b7-e36e115745b8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E28FF4A459
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 05:43:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z+7CE4R8Nkdm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jan 2019 05:43:49 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 830304A455
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 05:43:49 -0500 (EST)
In-Reply-To: <8fd0977c-9ca1-8ad8-a6b7-e36e115745b8@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gV2VkLCA5IEphbiAyMDE5IDEwOjA5OjUxICswMDAwCk1hcmMgWnluZ2llciA8bWFyYy56eW5n
aWVyQGFybS5jb20+IHdyb3RlOgoKPiBPbiAwOS8wMS8yMDE5IDA5OjEzLCBBbmRyw6kgUHJ6eXdh
cmEgd3JvdGU6Cj4gPiBPbiAwOS8wMS8yMDE5IDA0OjQwLCBrYnVpbGQgdGVzdCByb2JvdCB3cm90
ZToKPiA+IAo+ID4gTWFyYywgQ2hyaXN0b2ZmZXIsCj4gPiAgIAo+ID4+IHRyZWU6Cj4gPj4gaHR0
cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQva3ZtYXJtL2t2bWFy
bS5naXQKPiA+PiBrdm0tYXJtNjQvbnYtd2lwLXY1LjAtcmMxIGhlYWQ6Cj4gPj4gNjg4YzM4NmNh
MDk2ZjJjMWYyZWVlMzg2Njk3NTg2Yzg4ZGY1ZDViYyBjb21taXQ6Cj4gPj4gMmIxMjY1YzU4YTg3
M2Q5MTdlOTlhYzc2MmUyNDNjMTI3NDQ4MWRiZiBbNC83NV0gS1ZNOiBhcm0vYXJtNjQ6Cj4gPj4g
Y29uc29saWRhdGUgYXJjaCB0aW1lciB0cmFwIGhhbmRsZXJzIGNvbmZpZzogYXJtLWF4bTU1eHhf
ZGVmY29uZmlnCj4gPj4gKGF0dGFjaGVkIGFzIC5jb25maWcpIGNvbXBpbGVyOiBhcm0tbGludXgt
Z251ZWFiaS1nY2MgKERlYmlhbgo+ID4+IDcuMi4wLTExKSA3LjIuMCByZXByb2R1Y2U6IHdnZXQK
PiA+PiBodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vaW50ZWwvbGtwLXRlc3RzL21h
c3Rlci9zYmluL21ha2UuY3Jvc3MKPiA+PiAtTyB+L2Jpbi9tYWtlLmNyb3NzIGNobW9kICt4IH4v
YmluL21ha2UuY3Jvc3MgZ2l0IGNoZWNrb3V0Cj4gPj4gMmIxMjY1YzU4YTg3M2Q5MTdlOTlhYzc2
MmUyNDNjMTI3NDQ4MWRiZiAjIHNhdmUgdGhlCj4gPj4gYXR0YWNoZWQgLmNvbmZpZyB0byBsaW51
eCBidWlsZCB0cmVlIEdDQ19WRVJTSU9OPTcuMi4wIG1ha2UuY3Jvc3MKPiA+PiBBUkNIPWFybSAK
PiA+Pgo+ID4+IEFsbCBlcnJvcnMgKG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+KTogIAo+ID4gCj4g
PiBJIHdhcyBsb29raW5nIGF0IHRoaXMgeWVzdGVyZGF5OiBJdCdzIGEgYml0IG5hc3R5LCBkb24n
dCBrbm93IGEgZ29vZAo+ID4gc29sdXRpb24gYmVzaWRlIGJyaW5naW5nIGJhY2sgdGhpcyBwYXJ0
IG9mIG15IG9yaWdpbmFsIHRpbWVyIHJld29yawo+ID4gc2VyaWVzLiBUaGUgcHJvYmxlbSBpcyB0
aGF0IHRob3NlIHN5bWJvbHMgY29udGFpbnMgdGhlIEFhcmNoNjQKPiA+IHNwZWNpZmljIChpbnN0
cnVjdGlvbikgZW5jb2Rpbmcgb2YgdGhlIHRpbWVyIHJlZ2lzdGVycywgcGx1cyB3ZQo+ID4gbmVl
ZCB0aGUgQUFyY2gzMiBlbmNvZGluZ3MgZm9yIDMyLW9uLTY0IGd1ZXN0cy4gIAo+IAo+IFdoeT8g
VGhlcmUgaXMgZXhhY3RseSBvbmUgdGltZXIgdGhhdCBuZWVkcyB0cmFwcGluZyBmb3IgQUFyY2gz
MiAodGhlCj4gRUwxIHBoeXNpY2FsIHRpbWVyKS4gQWxsIHdlIG5lZWQgaXM6Cj4gCj4gLSB0aGUg
U1lTX0FBUkNIMzJfQ05UUF8qIGVuY29kaW5ncyBvbiAzMmJpdAo+IC0gc29tZSBDUFAgbWFnaWMg
dG8gcHJldmVudCB0aGUgY29tcGlsYXRpb24gZnJvbSBicmVha2luZwoKRmFpciBlbm91Z2gsIGlm
IHlvdSBhcmUgT0sgd2l0aCB0aGlzLiBJIGhhZCBzb21ldGhpbmcgbGlrZSB0aGlzIGJlZm9yZSwK
YnV0IGl0IGxvb2tlZCBraW5kIG9mIGhhY2tpc2ggdG8gbWUsIHNvIEkgd2FzIGxvb2tpbmcgYXQg
c29tZSBwcm9wZXIoVE0pCnNvbHV0aW9uLgoKPiA+IAo+ID4gVGhhdCdzIHdoeSBJIHVzZWQgdGhl
IGdlbmVyaWMgVUFQSSBlbmNvZGluZyBmb3IgdGhlIHJlZ2lzdGVycywKPiA+IGJlY2F1c2Ugd2Ug
b25seSBuZWVkICpzb21lKiBpZGVudGlmaWNhdGlvbiBmb3IgdGhlbSwgaXQgZG9lc24ndAo+ID4g
bmVlZCB0byBiZSBzb21ldGhpbmcgZGVmaW5lZCBieSB0aGUgYXJjaGl0ZWN0dXJlLiAgCj4gCj4g
SSBkaXNhZ3JlZS4gQnkgZG9pbmcgc28sIHlvdSdyZSBjb25mbGF0aW5nIHVzZXJzcGFjZSBhY2Nl
c3MgYW5kCj4gdHJhcHBpbmcsIHdoaWNoIGhhcyBwcm92ZWQgdG8gYmUgYSBiYWQgaWRlYSBpbiB0
aGUgcGFzdC4gRm9yIGV4YW1wbGUsCj4geW91J2QgZW5kLXVwIGhhdmluZyBib3RoIENWQUwgYW5k
IFRWQUwgaW4gVUFQSSwgd2hpY2ggaXMgbm90IHNvbWV0aGluZwo+IEknbSBrZWVuIHRvIGhhdmUu
IE9uIHRoZSBvdGhlciBoYW5kLCB0aGUgdHJhcHBpbmcgZnVuY3Rpb24gZG8gbmVlZCB0bwo+IGJl
IGFibGUgdG8gaGFuZGxlIHRoZXNlLgoKRmFpciBlbm91Z2gsIEkgd2FzIGp1c3QgKmhvcGluZyog
d2UgY2FuIGtlZXAgYXJjaF90aW1lci5jIGNsZWFuIG9mIGFyY2gKc3BlY2lmaWMgZW5jb2Rpbmdz
LiBJIGNhbiB1bmRlcnN0YW5kIHRoYXQgd2l0aCBhbGwgdGhlIGFkZGVkCmNvbXBsZXhpdHkgb2Yg
dGhlIG5lc3RlZCB0aW1lcnMgdGhpcyBpcyBwcm9iYWJseSBub3QgZmVhc2libGUgYW55bW9yZS4K
CkNoZWVycywKQW5kcmUuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
