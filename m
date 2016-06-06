From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [kvm-unit-tests PATCH v2 03/10] arm/arm64: smp: support more
 than 8 cpus
Date: Mon, 6 Jun 2016 17:32:38 +0100
Message-ID: <20160606163238.GB23505@leverpostej>
References: <1465064165-14885-4-git-send-email-drjones@redhat.com>
 <8737oqi8x2.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD13341AF6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2016 12:28:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MyjIWmO7mFtQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2016 12:28:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0C70412C2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2016 12:28:48 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <8737oqi8x2.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gTW9uLCBKdW4gMDYsIDIwMTYgYXQgMDU6MjI6NDlQTSArMDEwMCwgQWxleCBCZW5uw6llIHdy
b3RlOgo+IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4gPiArI2Rl
ZmluZSBNUElEUl9MRVZFTF9TSElGVChsZXZlbCkgXAo+ID4gKwkoKCgxIDw8IGxldmVsKSA+PiAx
KSA8PCAzKQo+ID4gKyNkZWZpbmUgTVBJRFJfQUZGSU5JVFlfTEVWRUwobXBpZHIsIGxldmVsKSBc
Cj4gPiArCSgobXBpZHIgPj4gTVBJRFJfTEVWRUxfU0hJRlQobGV2ZWwpKSAmIDB4ZmYpCj4gCj4g
RG9lc24ndCBBZmYzIGJyZWFrIHRoaXMgbGl0dGxlIG1hY3JvPyBJdCBzaXRzIGF0IDMyOjM5IHdp
dGggYSBnYXAgZm9yCj4gTVQsIFJFUzAsIFUsIFJFUzEgZm9yIGJpdHMgMjU6MzEKCkl0IHdvcmtz
LCBpdCdzIGp1c3QgYSBsaXR0bGUgYml0IG1hZ2ljOgoKKGdkYikgcCAoKCgxIDw8IDApID4+IDEp
IDw8IDMpCiQxID0gMAooZ2RiKSBwICgoKDEgPDwgMSkgPj4gMSkgPDwgMykKJDIgPSA4CihnZGIp
IHAgKCgoMSA8PCAyKSA+PiAxKSA8PCAzKQokMyA9IDE2CihnZGIpIHAgKCgoMSA8PCAzKSA+PiAx
KSA8PCAzKQokNCA9IDMyCihnZGIpIAoKV2UgZG8gdGhlIHNhbWUgaW4gYXJjaC9hcm02NC9pbmNs
dWRlL2FzbS9jcHV0eXBlLmggc2luY2UgYjA1ODQ1MGYzOGMzMzdkMQooImFybTY0OiBrZXJuZWw6
IGFkZCBNUElEUl9FTDEgYWNjZXNzb3JzIG1hY3JvcyIpLgoKVGhhbmtzLApNYXJrLgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
