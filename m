From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Fix user access for debug registers
Date: Wed, 16 Sep 2015 15:35:55 +0100
Message-ID: <87wpvqmnxw.fsf@linaro.org>
References: <1442400070-23316-1-git-send-email-marc.zyngier@arm.com>
 <20150916134141.GA15903@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E0C41450
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2015 10:35:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cEJmMcQXwdfn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2015 10:34:58 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9170F412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2015 10:34:58 -0400 (EDT)
Received: by wiclk2 with SMTP id lk2so74074918wic.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2015 07:35:57 -0700 (PDT)
In-reply-to: <20150916134141.GA15903@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

CkNocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoK
PiBPbiBXZWQsIFNlcCAxNiwgMjAxNSBhdCAxMTo0MToxMEFNICswMTAwLCBNYXJjIFp5bmdpZXIg
d3JvdGU6Cj4+IFdoZW4gc2V0dGluZyB0aGUgZGVidWcgcmVnaXN0ZXIgZnJvbSB1c2Vyc3BhY2Us
IG1ha2Ugc3VyZSB0aGF0Cj4+IGNvcHlfZnJvbV91c2VyKCkgaXMgY2FsbGVkIHdpdGggaXRzIHBh
cmFtZXRlcnMgaW4gdGhlIGV4cGVjdGVkCj4+IG9yZGVyLiBJdCBvdGhlcndpc2UgZG9lc24ndCBk
byB3aGF0IHlvdSB0aGluay4KPj4gCj4+IFJlcG9ydGVkLWJ5OiBQZXRlciBNYXlkZWxsIDxwZXRl
ci5tYXlkZWxsQGxpbmFyby5vcmc+Cj4+IENjOiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxp
bmFyby5vcmc+Cj4+IEZpeGVzOiA4NGU2OTBiZmJlZDEgKCJLVk06IGFybTY0OiBpbnRyb2R1Y2Ug
dmNwdS0+YXJjaC5kZWJ1Z19wdHIiKQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1h
cmMuenluZ2llckBhcm0uY29tPgo+Cj4geWlrZXMhCgpPSyBJJ20gbm93IG11Y2hseSBjb25mdXNl
ZCBhcyB0byBob3cgaXQgY291bGQgaGF2ZSB3b3JrZWQuLi4KCj4KPiBSZXZpZXdlZC1ieTogQ2hy
aXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5hcm8ub3JnPgoKLS0gCkFsZXggQmVu
bsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
