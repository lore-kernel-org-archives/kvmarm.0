Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802CCC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 01:53:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B2394B9D1;
	Thu,  8 Dec 2022 20:53:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dbbzc9x1XUNu; Thu,  8 Dec 2022 20:53:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C73354B9DE;
	Thu,  8 Dec 2022 20:53:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 546CE4B9E3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:53:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j34HO7lyrhWS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 20:53:29 -0500 (EST)
Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C18874B9DE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:53:28 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Ricardo Koller <ricarkol@google.com>
Subject: [PATCH v2 1/7] KVM: selftests: Fix build due to ucall_uninit() removal
Date: Fri,  9 Dec 2022 01:53:00 +0000
Message-Id: <20221209015307.1781352-2-oliver.upton@linux.dev>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, linux-kselftest@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

RnJvbTogTWFyayBCcm93biA8YnJvb25pZUBrZXJuZWwub3JnPgoKVG9kYXkncyAtbmV4dCBmYWls
cyB0byBidWlsZCBvbiBhcm02NCBkdWUgdG86CgpJbiBmaWxlIGluY2x1ZGVkIGZyb20gaW5jbHVk
ZS9rdm1fdXRpbC5oOjExLAogICAgICAgICAgICAgICAgIGZyb20gYWFyY2g2NC9wYWdlX2ZhdWx0
X3Rlc3QuYzoxNToKaW5jbHVkZS91Y2FsbF9jb21tb24uaDozNjo0Nzogbm90ZTogZXhwZWN0ZWQg
4oCYdm1fcGFkZHJfdOKAmSB7YWthIOKAmGxvbmcgdW5zaWduZWQgaW504oCZfSBidXQgYXJndW1l
bnQgaXMgb2YgdHlwZSDigJh2b2lkICrigJkKICAgMzYgfCB2b2lkIHVjYWxsX2luaXQoc3RydWN0
IGt2bV92bSAqdm0sIHZtX3BhZGRyX3QgbW1pb19ncGEpOwogICAgICB8ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfn5+fn5+fn5+fn5efn5+fn5+fgphYXJjaDY0L3BhZ2VfZmF1
bHRfdGVzdC5jOjcyNToyOiB3YXJuaW5nOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlv
biDigJh1Y2FsbF91bmluaXTigJk7IGRpZCB5b3UgbWVhbiDigJh1Y2FsbF9pbml04oCZPyBbLVdp
bXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0KICA3MjUgfCAgdWNhbGxfdW5pbml0KHZtKTsK
ICAgICAgfCAgXn5+fn5+fn5+fn5+CiAgICAgIHwgIHVjYWxsX2luaXQKCndoaWNoIGlzIGNhdXNl
ZCBieSBjb21taXQKCmludGVyYWN0aW5nIHBvb3JseSB3aXRoIGNvbW1pdAoKICAgMjhhNjU1Njdh
Y2I1ICgiS1ZNOiBzZWxmdGVzdHM6IERyb3Agbm93LXVubmVjZXNzYXJ5IHVjYWxsX3VuaW5pdCgp
IikKCkFzIGlzIGRvbmUgZm9yIG90aGVyIHVjYWxsX3VuaW5pdCgpIHVzZXJzIHJlbW92ZSB0aGUg
Y2FsbCBpbiB0aGUgbmV3bHkgYWRkZWQKcGFnZV9mYXVsdF90ZXN0LmMuCgpGaXhlczogMjhhNjU1
NjdhY2I1ICgiS1ZNOiBzZWxmdGVzdHM6IERyb3Agbm93LXVubmVjZXNzYXJ5IHVjYWxsX3VuaW5p
dCgpIikKRml4ZXM6IDM1YzU4MTAxNTcxMiAoIktWTTogc2VsZnRlc3RzOiBhYXJjaDY0OiBBZGQg
YWFyY2g2NC9wYWdlX2ZhdWx0X3Rlc3QiKQpTaWduZWQtb2ZmLWJ5OiBNYXJrIEJyb3duIDxicm9v
bmllQGtlcm5lbC5vcmc+CkNjOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNv
bT4KQ2M6IFJpY2FyZG8gS29sbGVyIDxyaWNhcmtvbEBnb29nbGUuY29tPgpDYzogTWFyYyBaeW5n
aWVyIDxtYXpAa2VybmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogT2xpdmVyIFVwdG9uIDxvbGl2ZXIu
dXB0b25AbGludXguZGV2PgotLS0KIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0
L3BhZ2VfZmF1bHRfdGVzdC5jIHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQoK
ZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1
bHRfdGVzdC5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FhcmNoNjQvcGFnZV9mYXVs
dF90ZXN0LmMKaW5kZXggMGNkYTcwYmVmNWQ1Li45MmQzYTkxMTUzYjYgMTAwNjQ0Ci0tLSBhL3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdC5jCisrKyBi
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3BhZ2VfZmF1bHRfdGVzdC5jCkBA
IC03MjIsNyArNzIyLDYgQEAgc3RhdGljIHZvaWQgcnVuX3Rlc3QoZW51bSB2bV9ndWVzdF9tb2Rl
IG1vZGUsIHZvaWQgKmFyZykKIAogCXZjcHVfcnVuX2xvb3Aodm0sIHZjcHUsIHRlc3QpOwogCi0J
dWNhbGxfdW5pbml0KHZtKTsKIAlrdm1fdm1fZnJlZSh2bSk7CiAJZnJlZV91ZmZkKHRlc3QsIHB0
X3VmZmQsIGRhdGFfdWZmZCk7CiAKLS0gCjIuMzkuMC5yYzEuMjU2Lmc1NGZkODM1MGJkLWdvb2cK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
