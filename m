From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH v5 10/11] arm/arm64: gicv3: add an IPI test
Date: Fri, 11 Nov 2016 09:21:20 +0000
Message-ID: <4d1964d4-6540-3df6-8193-6dac3efa7d5c@arm.com>
References: <1478798481-25030-1-git-send-email-drjones@redhat.com>
 <1478798481-25030-11-git-send-email-drjones@redhat.com>
 <874m3f8621.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E11094042C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 04:20:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kha4Bwge6XK6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2016 04:20:22 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFF1440419
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2016 04:20:22 -0500 (EST)
In-Reply-To: <874m3f8621.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

SGksCgpPbiAxMC8xMS8xNiAxOTo1MywgQWxleCBCZW5uw6llIHdyb3RlOgoKLi4uLgo+IFNvIEkg
d2FzIHJlLWJhc2luZyBteSBrdm0tdW5pdC10ZXN0cyBhZ2FpbnN0IHlvdXIgR0lDIHJld29yayBh
bmQgZm91bmQKPiBteXNlbGYgY29weSBhbmQgcGFzdGluZyBhIGJ1bmNoIG9mIHRoaXMgaW50byBt
eSB0ZXN0cyB0aGF0IGZpcmUgSVJRcy4KClNvIEkgdGFrZSBpdCB5b3UgYXJlIHdvcmtpbmcgb24g
KG9yIGFscmVhZHkgaGF2ZSkgY29kZSB0byB0ZXN0IFNQSXMsCnByb2JhYmx5IHZpYSBHSUNEX0lT
UEVORFI/Ckp1c3QgYXNraW5nIGJlY2F1c2UgSSB3YXMgdGhpbmtpbmcgYWJvdXQgZ29pbmcgdGhl
cmUgYW5kIHRodXMgY291bGQgc2F2ZQpteSB0aW1lIGlmIHlvdSBhcmUgb24gaXQgYWxyZWFkeS4u
LgoKPiBUaGF0IG1ha2VzIG1lIHRoaW5rIHRoZSBhYnN0cmFjdGlvbiBzaG91bGQgYmUgaW4gdGhl
IGxpYnJhcnkgY29kZSBzbwo+IG90aGVyIHRlc3RzIGNhbiBmaWRkbGUgd2l0aCBzZW5kaW5nIElS
UXMuCgouLi5iZWNhdXNlIEkgd2FzIHdvbmRlcmluZyB0aGUgc2FtZS4KCkNoZWVycywKQW5kcmUu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
