From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/2] kvm/arm: skip MMIO insn after emulation
Date: Fri,  9 Nov 2018 15:07:10 +0000
Message-ID: <20181109150711.45864-2-mark.rutland@arm.com>
References: <20181109150711.45864-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85F5E4A351
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Nov 2018 10:07:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WLl74MCOo-yq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Nov 2018 10:07:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 334184A353
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Nov 2018 10:07:23 -0500 (EST)
In-Reply-To: <20181109150711.45864-1-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

V2hlbiB3ZSBlbXVsYXRlIGFuIE1NSU8gaW5zdHJ1Y3Rpb24sIHdlIGFkdmFuY2UgdGhlIENQVSBz
dGF0ZSB3aXRoaW4KZGVjb2RlX2hzcigpLCBiZWZvcmUgZW11bGF0aW5nIHRoZSBpbnN0cnVjdGlv
biBlZmZlY3RzLgoKSGF2aW5nIHRoaXMgbG9naWMgaW4gZGVjb2RlX2hzcigpIGlzIG9wYXF1ZSwg
YW5kIGFkdmFuY2luZyB0aGUgc3RhdGUKYmVmb3JlIGVtdWxhdGlvbiBpcyBwcm9ibGVtYXRpYy4g
SXQgZ2V0cyBpbiB0aGUgd2F5IG9mIGFwcGx5aW5nCmNvbnNpc3RlbnQgc2luZ2xlLXN0ZXAgbG9n
aWMsIGFuZCBpdCBwcmV2ZW50cyB1cyBmcm9tIGJlaW5nIGFibGUgdG8gZmFpbAphbiBNTUlPIGlu
c3RydWN0aW9uIHdpdGggYSBzeW5jaHJvbm91cyBleGNlcHRpb24uCgpDbGVhbiB0aGlzIHVwIGJ5
IG9ubHkgYWR2YW5jaW5nIHRoZSBDUFUgc3RhdGUgKmFmdGVyKiB0aGUgZWZmZWN0cyBvZiB0aGUK
aW5zdHJ1Y3Rpb24gYXJlIGVtdWxhdGVkLgoKU2lnbmVkLW9mZi1ieTogTWFyayBSdXRsYW5kIDxt
YXJrLnJ1dGxhbmRAYXJtLmNvbT4KQ2M6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4KQ2M6IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAYXJtLmNvbT4KQ2M6
IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+CkNjOiBQZXRlciBNYXlkZWxsIDxw
ZXRlci5tYXlkZWxsQGxpbmFyby5vcmc+Ci0tLQogdmlydC9rdm0vYXJtL21taW8uYyB8IDExICsr
KysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9tbWlvLmMgYi92aXJ0L2t2bS9hcm0vbW1pby5j
CmluZGV4IGRhYzdjZWIxYTY3Ny4uMDg0NDNhMTVlNmJlIDEwMDY0NAotLS0gYS92aXJ0L2t2bS9h
cm0vbW1pby5jCisrKyBiL3ZpcnQva3ZtL2FybS9tbWlvLmMKQEAgLTExNyw2ICsxMTcsMTIgQEAg
aW50IGt2bV9oYW5kbGVfbW1pb19yZXR1cm4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qg
a3ZtX3J1biAqcnVuKQogCQl2Y3B1X3NldF9yZWcodmNwdSwgdmNwdS0+YXJjaC5tbWlvX2RlY29k
ZS5ydCwgZGF0YSk7CiAJfQogCisJLyoKKwkgKiBUaGUgTU1JTyBpbnN0cnVjdGlvbiBpcyBlbXVs
YXRlZCBhbmQgc2hvdWxkIG5vdCBiZSByZS1leGVjdXRlZAorCSAqIGluIHRoZSBndWVzdC4KKwkg
Ki8KKwlrdm1fc2tpcF9pbnN0cih2Y3B1LCBrdm1fdmNwdV90cmFwX2lsX2lzMzJiaXQodmNwdSkp
OworCiAJcmV0dXJuIDA7CiB9CiAKQEAgLTE0NCwxMSArMTUwLDYgQEAgc3RhdGljIGludCBkZWNv
ZGVfaHNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCAqaXNfd3JpdGUsIGludCAqbGVuKQog
CXZjcHUtPmFyY2gubW1pb19kZWNvZGUuc2lnbl9leHRlbmQgPSBzaWduX2V4dGVuZDsKIAl2Y3B1
LT5hcmNoLm1taW9fZGVjb2RlLnJ0ID0gcnQ7CiAKLQkvKgotCSAqIFRoZSBNTUlPIGluc3RydWN0
aW9uIGlzIGVtdWxhdGVkIGFuZCBzaG91bGQgbm90IGJlIHJlLWV4ZWN1dGVkCi0JICogaW4gdGhl
IGd1ZXN0LgotCSAqLwotCWt2bV9za2lwX2luc3RyKHZjcHUsIGt2bV92Y3B1X3RyYXBfaWxfaXMz
MmJpdCh2Y3B1KSk7CiAJcmV0dXJuIDA7CiB9CiAKLS0gCjIuMTEuMAoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
