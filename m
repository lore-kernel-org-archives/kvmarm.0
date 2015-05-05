From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: some questions about system calls in KVM/ARM
Date: Tue, 5 May 2015 14:17:53 +0200
Message-ID: <20150505121753.GC19385@cbox>
References: <CAJoe4kjEDbCwBSgSamB7RW+fYYhXO2FfvMB3JDJppV-DZ+jhGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1844F972
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2015 08:09:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XNa9X5xLxwMr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2015 08:09:11 -0400 (EDT)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F7874F804
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2015 08:09:11 -0400 (EDT)
Received: by labbd9 with SMTP id bd9so125845429lab.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2015 05:17:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAJoe4kjEDbCwBSgSamB7RW+fYYhXO2FfvMB3JDJppV-DZ+jhGg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?utf-8?B?5a2Z5pmT6Ziz?= <sxy.winner@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gU3VuLCBNYXkgMDMsIDIwMTUgYXQgMTE6Mzc6MjlBTSArMDgwMCwg5a2Z5pmT6ZizIHdyb3Rl
Ogo+IEhlbGxvLAo+IEkgYW0gaW50ZXJzdGVkIGluIEtWTS9BUk0gYW5kIEkgYW0gdHJ5aW5nIHRv
IGRvIHNvbWUgd29yayBiYXNlZCBvbiBLVk0vQVJNLgo+IEJ1dCBoZXJlIGlzIHNvbWUgcXVlc3Rp
b25zIDoKPiAxLiBpZiBJIHNldCBIQ1IuVEdFPTEsIGRvZXMgdGhlIHN5c3RlbSBjYWxscyB3aWxs
IHRyYXBzIGludG8gaHlwIG1vZGUgYW5kCj4gYmUgaGFuZGxlZCBieSBoeXBfc3ZjKCBhcmNoL2Fy
bS9rdm0vaW50ZXJydXB0cy5TKT8KCm5vLCBoeXBfc3ZjIGlzIG9ubHkgaGFuZGxpbmcgaHlwZXJ2
aXNvciBjYWxscyBmcm9tIGh5cCBtb2RlIGl0c2VsZi4gIEFsbAp0cmFwcyB0byBIeXAgbW9kZSBh
cmUgaGFuZGxlZCBpbiBoeXBfaHZjLiAgU2VlICJVc2Ugb2Ygb2Zmc2V0IDB4MTQgaW4KdGhlIEh5
cCB2ZWN0b3IgdGFibGUiIGluIFNlY3Rpb24gQjEuOC4xIGluIHRoZSBBUk12NyBBUk0gKERESSAw
NDA2Qy5jKS4KCj4gMi4gSG93IGNhbiBJIGdldCBHdWVzdCBPUydzIHN5c3RlbSBjYWxsJ3MgbnVt
YmVyIGFuZCBhZGRyZXNzIHdoaWxlIGlzc3VpbmcKPiBzd2kgaW5zdHJ1Y3Rpb24gaW4gR3Vlc3Qg
T1MgdXNyIG1vZGUgYW5kIHRyYXBwZWQgaW50byBIeXAgbW9kZT8KCllvdSBoYXZlIHRvIGtub3cg
dGhlIEFCSSBvZiB0aGUgZ3Vlc3Qgb3MgYW5kIGRlY29kZSB3aGF0ZXZlcgpyZWdpc3Rlci9pbW1l
ZGlhdGUgdXNlZCBieSB0aGF0LgoKLUNocmlzdG9mZmVyCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
