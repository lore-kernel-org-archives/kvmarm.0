From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/28] arm64: KVM: Skip MMIO insn after emulation
Date: Wed, 19 Dec 2018 18:03:22 +0000
Message-ID: <20181219180349.242681-2-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 344C54A377
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C9GWfhyBj35Z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:04:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD42A4A341
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:12 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogTWFyayBSdXRsYW5kIDxtYXJrLnJ1dGxhbmRAYXJtLmNvbT4KCldoZW4gd2UgZW11bGF0
ZSBhbiBNTUlPIGluc3RydWN0aW9uLCB3ZSBhZHZhbmNlIHRoZSBDUFUgc3RhdGUgd2l0aGluCmRl
Y29kZV9oc3IoKSwgYmVmb3JlIGVtdWxhdGluZyB0aGUgaW5zdHJ1Y3Rpb24gZWZmZWN0cy4KCkhh
dmluZyB0aGlzIGxvZ2ljIGluIGRlY29kZV9oc3IoKSBpcyBvcGFxdWUsIGFuZCBhZHZhbmNpbmcg
dGhlIHN0YXRlCmJlZm9yZSBlbXVsYXRpb24gaXMgcHJvYmxlbWF0aWMuIEl0IGdldHMgaW4gdGhl
IHdheSBvZiBhcHBseWluZwpjb25zaXN0ZW50IHNpbmdsZS1zdGVwIGxvZ2ljLCBhbmQgaXQgcHJl
dmVudHMgdXMgZnJvbSBiZWluZyBhYmxlIHRvIGZhaWwKYW4gTU1JTyBpbnN0cnVjdGlvbiB3aXRo
IGEgc3luY2hyb25vdXMgZXhjZXB0aW9uLgoKQ2xlYW4gdGhpcyB1cCBieSBvbmx5IGFkdmFuY2lu
ZyB0aGUgQ1BVIHN0YXRlICphZnRlciogdGhlIGVmZmVjdHMgb2YgdGhlCmluc3RydWN0aW9uIGFy
ZSBlbXVsYXRlZC4KCkNjOiBQZXRlciBNYXlkZWxsIDxwZXRlci5tYXlkZWxsQGxpbmFyby5vcmc+
ClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+ClJldmll
d2VkLWJ5OiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGFybS5jb20+ClNpZ25l
ZC1vZmYtYnk6IE1hcmsgUnV0bGFuZCA8bWFyay5ydXRsYW5kQGFybS5jb20+ClNpZ25lZC1vZmYt
Ynk6IE1hcmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+Ci0tLQogdmlydC9rdm0vYXJt
L21taW8uYyB8IDExICsrKysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCsp
LCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9tbWlvLmMgYi92aXJ0
L2t2bS9hcm0vbW1pby5jCmluZGV4IGRhYzdjZWIxYTY3Ny4uMDg0NDNhMTVlNmJlIDEwMDY0NAot
LS0gYS92aXJ0L2t2bS9hcm0vbW1pby5jCisrKyBiL3ZpcnQva3ZtL2FybS9tbWlvLmMKQEAgLTEx
Nyw2ICsxMTcsMTIgQEAgaW50IGt2bV9oYW5kbGVfbW1pb19yZXR1cm4oc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3J1biAqcnVuKQogCQl2Y3B1X3NldF9yZWcodmNwdSwgdmNwdS0+
YXJjaC5tbWlvX2RlY29kZS5ydCwgZGF0YSk7CiAJfQogCisJLyoKKwkgKiBUaGUgTU1JTyBpbnN0
cnVjdGlvbiBpcyBlbXVsYXRlZCBhbmQgc2hvdWxkIG5vdCBiZSByZS1leGVjdXRlZAorCSAqIGlu
IHRoZSBndWVzdC4KKwkgKi8KKwlrdm1fc2tpcF9pbnN0cih2Y3B1LCBrdm1fdmNwdV90cmFwX2ls
X2lzMzJiaXQodmNwdSkpOworCiAJcmV0dXJuIDA7CiB9CiAKQEAgLTE0NCwxMSArMTUwLDYgQEAg
c3RhdGljIGludCBkZWNvZGVfaHNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCAqaXNfd3Jp
dGUsIGludCAqbGVuKQogCXZjcHUtPmFyY2gubW1pb19kZWNvZGUuc2lnbl9leHRlbmQgPSBzaWdu
X2V4dGVuZDsKIAl2Y3B1LT5hcmNoLm1taW9fZGVjb2RlLnJ0ID0gcnQ7CiAKLQkvKgotCSAqIFRo
ZSBNTUlPIGluc3RydWN0aW9uIGlzIGVtdWxhdGVkIGFuZCBzaG91bGQgbm90IGJlIHJlLWV4ZWN1
dGVkCi0JICogaW4gdGhlIGd1ZXN0LgotCSAqLwotCWt2bV9za2lwX2luc3RyKHZjcHUsIGt2bV92
Y3B1X3RyYXBfaWxfaXMzMmJpdCh2Y3B1KSk7CiAJcmV0dXJuIDA7CiB9CiAKLS0gCjIuMTkuMgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
