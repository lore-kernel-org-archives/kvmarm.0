From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 09/22] vfio: VFIO_IOMMU_BIND/UNBIND_MSI
Date: Wed, 10 Apr 2019 14:15:41 +0100
Message-ID: <73e3c98a-2a2c-83ad-1bbb-7f7368cce274@arm.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
 <20190317172232.1068-10-eric.auger@redhat.com>
 <20190321170159.38358f38@x1.home>
 <16931d58-9c88-8cfb-a392-408ea7afdf16@redhat.com>
 <20190322160947.3f8dacdb@x1.home>
 <b47128de-88d0-1971-1fbc-86e43439c7ee@redhat.com>
 <20190403113800.51503693@x1.home>
 <4b27b707-4917-2c3e-a13c-3b978e850d09@redhat.com>
 <20190410123531.GA19023@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9523B4A445
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 09:15:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b0mTCyRrWsvw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 09:15:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 202E44A380
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 09:15:48 -0400 (EDT)
In-Reply-To: <20190410123531.GA19023@debian>
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
To: =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@arm.com>, Auger Eric <eric.auger@redhat.com>
Cc: yi.l.liu@linux.intel.com, kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com, kvm@vger.kernel.org, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, Alex Williamson <alex.williamson@redhat.com>, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

SGkgVmluY2VudCwKCk9uIDEwLzA0LzIwMTkgMTM6MzUsIFZpbmNlbnQgU3RlaGzDqSB3cm90ZToK
PiBPbiBUaHUsIEFwciAwNCwgMjAxOSBhdCAwODo1NToyNUFNICswMjAwLCBBdWdlciBFcmljIHdy
b3RlOgo+PiBIaSBNYXJjLCBSb2JpbiwgQWxleCwKPiAoLi4pCj4+IERvIHlvdSB0aGluayB0aGlz
IGlzIGEgcmVhc29uYWJsZSBhc3N1bXB0aW9uIHRvIGNvbnNpZGVyIGRldmljZXMgd2l0aGluCj4+
IHRoZSBzYW1lIGhvc3QgaW9tbXUgZ3JvdXAgc2hhcmUgdGhlIHNhbWUgTVNJIGRvb3JiZWxsPwo+
IAo+IEhpIEVyaWMsCj4gCj4gSSBhbSBub3Qgc3VyZSB0aGlzIGFzc3VtcHRpb24gYWx3YXlzIGhv
bGQuCj4gCj4gTWFyYywgUm9iaW4gYW5kIEFsZXggY2FuIGNvcnJlY3QgbWUsIGJ1dCBmb3IgZXhh
bXBsZSBJIHRoaW5rIHRoZSBmb2xsb3dpbmcKPiB0b3BvbG9neSBpcyB2YWxpZCBmb3IgQXJtIHN5
c3RlbXM6Cj4gCj4gICstLS0tLS0tLS0tLS0rICArLS0tLS0tLS0tLS0tKwo+ICB8IEVuZHBvaW50
IEEgfCAgfCBFbmRwb2ludCBCIHwKPiAgKy0tLS0tLS0tLS0tLSsgICstLS0tLS0tLS0tLS0rCj4g
ICAgICAgICAgICAgdiAgICAgdgo+ICAgICAgICAgICAvLS0tLS0tLS0tXAo+ICAgICAgICAgIHwg
IE5vbi1BQ1MgIHwKPiAgICAgICAgICB8ICBTd2l0Y2ggICB8Cj4gICAgICAgICAgIFwtLS0tLS0t
LS0vCj4gICAgICAgICAgICAgICAgdgo+ICAgICAgICArLS0tLS0tLS0tLS0tLS0tKwo+ICAgICAg
ICB8ICAgICBQQ0llICAgICAgfAo+ICAgICAgICB8IFJvb3QgQ29tcGxleCAgfAo+ICAgICAgICAr
LS0tLS0tLS0tLS0tLS0tKwo+ICAgICAgICAgICAgICAgIHYKPiAgICAgICAgICArLS0tLS0tLS0t
LS0rCj4gICAgICAgICAgfCAgIFNNTVUgICAgfAo+ICAgICAgICAgICstLS0tLS0tLS0tLSsKPiAg
ICAgICAgICAgICAgICB2Cj4gICArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rCj4gICB8ICAg
U3lzdGVtIGludGVyY29ubmVjdCAgICB8Cj4gICArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0r
Cj4gICAgICAgICB2ICAgICAgICAgICAgICB2Cj4gICArLS0tLS0tLS0tLS0rICArLS0tLS0tLS0t
LS0rCj4gICB8ICAgSVRTIEEgICB8ICB8ICAgSVRTIEIgICB8Cj4gICArLS0tLS0tLS0tLS0rICAr
LS0tLS0tLS0tLS0rCj4gCj4gQWxsIFBDSWUgRW5kcG9pbnRzIGFuZCBJVFMgY291bGQgYmUgaW4g
dGhlIHNhbWUgSVRTIEdyb3VwIDAsIG1lYW5pbmcKPiBkZXZpY2VzIGNvdWxkIHNlbmQgdGhlaXIg
TVNJIGF0IGFueSBJVFMgaW4gaGFyZHdhcmUuCj4gCj4gRm9yIExpbnV4IHRoZSB0d28gUENJZSBF
bmRwb2ludHMgd291bGQgYmUgaW4gdGhlIHNhbWUgaW9tbXUgZ3JvdXAsIGJlY2F1c2UKPiB0aGUg
c3dpdGNoIGluIHRoaXMgZXhhbXBsZSBkb2VzIG5vdCBzdXBwb3J0IEFDUy4KPiAKPiBJIHRoaW5r
IHRoZSBkZXZpY2V0cmVlIG1zaS1tYXAgcHJvcGVydHkgY291bGQgYmUgdXNlZCB0byAibWFwIiB0
aGUgUklEIG9mCj4gRW5kcG9pbnQgQSB0byBJVFMgQSBhbmQgdGhlIFJJRCBvZiBFbmRwb2ludCBC
IHRvIElUUyBCLCB3aGljaCB3b3VsZCB2aW9sYXRlCj4gdGhlIGFzc3VtcHRpb24uCj4gCj4gU2Vl
IHRoZSBtb25vbGl0aGljIGV4YW1wbGUgaW4gWzFdLCB0aGUgZXhhbXBsZSBzeXN0ZW0gaW4gWzJd
LCBhcHBlbmRpY2VzCj4gRCwgRSBhbmQgRiBpbiBbM10gYW5kIHRoZSBtc2ktbWFwIHByb3BlcnR5
IGluIFs0XS4KCkkgdGhpbmsgd2UgYXJlIGFsbCBpbiBhZ3JlZW1lbnQgdGhhdCB0aGlzIGlzIGEg
cG9zc2libGUgdG9wb2xvZ3kuIEl0IGlzCmp1c3QgdGhhdCBpdCBkb2Vzbid0IGV4aXN0IGluIGFu
eSByZWFsLWxpZmUgaW1wbGVtZW50YXRpb24gd2Uga25vdyBvZgoodGhlIElUUyB0ZW5kcyB0byBi
ZSBjbG9zZSB0byB0aGUgUkMgYW5kIG5vdCBkb3duc3RyZWFtIG9mIHRoZQppbnRlcmNvbm5lY3Qp
LgoKR2l2ZW4gdGhlIGNvbXBsZXhpdHkgb2Ygd2hhdCB3ZSdyZSB0cnlpbmcgdG8gcHV0IHRvZ2V0
aGVyLCBJJ2QgcmF0aGVyCnN0YXJ0IHdpdGggYSBzbWFsbCBzdGVwIHdoaWNoIHN1cHBvcnRzIGNv
bW1vbmx5IGltcGxlbWVudGVkIHRvcG9sb2d5LAphbmQgbGF0ZXIgYWRkcmVzcyB0aGUgb2RkIG9u
ZXMgaWYgdGhleSBhY3R1YWxseSBjcm9wIHVwLgoKVGhhbmtzLAoKCU0uCi0tIApKYXp6IGlzIG5v
dCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
