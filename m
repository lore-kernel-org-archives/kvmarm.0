Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FC5C43217
	for <kvmarm@archiver.kernel.org>; Thu, 16 Dec 2021 12:31:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1E74B26C;
	Thu, 16 Dec 2021 07:31:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19CblXKmhy1U; Thu, 16 Dec 2021 07:31:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88B234B255;
	Thu, 16 Dec 2021 07:31:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 956684B222
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1lIKKGAaAYgY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Dec 2021 07:31:41 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 943374B1D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Dec 2021 07:31:41 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id AB77361D79;
 Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C52EC36AE5;
 Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1639657900;
 bh=4rSkbQHvQNccr16rISKUtR7jY5pFieW8AWzfrNGTbuQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eGRNOAC7Xn3HzuELEenJ8leZ7alg6aXJK79jHjnyFAQElk80WahKlg2uASA+YCXVj
 zK1uuqVODsjdaGEEg8/5qKAGj7SlCslrwQADGPPtDhgOxibicd2Qt9McGwhqeCB/4v
 Xibt9BVS4Zaz4u0J3WIsgqxJ7cxk1v3afYgANmi2ioSEZZqC5CNJhUliAxM60QkV2O
 ppJ1bCfetwsGnTcu0CfTLWzbIEGFzDFhiaAaEirS5s4lc3yFHD9bswWbHR7//yitdF
 awo5jHJ3lWnT0F5IBNdHMWZ6PY4UEGeDym/9AoKIWedSZub3mRzkkp7c7svpKDuNxm
 7VattwRsmAHSg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mxpv8-00CWIB-6t; Thu, 16 Dec 2021 12:31:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [PATCH 1/5] KVM: selftests: Fix vm_compute_max_gfn on !x86
Date: Thu, 16 Dec 2021 12:31:31 +0000
Message-Id: <20211216123135.754114-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211216123135.754114-1-maz@kernel.org>
References: <20211216123135.754114-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Q29tcGlsaW5nIHRoZSBzZWxmdGVzdHRzIG9uIGFybTY0IGxlYWRzIHRvIHRoaXM6CgpnY2MgLVdh
bGwgLVdzdHJpY3QtcHJvdG90eXBlcyAtV3VuaW5pdGlhbGl6ZWQgLU8yIC1nIC1zdGQ9Z251OTkg
LWZuby1zdGFjay1wcm90ZWN0b3IgLWZuby1QSUUgLUkuLi8uLi8uLi8uLi90b29scy9pbmNsdWRl
IC1JLi4vLi4vLi4vLi4vdG9vbHMvYXJjaC9hcm02NC9pbmNsdWRlIC1JLi4vLi4vLi4vLi4vdXNy
L2luY2x1ZGUvIC1JaW5jbHVkZSAtSWxpYiAtSWluY2x1ZGUvYWFyY2g2NCAtSS4uICAgLWMgbGli
L2t2bV91dGlsLmMgLW8gL2hvbWUvbWF6L2FybS1wbGF0Zm9ybXMvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMva3ZtL2xpYi9rdm1fdXRpbC5vCkluIGZpbGUgaW5jbHVkZWQgZnJvbSBsaWIva3ZtX3V0
aWwuYzoxMDoKaW5jbHVkZS9rdm1fdXRpbC5oOiBJbiBmdW5jdGlvbiDigJh2bV9jb21wdXRlX21h
eF9nZm7igJk6CmluY2x1ZGUva3ZtX3V0aWwuaDo3OToyMTogZXJyb3I6IGludmFsaWQgdXNlIG9m
IHVuZGVmaW5lZCB0eXBlIOKAmHN0cnVjdCBrdm1fdm3igJkKICAgNzkgfCAgcmV0dXJuICgoMVVM
TCA8PCB2bS0+cGFfYml0cykgPj4gdm0tPnBhZ2Vfc2hpZnQpIC0gMTsKICAgICAgfCAgICAgICAg
ICAgICAgICAgICAgIF5+CmluY2x1ZGUva3ZtX3V0aWwuaDo3OTozNzogZXJyb3I6IGludmFsaWQg
dXNlIG9mIHVuZGVmaW5lZCB0eXBlIOKAmHN0cnVjdCBrdm1fdm3igJkKICAgNzkgfCAgcmV0dXJu
ICgoMVVMTCA8PCB2bS0+cGFfYml0cykgPj4gdm0tPnBhZ2Vfc2hpZnQpIC0gMTsKICAgICAgfCAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefgpbLi4uXQoKVGhpcyBpcyBhbGwg
YmVjYXVzZSBzdHJ1Y3Qga3ZtX3ZtIGlzIG5vdCBkZWZpbmVkIHlldCAob25seSBkZWNsYXJlZCku
ClNpZGVzdGVwIHRoZSB3aG9sZSBpc3N1ZSBieSBtYWtpbmcgdm1fY29tcHV0ZV9tYXhfZ2ZuKCkg
YSBtYWNyby4KCkZpeGVzOiBjOGNjNDNjMWVhZTIgKCJzZWxmdGVzdHM6IEtWTTogYXZvaWQgZmFp
bHVyZXMgZHVlIHRvIHJlc2VydmVkIEh5cGVyVHJhbnNwb3J0IHJlZ2lvbiIpClNpZ25lZC1vZmYt
Ynk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Ci0tLQogdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMva3ZtL2luY2x1ZGUva3ZtX3V0aWwuaCB8IDkgKysrKystLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2t2bS9pbmNsdWRlL2t2bV91dGlsLmggYi90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9rdm0vaW5jbHVkZS9rdm1fdXRpbC5oCmluZGV4IGRhMmI3MDJkYTcxYS4uYzc0MjQx
ZGRmOGIxIDEwMDY0NAotLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vaW5jbHVkZS9r
dm1fdXRpbC5oCisrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9pbmNsdWRlL2t2bV91
dGlsLmgKQEAgLTc0LDEwICs3NCwxMSBAQCBlbnVtIHZtX2d1ZXN0X21vZGUgewogI2lmIGRlZmlu
ZWQoX194ODZfNjRfXykKIHVuc2lnbmVkIGxvbmcgdm1fY29tcHV0ZV9tYXhfZ2ZuKHN0cnVjdCBr
dm1fdm0gKnZtKTsKICNlbHNlCi1zdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgdm1fY29tcHV0
ZV9tYXhfZ2ZuKHN0cnVjdCBrdm1fdm0gKnZtKQotewotCXJldHVybiAoKDFVTEwgPDwgdm0tPnBh
X2JpdHMpID4+IHZtLT5wYWdlX3NoaWZ0KSAtIDE7Ci19CisjZGVmaW5lIHZtX2NvbXB1dGVfbWF4
X2dmbih2bSkJCQkJCQlcCisJKHsJCQkJCQkJCVwKKwkJc3RydWN0IGt2bV92bSAqX192bSA9IHZt
OwkJCQlcCisJCSgoMVVMTCA8PCBfX3ZtLT5wYV9iaXRzKSA+PiBfX3ZtLT5wYWdlX3NoaWZ0KSAt
IDE7CVwKKwl9KQogI2VuZGlmCiAKICNkZWZpbmUgTUlOX1BBR0VfU0laRQkJKDFVIDw8IE1JTl9Q
QUdFX1NISUZUKQotLSAKMi4zMC4yCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
