From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH v3 0/7] Add virtio-iommu driver
Date: Tue, 16 Oct 2018 19:44:09 +0100
Message-ID: <b2f929c3-b0df-acdc-c5e8-0d7ddf7ed964@arm.com>
References: <20181012145917.6840-1-jean-philippe.brucker@arm.com>
 <7874471b-3711-ca44-d220-5e756ac7db8c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 718B249E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Oct 2018 14:44:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6eOxaQPBIuAM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Oct 2018 14:44:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F355E40493
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Oct 2018 14:44:26 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <7874471b-3711-ca44-d220-5e756ac7db8c@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Cc: "kevin.tian@intel.com" <kevin.tian@intel.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "mst@redhat.com" <mst@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, Will Deacon <Will.Deacon@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Robin Murphy <Robin.Murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>
List-Id: kvmarm@lists.cs.columbia.edu

T24gMTYvMTAvMjAxOCAxMDoyNSwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBKZWFuLAo+IAo+IE9u
IDEwLzEyLzE4IDQ6NTkgUE0sIEplYW4tUGhpbGlwcGUgQnJ1Y2tlciB3cm90ZToKPj4gSW1wbGVt
ZW50IHRoZSB2aXJ0aW8taW9tbXUgZHJpdmVyLCBmb2xsb3dpbmcgc3BlY2lmaWNhdGlvbiB2MC44
IFsxXS4KPj4gQ2hhbmdlcyBzaW5jZSB2MiBbMl06Cj4+IAo+PiAqIFBhdGNoZXMgMi00IGFsbG93
IHZpcnRpby1pb21tdSB0byB1c2UgdGhlIFBDSSB0cmFuc3BvcnQsIHNpbmNlIFFFTVUKPj7CoMKg
IHdvdWxkIGxpa2UgdG8gcGhhc2Ugb3V0IHRoZSBNTUlPIHRyYW5zcG9ydC4gVGhpcyBwcm9kdWNl
cyBhIGNvbXBsZXgKPj7CoMKgIHRvcG9sb2d5IHdoZXJlIHRoZSBwcm9ncmFtbWluZyBpbnRlcmZh
Y2Ugb2YgdGhlIElPTU1VIGNvdWxkIGFwcGVhcgo+PsKgwqAgbG93ZXIgdGhhbiB0aGUgZW5kcG9p
bnRzIHRoYXQgaXQgdHJhbnNsYXRlcy4gSXQncyBub3QgdW5oZWFyZCBvZiAoZS5nLgo+PsKgwqAg
QU1EIElPTU1VKSwgYW5kIHRoZSBndWVzdCBlYXNpbHkgY29wZXMgd2l0aCB0aGlzLgo+PsKgwqAg
Cj4+wqDCoCBUaGUgIkZpcm13YXJlIGRlc2NyaXB0aW9uIiBzZWN0aW9uIG9mIHRoZSBzcGVjaWZp
Y2F0aW9uIGhhcyBiZWVuCj4+wqDCoCB1cGRhdGVkIHdpdGggYWxsIGNvbWJpbmF0aW9ucyBvZiBQ
Q0ksIE1NSU8gYW5kIERULCBBQ1BJLgo+IAo+IEkgaGF2ZSBhIHF1ZXN0aW9uIHdydCB0aGUgRlcg
c3BlY2lmaWNhdGlvbi4gVGhlIElPTU1VIGNvbnN1bWVzIDEgc2xvdCBpbgo+IHRoZSBQQ0kgZG9t
YWluIGFuZCBvbmUgbmVlZHMgdG8gbGVhdmUgYSBSSUQgaG9sZSBpbiB0aGUgaW9tbXUtbWFwLsKg
IEl0Cj4gaXMgbm90IG9idmlvdXMgdG8gbWUgdGhhdCB0aGlzIFJJRCBhbHdheXMgaXMgcHJlZGlj
dGFibGUgZ2l2ZW4gdGhlIHBjaWUKPiBlbnVtZXJhdGlvbiBtZWNoYW5pc20uIEdlbmVyYWxseSB3
ZSBoYXZlIGEgY29hcnNlIGdyYWluIG1hcHBpbmcgb2YgUklECj4gb250byBpb21tdSBwaGFuZGxl
cy9TVFJFQU1JRHMuIEhlcmUsIGlmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHkgd2UgbmVlZAo+IHRv
IHByZWNpc2VseSBpZGVudGlmeSB0aGUgUklEIGdyYW50ZWQgdG8gdGhlIGlvbW11LiBPbiBRRU1V
IHRoaXMgbWF5Cj4gZGVwZW5kIG9uIHRoZSBpbnN0YW50aWF0aW9uIG9yZGVyIG9mIHRoZSB2aXJ0
aW8tcGNpIGRldmljZSByaWdodD8KClllcywgYWx0aG91Z2ggaXQgc2hvdWxkIGFsbCBoYXBwZW4g
YmVmb3JlIHlvdSBib290IHRoZSBndWVzdCwgc2luY2UKdGhlcmUgaXMgbm8gaG90cGx1Z2dpbmcg
YW4gSU9NTVUuIENvdWxkIHlvdSByZXNlcnZlIGEgUENJIHNsb3QgdXBmcm9udAphbmQgdXNlIGl0
IGZvciB2aXJ0aW8taW9tbXUgbGF0ZXI/IE9yIGdlbmVyYXRlIHRoZSBpb21tdS1tYXAgYXQgdGhl
IHNhbWUKdGltZSBhcyBnZW5lcmF0aW5nIHRoZSBjaGlsZCBub2RlIG9mIHRoZSBQQ0kgUkM/Cgo+
IFNvCj4gdGhpcyBkb2VzIG5vdCBsb29rIHRyaXZpYWwgdG8gYnVpbGQgdGhpcyBpbmZvLiBJc24n
dCBpdCBwb3NzaWJsZSB0byBkbwo+IHRoaXMgZXhjbHVzaW9uIGF0IGtlcm5lbCBsZXZlbCBpbnN0
ZWFkPwoKU28gaW4gdGhlb3J5IFZJUlRJT19GX0lPTU1VX1BMQVRGT1JNIGFscmVhZHkgZG9lcyB0
aGF0OgoKVklSVElPX0ZfSU9NTVVfUExBVEZPUk0oMzMpCiAgICBUaGlzIGZlYXR1cmUgaW5kaWNh
dGVzIHRoYXQgdGhlIGRldmljZSBpcyBiZWhpbmQgYW4gSU9NTVUgdGhhdAogICAgdHJhbnNsYXRl
cyBidXMgYWRkcmVzc2VzIGZyb20gdGhlIGRldmljZSBpbnRvIHBoeXNpY2FsIGFkZHJlc3NlcyBp
bgogICAgbWVtb3J5LiBJZiB0aGlzIGZlYXR1cmUgYml0IGlzIHNldCB0byAwLCB0aGVuIHRoZSBk
ZXZpY2UgZW1pdHMKICAgIHBoeXNpY2FsIGFkZHJlc3NlcyB3aGljaCBhcmUgbm90IHRyYW5zbGF0
ZWQgZnVydGhlciwgZXZlbiB0aG91Z2ggYW4KICAgIElPTU1VIG1heSBiZSBwcmVzZW50LgoKRm9y
IGJldHRlciBvciBmb3Igd29yc2UsIHRoZSBndWVzdCBoYXMgdG8gaW1wbGVtZW50IGl0LiBJZiB0
aGlzIGZlYXR1cmUKYml0IGlzIHVuc2V0IGZvciB2aXJ0aW8taW9tbXUsIGl0IGRvZXMgRE1BIG9u
IHRoZSBwaHlzaWNhbCBhZGRyZXNzCnNwYWNlLCByZWdhcmRsZXNzIG9mIHdoYXQgdGhlIHN0YXRp
YyB0b3BvbG9neSBkZXNjcmlwdGlvbiBzYXlzLgoKSW4gcHJhY3RpY2UgaXQgZG9lc24ndCBxdWl0
ZSB3b3JrLiBJZiB5b3VyIGlvbW11LW1hcCBkZXNjcmliZXMgdGhlIElPTU1VCmFzIHRyYW5zbGF0
aW5nIGl0c2VsZiwgTGludXgnIE9GIGNvZGUgd2lsbCB3YWl0IGZvciB0aGUgSU9NTVUgdG8gYmUK
cHJvYmVkIGJlZm9yZSBwcm9iaW5nIHRoZSBJT01NVS4gV29ya2luZyBhcm91bmQgdGhpcyB3aXRo
IGhhY2tzIGlzCnBvc3NpYmxlLCBidXQgSSBkb24ndCB3YW50IHRvIGludHJvZHVjZSBtb3JlIHF1
ZXN0aW9uYWJsZSBjb2RlIHRvIE9GIGFuZApkZXZpY2UgdHJlZSBiaW5kaW5ncyBpZiB0aGVyZSBp
cyBhbnkgb3RoZXIgd2F5LgoKVGhhbmtzLApKZWFuCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
