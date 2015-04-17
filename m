From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: ARM: PCI devices emulation broken with KVM due to cache issue
Date: Fri, 17 Apr 2015 16:06:48 +0200
Message-ID: <20150417140648.GJ6186@cbox>
References: <CAGE1QJoXVDP_O0W9dRCsN+FBW3BEYn5gqiCvGh07CfadNp2kHw@mail.gmail.com>
 <552FDD13.4090006@redhat.com> <20150417092910.GI6186@cbox>
 <CAGE1QJo-waQgNyy4XG6Ecqeg3yXH_o4EFuqX+mzj0_66X-ghXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 609494CCD3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 09:58:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gBYAIStglK2P for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2015 09:58:40 -0400 (EDT)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
 [209.85.217.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D041B4CBD2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 09:58:39 -0400 (EDT)
Received: by lbbzk7 with SMTP id zk7so83877268lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 07:06:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAGE1QJo-waQgNyy4XG6Ecqeg3yXH_o4EFuqX+mzj0_66X-ghXQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?iso-8859-1?B?Suly6W15IEZhbmd16GRl?= <j.fanguede@virtualopensystems.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gRnJpLCBBcHIgMTcsIDIwMTUgYXQgMDM6NDg6MzVQTSArMDIwMCwgSsOpcsOpbXkgRmFuZ3XD
qGRlIHdyb3RlOgo+IE9uIEZyaSwgQXByIDE3LCAyMDE1IGF0IDExOjI5IEFNLCBDaHJpc3RvZmZl
ciBEYWxsCj4gPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4gd3JvdGU6Cj4gPiBPbiBUaHUs
IEFwciAxNiwgMjAxNSBhdCAwNjowMjoyN1BNICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
ID4+Cj4gPj4KPiA+PiBPbiAxNi8wNC8yMDE1IDE3OjU0LCBKw6lyw6lteSBGYW5ndcSNZGUgd3Jv
dGU6Cj4gPj4gPiBUaGUgZ3Vlc3Qga2VybmVsIGRyaXZlciBvZiB0aGUgbHNpIGRldmljZSBmYWls
cyB0byBlbmFibGUgaXQgY29ycmVjdGx5Cj4gPj4gPiB3aXRoIGEgY2FjaGUgZXJyb3I6Cj4gPj4g
PiBbLi4uXQo+ID4+ID4gc3ltNTNjOHh4IDAwMDA6MDA6MDEuMDogZW5hYmxpbmcgZGV2aWNlICgw
MTAwIC0+IDAxMDMpCj4gPj4gPiBzeW0wOiA8ODk1YT4gcmV2IDB4MCBhdCBwY2kgMDAwMDowMDow
MS4wIGlycSA1NAo+ID4+ID4gc3ltMDogTm8gTlZSQU0sIElEIDcsIEZhc3QtNDAsIExWRCwgcGFy
aXR5IGNoZWNraW5nCj4gPj4gPiBDQUNIRSBURVNUIEZBSUxFRDogY2hpcCB3cm90ZSAyLCBob3N0
IHJlYWQgMS4KPiA+PiA+IHN5bTA6IENBQ0hFIElOQ09SUkVDVExZIENPTkZJR1VSRUQuCj4gPj4g
PiBzeW0wOiBnaXZpbmcgdXAgLi4uCj4gPj4gPiBbLi4uXQo+ID4+Cj4gPj4gTm90ZSB0aGF0IHRo
aXMgaXMganVzdCBhIGZhaWx1cmUgaW4gdGhlIGRyaXZlciBzZWxmLXRlc3QuICBJdCBoYXMKPiA+
PiBub3RoaW5nIHRvIGRvIHdpdGggdGhlIHByb2Nlc3NvciBjYWNoZSAodGhvdWdoIHRoZXJlIGFy
ZSBvdGhlciBwcm9ibGVtcwo+ID4+IHdpdGggUENJIGFuZCB0aGUgcHJvY2Vzc29yIGNhY2hlIGlu
IEtWTSBtb2RlKS4KPiA+Pgo+ID4+IERvIG5vdCB1c2UgdGhpcyBRRU1VIGRldmljZS4gIFRoZSBl
bXVsYXRpb24gaXMgaW5jb21wbGV0ZSBhbmQgaXQncyBzbG93Lgo+ID4+ICBVc2UgdmlydGlvLXNj
c2kgb3IgbWVnYXNhcyBpbnN0ZWFkLiAgU3RpbGwsIEknbSBub3Qgc3VyZSB0aGF0IHdvdWxkCj4g
Pj4gd29yayB3aXRoIEtWTTsgYXMgZmFyIGFzIEkga25vdywgbW9zdCB3b3JrIG9uIHRoZSBBUk0g
UENJIGhvc3QgYnJpZGdlCj4gPj4gd2FzIGRvbmUgdXNpbmcgVUVGSSBmaXJtd2FyZS4KPiA+Pgo+
ID4gSSd2ZSBiZWVuIHJ1bm5pbmcgYSBudW1iZXIgb2YgdGVzdHMgbGF0ZWx5IHVzaW5nIHZpcnRp
by1uZXQtcGNpIGFuZAo+ID4gdmlydGlvLWJsay1wY2kgb24gWEdlbmUgYXQgaXQgd29ya3MgbGlr
ZSBhIGNoYXJtLgo+IAo+IEl0IHNob3VsZCBiZSBub3RlZCB0aGF0IGFsbCB0aGVzZSBkZXZpY2Vz
IHdvcmsgZmluZSBvbiB4ODYgd2l0aCBLVk0KPiBlbmFibGVkLgo+IAo+IE9mIGNvdXJzZSwgbm90
IGFsbCBQQ0kgZGV2aWNlcyBhcmUgYWZmZWN0ZWQsIGUuZy4gdmlydGlvLSogZGV2aWNlcwo+IHdv
cmsgZmluZSBmb3IgbWUgYWxzby4gSG93ZXZlciwgc2hvdWxkIHRoaXMgZmFpbHVyZSBiZSBjb25z
aWRlcmVkCj4gbm9ybWFsIHdpdGggS1ZNIG9uIEFSTSwgd2hpbGUgaXQgd29ya3Mgb24geDg2Pwo+
IAo+IEZvciBpbnN0YW5jZSwgbGV0J3MgdGFrZSB0aGUgdXNlIGNhc2Ugd2hlcmUgdGhlcmUgaXMg
bm8gdmlydGlvCj4gYWx0ZXJuYXRpdmU6IFVTQiBkZXZpY2VzIChwYXNzdGhyb3VnaCBvciBlbXVs
YXRlZCkgYXR0YWNoZWQgdG8gYSBQQ0kKPiBVU0IgY29udHJvbGxlciwgaG93IGlzIHRoaXMgc3Vw
cG9zZWQgdG8gd29yayB3aXRoIEtWTSBvbiBBUk0/Cj4gVGhlIG9ubHkgd2F5IHRvIG1ha2UgdXNi
LWVoY2kgd29ya2luZyB0aGF0IEkgYW0gYXdhcmUsIGlzCj4gd2l0aCB0aGlzIGNhY2hlIGhhY2su
CgpBcyBQYW9sbyBzYWlkLCB3ZSBrbm93IHRoZXJlIGFyZSBjYWNoZSBpc3N1ZXMgb24gS1ZNL0FS
TSBhbmQgd2UgYXJlCndvcmtpbmcgdGhyb3VnaC4gIFBhdGNoZXMgYXJlIGFzIGFsd2F5cyB3ZWxj
b21lIDspCgotQ2hyaXN0b2ZmZXIKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
