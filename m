From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] ARM/ARM64: KVM: Implement KVM_FLUSH_DCACHE_GPA ioctl
Date: Thu, 07 May 2015 19:01:36 +0200
Message-ID: <554B9A70.6020309@redhat.com>
References: <1430817191-6231-1-git-send-email-j.fanguede@virtualopensystems.com>
 <20150506141249.GA6796@cbox>
 <CAGE1QJrabWWs0O1V-MpOxT_=1472TXb5rvJzJAJNfWH70x9pcg@mail.gmail.com>
 <20150507112027.GC25885@cbox>
 <CAGE1QJoyaGpuf=6Msa=xpm0pPGRkYWctcXGf=rwnha5o9Gm4bw@mail.gmail.com>
 <CAMJs5B9i9q8gJU93B09-uLMF6w1bTft-40DWPFUP6ky=SketSQ@mail.gmail.com>
 <CAGE1QJoEAg9tAM63MEbpLuqvY_ZwGrHPU1sqo=L_iByKrERUow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BB2850CA8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2015 12:52:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UdJB52pVt5sF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2015 12:52:56 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CC4950CA6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2015 12:52:56 -0400 (EDT)
In-Reply-To: <CAGE1QJoEAg9tAM63MEbpLuqvY_ZwGrHPU1sqo=L_iByKrERUow@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?SsOpcsOpbXkgRmFuZ3XDqGRl?= <j.fanguede@virtualopensystems.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: list@lists.cs.columbia.edu, Overall <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, open@lists.cs.columbia.edu, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAwNy8wNS8yMDE1IDE4OjU2LCBKw6lyw6lteSBGYW5ndcOoZGUgd3JvdGU6Cj4gVVNCIGRl
dmljZXMgZmFpbCB3aXRoIGEgdGltZW91dCBlcnJvciwgYXMgaWYgdGhlIGNvbW11bmljYXRpb24g
YmV0d2Vlbgo+IHRoZSBrZXJuZWwgYW5kIHRoZSBkZXZpY2VzIGZhaWwgYXQgYSBjZXJ0YWluIHBv
aW50Ogo+IHVzYiAxLTE6IGRldmljZSBub3QgYWNjZXB0aW5nIGFkZHJlc3MgNSwgZXJyb3IgLTEx
MAo+IHVzYiB1c2IxLXBvcnQxOiB1bmFibGUgdG8gZW51bWVyYXRlIFVTQiBkZXZpY2UKPiAKPiBl
MTAwMCBmYWlscyB3aGVuIHRoZSB1c2Vyc3BhY2UgdHJpZXMgdG8gdXNlIGl0LCB3aXRoIHRoZXNl
IHR5cGUgb2YKPiBrZXJuZWwgbWVzc2FnZXM6Cj4gZTEwMDAgMDAwMDowMDowMi4wIGV0aDA6IERl
dGVjdGVkIFR4IFVuaXQgSGFuZwo+ICAgVHggUXVldWUgICAgICAgICAgICAgPDA+Cj4gICBUREgg
ICAgICAgICAgICAgICAgICA8ZD4KPiAgIFREVCAgICAgICAgICAgICAgICAgIDxkPgo+ICAgbmV4
dF90b191c2UgICAgICAgICAgPGQ+Cj4gICBuZXh0X3RvX2NsZWFuICAgICAgICA8OT4KPiBidWZm
ZXJfaW5mb1tuZXh0X3RvX2NsZWFuXQo+ICAgdGltZV9zdGFtcCAgICAgICAgICAgPGZmZmY5MzEx
Pgo+ICAgbmV4dF90b193YXRjaCAgICAgICAgPGE+Cj4gICBqaWZmaWVzICAgICAgICAgICAgICA8
ZmZmZjk1NmE+Cj4gICBuZXh0X3RvX3dhdGNoLnN0YXR1cyA8MD4KCkNhbiB5b3UgZmluZCBvdXQg
d2hhdCBtZW1vcnkgYXR0cmlidXRlcyB0aGUgZ3Vlc3QgaXMgdXNpbmcgZm9yIHRoZQptZW1vcnkt
LS1hbmQgaWYgaXQncyB1bmNhY2hlZCwgd2h5PwoKUGFvbG8KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
