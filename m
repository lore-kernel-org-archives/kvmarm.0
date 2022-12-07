Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71642C63705
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 21:48:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7E5E4B838;
	Wed,  7 Dec 2022 16:48:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pqIo46cGw8TA; Wed,  7 Dec 2022 16:48:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 307134B839;
	Wed,  7 Dec 2022 16:48:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A99F44B837
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 16:48:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rbT2-c3NRh9x for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 16:48:26 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7BB34B835
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 16:48:25 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670449704;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OmUuSlDwuptIt2dazcrMy1PSKnvzv2Vi/qLEdCvsz/Y=;
 b=r9OVVkwqCW2+ZPso5Mwh5U1VnBcaT5WsdLENVqzghNOT3staCANlBlpxlDD4ykT/tlhLWu
 aE9D5Y1Hts/dAqCvu9onYYdd8eq7FFPmU3GxGxMEhzyhvZRKyGGTsrCch80Jnhdu3LaOuN
 9UpIlbMneOGhUV9yZri4B4u7RnWiMJI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Andrew Jones <andrew.jones@linux.dev>,
 Sean Christopherson <seanjc@google.com>,
 Ricardo Koller <ricarkol@google.com>
Subject: [PATCH 1/4] KVM: selftests: Fix build due to ucall_uninit() removal
Date: Wed,  7 Dec 2022 21:48:05 +0000
Message-Id: <20221207214809.489070-2-oliver.upton@linux.dev>
In-Reply-To: <20221207214809.489070-1-oliver.upton@linux.dev>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
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
X3VmZmQsIGRhdGFfdWZmZCk7CiAKLS0gCjIuMzkuMC5yYzAuMjY3LmdjYjUyYmEwNmU3LWdvb2cK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
